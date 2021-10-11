Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4691C428F56
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 15:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236840AbhJKN5j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 09:57:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:39742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236911AbhJKNzm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:55:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9566610C8;
        Mon, 11 Oct 2021 13:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960383;
        bh=Io/4ppa+oQGBnZuwCiFENoxZpM+nqYKIaoBGzVn7u2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n5D4QDCXOYLtBGrGpc8zw4yffyYG5TKuQe+zUps/Z2fXsynYWcT+e7MLP0KU4RkNi
         IZQ4VJVUiNH33HoNfs+lgP7kOEZA/yGi0a4/kOviukYzmqtZ8pBnhu84bGcWpvRmHE
         YZhxMFYNbHwBfYYlz1fcXTXbZHjIyvNUMkP9sI7c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 45/83] dt-bindings: drm/bridge: ti-sn65dsi86: Fix reg value
Date:   Mon, 11 Oct 2021 15:46:05 +0200
Message-Id: <20211011134509.959795246@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134508.362906295@linuxfoundation.org>
References: <20211011134508.362906295@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit b2d70c0dbf2731a37d1c7bcc86ab2387954d5f56 ]

make dtbs_check:

    arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dt.yaml: bridge@2c: reg:0:0: 45 was expected

According to the datasheet, the I2C address can be either 0x2c or 0x2d,
depending on the ADDR control input.

Fixes: e3896e6dddf0b821 ("dt-bindings: drm/bridge: Document sn65dsi86 bridge bindings")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
Link: https://lore.kernel.org/r/08f73c2aa0d4e580303357dfae107d084d962835.1632486753.git.geert+renesas@glider.be
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/display/bridge/ti,sn65dsi86.yaml        | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/display/bridge/ti,sn65dsi86.yaml b/Documentation/devicetree/bindings/display/bridge/ti,sn65dsi86.yaml
index f8622bd0f61e..f0e0345da498 100644
--- a/Documentation/devicetree/bindings/display/bridge/ti,sn65dsi86.yaml
+++ b/Documentation/devicetree/bindings/display/bridge/ti,sn65dsi86.yaml
@@ -18,7 +18,7 @@ properties:
     const: ti,sn65dsi86
 
   reg:
-    const: 0x2d
+    enum: [ 0x2c, 0x2d ]
 
   enable-gpios:
     maxItems: 1
-- 
2.33.0



