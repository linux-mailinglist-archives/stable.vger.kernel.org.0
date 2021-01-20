Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF6D62FC78C
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 03:14:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728956AbhATCNG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 21:13:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:47354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730882AbhATB3q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Jan 2021 20:29:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B087F2313F;
        Wed, 20 Jan 2021 01:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611106098;
        bh=tW6sng02PjZFCGu4nRAPktk16OllocRBiwQ9hK7ZCp4=;
        h=From:To:Cc:Subject:Date:From;
        b=bd7X5cvoa2JtPtwxe7zwypBfN2tdQ/nDyjpJWX95J0mFDOPvqjXSnQNfQkX37/3k+
         xBZrX3EUvC8XyzTlXFIpbsLCj7NSmHLsfb8UGnz4Jp9/BP8cDJEBw9iUS9xYO6OhQn
         PEq6w5Un5Haa76yBzaIWB+BnjsOFvGMG0QYUtzpLTl9CjqgE/BPXslQSLzob1ictyF
         Olxo5mBCNyXUJX5+fR3mQQRNvdOGZDRNE1J1O78WkTSS+z8srMkxPgQ1i0toEiiMij
         oexDlQ/xzwoZEovFNXb9boy4hdnyRnWOtAL3Dzjx25Zf54IPnt8FeQspB5ekp7kJbS
         DIZd3t3cFhiAQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Cezary Rojewski <cezary.rojewski@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.9 1/4] ASoC: Intel: haswell: Add missing pm_ops
Date:   Tue, 19 Jan 2021 20:28:13 -0500
Message-Id: <20210120012816.770648-1-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit bb224c3e3e41d940612d4cc9573289cdbd5cb8f5 ]

haswell machine board is missing pm_ops what prevents it from undergoing
suspend-resume procedure successfully. Assign default snd_soc_pm_ops so
this is no longer the case.

Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://lore.kernel.org/r/20201217105401.27865-1-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/haswell.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/intel/boards/haswell.c b/sound/soc/intel/boards/haswell.c
index 11d0cc2b0e390..060da95770416 100644
--- a/sound/soc/intel/boards/haswell.c
+++ b/sound/soc/intel/boards/haswell.c
@@ -197,6 +197,7 @@ static struct platform_driver haswell_audio = {
 	.probe = haswell_audio_probe,
 	.driver = {
 		.name = "haswell-audio",
+		.pm = &snd_soc_pm_ops,
 	},
 };
 
-- 
2.27.0

