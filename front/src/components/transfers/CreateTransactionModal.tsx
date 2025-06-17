"use client";

import { useState, useEffect } from "react";
import { Button } from "@/components/ui/button";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Checkbox } from "@/components/ui/checkbox";
import { Plus, Loader2 } from "lucide-react";
import { toast } from "sonner";

interface Tag {
  id: number;
  nome: string;
}

interface TagsApiResponse {
  data: Tag[];
}

interface CreateTransactionModalProps {
  onTransacaoCriada: () => void;
  usuarioId: number;
}

export function CreateTransactionModal({ onTransacaoCriada, usuarioId }: CreateTransactionModalProps) {
  const [open, setOpen] = useState(false);
  const [loading, setLoading] = useState(false);
  const [loadingTags, setLoadingTags] = useState(false);
  const [todasTags, setTodasTags] = useState<Tag[]>([]);
  const [formData, setFormData] = useState({
    descricao: "",
    tipo: "",
    valor: "",
    data: new Date().toISOString().slice(0, 10), // yyyy-mm-dd
  });
  const [tagsSelecionadas, setTagsSelecionadas] = useState<number[]>([]);

  // Buscar todas as tags quando o modal abrir
  useEffect(() => {
    if (open) {
      buscarTags();
    }
  }, [open]);

  const buscarTags = async () => {
    setLoadingTags(true);
    try {
      const response = await fetch("http://localhost:4000/api/tags");

      if (!response.ok) {
        throw new Error("Erro ao buscar tags");
      }
      const data: TagsApiResponse = await response.json();
      setTodasTags(data.data);
    } catch (error) {
      console.error("Erro ao buscar tags:", error);
      toast.error("Erro ao carregar tags");
      setTodasTags([]);
    } finally {
      setLoadingTags(false);
    }
  };

  // Função para alternar seleção de tag
  const toggleTag = (tagId: number) => {
    setTagsSelecionadas((prev) => (prev.includes(tagId) ? prev.filter((id) => id !== tagId) : [...prev, tagId]));
  };

  // Função para resetar formulário
  const resetForm = () => {
    setFormData({
      descricao: "",
      tipo: "",
      valor: "",
      data: new Date().toISOString().slice(0, 10), // yyyy-mm-dd
    });
    setTagsSelecionadas([]);
  };

  // Função para criar transação
  const handleCriarTransacao = async () => {
    // Validações básicas
    if (!formData.descricao.trim()) {
      toast.error("Descrição é obrigatória");
      return;
    }
    if (!formData.tipo) {
      toast.error("Tipo é obrigatório");
      return;
    }
    if (!formData.valor || Number.parseFloat(formData.valor) <= 0) {
      toast.error("Valor deve ser maior que zero");
      return;
    }

    setLoading(true);
    try {
      const dadosParaEnviar = {
        descricao: formData.descricao.trim(),
        usuario_id: usuarioId,
        tipo: formData.tipo,
        valor: formData.valor,
        data: formData.data,
        tag_ids: tagsSelecionadas, // Enviando array de IDs
      };

      console.log("Dados enviados:", dadosParaEnviar); // Para debug
      const token = localStorage.getItem("token");
      const response = await fetch("http://localhost:4000/api/transacoes", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "Authorization": `Bearer ${token}`
        },
        body: JSON.stringify({ transacao: dadosParaEnviar }),
      });

      if (!response.ok) {
        throw new Error("Erro ao criar transação");
      }

      toast.success("Transação criada com sucesso!");
      resetForm();
      setOpen(false);
      onTransacaoCriada();
    } catch (error) {
      console.error("Erro ao criar transação:", error);
      toast.error("Erro ao criar transação. Tente novamente.");
    } finally {
      setLoading(false);
    }
  };

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogTrigger asChild>
        <Button className="gap-2">
          <Plus className="h-4 w-4" />
          Nova Transação
        </Button>
      </DialogTrigger>
      <DialogContent className="sm:max-w-[500px] max-h-[80vh] overflow-y-auto">
        <DialogHeader>
          <DialogTitle>Criar Nova Transação</DialogTitle>
        </DialogHeader>

        <div className="grid gap-4 py-4">
          {/* Descrição */}
          <div className="grid gap-2">
            <Label htmlFor="nova-descricao">Descrição *</Label>
            <Input
              id="nova-descricao"
              value={formData.descricao}
              onChange={(e) =>
                setFormData({
                  ...formData,
                  descricao: e.target.value,
                })
              }
              placeholder="Digite a descrição da transação"
            />
          </div>

          {/* Tipo */}
          <div className="grid gap-2">
            <Label htmlFor="novo-tipo">Tipo *</Label>
            <Select
              value={formData.tipo}
              onValueChange={(value) =>
                setFormData({
                  ...formData,
                  tipo: value,
                })
              }
            >
              <SelectTrigger>
                <SelectValue placeholder="Selecione o tipo" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="DESPESA">DESPESA</SelectItem>
                <SelectItem value="RECEITA">RECEITA</SelectItem>
              </SelectContent>
            </Select>
          </div>

          {/* Valor */}
          <div className="grid gap-2">
            <Label htmlFor="novo-valor">Valor *</Label>
            <Input
              id="novo-valor"
              type="number"
              step="0.01"
              min="0"
              value={formData.valor}
              onChange={(e) =>
                setFormData({
                  ...formData,
                  valor: e.target.value,
                })
              }
              placeholder="0.00"
            />
          </div>

          {/* Data */}
          <div className="grid gap-2">
            <Label htmlFor="nova-data">Data *</Label>
            <Input
              id="nova-data"
              type="date"
              value={formData.data}
              onChange={(e) =>
                setFormData({
                  ...formData,
                  data: e.target.value,
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
            ) : todasTags.length > 0 ? (
              <div className="max-h-32 overflow-y-auto border rounded-md p-2">
                {todasTags.map((tag) => (
                  <div key={tag.id} className="flex items-center space-x-2 py-1">
                    <Checkbox
                      id={`nova-tag-${tag.id}`}
                      checked={tagsSelecionadas.includes(tag.id)}
                      onCheckedChange={() => toggleTag(tag.id)}
                    />
                    <Label htmlFor={`nova-tag-${tag.id}`} className="text-sm">
                      {tag.nome}
                    </Label>
                  </div>
                ))}
              </div>
            ) : (
              <div className="text-sm text-gray-500 p-2 border rounded-md">Nenhuma tag disponível</div>
            )}

            {/* Mostrar tags selecionadas */}
            {tagsSelecionadas.length > 0 && (
              <div className="flex flex-wrap gap-1 mt-2">
                <span className="text-xs text-gray-600">Selecionadas:</span>
                {tagsSelecionadas.map((tagId) => {
                  const tag = todasTags.find((t) => t.id === tagId);
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
            <Button
              variant="outline"
              onClick={() => {
                resetForm();
                setOpen(false);
              }}
            >
              Cancelar
            </Button>
            <Button onClick={handleCriarTransacao} disabled={loading}>
              {loading ? (
                <>
                  <Loader2 className="h-4 w-4 animate-spin mr-2" />
                  Criando...
                </>
              ) : (
                "Criar Transação"
              )}
            </Button>
          </div>
        </div>
      </DialogContent>
    </Dialog>
  );
}
