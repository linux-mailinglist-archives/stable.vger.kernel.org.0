Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6328EF4660
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 12:42:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389763AbfKHLmF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:42:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:55688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389755AbfKHLmE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:42:04 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20C5C222C4;
        Fri,  8 Nov 2019 11:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213323;
        bh=ycY+drilEGsuAc0TqZW982ftVP8L7XHLLduCT27lNnk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sCL5RmDDusTZgove/q9ztclYeIG7sKbTDQrAaA7exScOLvt2jrRaxgQ69UR7BeTwX
         rfv3Vpv8EmsGlQv8dodRvMVz6fPak9pRz1ZNbmg1+pbjwoySf2KO8Zq2VdH5wSZF3n
         bQxtdbaRdldxjXWqQqD1tiq0ZLU8ekVYpf4FeoYg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        Sasha Levin <sashal@kernel.org>,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 166/205] arm64: dts: renesas: salvator-common: adv748x: Override secondary addresses
Date:   Fri,  8 Nov 2019 06:37:13 -0500
Message-Id: <20191108113752.12502-166-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kieran Bingham <kieran.bingham@ideasonboard.com>

[ Upstream commit e3da41a6c28f9b61ea03df987f1c9ffffc8b8e60 ]

Ensure that the ADV748x device addresses do not conflict, and group them
together (visually in i2cdetect)

Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/salvator-common.dtsi | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/renesas/salvator-common.dtsi b/arch/arm64/boot/dts/renesas/salvator-common.dtsi
index 7d3d866a00635..3b90f816dfefc 100644
--- a/arch/arm64/boot/dts/renesas/salvator-common.dtsi
+++ b/arch/arm64/boot/dts/renesas/salvator-common.dtsi
@@ -420,7 +420,10 @@
 
 	video-receiver@70 {
 		compatible = "adi,adv7482";
-		reg = <0x70>;
+		reg = <0x70 0x71 0x72 0x73 0x74 0x75
+		       0x60 0x61 0x62 0x63 0x64 0x65>;
+		reg-names = "main", "dpll", "cp", "hdmi", "edid", "repeater",
+			    "infoframe", "cbus", "cec", "sdp", "txa", "txb" ;
 
 		#address-cells = <1>;
 		#size-cells = <0>;
-- 
2.20.1

