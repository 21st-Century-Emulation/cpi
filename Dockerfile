FROM rust:1.51 as builder

RUN USER=root cargo new --bin cpi
WORKDIR ./cpi
COPY ./Cargo.lock ./Cargo.toml ./
RUN cargo build --release
RUN rm src/*.rs
COPY ./src ./src
RUN rm ./target/release/deps/cpi*
RUN cargo build --release

FROM ubuntu:20.04

RUN apt update && apt install -y libssl-dev

COPY --from=builder /cpi/target/release/cpi .
EXPOSE 8080
ENTRYPOINT ["./cpi"]