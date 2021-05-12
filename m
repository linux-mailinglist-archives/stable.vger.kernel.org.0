Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B47C537C4BF
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234560AbhELPdM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:33:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:38874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234319AbhELPYp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:24:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 914E76144B;
        Wed, 12 May 2021 15:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832220;
        bh=fRwySrHidtwTz3xdd3XUoRvBEGEyE54CoAVlnjs1pwU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=anaCYM4Pb/LP8uFCApGPD6YxoXFyX0WZzIl+rDU7RDO74XlVOSoyhybIGMgTjhtAX
         MJ3Qo5PaUpjyhAw7itNjYPDX68HtOT6cm/x+g506eJ0h+ukxT6fcafCJiNr2ycAqDH
         h+VqzwoKyla+Osg3zOMh/GKBrrZyjNSi5zQV22r4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabien Parent <fparent@baylibre.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 191/530] arm64: dts: mediatek: fix reset GPIO level on pumpkin
Date:   Wed, 12 May 2021 16:45:01 +0200
Message-Id: <20210512144826.109806195@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabien Parent <fparent@baylibre.com>

[ Upstream commit a7dceafed43a4a610d340da3703653cca2c50c1d ]

The tca6416 chip is active low. Fix the reset-gpios value.

Fixes: e2a8fa1e0faa ("arm64: dts: mediatek: fix tca6416 reset GPIOs in pumpkin")
Signed-off-by: Fabien Parent <fparent@baylibre.com>
Link: https://lore.kernel.org/r/20210223221826.2063911-1-fparent@baylibre.com
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi b/arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi
index 29d8cf6df46b..99c2d6fd6304 100644
--- a/arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi
+++ b/arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi
@@ -56,7 +56,7 @@
 	tca6416: gpio@20 {
 		compatible = "ti,tca6416";
 		reg = <0x20>;
-		reset-gpios = <&pio 65 GPIO_ACTIVE_HIGH>;
+		reset-gpios = <&pio 65 GPIO_ACTIVE_LOW>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&tca6416_pins>;
 
-- 
2.30.2



