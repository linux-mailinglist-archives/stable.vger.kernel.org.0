Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA8DA6012DF
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 17:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbiJQPqO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 11:46:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229594AbiJQPqN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 11:46:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBEA0FD3F;
        Mon, 17 Oct 2022 08:46:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 743E1B81913;
        Mon, 17 Oct 2022 15:46:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27D8FC4347C;
        Mon, 17 Oct 2022 15:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666021570;
        bh=9c9EEzyY7oUq22Pd8vm1w2MFf4GstXJ90YPs3mnWmLo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=AYSVM4vwMV3llm4rCDTm0OzgGQO40L+/twQp/M5dsO8yIR6g3EMA4DmOdFaNGtODx
         TTexZOultQS63kRoGHhk6Ck0nSF1crSdh6LzxIaqA/U3VQNifxlXcN+agm46PKxvnn
         DBmVyT13PdRIopBEGqE0Ui1h6AX0IOePMK8W2L2p7j9zDAglKigPF8G6+qMpKCAtpO
         WNT9PdO8COcagSErSVSLPJ5xYxfkqcwgXTILM1y39NRBM4IFwuF2SUsS0iJyFSfBjf
         DDdXTImzmTsPjC5+4JOJeLJNwcM2BrJaWhZ+Ccbbz2UkC0pzTYJAThtC3yc/OMSr3p
         W1vSeu37OAM7g==
Received: by mail-lj1-f174.google.com with SMTP id r22so14431853ljn.10;
        Mon, 17 Oct 2022 08:46:10 -0700 (PDT)
X-Gm-Message-State: ACrzQf1KKyt1AOR2ktHLdZLw50dly/KhO9c389yM2Sv551Av5Op3VOLh
        aKs8LeLLNHJBzcoS3F2OOhw+wV+Cp0c+tp1WzzQ=
X-Google-Smtp-Source: AMsMyM7peUSTpBSPbo/vvPo6cWQeSx8q4yW3epDEX81Vp1cXfv9UMJT4N9U2CYjhXT7rI/J+VTkiB62AR3KCHYaAbKU=
X-Received: by 2002:a2e:b635:0:b0:26e:989e:438f with SMTP id
 s21-20020a2eb635000000b0026e989e438fmr3934831ljn.189.1666021568087; Mon, 17
 Oct 2022 08:46:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220929152010.835906-1-nathan@kernel.org>
In-Reply-To: <20220929152010.835906-1-nathan@kernel.org>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 17 Oct 2022 17:45:56 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFTXV8swyypu9j3rM4u1hO1wyb2atUJm32HB_X29sPBHQ@mail.gmail.com>
Message-ID: <CAMj1kXFTXV8swyypu9j3rM4u1hO1wyb2atUJm32HB_X29sPBHQ@mail.gmail.com>
Subject: Re: [PATCH] x86/Kconfig: Drop check for '-mabi=ms' for CONFIG_EFI_STUB
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, patches@lists.linux.dev,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 29 Sept 2022 at 17:20, Nathan Chancellor <nathan@kernel.org> wrote:
>
> A recent change in LLVM made CONFIG_EFI_STUB unselectable because it no
> longer pretends to support '-mabi=ms', breaking the dependency in
> Kconfig. Lack of CONFIG_EFI_STUB can prevent kernels from booting via
> EFI in certain circumstances.
>
> This check was added by commit 8f24f8c2fc82 ("efi/libstub: Annotate
> firmware routines as __efiapi") to ensure that '__attribute__((ms_abi))'
> was available, as '-mabi=ms' is not actually used in any cflags.
> According to the GCC documentation, this attribute has been supported
> since GCC 4.4.7. The kernel currently requires GCC 5.1 so this check is
> not necessary; even when that change landed in 5.6, the kernel required
> GCC 4.9 so it was unnecessary then as well.  Clang supports
> '__attribute__((ms_abi))' for all versions that are supported for
> building the kernel so no additional check is needed. Remove the
> 'depends on' line altogether to allow CONFIG_EFI_STUB to be selected
> when CONFIG_EFI is enabled, regardless of compiler.
>
> Cc: stable@vger.kernel.org
> Fixes: 8f24f8c2fc82 ("efi/libstub: Annotate firmware routines as __efiapi")
> Link: https://github.com/ClangBuiltLinux/linux/issues/1725
> Link: https://gcc.gnu.org/onlinedocs/gcc-4.4.7/gcc/Function-Attributes.html
> Link: https://github.com/llvm/llvm-project/commit/d1ad006a8f64bdc17f618deffa9e7c91d82c444d
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

I can take this as a EFI fix as well.

> ---
>  arch/x86/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index f9920f1341c8..81012154d9ed 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1956,7 +1956,6 @@ config EFI
>  config EFI_STUB
>         bool "EFI stub support"
>         depends on EFI
> -       depends on $(cc-option,-mabi=ms) || X86_32
>         select RELOCATABLE
>         help
>           This kernel feature allows a bzImage to be loaded directly
>
> base-commit: f76349cf41451c5c42a99f18a9163377e4b364ff
> --
> 2.37.3
>
