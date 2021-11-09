Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87C1744B2F2
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 19:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242833AbhKITBf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 14:01:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237469AbhKITBe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Nov 2021 14:01:34 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55865C061764
        for <stable@vger.kernel.org>; Tue,  9 Nov 2021 10:58:48 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id z21so491863edb.5
        for <stable@vger.kernel.org>; Tue, 09 Nov 2021 10:58:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ckvWhlaeZh0x0NLJKMOtA/VOUp/j79R2Yub8deg1/GQ=;
        b=M0Tzw8DbmvGOUn03GmXXn+YoiDtzteLno0G10yg+aMIFCv37LjlGdQun3A1TplOvvx
         NYVfn4djLrMqORJ6icc32cQhFKL/66ROcAuNXM2oUKpsWcL2cruvsMc4ImNDXvoB38i3
         ysuWxgseDOEcfZfawVyOmqXC1YtVX1TwaKJecFoIQG7nBFko+lrEajhNVFNtzuJKRZAL
         vFpqcyTqIAWD8/IWJr5txxHEV/c/nSXlr9yGydkbSKO/vh44lTUyGq479r4UrulYKu4b
         +TJTjzyWvnySTxE8Et8d1RcEAH3Kj4JbpgNDYVxa9H/omGofAgPXh0Jbhn9Gp+x3A4eH
         mPbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ckvWhlaeZh0x0NLJKMOtA/VOUp/j79R2Yub8deg1/GQ=;
        b=sHI/hDFcZWpP/ynG/Sw85rCzZBcRPxDiKyLOksFBDm8X+WsNTMCcxFB1WYfHoaJhQ8
         Ir7qXSkaRgkGrqVAxPLQ8hcRjXe/5Vc4JAXYVJ60d5+7pM7gCNTvVs2Vu8XTR/WFUdW4
         Tixvi/vxj839azkMS7nuSR/VZjWv98dnubEW0N4PbfK8KuzxYHyf7l8CpKZhh2xpI7Y4
         k3WPhN8PM287HsSi+FDAbXon0FdO6iYcNPKUNlymxBaNrC8XNC2vVv6MiznMuP+tmrSk
         yzDVVI2qyoLUDCdL+pLnABvQ+xMFOaugwD6s1uWJEOeQsAwglPbLP1mBuB0dLj2an4xS
         spgw==
X-Gm-Message-State: AOAM531SRddgi4l9Z2/QiFdhMuPVRWUuS2aNqmn+akGMfD2FJxbmdgop
        aj2anh6g2qjoADgZgja3SCEvyqb1akrgpNKjcKM32A==
X-Google-Smtp-Source: ABdhPJzP6pBwom/Wu+iYPI2eaL/T7RPrbvAinlFJiBZo4vFgCQtHaNJiWHDBH3wCUVutHb5l2/RoXWe1dESrOmt80Fg=
X-Received: by 2002:a05:6402:28e:: with SMTP id l14mr13192912edv.162.1636484326642;
 Tue, 09 Nov 2021 10:58:46 -0800 (PST)
MIME-Version: 1.0
References: <CADyq12yY25-LS8cV5LY-C=6_0HLPVZbSJCKtCDJm+wyHQSeVTg@mail.gmail.com>
 <cb682c8a-255e-28e5-d4e0-0981c2ab6ffd@intel.com> <85925a39-37c3-a79a-a084-51f2f291ca9c@intel.com>
 <CADyq12y0o=Y1MOMe7pCghy2ZEV2Y0Dd7jm5e=3o2N4-i088MWw@mail.gmail.com>
 <472b8dbf-2c55-98c9-39ad-2db32a649a20@intel.com> <CADyq12whSxPdJhf4qg_w-7YXgEKWx4SDHByNBNZbfWDOeEY-8w@mail.gmail.com>
 <649f4de7-3c91-4974-9af7-d981a2bf6224@www.fastmail.com>
In-Reply-To: <649f4de7-3c91-4974-9af7-d981a2bf6224@www.fastmail.com>
From:   Brian Geffon <bgeffon@google.com>
Date:   Tue, 9 Nov 2021 13:58:10 -0500
Message-ID: <CADyq12wXzitT4y38fUjiWq_Rq4AWQX4Z05Qpyuu-dNBzQc8Gmg@mail.gmail.com>
Subject: Re: XSAVE / RDPKRU on Intel 11th Gen Core CPUs
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Guenter Roeck <groeck@google.com>,
        Borislav Petkov <bp@suse.de>, stable@vger.kernel.org,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Andy,

