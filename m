Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDAF37CBDF
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235464AbhELQiZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:38:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:49666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237325AbhELQaF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:30:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9559861352;
        Wed, 12 May 2021 15:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835030;
        bh=lQWy1ogfCru3Jdza/vqNIxirYCHGCM1ChXjdqpLguAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O5h/1bW+xQ5J/JomzOfEPr6R9SIb6cqBUTLvBKDbtrMVx3OyPyVexkbXGREomW0I1
         LSgWDfo3Iz74KDHok5cv2aTz+DF1ygS613STpl8z0c7YH7ZSTshn7bglbwhOnEOm2s
         E44MHFCX/dhzfMLhbPG95R/Qt+3g7XbsMT6zoIfs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 179/677] arm64: dts: broadcom: bcm4908: fix switch parent node name
Date:   Wed, 12 May 2021 16:43:45 +0200
Message-Id: <20210512144843.183506437@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit a348ff97ffb840b9d74b0e64b3e0e6002187d224 ]

Ethernet switch and MDIO are grouped using "simple-bus". It's not
allowed to use "ethernet-switch" node name as it isn't a switch. Replace
it with "bus".

Fixes: 527a3ac9bdf8 ("arm64: dts: broadcom: bcm4908: describe internal switch")
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi b/arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi
index 9354077f74cd..9e799328c6db 100644
--- a/arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi
+++ b/arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi
@@ -131,7 +131,7 @@
 			status = "disabled";
 		};
 
-		ethernet-switch@80000 {
+		bus@80000 {
 			compatible = "simple-bus";
 			#size-cells = <1>;
 			#address-cells = <1>;
-- 
2.30.2



