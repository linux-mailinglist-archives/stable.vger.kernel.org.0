Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7DF33A02FE
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236616AbhFHTLp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:11:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:58908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237416AbhFHTJg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:09:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6C976141E;
        Tue,  8 Jun 2021 18:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623178102;
        bh=2051omGRCgbqyD5yjue/gMMoDodud1d4XeCDfFUHNZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hwoeW6rp7zuobR3cFyEvFiyqErntUp+5y5saixox62Gsu8S5tUjeQOpdpuCcbosIX
         bGDNdi3okFpt+YzutNuoT9poaO1STRRHfIJgoOlz+OUK0W58gdU3ModTmaIWtAjJTn
         epbJOsC86/RhRA6BpRgCMFFJxXsgIGyyms+3FPyg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 076/161] ARM: dts: imx: emcon-avari: Fix nxp,pca8574 #gpio-cells
Date:   Tue,  8 Jun 2021 20:26:46 +0200
Message-Id: <20210608175948.019730976@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
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



