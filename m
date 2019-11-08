Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5447F49CE
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:06:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389682AbfKHLlw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:41:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:55422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389673AbfKHLlw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:41:52 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BBFD621D7B;
        Fri,  8 Nov 2019 11:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213311;
        bh=hVTmL0FORV+KWz1VpzuweX8Ats/8839pboW72CRooBI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SCT51chryrurGhdtaopz153rkWZEITV7g1WAdPJ5oKby6uyyErRAFr9am/df+6XpA
         GdNvl8qkbQCYL+1yd77NMucZjekEahILR/dO0SEnahrQee6bN8OMAkaPRRWZbOIa3x
         c8O/YsBOwvu9CcgIjzAbDhFV93Z05gUNw7JeIQWw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Rob Herring <robh@kernel.org>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 158/205] media: dt-bindings: adv748x: Fix decimal unit addresses
Date:   Fri,  8 Nov 2019 06:37:05 -0500
Message-Id: <20191108113752.12502-158-sashal@kernel.org>
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 27582f0ea97fe3e4a38beb98ab36cce4b6f029d5 ]

With recent dtc and W=1:

    Warning (graph_port): video-receiver@70/port@10: graph node unit address error, expected "a"
    Warning (graph_port): video-receiver@70/port@11: graph node unit address error, expected "b"

Unit addresses are always hexadecimal (without prefix), while the bases
of reg property values depend on their prefixes.

Fixes: e69595170b1cad85 ("media: adv748x: Add adv7481, adv7482 bindings")

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Rob Herring <robh@kernel.org>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/media/i2c/adv748x.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/i2c/adv748x.txt b/Documentation/devicetree/bindings/media/i2c/adv748x.txt
index 21ffb5ed81830..54d1d3bc18694 100644
--- a/Documentation/devicetree/bindings/media/i2c/adv748x.txt
+++ b/Documentation/devicetree/bindings/media/i2c/adv748x.txt
@@ -73,7 +73,7 @@ Example:
 			};
 		};
 
-		port@10 {
+		port@a {
 			reg = <10>;
 
 			adv7482_txa: endpoint {
@@ -83,7 +83,7 @@ Example:
 			};
 		};
 
-		port@11 {
+		port@b {
 			reg = <11>;
 
 			adv7482_txb: endpoint {
-- 
2.20.1

