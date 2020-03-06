Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9202D17B2B9
	for <lists+stable@lfdr.de>; Fri,  6 Mar 2020 01:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbgCFAUp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Mar 2020 19:20:45 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44880 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726173AbgCFAUp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Mar 2020 19:20:45 -0500
Received: by mail-pg1-f194.google.com with SMTP id n24so208387pgk.11
        for <stable@vger.kernel.org>; Thu, 05 Mar 2020 16:20:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:subject:in-reply-to:cc:from:to:message-id:mime-version
         :content-transfer-encoding;
        bh=+dCROxXm63kuCRbzO1bF7hZyQIUcAyqsydyhewMMbBw=;
        b=kh+6yTOH1gzY1+UGxl6/tLwd3WUSdBX6z+0MJbIfsJrZPJKCZwQ1nl5/w2ayfW3hK9
         rXa0sYXQ3NE3snlJUPYT6m/TsZz7ydNK07iMLsSKn2SRsPeEI3FyOTStRzeUm1asuNmf
         9kQVKZLkKYabobiJgwh6KEinUO4cXCqr+3tX1ZQ2lLEcpmYK6cKlgLU+Ofnoj9BcJ5zY
         1Ss5epn3soowrunfvbqeJ/7re1TNmf2U4Q/lEuz0Ua3fRCW4nMDIa/iIyxRHPk1Z+DxU
         kSiQFN7oqNuT4d3YOKiV3/UQ/lmXCFovF33BXiBqpuzo88O0FV/JXSrZk89Voy8fMrjJ
         F33w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
         :mime-version:content-transfer-encoding;
        bh=+dCROxXm63kuCRbzO1bF7hZyQIUcAyqsydyhewMMbBw=;
        b=Qm830hUSYlte+8IMjCd6OPulqBqZTMrQ5olYa+sN0KIv/TxkoA+R+9aYthYk/72lBK
         ngkC/USjbL2CBnGeIIF/T0umH/efBWGse+N+O96ZdDVRigZNQIxW+xY3TIVp9gdaziYx
         vU9I9qXOZP2gxmk4+Ot6zYwOq3pc6MI5UvqTbPAPZt5JmFo7QvfsN4TsJeeyUwkRBYPb
         C6CGinhsr/weUxtCPHnWTm4912eMiX3Q216RqaWA4+kP/R2icL+k6Xh0FoPizrx2foI8
         +smJJReGBSCkB+4/Ti1AewNTePi1var9EoaxRbpsfu9ekxWznpfulqJBmeq7eouSsXum
         Npdg==
X-Gm-Message-State: ANhLgQ1cMxtCqjazy6dM+xVgeWaNxApWvOcjVaH32jqd3qovdHQ3Qaz9
        kg1QXskYI38+dKwX6uUOyW6zHg==
X-Google-Smtp-Source: ADFU+vs+C9XuIWtDzAx8P7eOzB45RGv02fBsZj/MUVzvOPEc71OPJW685bvI9k0bOR8S5rzecFfNQA==
X-Received: by 2002:a63:5a23:: with SMTP id o35mr728844pgb.60.1583454044037;
        Thu, 05 Mar 2020 16:20:44 -0800 (PST)
Received: from localhost ([2620:0:1000:2514:23a5:d584:6a92:3e3c])
        by smtp.gmail.com with ESMTPSA id a22sm244247pfo.56.2020.03.05.16.20.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2020 16:20:43 -0800 (PST)
Date:   Thu, 05 Mar 2020 16:20:43 -0800 (PST)
X-Google-Original-Date: Thu, 05 Mar 2020 16:20:40 PST (-0800)
Subject:     Re: [PATCH] RISC-V: Move all address space definition macros to one place
In-Reply-To: <20200224193436.26860-1-atish.patra@wdc.com>
CC:     linux-kernel@vger.kernel.org, aou@eecs.berkeley.edu,
        nickhu@andestech.com, david.abdurachmanov@gmail.com,
        Bjorn Topel <bjorn.topel@gmail.com>,
        Anup Patel <Anup.Patel@wdc.com>, stable@vger.kernel.org,
        rppt@linux.ibm.com, Atish Patra <Atish.Patra@wdc.com>,
        tglx@linutronix.de, Paul Walmsley <paul.walmsley@sifive.com>,
        greentime.hu@sifive.com, akpm@linux-foundation.org,
        linux-riscv@lists.infradead.org
