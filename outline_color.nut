global function InitOutlineColor

// ===== КОНФИГУРАЦИЯ =====
const table COLOR_PRESETS = {
    // Стандартные цвета (из настроек цветовой слепоты)
    "default_red":     [255, 0, 0],      // Красный (по умолчанию)
    "default_pink":    [255, 105, 180],  // Розовый
    "default_yellow":  [255, 255, 0],    // Желтый
    "default_orange":  [255, 165, 0],    // Оранжевый
    
    // Кастомные цвета (используем встроенные материалы)
    "cyan":    [0, 255, 255],   // Голубой
    "green":   [0, 255, 0],     // Зеленый
    "purple":  [128, 0, 128],   // Фиолетовый
    "white":   [255, 255, 255]  // Белый
}

// ===== СИСТЕМА ИЗМЕНЕНИЯ ЦВЕТА =====
void function SetOutlineColor(vector color) {
    // Используем встроенный шейдер outline_highlight
    Material outlineMaterial = Material("models/humans/outline_highlight")
    
    // Меняем параметры шейдера
    outlineMaterial.SetVector("_OutlineColor", color)
    outlineMaterial.SetFloat("_OutlineWidth", 1.5) // Толщина окантовки
    
    // Применяем ко всем игрокам
    foreach (player in GetPlayerArray()) {
        if (player != GetLocalPlayer()) {
            player.SetOutlineMaterial(outlineMaterial)
        }
    }
}

// ===== ИНТЕРФЕЙС =====
void function CycleOutlineColor() {
    static int currentPreset = 0
    local presets = COLOR_PRESETS.keys()
    
    currentPreset = (currentPreset + 1) % presets.len()
    string selected = presets[currentPreset]
    
    SetOutlineColor(Vector(COLOR_PRESETS[selected][0], 
                         COLOR_PRESETS[selected][1], 
                         COLOR_PRESETS[selected][2]))
    
    print("Outline color: " + selected)
}

// ===== ИНИЦИАЛИЗАЦИЯ =====
void function InitOutlineColor() {
    // Консольная команда
    ConCommand("outline_next", CycleOutlineColor, "Cycle outline colors")
    
    // Меню настроек
    ModSettings.AddMenu({
        title = "OUTLINE COLORS",
        items = [
            {
                text = "SELECT COLOR",
                items: [
                    { text: "Красный", action: function() { SetOutlineColor([255,0,0]) } },
                    { text: "Зеленый", action: function() { SetOutlineColor([0,255,0]) } },
                    { text: "Фиолетовый", action: function() { SetOutlineColor([128,0,128]) } }
                ]
            }
        ]
    })
}
