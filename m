Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9F83194ACF
	for <lists+stable@lfdr.de>; Thu, 26 Mar 2020 22:43:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgCZVng (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 17:43:36 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:50581 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbgCZVnf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Mar 2020 17:43:35 -0400
Received: by mail-wm1-f68.google.com with SMTP id d198so8947229wmd.0
        for <stable@vger.kernel.org>; Thu, 26 Mar 2020 14:43:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=f1NDn439r2NKX2oz5ZXFZ71Km/k0SiSxc8ZOwV4UNkM=;
        b=OjCourkV/MTqGFeOswaVFQKQOplgKPa1zgys4mGBsxi9hAycFeq4i7NQjVeYvQYYIl
         Z5C2H5mjphkQ+Nzq2zlU7T2vv8LZ/NSe84Rr6iRA3IieJSPTBIV+JoDOcG6K4wpyQoRZ
         J/de/gJN5I9LMtrwEK6Or+ioTpGm8lNkGQ4HCR0llDNYMPMqWxVKs6jmh/+jHxnwzP7L
         cw0COxWs9e/U1bP2id4ENhz6rqKaqFx/0xAWfHGEsXqI5cEg9y5EHkmEHrW3QMCSlPzM
         2ssLLxfTvxst3538bmc6yz2LSgwjSFKx6gc+tyKcSTosPXYfo5Ni3KfomzX3a+kPJ9d1
         9MEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=f1NDn439r2NKX2oz5ZXFZ71Km/k0SiSxc8ZOwV4UNkM=;
        b=UGO6pEO71KMLG+VoWkr68ERcuvOqIFOjPaBGbklmVspeCY/laD5HuZ4ZxDJTb+OvAA
         38jUwQMZw23k5gSevSINEjWHaI6r9PR6gPqvbHWdh1WYcNUd5paLd759Cw/+0k2mEwnX
         cj03J/YOJRgOsSHZ5Rz3/a2lVOdtiNhSLcvf54f9jROSf2OjaHYP7V4w2LciF37pgJAS
         j3Ih1o4eYcIM9LK2esT6OiBNN3A9/w7BPvtLlrC6pLk63IF+K6wGLGpoM7HUx2Cn1ZlP
         Nw+Zriv2F2z7vS54eyNPFXGGZhPw3Qs3q+QxCoXHVGY4VsnqqERL8v3Y8rf7nvKln5j7
         FxzQ==
X-Gm-Message-State: ANhLgQ3uY0BcYLM2eaFygpFOQ7jmkhO43wL/af4TFbmPaPB7oc6sUi7+
        2LzsmYzQKUZmN6F4Mug9WyN3nZqQl9jz6A+9FsDg
X-Google-Smtp-Source: ADFU+vtd+d+BeyjdXRco3BnmIUGbwN18p+gYCa+hvrOkYjQFzeB/QMBSlWf+/g2wWZKCyOEOqWoJhGQRRup/idE8gng=
X-Received: by 2002:adf:e807:: with SMTP id o7mr12050229wrm.77.1585259011235;
 Thu, 26 Mar 2020 14:43:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200224193436.26860-1-atish.patra@wdc.com> <mhng-a36eb560-2fbf-4fba-8416-8181a2c8ad5b@palmerdabbelt-glaptop1>
 <CAEn-LTo=GP5OMZiaBi8BL1etLcGrCyofQrtQ4-JOo5zcpCLu8A@mail.gmail.com> <CAEn-LTokKZXgoNgDi2e5XW2WgL5O+e5UVs7wX2ndqecCdPnN4g@mail.gmail.com>
In-Reply-To: <CAEn-LTokKZXgoNgDi2e5XW2WgL5O+e5UVs7wX2ndqecCdPnN4g@mail.gmail.com>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Thu, 26 Mar 2020 14:43:20 -0700
Message-ID: <CAOnJCUL4BcAFXd6HyOW_eq6mm7PWFNW6yP1srkvTO+=W67AJ-A@mail.gmail.com>
Subject: Re: [PATCH] RISC-V: Move all address space definition macros to one place
To:     David Abdurachmanov <david.abdurachmanov@gmail.com>
Cc:     Palmer Dabbelt <palmerdabbelt@google.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Nick Hu <nickhu@andestech.com>,
        Bjorn Topel <bjorn.topel@gmail.com>,
        Anup Patel <Anup.Patel@wdc.com>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Mike Rapoport <rppt@linux.ibm.com>,
        Atish Patra <Atish.Patra@wdc.com>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Greentime Hu <greentime.hu@sifive.com>,
        Thomas Gleixner <tglx@linutronix.de>, akpm@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 23, 2020 at 3:32 AM David Abdurachmanov
<david.abdurachmanov@gmail.com> wrote:
>
> On Sat, Mar 21, 2020 at 10:29 PM David Abdurachmanov
> <david.abdurachmanov@gmail.com> wrote:
> >
> > On Fri, Mar 6, 2020 at 2:20 AM Palmer Dabbelt <palmerdabbelt@google.com=
> wrote:
> > >
> > > On Mon, 24 Feb 2020 11:34:36 PST (-0800), Atish Patra wrote:
> > > > If both CONFIG_KASAN and CONFIG_SPARSEMEM_VMEMMAP are set, we get t=
he
> > > > following compilation error.
> > > >
> > > > ---------------------------------------------------------------
> > > > ./arch/riscv/include/asm/pgtable-64.h: In function =E2=80=98pud_pag=
e=E2=80=99:
> > > > ./include/asm-generic/memory_model.h:54:29: error: =E2=80=98vmemmap=
=E2=80=99 undeclared
> > > > (first use in this function); did you mean =E2=80=98mem_map=E2=80=
=99?
> > > >  #define __pfn_to_page(pfn) (vmemmap + (pfn))
> > > >                              ^~~~~~~
> > > > ./include/asm-generic/memory_model.h:82:21: note: in expansion of
> > > > macro =E2=80=98__pfn_to_page=E2=80=99
> > > >
> > > >  #define pfn_to_page __pfn_to_page
> > > >                      ^~~~~~~~~~~~~
> > > > ./arch/riscv/include/asm/pgtable-64.h:70:9: note: in expansion of m=
acro
> > > > =E2=80=98pfn_to_page=E2=80=99
> > > >   return pfn_to_page(pud_val(pud) >> _PAGE_PFN_SHIFT);
> > > > ---------------------------------------------------------------
> > > >
> > > > Fix the compliation errors by moving all the address space definiti=
on
> > > > macros before including pgtable-64.h.
> > > >
> > > > Cc: stable@vger.kernel.org
> > > > Fixes: 8ad8b72721d0 (riscv: Add KASAN support)
> > > >
> > > > Signed-off-by: Atish Patra <atish.patra@wdc.com>
> > > > ---
> > > >  arch/riscv/include/asm/pgtable.h | 78 +++++++++++++++++-----------=
----
> > > >  1 file changed, 41 insertions(+), 37 deletions(-)
> > > >
> > > > diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/=
asm/pgtable.h
> > > > index 453afb0a570a..4f6ee48a42e8 100644
> > > > --- a/arch/riscv/include/asm/pgtable.h
> > > > +++ b/arch/riscv/include/asm/pgtable.h
> > > > @@ -19,6 +19,47 @@
> > > >  #include <asm/tlbflush.h>
> > > >  #include <linux/mm_types.h>
> > > >
> > > > +#ifdef CONFIG_MMU
> > > > +
> > > > +#define VMALLOC_SIZE     (KERN_VIRT_SIZE >> 1)
> > > > +#define VMALLOC_END      (PAGE_OFFSET - 1)
> > > > +#define VMALLOC_START    (PAGE_OFFSET - VMALLOC_SIZE)
> > > > +
> > > > +#define BPF_JIT_REGION_SIZE  (SZ_128M)
> > > > +#define BPF_JIT_REGION_START (PAGE_OFFSET - BPF_JIT_REGION_SIZE)
> > > > +#define BPF_JIT_REGION_END   (VMALLOC_END)
> > > > +
> > > > +/*
> > > > + * Roughly size the vmemmap space to be large enough to fit enough
> > > > + * struct pages to map half the virtual address space. Then
> > > > + * position vmemmap directly below the VMALLOC region.
> > > > + */
> > > > +#define VMEMMAP_SHIFT \
> > > > +     (CONFIG_VA_BITS - PAGE_SHIFT - 1 + STRUCT_PAGE_MAX_SHIFT)
> > > > +#define VMEMMAP_SIZE BIT(VMEMMAP_SHIFT)
> > > > +#define VMEMMAP_END  (VMALLOC_START - 1)
> > > > +#define VMEMMAP_START        (VMALLOC_START - VMEMMAP_SIZE)
> > > > +
> > > > +/*
> > > > + * Define vmemmap for pfn_to_page & page_to_pfn calls. Needed if k=
ernel
> > > > + * is configured with CONFIG_SPARSEMEM_VMEMMAP enabled.
> > > > + */
> > > > +#define vmemmap              ((struct page *)VMEMMAP_START)
> > > > +
> > > > +#define PCI_IO_SIZE      SZ_16M
> > > > +#define PCI_IO_END       VMEMMAP_START
> > > > +#define PCI_IO_START     (PCI_IO_END - PCI_IO_SIZE)
> > > > +
> > > > +#define FIXADDR_TOP      PCI_IO_START
> > > > +#ifdef CONFIG_64BIT
> > > > +#define FIXADDR_SIZE     PMD_SIZE
> > > > +#else
> > > > +#define FIXADDR_SIZE     PGDIR_SIZE
> > > > +#endif
> > > > +#define FIXADDR_START    (FIXADDR_TOP - FIXADDR_SIZE)
> > > > +
> > > > +#endif
> > > > +
> > > >  #ifdef CONFIG_64BIT
> > > >  #include <asm/pgtable-64.h>
> > > >  #else
> > > > @@ -90,31 +131,6 @@ extern pgd_t swapper_pg_dir[];
> > > >  #define __S110       PAGE_SHARED_EXEC
> > > >  #define __S111       PAGE_SHARED_EXEC
> > > >
> > > > -#define VMALLOC_SIZE     (KERN_VIRT_SIZE >> 1)
> > > > -#define VMALLOC_END      (PAGE_OFFSET - 1)
> > > > -#define VMALLOC_START    (PAGE_OFFSET - VMALLOC_SIZE)
> > > > -
> > > > -#define BPF_JIT_REGION_SIZE  (SZ_128M)
> > > > -#define BPF_JIT_REGION_START (PAGE_OFFSET - BPF_JIT_REGION_SIZE)
> > > > -#define BPF_JIT_REGION_END   (VMALLOC_END)
> > > > -
> > > > -/*
> > > > - * Roughly size the vmemmap space to be large enough to fit enough
> > > > - * struct pages to map half the virtual address space. Then
> > > > - * position vmemmap directly below the VMALLOC region.
> > > > - */
> > > > -#define VMEMMAP_SHIFT \
> > > > -     (CONFIG_VA_BITS - PAGE_SHIFT - 1 + STRUCT_PAGE_MAX_SHIFT)
> > > > -#define VMEMMAP_SIZE BIT(VMEMMAP_SHIFT)
> > > > -#define VMEMMAP_END  (VMALLOC_START - 1)
> > > > -#define VMEMMAP_START        (VMALLOC_START - VMEMMAP_SIZE)
> > > > -
> > > > -/*
> > > > - * Define vmemmap for pfn_to_page & page_to_pfn calls. Needed if k=
ernel
> > > > - * is configured with CONFIG_SPARSEMEM_VMEMMAP enabled.
> > > > - */
> > > > -#define vmemmap              ((struct page *)VMEMMAP_START)
> > > > -
> > > >  static inline int pmd_present(pmd_t pmd)
> > > >  {
> > > >       return (pmd_val(pmd) & (_PAGE_PRESENT | _PAGE_PROT_NONE));
> > > > @@ -452,18 +468,6 @@ static inline int ptep_clear_flush_young(struc=
t vm_area_struct *vma,
> > > >  #define __pte_to_swp_entry(pte)      ((swp_entry_t) { pte_val(pte)=
 })
> > > >  #define __swp_entry_to_pte(x)        ((pte_t) { (x).val })
> > > >
> > > > -#define PCI_IO_SIZE      SZ_16M
> > > > -#define PCI_IO_END       VMEMMAP_START
> > > > -#define PCI_IO_START     (PCI_IO_END - PCI_IO_SIZE)
> > > > -
> > > > -#define FIXADDR_TOP      PCI_IO_START
> > > > -#ifdef CONFIG_64BIT
> > > > -#define FIXADDR_SIZE     PMD_SIZE
> > > > -#else
> > > > -#define FIXADDR_SIZE     PGDIR_SIZE
> > > > -#endif
> > > > -#define FIXADDR_START    (FIXADDR_TOP - FIXADDR_SIZE)
> > > > -
> > > >  /*
> > > >   * Task size is 0x4000000000 for RV64 or 0x9fc00000 for RV32.
> > > >   * Note that PGDIR_SIZE must evenly divide TASK_SIZE.
> > >
> > > While this isn't technically a fix, I'm inclined to target it for the=
 RCs just
> > > to avoid conflicts.  I've put it on for-next now so the builders have=
 some time
> > > to chew on things, as I don't want to put in a non-fix too quickly.
> >
> > I hit the same issue in Fedora/RISCV while building kernel-5.6.0-0.rc6,=
 and
> > we don't have KASAN selected. We do have CONFIG_SPARSEMEM_VMEMMAP
> > selected.
> >

Yes. I just verified that. CONFIG_SPARSEMEM_VMEMMAP is enough to
trigger the build error.
The code that raises the compilation error is added by kasan patchset,
but it is not dependent upon kasan.

--- a/arch/riscv/include/asm/pgtable-64.h
+++ b/arch/riscv/include/asm/pgtable-64.h
@@ -58,6 +58,11 @@ static inline unsigned long pud_page_vaddr(pud_t pud)
        return (unsigned long)pfn_to_virt(pud_val(pud) >> _PAGE_PFN_SHIFT);
 }

+static inline struct page *pud_page(pud_t pud)
+{
+       return pfn_to_page(pud_val(pud) >> _PAGE_PFN_SHIFT);
+}
+

@palmer: I am not sure if it is too late for an RC-fix. If not, can
you send it as an RC-fix ?

Let me know if you want me to respin the patch editing the commit text.

> > I will try this patch tomorrow.
> >
> Confirmed to solve my build errors with kernel in Fedora/RISCV.
>
> david
>


--=20
Regards,
Atish
