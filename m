Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A190A3A01EE
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235386AbhFHS6L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:58:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:52366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236980AbhFHS4K (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:56:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B86B6615A0;
        Tue,  8 Jun 2021 18:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177700;
        bh=2051omGRCgbqyD5yjue/gMMoDodud1d4XeCDfFUHNZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ib0ekq46mm/pd2ax36LM3BnASfs5P7Ias26I9clsApJbctpcjbVeRquWuHE0ISKVO
         /1llIr4bO2EQflLagMUpFw4ojYUV75IMdjStAbXNu1izz0GSEPlMo7XXijCJB1+2Cr
         +vyAGl7Yj3D56qqILnhsHKaeE3MRJO4JB7d1ixDw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 067/137] ARM: dts: imx: emcon-avari: Fix nxp,pca8574 #gpio-cells
Date:   Tue,  8 Jun 2021 20:26:47 +0200
Message-Id: <20210608175944.635928792@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175942.377073879@linuxfoundation.org>
References: <20210608175942.377073879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit b73eb6b3b91ff7d76cff5f8c7ab92fe0c51e3829 ]

According to the DT bindings, #gpio-cells must be two.

Fixes: 63e71fedc07c4ece ("ARM: dts: Add support for emtrion emCON-MX6 series")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6qdl-emcon-avari.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx6qdl-emcon-avari.dtsi b/arch/arm/boot/dts/imx6qdl-emcon-avari.dtsi
index 828cf3e39784..c4e146f3341b 100644
--- a/arch/arm/boot/dts/imx6qdl-emcon-avari.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-emcon-avari.dtsi
@@ -126,7 +126,7 @@
 		compatible = "nxp,pca8574";
 		reg = <0x3a>;
 		gpio-controller;
-		#gpio-cells = <1>;
+		#gpio-cells = <2>;
 	};
 };
 
-- 
2.30.2



