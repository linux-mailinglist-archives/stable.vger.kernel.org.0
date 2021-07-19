Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0E5C3CE5B5
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348966AbhGSPxK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:53:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:48162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347120AbhGSPrt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:47:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDF466142C;
        Mon, 19 Jul 2021 16:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626712077;
        bh=UmLDDuHsDMQSXQ7CGjLaMI8m20POY947kK+WUlq0OYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EiPgpKRZiZfCLrz7zTGAgb1JDdW3mZpRufs4YtgNy64y6EaorzlktfyMs1m6sEg9D
         O+MuE0oUXyJXLj2DAPzAyxZnQWf8sfj7zQ1TsxFIc9mtyiV4kilqECKruH7Xa5VMXp
         NrRe4AaYiRHghtarHBxvc/7Ep9/2WNwUy7D7rZDc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roger Quadros <rogerq@ti.com>,
        Aswath Govindraju <a-govindraju@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Nishanth Menon <nm@ti.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 242/292] arm64: dts: ti: j7200-main: Enable USB2 PHY RX sensitivity workaround
Date:   Mon, 19 Jul 2021 16:55:04 +0200
Message-Id: <20210719144950.916742224@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roger Quadros <rogerq@ti.com>

[ Upstream commit a2894d85f44ba3f2bdf5806c8dc62e2ec40c1c09 ]

Enable work around feature built into the controller to address issue with
RX Sensitivity for USB2 PHY.

Fixes: 6197d7139d12 ("arm64: dts: ti: k3-j7200-main: Add USB controller")
Signed-off-by: Roger Quadros <rogerq@ti.com>
Signed-off-by: Aswath Govindraju <a-govindraju@ti.com>
Reviewed-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
Link: https://lore.kernel.org/r/20210512153308.5840-1-a-govindraju@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-j7200-main.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/ti/k3-j7200-main.dtsi b/arch/arm64/boot/dts/ti/k3-j7200-main.dtsi
index 3398f174f09b..bfdf63d3947f 100644
--- a/arch/arm64/boot/dts/ti/k3-j7200-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j7200-main.dtsi
@@ -671,6 +671,7 @@
 					  "otg";
 			maximum-speed = "super-speed";
 			dr_mode = "otg";
+			cdns,phyrst-a-enable;
 		};
 	};
 
-- 
2.30.2



