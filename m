Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E590C6A51BE
	for <lists+stable@lfdr.de>; Tue, 28 Feb 2023 04:16:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbjB1DQV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Feb 2023 22:16:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjB1DQV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Feb 2023 22:16:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A3ED241DA;
        Mon, 27 Feb 2023 19:16:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01374B80D7B;
        Tue, 28 Feb 2023 03:16:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8E7FC4339B;
        Tue, 28 Feb 2023 03:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677554162;
        bh=zLoElNBfibhB4bO4YaGT0vwzawu6gO4X0BlnjgRZq2w=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=oo1qSxsjTyI6ovzpLGrHmgTyIF2WTg5mOnZ/BFUosesz7nenRRVDymwriFEoDoIoF
         Au+H/3853QXUog8byodvXV+p9QOgC1mJu3kL35hW6d+zEV+rVaRbu1Sw7D2UnSRiCa
         nA/GdrKrvgN/psuJWj6kOpwcUaPE4RdsfHJdiNuN0/Tti1mSfGWRhga+hxG2MA8/iU
         gT+ZtimMNYS3Ijj6KkGFu3grJdidciBoTaEbJs3mvxN4gC5hndAXQtDM/v0FPA3hQr
         QMJaId8SwRXtM4beA4o29qnWWlX7KLQZ/9Exn8aGifmuw6bF7YHqP75mMUP/l1eR0p
         wZl+HCkSHg2PQ==
Received: by mail-ed1-f44.google.com with SMTP id ec43so34290211edb.8;
        Mon, 27 Feb 2023 19:16:02 -0800 (PST)
X-Gm-Message-State: AO0yUKVb2jNxstXdh7CwiPjO49qUIVZM69Am+91FNyRXmC2WAPVK5mwl
        SD0cR0tK4tSRjxHu7DxQO1URy6anbQOjQE7+aAI=
X-Google-Smtp-Source: AK7set/WEayOvOsvDv4N9WulDM5hKKXV3BcBkv7fU0cMs/hNqPWTX7nlOewO5DJNDAG6qZF1LQvtlMRNxcJEQLxD7AM=
X-Received: by 2002:a17:906:dc53:b0:8b1:7684:dfad with SMTP id
 yz19-20020a170906dc5300b008b17684dfadmr448452ejb.8.1677554160884; Mon, 27 Feb
 2023 19:16:00 -0800 (PST)
MIME-Version: 1.0
References: <20230226150137.1919750-1-geomatsi@gmail.com> <20230226150137.1919750-2-geomatsi@gmail.com>
In-Reply-To: <20230226150137.1919750-2-geomatsi@gmail.com>
From:   Guo Ren <guoren@kernel.org>
Date:   Tue, 28 Feb 2023 11:15:49 +0800
X-Gmail-Original-Message-ID: <CAJF2gTSjnyV0hY94RJsoNAb0+VbwV48hgXLiUnQD7QiMx0F91Q@mail.gmail.com>
Message-ID: <CAJF2gTSjnyV0hY94RJsoNAb0+VbwV48hgXLiUnQD7QiMx0F91Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] Revert "riscv: mm: notify remote harts about mmu
 cache updates"
To:     Sergey Matyukevich <geomatsi@gmail.com>
Cc:     linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Zong Li <zong.li@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Sergey Matyukevich <sergey.matyukevich@syntacore.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thx
Reviewed-by: Guo Ren <guoren@kernel.org>

