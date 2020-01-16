Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55F2313EFF8
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:19:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392655AbgAPSSk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:18:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:40058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392644AbgAPR2o (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:28:44 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80558246FD;
        Thu, 16 Jan 2020 17:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195724;
        bh=0hFbTZ4UZHgAkJet9RcntmdVTjzElPVUr0Fv4SKJCSs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ao1B9ibeRByY33nvHfxoVHzkieVEWPKE04hosUnKvH5cLd79srI7NzDRzOOjKYXs2
         46lsf2sXO25/6PV9PyNHKWhvMNqs8/6Rlyqd/EbcFMCzrbX8wx3TT69rKFuXnK277e
         r4agqHilVYn4k8k6H7KTN/i3BWXfSCEMCXJOVo0g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.14 266/371] ASoC: cs4349: Use PM ops 'cs4349_runtime_pm'
Date:   Thu, 16 Jan 2020 12:22:18 -0500
Message-Id: <20200116172403.18149-209-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 9b4275c415acca6264a3d7f1182589959c93d530 ]

sound/soc/codecs/cs4349.c:358:32: warning:
 cs4349_runtime_pm defined but not used [-Wunused-const-variable=]

cs4349_runtime_pm ops already defined, it seems
we should enable it.

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: e40da86 ("ASoC: cs4349: Add support for Cirrus Logic CS4349")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Link: https://lore.kernel.org/r/20190815090157.70036-1-yuehaibing@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs4349.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/cs4349.c b/sound/soc/codecs/cs4349.c
index 0a749c79ef57..1d38e53dc95c 100644
--- a/sound/soc/codecs/cs4349.c
+++ b/sound/soc/codecs/cs4349.c
@@ -380,6 +380,7 @@ static struct i2c_driver cs4349_i2c_driver = {
 	.driver = {
 		.name		= "cs4349",
 		.of_match_table	= cs4349_of_match,
+		.pm = &cs4349_runtime_pm,
 	},
 	.id_table	= cs4349_i2c_id,
 	.probe		= cs4349_i2c_probe,
-- 
2.20.1

