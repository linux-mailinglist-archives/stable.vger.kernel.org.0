Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34D145782D
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 02:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726862AbfF0At0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 20:49:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:41742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728518AbfF0AhN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Jun 2019 20:37:13 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77818217F9;
        Thu, 27 Jun 2019 00:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595832;
        bh=wo4WAj4au1VlSy+57N3W9NobVAEXVXkth8KrqhYeEX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o0GF0uH+4MZwDUJ+Bv7jLXf/DainsimTvizEiNRRRrPDnvcspoMgmBt6d7UDm1MNT
         PCMWrMkcJAlTkn+y3DBTdG/Q3L7m/of7kgRpOMwfSQnkDqiUK0q3lBavkTRWtWRwqq
         JjictsHU3xYqZefS0BWTC/R9W2vp9MbUnkq0xwbs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 19/60] soundwire: intel: set dai min and max channels correctly
Date:   Wed, 26 Jun 2019 20:35:34 -0400
Message-Id: <20190627003616.20767-19-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627003616.20767-1-sashal@kernel.org>
References: <20190627003616.20767-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit 39194128701bf2af9bbc420ffe6e3cb5d2c16061 ]

Looks like there is a copy paste error.
This patch fixes it!

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/intel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/soundwire/intel.c b/drivers/soundwire/intel.c
index 0a8990e758f9..a6e2581ada70 100644
--- a/drivers/soundwire/intel.c
+++ b/drivers/soundwire/intel.c
@@ -651,8 +651,8 @@ static int intel_create_dai(struct sdw_cdns *cdns,
 				return -ENOMEM;
 			}
 
-			dais[i].playback.channels_min = 1;
-			dais[i].playback.channels_max = max_ch;
+			dais[i].capture.channels_min = 1;
+			dais[i].capture.channels_max = max_ch;
 			dais[i].capture.rates = SNDRV_PCM_RATE_48000;
 			dais[i].capture.formats = SNDRV_PCM_FMTBIT_S16_LE;
 		}
-- 
2.20.1

