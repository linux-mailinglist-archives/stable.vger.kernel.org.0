Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A76B4172FA7
	for <lists+stable@lfdr.de>; Fri, 28 Feb 2020 05:08:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730736AbgB1EIi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 23:08:38 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33056 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730314AbgB1EIi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Feb 2020 23:08:38 -0500
Received: by mail-wr1-f68.google.com with SMTP id x7so1442947wrr.0
        for <stable@vger.kernel.org>; Thu, 27 Feb 2020 20:08:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=E6J9poe7L3fgO6iROGjXXzLpbZbZiJ8HzNPUuKbvpBQ=;
        b=hQDPlPu8i3UJQcAlFtZ1KPi0aDhVdJkeXxLsguGG1Tc7naaWqI5ah5b3ihvxIkto2b
         v6ZDujFuWr7KLdEUBiPLR5GDTrZe7oaUjM1RagyK1zH8LOZr1GU6/dvq9T+uSzwHdN1Z
         Ue0SfVA36T0pT+6Xz6egXnsKigQzLufF7186+OZW6SCax5kzWrCGeasoLAgnTWc0sxVa
         bI/ObTs5zwg1QTdM2cBtvTT35DvEURwJtsCq/amrCqwqKttX2fvrOrPOTj9i0qHsbUBN
         zCSAewl8rQbz27h73V2kSzxvnQ2pteIdNNAmxk4u9r1TvbC3ExHRbz+DO/BOWTPY8yYB
         GdwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=E6J9poe7L3fgO6iROGjXXzLpbZbZiJ8HzNPUuKbvpBQ=;
        b=mfmoxNS6vAVRVc0ZXl1fBS7QVIwPfQUsWJxMyXpeNZuahxRy0SOgbWoU/b0B+EY+tq
         Rg8rfRTJle3N0YR73Nc69p5XFPNUl0dIF+iTu5AUZBiegCQZlUHIVyyxhW2aG7l+e4im
         LsqL7t6wJqcvgG3V9Twa1RYzN/yfLaVTk/MCZ8FkF28W+cu3uQtbg1Tvl37vpS3Rh6ST
         QkuRUnQRiBd52XL+Z+cWXddQ2XM9KCjsPS+/TKjJ8pd6GMwq57B/GygMxG9eKsUbVck4
         AlnfDCXhYH26FnZ2hHd2V7Pv5YDr425HNLrBE4w/cntQgvE66VCP9VJZNedrbU+qLbWo
         vXPg==
X-Gm-Message-State: APjAAAUgz6p8G2xlBNOT5wqTCcjmCb9gwWVIIzplIBYxPU9mSvPuiMWn
        keBVPvZt9XJvPNzVb+qqJnhZuzqlZX76efel0Wbp+g==
X-Google-Smtp-Source: APXvYqzGY7zbGE/wiCP2QlLt8CfEyzYl9aJdIcOxadwj5rJwYC+4s4ClgXEgopjqCgej2/koq6sQoObqltMWBHF9Tr8=
X-Received: by 2002:adf:ec84:: with SMTP id z4mr2481605wrn.61.1582862915813;
 Thu, 27 Feb 2020 20:08:35 -0800 (PST)
MIME-Version: 1.0
References: <20200224193436.26860-1-atish.patra@wdc.com>
In-Reply-To: <20200224193436.26860-1-atish.patra@wdc.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 28 Feb 2020 09:38:23 +0530
Message-ID: <CAAhSdy0FH_89dQhWbLJmLsMQV6Lyd8+WE=Ks13Nx88j_dy_b7g@mail.gmail.com>
Subject: Re: [PATCH] RISC-V: Move all address space definition macros to one place
To:     Atish Patra <atish.patra@wdc.com>
Cc:     "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anup Patel <Anup.Patel@wdc.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        David Abdurachmanov <david.abdurachmanov@gmail.com>,
        Greentime Hu <greentime.hu@sifive.com>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Nick Hu <nickhu@andestech.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 25, 2020 at 1:04 AM Atish Patra <atish.patra@wdc.com> wrote:
