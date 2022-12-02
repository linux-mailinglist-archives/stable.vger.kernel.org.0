Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC189640262
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 09:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231649AbiLBIkL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Dec 2022 03:40:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232721AbiLBIjv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Dec 2022 03:39:51 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84BC610FF3
        for <stable@vger.kernel.org>; Fri,  2 Dec 2022 00:39:45 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id d18so2682082iof.6
        for <stable@vger.kernel.org>; Fri, 02 Dec 2022 00:39:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uHMoD/DcrhObTGtyvyKEig8wHn7CtcVTXrQ4ciasUkM=;
        b=JnXkfoFq7hb5GNb8lyWcXA//VaK0QvOA+CpsnlLhjtGk/vicAEoolpKw3/6044ildC
         HAYIX8MfXJ49PDjbHXWmMFDTaR0CH+ZhQrs1XwGRHP3IIyImxckBaOFK9yyaCk7AIJSg
         C46zmAx4VHTTe8uzvUneLbW7Ma+M8EYqqdNw3yevC0CrxwD6TgYDzWcky8zM7UAWZxKq
         cRLeRQYIIy0kU7bFpUYZ5ntA0ybx9Og3/6jYUbdbjlvOTHcZbFfFUy1otbq0Jy3/muri
         wmpGYoVFBglbeRWCZa4Urowy4APUojbeQgCPCzYCVsh5pC4pNeFVd71gypdw6uVPln15
         qKYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uHMoD/DcrhObTGtyvyKEig8wHn7CtcVTXrQ4ciasUkM=;
        b=NLM5iyusahFxcxHVP38GK2a9DZmFzVGcKnia3LsZLuq/gXhh1wBKkFLR5ED44IwFbO
         h1tEsUApl0E+lx2lC5e6e7KH+g/cXA3GRGk65CHUAp8uB45nHatvzQNTr/yCwjOQ7Wog
         DCZDbUjXKq3BUU8BUA022NyFKAzcApW6PQD52fMRjbdVT5Bx98TiKs7mvdoV38kSqTG4
         BtIJIUTkXZFaNysmbxiCQlLBywI6ziVeDFmOq0afcHcu1mpLPU/Zjk5seHv/tN9xB4jh
         Ui9mjoZUvJnsmmZXR7q3eZEJN2PXeMNmRFRzl1xH7Y3JOPfj9i04fCZPBZEQM2Z75yLy
         hIrw==
X-Gm-Message-State: ANoB5pnJNe+Q6trfwyZrrKcOk2swT0ARdQnUOh+YODzVQO3ApCWcvR4H
        IgW+J19S19aJf+B7d3Wee0pBrX1SBo6w3jufZTHuqA==
X-Google-Smtp-Source: AA0mqf4JiwQnAyPsXCWrNbTSZVfNVE6Y+b/uABBIXoE9/WT+6EniEpMZGgn/Las+wt5J8BW7NftFFpYE6E9BR7+lwjQ=
X-Received: by 2002:a02:cc4d:0:b0:373:2fc2:96d7 with SMTP id
 i13-20020a02cc4d000000b003732fc296d7mr27723585jaq.177.1669970384908; Fri, 02
 Dec 2022 00:39:44 -0800 (PST)
MIME-Version: 1.0
References: <CA+G9fYuNirzmuQvYpH6gYiAr_fqh9g-+RP83FW3oLbty9iKbyw@mail.gmail.com>
 <868rjrmmv2.wl-maz@kernel.org>
