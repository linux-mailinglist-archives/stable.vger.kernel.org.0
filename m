Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A16BD499C73
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1579378AbiAXWFZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:05:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1456348AbiAXVzB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:55:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7878C07E28D;
        Mon, 24 Jan 2022 12:35:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C98E861008;
        Mon, 24 Jan 2022 20:35:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B03F9C340E5;
        Mon, 24 Jan 2022 20:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056538;
        bh=eSZLF44e1JuTOoRoJCqOdob9EQwzWM9kUjPky1IcxwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eB+La/G1ZdSp49hCuZ3ytFbtLet7Hdzs2DbBI7sDZptdNGZnvIbm2R02K0IyjGx3e
         DbqeoBh4S3ruT7kVwKdjzzzg+MzKYG6sGDq4gm2Ip3r1tjTJSfXctBTkN6QPm95g8a
         W9ZR7hEZPU2u4FgSpyDV/tRojBaE2jlgiYN4IQ6U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>,
        Aswath Govindraju <a-govindraju@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 518/846] arm64: dts: ti: j721e-main: Fix dtbs_check in serdes_ln_ctrl node
Date:   Mon, 24 Jan 2022 19:40:35 +0100
Message-Id: <20220124184118.880371020@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
@@ -42,7 +42,7 @@
 		#size-cells = <1>;
 		ranges = <0x0 0x0 0x00100000 0x1c000>;
 
-		serdes_ln_ctrl: mux@4080 {
+		serdes_ln_ctrl: mux-controller@4080 {
 			compatible = "mmio-mux";
 			reg = <0x00004080 0x50>;
 			#mux-control-cells = <1>;
-- 
2.34.1



