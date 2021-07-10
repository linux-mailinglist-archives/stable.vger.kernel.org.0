Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 028D73C2CE8
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232087AbhGJCVK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:21:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:37414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231905AbhGJCU4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:20:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2281B61412;
        Sat, 10 Jul 2021 02:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883491;
        bh=F3Rgq7wpO6PlPYF5bPYKKBwJI5/HgM/vLo9ss8e2UzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UvDMKXANl48vjhBF1Uu+03IQd/peKwxDGUZboNBw9iIXTdaC338QjefLXJFHw7OCC
         WOrSe549I0eA9sJ0aqV7iYzWH9GAqxF9069EuRKDejcstuigFmRMzojWBKEVhdEoYV
         r/HfqPoWDvoSKxQi/kVPMY/Jp4n8XqeeCAXEwqJQja8fAu3Wb46B7EeT54DKxEziKk
         NwqPUuE38TJXJtxhlwqflo/a+eSrgduqBMb4mvd3Fz0BWvkQ4iM+KLb+Fw39oGDqLU
         C/CGRdGlga01vjtBIyaOvzIZR2mYE5RuShcBQAt9ZTEx+NOX3BDYxVjpy9txNPA9DR
         zVQ8P61/KNevw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.13 016/114] ASoC: intel/boards: add missing MODULE_DEVICE_TABLE
Date:   Fri,  9 Jul 2021 22:16:10 -0400
Message-Id: <20210710021748.3167666-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710021748.3167666-1-sashal@kernel.org>
References: <20210710021748.3167666-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zou Wei <zou_wei@huawei.com>

[ Upstream commit a75e5cdf4dd1307bb1541edbb0c008f40896644c ]

This patch adds missing MODULE_DEVICE_TABLE definition which generates
correct modalias for automatic loading of this driver when it is built
as an external module.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
Link: https://lore.kernel.org/r/1620791647-16024-1-git-send-email-zou_wei@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_da7219_max98373.c | 1 +
 sound/soc/intel/boards/sof_rt5682.c          | 1 +
 2 files changed, 2 insertions(+)

diff --git a/sound/soc/intel/boards/sof_da7219_max98373.c b/sound/soc/intel/boards/sof_da7219_max98373.c
index f3cb0773e70e..8d1ad892e86b 100644
--- a/sound/soc/intel/boards/sof_da7219_max98373.c
+++ b/sound/soc/intel/boards/sof_da7219_max98373.c
@@ -440,6 +440,7 @@ static const struct platform_device_id board_ids[] = {
 	},
 	{ }
 };
+MODULE_DEVICE_TABLE(platform, board_ids);
 
 static struct platform_driver audio = {
 	.probe = audio_probe,
diff --git a/sound/soc/intel/boards/sof_rt5682.c b/sound/soc/intel/boards/sof_rt5682.c
index 58548ea0d915..cf1d053733e2 100644
--- a/sound/soc/intel/boards/sof_rt5682.c
+++ b/sound/soc/intel/boards/sof_rt5682.c
@@ -968,6 +968,7 @@ static const struct platform_device_id board_ids[] = {
 	},
 	{ }
 };
+MODULE_DEVICE_TABLE(platform, board_ids);
 
 static struct platform_driver sof_audio = {
 	.probe = sof_audio_probe,
-- 
2.30.2

