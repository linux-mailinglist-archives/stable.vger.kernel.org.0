Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA3E18F2DA
	for <lists+stable@lfdr.de>; Mon, 23 Mar 2020 11:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727870AbgCWKci (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Mar 2020 06:32:38 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40753 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727829AbgCWKci (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Mar 2020 06:32:38 -0400
Received: by mail-wm1-f65.google.com with SMTP id a81so8385832wmf.5;
        Mon, 23 Mar 2020 03:32:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=59Ut9IY4o/q5MZFN98JGtJfE2YyEe3hnu26+XZPTOIo=;
        b=lQzO1/oMkjJlrnRwkhpmsHy8gUzTzpBjViiDOt1dlcveGJijRmQZy0ei+PbS1diI1L
         OucC4Hl8fpR+/xIAcYduI8ZL0RsFPGN4Ucf9PepZYb1VtlU1iEPAzp5KMHa1+kwLdTvA
         7fQAts/DtpCIgIf9kKffMYLxAVmUI+sG9NR3JAnTBLedGl7PiKaOA9IP506C55ioOEVf
         +fZ2N5c9AFJb8O7fy5M1p41MheEf2MaGSnV5hl73wfpd71PS4TwdmQjDjaqXaPXFR2cl
         L6HebqUBoBZc/KL2E/y9fDjrY9FSzaVyXeLsvgpBHd7JEAGyXjsUtSGudWa4uvzNywDs
         JqLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=59Ut9IY4o/q5MZFN98JGtJfE2YyEe3hnu26+XZPTOIo=;
        b=GcAWT94mhrHy/PZNNFaZD0nOOVp3Tk6587NxQ43npcbKhnqQZdiKbBHw29JUXwFpB1
         d6ir9hOrik7scGkJkgIkgdjjAfMG+7eLo/0zOhD1wxlKxNKdMVEcIKiZ+glhcD8011Dy
         LRxXOJNNscVUHOwa33XqjFu4S+MsH0v9Iy0o0IgX8YTKSL8VijO89Tacq5yvRDh+Jym2
         dYLW4yq93SlbxfV3CkTRIej52JGV9fFiEfW+3wZsAdhObM+VaeKJ4mf8b3y5gkvVmBZY
         jE2N08W5nfPc8mIp2JzsrUcOdA6ZplgOdBGQsMGaVkLMW05MNcNMrDpowJMGxSXPLpdI
         Hp0g==
X-Gm-Message-State: ANhLgQ28ZUXUo/oemQR+XB/LKrLVGJ3E/JHL0vZ5gxjroRjtp0gIu32L
        bbBOdL6hztPLdRiyG741zbcU0jLUhIR7MvrezjY=
X-Google-Smtp-Source: ADFU+vt/QLigcG486ru4fwyg+nnx96T1p/Nq94xgY8sKoWbbeCXaO1ssyA8TBN4/K2CEP5dtp/CYchu1wgRVhBoCN3A=
X-Received: by 2002:a05:600c:228f:: with SMTP id 15mr7693466wmf.140.1584959554995;
 Mon, 23 Mar 2020 03:32:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200224193436.26860-1-atish.patra@wdc.com> <mhng-a36eb560-2fbf-4fba-8416-8181a2c8ad5b@palmerdabbelt-glaptop1>
 <CAEn-LTo=GP5OMZiaBi8BL1etLcGrCyofQrtQ4-JOo5zcpCLu8A@mail.gmail.com>
In-Reply-To: <CAEn-LTo=GP5OMZiaBi8BL1etLcGrCyofQrtQ4-JOo5zcpCLu8A@mail.gmail.com>
From:   David Abdurachmanov <david.abdurachmanov@gmail.com>
Date:   Mon, 23 Mar 2020 12:31:58 +0200
Message-ID: <CAEn-LTokKZXgoNgDi2e5XW2WgL5O+e5UVs7wX2ndqecCdPnN4g@mail.gmail.com>
Subject: Re: [PATCH] RISC-V: Move all address space definition macros to one place
To:     Palmer Dabbelt <palmerdabbelt@google.com>
Cc:     Atish Patra <Atish.Patra@wdc.com>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Albert Ou <aou@eecs.berkeley.edu>, nickhu@andestech.com,
        Bjorn Topel <bjorn.topel@gmail.com>,
        Anup Patel <Anup.Patel@wdc.com>, stable@vger.kernel.org,
        Mike Rapoport <rppt@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Greentime Hu <greentime.hu@sifive.com>,
        akpm@linux-foundation.org,
        linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 21, 2020 at 10:29 PM David Abdurachmanov
<david.abdurachmanov@gmail.com> wrote:
>
> On Fri, Mar 6, 2020 at 2:20 AM Palmer Dabbelt <palmerdabbelt@google.com> =
wrote:
> >
> > On Mon, 24 Feb 2020 11:34:36 PST (-0800), Atish Patra wrote:
> > > If both CONFIG_KASAN and CONFIG_SPARSEMEM_VMEMMAP are set, we get the
> > > following compilation error.
> > >
> > > ---------------------------------------------------------------
> > > ./arch/riscv/include/asm/pgtable-64.h: In function =E2=80=98pud_page=
=E2=80=99:
> > > ./include/asm-generic/memory_model.h:54:29: error: =E2=80=98vmemmap=
=E2=80=99 undeclared
> > > (first use in this function); did you mean =E2=80=98mem_map=E2=80=99?
> > >  #define __pfn_to_page(pfn) (vmemmap + (pfn))
> > >                              ^~~~~~~
> > > ./include/asm-generic/memory_model.h:82:21: note: in expansion of
> > > macro =E2=80=98__pfn_to_page=E2=80=99
> > >
> > >  #define pfn_to_page __pfn_to_page
> > >                      ^~~~~~~~~~~~~
> > > ./arch/riscv/include/asm/pgtable-64.h:70:9: note: in expansion of mac=
ro
> > > =E2=80=98pfn_to_page=E2=80=99
> > >   return pfn_to_page(pud_val(pud) >> _PAGE_PFN_SHIFT);
> > > ---------------------------------------------------------------
> > >
> > > Fix the compliation errors by moving all the address space definition
> > > macros before including pgtable-64.h.
> > >
> > > Cc: stable@vger.kernel.org
> > > Fixes: 8ad8b72721d0 (riscv: Add KASAN support)
> > >
> > > Signed-off-by: Atish Patra <atish.patra@wdc.com>
> > > ---
> > >  arch/riscv/include/asm/pgtable.h | 78 +++++++++++++++++-------------=
--
> > >  1 file changed, 41 insertions(+), 37 deletions(-)
> > >
> > > diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/as=
m/pgtable.h
> > > index 453afb0a570a..4f6ee48a42e8 100644
> > > --- a/arch/riscv/include/asm/pgtable.h
> > > +++ b/arch/riscv/include/asm/pgtable.h
> > > @@ -19,6 +19,47 @@
> > >  #include <asm/tlbflush.h>
> > >  #include <linux/mm_types.h>
> > >
> > > +#ifdef CONFIG_MMU
> > > +
> > > +#define VMALLOC_SIZE     (KERN_VIRT_SIZE >> 1)
> > > +#define VMALLOC_END      (PAGE_OFFSET - 1)
> > > +#define VMALLOC_START    (PAGE_OFFSET - VMALLOC_SIZE)
> > > +
> > > +#define BPF_JIT_REGION_SIZE  (SZ_128M)
> > > +#define BPF_JIT_REGION_START (PAGE_OFFSET - BPF_JIT_REGION_SIZE)
> > > +#define BPF_JIT_REGION_END   (VMALLOC_END)
> > > +
> > > +/*
> > > + * Roughly size the vmemmap space to be large enough to fit enough
> > > + * struct pages to map half the virtual address space. Then
> > > + * position vmemmap directly below the VMALLOC region.
> > > + */
> > > +#define VMEMMAP_SHIFT \
> > > +     (CONFIG_VA_BITS - PAGE_SHIFT - 1 + STRUCT_PAGE_MAX_SHIFT)
> > > +#define VMEMMAP_SIZE BIT(VMEMMAP_SHIFT)
> > > +#define VMEMMAP_END  (VMALLOC_START - 1)
> > > +#define VMEMMAP_START        (VMALLOC_START - VMEMMAP_SIZE)
> > > +
> > > +/*
> > > + * Define vmemmap for pfn_to_page & page_to_pfn calls. Needed if ker=
nel
> > > + * is configured with CONFIG_SPARSEMEM_VMEMMAP enabled.
> > > + */
> > > +#define vmemmap              ((struct page *)VMEMMAP_START)
> > > +
> > > +#define PCI_IO_SIZE      SZ_16M
> > > +#define PCI_IO_END       VMEMMAP_START
> > > +#define PCI_IO_START     (PCI_IO_END - PCI_IO_SIZE)
> > > +
> > > +#define FIXADDR_TOP      PCI_IO_START
> > > +#ifdef CONFIG_64BIT
> > > +#define FIXADDR_SIZE     PMD_SIZE
> > > +#else
> > > +#define FIXADDR_SIZE     PGDIR_SIZE
> > > +#endif
> > > +#define FIXADDR_START    (FIXADDR_TOP - FIXADDR_SIZE)
> > > +
> > > +#endif
> > > +
> > >  #ifdef CONFIG_64BIT
> > >  #include <asm/pgtable-64.h>
> > >  #else
> > > @@ -90,31 +131,6 @@ extern pgd_t swapper_pg_dir[];
> > >  #define __S110       PAGE_SHARED_EXEC
> > >  #define __S111       PAGE_SHARED_EXEC
> > >
> > > -#define VMALLOC_SIZE     (KERN_VIRT_SIZE >> 1)
> > > -#define VMALLOC_END      (PAGE_OFFSET - 1)
> > > -#define VMALLOC_START    (PAGE_OFFSET - VMALLOC_SIZE)
> > > -
> > > -#define BPF_JIT_REGION_SIZE  (SZ_128M)
> > > -#define BPF_JIT_REGION_START (PAGE_OFFSET - BPF_JIT_REGION_SIZE)
> > > -#define BPF_JIT_REGION_END   (VMALLOC_END)
> > > -
> > > -/*
> > > - * Roughly size the vmemmap space to be large enough to fit enough
> > > - * struct pages to map half the virtual address space. Then
> > > - * position vmemmap directly below the VMALLOC region.
> > > - */
> > > -#define VMEMMAP_SHIFT \
> > > -     (CONFIG_VA_BITS - PAGE_SHIFT - 1 + STRUCT_PAGE_MAX_SHIFT)
> > > -#define VMEMMAP_SIZE BIT(VMEMMAP_SHIFT)
> > > -#define VMEMMAP_END  (VMALLOC_START - 1)
> > > -#define VMEMMAP_START        (VMALLOC_START - VMEMMAP_SIZE)
> > > -
> > > -/*
> > > - * Define vmemmap for pfn_to_page & page_to_pfn calls. Needed if ker=
nel
> > > - * is configured with CONFIG_SPARSEMEM_VMEMMAP enabled.
> > > - */
> > > -#define vmemmap              ((struct page *)VMEMMAP_START)
> > > -
> > >  static inline int pmd_present(pmd_t pmd)
> > >  {
> > >       return (pmd_val(pmd) & (_PAGE_PRESENT | _PAGE_PROT_NONE));
> > > @@ -452,18 +468,6 @@ static inline int ptep_clear_flush_young(struct =
vm_area_struct *vma,
> > >  #define __pte_to_swp_entry(pte)      ((swp_entry_t) { pte_val(pte) }=
)
> > >  #define __swp_entry_to_pte(x)        ((pte_t) { (x).val })
> > >
> > > -#define PCI_IO_SIZE      SZ_16M
> > > -#define PCI_IO_END       VMEMMAP_START
> > > -#define PCI_IO_START     (PCI_IO_END - PCI_IO_SIZE)
> > > -
> > > -#define FIXADDR_TOP      PCI_IO_START
> > > -#ifdef CONFIG_64BIT
> > > -#define FIXADDR_SIZE     PMD_SIZE
> > > -#else
> > > -#define FIXADDR_SIZE     PGDIR_SIZE
> > > -#endif
> > > -#define FIXADDR_START    (FIXADDR_TOP - FIXADDR_SIZE)
> > > -
> > >  /*
> > >   * Task size is 0x4000000000 for RV64 or 0x9fc00000 for RV32.
> > >   * Note that PGDIR_SIZE must evenly divide TASK_SIZE.
> >
> > While this isn't technically a fix, I'm inclined to target it for the R=
Cs just
> > to avoid conflicts.  I've put it on for-next now so the builders have s=
ome time
> > to chew on things, as I don't want to put in a non-fix too quickly.
>
> I hit the same issue in Fedora/RISCV while building kernel-5.6.0-0.rc6, a=
nd
> we don't have KASAN selected. We do have CONFIG_SPARSEMEM_VMEMMAP
> selected.
>
> I will try this patch tomorrow.
>
Confirmed to solve my build errors with kernel in Fedora/RISCV.

david
