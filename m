Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5942AF4BCF
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727010AbfKHMgr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 07:36:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:44332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726036AbfKHMgq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 07:36:46 -0500
Received: from localhost.localdomain (lfbn-mar-1-550-151.w90-118.abo.wanadoo.fr [90.118.131.151])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C7442248C;
        Fri,  8 Nov 2019 12:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573216606;
        bh=kEY/F/Ldc/xjgrznfurffqYh7kxLc2SPYlECzyaD8Js=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fmqKbhX7Fs2BGfaiZ/uDKsI25T+fW7fK7oIx02UaTDTDWDxuFBsv28xySPUZHc9EJ
         Fqve3IXbcki9gvqvxRfwuzXdLNIwa+pln2IoEqFKYFBdZZtrV1OBTABeeIvrPfB3eC
         lkYXFKxSJrOMcO6VtlOC76n7QDeXTRrk3kbj9ydw=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     stable@vger.kernel.org
Cc:     linus.walleij@linaro.org, rmk+kernel@armlinux.org.uk,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH for-stable-4.4 21/50] ARM: spectre: add Kconfig symbol for CPUs vulnerable to Spectre
Date:   Fri,  8 Nov 2019 13:35:25 +0100
Message-Id: <20191108123554.29004-22-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108123554.29004-1-ardb@kernel.org>
References: <20191108123554.29004-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

Commit c58d237d0852a57fde9bc2c310972e8f4e3d155d upstream.

Add a Kconfig symbol for CPUs which are vulnerable to the Spectre
attacks.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Boot-tested-by: Tony Lindgren <tony@atomide.com>
Reviewed-by: Tony Lindgren <tony@atomide.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: David A. Long <dave.long@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm/mm/Kconfig | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
index 41218867a9a6..7ef92e6692ab 100644
--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -396,6 +396,7 @@ config CPU_V7
 	select CPU_CP15_MPU if !MMU
 	select CPU_HAS_ASID if MMU
 	select CPU_PABRT_V7
+	select CPU_SPECTRE if MMU
 	select CPU_TLB_V7 if MMU
 
 # ARMv7M
@@ -793,6 +794,9 @@ config CPU_BPREDICT_DISABLE
 	help
 	  Say Y here to disable branch prediction.  If unsure, say N.
 
+config CPU_SPECTRE
+	bool
+
 config TLS_REG_EMUL
 	bool
 	select NEED_KUSER_HELPERS
-- 
2.20.1