>
> If both CONFIG_KASAN and CONFIG_SPARSEMEM_VMEMMAP are set, we get the
> following compilation error.
>
> ---------------------------------------------------------------
> ./arch/riscv/include/asm/pgtable-64.h: In function =E2=80=98pud_page=E2=
=80=99:
> ./include/asm-generic/memory_model.h:54:29: error: =E2=80=98vmemmap=E2=80=
=99 undeclared
> (first use in this function); did you mean =E2=80=98mem_map=E2=80=99?
>  #define __pfn_to_page(pfn) (vmemmap + (pfn))
>                              ^~~~~~~
> ./include/asm-generic/memory_model.h:82:21: note: in expansion of
> macro =E2=80=98__pfn_to_page=E2=80=99
>
>  #define pfn_to_page __pfn_to_page
>                      ^~~~~~~~~~~~~
> ./arch/riscv/include/asm/pgtable-64.h:70:9: note: in expansion of macro
> =E2=80=98pfn_to_page=E2=80=99
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
> diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pg=
table.h
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
> +#define BPF_JIT_REGION_SIZE    (SZ_128M)
> +#define BPF_JIT_REGION_START   (PAGE_OFFSET - BPF_JIT_REGION_SIZE)
> +#define BPF_JIT_REGION_END     (VMALLOC_END)
> +
> +/*
> + * Roughly size the vmemmap space to be large enough to fit enough
> + * struct pages to map half the virtual address space. Then
> + * position vmemmap directly below the VMALLOC region.
> + */
> +#define VMEMMAP_SHIFT \
> +       (CONFIG_VA_BITS - PAGE_SHIFT - 1 + STRUCT_PAGE_MAX_SHIFT)
> +#define VMEMMAP_SIZE   BIT(VMEMMAP_SHIFT)
> +#define VMEMMAP_END    (VMALLOC_START - 1)
> +#define VMEMMAP_START  (VMALLOC_START - VMEMMAP_SIZE)
> +
> +/*
> + * Define vmemmap for pfn_to_page & page_to_pfn calls. Needed if kernel
> + * is configured with CONFIG_SPARSEMEM_VMEMMAP enabled.
> + */
> +#define vmemmap                ((struct page *)VMEMMAP_START)
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
>  #define __S110 PAGE_SHARED_EXEC
>  #define __S111 PAGE_SHARED_EXEC
>
> -#define VMALLOC_SIZE     (KERN_VIRT_SIZE >> 1)
> -#define VMALLOC_END      (PAGE_OFFSET - 1)
> -#define VMALLOC_START    (PAGE_OFFSET - VMALLOC_SIZE)
> -
> -#define BPF_JIT_REGION_SIZE    (SZ_128M)
> -#define BPF_JIT_REGION_START   (PAGE_OFFSET - BPF_JIT_REGION_SIZE)
> -#define BPF_JIT_REGION_END     (VMALLOC_END)
> -
> -/*
> - * Roughly size the vmemmap space to be large enough to fit enough
> - * struct pages to map half the virtual address space. Then
> - * position vmemmap directly below the VMALLOC region.
> - */
> -#define VMEMMAP_SHIFT \
> -       (CONFIG_VA_BITS - PAGE_SHIFT - 1 + STRUCT_PAGE_MAX_SHIFT)
> -#define VMEMMAP_SIZE   BIT(VMEMMAP_SHIFT)
> -#define VMEMMAP_END    (VMALLOC_START - 1)
> -#define VMEMMAP_START  (VMALLOC_START - VMEMMAP_SIZE)
> -
> -/*
> - * Define vmemmap for pfn_to_page & page_to_pfn calls. Needed if kernel
> - * is configured with CONFIG_SPARSEMEM_VMEMMAP enabled.
> - */
> -#define vmemmap                ((struct page *)VMEMMAP_START)
> -
>  static inline int pmd_present(pmd_t pmd)
>  {
>         return (pmd_val(pmd) & (_PAGE_PRESENT | _PAGE_PROT_NONE));
> @@ -452,18 +468,6 @@ static inline int ptep_clear_flush_young(struct vm_a=
rea_struct *vma,
>  #define __pte_to_swp_entry(pte)        ((swp_entry_t) { pte_val(pte) })
>  #define __swp_entry_to_pte(x)  ((pte_t) { (x).val })
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
> --
> 2.25.0
>

Looks good to me. At least now all virtual memory layout related
defines are in one place.

Reviewed-by: Anup Patel <anup@brainfault.org>

Regards,
Anup