From:   Palmer Dabbelt <palmerdabbelt@google.com>
To:     Atish Patra <Atish.Patra@wdc.com>
Message-ID: <mhng-a36eb560-2fbf-4fba-8416-8181a2c8ad5b@palmerdabbelt-glaptop1>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 24 Feb 2020 11:34:36 PST (-0800), Atish Patra wrote:
> If both CONFIG_KASAN and CONFIG_SPARSEMEM_VMEMMAP are set, we get the
> following compilation error.
>
> ---------------------------------------------------------------
> ./arch/riscv/include/asm/pgtable-64.h: In function ‘pud_page’:
> ./include/asm-generic/memory_model.h:54:29: error: ‘vmemmap’ undeclared
> (first use in this function); did you mean ‘mem_map’?
>  #define __pfn_to_page(pfn) (vmemmap + (pfn))
>                              ^~~~~~~
> ./include/asm-generic/memory_model.h:82:21: note: in expansion of
> macro ‘__pfn_to_page’
>
>  #define pfn_to_page __pfn_to_page
>                      ^~~~~~~~~~~~~
> ./arch/riscv/include/asm/pgtable-64.h:70:9: note: in expansion of macro
> ‘pfn_to_page’
>   return pfn_to_page(pud_val(pud) >> _PAGE_PFN_SHIFT);
> ---------------------------------------------------------------
>
> Fix the compliation errors by moving all the address space definition
> macros before including pgtable-64.h.
>
> Cc: stable@vger.kernel.org
> Fixes: 8ad8b72721d0 (riscv: Add KASAN support)
>
> Signed-off-by: Atish Patra <atish.patra@wdc.com>
> ---
>  arch/riscv/include/asm/pgtable.h | 78 +++++++++++++++++---------------
>  1 file changed, 41 insertions(+), 37 deletions(-)
>
> diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
> index 453afb0a570a..4f6ee48a42e8 100644
> --- a/arch/riscv/include/asm/pgtable.h
> +++ b/arch/riscv/include/asm/pgtable.h
> @@ -19,6 +19,47 @@
>  #include <asm/tlbflush.h>
>  #include <linux/mm_types.h>
>
> +#ifdef CONFIG_MMU
> +
> +#define VMALLOC_SIZE     (KERN_VIRT_SIZE >> 1)
> +#define VMALLOC_END      (PAGE_OFFSET - 1)
> +#define VMALLOC_START    (PAGE_OFFSET - VMALLOC_SIZE)
> +
> +#define BPF_JIT_REGION_SIZE	(SZ_128M)
> +#define BPF_JIT_REGION_START	(PAGE_OFFSET - BPF_JIT_REGION_SIZE)
> +#define BPF_JIT_REGION_END	(VMALLOC_END)
> +
> +/*
> + * Roughly size the vmemmap space to be large enough to fit enough
> + * struct pages to map half the virtual address space. Then
> + * position vmemmap directly below the VMALLOC region.
> + */
> +#define VMEMMAP_SHIFT \
> +	(CONFIG_VA_BITS - PAGE_SHIFT - 1 + STRUCT_PAGE_MAX_SHIFT)
> +#define VMEMMAP_SIZE	BIT(VMEMMAP_SHIFT)
> +#define VMEMMAP_END	(VMALLOC_START - 1)
> +#define VMEMMAP_START	(VMALLOC_START - VMEMMAP_SIZE)
> +
> +/*
> + * Define vmemmap for pfn_to_page & page_to_pfn calls. Needed if kernel
> + * is configured with CONFIG_SPARSEMEM_VMEMMAP enabled.
> + */
> +#define vmemmap		((struct page *)VMEMMAP_START)
> +
> +#define PCI_IO_SIZE      SZ_16M
> +#define PCI_IO_END       VMEMMAP_START
> +#define PCI_IO_START     (PCI_IO_END - PCI_IO_SIZE)
> +
> +#define FIXADDR_TOP      PCI_IO_START
> +#ifdef CONFIG_64BIT
> +#define FIXADDR_SIZE     PMD_SIZE
> +#else
> +#define FIXADDR_SIZE     PGDIR_SIZE
> +#endif
> +#define FIXADDR_START    (FIXADDR_TOP - FIXADDR_SIZE)
> +
> +#endif
> +
>  #ifdef CONFIG_64BIT
>  #include <asm/pgtable-64.h>
>  #else
> @@ -90,31 +131,6 @@ extern pgd_t swapper_pg_dir[];
>  #define __S110	PAGE_SHARED_EXEC
>  #define __S111	PAGE_SHARED_EXEC
>
> -#define VMALLOC_SIZE     (KERN_VIRT_SIZE >> 1)
> -#define VMALLOC_END      (PAGE_OFFSET - 1)
> -#define VMALLOC_START    (PAGE_OFFSET - VMALLOC_SIZE)
> -
> -#define BPF_JIT_REGION_SIZE	(SZ_128M)
> -#define BPF_JIT_REGION_START	(PAGE_OFFSET - BPF_JIT_REGION_SIZE)
> -#define BPF_JIT_REGION_END	(VMALLOC_END)
> -
> -/*
> - * Roughly size the vmemmap space to be large enough to fit enough
> - * struct pages to map half the virtual address space. Then
> - * position vmemmap directly below the VMALLOC region.
> - */
> -#define VMEMMAP_SHIFT \
> -	(CONFIG_VA_BITS - PAGE_SHIFT - 1 + STRUCT_PAGE_MAX_SHIFT)
> -#define VMEMMAP_SIZE	BIT(VMEMMAP_SHIFT)
> -#define VMEMMAP_END	(VMALLOC_START - 1)
> -#define VMEMMAP_START	(VMALLOC_START - VMEMMAP_SIZE)
> -
> -/*
> - * Define vmemmap for pfn_to_page & page_to_pfn calls. Needed if kernel
> - * is configured with CONFIG_SPARSEMEM_VMEMMAP enabled.
> - */
> -#define vmemmap		((struct page *)VMEMMAP_START)
> -
>  static inline int pmd_present(pmd_t pmd)
>  {
>  	return (pmd_val(pmd) & (_PAGE_PRESENT | _PAGE_PROT_NONE));
> @@ -452,18 +468,6 @@ static inline int ptep_clear_flush_young(struct vm_area_struct *vma,
>  #define __pte_to_swp_entry(pte)	((swp_entry_t) { pte_val(pte) })
>  #define __swp_entry_to_pte(x)	((pte_t) { (x).val })
>
> -#define PCI_IO_SIZE      SZ_16M
> -#define PCI_IO_END       VMEMMAP_START
> -#define PCI_IO_START     (PCI_IO_END - PCI_IO_SIZE)
> -
> -#define FIXADDR_TOP      PCI_IO_START
> -#ifdef CONFIG_64BIT
> -#define FIXADDR_SIZE     PMD_SIZE
> -#else
> -#define FIXADDR_SIZE     PGDIR_SIZE
> -#endif
> -#define FIXADDR_START    (FIXADDR_TOP - FIXADDR_SIZE)
> -
>  /*
>   * Task size is 0x4000000000 for RV64 or 0x9fc00000 for RV32.
>   * Note that PGDIR_SIZE must evenly divide TASK_SIZE.

While this isn't technically a fix, I'm inclined to target it for the RCs just
to avoid conflicts.  I've put it on for-next now so the builders have some time
to chew on things, as I don't want to put in a non-fix too quickly.

Thanks!
