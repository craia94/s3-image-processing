# User A
output "user_a_secret_key" {
  value = aws_iam_access_key.user_a.encrypted_secret
}

output "user_a_access_key" {
  value = aws_iam_access_key.user_a.id
}

# User B
output "user_b_secret_key" {
  value = aws_iam_access_key.user_b.encrypted_secret
}

output "user_b_access_key" {
  value = aws_iam_access_key.user_b.id
}