require 'spec_helper'

describe Calrom::RcParser do
  it 'empty string' do
    expect(described_class.(''))
      .to eq []
  end

  it 'whitespace only' do
    expect(described_class.('  '))
      .to eq []
  end

  it 'single option' do
    expect(described_class.('-o'))
      .to eq ['-o']
  end

  it 'quoted string' do
    expect(described_class.('-o "quoted string"'))
      .to eq ['-o', 'quoted string']
  end

  it 'multi-line' do
    expect(described_class.("-a\n-b"))
      .to eq ['-a', '-b']
  end

  it 'comment after a content' do
    expect(described_class.('-a # comment'))
      .to eq ['-a']
  end

  it 'comment immediately after a content' do
    expect(described_class.('-a# comment'))
      .to eq ['-a']
  end

  it 'comment only' do
    expect(described_class.('# comment'))
      .to eq []
  end
end
