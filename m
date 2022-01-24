Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 836824998E2
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:39:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1453665AbiAXVag (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:30:36 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43322 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1450518AbiAXVUq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:20:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8302B614B7;
        Mon, 24 Jan 2022 21:20:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AA60C340E4;
        Mon, 24 Jan 2022 21:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059245;
        bh=I+JvnFAHS41UTtNdATtf26YEGvSzYJcB0kAE6Oy/G6M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iozpRhXVp6DnZmzNZusRx7dOGnfR7eXnmrFoYBajG+UzE84h+uUnlraYoYYpFSr28
         WxfR3zbnb53qLfr4x6IdSmAuNEn1xCoXLfPdSa1W/opoEJXLW9AhhrQGpKliE1fZJ6
         U00DXuaWoWQB02/z+qASgw76SbZXl72ReVJ7vqFc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alyssa Ross <hi@alyssa.is>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0518/1039] ASoC: fsl_mqs: fix MODULE_ALIAS
Date:   Mon, 24 Jan 2022 19:38:27 +0100
Message-Id: <20220124184142.708145770@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alyssa Ross <hi@alyssa.is>

[ Upstream commit 9f3d45318dd9e739ed62e4218839a7a824d3cced ]

modprobe can't handle spaces in aliases.

Fixes: 9e28f6532c61 ("ASoC: fsl_mqs: Add MQS component driver")
Signed-off-by: Alyssa Ross <hi@alyssa.is>
Link: https://lore.kernel.org/r/20220104132218.1690103-1-hi@alyssa.is
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_mqs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/fsl/fsl_mqs.c b/sound/soc/fsl/fsl_mqs.c
index 27b4536dce443..ceaecbe3a25e4 100644
--- a/sound/soc/fsl/fsl_mqs.c
+++ b/sound/soc/fsl/fsl_mqs.c
@@ -337,4 +337,4 @@ module_platform_driver(fsl_mqs_driver);
 MODULE_AUTHOR("Shengjiu Wang <Shengjiu.Wang@nxp.com>");
 MODULE_DESCRIPTION("MQS codec driver");
 MODULE_LICENSE("GPL v2");
-MODULE_ALIAS("platform: fsl-mqs");
+MODULE_ALIAS("platform:fsl-mqs");
-- 
2.34.1



