Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B69124F7EE
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730222AbgHXJX2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 05:23:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:34544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730309AbgHXIyS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:54:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87895207DF;
        Mon, 24 Aug 2020 08:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598259258;
        bh=Gl4jNOH4OH/fe6YEFEorvVIhkVY8kwj2SMw84rehO6c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Z6z9cmS7MR8TYiioz68QuzK3XHAZjntrQwijkNJzAZLDh7Zn50XuXUKJW3uu1XpY
         /q4Wjhx56W3u9vy/c1OLcHAA+8pkGpaYCfPmioo2wvRFmvKz/pD7etBI+IGSQZ+ing
         Tz/WPG7CcU+Cn5qZhYoS+oJl/bdvEQwh6YjSY1Vo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Stephan Gerhold <stephan@gerhold.net>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 39/50] ASoC: msm8916-wcd-analog: fix register Interrupt offset
Date:   Mon, 24 Aug 2020 10:31:40 +0200
Message-Id: <20200824082354.029293409@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082351.823243923@linuxfoundation.org>
References: <20200824082351.823243923@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit ff69c97ef84c9f7795adb49e9f07c9adcdd0c288 ]

For some reason interrupt set and clear register offsets are
not set correctly.
This patch corrects them!

Fixes: 585e881e5b9e ("ASoC: codecs: Add msm8916-wcd analog codec")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Tested-by: Stephan Gerhold <stephan@gerhold.net>
Reviewed-by: Stephan Gerhold <stephan@gerhold.net>
Link: https://lore.kernel.org/r/20200811103452.20448-1-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/msm8916-wcd-analog.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/msm8916-wcd-analog.c b/sound/soc/codecs/msm8916-wcd-analog.c
index 3633eb30dd135..4f949ad50d6a7 100644
--- a/sound/soc/codecs/msm8916-wcd-analog.c
+++ b/sound/soc/codecs/msm8916-wcd-analog.c
@@ -16,8 +16,8 @@
 
 #define CDC_D_REVISION1			(0xf000)
 #define CDC_D_PERPH_SUBTYPE		(0xf005)
-#define CDC_D_INT_EN_SET		(0x015)
-#define CDC_D_INT_EN_CLR		(0x016)
+#define CDC_D_INT_EN_SET		(0xf015)
+#define CDC_D_INT_EN_CLR		(0xf016)
 #define MBHC_SWITCH_INT			BIT(7)
 #define MBHC_MIC_ELECTRICAL_INS_REM_DET	BIT(6)
 #define MBHC_BUTTON_PRESS_DET		BIT(5)
-- 
2.25.1



