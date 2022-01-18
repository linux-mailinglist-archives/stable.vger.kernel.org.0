Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 404514917B2
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241226AbiARCmn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:42:43 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:51206 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346283AbiARCfh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:35:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A269B61216;
        Tue, 18 Jan 2022 02:35:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A449C36AEF;
        Tue, 18 Jan 2022 02:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473336;
        bh=BiirOjHlpVWgM5LSvRW1pHCwL3lov5qRslVKyuTy9EM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eU9R9AoZVOqiHAw7KkX8mO1zBXIbUNjAHAWe9aq5pIhdV6NIM3wkUdrM8lp5VQQrf
         wTKQFVM7s8zUOVHsNeXRspSnCQFePtJyWXVJQ49LvntuzbSQ3zGJmHNFeshf9j0TgC
         IlkngA/YO0nBwb69zgz72ksf1NpQNFjJMM3DOV6g0puRsk/uT9L0njfHN2+EEzAm04
         oNReAbY1JfkFhcRggpFeIFvN5DS8AiSyhpawXsgqpur5R4UmpKKgQhCtVx9xfuS4Yt
         6uKAhgPk1NGkyaOpASXGLRHp9BbV0igmgZW+ZVyVFygs0CKPsvbWkt6Nciq8dZI/iw
         bW3mBJxoBhOrA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kishon Vijay Abraham I <kishon@ti.com>,
        Aswath Govindraju <a-govindraju@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Sasha Levin <sashal@kernel.org>, nm@ti.com, kristo@kernel.org,
        robh+dt@kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 076/188] arm64: dts: ti: j7200-main: Fix 'dtbs_check' serdes_ln_ctrl node
Date:   Mon, 17 Jan 2022 21:30:00 -0500
Message-Id: <20220118023152.1948105-76-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kishon Vijay Abraham I <kishon@ti.com>

[ Upstream commit 4d3984906397581dc0ccb6a02bf16b6ff82c9192 ]

Fix 'dtbs_check' in serdes_ln_ctrl (serdes-ln-ctrl@4080) node by
changing the node name to mux-controller@4080.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Reviewed-by: Aswath Govindraju <a-govindraju@ti.com>
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Link: https://lore.kernel.org/r/20211126084555.17797-2-kishon@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-j7200-main.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-j7200-main.dtsi b/arch/arm64/boot/dts/ti/k3-j7200-main.dtsi
index 874cba75e9a5a..7daa280220442 100644
--- a/arch/arm64/boot/dts/ti/k3-j7200-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j7200-main.dtsi
@@ -32,7 +32,7 @@ scm_conf: scm-conf@100000 {
 		#size-cells = <1>;
 		ranges = <0x00 0x00 0x00100000 0x1c000>;
 
-		serdes_ln_ctrl: serdes-ln-ctrl@4080 {
+		serdes_ln_ctrl: mux-controller@4080 {
 			compatible = "mmio-mux";
 			#mux-control-cells = <1>;
 			mux-reg-masks = <0x4080 0x3>, <0x4084 0x3>, /* SERDES0 lane0/1 select */
-- 
2.34.1

