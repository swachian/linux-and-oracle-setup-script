"1000".upto("9999") do |abcd|
  dcba=abcd.reverse
  puts abcd if abcd.to_i*9 == dcba.to_i
end