In-Reply-To: <868rjrmmv2.wl-maz@kernel.org>
From:   Anders Roxell <anders.roxell@linaro.org>
Date:   Fri, 2 Dec 2022 09:39:33 +0100
Message-ID: <CADYN=9KSKQx816id-zWepV-E3ozph3k2_i9Rhs6QseFv0hkPfg@mail.gmail.com>
Subject: Re: stable-rc-5.10: arm64: allmodconfig: (.hyp.text+0x1a4c):
 undefined reference to `__kvm_nvhe_memset'
To:     Marc Zyngier <maz@kernel.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        linux-stable <stable@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        lkft-triage@lists.linaro.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 1 Dec 2022 at 11:36, Marc Zyngier <maz@kernel.org> wrote:
>
> On Thu, 01 Dec 2022 09:39:57 +0000,
> Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> >
> > [please ignore if it is already reported]
> >
> > The stable-rc 5.10 arm64 allmodconfig builds failed with gcc-12.
> > List of build warnings and errors with gcc-12 are listed below.
> >
> > aarch64-linux-gnu-ld: Unexpected GOT/PLT entries detected!
> > aarch64-linux-gnu-ld: Unexpected run-time procedure linkages detected!
> > aarch64-linux-gnu-ld: arch/arm64/kvm/hyp/nvhe/kvm_nvhe.o: in function
> > `__kvm_nvhe___kvm_tlb_flush_vmid_ipa':
> > (.hyp.text+0x1a4c): undefined reference to `__kvm_nvhe_memset'
>
> Stupid gcc. Can you try the following patch and check if this works
> for you?

The patch didn't apply smodly, was a few minor issues.
But it solved the build error.

Cheers,
Anders

>
> Thanks,
>
>         M.
>
> From 4e775885654bd667a519df5ca5aaf702ce438f5e Mon Sep 17 00:00:00 2001
> From: Will Deacon <will@kernel.org>
> Date: Fri, 19 Mar 2021 10:01:10 +0000
> Subject: [PATCH] KVM: arm64: Link position-independent string routines into
>  .hyp.text
>
> Commit 7b4a7b5e6fefd15f708f959dd43e188444e252ec upstream.
>
> Pull clear_page(), copy_page(), memcpy() and memset() into the nVHE hyp
> code and ensure that we always execute the '__pi_' entry point on the
> offchance that it changes in future.
>
> [ qperret: Commit title nits and added linker script alias ]
>
> Signed-off-by: Will Deacon <will@kernel.org>
> Signed-off-by: Quentin Perret <qperret@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Link: https://lore.kernel.org/r/20210319100146.1149909-3-qperret@google.com
> ---
>  arch/arm64/include/asm/hyp_image.h |  3 +++
>  arch/arm64/kernel/image-vars.h     | 11 +++++++++++
>  arch/arm64/kvm/hyp/nvhe/Makefile   |  4 ++++
>  3 files changed, 18 insertions(+)
>
> diff --git a/arch/arm64/include/asm/hyp_image.h b/arch/arm64/include/asm/hyp_image.h
> index daa1a1da539e..e06842756051 100644
> --- a/arch/arm64/include/asm/hyp_image.h
> +++ b/arch/arm64/include/asm/hyp_image.h
> @@ -31,6 +31,9 @@
>   */
>  #define KVM_NVHE_ALIAS(sym)    kvm_nvhe_sym(sym) = sym;
>
> +/* Defines a linker script alias for KVM nVHE hyp symbols */
> +#define KVM_NVHE_ALIAS_HYP(first, sec) kvm_nvhe_sym(first) = kvm_nvhe_sym(sec);
> +
>  #endif /* LINKER_SCRIPT */
>
>  #endif /* __ARM64_HYP_IMAGE_H__ */
> diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
> index c615b285ff5b..48e43b29a2d5 100644
> --- a/arch/arm64/kernel/image-vars.h
> +++ b/arch/arm64/kernel/image-vars.h
> @@ -103,6 +103,17 @@ KVM_NVHE_ALIAS(gic_nonsecure_priorities);
>  KVM_NVHE_ALIAS(__start___kvm_ex_table);
>  KVM_NVHE_ALIAS(__stop___kvm_ex_table);
>
> +/* Position-independent library routines */
> +KVM_NVHE_ALIAS_HYP(clear_page, __pi_clear_page);
> +KVM_NVHE_ALIAS_HYP(copy_page, __pi_copy_page);
> +KVM_NVHE_ALIAS_HYP(memcpy, __pi_memcpy);
> +KVM_NVHE_ALIAS_HYP(memset, __pi_memset);
> +
> +#ifdef CONFIG_KASAN
> +KVM_NVHE_ALIAS_HYP(__memcpy, __pi_memcpy);
> +KVM_NVHE_ALIAS_HYP(__memset, __pi_memset);
> +#endif
> +
>  #endif /* CONFIG_KVM */
>
>  #endif /* __ARM64_KERNEL_IMAGE_VARS_H */
> diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
> index ddde15fe85f2..230bba1a6716 100644
> --- a/arch/arm64/kvm/hyp/nvhe/Makefile
> +++ b/arch/arm64/kvm/hyp/nvhe/Makefile
> @@ -6,9 +6,13 @@
>  asflags-y := -D__KVM_NVHE_HYPERVISOR__
>  ccflags-y := -D__KVM_NVHE_HYPERVISOR__
>
> +lib-objs := clear_page.o copy_page.o memcpy.o memset.o
> +lib-objs := $(addprefix ../../../lib/, $(lib-objs))
> +
>  obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o hyp-main.o
>  obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
>          ../fpsimd.o ../hyp-entry.o
> +obj-y += $(lib-objs)
>
>  ##
>  ## Build rules for compiling nVHE hyp code
> --
> 2.34.1
>
>
> --
> Without deviation from the norm, progress is not possible.
