Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0013CE13E
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238401AbhGSPZZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:25:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:48264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345605AbhGSPNh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:13:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86A566121F;
        Mon, 19 Jul 2021 15:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710002;
        bh=osn4rjtANXWskyEV0mZWjevf0Tk15UGwMHiy8emKj2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YdCvNYGXvbrpV8IJrR5Nv/Pd6W8UxKDOAcIe8np3jHHeKrSKMp40F1r1gIwE/tOW8
         wHqjt0yb598Q3QzJ5Kuv65jjVcj0mORJsrrvaDPu1pzEz4M6iSBKA21npOgE0Qaco0
         5t7B/UT8e3wGjkaY0dADzsmm8ELEC9TYxHDIhcx4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zou Wei <zou_wei@huawei.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 033/243] ASoC: intel/boards: add missing MODULE_DEVICE_TABLE
Date:   Mon, 19 Jul 2021 16:51:02 +0200
Message-Id: <20210719144942.003486390@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index ddbb9fe7cc06..1f94fa5a15db 100644
--- a/sound/soc/intel/boards/sof_rt5682.c
+++ b/sound/soc/intel/boards/sof_rt5682.c
@@ -877,6 +877,7 @@ static const struct platform_device_id board_ids[] = {
 	},
 	{ }
 };
+MODULE_DEVICE_TABLE(platform, board_ids);
 
 static struct platform_driver sof_audio = {
 	.probe = sof_audio_probe,
-- 
2.30.2



