Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 444A849A028
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:25:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1842093AbiAXXAx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:00:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1836490AbiAXWjg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:39:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B1D6C054873;
        Mon, 24 Jan 2022 13:01:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF22760C17;
        Mon, 24 Jan 2022 21:01:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C379AC340E5;
        Mon, 24 Jan 2022 21:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058085;
        bh=k4iMiEeTASmYGmITRMv4gYpGEhH/4cLgMRmqExbaV+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wt/l/qFg45C7TjkZNcA+y+H6Ty/arb0b0ut/uMkZ4RLWLBfSkwPdaWUSgCggI0/qs
         MFNcl7cAozVQPwZSVjdzBxwF89HuZ4JBvxImWNha20EHBSv/hcgMO6MQ1s2ktofkZd
         YwGVbGkFoq9nfpCFzcLC7/9TbAXedprwRM1f6M+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Fan <peng.fan@nxp.com>,
        Nishanth Menon <nm@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0176/1039] arm64: dts: ti: k3-j721e: correct cache-sets info
Date:   Mon, 24 Jan 2022 19:32:45 +0100
Message-Id: <20220124184131.176905171@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 7a0df1f969c14939f60a7f9a6af72adcc314675f ]

A72 Cluster has 48KB Icache, 32KB Dcache and 1MB L2 Cache
 - ICache is 3-way set-associative
 - Dcache is 2-way set-associative
 - Line size are 64bytes

So correct the cache-sets info.

Fixes: 2d87061e70dea ("arm64: dts: ti: Add Support for J721E SoC")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Link: https://lore.kernel.org/r/20211112063155.3485777-1-peng.fan@oss.nxp.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-j721e.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-j721e.dtsi b/arch/arm64/boot/dts/ti/k3-j721e.dtsi
index 214359e7288b2..a5967ba139d7e 100644
--- a/arch/arm64/boot/dts/ti/k3-j721e.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j721e.dtsi
@@ -64,7 +64,7 @@
 			i-cache-sets = <256>;
 			d-cache-size = <0x8000>;
 			d-cache-line-size = <64>;
-			d-cache-sets = <128>;
+			d-cache-sets = <256>;
 			next-level-cache = <&L2_0>;
 		};
 
@@ -78,7 +78,7 @@
 			i-cache-sets = <256>;
 			d-cache-size = <0x8000>;
 			d-cache-line-size = <64>;
-			d-cache-sets = <128>;
+			d-cache-sets = <256>;
 			next-level-cache = <&L2_0>;
 		};
 	};
-- 
2.34.1



