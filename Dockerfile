# Use the official Go Alpine base image for a lightweight build
FROM golang:1.14.0-alpine AS builder

# Install dependencies required for building Go apps
RUN apk add --no-cache gcc musl-dev

# Set the working directory inside the container
WORKDIR /app

# Copy only go.mod and go.sum to leverage Docker caching for dependencies
COPY go.mod ./
RUN go mod download

# Copy the entire source code
COPY . .

# Build the Go application
RUN go clean --modcache && go build -o main .

# Create a minimal runtime image
FROM alpine:latest

# Set working directory in the runtime container
WORKDIR /app

# Copy the compiled Go binary from the builder stage
COPY --from=builder /app/main .

# Expose a port if the app serves HTTP (optional)
# EXPOSE 8080

# Set the command to run the application
CMD ["./main"]
