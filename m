Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA3B82DDCF7
	for <lists+stable@lfdr.de>; Fri, 18 Dec 2020 03:37:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730486AbgLRChm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Dec 2020 21:37:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728578AbgLRChm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Dec 2020 21:37:42 -0500
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F703C0617A7;
        Thu, 17 Dec 2020 18:37:02 -0800 (PST)
Received: by mail-qt1-x82d.google.com with SMTP id c14so422635qtn.0;
        Thu, 17 Dec 2020 18:37:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=eLeNkTbh4DSc6M1hh6DNaHMv8Lj9zN6vPFWfAXZNwaY=;
        b=mmrDUgHBSjvMD2nn3XQbwAGrHQWS+6MZPQEb1oZn5xg62coWOgcnZ8haMtMJbuZU2e
         4lkeS1JlJYnHvKo/FpldtZSEkvhrqx1w7O9qp7pL2tHUEls+Vt53Om///vYe5r6TnWLi
         4SUdtI4z+MLe3It0idX+zdDtaCfFO9YMjndydd/zwk7rMX62kihdjXYQ0q1Ux5/euws9
         O815K9q93NmfNp+z6AgrXpg04/eXgfMZHbAVN0IFEyUkGknFZChBQRK1/zTqhc5TwXyR
         HLhMUp3h9A6QEM50kA/2vUbvOrjwIGZB3RF/jpPyeo3jxU0/rBVo8puEx2XkhendX0lW
         8STw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=eLeNkTbh4DSc6M1hh6DNaHMv8Lj9zN6vPFWfAXZNwaY=;
        b=BzF4CdWaLmBxyARhvgWIvBRLe4NErPqk5xryHSIt8nqco9GfK2pmGrOgI0xMufKkbG
         Cqksd36kf8beQkMmoL8AiNAfjlisXrDJEb0sgh3BPfNduttobdUhZXlWDi+sOpQTU55g
         oWswm3z3tOICWQV+Us1g4r5MnA4kTliGz80up2apfDPO+yfapPawUayojGtxtrrXcNRD
         s4JeEdN+p8nJHrfDQ+s+EksD5EwNDlnddMVXqxAxAS50TPdq39ovpBDny7NJ4QIZPhGg
         5JbthYWIGBZpx+pr8HRQbMc+ic6MlexgzhAcysmks/QeCMpdkV1flI7eZi7LVLiJdXH0
         xkPA==
X-Gm-Message-State: AOAM532GvAwKo5PQbuRZ1vFlseZSB7Uy9IdCXws1FF2Txn7Xw2Ae84FI
        PIQWwZMcgZK4Oa19vU8Hey4=
X-Google-Smtp-Source: ABdhPJxGss/SAuvfMsh8jZ4y8fcmFs98NxJ4B2z3d6gxBRniMhY9u0UP6oGV6EvV+EuPh0kQG32O4Q==
X-Received: by 2002:ac8:720c:: with SMTP id a12mr1981900qtp.42.1608259021374;
        Thu, 17 Dec 2020 18:37:01 -0800 (PST)
Received: from ubuntu-m3-large-x86 ([2604:1380:45f1:1d00::1])
        by smtp.gmail.com with ESMTPSA id b78sm214183qkg.29.2020.12.17.18.37.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Dec 2020 18:37:00 -0800 (PST)
Date:   Thu, 17 Dec 2020 19:36:58 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        kernel-team <kernel-team@android.com>,
        Peter Smith <Peter.Smith@arm.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        stable <stable@vger.kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        =?utf-8?B?RsSBbmctcnXDrCBTw7JuZw==?= <maskray@google.com>,
        Quentin Perret <qperret@google.com>,
        Alan Modra <amodra@gmail.com>,
        "kernelci . org bot" <bot@kernelci.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] arm64: link with -z norelro for LLD or aarch64-elf
Message-ID: <20201218023658.GA577188@ubuntu-m3-large-x86>
References: <CAKwvOd=LZHzR11kuhT2EjFnUdFwu5hQmxiwqeLB2sKC0hWFY=g@mail.gmail.com>
 <20201218002432.788499-1-ndesaulniers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201218002432.788499-1-ndesaulniers@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 17, 2020 at 04:24:32PM -0800, 'Nick Desaulniers' via Clang Built Linux wrote:
