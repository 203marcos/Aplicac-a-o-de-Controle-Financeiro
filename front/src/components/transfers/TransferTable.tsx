"use client";

import { useState, useEffect } from "react";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Button } from "@/components/ui/button";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog";
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
  AlertDialogTrigger,
} from "@/components/ui/alert-dialog";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Checkbox } from "@/components/ui/checkbox";
import { Edit, Trash2, Loader2 } from "lucide-react";
import { toast } from "sonner";

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

interface TagsApiResponse {
  data: Tag[];
}

interface TransferTableProps {
  transacoesFiltradas: Transacao[];
  transacaoEditando: Transacao | null;
  setTransacaoEditando: (t: Transacao | null) => void;
  formatarData: (data: string) => string;
  formatarValor: (valor: string) => string;
  onTransacaoAtualizada: () => void; // Callback para recarregar dados
  todasTags: Tag[]; // Mantido para compatibilidade, mas não será usado
}

export function TransferTable({
  transacoesFiltradas,
  transacaoEditando,
  setTransacaoEditando,
  formatarData,
  formatarValor,
  onTransacaoAtualizada,
}: TransferTableProps) {
  const [tagsSelecionadas, setTagsSelecionadas] = useState<number[]>([]);
  const [loading, setLoading] = useState(false);
  const [loadingTags, setLoadingTags] = useState(false);
  const [todasTagsDisponiveis, setTodasTagsDisponiveis] = useState<Tag[]>([]);
  const [modalEditarAberto, setModalEditarAberto] = useState(false);

  // Buscar todas as tags quando o modal de edição abrir
  useEffect(() => {
    if (modalEditarAberto) {
      buscarTags();
    }
  }, [modalEditarAberto]);

  const buscarTags = async () => {
    setLoadingTags(true);
    try {
      const response = await fetch("http://localhost:4000/api/tags");
      if (!response.ok) {
        throw new Error("Erro ao buscar tags");
      }
      const data: TagsApiResponse = await response.json();
      setTodasTagsDisponiveis(data.data);
    } catch (error) {
      console.error("Erro ao buscar tags:", error);
      toast.error("Erro ao carregar tags");
      setTodasTagsDisponiveis([]);
    } finally {
      setLoadingTags(false);
    }
  };

  // Função para salvar edição
  const handleSalvarEdicao = async () => {
    if (!transacaoEditando) return;

    setLoading(true);
    try {
      const dadosParaEnviar = {
        descricao: transacaoEditando.descricao,
        valor: transacaoEditando.valor,
        tipo: transacaoEditando.tipo,
        data: transacaoEditando.data,
        tag_ids: tagsSelecionadas,
      };

      console.log("Dados enviados para edição:", dadosParaEnviar); // Para debug
      const token = localStorage.getItem("token");
      const response = await fetch(`http://localhost:4000/api/transacoes/${transacaoEditando.id}`, {
        method: "PUT",
        headers: { "Content-Type": "application/json", "Authorization": `Bearer ${token}` },
        body: JSON.stringify(dadosParaEnviar),
      });

      if (!response.ok) {
        throw new Error("Erro ao atualizar transação");
      }

      toast.success("Transação atualizada com sucesso!");

      setTransacaoEditando(null);
      setModalEditarAberto(false);
      onTransacaoAtualizada(); // Recarregar dados
    } catch (error) {
      console.error("Erro ao salvar transação:", error);
      toast.error("Erro ao salvar as alterações. Tente novamente.");
    } finally {
      setLoading(false);
    }
  };

  // Função para deletar transação
  const handleDeletarTransacao = async (id: number) => {
    setLoading(true);
    try {
      const token = localStorage.getItem("token");
      const response = await fetch(`http://localhost:4000/api/transacoes/${id}`,
        {
          method: "DELETE",
          headers: { "Content-Type": "application/json", "Authorization": `Bearer ${token}` }
        });

      if (!response.ok) {
        throw new Error("Erro ao deletar transação");
      }

      toast.success("Transação deletada com sucesso!");

      onTransacaoAtualizada(); // Recarregar dados
    } catch (error) {
      console.error("Erro ao deletar transação:", error);
      toast.error("Erro ao deletar a transação. Tente novamente.");
    } finally {
      setLoading(false);
    }
  };

  // Função para abrir modal de edição
  const abrirModalEdicao = (transacao: Transacao) => {
    setTransacaoEditando({ ...transacao });
    // Definir tags selecionadas baseado nas tags da transação
    setTagsSelecionadas(transacao.tags.map((tag) => tag.id));
    setModalEditarAberto(true);
  };

  // Função para fechar modal de edição
  const fecharModalEdicao = () => {
    setTransacaoEditando(null);
    setModalEditarAberto(false);
    setTagsSelecionadas([]);
  };

  // Função para alternar seleção de tag
  const toggleTag = (tagId: number) => {
    setTagsSelecionadas((prev) => (prev.includes(tagId) ? prev.filter((id) => id !== tagId) : [...prev, tagId]));
  };

  // Função para formatar data para input
  const formatarDataParaInput = (dataString: string) => {
    const data = new Date(dataString);
    return data.toISOString().split("T")[0];
  };

  return (
    <div className="rounded-md border">
      <Table>
        <TableHeader>
          <TableRow>
            <TableHead>Descrição</TableHead>
            <TableHead>Tipo</TableHead>
            <TableHead>Valor</TableHead>
            <TableHead>Data</TableHead>
            <TableHead>Tags</TableHead>
            <TableHead className="text-right">Ações</TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          {transacoesFiltradas.length === 0 ? (
            <TableRow>
              <TableCell colSpan={6} className="text-center py-8 text-gray-500">
                Nenhuma transferência encontrada
              </TableCell>
            </TableRow>
          ) : (
            transacoesFiltradas.map((transacao) => (
              <TableRow key={transacao.id}>
                <TableCell className="font-medium">{transacao.descricao}</TableCell>
                <TableCell>
                  <span
                    className={`inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium ${transacao.tipo === "DESPESA" ? "bg-red-100 text-red-800" : "bg-green-100 text-green-800"
                      }`}
                  >
                    {transacao.tipo}
                  </span>
                </TableCell>
                <TableCell
                  className={`font-semibold ${transacao.tipo === "RECEITA" ? "text-green-600" : "text-red-600"}`}
                >
                  {formatarValor(transacao.valor)}
                </TableCell>
                <TableCell>{formatarData(transacao.data)}</TableCell>
                <TableCell>
                  <div className="flex flex-wrap gap-1">
                    {transacao.tags.length > 0 ? (
                      transacao.tags.map((tag) => (
                        <span
                          key={tag.id}
                          className="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-gray-100 text-gray-800"
                        >
                          {tag.nome}
                        </span>
                      ))
                    ) : (
                      <span className="text-gray-400">Sem tags</span>
                    )}
                  </div>
                </TableCell>
                <TableCell className="text-right">
                  <div className="flex gap-2 justify-end">
                    {/* Botão Editar */}
                    <Dialog open={modalEditarAberto} onOpenChange={setModalEditarAberto}>
                      <DialogTrigger asChild>
                        <Button variant="outline" size="sm" onClick={() => abrirModalEdicao(transacao)}>
                          <Edit className="h-4 w-4" />
                        </Button>
                      </DialogTrigger>
                      <DialogContent className="sm:max-w-[500px] max-h-[80vh] overflow-y-auto">
                        <DialogHeader>
                          <DialogTitle>Editar Transferência</DialogTitle>
                        </DialogHeader>
                        {transacaoEditando && (
                          <div className="grid gap-4 py-4">
                            {/* Descrição */}
                            <div className="grid gap-2">
                              <Label htmlFor="descricao">Descrição</Label>
                              <Input
                                id="descricao"
                                value={transacaoEditando.descricao}
                                onChange={(e) =>
                                  setTransacaoEditando({
                                    ...transacaoEditando,
                                    descricao: e.target.value,
                                  })
                                }
                              />
                            </div>

                            {/* Valor */}
                            <div className="grid gap-2">
                              <Label htmlFor="valor">Valor</Label>
                              <Input
                                id="valor"
                                type="number"
                                step="0.01"
                                value={transacaoEditando.valor}
                                onChange={(e) =>
                                  setTransacaoEditando({
                                    ...transacaoEditando,
                                    valor: e.target.value,
                                  })
                                }
                              />
                            </div>

                            {/* Tipo */}
                            <div className="grid gap-2">
                              <Label htmlFor="tipo">Tipo</Label>
                              <Select
                                value={transacaoEditando.tipo}
                                onValueChange={(value) =>
                                  setTransacaoEditando({
                                    ...transacaoEditando,
                                    tipo: value,
                                  })
                                }
                              >
                                <SelectTrigger>
                                  <SelectValue />
                                </SelectTrigger>
                                <SelectContent>
                                  <SelectItem value="DESPESA">DESPESA</SelectItem>
                                  <SelectItem value="RECEITA">RECEITA</SelectItem>
                                </SelectContent>
                              </Select>
                            </div>

                            {/* Data */}
                            <div className="grid gap-2">
                              <Label htmlFor="data">Data</Label>
                              <Input
                                id="data"
                                type="date"
                                value={formatarDataParaInput(transacaoEditando.data)}
                                onChange={(e) =>
                                  setTransacaoEditando({
                                    ...transacaoEditando,
                                    data: new Date(e.target.value).toISOString(),
                                  })
                                }
                              />
                            </div>

                            {/* Tags */}
                            <div className="grid gap-2">
                              <Label>Tags (opcional)</Label>
                              {loadingTags ? (
                                <div className="flex items-center justify-center p-4 border rounded-md">
                                  <Loader2 className="h-4 w-4 animate-spin mr-2" />
                                  Carregando tags...
                                </div>
                              ) : todasTagsDisponiveis.length > 0 ? (
                                <div className="max-h-32 overflow-y-auto border rounded-md p-2">
                                  {todasTagsDisponiveis.map((tag) => (
                                    <div key={tag.id} className="flex items-center space-x-2 py-1">
                                      <Checkbox
                                        id={`edit-tag-${tag.id}`}
                                        checked={tagsSelecionadas.includes(tag.id)}
                                        onCheckedChange={() => toggleTag(tag.id)}
                                      />
                                      <Label htmlFor={`edit-tag-${tag.id}`} className="text-sm">
                                        {tag.nome}
                                      </Label>
                                    </div>
                                  ))}
                                </div>
                              ) : (
                                <div className="text-sm text-gray-500 p-2 border rounded-md">
                                  Nenhuma tag disponível
                                </div>
                              )}

                              {/* Mostrar tags selecionadas */}
                              {tagsSelecionadas.length > 0 && (
                                <div className="flex flex-wrap gap-1 mt-2">
                                  <span className="text-xs text-gray-600">Selecionadas:</span>
                                  {tagsSelecionadas.map((tagId) => {
                                    const tag = todasTagsDisponiveis.find((t) => t.id === tagId);
                                    return (
                                      <span
                                        key={tagId}
                                        className="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-blue-100 text-blue-800"
                                      >
                                        {tag?.nome} (ID: {tagId})
                                      </span>
                                    );
                                  })}
                                </div>
                              )}
                            </div>

                            {/* Botões */}
                            <div className="flex justify-end gap-2 pt-4">
                              <Button variant="outline" onClick={fecharModalEdicao}>
                                Cancelar
                              </Button>
                              <Button onClick={handleSalvarEdicao} disabled={loading}>
                                {loading ? (
                                  <>
                                    <Loader2 className="h-4 w-4 animate-spin mr-2" />
                                    Salvando...
                                  </>
                                ) : (
                                  "Salvar"
                                )}
                              </Button>
                            </div>
                          </div>
                        )}
                      </DialogContent>
                    </Dialog>

                    {/* Botão Deletar */}
                    <AlertDialog>
                      <AlertDialogTrigger asChild>
                        <Button variant="outline" size="sm" className="text-red-600 hover:text-red-700">
                          <Trash2 className="h-4 w-4" />
                        </Button>
                      </AlertDialogTrigger>
                      <AlertDialogContent>
                        <AlertDialogHeader>
                          <AlertDialogTitle>Confirmar Exclusão</AlertDialogTitle>
                          <AlertDialogDescription>
                            Tem certeza que deseja deletar a transação "{transacao.descricao}"? Esta ação não pode ser
                            desfeita.
                          </AlertDialogDescription>
                        </AlertDialogHeader>
                        <AlertDialogFooter>
                          <AlertDialogCancel>Cancelar</AlertDialogCancel>
                          <AlertDialogAction
                            onClick={() => handleDeletarTransacao(transacao.id)}
                            className="bg-red-600 hover:bg-red-700"
                            disabled={loading}
                          >
                            {loading ? "Deletando..." : "Deletar"}
                          </AlertDialogAction>
                        </AlertDialogFooter>
                      </AlertDialogContent>
                    </AlertDialog>
                  </div>
                </TableCell>
              </TableRow>
            ))
          )}
        </TableBody>
      </Table>
    </div>
  );
}