On Tue, Nov 9, 2021 at 9:58 AM Andy Lutomirski <luto@kernel.org> wrote:
> Here's an excerpt from an old email that I, perhaps unwisely, sent to Dav=
e but not to a public list:
>
> static inline void write_pkru(u32 pkru)
> {
>         struct pkru_state *pk;
>
>         if (!boot_cpu_has(X86_FEATURE_OSPKE))
>                 return;
>
>         pk =3D get_xsave_addr(&current->thread.fpu.state.xsave,
> XFEATURE_PKRU);
>
>         /*
>          * The PKRU value in xstate needs to be in sync with the value
> that is
>          * written to the CPU. The FPU restore on return to userland woul=
d
>          * otherwise load the previous value again.
>          */
>         fpregs_lock();
>         if (pk)
>                 pk->pkru =3D pkru;
>
> ^^^
> else we just write to the PKRU register but leave XINUSE[PKRU] clear on
> return to usermode?  That seems... unwise.
>
>         __write_pkru(pkru);
>         fpregs_unlock();
> }
>
> I bet you're hitting exactly this bug.  The fix ended up being a whole se=
ries of patches, but the gist of it is that the write_pkru() slow path need=
s to set the xfeature bit in the xsave buffer and then do the write.  It sh=
ould be possible to make a little patch to do just this in a couple lines o=
f code.

I think you've got the right idea, the following patch does seem to
fix the problem on this CPU, this is based on 5.13. It seems the
changes to asm/pgtable.h were not enough, I also had to modify
fpu/internal.h to get it working properly.

From e5e184d68ac6ca93c3cd2cc88d61af3260d1c014 Mon Sep 17 00:00:00 2001
From: Brian Geffon <bgeffon@google.com>
Date: Tue, 9 Nov 2021 17:08:25 +0000
Subject: [PATCH] x86/fpu: Set XFEATURE_PKRU when writing to pkru

On kernels prior to 5.14 the write_pkru path could
end up writing to the pkru register without updating
the corresponding state.

Signed-off-by: Brian Geffon <bgeffon@google.com>
---
 arch/x86/include/asm/fpu/internal.h | 22 ++++++++++------------
 arch/x86/include/asm/pgtable.h      |  5 +++--
 2 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/fpu/internal.h
b/arch/x86/include/asm/fpu/internal.h
index 16bf4d4a8159..ed2ce7d1afeb 100644
--- a/arch/x86/include/asm/fpu/internal.h
+++ b/arch/x86/include/asm/fpu/internal.h
@@ -564,18 +564,16 @@ static inline void switch_fpu_finish(struct fpu *new_=
fpu)
         * PKRU state is switched eagerly because it needs to be valid befo=
re we
         * return to userland e.g. for a copy_to_user() operation.
         */
-       if (!(current->flags & PF_KTHREAD)) {
-               /*
-                * If the PKRU bit in xsave.header.xfeatures is not set,
-                * then the PKRU component was in init state, which means
-                * XRSTOR will set PKRU to 0. If the bit is not set then
-                * get_xsave_addr() will return NULL because the PKRU value
-                * in memory is not valid. This means pkru_val has to be
-                * set to 0 and not to init_pkru_value.
-                */
-               pk =3D get_xsave_addr(&new_fpu->state.xsave, XFEATURE_PKRU)=
;
-               pkru_val =3D pk ? pk->pkru : 0;
-       }
+       /*
+        * If the PKRU bit in xsave.header.xfeatures is not set,
+        * then the PKRU component was in init state, which means
+        * XRSTOR will set PKRU to 0. If the bit is not set then
+        * get_xsave_addr() will return NULL because the PKRU value
+        * in memory is not valid. This means pkru_val has to be
+        * set to 0 and not to init_pkru_value.
+        */
+       pk =3D get_xsave_addr(&new_fpu->state.xsave, XFEATURE_PKRU);
+       pkru_val =3D pk ? pk->pkru : 0;
        __write_pkru(pkru_val);
 }

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.=
h
index b1099f2d9800..d00fc2df4cfe 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -137,18 +137,19 @@ static inline u32 read_pkru(void)
 static inline void write_pkru(u32 pkru)
 {
        struct pkru_state *pk;
+       struct fpu *fpu =3D &current->thread.fpu;

        if (!boot_cpu_has(X86_FEATURE_OSPKE))
                return;

-       pk =3D get_xsave_addr(&current->thread.fpu.state.xsave, XFEATURE_PK=
RU);
-
        /*
         * The PKRU value in xstate needs to be in sync with the value that=
 is
         * written to the CPU. The FPU restore on return to userland would
         * otherwise load the previous value again.
         */
+       fpu->state.xsave.header.xfeatures |=3D XFEATURE_MASK_PKRU;
        fpregs_lock();
+       pk =3D get_xsave_addr(&fpu->state.xsave, XFEATURE_PKRU);
        if (pk)
                pk->pkru =3D pkru;
        __write_pkru(pkru);
--=20
2.34.0.rc0.344.g81b53c2807-goog
