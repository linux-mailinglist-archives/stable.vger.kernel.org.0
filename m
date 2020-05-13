Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7CE91D104C
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 12:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730299AbgEMKxZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 06:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728113AbgEMKxY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 May 2020 06:53:24 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EB71C061A0C
        for <stable@vger.kernel.org>; Wed, 13 May 2020 03:53:24 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id o14so16184174ljp.4
        for <stable@vger.kernel.org>; Wed, 13 May 2020 03:53:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CuomZUNJxY2EpZsIzxvF7exIxORVQ8kM+PEKcmhZrds=;
        b=Z7bv+0eaAHZ7Ul+hnsQNZVUxd83l397Utp7ElR9GsEePL8b9FC+t4aKC9UWWwe83WD
         6kozouZAHT1+ih1l8hgzDumLvB0bfgI/rt0sXFzprCoYptS6LjKPGsokt9oxGvxc1rCX
         MLcbM2WpiYoBm0wnb7+c+AK6DNv/LbqvOLq4rX4x22rdVt9k0NGIWyTTSOKl8m3YdslM
         iSPbvbiLX/MHdKAszO21jKkEcSR//xjG2gruiZJQYUq989Iwxu+8amA5ANAYi5no5RfX
         IpXBeagpJzUPrCFpH3EbsjHx92QgN3DzyknNVPuqsCrr5fokwTfkm52bZXphjnidGv0g
         lTKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CuomZUNJxY2EpZsIzxvF7exIxORVQ8kM+PEKcmhZrds=;
        b=U2YasfGgIiE2J8zfiOmyKFggYmCnoBsarRU6PZ3VVd3n0YSl3uxTSfaj9BFRaPWaOP
         p/En35ixX4fTGQUqGv95bIeCVef9znqXhS4lkAjHEXcNEGDPZN9AKeFXEAB4d7oP6LeJ
         tx0MiiMNVp4c3Lky9mZV+iYca8tiT4pfYfYdtAWU6XDG3e+R0sovC1vUkoLoFglKWGWX
         6qBUx8ecNsiD1Yb0pW55b6Z795/OUb2AG+hmI21yBMD0Z8S3d2TCJ3WBUKFK9Qd5uf5X
         n3xBkT7kwSCFGZJ381b4uYNnHDCfjl3dXtx2dtGa0IH3Sp3lnSoyZGqZjNX9E+UUAcMD
         b0uQ==
X-Gm-Message-State: AOAM531OJxuzcXZFbW8hHOxwOKFQBBSo3x6hiibgTPtOC+859dhm2Dmn
        5RwUZbw6rtHS2j8xup8K/tebQWvesmRkkfStLygnJA==
X-Google-Smtp-Source: ABdhPJxuAYu03U+4GhW2XOHE2bX0tFLPDPOhblKUAGv5xUqXKzdpIvU2R3y0x0inx7UnsVk/IpRRyJx8k2BXKnZ1jGs=
X-Received: by 2002:a05:651c:1103:: with SMTP id d3mr6173579ljo.38.1589367202641;
 Wed, 13 May 2020 03:53:22 -0700 (PDT)
MIME-Version: 1.0
References: <15892828013114@kroah.com>
In-Reply-To: <15892828013114@kroah.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 13 May 2020 16:23:11 +0530
Message-ID: <CA+G9fYt_BmF2t+3S1_yD0KZ3d8OE1W_tQH2pROo1E1GLgm0aBA@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] arm64: hugetlb: avoid potential NULL
 dereference" failed to apply to 4.14-stable tree
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
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
> The patch below does not apply to the 4.14-stable tree.
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

As per the subject this patch failed to apply on 4.14
FYI,
on stable-rc 4.14 branch arm64 architecture build failed.

 # make -sk KBUILD_BUILD_USER=3DTuxBuild -C/linux -j16 ARCH=3Darm64
CROSS_COMPILE=3Daarch64-linux-gnu- HOSTCC=3Dgcc CC=3D"sccache
aarch64-linux-gnu-gcc" O=3Dbuild Image
70 #
71 ../arch/arm64/mm/hugetlbpage.c: In function =E2=80=98huge_pte_alloc=E2=
=80=99:
72 ../arch/arm64/mm/hugetlbpage.c:223:8: error: =E2=80=98pmdp=E2=80=99 unde=
clared
(first use in this function); did you mean =E2=80=98pmd=E2=80=99?
73  223 | if (!pmdp)
74  | ^~~~
75  | pmd
76 ../arch/arm64/mm/hugetlbpage.c:223:8: note: each undeclared
identifier is reported only once for each function it appears in
77 make[2]: *** [../scripts/Makefile.build:326:
arch/arm64/mm/hugetlbpage.o] Error 1

ref:
https://gitlab.com/Linaro/lkft/kernel-runs/-/jobs/550145375

--=20
Linaro LKFT
https://lkft.linaro.org
