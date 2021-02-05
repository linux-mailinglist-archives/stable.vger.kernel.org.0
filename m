Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BBEB3113AE
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 22:38:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232010AbhBEViQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 16:38:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:45582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233024AbhBEPAA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 10:00:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F84464FCD;
        Fri,  5 Feb 2021 14:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534174;
        bh=LaSCGbplNpKW0icELFx/FkQSKrppRG4FrgGCx6zV8jU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KvAzCzfDmfg1FkzTgHJAN9ynyWaAyKw7wx2o660B7ADT+498dS2YiHzFcVGiZyKps
         8wtn8RGHVhFMrDpKGG24Ea5+exh9c3LK4wP7BDJnaZ52aV4B8l91Fdpi1Ojl0oYjmd
         JxWUCVIPpX3oeAjd4bSsizVswXDIZhEDTKjiOPTY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        kbuild test robot <lkp@intel.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 5.10 16/57] ARM: 9025/1: Kconfig: CPU_BIG_ENDIAN depends on !LD_IS_LLD
Date:   Fri,  5 Feb 2021 15:06:42 +0100
Message-Id: <20210205140656.672218181@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140655.982616732@linuxfoundation.org>
References: <20210205140655.982616732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nick Desaulniers <ndesaulniers@google.com>

commit 28187dc8ebd938d574edfc6d9e0f9c51c21ff3f4 upstream.

LLD does not yet support any big endian architectures. Make this config
non-selectable when using LLD until LLD is fixed.

Link: https://github.com/ClangBuiltLinux/linux/issues/965

Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/mm/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -743,6 +743,7 @@ config SWP_EMULATE
 config CPU_BIG_ENDIAN
 	bool "Build big-endian kernel"
 	depends on ARCH_SUPPORTS_BIG_ENDIAN
+	depends on !LD_IS_LLD
 	help
 	  Say Y if you plan on running a kernel in big-endian mode.
 	  Note that your board must be properly built and your board


