Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B09049F6CE
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 11:05:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241004AbiA1KFk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jan 2022 05:05:40 -0500
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:55996
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237493AbiA1KFk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jan 2022 05:05:40 -0500
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 5E3713F1A4
        for <stable@vger.kernel.org>; Fri, 28 Jan 2022 10:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1643364338;
        bh=O2AwCzmYc8oJyRvt38Q3eFdAEi62fT7JJ41T7HDRaZY=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=jFynAPC5jS3TuSW0DwBFoBtJMNpyruFX8Ud/SKY65dHlfFes688+9yvc2QTtU+4bn
         L+fKJrSxitVSAHYJS0Lb+lLPdLNGVSkUQWVAO8AmIXdD9/0T9pXt/nlKX2Dg5JZLvg
         H8BjAwM5L0VoO7mDKvh7sbWtnRYDMn8tRNFmfzuHyGPOIvRAxcWk6hRGxyfrBa42ly
         M84OT647Chcd/U3H8T1CzYex/OEjWSKoUMR3kpTmI5/1/LWKK2Sw02hIIZBPuKNear
         bgOKMy5GSRw6czM5B5u2tVYp4mrImUzZjAYDfSiGZ7rxJNJU0a8OjkiHgfe9iZz7uy
         cgbx9VXJCrjeg==
Received: by mail-ed1-f72.google.com with SMTP id w23-20020a50d797000000b00406d33c039dso2819481edi.11
        for <stable@vger.kernel.org>; Fri, 28 Jan 2022 02:05:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O2AwCzmYc8oJyRvt38Q3eFdAEi62fT7JJ41T7HDRaZY=;
        b=2m7+Gs8kjlKhCNxWkRk4Suu+CmPTCDS43mEwYRc7oTlQp+yX/GNSOvkcd9RYRlCMuW
         uW+OBY9T5KOKjl1THB5APmY/Yw6rsZocnaPF5YSIYJzY0BNjNmVUxiJpmSt0mbGKROHp
         gK6YarFU0m2PS1ulRQ2HGEYatyCvA4M0B3Zp6g/R+MdSw0mSXaWeFnRe5WtUoYGIglik
         QBAO6uAQHEFh0Wqo0RlIlZCWbAtywt8Ti72HL9KFDqxOkl3XxztaNlOdxh89F8tBnPrD
         1jJZvwCs+11gunwneFtDsC13P03it1gzxaUCUsiyUQrNvoOY+hvyyplM1EsE3zYklVZ6
         /YVQ==
X-Gm-Message-State: AOAM531WjDoUfN7lC4btHHNkRNSTByjh/YXLis214AN51VxhOMCRph0c
        PIn8UiDD//VN3aiurZkB1CzvRpCHPZoYtVsL2DkaeI6NFkKYkpYcIe5KqtM7Y4mhBFYiqpsyBro
        lnKwoxRuomZMz6JrQnGEyyzCAc4wF5hseK898GoV8TqmjZDe/Tw==
X-Received: by 2002:a05:6402:424a:: with SMTP id g10mr7509437edb.309.1643364337995;
        Fri, 28 Jan 2022 02:05:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzsVnSwgUFr96As1FnWBQoNDpcCVx1aZj6cMWJvV98yVlEvSPf2G1oW4NedbPBIYoEh/UJEBA7P84mQwLL5yCU=
X-Received: by 2002:a05:6402:424a:: with SMTP id g10mr7509413edb.309.1643364337738;
 Fri, 28 Jan 2022 02:05:37 -0800 (PST)
MIME-Version: 1.0
References: <20220126171442.1338740-1-aurelien@aurel32.net>
In-Reply-To: <20220126171442.1338740-1-aurelien@aurel32.net>
From:   Alexandre Ghiti <alexandre.ghiti@canonical.com>
Date:   Fri, 28 Jan 2022 11:05:26 +0100
Message-ID: <CA+zEjCvwsM=DaUqB8Hv_=dXRdauz6hjeFE1MK_A6=QjrsW2EyQ@mail.gmail.com>
Subject: Re: [PATCH] riscv: fix build with binutils 2.38
To:     Aurelien Jarno <aurelien@aurel32.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Kito Cheng <kito.cheng@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        "open list:RISC-V ARCHITECTURE" <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Aurelien,

On Wed, Jan 26, 2022 at 6:41 PM Aurelien Jarno <aurelien@aurel32.net> wrote:
>
> From version 2.38, binutils default to ISA spec version 20191213. This
> means that the csr read/write (csrr*/csrw*) instructions and fence.i
> instruction has separated from the `I` extension, become two standalone
> extensions: Zicsr and Zifencei. As the kernel uses those instruction,
> this causes the following build failure:
>
>   CC      arch/riscv/kernel/vdso/vgettimeofday.o
>   <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h: Assembler messages:
>   <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h:71: Error: unrecognized opcode `csrr a5,0xc01'
>   <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h:71: Error: unrecognized opcode `csrr a5,0xc01'
>   <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h:71: Error: unrecognized opcode `csrr a5,0xc01'
>   <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h:71: Error: unrecognized opcode `csrr a5,0xc01'
>
> The fix is to specify those extensions explicitely in -march. However as
> older binutils version do not support this, we first need to detect
> that.
>
> Cc: stable@vger.kernel.org # 4.15+
> Cc: Kito Cheng <kito.cheng@gmail.com>
> Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
> ---
>  arch/riscv/Makefile | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
> index 8a107ed18b0d..7d81102cffd4 100644
> --- a/arch/riscv/Makefile
> +++ b/arch/riscv/Makefile
> @@ -50,6 +50,12 @@ riscv-march-$(CONFIG_ARCH_RV32I)     := rv32ima
>  riscv-march-$(CONFIG_ARCH_RV64I)       := rv64ima
>  riscv-march-$(CONFIG_FPU)              := $(riscv-march-y)fd
>  riscv-march-$(CONFIG_RISCV_ISA_C)      := $(riscv-march-y)c
> +
> +# Newer binutils versions default to ISA spec version 20191213 which moves some
> +# instructions from the I extension to the Zicsr and Zifencei extensions.
> +toolchain-need-zicsr-zifencei := $(call cc-option-yn, -march=$(riscv-march-y)_zicsr_zifencei)
> +riscv-march-$(toolchain-need-zicsr-zifencei) := $(riscv-march-y)_zicsr_zifencei
> +
>  KBUILD_CFLAGS += -march=$(subst fd,,$(riscv-march-y))
>  KBUILD_AFLAGS += -march=$(riscv-march-y)
>
> --
> 2.34.1
>
>

That fixes our kernel build with the new binutils, so you can add:

Tested-by: Alexandre Ghiti <alexandre.ghiti@canonical.com>

Thanks for working on this!

Alex

> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv
