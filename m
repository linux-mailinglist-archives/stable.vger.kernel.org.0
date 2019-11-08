Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10CA6F5444
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 19:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387543AbfKHSzl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 13:55:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:53076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387707AbfKHSzk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 13:55:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAEF82178F;
        Fri,  8 Nov 2019 18:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239339;
        bh=OUxU/eQZ6HEuqMpH2FbTVFsxnOXLUuvEPUkI2xixscQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qDMisU73ddlhpssefBRHB/CiIfkeATLb1uoPQ0pwhYOLi9nT2F+q1KidWunJTl1E9
         K+hPjKc0PlFRSCwowKAtC6/aUgxCA/i5eTrav+xUbP1QSO0juYo56aEEj9ruK0oUvN
         wvTDMC/KNH67NO+9YvzJWjqgt2Xid2ysP41pj9Lw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linus.walleij@linaro.org, rmk+kernel@armlinux.org.uk, Ard Biesheuvel" 
        <ardb@kernel.org>, Russell King <rmk+kernel@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        "David A. Long" <dave.long@linaro.org>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 4.4 44/75] ARM: spectre: add Kconfig symbol for CPUs vulnerable to Spectre
Date:   Fri,  8 Nov 2019 19:50:01 +0100
Message-Id: <20191108174750.253744224@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174708.135680837@linuxfoundation.org>
References: <20191108174708.135680837@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/mm/Kconfig |    4 ++++
 1 file changed, 4 insertions(+)

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


