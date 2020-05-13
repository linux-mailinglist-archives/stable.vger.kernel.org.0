Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19D0A1D0FDE
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 12:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732485AbgEMKcY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 06:32:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727794AbgEMKcX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 May 2020 06:32:23 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 828CAC061A0C
        for <stable@vger.kernel.org>; Wed, 13 May 2020 03:32:23 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id w10so6466324ljo.0
        for <stable@vger.kernel.org>; Wed, 13 May 2020 03:32:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=kgV1PH6IdI+/Z8CIXoSiBHCJgvfZ9K5954ASAiVs5C8=;
        b=zEmxlB7PoUsxMJz/Hk9ivN/qplHBf/NBwwIS3XRsbMtwFeqttUE3v1MQtWr5Q8rRPo
         PqnjmeFC2xrjbZuPZgeBuwNIgRO2/UY5I/5tyI1s5uiU5VQz/CbBE69XmL/Kd/qcrOxA
         11qQU7Lyvza2p3R1k/I0UxNQLd9FAuFBGgf4Wz7FBUhkZaL2NgAS8sCblYuX0bgom027
         aECc2J+YC28+H5H8lWP6A9UKnyLs2S8+Xv2Bcd7uyvt6CXER6DYy5ei0IprTRwbAkpRh
         Ckz+mpZP9xf1mxxxwJ4pQ/17A1p4Gy32JoGvbX3fkerkR+NeklnZAJLXHw/BRsLcEorw
         vfIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=kgV1PH6IdI+/Z8CIXoSiBHCJgvfZ9K5954ASAiVs5C8=;
        b=UXoWp4cqv/XtoKgYM/K4ZjqYUVpmoHuyUuATi6DkJDE1Clp3KjeoxSgvg14RJrfHD5
         4UoKX8Axrzj+eKlop7HtonNpfDnudgThfNSdigI6yNLBnEWKuOlxFGBUDaSmuxQTq7Xp
         OKl8GR02g6Yy/8JFMjKbN+WzKJNtW4tpPDZDcygzPmxZJA7dqa77Iv+RFDVfQirVHQMH
         22LSKoEbgCb//iixG4GJ7Xvl9+ikEB0Zzon/nnqut6SsVaDkWFmfVu91TbNJ62rMtSI+
         lJiXRYCHU2HSFAK1/tRF4o8tFK6+O8/ms1za8zgkFv2Ox+FD5UhTF9/Z9zArWeEreSSF
         wFMw==
X-Gm-Message-State: AOAM530esndoxDS/0+EP/lcI0RujX1z4dLVLO3jd/jqOUmNMPGrDe3S6
        9l+bIB4m3pco63MDwneQk7ld4MVxroN3VU/q7kD2+A==
X-Google-Smtp-Source: ABdhPJwrE5MR0Z3Lgel2dOA+n6bI6qjbtbjRYYl978azmhVUrEawbknTFZJo7BYsDw9RhdRCbjmMRRJ7OoHIN3fAFkM=
X-Received: by 2002:a2e:8912:: with SMTP id d18mr17369817lji.123.1589365940899;
 Wed, 13 May 2020 03:32:20 -0700 (PDT)
MIME-Version: 1.0
References: <158928280292134@kroah.com>
In-Reply-To: <158928280292134@kroah.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 13 May 2020 16:02:09 +0530
Message-ID: <CA+G9fYvoMhYHihJCq9eF7F0YwaL+s-n7nzPERmzbr08iL_Jwgw@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] arm64: hugetlb: avoid potential NULL
 dereference" failed to apply to 4.9-stable tree
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Mark Rutland <mark.rutland@arm.com>, catalin.marinas@arm.com,
        kyrylo.tkachov@arm.com, linux- stable <stable@vger.kernel.org>,
        Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 12 May 2020 at 16:56, <gregkh@linuxfoundation.org> wrote:
