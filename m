Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31DEB1630FF
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 20:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727503AbgBRT6R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 14:58:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:35838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726557AbgBRT6R (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 14:58:17 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95E5120659;
        Tue, 18 Feb 2020 19:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582055897;
        bh=H+16V16wnbDW8zmH8rcsA0BqL7v9Yl6dcr/5UjFg3Lo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YdgTQ3ZBwScOVtJztE0X2dbQJeDgmOB7AoCVmw8XL8QmshWpE+in1uiEBi3MXaxcP
         disaFRD28+GhuqiyKUQC/BceeCzDAKkToBingA+g4iYFyP7rT4GljScBQLKmY3DdJ4
         zCRguthQfgnljs3INktzFC4mch1gDDpSpnGcuzMg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Olof Johansson <olof@lixom.net>
Subject: [PATCH 5.4 23/66] ARM: npcm: Bring back GPIOLIB support
Date:   Tue, 18 Feb 2020 20:54:50 +0100
Message-Id: <20200218190430.231827471@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200218190428.035153861@linuxfoundation.org>
References: <20200218190428.035153861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

commit e383e871ab54f073c2a798a9e0bde7f1d0528de8 upstream.

The CONFIG_ARCH_REQUIRE_GPIOLIB is gone since commit 65053e1a7743
("gpio: delete ARCH_[WANTS_OPTIONAL|REQUIRE]_GPIOLIB") and all platforms
should explicitly select GPIOLIB to have it.

Link: https://lore.kernel.org/r/20200130195525.4525-1-krzk@kernel.org
Cc: <stable@vger.kernel.org>
Fixes: 65053e1a7743 ("gpio: delete ARCH_[WANTS_OPTIONAL|REQUIRE]_GPIOLIB")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-npcm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/mach-npcm/Kconfig
+++ b/arch/arm/mach-npcm/Kconfig
@@ -11,7 +11,7 @@ config ARCH_NPCM7XX
 	depends on ARCH_MULTI_V7
 	select PINCTRL_NPCM7XX
 	select NPCM7XX_TIMER
-	select ARCH_REQUIRE_GPIOLIB
+	select GPIOLIB
 	select CACHE_L2X0
 	select ARM_GIC
 	select HAVE_ARM_TWD if SMP


