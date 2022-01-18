Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 232CC491556
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:27:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343844AbiARC10 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:27:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245324AbiARCZR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:25:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E8CDC0613AC;
        Mon, 17 Jan 2022 18:24:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16EABB8123A;
        Tue, 18 Jan 2022 02:24:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE39EC36AEF;
        Tue, 18 Jan 2022 02:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472662;
        bh=fOdp8drVGeVQtJE34TPJ0nmUqgItGGndsnQCmIEAx4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cFKZ85b8GIyKSgTbfS9Py7LkzjsI8QFtM6CMmMf75HS+IpGcv5N4Y1lNQUqIZk17z
         /t4T5xYRXnUAQvTmiqUco1gmduP6gR45UNOIMMTunxLXqjOoDLIjIpM+E+d2FjEI4x
         CInWNUToLuK2sO9FXx8eKaL2XG/vJYhsjeAWKU9Bbormdqlxngn8D7dsSjq9QrvkUE
         psWRNM3bJqCpuCavHkb6ZB+p/wUtbLezmd/0WUJdyUhGxrYqxCmAC1JTaye0v2TEE1
         H5BUrW8l03pMVUeMhn2wPR6Pp4xJuYnr4UxXsNy7ZhCs4DRnJNTPu0779lUmFdGQ2U
         MuYDjmXbzkE9A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kishon Vijay Abraham I <kishon@ti.com>,
        Aswath Govindraju <a-govindraju@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Sasha Levin <sashal@kernel.org>, nm@ti.com, kristo@kernel.org,
        robh+dt@kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 090/217] arm64: dts: ti: j7200-main: Fix 'dtbs_check' serdes_ln_ctrl node
Date:   Mon, 17 Jan 2022 21:17:33 -0500
Message-Id: <20220118021940.1942199-90-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
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
index d60ef4f7dd0b7..05a627ad6cdc4 100644
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

