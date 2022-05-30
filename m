Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59E345383AD
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239844AbiE3Oi0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 10:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242662AbiE3Ob0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 10:31:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BB1C12D1DE;
        Mon, 30 May 2022 06:53:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7CC6BB80DEB;
        Mon, 30 May 2022 13:53:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E2E3C36AE9;
        Mon, 30 May 2022 13:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918783;
        bh=MAX7wiH1XxyplvJYlh0+kplgAwx6qXFUDvATHGh08A4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=DuEypzZccb0PLN/3B8rGnTR+J9Z164k7C50L3nvm7pTBT6MkFrfeMaXU+ImXTJ9AF
         bVRXyPEphWVyAaPYB2bgezXsH7UmwXlcr+hXbKoHXhZpWnOIDryLjDz8hvIO2Xlzvp
         pwN8aaHmM+LlX2Kv6/hr4QDPVNt/nhEyDmIyVy+Vffn50md6PUtbtzwnXwTTq4QpRP
         VROVhL9Llx7EnsOKpvEVHZWkV4Gum0cvJ+5IomhmUvv8Kl6uI4kAkJbIEla6xuy3/D
         knrSsqo6jbYaADoVRBO4huEqiM2UQTvxRDS00terKKizU+WuPrlEEIhZx4oZqvblIw
         TAjo7+TuczBNw==
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-e93bbb54f9so14363181fac.12;
        Mon, 30 May 2022 06:53:03 -0700 (PDT)
X-Gm-Message-State: AOAM533whQR514x7Z/9EVR4dafsW+/n2OyhcIULbTyWNZ2vtxtYdx/Qj
        P4MQE688Zp/h9vW5mBgeu1ARoij9WkoAZFPnS9o=
X-Google-Smtp-Source: ABdhPJzdoo1sHFLLInFtt/hgXNHnvLFK6tnUHaPcCvCd7dg8vI8l0LUkCVEH8ofVkRXE/tkQtssOPOuGWKCysy8VVxw=
X-Received: by 2002:a05:6870:eaa5:b0:da:b3f:2b45 with SMTP id
 s37-20020a056870eaa500b000da0b3f2b45mr10799698oap.228.1653918782369; Mon, 30
 May 2022 06:53:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220530135057.1937286-1-sashal@kernel.org> <20220530135057.1937286-27-sashal@kernel.org>
In-Reply-To: <20220530135057.1937286-27-sashal@kernel.org>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 30 May 2022 15:52:51 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFZkuQ1peuJVPt6usbfKzCqp3cD5nbz4M=yTj5OQt3Wew@mail.gmail.com>
Message-ID: <CAMj1kXFZkuQ1peuJVPt6usbfKzCqp3cD5nbz4M=yTj5OQt3Wew@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 4.14 27/29] ARM: 9201/1: spectre-bhb: rely on
 linker to emit cross-section literal loads
To:     Sasha Levin <sashal@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Nicolas Pitre <nico@fluxnic.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

AUTONAK

