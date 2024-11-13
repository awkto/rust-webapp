# Stage 1: Build the Rust application
FROM rust:latest AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy the Cargo manifest and source code to the container
#COPY Cargo.toml Cargo.lock ./
COPY Cargo.toml ./
COPY src ./src

# Build the application in release mode
RUN cargo build --release

# Stage 2: Create a minimal runtime image
FROM debian:bullseye-slim

# Install necessary dependencies
RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*

# Set the working directory inside the container
WORKDIR /app

# Copy the compiled binary from the builder stage
COPY --from=builder /app/target/release/rust-web-app /app/rust-web-app

# Expose the application port
EXPOSE 8080

# Set the default command to run the application
CMD ["/app/rust-web-app"]
