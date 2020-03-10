Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A352017FA1A
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:02:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730018AbgCJNCr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:02:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:46338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730464AbgCJNCq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:02:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10DC4208E4;
        Tue, 10 Mar 2020 13:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845364;
        bh=CLL7T+YiC1fWFLnmvzohg0ZeFuSTWM7U9KxIUt33uq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VE0JTBrqkMoLhQBSKwlpAZhbd5aX5rOuHUC/YJv2KHM92HDqkDfyffJaT0/4SNk2Z
         bSeycA3EE9qaVudDifv09PFBfr7+jO5oA3PrOSKIhxyl7OaozEWLF5dZ3OTrCb9uFk
         YV4SqjchxDfDfYGdYDsfT6qyIWjVCJL2UGsb+Qwo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 5.5 154/189] arm64: dts: imx8qxp-mek: Remove unexisting Ethernet PHY
Date:   Tue, 10 Mar 2020 13:39:51 +0100
Message-Id: <20200310123655.479386222@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123639.608886314@linuxfoundation.org>
References: <20200310123639.608886314@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Estevam <festevam@gmail.com>

commit 26c4b4758fce8f0ae744335e1762213be29db441 upstream.

There is only on Ethernet port and one Ethernet PHY on imx8qxp-mek.

Remove the unexisting ethphy1 port.

This fixes a run-time warning:

mdio_bus 5b040000.ethernet-1: MDIO device at address 1 is missing.

Fixes: fdea904e85e1 ("arm64: dts: imx: add imx8qxp mek support")
Signed-off-by: Fabio Estevam <festevam@gmail.com>
Reviewed-by: Leonard Crestez <leonard.crestez@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/boot/dts/freescale/imx8qxp-mek.dts |    5 -----
 1 file changed, 5 deletions(-)

--- a/arch/arm64/boot/dts/freescale/imx8qxp-mek.dts
+++ b/arch/arm64/boot/dts/freescale/imx8qxp-mek.dts
@@ -52,11 +52,6 @@
 			compatible = "ethernet-phy-ieee802.3-c22";
 			reg = <0>;
 		};
-
-		ethphy1: ethernet-phy@1 {
-			compatible = "ethernet-phy-ieee802.3-c22";
-			reg = <1>;
-		};
 	};
 };
 


