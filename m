Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3917A4996CD
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:20:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443264AbiAXVGx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:06:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381767AbiAXUtE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:49:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FDD9C0418B5;
        Mon, 24 Jan 2022 11:58:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1129B81218;
        Mon, 24 Jan 2022 19:57:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 110D1C340E5;
        Mon, 24 Jan 2022 19:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054277;
        bh=zFvwzpFQWjdF+o/sqOiU7jfu+9OjkMg1F/9RRwCH8ws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r6S4ZmOoZ2Skam62FMmMvq5Ve+SVDfpydQ9YNQ7kIWZ/AFOa4x1Lis53XANpwp/d9
         pPUt8ZmZgbIkoai6Y6dFz4Uz3nkmj93uqholSRZSu8tpcO1dAzTSJ1GQVTo0hQUFTm
         h8jXY4rTrqyxugOROtTrPce1ccEDZV1/1wb2OBo4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>,
        Aswath Govindraju <a-govindraju@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 337/563] arm64: dts: ti: j7200-main: Fix dtbs_check serdes_ln_ctrl node
Date:   Mon, 24 Jan 2022 19:41:42 +0100
Message-Id: <20220124184036.087679600@linuxfoundation.org>
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
index 5832ad830ed14..1ab9f9604af6c 100644
--- a/arch/arm64/boot/dts/ti/k3-j7200-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j7200-main.dtsi
@@ -25,7 +25,7 @@
 		#size-cells = <1>;
 		ranges = <0x00 0x00 0x00100000 0x1c000>;
 
-		serdes_ln_ctrl: serdes-ln-ctrl@4080 {
+		serdes_ln_ctrl: mux-controller@4080 {
 			compatible = "mmio-mux";
 			#mux-control-cells = <1>;
 			mux-reg-masks = <0x4080 0x3>, <0x4084 0x3>, /* SERDES0 lane0/1 select */
-- 
2.34.1



