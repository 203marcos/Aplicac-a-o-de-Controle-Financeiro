"use client";

import { useState, useEffect } from "react";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { LogOut } from "lucide-react";
import { useRouter } from "next/navigation";
import { TransferFilter } from "@/components/transfers/TransferFilter";
import { TransferTable } from "@/components/transfers/TransferTable";
import { TransferSummary } from "@/components/transfers/TransferSummary";
import { CreateTransactionModal } from "@/components/transfers/CreateTransactionModal";

// Interfaces (mantenha as mesmas)
interface Tag {
  id: number;
  nome: string;
}

interface Transacao {
  id: number;
  descricao: string;
  valor: string;
  tipo: string;
  data: string;
  tags: Tag[];
}

interface ApiResponse {
  data: Transacao[];
}

export default function TransferenciasPage() {
  const [transacoes, setTransacoes] = useState<Transacao[]>([]);
  const [transacaoEditando, setTransacaoEditando] = useState<Transacao | null>(null);
  const [loading, setLoading] = useState(true);
  const router = useRouter();

  // Pegue o id do usuário do localStorage
  const usuarioId =
    typeof window !== "undefined"
      ? JSON.parse(localStorage.getItem("user") || "{}")?.id
      : null;

  // Verifica se existe token no localStorage
  useEffect(() => {
    if (typeof window !== "undefined") {
      const token = localStorage.getItem("token");
      if (!token) {
        router.push("/login");
        return;
      }
    }
  }, [router]);

  // Buscar dados da API
  const carregarTransacoes = async () => {
    if (!usuarioId) {
      router.push("/login");
      return;
    }
    try {
      setLoading(true);
      const token = localStorage.getItem("token");
      const response = await fetch(
        `http://localhost:4000/api/transacoes?usuario_id=${usuarioId}`,
        {
          headers: {
            "Authorization": `Bearer ${token}`,
            "Content-Type": "application/json",
          },
        }
      );
      if (!response.ok) {
        throw new Error("Erro ao buscar transações");
      }
      const responseData: ApiResponse = await response.json();
      setTransacoes(responseData.data);
      setLoading(false);
    } catch (error) {
      setLoading(false);
    }
  };

  useEffect(() => {
    carregarTransacoes();
  }, [usuarioId, router]);

  // Extrair todas as tags únicas
  const todasTags = transacoes.flatMap((t) => t.tags.map((tag) => tag.nome));
  const tagsUnicas = [...new Set(todasTags)];

  // Filtro por tag
  const [filtroTag, setFiltroTag] = useState<string>("todos");

  // Filtrar transações pela tag selecionada
  const transacoesFiltradas = transacoes.filter(
    (transacao) => filtroTag === "todos" || transacao.tags.some((tag) => tag.nome === filtroTag),
  );

  const handleSair = () => {
    localStorage.removeItem("token");      // Remove o token
    localStorage.removeItem("user");       // (Opcional) Remove o usuário salvo
    router.push("/login");
  };


  const formatarData = (dataString: string) => {
    return new Date(dataString).toLocaleDateString("pt-BR", {
      day: "2-digit",
      month: "2-digit",
      year: "numeric",
    });
  };

  const formatarValor = (valor: string) => {
    const valorNumerico = Number.parseFloat(valor);
    return new Intl.NumberFormat("pt-BR", {
      style: "currency",
      currency: "BRL",
    }).format(valorNumerico);
  };

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="text-lg">Carregando transferências...</div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-50 p-4">
      <div className="max-w-6xl mx-auto">
        {/* Botão de Sair */}
        <div className="flex justify-end mb-6">
          <Button onClick={handleSair} variant="outline" className="gap-2">
            <LogOut className="h-4 w-4" />
            Sair
          </Button>
        </div>


        <div className="flex justify-end mb-6">
          <CreateTransactionModal
            onTransacaoCriada={carregarTransacoes}
            usuarioId={usuarioId}
          />
        </div>


        {/* Card Principal */}
        <Card>
          <CardHeader>
            <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
              <CardTitle className="text-2xl">Transferências</CardTitle>
              {tagsUnicas.length > 0 && (
                <TransferFilter tagsUnicas={tagsUnicas} filtroTag={filtroTag} setFiltroTag={setFiltroTag} />
              )}
            </div>
          </CardHeader>
          <CardContent>
            <TransferTable
              transacoesFiltradas={transacoesFiltradas}
              transacaoEditando={transacaoEditando}
              setTransacaoEditando={setTransacaoEditando}
              formatarData={formatarData}
              formatarValor={formatarValor}
              onTransacaoAtualizada={carregarTransacoes} // Adicione esta prop
              todasTags={[]} // Passe aqui a lista de todas as tags do seu sistema, por exemplo: todasTags={tagsUnicas.map(nome => ({ id: ..., nome }))}
            />
            <TransferSummary
              transacoesFiltradas={transacoesFiltradas}
              transacoes={transacoes}
              formatarValor={formatarValor}
            />
          </CardContent>
        </Card>
      </div>
    </div>
  );
};