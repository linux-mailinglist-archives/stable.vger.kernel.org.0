Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38C133D2973
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233856AbhGVQEF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:04:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:39726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233887AbhGVQDK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:03:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF3A261C29;
        Thu, 22 Jul 2021 16:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972218;
        bh=OcXRq3Z8o+l1kH7/DxfplbAae3MTq8zuuj5wOwrhSGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TcQ0WVCDB7dhPLkMUT4plbit07PXPzvGzbSxk3BHzU4ON4d4vPboX5pu4uIoJ4Qdf
         zwxbokIvAQTgw7zwjJ8H37QFlZLOiUG+xBT2ImnE0flznLNYetMclACoA1mISvN6Y1
         KzfwjjnNQ5mi/sQcBdBYrPjrJNEo2M/PJp9827ok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ezequiel Garcia <ezequiel@collabora.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 003/156] ARM: dts: rockchip: Fix thermal sensor cells o rk322x
Date:   Thu, 22 Jul 2021 18:29:38 +0200
Message-Id: <20210722155628.488340618@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ezequiel Garcia <ezequiel@collabora.com>

[ Upstream commit d5c24e20daf09587cbc221d40be1ba92673e8d94 ]

The number of cells to be used with a thermal sensor specifier
must be "1". Fix this.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20210506175514.168365-2-ezequiel@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/rk322x.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/rk322x.dtsi b/arch/arm/boot/dts/rk322x.dtsi
index 208f21245095..9f02ba7a0cc2 100644
--- a/arch/arm/boot/dts/rk322x.dtsi
+++ b/arch/arm/boot/dts/rk322x.dtsi
@@ -517,7 +517,7 @@
 		pinctrl-0 = <&otp_pin>;
 		pinctrl-1 = <&otp_out>;
 		pinctrl-2 = <&otp_pin>;
-		#thermal-sensor-cells = <0>;
+		#thermal-sensor-cells = <1>;
 		rockchip,hw-tshut-temp = <95000>;
 		status = "disabled";
 	};
-- 
2.30.2



