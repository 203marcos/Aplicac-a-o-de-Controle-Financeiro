interface TransferSummaryProps {
  transacoesFiltradas: { valor: string; tipo: string; }[];
  transacoes: { valor: string; tipo: string; }[];
  formatarValor: (valor: string) => string;
}

export function TransferSummary({ transacoesFiltradas, transacoes, formatarValor }: TransferSummaryProps) {
  return (
    <div className="mt-6 flex justify-between items-center text-sm text-gray-600">
      <span>
        Mostrando {transacoesFiltradas.length} de {transacoes.length} transferências
      </span>
      <span>
        Total:{" "}
        {formatarValor(
          transacoesFiltradas
            .reduce((acc, t) => {
              const valor = Number.parseFloat(t.valor);
              return t.tipo === "RECEITA" ? acc + valor : acc - valor;
            }, 0)
            .toString(),
        )}
      </span>
    </div>
  );
}