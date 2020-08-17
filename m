Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06B30246FC2
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 19:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731636AbgHQRxf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 13:53:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:41076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388635AbgHQQLk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:11:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD68E20829;
        Mon, 17 Aug 2020 16:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680698;
        bh=ieYQdzrY3+Von0WGrYWU5T18p5B4q0CSlpJT2dOY+EM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JUSUYsJ+kdaOGbnVA8trCXJSJboaMrs4q835NfsEF1Y5JANmBOk5uJHmrBV75gVpr
         5ZpsoOKvuh65LCn9wXXrs3+dSA2yyoqkNCcFB2Jc+aO0P97mV3IUwau3y307XRs7Ew
         zPGFF+r/erQvFCGdXtB1Zq9jpQRUVBxWz9PxYhFQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 020/168] ARM: dts: gose: Fix ports node name for adv7180
Date:   Mon, 17 Aug 2020 17:15:51 +0200
Message-Id: <20200817143734.732002368@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143733.692105228@linuxfoundation.org>
References: <20200817143733.692105228@linuxfoundation.org>
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
index 6b2f3a4fd13d6..9235be8f0f007 100644
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



