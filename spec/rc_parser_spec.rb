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

  it 'handles newline as any other whitespace' do
    expect(described_class.("-a\n-b"))
      .to eq ['-a', '-b']
  end

  it 'comment after content' do
    expect(described_class.('-a # comment'))
      .to eq ['-a']
  end

  it 'comment immediately after content' do
    expect(described_class.('-a# comment'))
      .to eq ['-a']
  end

  it 'comment only' do
    expect(described_class.('# comment'))
      .to eq []
  end

  # tilde expansion to contents of $HOME is a frequently used shell feature
  # and it may have sense to support it in the configuration files, but at least for now
  # we are not going down the road of implementing "almost a real shell"
  it 'does not expand tilde' do
    expect(described_class.('~'))
      .to eq ['~']
  end
end
