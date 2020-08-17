Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9014246BC2
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 18:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388189AbgHQQCU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 12:02:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:49154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388183AbgHQQCQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:02:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0039820888;
        Mon, 17 Aug 2020 16:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680136;
        bh=2wVZT9ZwJSV3mZRLRZbravFmdRZE3d2p1fxTXI7EZ8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l7bDXbZIztT6M9DT+Ogdo5yYqTiBLgogvQ2CWF5q3FytLmW8epPuSrXY+TWdvhunI
         z+saSLQ2PHStFfbtD6ZliycYOuRAg3fiNMwi+Hi5Mw/TpYN6OMs70+2Pxgejmo215B
         86rDLTLiqVSRF/tIacN7nTPJCKPU2EG2t4SULYhI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 026/270] ARM: dts: gose: Fix ports node name for adv7180
Date:   Mon, 17 Aug 2020 17:13:47 +0200
Message-Id: <20200817143757.083892025@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143755.807583758@linuxfoundation.org>
References: <20200817143755.807583758@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

[ Upstream commit d344234abde938ae1062edb6c05852b0bafb4a03 ]

When adding the adv7180 device node the ports node was misspelled as
port, fix this.

Fixes: 8cae359049a88b75 ("ARM: dts: gose: add composite video input")
Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Link: https://lore.kernel.org/r/20200704155856.3037010-2-niklas.soderlund+renesas@ragnatech.se
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/r8a7793-gose.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/r8a7793-gose.dts b/arch/arm/boot/dts/r8a7793-gose.dts
index 42f3313e6988a..dc435ac95d23a 100644
--- a/arch/arm/boot/dts/r8a7793-gose.dts
+++ b/arch/arm/boot/dts/r8a7793-gose.dts
@@ -339,7 +339,7 @@ composite-in@20 {
 			reg = <0x20>;
 			remote = <&vin1>;
 
-			port {
+			ports {
 				#address-cells = <1>;
 				#size-cells = <0>;
 
-- 
2.25.1



