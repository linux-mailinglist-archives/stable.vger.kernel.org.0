Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AED94233E1
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 00:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236820AbhJEWy2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 18:54:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236810AbhJEWy2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Oct 2021 18:54:28 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AFAEC061749;
        Tue,  5 Oct 2021 15:52:37 -0700 (PDT)
Date:   Tue, 05 Oct 2021 22:52:33 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1633474355;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pEBtN2cfC4BYMywORJN4oVkV0S4K96K1JD1KKNtOe7I=;
        b=sftG08wxpl5XlprtBczyDVJTr3LEz8qyYkTu7jaKWKouGCIVeNGRkueUla9WLZ8BGn9ui+
        m8AQQOgoaEO2DpWBTnN57K/J3xIomvOkzvSXn5S8DaZwjOxyNbbcsDZ8VK+g0Oeh2YguMw
        LaYS4zZp2nG1/WJnQH9tmf4k9cekYFlZu81kkZDzyHxDz0Z5o7lHjviLpkH/R8rFR/wk8P
        oF6D8Yc3OdVcw7SPhxQUbKB8mQUEpZ20RW4piSOWG8mwLSRkmsJmnVxjVSCRgy4tkHAovu
        fjldRsP/UFCsbXajqXyKZr7kResrPEAFMuihnw2PVR6iIBojNeMXI9dxO66gvQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1633474355;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pEBtN2cfC4BYMywORJN4oVkV0S4K96K1JD1KKNtOe7I=;
        b=p6BSzfA/SM95Be2G5eG4AICuiDlBPfmnzcKSANn2lYrJjQRgbuiJvgMb1epsI7puzPbHKK
        jPg/+HQuPc2mYIDg==
From:   "tip-bot2 for Lukas Bulwahn" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/Kconfig: Correct reference to MWINCHIP3D
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Borislav Petkov <bp@suse.de>, <stable@vger.kernel.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20210803113531.30720-4-lukas.bulwahn@gmail.com>
References: <20210803113531.30720-4-lukas.bulwahn@gmail.com>
MIME-Version: 1.0
Message-ID: <163347435383.25758.16809029826947705585.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     9608312f03f412eafa1630b134db710b4473d62a
Gitweb:        https://git.kernel.org/tip/9608312f03f412eafa1630b134db710b4473d62a
Author:        Lukas Bulwahn <lukas.bulwahn@gmail.com>
AuthorDate:    Tue, 03 Aug 2021 13:35:25 +02:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Wed, 06 Oct 2021 00:46:44 +02:00

x86/Kconfig: Correct reference to MWINCHIP3D

Commit in Fixes intended to exclude the Winchip series and referred to
CONFIG_WINCHIP3D, but the config symbol is called CONFIG_MWINCHIP3D.

Hence, scripts/checkkconfigsymbols.py warns:

WINCHIP3D
Referencing files: arch/x86/Kconfig

Correct the reference to the intended config symbol.

Fixes: 69b8d3fcabdc ("x86/Kconfig: Exclude i586-class CPUs lacking PAE support from the HIGHMEM64G Kconfig group")
Suggested-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20210803113531.30720-4-lukas.bulwahn@gmail.com
---
 arch/x86/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ab83c22..8055da4 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1405,7 +1405,7 @@ config HIGHMEM4G
 
 config HIGHMEM64G
 	bool "64GB"
-	depends on !M486SX && !M486 && !M586 && !M586TSC && !M586MMX && !MGEODE_LX && !MGEODEGX1 && !MCYRIXIII && !MELAN && !MWINCHIPC6 && !WINCHIP3D && !MK6
+	depends on !M486SX && !M486 && !M586 && !M586TSC && !M586MMX && !MGEODE_LX && !MGEODEGX1 && !MCYRIXIII && !MELAN && !MWINCHIPC6 && !MWINCHIP3D && !MK6
 	select X86_PAE
 	help
 	  Select this if you have a 32-bit processor and more than 4
