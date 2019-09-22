Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F378BA457
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 20:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391402AbfIVSsH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:48:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:44810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391371AbfIVSsG (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:48:06 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5324C214D9;
        Sun, 22 Sep 2019 18:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178086;
        bh=bKfn+btWwWWiPbw7VyR5q/2ZiI1dAcsXHfdj2EDnlZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pgWBuuNqPVAE+nhRstuxAzX1Y4sOogcT490xiF0CJk+2bAhHpkS0skOuVExOTbBWb
         XyHgH7FSFWmtQHzv5DHOg2WA3xsANn8r7srb//kcwykhwwrqwfJCCWulLnyMLxnY5m
         PUfB1oR6jkts2b2kACxjvFQwskARsSY/PTCFarcg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maxime Ripard <maxime.ripard@bootlin.com>,
        Rob Herring <robh@kernel.org>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 154/203] ASoC: dt-bindings: sun4i-spdif: Fix dma-names warning
Date:   Sun, 22 Sep 2019 14:43:00 -0400
Message-Id: <20190922184350.30563-154-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184350.30563-1-sashal@kernel.org>
References: <20190922184350.30563-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime.ripard@bootlin.com>

[ Upstream commit 1a8e7cdfa4f5872bf0c202d09bff6628aba6b9f6 ]

Even though the H6 compatible has been properly added, the exeption for the
number of DMA channels hasn't been updated, leading in a validation
warning.

Fix this.

Fixes: b20453031472 ("dt-bindings: sound: sun4i-spdif: Add Allwinner H6 compatible")
Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
Link: https://lore.kernel.org/r/20190828125209.28173-1-mripard@kernel.org
Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/sound/allwinner,sun4i-a10-spdif.yaml  | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/sound/allwinner,sun4i-a10-spdif.yaml b/Documentation/devicetree/bindings/sound/allwinner,sun4i-a10-spdif.yaml
index e0284d8c3b636..38d4cede0860d 100644
--- a/Documentation/devicetree/bindings/sound/allwinner,sun4i-a10-spdif.yaml
+++ b/Documentation/devicetree/bindings/sound/allwinner,sun4i-a10-spdif.yaml
@@ -70,7 +70,9 @@ allOf:
       properties:
         compatible:
           contains:
-            const: allwinner,sun8i-h3-spdif
+            enum:
+              - allwinner,sun8i-h3-spdif
+              - allwinner,sun50i-h6-spdif
 
     then:
       properties:
-- 
2.20.1

