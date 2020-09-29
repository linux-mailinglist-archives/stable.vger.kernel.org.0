Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF1E27B968
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 03:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727288AbgI2Baj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 21:30:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:39510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727344AbgI2Bah (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Sep 2020 21:30:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 880A321D7D;
        Tue, 29 Sep 2020 01:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601343037;
        bh=unoHxtSRdKvnphH9lXj1ePIn2asvOMskiEcRPQoPudE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SU4PNONJi/SgfWd74Y21rYvMHi5XG6B8hZy+28FeDRQMWphHp53EdUMXzqCn4ftyf
         eyUjF82Le5BBHLNaXJ6SEfX9ZI5lgm15Eopu/2uYQ3h+9Tmf5LGMLIga0hyMFfKQh5
         olLr9E2Y9xeqIU8nyRgZRctdZQlnvqHLMur3n1DY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Martin Cerveny <m.cerveny@computer.org>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.8 07/29] drm/sun4i: mixer: Extend regmap max_register
Date:   Mon, 28 Sep 2020 21:30:04 -0400
Message-Id: <20200929013027.2406344-7-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929013027.2406344-1-sashal@kernel.org>
References: <20200929013027.2406344-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Cerveny <m.cerveny@computer.org>

[ Upstream commit 74ea06164cda81dc80e97790164ca533fd7e3087 ]

Better guess. Secondary CSC registers are from 0xF0000.

Signed-off-by: Martin Cerveny <m.cerveny@computer.org>
Reviewed-by: Jernej Skrabec <jernej.skrabec@siol.net>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20200906162140.5584-3-m.cerveny@computer.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun8i_mixer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/sun4i/sun8i_mixer.c b/drivers/gpu/drm/sun4i/sun8i_mixer.c
index cc4fb916318f3..c3304028e3dcd 100644
--- a/drivers/gpu/drm/sun4i/sun8i_mixer.c
+++ b/drivers/gpu/drm/sun4i/sun8i_mixer.c
@@ -307,7 +307,7 @@ static struct regmap_config sun8i_mixer_regmap_config = {
 	.reg_bits	= 32,
 	.val_bits	= 32,
 	.reg_stride	= 4,
-	.max_register	= 0xbfffc, /* guessed */
+	.max_register	= 0xffffc, /* guessed */
 };
 
 static int sun8i_mixer_of_get_id(struct device_node *node)
-- 
2.25.1

