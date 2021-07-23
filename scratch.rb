<<-DOC
given
protected
def a
  @a
end

will self.a = 2
== 
@a = 2
?
DOC


class A
  attr_reader :b
  def initialize
    @a = 1
    @b = @a
  end

  def change_a
    a
  end

  private

  def a
    a = new
    a.instance_variable_set(:a, 3)
  end
end