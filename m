Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C82E499922
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1454218AbiAXVcC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:32:02 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42788 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1451919AbiAXVXr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:23:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ADB0A614BE;
        Mon, 24 Jan 2022 21:23:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CCD6C340E4;
        Mon, 24 Jan 2022 21:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059426;
        bh=1VmxqRQqnMtNeL4jEfDUqZK8fk1huCUw/3YpBo2zpvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cZqDrV4+DBDHJOSeMnGBXoDjsUPUAklk4mRKJydgH7sX+e4c5JHbP+JuVlQVL9wjI
         tVhiLiQvzqBVIPqgx5sQFCtTOFQ34UP2R9ov9B8pTd0xKtOPJ8lFBJMe+y2+IU8JJG
         M+p6grlj6zNjTDHdHNLJWGOVaOI5ajZwETNmo+S4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>,
        Aswath Govindraju <a-govindraju@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0611/1039] arm64: dts: ti: j7200-main: Fix dtbs_check serdes_ln_ctrl node
Date:   Mon, 24 Jan 2022 19:40:00 +0100
Message-Id: <20220124184145.879252999@linuxfoundation.org>
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
@@ -32,7 +32,7 @@
 		#size-cells = <1>;
 		ranges = <0x00 0x00 0x00100000 0x1c000>;
 
-		serdes_ln_ctrl: serdes-ln-ctrl@4080 {
+		serdes_ln_ctrl: mux-controller@4080 {
 			compatible = "mmio-mux";
 			#mux-control-cells = <1>;
 			mux-reg-masks = <0x4080 0x3>, <0x4084 0x3>, /* SERDES0 lane0/1 select */
-- 
2.34.1



