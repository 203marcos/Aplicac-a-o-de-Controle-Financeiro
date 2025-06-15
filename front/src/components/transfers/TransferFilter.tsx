import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Filter } from "lucide-react";

interface TransferFilterProps {
  tagsUnicas: string[];
  filtroTag: string;
  setFiltroTag: (tag: string) => void;
}

export function TransferFilter({ tagsUnicas, filtroTag, setFiltroTag }: TransferFilterProps) {
  return (
    <div className="flex items-center gap-2">
      <Filter className="h-4 w-4" />
      <Select value={filtroTag} onValueChange={setFiltroTag}>
        <SelectTrigger className="w-[180px]">
          <SelectValue placeholder="Filtrar por tag" />
        </SelectTrigger>
        <SelectContent>
          <SelectItem value="todos">Todas as tags</SelectItem>
          {tagsUnicas.map((tag) => (
            <SelectItem key={tag} value={tag}>
              {tag}
            </SelectItem>
          ))}
        </SelectContent>
      </Select>
    </div>
  );
}