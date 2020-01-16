Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE32A13F4A9
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:53:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389461AbgAPRIj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:08:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:42838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387629AbgAPRIj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:08:39 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BFC8206D9;
        Thu, 16 Jan 2020 17:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194519;
        bh=sT3KDcw/wc551YaCyJ5Nu5sFuDODu+pXhos+pJR1tjM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZmBvMS89LGHR3ObDdlk9DC193sFJugueb6Fp3LID1KNDmocRLv+UK1PIyzVwMAVp1
         Ec3ncba9aQVenPVUr7oxdLQv7l/wfn/FzHt2JriYo0MS1T+TshWlrh+Hw/qXvOEZzY
         Hmu722oOwdj5sNBf2j/dYrIAU5j+sKSrZc3hpRU0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jerome Brunet <jbrunet@baylibre.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 411/671] ASoC: meson: axg-tdmout: right_j is not supported
Date:   Thu, 16 Jan 2020 12:00:49 -0500
Message-Id: <20200116170509.12787-148-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit 7e0d7d0fbd06af0507611f85dba8daf24832abd9 ]

Right justified format is actually not supported by the amlogic tdm output
encoder.

Fixes: c41c2a355b86 ("ASoC: meson: add tdm output driver")
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/meson/axg-tdmout.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/soc/meson/axg-tdmout.c b/sound/soc/meson/axg-tdmout.c
index f73368ee1088..d11acb3cc696 100644
--- a/sound/soc/meson/axg-tdmout.c
+++ b/sound/soc/meson/axg-tdmout.c
@@ -136,7 +136,6 @@ static int axg_tdmout_prepare(struct regmap *map, struct axg_tdm_stream *ts)
 		break;
 
 	case SND_SOC_DAIFMT_LEFT_J:
-	case SND_SOC_DAIFMT_RIGHT_J:
 	case SND_SOC_DAIFMT_DSP_B:
 		val |= TDMOUT_CTRL0_INIT_BITNUM(2);
 		break;
-- 
2.20.1

