Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9454800F8
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:51:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231472AbhL0Pvr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:51:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240857AbhL0Pty (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:49:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E85CC0698D4;
        Mon, 27 Dec 2021 07:45:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0022B810BF;
        Mon, 27 Dec 2021 15:45:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19A7EC36AE7;
        Mon, 27 Dec 2021 15:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619904;
        bh=h696b4T6pl5xyGVboPnC83c0A5h/TomINgPCXlGpkLM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0ZfMZ8yTTg91ZAoywzwYSE/hZ47sJXtUlYlGVzsiBFCdqaVrdJcPU3vSuhefjLGYE
         lsaOevDvU/PYuyrTS8FrRfKdb1mTR6Xzl+xJnJLoc4bhsLt3Z/L/0k96kpSmSNp8Xt
         vNRjPiTeADBWqbgu7RPY4BuG3MzkHmW87skDWxjo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Ying <ying.zhang22455@nxp.com>,
        Li Yang <leoyang.li@nxp.com>, Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 5.15 110/128] arm64: dts: lx2160a: fix scl-gpios property name
Date:   Mon, 27 Dec 2021 16:31:25 +0100
Message-Id: <20211227151335.193945141@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Ying-22455 <ying.zhang22455@nxp.com>

commit 849e087ba68ac6956c11016ce34f9f10a09a4186 upstream.

Fix the typo in the property name.

Fixes: d548c217c6a3c ("arm64: dts: add QorIQ LX2160A SoC support")
Signed-off-by: Zhang Ying <ying.zhang22455@nxp.com>
Signed-off-by: Li Yang <leoyang.li@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
@@ -719,7 +719,7 @@
 			clock-names = "i2c";
 			clocks = <&clockgen QORIQ_CLK_PLATFORM_PLL
 					    QORIQ_CLK_PLL_DIV(16)>;
-			scl-gpio = <&gpio2 15 GPIO_ACTIVE_HIGH>;
+			scl-gpios = <&gpio2 15 GPIO_ACTIVE_HIGH>;
 			status = "disabled";
 		};
 
@@ -768,7 +768,7 @@
 			clock-names = "i2c";
 			clocks = <&clockgen QORIQ_CLK_PLATFORM_PLL
 					    QORIQ_CLK_PLL_DIV(16)>;
-			scl-gpio = <&gpio2 16 GPIO_ACTIVE_HIGH>;
+			scl-gpios = <&gpio2 16 GPIO_ACTIVE_HIGH>;
 			status = "disabled";
 		};
 