> With GNU binutils 2.35+, linking with BFD produces warnings for vmlinux:
> aarch64-linux-gnu-ld: warning: -z norelro ignored
> 
> BFD can produce this warning when the target emulation mode does not
> support RELRO program headers, and -z relro or -z norelro is passed.
> 
> Alan Modra clarifies:
>   The default linker emulation for an aarch64-linux ld.bfd is
>   -maarch64linux, the default for an aarch64-elf linker is
>   -maarch64elf.  They are not equivalent.  If you choose -maarch64elf
>   you get an emulation that doesn't support -z relro.
> 
> The ARCH=arm64 kernel prefers -maarch64elf, but may fall back to
> -maarch64linux based on the toolchain configuration.
> 
> LLD will always create RELRO program header regardless of target
> emulation.
> 
> To avoid the above warning when linking with BFD, pass -z norelro only
> when linking with LLD or with -maarch64linux.
> 
> Cc: Alan Modra <amodra@gmail.com>
> Cc: Fāng-ruì Sòng <maskray@google.com>
> Fixes: 3b92fa7485eb ("arm64: link with -z norelro regardless of CONFIG_RELOCATABLE")
> Reported-by: kernelci.org bot <bot@kernelci.org>
> Reported-by: Quentin Perret <qperret@google.com>
> Acked-by: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>

Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>

> ---
> Changes V1 -> V2:
> * s/relocation types/program headers/
> * s/newer GNU binutils/GNU binutils 2.35+/
> * Pick up Ard's Ack.
> 
> Note: maintainers may want to pick up the following tag:
> 
> Fixes: 3bbd3db86470 ("arm64: relocatable: fix inconsistencies in linker script and options")
> 
> or drop the existing fixes tag (this patch is more so in response to
> change to BFD to warn than fix a kernel regression, IMO, but I don't
> care). Either way, it would be good to fix this for the newly minted
> v5.10.y.

Should probably have

Cc: stable@vger.kernel.org

then.

> I'll probably be offline for the next two weeks for the holidays, so no
> promises on quick replies. Happy holidays+new year!
> 
> 
>  arch/arm64/Makefile | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
> index 6be9b3750250..90309208bb28 100644
> --- a/arch/arm64/Makefile
> +++ b/arch/arm64/Makefile
> @@ -10,7 +10,7 @@
>  #
>  # Copyright (C) 1995-2001 by Russell King
>  
> -LDFLAGS_vmlinux	:=--no-undefined -X -z norelro
> +LDFLAGS_vmlinux	:=--no-undefined -X
>  
>  ifeq ($(CONFIG_RELOCATABLE), y)
>  # Pass --no-apply-dynamic-relocs to restore pre-binutils-2.27 behaviour
> @@ -115,16 +115,20 @@ KBUILD_CPPFLAGS	+= -mbig-endian
>  CHECKFLAGS	+= -D__AARCH64EB__
>  # Prefer the baremetal ELF build target, but not all toolchains include
>  # it so fall back to the standard linux version if needed.
> -KBUILD_LDFLAGS	+= -EB $(call ld-option, -maarch64elfb, -maarch64linuxb)
> +KBUILD_LDFLAGS	+= -EB $(call ld-option, -maarch64elfb, -maarch64linuxb -z norelro)
>  UTS_MACHINE	:= aarch64_be
>  else
>  KBUILD_CPPFLAGS	+= -mlittle-endian
>  CHECKFLAGS	+= -D__AARCH64EL__
>  # Same as above, prefer ELF but fall back to linux target if needed.
> -KBUILD_LDFLAGS	+= -EL $(call ld-option, -maarch64elf, -maarch64linux)
> +KBUILD_LDFLAGS	+= -EL $(call ld-option, -maarch64elf, -maarch64linux -z norelro)
>  UTS_MACHINE	:= aarch64
>  endif
>  
> +ifeq ($(CONFIG_LD_IS_LLD), y)
> +KBUILD_LDFLAGS	+= -z norelro
> +endif
> +
>  CHECKFLAGS	+= -D__aarch64__
>  
>  ifeq ($(CONFIG_DYNAMIC_FTRACE_WITH_REGS),y)
> -- 
> 2.29.2.684.gfbc64c5ab5-goog
> 
