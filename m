Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1ACD4917B3
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347731AbiARCmn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:42:43 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:52720 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346302AbiARCfi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:35:38 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 208A061234;
        Tue, 18 Jan 2022 02:35:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DB02C36AEB;
        Tue, 18 Jan 2022 02:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473337;
        bh=UGWm0wK11v3EDmwx/5ILniSLk7LdT6bmX2euEBeMYLw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gHwTiRaBxMXZiJmNjdePQdk6T7mM1tkr4b1KeROmlegCD2m6jAJqhTvI/quj+wtz8
         yfmmP42kF1CpfxO7frZGN6ithD8nkbUGfTjAOm9MgJsUEmRzgce0xt5XPcFszMb6eu
         PSyivFCBM6FfJ3IZpOUkL4zIblmDvCM3rsR/uGg1Hpc13vB/lWwQg2Ajs2/XAlpOjX
         AsiA8WZtupPtVLpaYJ/OZPl9L0acjlgAKYtbhhoVF8q3fcIbRTbYbfBl4pS9YlQk6C
         uiZY6JjAWWx/hAmXT5pcT0RS5THX43frmJZenNJl+yQbHVYbQ2dYAXXeIWjk9Jj6oM
         hEHeZ9sIN2qxw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kishon Vijay Abraham I <kishon@ti.com>,
        Aswath Govindraju <a-govindraju@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Sasha Levin <sashal@kernel.org>, nm@ti.com, kristo@kernel.org,
        robh+dt@kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 077/188] arm64: dts: ti: j721e-main: Fix 'dtbs_check' in serdes_ln_ctrl node
Date:   Mon, 17 Jan 2022 21:30:01 -0500
Message-Id: <20220118023152.1948105-77-sashal@kernel.org>
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

[ Upstream commit 3f92a5be6084b77f764a8bbb881ac0d12cb9e863 ]

Fix 'dtbs_check' in serdes_ln_ctrl (mux@4080) node by changing the node
name to mux-controller@4080.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Reviewed-by: Aswath Govindraju <a-govindraju@ti.com>
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Link: https://lore.kernel.org/r/20211126084555.17797-3-kishon@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-j721e-main.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-j721e-main.dtsi b/arch/arm64/boot/dts/ti/k3-j721e-main.dtsi
index 08c8d1b47dcd9..e85c89eebfa31 100644
--- a/arch/arm64/boot/dts/ti/k3-j721e-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j721e-main.dtsi
@@ -42,7 +42,7 @@ scm_conf: scm-conf@100000 {
 		#size-cells = <1>;
 		ranges = <0x0 0x0 0x00100000 0x1c000>;
 
-		serdes_ln_ctrl: mux@4080 {
+		serdes_ln_ctrl: mux-controller@4080 {
 			compatible = "mmio-mux";
 			reg = <0x00004080 0x50>;
 			#mux-control-cells = <1>;
-- 
2.34.1