On Mon, 30 May 2022 at 15:52, Sasha Levin <sashal@kernel.org> wrote:
>
> From: Ard Biesheuvel <ardb@kernel.org>
>
> [ Upstream commit ad12c2f1587c6ec9b52ff226f438955bfae6ad89 ]
>
> The assembler does not permit 'LDR PC, <sym>' when the symbol lives in a
> different section, which is why we have been relying on rather fragile
> open-coded arithmetic to load the address of the vector_swi routine into
> the program counter using a single LDR instruction in the SWI slot in
> the vector table. The literal was moved to a different section to in
> commit 19accfd373847 ("ARM: move vector stubs") to ensure that the
> vector stubs page does not need to be mapped readable for user space,
> which is the case for the vector page itself, as it carries the kuser
> helpers as well.
>
> So the cross-section literal load is open-coded, and this relies on the
> address of vector_swi to be at the very start of the vector stubs page,
> and we won't notice if we got it wrong until booting the kernel and see
> it break. Fortunately, it was guaranteed to break, so this was fragile
> but not problematic.
>
> Now that we have added two other variants of the vector table, we have 3
> occurrences of the same trick, and so the size of our ISA/compiler/CPU
> validation space has tripled, in a way that may cause regressions to only
> be observed once booting the image in question on a CPU that exercises a
> particular vector table.
>
> So let's switch to true cross section references, and let the linker fix
> them up like it fixes up all the other cross section references in the
> vector page.
>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  arch/arm/kernel/entry-armv.S | 22 +++++++++++++++-------
>  1 file changed, 15 insertions(+), 7 deletions(-)
>
> diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
> index e1b3c5c96560..0a9891df1ca4 100644
> --- a/arch/arm/kernel/entry-armv.S
> +++ b/arch/arm/kernel/entry-armv.S
> @@ -1102,10 +1102,15 @@ ENDPROC(vector_bhb_bpiall_\name)
>         .endm
>
>         .section .stubs, "ax", %progbits
> -       @ This must be the first word
> +       @ These need to remain at the start of the section so that
> +       @ they are in range of the 'SWI' entries in the vector tables
> +       @ located 4k down.
> +.L__vector_swi:
>         .word   vector_swi
>  #ifdef CONFIG_HARDEN_BRANCH_HISTORY
> +.L__vector_bhb_loop8_swi:
>         .word   vector_bhb_loop8_swi
> +.L__vector_bhb_bpiall_swi:
>         .word   vector_bhb_bpiall_swi
>  #endif
>
> @@ -1248,10 +1253,11 @@ vector_addrexcptn:
>         .globl  vector_fiq
>
>         .section .vectors, "ax", %progbits
> -.L__vectors_start:
>         W(b)    vector_rst
>         W(b)    vector_und
> -       W(ldr)  pc, .L__vectors_start + 0x1000
> +ARM(   .reloc  ., R_ARM_LDR_PC_G0, .L__vector_swi              )
> +THUMB( .reloc  ., R_ARM_THM_PC12, .L__vector_swi               )
> +       W(ldr)  pc, .
>         W(b)    vector_pabt
>         W(b)    vector_dabt
>         W(b)    vector_addrexcptn
> @@ -1260,10 +1266,11 @@ vector_addrexcptn:
>
>  #ifdef CONFIG_HARDEN_BRANCH_HISTORY
>         .section .vectors.bhb.loop8, "ax", %progbits
> -.L__vectors_bhb_loop8_start:
>         W(b)    vector_rst
>         W(b)    vector_bhb_loop8_und
> -       W(ldr)  pc, .L__vectors_bhb_loop8_start + 0x1004
> +ARM(   .reloc  ., R_ARM_LDR_PC_G0, .L__vector_bhb_loop8_swi    )
> +THUMB( .reloc  ., R_ARM_THM_PC12, .L__vector_bhb_loop8_swi     )
> +       W(ldr)  pc, .
>         W(b)    vector_bhb_loop8_pabt
>         W(b)    vector_bhb_loop8_dabt
>         W(b)    vector_addrexcptn
> @@ -1271,10 +1278,11 @@ vector_addrexcptn:
>         W(b)    vector_bhb_loop8_fiq
>
>         .section .vectors.bhb.bpiall, "ax", %progbits
> -.L__vectors_bhb_bpiall_start:
>         W(b)    vector_rst
>         W(b)    vector_bhb_bpiall_und
> -       W(ldr)  pc, .L__vectors_bhb_bpiall_start + 0x1008
> +ARM(   .reloc  ., R_ARM_LDR_PC_G0, .L__vector_bhb_bpiall_swi   )
> +THUMB( .reloc  ., R_ARM_THM_PC12, .L__vector_bhb_bpiall_swi    )
> +       W(ldr)  pc, .
>         W(b)    vector_bhb_bpiall_pabt
>         W(b)    vector_bhb_bpiall_dabt
>         W(b)    vector_addrexcptn
> --
> 2.35.1
>
