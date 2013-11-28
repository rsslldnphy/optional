require 'spec_helper'

describe Option do
  describe '#map' do
    it 'maps `Some[x]` to `Some[f(x)]`' do
      result = Some["I'm a cat!"].map(&:upcase)
      expect(result).to eq Some["I'M A CAT!"]
    end

    it 'maps `None` to `None`' do
      result = None.map(&:upcase)
      expect(result).to eq None
    end
  end

  describe '#collect' do
    it 'maps `Some[x]` to `Some[f(x)]`' do
      result = Some["I'm a cat!"].collect(&:upcase)
      expect(result).to eq Some["I'M A CAT!"]
    end

    it 'maps `None` to `None`' do
      result = None.collect(&:upcase)
      expect(result).to eq None
    end
  end

  describe '#collect_concat' do
    it 'maps `Some[x] to `Some[f(x)]`' do
      result = Some["I'm a cat!"].collect_concat(&:upcase)
      expect(result).to eq Some["I'M A CAT!"]
    end

    it 'maps `Some[Some[x]] to `Some[f(x)]`' do
      result = Some[Some["I'm a cat!"]].collect_concat { |x| x.map(&:upcase) }
      expect(result).to eq Some["I'M A CAT!"]
    end

    it 'maps `None` to `None`' do
      result = None.collect_concat(&:upcase)
      expect(result).to eq None
    end

    it 'maps `Some[None]` to `None`' do
      result = Some[None].collect_concat { |x| x.map(&:upcase) }
      expect(result).to eq None
    end

  end

  describe '#flat_map' do
    it 'maps `Some[x] to `Some[f(x)]`' do
      result = Some["I'm a cat!"].flat_map(&:upcase)
      expect(result).to eq Some["I'M A CAT!"]
    end

    it 'maps `Some[Some[x]] to `Some[f(x)]`' do
      result = Some[Some["I'm a cat!"]].flat_map { |x| x.map(&:upcase) }
      expect(result).to eq Some["I'M A CAT!"]
    end

    it 'maps `None` to `None`' do
      result = None.flat_map(&:upcase)
      expect(result).to eq None
    end

    it 'maps `Some[None]` to `None`' do
      result = Some[None].flat_map { |x| x.map(&:upcase) }
      expect(result).to eq None
    end
  end

  describe '#detect' do
    it 'returns a `Some` if the predicate returns true' do
      result = Some[5].detect { |x| x > 4 }
      expect(result).to eq Some[5]
    end

    it 'returns a `None` if the predicate returns false' do
      result = Some[5].detect { |x| x < 4 }
      expect(result).to eq None
    end

    it 'returns a `None` if the original option is a `None`' do
      result = None.detect { |x| true }
      expect(result).to eq None
    end
  end

  describe '#find' do
    it 'returns a `Some` if the predicate returns true' do
      result = Some[5].find { |x| x > 4 }
      expect(result).to eq Some[5]
    end

    it 'returns a `None` if the predicate returns false' do
      result = Some[5].find { |x| x < 4 }
      expect(result).to eq None
    end

    it 'returns a `None` if the original option is a `None`' do
      result = None.find { |x| true }
      expect(result).to eq None
    end
  end

  describe '#select' do
    it 'returns a `Some` if the predicate returns true' do
      result = Some[5].select { |x| x > 4 }
      expect(result).to eq Some[5]
    end

    it 'returns a `None` if the predicate returns false' do
      result = Some[5].select { |x| x < 4 }
      expect(result).to eq None
    end

    it 'returns a `None` if the original option is a `None`' do
      result = None.select { |x| true }
      expect(result).to eq None
    end
  end

  describe '#find_all' do
    it 'returns a `Some` if the predicate returns true' do
      result = Some[5].find_all { |x| x > 4 }
      expect(result).to eq Some[5]
    end

    it 'returns a `None` if the predicate returns false' do
      result = Some[5].find_all { |x| x < 4 }
      expect(result).to eq None
    end

    it 'returns a `None` if the original option is a `None`' do
      result = None.find_all { |x| true }
      expect(result).to eq None
    end
  end

  describe '#grep' do
    it 'returns a `Some` if the value matches' do
      result = Some['cats cats cats!'].grep(/cat/)
      expect(result).to eq Some['cats cats cats!']
    end

    it 'returns a `None` if the value does not match' do
      result = Some['cats cats cats!'].grep(/dog/)
      expect(result).to eq None
    end

    it 'returns a `None` if the original option is a `None`' do
      result = None.grep(/cat/)
      expect(result).to eq None
    end
  end

  describe '#reject' do
    it 'returns a `Some` if the value does not matches' do
      result = Some['cats cats cats!'].reject(&:empty?)
      expect(result).to eq Some['cats cats cats!']
    end

    it 'returns a `None` if the value matches' do
      result = Some['cats cats cats!'].reject { |x| x.length > 3 }
      expect(result).to eq None
    end

    it 'returns a `None` if the original option is a `None`' do
      result = None.reject(&:empty?)
      expect(result).to eq None
    end
  end

  describe '#reduce' do
    it 'given an accumulator `acc`, it reduces `Some[x]` to `Some[f acc x]`' do
      result = Some[5].reduce(10, :+)
      expect(result).to eq 15
    end

    it 'given no accumulator, it reduces `Some[x]` to `x`' do
      result = Some[5].reduce(:+)
      expect(result).to eq 5
    end

    it 'given an accumulator `acc`, it reduces `None` to `acc`' do
      result = None.reduce(10, :+)
      expect(result).to eq 10
    end

    it 'given no accumulator, reducing `None` raises an error' do
      expect { None.reduce(:+) }.to raise_error ValueOfNoneError
    end

  end

  describe '#inject' do
    it 'given an accumulator `acc`, it reduces `Some[x]` to `Some[f acc x]`' do
      result = Some[5].inject(10, :+)
      expect(result).to eq 15
    end

    it 'given no accumulator, it reduces `Some[x]` to `x`' do
      result = Some[5].inject(:+)
      expect(result).to eq 5
    end

    it 'given an accumulator `acc`, it reduces `None` to `acc`' do
      result = None.inject(10, :+)
      expect(result).to eq 10
    end

    it 'given no accumulator, reducing `None` raises an error' do
      expect { None.inject(:+) }.to raise_error ValueOfNoneError
    end

  end

  describe '#flatten' do
    it 'flattens a `Some` to a `Some`' do
      result = Some[:foo].flatten
      expect(result).to eq Some[:foo]
    end

    it 'flattens a `None` to a `None`' do
      result = None.flatten
      expect(result).to eq None
    end

    it 'flattens a `Some` containing nested `Some`s and `None`s to a `Some` of their values' do
      result = Some[Some[1], None, Some[Some[2, 3]], None, None, [4]].flatten
      expect(result).to eq Some[1, 2, 3, 4]
    end

    it 'flattens an array of nested `Some`s and `None`s to an array' do
      result = [Some[1], None, Some[Some[2, 3]], None, None, [4]].flatten
      expect(result).to eq [1, 2, 3, 4]
    end
  end

  describe '#map_through' do
    it 'maps `Some[x]` to `Some[f(g(x))]`' do
      result = Some[:cat].map_through(:to_s, :upcase, :to_sym)
      expect(result).to eq Some[:CAT]
    end
    it 'maps `None` to `None`' do
      result = None.map_through(:to_s, :upcase, :to_sym)
      expect(result).to eq None
    end
  end

  describe '#juxt' do
    it 'calls each of the passed functions on its value, returning an `Some[Array]` of the results' do
      result = Some[0].juxt(:zero?, :pred, :succ)
      expect(result).to eq Some[true, -1, 1]
    end
    it 'maps to a `None` when called on a `None`' do
      result = None.juxt(:zero?, :pred, :succ)
      expect(result).to eq None
    end
  end
end