On Sun, Feb 26, 2023 at 11:02=E2=80=AFPM Sergey Matyukevich <geomatsi@gmail=
.com> wrote:
>
> From: Sergey Matyukevich <sergey.matyukevich@syntacore.com>
>
> This reverts the remaining bits of commit 4bd1d80efb5a ("riscv: mm:
> notify remote harts harts about mmu cache updates").
>
> According to bug reports, suggested approach to fix stale TLB entries
> is not sufficient. It needs to be replaced by a more robust solution.
>
> Fixes: 4bd1d80efb5a ("riscv: mm: notify remote harts about mmu cache upda=
tes")
> Reported-by: Zong Li <zong.li@sifive.com>
> Reported-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Signed-off-by: Sergey Matyukevich <sergey.matyukevich@syntacore.com>
> Cc: stable@vger.kernel.org
>
> ---
>  arch/riscv/include/asm/mmu.h      |  2 --
>  arch/riscv/include/asm/tlbflush.h | 18 ------------------
>  arch/riscv/mm/context.c           | 10 ----------
>  arch/riscv/mm/tlbflush.c          | 28 +++++++++++++++++-----------
>  4 files changed, 17 insertions(+), 41 deletions(-)
>
> diff --git a/arch/riscv/include/asm/mmu.h b/arch/riscv/include/asm/mmu.h
> index 5ff1f19fd45c..0099dc116168 100644
> --- a/arch/riscv/include/asm/mmu.h
> +++ b/arch/riscv/include/asm/mmu.h
> @@ -19,8 +19,6 @@ typedef struct {
>  #ifdef CONFIG_SMP
>         /* A local icache flush is needed before user execution can resum=
e. */
>         cpumask_t icache_stale_mask;
> -       /* A local tlb flush is needed before user execution can resume. =
*/
> -       cpumask_t tlb_stale_mask;
>  #endif
>  } mm_context_t;
>
> diff --git a/arch/riscv/include/asm/tlbflush.h b/arch/riscv/include/asm/t=
lbflush.h
> index 907b9efd39a8..801019381dea 100644
> --- a/arch/riscv/include/asm/tlbflush.h
> +++ b/arch/riscv/include/asm/tlbflush.h
> @@ -22,24 +22,6 @@ static inline void local_flush_tlb_page(unsigned long =
addr)
>  {
>         ALT_FLUSH_TLB_PAGE(__asm__ __volatile__ ("sfence.vma %0" : : "r" =
(addr) : "memory"));
>  }
> -
> -static inline void local_flush_tlb_all_asid(unsigned long asid)
> -{
> -       __asm__ __volatile__ ("sfence.vma x0, %0"
> -                       :
> -                       : "r" (asid)
> -                       : "memory");
> -}
> -
> -static inline void local_flush_tlb_page_asid(unsigned long addr,
> -               unsigned long asid)
> -{
> -       __asm__ __volatile__ ("sfence.vma %0, %1"
> -                       :
> -                       : "r" (addr), "r" (asid)
> -                       : "memory");
> -}
> -
>  #else /* CONFIG_MMU */
>  #define local_flush_tlb_all()                  do { } while (0)
>  #define local_flush_tlb_page(addr)             do { } while (0)
> diff --git a/arch/riscv/mm/context.c b/arch/riscv/mm/context.c
> index 80ce9caba8d2..7acbfbd14557 100644
> --- a/arch/riscv/mm/context.c
> +++ b/arch/riscv/mm/context.c
> @@ -196,16 +196,6 @@ static void set_mm_asid(struct mm_struct *mm, unsign=
ed int cpu)
>
>         if (need_flush_tlb)
>                 local_flush_tlb_all();
> -#ifdef CONFIG_SMP
> -       else {
> -               cpumask_t *mask =3D &mm->context.tlb_stale_mask;
> -
> -               if (cpumask_test_cpu(cpu, mask)) {
> -                       cpumask_clear_cpu(cpu, mask);
> -                       local_flush_tlb_all_asid(cntx & asid_mask);
> -               }
> -       }
> -#endif
>  }
>
>  static void set_mm_noasid(struct mm_struct *mm)
> diff --git a/arch/riscv/mm/tlbflush.c b/arch/riscv/mm/tlbflush.c
> index ce7dfc81bb3f..37ed760d007c 100644
> --- a/arch/riscv/mm/tlbflush.c
> +++ b/arch/riscv/mm/tlbflush.c
> @@ -5,7 +5,23 @@
>  #include <linux/sched.h>
>  #include <asm/sbi.h>
>  #include <asm/mmu_context.h>
> -#include <asm/tlbflush.h>
> +
> +static inline void local_flush_tlb_all_asid(unsigned long asid)
> +{
> +       __asm__ __volatile__ ("sfence.vma x0, %0"
> +                       :
> +                       : "r" (asid)
> +                       : "memory");
> +}
> +
> +static inline void local_flush_tlb_page_asid(unsigned long addr,
> +               unsigned long asid)
> +{
> +       __asm__ __volatile__ ("sfence.vma %0, %1"
> +                       :
> +                       : "r" (addr), "r" (asid)
> +                       : "memory");
> +}
>
>  void flush_tlb_all(void)
>  {
> @@ -15,7 +31,6 @@ void flush_tlb_all(void)
>  static void __sbi_tlb_flush_range(struct mm_struct *mm, unsigned long st=
art,
>                                   unsigned long size, unsigned long strid=
e)
>  {
> -       struct cpumask *pmask =3D &mm->context.tlb_stale_mask;
>         struct cpumask *cmask =3D mm_cpumask(mm);
>         unsigned int cpuid;
>         bool broadcast;
> @@ -29,15 +44,6 @@ static void __sbi_tlb_flush_range(struct mm_struct *mm=
, unsigned long start,
>         if (static_branch_unlikely(&use_asid_allocator)) {
>                 unsigned long asid =3D atomic_long_read(&mm->context.id);
>
> -               /*
> -                * TLB will be immediately flushed on harts concurrently
> -                * executing this MM context. TLB flush on other harts
> -                * is deferred until this MM context migrates there.
> -                */
> -               cpumask_setall(pmask);
> -               cpumask_clear_cpu(cpuid, pmask);
> -               cpumask_andnot(pmask, pmask, cmask);
> -
>                 if (broadcast) {
>                         sbi_remote_sfence_vma_asid(cmask, start, size, as=
id);
>                 } else if (size <=3D stride) {
> --
> 2.39.2
>


--=20
Best Regards
 Guo Ren
