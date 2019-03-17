defmodule Todo.Macros do
  defmacro iff(left, right, do: expression, else: else_expression) do
    quote do
      if unquote(left) === unquote(right) do
        unquote(expression)
      else
        unquote(else_expression)
      end
    end
  end
end
