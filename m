Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBDEA101861
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:07:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729382AbfKSFcX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:32:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:52668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728824AbfKSFcW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:32:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D052021783;
        Tue, 19 Nov 2019 05:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141542;
        bh=ycY+drilEGsuAc0TqZW982ftVP8L7XHLLduCT27lNnk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nZkgGTPXxbgAHTjI8ucspH8+qFqZ0Y0D6iJoFMysIjP3EYOtaAOs8PBeV9iiQybEE
         k937aJ0P/yDatvmA1FZlx4uRjet7mW0Keoqpw+hPXff/M7ut/M3n4o8jUijAauda4F
         oZXya5QSv3K3tXxsNpbptg+fQL831iKroZAAaGf4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 197/422] arm64: dts: renesas: salvator-common: adv748x: Override secondary addresses
Date:   Tue, 19 Nov 2019 06:16:34 +0100
Message-Id: <20191119051411.337601402@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



