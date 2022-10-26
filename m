Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E730B60E584
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 18:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233166AbiJZQem (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 12:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232946AbiJZQem (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 12:34:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80FED2872C
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 09:34:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 37409B8231B
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 16:34:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9134EC433C1;
        Wed, 26 Oct 2022 16:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666802077;
        bh=Cs4zsrlaPrEA1gEiqwyW4ngWGdSOv+K9NmjdBC3AKhU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ss9qTInoucR4ik6VF6p+DYdCfZE4ThXlBB9jjrg2cXasWqxjSPhHlQdXjnzse/SVh
         zjKmh6Qvm6xxMW2xHqFC4wiq95Z20weB4YftSN0l9oqqnIb92lsKc2qrTa+Pnw+V3a
         hKw75wZtaVsMEb0ErICOEAkNJSmLVPV7qk0bSEZQ18Ks+FlDvgstccm47aAqX2+iaG
         ArvG65EjeOGhEXC4Bnajf6QA2b9maCXosvDR3ZmbF8bDKM8QmG6y4H+APMd2nxEZKs
         ftfmFd02rWcjas6FpVa9qb4Ol8EcdxrlsY31aquy5THuKQaRlQwjzkVeQfsDF2ycJR
         eGf4+kRGIT0Pw==
Date:   Wed, 26 Oct 2022 09:34:35 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     ardb@kernel.org, bp@suse.de, ndesaulniers@google.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] x86/Kconfig: Drop check for -mabi=ms for
 CONFIG_EFI_STUB" failed to apply to 5.15-stable tree
Message-ID: <Y1lhm3mNdI0PFbLe@dev-arch.thelio-3990X>
References: <166679808320556@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="95aGtfb6wY818vPS"
Content-Disposition: inline
In-Reply-To: <166679808320556@kroah.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--95aGtfb6wY818vPS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 26, 2022 at 05:28:03PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.15-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> Possible dependencies:
> 
> 33806e7cb8d5 ("x86/Kconfig: Drop check for -mabi=ms for CONFIG_EFI_STUB")
> c6dbd3e5e69c ("x86/mmx_32: Remove X86_USE_3DNOW")
> 6bf8a55d8344 ("x86: Fix misspelled Kconfig symbols")
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> From 33806e7cb8d50379f55c3e8f335e91e1b359dc7b Mon Sep 17 00:00:00 2001
> From: Nathan Chancellor <nathan@kernel.org>
> Date: Thu, 29 Sep 2022 08:20:10 -0700
> Subject: [PATCH] x86/Kconfig: Drop check for -mabi=ms for CONFIG_EFI_STUB

Attached is a backport that applies to both 5.15 and 5.10. Let me know
if there are any issues.

Cheers,
Nathan

--95aGtfb6wY818vPS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-x86-Kconfig-Drop-check-for-mabi-ms-for-CONFIG_EFI_ST.patch"

From c411c8cc183357003fc174a6c89978dd663fba33 Mon Sep 17 00:00:00 2001
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 29 Sep 2022 08:20:10 -0700
Subject: [PATCH 5.15/5.10] x86/Kconfig: Drop check for -mabi=ms for
 CONFIG_EFI_STUB

commit 33806e7cb8d50379f55c3e8f335e91e1b359dc7b upstream.

A recent change in LLVM made CONFIG_EFI_STUB unselectable because it no
longer pretends to support -mabi=ms, breaking the dependency in
Kconfig. Lack of CONFIG_EFI_STUB can prevent kernels from booting via
EFI in certain circumstances.

This check was added by

  8f24f8c2fc82 ("efi/libstub: Annotate firmware routines as __efiapi")

to ensure that __attribute__((ms_abi)) was available, as -mabi=ms is
not actually used in any cflags.

According to the GCC documentation, this attribute has been supported
since GCC 4.4.7. The kernel currently requires GCC 5.1 so this check is
not necessary; even when that change landed in 5.6, the kernel required
GCC 4.9 so it was unnecessary then as well.

Clang supports __attribute__((ms_abi)) for all versions that are
supported for building the kernel so no additional check is needed.
Remove the 'depends on' line altogether to allow CONFIG_EFI_STUB to be
selected when CONFIG_EFI is enabled, regardless of compiler.

Fixes: 8f24f8c2fc82 ("efi/libstub: Annotate firmware routines as __efiapi")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Cc: stable@vger.kernel.org
Link: https://github.com/llvm/llvm-project/commit/d1ad006a8f64bdc17f618deffa9e7c91d82c444d
[nathan: Fix conflict due to lack of c6dbd3e5e69c in older trees]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/x86/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 57f5e881791a..0f2234cd8453 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1926,7 +1926,6 @@ config EFI
 config EFI_STUB
 	bool "EFI stub support"
 	depends on EFI && !X86_USE_3DNOW
-	depends on $(cc-option,-mabi=ms) || X86_32
 	select RELOCATABLE
 	help
 	  This kernel feature allows a bzImage to be loaded directly

base-commit: bd8a595958a5b02e58cdd6fed82d4ebc77b1988a
-- 
2.38.1


--95aGtfb6wY818vPS--
