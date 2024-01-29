library(tidyverse)
bonesy <- read_csv('TB_Flotation_RAW.csv')
bonesy$Sample_Numeric <- as.numeric(as.factor(bonesy$`Sample ID:`))
view(bonesy)
bones_only <- bonesy %>% filter(Material == 'bone')
# bones graph
ggplot(bones_only, aes(x =`Sample ID:`, y = `g/L Ratio`, fill = `Sample_Numeric`)) + 
  geom_bar(stat = 'identity') + ggtitle('Bone Gram to Sample Litre Across Samples') + 
  labs(x = 'Sample ID', y = 'g / L Ratio') + guides(fill = 'none') + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) + 
  scale_fill_gradient(low = 'darkred', high = '#FF7F7F')

ceram_only <- bonesy %>% filter(Material == 'ceramic')
# ceramic graph
ggplot(ceram_only, aes(x =`Sample ID:`, y = `g/L Ratio`, fill = `Sample_Numeric`)) + 
  geom_bar(stat = 'identity') + ggtitle('Ceramic Gram to Sample Litre Across Samples') + 
  labs(x = 'Sample ID', y = 'g / L Ratio') + guides(fill = 'none') + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) + 
  scale_fill_gradient(low = 'darkgreen', high = 'lightgreen')

lith_only <- bonesy %>% filter(Material == 'lithic')
# lithic graph
ggplot(lith_only, aes(x =`Sample ID:`, y = `g/L Ratio`, fill = `Sample_Numeric`)) + 
  geom_bar(stat = 'identity') + ggtitle('Lithic Gram to Sample Litre Across Samples') + 
  labs(x = 'Sample ID', y = 'g / L Ratio') + guides(fill = 'none') + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) + 
  scale_fill_gradient(low = 'darkblue', high = '#00BCFF')

# stacked graph for all 3
important_only <- bonesy %>% filter(Material %in% c('bone', 'ceramic', 'lithic'))
ggplot(important_only, aes(x =`Sample ID:`, y = `g/L Ratio`, fill = `Material`)) + 
  geom_bar(position = 'stack', stat = 'identity') + ggtitle('Bone, Lithic, and Ceramic Gram to Sample Litre Across Samples') + 
  labs(x = 'Sample ID', y = 'g / L Ratio') +  
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))
