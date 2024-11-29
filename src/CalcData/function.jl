using LinearAlgebra

function mean_gram_schmidt(vectors::Matrix{T}) where T
    n, m = size(vectors)
    orthogonal_vectors = zeros(T, n, m)

    for i in 1:m
        # Copy the current vector
        v = vectors[:, i]
        
        # Orthogonalize against previously computed vectors
        for j in 1:i-1
            v -= (dot(orthogonal_vectors[:, j], v) / dot(orthogonal_vectors[:, j], orthogonal_vectors[:, j])) * orthogonal_vectors[:, j]
        end

        # Center to mean-zero for all except the last vector
        if i != m
            v .-= mean(v)
        end

        # Normalize the vector
        orthogonal_vectors[:, i] = v / norm(v)
    end

    return orthogonal_vectors
end


function shrink_rows(matrix::AbstractMatrix)
    # Find rows that contain only zeros
    nonzero_rows = findall(row -> any(!iszero, row), eachrow(matrix))

    # Create the reduced matrix containing only the nonzero rows
    reduced_matrix = matrix[nonzero_rows, :]

    # Vector of deleted rows
    all_rows = collect(1:size(matrix, 1))
    deleted_rows = setdiff(all_rows, nonzero_rows)

    return reduced_matrix, deleted_rows
end

function restore_rows(reduced_matrix::AbstractMatrix, deleted_rows::Vector{Int}, original_size::Tuple{Int, Int})
    # Create an empty matrix of the original size
    restored_matrix = zeros(eltype(reduced_matrix), original_size...)

    # Determine rows that were kept
    kept_rows = setdiff(1:original_size[1], deleted_rows)

    # Insert the reduced matrix rows back into their original positions
    restored_matrix[kept_rows, :] .= reduced_matrix

    return restored_matrix
end

function shrink_columns(matrix::AbstractMatrix)
    # Find columns that contain only zeros
    nonzero_columns = findall(col -> any(!iszero, col), eachcol(matrix))

    # Create the reduced matrix containing only the nonzero columns
    reduced_matrix = matrix[:, nonzero_columns]

    # Vector of deleted columns
    all_columns = collect(1:size(matrix, 2))
    deleted_columns = setdiff(all_columns, nonzero_columns)

    return reduced_matrix, deleted_columns
end

function restore_columns(reduced_matrix::AbstractMatrix, deleted_columns::Vector{Int}, original_size::Tuple{Int, Int})
    # Create an empty matrix of the original size
    restored_matrix = zeros(eltype(reduced_matrix), original_size...)

    # Determine columns that were kept
    kept_columns = setdiff(1:original_size[2], deleted_columns)

    # Insert the reduced matrix columns back into their original positions
    restored_matrix[:, kept_columns] .= reduced_matrix

    return restored_matrix
end