>
>
> The patch below does not apply to the 4.9-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
>
> thanks,
>
> greg k-h
>
> ------------------ original commit in Linus's tree ------------------
>
> From 027d0c7101f50cf03aeea9eebf484afd4920c8d3 Mon Sep 17 00:00:00 2001
> From: Mark Rutland <mark.rutland@arm.com>
> Date: Tue, 5 May 2020 13:59:30 +0100
> Subject: [PATCH] arm64: hugetlb: avoid potential NULL dereference
> MIME-Version: 1.0
> Content-Type: text/plain; charset=3DUTF-8
> Content-Transfer-Encoding: 8bit
>
> The static analyzer in GCC 10 spotted that in huge_pte_alloc() we may
> pass a NULL pmdp into pte_alloc_map() when pmd_alloc() returns NULL:
>
> |   CC      arch/arm64/mm/pageattr.o
> |   CC      arch/arm64/mm/hugetlbpage.o
> |                  from arch/arm64/mm/hugetlbpage.c:10:
> | arch/arm64/mm/hugetlbpage.c: In function =E2=80=98huge_pte_alloc=E2=80=
=99:
> | ./arch/arm64/include/asm/pgtable-types.h:28:24: warning: dereference of=
 NULL =E2=80=98pmdp=E2=80=99 [CWE-690] [-Wanalyzer-null-dereference]
> | ./arch/arm64/include/asm/pgtable.h:436:26: note: in expansion of macro =
=E2=80=98pmd_val=E2=80=99
> | arch/arm64/mm/hugetlbpage.c:242:10: note: in expansion of macro =E2=80=
=98pte_alloc_map=E2=80=99
> |     |arch/arm64/mm/hugetlbpage.c:232:10:
> |     |./arch/arm64/include/asm/pgtable-types.h:28:24:
> | ./arch/arm64/include/asm/pgtable.h:436:26: note: in expansion of macro =
=E2=80=98pmd_val=E2=80=99
> | arch/arm64/mm/hugetlbpage.c:242:10: note: in expansion of macro =E2=80=
=98pte_alloc_map=E2=80=99
>
> This can only occur when the kernel cannot allocate a page, and so is
> unlikely to happen in practice before other systems start failing.
>
> We can avoid this by bailing out if pmd_alloc() fails, as we do earlier
> in the function if pud_alloc() fails.
>
> Fixes: 66b3923a1a0f ("arm64: hugetlb: add support for PTE contiguous bit"=
)
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Reported-by: Kyrill Tkachov <kyrylo.tkachov@arm.com>
> Cc: <stable@vger.kernel.org> # 4.5.x-
> Cc: Will Deacon <will@kernel.org>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
>
> diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
> index bbeb6a5a6ba6..0be3355e3499 100644
> --- a/arch/arm64/mm/hugetlbpage.c
> +++ b/arch/arm64/mm/hugetlbpage.c
> @@ -230,6 +230,8 @@ pte_t *huge_pte_alloc(struct mm_struct *mm,
>                 ptep =3D (pte_t *)pudp;
>         } else if (sz =3D=3D (CONT_PTE_SIZE)) {
>                 pmdp =3D pmd_alloc(mm, pudp, addr);
> +               if (!pmdp)
> +                       return NULL;
>
>                 WARN_ON(addr & (sz - 1));
>                 /*
>

on stable-rc 4.9 branch arm64 architecture build failed.

  CC      arch/arm64/mm/hugetlbpage.o
arch/arm64/mm/hugetlbpage.c: In function 'huge_pte_alloc':
arch/arm64/mm/hugetlbpage.c:106:8: error: 'pmdp' undeclared (first use
in this function); did you mean 'pmd'?
   if (!pmdp)
        ^~~~
        pmd
arch/arm64/mm/hugetlbpage.c:106:8: note: each undeclared identifier is
reported only once for each function it appears in
scripts/Makefile.build:304: recipe for target
'arch/arm64/mm/hugetlbpage.o' failed

ref:
https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-4.9/D=
ISTRO=3Dlkft,MACHINE=3Dhikey,label=3Ddocker-lkft/893/consoleText

--=20
Linaro LKFT
https://lkft.linaro.org
