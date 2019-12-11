Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1F211B508
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:52:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731921AbfLKPvJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:51:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:53242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732606AbfLKPWa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:22:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AEF462073D;
        Wed, 11 Dec 2019 15:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077750;
        bh=HVZU9x+0pH2TId1VoYSaRAKp0uzKYBqTQQa8/QJcRxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rEHrt/9F/+/Ru5/5t3HHQI7IiF+fJrjBgzkdLAcxY02ZooqsiaCoFuvKhHOJFFnN1
         /SsasHSgfno6aY0kuGCFM7bxHxruvKAYRXRiLdUvAH/zsC/dc2o5diYnU931bKdhIW
         FDybVtDi94e5ft981kPP01tVCtLFVZm90+4BGzcM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 149/243] soc: renesas: r8a77980-sysc: Correct names of A2DP[01] power domains
Date:   Wed, 11 Dec 2019 16:05:11 +0100
Message-Id: <20191211150349.229729642@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 97473bc85b22ac610b1810b6a9a4669a6cb0b7b0 ]

The R-Car Gen3 HardWare Manual Errata for Rev. 0.80 (Feb 28, 2018)
renamed the A2PD0 and A2DP0 power domains on R-Car V3H to A2DP0 resp.
A2DP1.

As these definitions are not yet used from DT, they can just be renamed.

Fixes: 7755b40d07a8dba7 ("dt-bindings: power: add R8A77980 SYSC power domain definitions")
Fixes: 41d6d8bd8ae94ca9 ("soc: renesas: rcar-sysc: add R8A77980 support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/renesas/r8a77980-sysc.c       | 4 ++--
 include/dt-bindings/power/r8a77980-sysc.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/soc/renesas/r8a77980-sysc.c b/drivers/soc/renesas/r8a77980-sysc.c
index 9265fb525ef34..dbb2621ce4e3e 100644
--- a/drivers/soc/renesas/r8a77980-sysc.c
+++ b/drivers/soc/renesas/r8a77980-sysc.c
@@ -38,8 +38,8 @@ static const struct rcar_sysc_area r8a77980_areas[] __initconst = {
 	{ "a2sc2",	0x400, 8, R8A77980_PD_A2SC2,	R8A77980_PD_A3IR },
 	{ "a2sc3",	0x400, 9, R8A77980_PD_A2SC3,	R8A77980_PD_A3IR },
 	{ "a2sc4",	0x400, 10, R8A77980_PD_A2SC4,	R8A77980_PD_A3IR },
-	{ "a2pd0",	0x400, 11, R8A77980_PD_A2PD0,	R8A77980_PD_A3IR },
-	{ "a2pd1",	0x400, 12, R8A77980_PD_A2PD1,	R8A77980_PD_A3IR },
+	{ "a2dp0",	0x400, 11, R8A77980_PD_A2DP0,	R8A77980_PD_A3IR },
+	{ "a2dp1",	0x400, 12, R8A77980_PD_A2DP1,	R8A77980_PD_A3IR },
 	{ "a2cn",	0x400, 13, R8A77980_PD_A2CN,	R8A77980_PD_A3IR },
 	{ "a3vip",	0x2c0, 0, R8A77980_PD_A3VIP,	R8A77980_PD_ALWAYS_ON },
 	{ "a3vip1",	0x300, 0, R8A77980_PD_A3VIP1,	R8A77980_PD_A3VIP },
diff --git a/include/dt-bindings/power/r8a77980-sysc.h b/include/dt-bindings/power/r8a77980-sysc.h
index 2c90c12377253..7bebe7e8dbdbb 100644
--- a/include/dt-bindings/power/r8a77980-sysc.h
+++ b/include/dt-bindings/power/r8a77980-sysc.h
@@ -15,8 +15,8 @@
 #define R8A77980_PD_A2SC2		0
 #define R8A77980_PD_A2SC3		1
 #define R8A77980_PD_A2SC4		2
-#define R8A77980_PD_A2PD0		3
-#define R8A77980_PD_A2PD1		4
+#define R8A77980_PD_A2DP0		3
+#define R8A77980_PD_A2DP1		4
 #define R8A77980_PD_CA53_CPU0		5
 #define R8A77980_PD_CA53_CPU1		6
 #define R8A77980_PD_CA53_CPU2		7
-- 
2.20.1



