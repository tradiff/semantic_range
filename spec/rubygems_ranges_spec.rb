require 'spec_helper'

describe SemanticRange do
  it 'range for rubygems/packagist' do
    [
      ['1.0.0 - 2.0.0', '1.2.3'],
      ['^1.2.3+build', '1.2.3'],
      ['^1.2.3+build', '1.3.0'],
      ['1.2.3-pre+asdf - 2.4.3-pre+asdf', '1.2.3'],
      ['1.2.3pre+asdf - 2.4.3-pre+asdf', '1.2.3', true],
      ['1.2.3-pre+asdf - 2.4.3pre+asdf', '1.2.3', true],
      ['1.2.3pre+asdf - 2.4.3pre+asdf', '1.2.3', true],
      ['1.2.3-pre+asdf - 2.4.3-pre+asdf', '1.2.3-pre.2'],
      ['1.2.3-pre+asdf - 2.4.3-pre+asdf', '2.4.3-alpha'],
      ['1.2.3+asdf - 2.4.3+asdf', '1.2.3'],
      ['1.0.0', '1.0.0'],
      ['>=*', '0.2.4'],
      ['', '1.0.0'],
      ['*', '1.2.3'],
      ['*', 'v1.2.3', true],
      ['>=1.0.0', '1.0.0'],
      ['>=1.0.0', '1.0.1'],
      ['>=1.0.0', '1.1.0'],
      ['>1.0.0', '1.0.1'],
      ['>1.0.0', '1.1.0'],
      ['<=2.0.0', '2.0.0'],
      ['<=2.0.0', '1.9999.9999'],
      ['<=2.0.0', '0.2.9'],
      ['<2.0.0', '1.9999.9999'],
      ['<2.0.0', '0.2.9'],
      ['>= 1.0.0', '1.0.0'],
      ['>=  1.0.0', '1.0.1'],
      ['>=   1.0.0', '1.1.0'],
      ['> 1.0.0', '1.0.1'],
      ['>  1.0.0', '1.1.0'],
      ['<=   2.0.0', '2.0.0'],
      ['<= 2.0.0', '1.9999.9999'],
      ['<=  2.0.0', '0.2.9'],
      ['<    2.0.0', '1.9999.9999'],
      ["<\t2.0.0", '0.2.9'],
      ['>=0.1.97', 'v0.1.97', true],
      ['>=0.1.97', '0.1.97'],
      ['0.1.20 || 1.2.4', '1.2.4'],
      ['>=0.2.3 || <0.0.1', '0.0.0'],
      ['>=0.2.3 || <0.0.1', '0.2.3'],
      ['>=0.2.3 || <0.0.1', '0.2.4'],
      ['||', '1.3.4'],
      ['2.x.x', '2.1.3'],
      ['1.2.x', '1.2.3'],
      ['1.2.x || 2.x', '2.1.3'],
      ['1.2.x || 2.x', '1.2.3'],
      ['x', '1.2.3'],
      ['2.*.*', '2.1.3'],
      ['1.2.*', '1.2.3'],
      ['1.2.* || 2.*', '2.1.3'],
      ['1.2.* || 2.*', '1.2.3'],
      ['*', '1.2.3'],
      ['2', '2.1.2'],
      ['2.3', '2.3.1'],
      ['~2.4', '2.4.0'], # >=2.4.0 <3.0.0
      ['~2.4', '2.9.0'], # >=2.4.0 <3.0.0
      ['~2.4', '2.4.5'],
      ['~2.4', '2.9.5'],
      ['~> 0.0.1', '0.0.1'], # >=0.0.1 <0.1.0,
      ['~> 0.0.1', '0.0.2'], # >=0.0.1 <0.1.0,
      ['~>3.2.1', '3.2.2'], # >=3.2.1 <3.3.0,
      ['~1', '1.2.3'], # >=1.0.0 <2.0.0
      ['~>1', '1.2.3'],
      ['~> 1', '1.2.3'],
      ['~1.0', '1.0.2'], # >=1.0.0 <1.1.0,
      ['~ 1.0', '1.0.2'],
      ['~ 1.0.3', '1.0.12'],
      ['>=1', '1.0.0'],
      ['>= 1', '1.0.0'],
      ['<1.2', '1.1.1'],
      ['< 1.2', '1.1.1'],
      ['~v0.5.4-pre', '0.5.5'],
      ['~v0.5.4-pre', '0.5.4'],
      ['=0.7.x', '0.7.2'],
      ['<=0.7.x', '0.7.2'],
      ['>=0.7.x', '0.7.2'],
      ['<=0.7.x', '0.6.2'],
      ['~1.2.1 >=1.2.3', '1.2.3'],
      ['~1.2.1 =1.2.3', '1.2.3'],
      ['~1.2.1 1.2.3', '1.2.3'],
      ['~1.2.1 >=1.2.3 1.2.3', '1.2.3'],
      ['~1.2.1 1.2.3 >=1.2.3', '1.2.3'],
      ['~1.2.1 1.2.3', '1.2.3'],
      ['>=1.2.1 1.2.3', '1.2.3'],
      ['1.2.3 >=1.2.1', '1.2.3'],
      ['>=1.2.3 >=1.2.1', '1.2.3'],
      ['>=1.2.1 >=1.2.3', '1.2.3'],
      ['>=1.2', '1.2.8'],
      ['^1.2.3', '1.8.1'],
      ['^0.1.2', '0.1.2'],
      ['^0.1', '0.1.2'],
      ['^1.2', '1.4.2'],
      ['^1.2 ^1', '1.4.2'],
      ['^1.2.3-alpha', '1.2.3-pre'],
      ['^1.2.0-alpha', '1.2.0-pre'],
      ['^0.0.1-alpha', '0.0.1-beta']
    ].each do |tuple|
      range = tuple[0]
      version = tuple[1]
      loose = tuple[2]
      expect(SemanticRange.satisfies?(version, range, loose, 'Rubygems')).to eq(true), "#{tuple}"
      expect(SemanticRange.satisfies?(version, range, loose, 'Packagist')).to eq(true), "#{tuple}"
    end
  end

  it 'negative range for rubygems/packagist' do
    [
      ['1.0.0 - 2.0.0', '2.2.3'],
      ['1.2.3+asdf - 2.4.3+asdf', '1.2.3-pre.2'],
      ['1.2.3+asdf - 2.4.3+asdf', '2.4.3-alpha'],
      ['^1.2.3+build', '2.0.0'],
      ['^1.2.3+build', '1.2.0'],
      ['^1.2.3', '1.2.3-pre'],
      ['^1.2', '1.2.0-pre'],
      ['>1.2', '1.3.0-beta'],
      ['<=1.2.3', '1.2.3-beta'],
      ['^1.2.3', '1.2.3-beta'],
      ['=0.7.x', '0.7.0-asdf'],
      ['>=0.7.x', '0.7.0-asdf'],
      ['1', '1.0.0beta', true],
      ['<1', '1.0.0beta', true],
      ['< 1', '1.0.0beta', true],
      ['1.0.0', '1.0.1'],
      ['>=1.0.0', '0.0.0'],
      ['>=1.0.0', '0.0.1'],
      ['>=1.0.0', '0.1.0'],
      ['>1.0.0', '0.0.1'],
      ['>1.0.0', '0.1.0'],
      ['<=2.0.0', '3.0.0'],
      ['<=2.0.0', '2.9999.9999'],
      ['<=2.0.0', '2.2.9'],
      ['<2.0.0', '2.9999.9999'],
      ['<2.0.0', '2.2.9'],
      ['>=0.1.97', 'v0.1.93', true],
      ['>=0.1.97', '0.1.93'],
      ['0.1.20 || 1.2.4', '1.2.3'],
      ['>=0.2.3 || <0.0.1', '0.0.3'],
      ['>=0.2.3 || <0.0.1', '0.2.2'],
      ['2.x.x', '1.1.3'],
      ['2.x.x', '3.1.3'],
      ['1.2.x', '1.3.3'],
      ['1.2.x || 2.x', '3.1.3'],
      ['1.2.x || 2.x', '1.1.3'],
      ['2.*.*', '1.1.3'],
      ['2.*.*', '3.1.3'],
      ['1.2.*', '1.3.3'],
      ['1.2.* || 2.*', '3.1.3'],
      ['1.2.* || 2.*', '1.1.3'],
      ['2', '1.1.2'],
      ['2.3', '2.4.1'],
      ['~2.4', '3.0.0'], # >=2.4.0 <2.5.0
      ['~2.4', '2.3.9'],
      ['~>3.2.1', '3.3.2'], # >=3.2.1 <3.3.0
      ['~>3.2.1', '3.2.0'], # >=3.2.1 <3.3.0
      ['~1', '0.2.3'], # >=1.0.0 <2.0.0
      ['~>1', '2.2.3'],
      ['~1.0', '2.0.0'], # >=1.0.0 <1.1.0
      ['<1', '1.0.0'],
      ['>=1.2', '1.1.1'],
      ['1', '2.0.0beta', true],
      ['~v0.5.4-beta', '0.5.4-alpha'],
      ['=0.7.x', '0.8.2'],
      ['>=0.7.x', '0.6.2'],
      ['<0.7.x', '0.7.2'],
      ['<1.2.3', '1.2.3-beta'],
      ['=1.2.3', '1.2.3-beta'],
      ['>1.2', '1.2.8'],
      ['^1.2.3', '2.0.0-alpha'],
      ['^1.2.3', '1.2.2'],
      ['^1.2', '1.1.9'],
      ['*', 'v1.2.3-foo', true],
      # invalid ranges never satisfied!
      ['blerg', '1.2.3'],
      ['git+https:#user:password0123@github.com/foo', '123.0.0', true],
      ['^1.2.3', '2.0.0-pre']
    ].each do |tuple|
      range = tuple[0]
      version = tuple[1]
      loose = tuple[2]
      expect(SemanticRange.satisfies?(version, range, loose, 'Rubygems')).to eq(false), "#{tuple}"
      expect(SemanticRange.satisfies?(version, range, loose, 'Packagist')).to eq(false), "#{tuple}"
    end
  end

  it 'valid range' do
    [
      ['1.0.0 - 2.0.0', '>=1.0.0 <=2.0.0'],
      ['1.0.0', '1.0.0'],
      ['>=*', '*'],
      ['', '*'],
      ['*', '*'],
      ['*', '*'],
      ['>=1.0.0', '>=1.0.0'],
      ['>1.0.0', '>1.0.0'],
      ['<=2.0.0', '<=2.0.0'],
      ['1', '>=1.0.0 <2.0.0'],
      ['<=2.0.0', '<=2.0.0'],
      ['<=2.0.0', '<=2.0.0'],
      ['<2.0.0', '<2.0.0'],
      ['<2.0.0', '<2.0.0'],
      ['>= 1.0.0', '>=1.0.0'],
      ['>=  1.0.0', '>=1.0.0'],
      ['>=   1.0.0', '>=1.0.0'],
      ['> 1.0.0', '>1.0.0'],
      ['>  1.0.0', '>1.0.0'],
      ['<=   2.0.0', '<=2.0.0'],
      ['<= 2.0.0', '<=2.0.0'],
      ['<=  2.0.0', '<=2.0.0'],
      ['<    2.0.0', '<2.0.0'],
      ['<	2.0.0', '<2.0.0'],
      ['>=0.1.97', '>=0.1.97'],
      ['>=0.1.97', '>=0.1.97'],
      ['0.1.20 || 1.2.4', '0.1.20||1.2.4'],
      ['>=0.2.3 || <0.0.1', '>=0.2.3||<0.0.1'],
      ['>=0.2.3 || <0.0.1', '>=0.2.3||<0.0.1'],
      ['>=0.2.3 || <0.0.1', '>=0.2.3||<0.0.1'],
      ['||', '||'],
      ['2.x.x', '>=2.0.0 <3.0.0'],
      ['1.2.x', '>=1.2.0 <1.3.0'],
      ['1.2.x || 2.x', '>=1.2.0 <1.3.0||>=2.0.0 <3.0.0'],
      ['1.2.x || 2.x', '>=1.2.0 <1.3.0||>=2.0.0 <3.0.0'],
      ['x', '*'],
      ['2.*.*', '>=2.0.0 <3.0.0'],
      ['1.2.*', '>=1.2.0 <1.3.0'],
      ['1.2.* || 2.*', '>=1.2.0 <1.3.0||>=2.0.0 <3.0.0'],
      ['*', '*'],
      ['2', '>=2.0.0 <3.0.0'],
      ['2.3', '>=2.3.0 <2.4.0'],
      ['~2.4', '>=2.4.0 <3.0.0'],
      ['~>3.2.1', '>=3.2.1 <3.3.0'],
      ['~1', '>=1.0.0 <2.0.0'],
      ['~>1', '>=1.0.0 <2.0.0'],
      ['~> 1', '>=1.0.0 <2.0.0'],
      ['~1.0', '>=1.0.0 <2.0.0'],
      ['~ 1.0', '>=1.0.0 <2.0.0'],
      ['^0', '>=0.0.0 <1.0.0'],
      ['^ 1', '>=1.0.0 <2.0.0'],
      ['^0.1', '>=0.1.0 <0.2.0'],
      ['^1.0', '>=1.0.0 <2.0.0'],
      ['^1.2', '>=1.2.0 <2.0.0'],
      ['^0.0.1', '>=0.0.1 <0.0.2'],
      ['^0.0.1-beta', '>=0.0.1-beta <0.0.2'],
      ['^0.1.2', '>=0.1.2 <0.2.0'],
      ['^1.2.3', '>=1.2.3 <2.0.0'],
      ['^1.2.3-beta.4', '>=1.2.3-beta.4 <2.0.0'],
      ['<1', '<1.0.0'],
      ['< 1', '<1.0.0'],
      ['>=1', '>=1.0.0'],
      ['>= 1', '>=1.0.0'],
      ['<1.2', '<1.2.0'],
      ['< 1.2', '<1.2.0'],
      ['1', '>=1.0.0 <2.0.0'],
      ['>01.02.03', '>1.2.3', true],
      ['>01.02.03', nil],
      ['~1.2.3beta', '>=1.2.3-beta <1.3.0', true],
      ['~1.2.3beta', nil],
      ['^ 1.2 ^ 1', '>=1.2.0 <2.0.0 >=1.0.0 <2.0.0']
    ].each do |tuple|
      pre = tuple[0]
      wanted = tuple[1]
      loose = tuple[2]
      expect(SemanticRange.valid_range(pre, loose, 'Rubygems')).to eq(wanted)
      expect(SemanticRange.valid_range(pre, loose, 'Packagist')).to eq(wanted)
    end
  end

  it 'max satisfying' do
    [
      [['1.2.3', '1.2.4'], '1.2', '1.2.4'],
      [['1.2.4', '1.2.3'], '1.2', '1.2.4'],
      [['1.2.3', '1.2.4', '1.2.5', '1.2.6'], '~1.2.3', '1.2.6'],
      [['1.1.0', '1.2.0', '1.2.1', '1.3.0', '2.0.0b1', '2.0.0b2', '2.0.0b3', '2.0.0', '2.1.0'], '~2.0.0', '2.0.0', true]
    ].each do |v|
      versions, range, expected, loose = v
      expect(SemanticRange.max_satisfying(versions, range, loose, 'Rubygems')).to eq(expected)
    end
  end

  it 'comparators' do
    # [range, comparators]
    # turn range into a set of individual comparators
    [
      ['1.0.0 - 2.0.0', [['>=1.0.0', '<=2.0.0']]],
      ['1.0.0', [['1.0.0']]],
      ['>=*', [['']]],
      ['', [['']]],
      ['*', [['']]],
      ['*', [['']]],
      ['>=1.0.0', [['>=1.0.0']]],
      ['>=1.0.0', [['>=1.0.0']]],
      ['>=1.0.0', [['>=1.0.0']]],
      ['>1.0.0', [['>1.0.0']]],
      ['>1.0.0', [['>1.0.0']]],
      ['<=2.0.0', [['<=2.0.0']]],
      ['1', [['>=1.0.0', '<2.0.0']]],
      ['<=2.0.0', [['<=2.0.0']]],
      ['<=2.0.0', [['<=2.0.0']]],
      ['<2.0.0', [['<2.0.0']]],
      ['<2.0.0', [['<2.0.0']]],
      ['>= 1.0.0', [['>=1.0.0']]],
      ['>=  1.0.0', [['>=1.0.0']]],
      ['>=   1.0.0', [['>=1.0.0']]],
      ['> 1.0.0', [['>1.0.0']]],
      ['>  1.0.0', [['>1.0.0']]],
      ['<=   2.0.0', [['<=2.0.0']]],
      ['<= 2.0.0', [['<=2.0.0']]],
      ['<=  2.0.0', [['<=2.0.0']]],
      ['<    2.0.0', [['<2.0.0']]],
      ["<\t2.0.0", [['<2.0.0']]],
      ['>=0.1.97', [['>=0.1.97']]],
      ['>=0.1.97', [['>=0.1.97']]],
      ['0.1.20 || 1.2.4', [['0.1.20'], ['1.2.4']]],
      ['>=0.2.3 || <0.0.1', [['>=0.2.3'], ['<0.0.1']]],
      ['>=0.2.3 || <0.0.1', [['>=0.2.3'], ['<0.0.1']]],
      ['>=0.2.3 || <0.0.1', [['>=0.2.3'], ['<0.0.1']]],
      ['||', [[''], ['']]],
      ['2.x.x', [['>=2.0.0', '<3.0.0']]],
      ['1.2.x', [['>=1.2.0', '<1.3.0']]],
      ['1.2.x || 2.x', [['>=1.2.0', '<1.3.0'], ['>=2.0.0', '<3.0.0']]],
      ['1.2.x || 2.x', [['>=1.2.0', '<1.3.0'], ['>=2.0.0', '<3.0.0']]],
      ['x', [['']]],
      ['2.*.*', [['>=2.0.0', '<3.0.0']]],
      ['1.2.*', [['>=1.2.0', '<1.3.0']]],
      ['1.2.* || 2.*', [['>=1.2.0', '<1.3.0'], ['>=2.0.0', '<3.0.0']]],
      ['1.2.* || 2.*', [['>=1.2.0', '<1.3.0'], ['>=2.0.0', '<3.0.0']]],
      ['*', [['']]],
      ['2', [['>=2.0.0', '<3.0.0']]],
      ['2.3', [['>=2.3.0', '<2.4.0']]],
      ['~2.4', [['>=2.4.0', '<3.0.0']]],
      ['~>3.2.1', [['>=3.2.1', '<3.3.0']]],
      ['~1', [['>=1.0.0', '<2.0.0']]],
      ['~>1', [['>=1.0.0', '<2.0.0']]],
      ['~> 1', [['>=1.0.0', '<2.0.0']]],
      ['~1.0', [['>=1.0.0', '<2.0.0']]],
      ['~ 1.0', [['>=1.0.0', '<2.0.0']]],
      ['~ 1.0.3', [['>=1.0.3', '<1.1.0']]],
      ['~> 1.0.3', [['>=1.0.3', '<1.1.0']]],
      ['<1', [['<1.0.0']]],
      ['< 1', [['<1.0.0']]],
      ['>=1', [['>=1.0.0']]],
      ['>= 1', [['>=1.0.0']]],
      ['<1.2', [['<1.2.0']]],
      ['< 1.2', [['<1.2.0']]],
      ['1', [['>=1.0.0', '<2.0.0']]],
      ['1 2', [['>=1.0.0', '<2.0.0', '>=2.0.0', '<3.0.0']]],
      ['1.2 - 3.4.5', [['>=1.2.0', '<=3.4.5']]],
      ['1.2.3 - 3.4', [['>=1.2.3', '<3.5.0']]],
      ['1.2.3 - 3', [['>=1.2.3', '<4.0.0']]],
      ['>*', [['<0.0.0']]],
      ['<*', [['<0.0.0']]]
    ].each do |v|
      pre, wanted = v
      found = SemanticRange.to_comparators(pre, false, 'Rubygems')
      jw = wanted.to_json
      expect(found).to eq(wanted), "to_comparators(#{pre}), expected #{found} to eq #{jw}"
    end
  end
end