// app/providers.tsx
'use client'

import { Toaster } from '@/components/ui/toaster'
import { ChakraProvider } from '@chakra-ui/react'
import { useState } from 'react'
import { QueryClient, QueryClientProvider } from 'react-query'

export function Providers({ children }: { children: React.ReactNode }) {
  const [queryClient] = useState(() => new QueryClient())

  return (
    <QueryClientProvider client={queryClient}>
      <ChakraProvider>
        {children}
      </ChakraProvider>
      <Toaster/>
    </QueryClientProvider>
  )
}