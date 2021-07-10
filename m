Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64A3D3C2DCF
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232619AbhGJCZN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:25:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:41838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232068AbhGJCY7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:24:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B064613E8;
        Sat, 10 Jul 2021 02:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883735;
        bh=aPEsAJGmsGNzWDFxYT9/4VLd8DXDuBcJnkwDQrRJGlk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jj0ZWhqSWsx3V9dGqFLvBtaiucrgMfCryzMMfa6U8+oP3FT+i8MJf73SVstu2Urck
         SsgoVOpeUFDrRqf+Ka4YzBpGTp7zn5XhLnQWlsOBWuxsRoD0S6CbpjCEouNVe0fHvO
         8iYbCubihRW1QE7c57x+SGS/fK9lfp23dBBGhHSIzN2R1mipogCRMhT+rdKvQt8isD
         zZ9O6mB4hy9TQw/i4cxlwFWtpWV2UGqOEftxFpB20uHD8JTurz4OJ0A0d04nJ/pjUD
         zAe3dPITgZbJAt92ex1dBoFtArIYFDJeq6Jiehfc5iCgkb522Knu8M5W0qUEeHRLSd
         DxrBBSzC8dZeA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.12 014/104] ASoC: intel/boards: add missing MODULE_DEVICE_TABLE
Date:   Fri,  9 Jul 2021 22:20:26 -0400
Message-Id: <20210710022156.3168825-14-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022156.3168825-1-sashal@kernel.org>
References: <20210710022156.3168825-1-sashal@kernel.org>
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
index 55505e207bc0..56e92a1ff34d 100644
--- a/sound/soc/intel/boards/sof_rt5682.c
+++ b/sound/soc/intel/boards/sof_rt5682.c
@@ -942,6 +942,7 @@ static const struct platform_device_id board_ids[] = {
 	},
 	{ }
 };
+MODULE_DEVICE_TABLE(platform, board_ids);
 
 static struct platform_driver sof_audio = {
 	.probe = sof_audio_probe,
-- 
2.30.2

