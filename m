Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41C0D25F01F
	for <lists+stable@lfdr.de>; Sun,  6 Sep 2020 21:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726349AbgIFT3y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Sep 2020 15:29:54 -0400
Received: from crapouillou.net ([89.234.176.41]:35664 "EHLO crapouillou.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725773AbgIFT3x (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Sep 2020 15:29:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crapouillou.net;
        s=mail; t=1599420584; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qDP1LlFIHYvv266jJZcZql5leJmGLygtd2JQsS4aQs8=;
        b=LAtgaSNWVeE7i9YUE5n8CaTwEXrk75B5uk/IWM4OvRNIN6SFSNlubhGzS5PcCvd0PNzfno
        WOVyRxyJLJlrLTJJ8PBIb11t4KC7fddLHrvsibN1Uq1qLRRSNU4AegzPUIg9GmjzgkquCC
        jy9Bl6C/96EQdoXNuTovokGr6zkxz58=
From:   Paul Cercueil <paul@crapouillou.net>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     "Maciej W . Rozycki" <macro@linux-mips.org>,
        Paul Burton <paulburton@kernel.org>,
        Zhou Yanjie <zhouyanjie@wanyeetech.com>, od@zcrc.me,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        Paul Cercueil <paul@crapouillou.net>, stable@vger.kernel.org
Subject: [PATCH v3 01/15] MIPS: configs: lb60: Fix defconfig not selecting correct board
Date:   Sun,  6 Sep 2020 21:29:21 +0200
Message-Id: <20200906192935.107086-2-paul@crapouillou.net>
In-Reply-To: <20200906192935.107086-1-paul@crapouillou.net>
References: <20200906192935.107086-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since INGENIC_GENERIC_BOARD was introduced, the JZ4740_QI_LB60 option
is no longer the default, so the symbol has to be selected by the
defconfig, otherwise the kernel built will be for a generic Ingenic
board and won't have the Device Tree blob built-in.

Cc: stable@vger.kernel.org # v5.7
Fixes: 62249209a772 ("MIPS: ingenic: Default to a generic board")
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
---

Notes:
    v3: New patch

 arch/mips/configs/qi_lb60_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/mips/configs/qi_lb60_defconfig b/arch/mips/configs/qi_lb60_defconfig
index 81bfbee72b0c..9c2c183085d1 100644
--- a/arch/mips/configs/qi_lb60_defconfig
+++ b/arch/mips/configs/qi_lb60_defconfig
@@ -8,6 +8,7 @@ CONFIG_EMBEDDED=y
 # CONFIG_COMPAT_BRK is not set
 CONFIG_SLAB=y
 CONFIG_MACH_INGENIC=y
+CONFIG_JZ4740_QI_LB60=y
 CONFIG_HZ_100=y
 # CONFIG_SECCOMP is not set
 CONFIG_MODULES=y
-- 
2.28.0

