Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D84111B4BF
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:50:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732816AbfLKPYP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:24:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:55470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732428AbfLKPYM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:24:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88611222C4;
        Wed, 11 Dec 2019 15:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077852;
        bh=Kwz4p3q0xjiBMR4tx+Z2hf0uv4OjZCHsCcNDLY1JdEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KvS18ZiQAwsJSpg4KdERMdhr1hyhGAQCgnKsQV/3Sp66auZVTnCfmEasijRkIDisK
         IJlscV/+iHouwuSx9m1gNgEHEFqxz6zmSFPpW2ceG8sH2wIcmMVyftpP3wOufn8cCo
         o/XmYmdtRWiLWVZTGUnWcPdSb0lSbrvgRGiGLqs4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 148/243] soc: renesas: r8a77970-sysc: Correct names of A2DP/A2CN power domains
Date:   Wed, 11 Dec 2019 16:05:10 +0100
Message-Id: <20191211150349.160913026@linuxfoundation.org>
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

[ Upstream commit b5eb730e031acaba2d25e8f522ac5966a70885ae ]

The R-Car Gen3 HardWare Manual Errata for Rev. 0.80 (Feb 28, 2018)
renamed the A2IR2 and A2IR3 power domains on R-Car V3M to A2DP resp.
A2CN.

As these definitions are not yet used from DT, they can just be renamed.

While at it, fix the indentation of the A3IR definition.

Fixes: 833bdb47c826a1a6 ("dt-bindings: power: add R8A77970 SYSC power domain definitions")
Fixes: bab9b2a74fe9da96 ("soc: renesas: rcar-sysc: add R8A77970 support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/renesas/r8a77970-sysc.c       | 4 ++--
 include/dt-bindings/power/r8a77970-sysc.h | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/soc/renesas/r8a77970-sysc.c b/drivers/soc/renesas/r8a77970-sysc.c
index caf894f193edc..77422baa7a56a 100644
--- a/drivers/soc/renesas/r8a77970-sysc.c
+++ b/drivers/soc/renesas/r8a77970-sysc.c
@@ -27,8 +27,8 @@ static const struct rcar_sysc_area r8a77970_areas[] __initconst = {
 	{ "a3ir",	0x180, 0, R8A77970_PD_A3IR,	R8A77970_PD_ALWAYS_ON },
 	{ "a2ir0",	0x400, 0, R8A77970_PD_A2IR0,	R8A77970_PD_A3IR },
 	{ "a2ir1",	0x400, 1, R8A77970_PD_A2IR1,	R8A77970_PD_A3IR },
-	{ "a2ir2",	0x400, 2, R8A77970_PD_A2IR2,	R8A77970_PD_A3IR },
-	{ "a2ir3",	0x400, 3, R8A77970_PD_A2IR3,	R8A77970_PD_A3IR },
+	{ "a2dp",	0x400, 2, R8A77970_PD_A2DP,	R8A77970_PD_A3IR },
+	{ "a2cn",	0x400, 3, R8A77970_PD_A2CN,	R8A77970_PD_A3IR },
 	{ "a2sc0",	0x400, 4, R8A77970_PD_A2SC0,	R8A77970_PD_A3IR },
 	{ "a2sc1",	0x400, 5, R8A77970_PD_A2SC1,	R8A77970_PD_A3IR },
 };
diff --git a/include/dt-bindings/power/r8a77970-sysc.h b/include/dt-bindings/power/r8a77970-sysc.h
index bf54779d16252..9eaf824b15826 100644
--- a/include/dt-bindings/power/r8a77970-sysc.h
+++ b/include/dt-bindings/power/r8a77970-sysc.h
@@ -19,10 +19,10 @@
 #define R8A77970_PD_CR7			13
 #define R8A77970_PD_CA53_SCU		21
 #define R8A77970_PD_A2IR0		23
-#define R8A77970_PD_A3IR			24
+#define R8A77970_PD_A3IR		24
 #define R8A77970_PD_A2IR1		27
-#define R8A77970_PD_A2IR2		28
-#define R8A77970_PD_A2IR3		29
+#define R8A77970_PD_A2DP		28
+#define R8A77970_PD_A2CN		29
 #define R8A77970_PD_A2SC0		30
 #define R8A77970_PD_A2SC1		31
 
-- 
2.20.1



