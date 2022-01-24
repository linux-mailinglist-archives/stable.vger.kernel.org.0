Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD9E499800
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349522AbiAXVSH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:18:07 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35896 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449681AbiAXVQA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:16:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EDB65B8105C;
        Mon, 24 Jan 2022 21:15:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CC31C340E4;
        Mon, 24 Jan 2022 21:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058957;
        bh=8ntT8bn7mdE+kEh+TvWHhZ2ZY1wkjhRLlEw0CeWml1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2h1gwdqdSEiZ0v9FIPn89xang9+z4vx3NebePAfFKHSt6/PVyAHR8/LIpMMRYBjMz
         K/jbjkDIfkNtvuT6HpwB16io3mBfXdhBmqWKXbIiJ/excGsicLx57/DueSwTxpM5tf
         dpLnlRiCI6/1wnZJBP/lGoXH/aqZHOxOoOSeJAu0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0458/1039] ASoC: codecs: wcd938x: add SND_SOC_WCD938_SDW to codec list instead
Date:   Mon, 24 Jan 2022 19:37:27 +0100
Message-Id: <20220124184140.692423841@linuxfoundation.org>
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

From: Lukas Bulwahn <lukas.bulwahn@gmail.com>

[ Upstream commit 2039cc1da4bee1fd0df644e26b28ed769cd32a81 ]

Commit 045442228868 ("ASoC: codecs: wcd938x: add audio routing and
Kconfig") adds SND_SOC_WCD937X, which does not exist, and
SND_SOC_WCD938X, which seems not really to be the intended config to be
selected, but only a supporting config symbol to the actual config
SND_SOC_WCD938X_SDW for the codec.

Add SND_SOC_WCD938_SDW to the list instead of SND_SOC_WCD93{7,8}X.

The issue was identified with ./scripts/checkkconfigsymbols.py.

Fixes: 045442228868 ("ASoC: codecs: wcd938x: add audio routing and Kconfig")
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Link: https://lore.kernel.org/r/20211125095158.8394-3-lukas.bulwahn@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/Kconfig | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index 326f2d611ad4e..3a610ba183ffb 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -241,8 +241,7 @@ config SND_SOC_ALL_CODECS
 	imply SND_SOC_UDA1380
 	imply SND_SOC_WCD9335
 	imply SND_SOC_WCD934X
-	imply SND_SOC_WCD937X
-	imply SND_SOC_WCD938X
+	imply SND_SOC_WCD938X_SDW
 	imply SND_SOC_LPASS_RX_MACRO
 	imply SND_SOC_LPASS_TX_MACRO
 	imply SND_SOC_WL1273
-- 
2.34.1



