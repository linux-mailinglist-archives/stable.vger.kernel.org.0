Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C566498F90
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352738AbiAXTxQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:53:16 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:45408 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234697AbiAXTsO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:48:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 124176159E;
        Mon, 24 Jan 2022 19:48:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5EF2C340EC;
        Mon, 24 Jan 2022 19:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053692;
        bh=GDL5/qHmTlCExEwaF9eBCmfkh9P9BFI0UW3VqrG8rL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nCpwnJRCwzYU4UDf9StKxiy+pkmWXm80Kl0UYITq5i+CXjMM4ewFjcL2bkta4a2I0
         Nk8tQHRJitBmU3OaGLV+3upsvbffO5izQclWYUL70lqvfeFTDmWjn9TI/NNXjdYRyw
         tunlXvN7uUiIgXqkzxYI17rdT9dWAGBz+HFFiH1g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Fan <peng.fan@nxp.com>,
        Nishanth Menon <nm@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 103/563] arm64: dts: ti: k3-j721e: correct cache-sets info
Date:   Mon, 24 Jan 2022 19:37:48 +0100
Message-Id: <20220124184027.959325002@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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
index cc483f7344af3..d1ef9fbe4981d 100644
--- a/arch/arm64/boot/dts/ti/k3-j721e.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j721e.dtsi
@@ -61,7 +61,7 @@
 			i-cache-sets = <256>;
 			d-cache-size = <0x8000>;
 			d-cache-line-size = <64>;
-			d-cache-sets = <128>;
+			d-cache-sets = <256>;
 			next-level-cache = <&L2_0>;
 		};
 
@@ -75,7 +75,7 @@
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



