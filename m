Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B77C91FE7FD
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbgFRBLC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:11:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:38680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727809AbgFRBK7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:10:59 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A996214DB;
        Thu, 18 Jun 2020 01:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442659;
        bh=rGnkqzOklVdCYmtctnndT4Xj7oX+ndcWZlmsfC9t1nQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XthIOUjfoIfJn6EEqPux7QG7JwkqZfGdn+/wGnDRJPEInZF/cWZDcQcTlF7bzDKUU
         lxngtltCsXXcyha2RZ9bp/ztAhov6zmJqxEsKlcQ6x1qw+JvgUk01xemNosPy3SeD2
         +LzRT9+0CI1BfwT+k36G5YrYU7olLOducGLhOQXM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Li <liwei391@huawei.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.7 130/388] ASoC: Fix wrong dependency of da7210 and wm8983
Date:   Wed, 17 Jun 2020 21:03:47 -0400
Message-Id: <20200618010805.600873-130-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Li <liwei391@huawei.com>

[ Upstream commit c1c050ee74d67aeb879fd38e3a07139d7fdb79f4 ]

As these two drivers support I2C and SPI, we should add the SND_SOC_I2C_AND_SPI
dependency instead.

Fixes: ce0c97f8a2936 ("ASoC: Fix SND_SOC_ALL_CODECS imply SPI fallout")
Signed-off-by: Wei Li <liwei391@huawei.com>
Link: https://lore.kernel.org/r/20200420202410.47327-3-liwei391@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index 8cdc68c141dc..7d2cbed55a9d 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -717,7 +717,7 @@ config SND_SOC_L3
 
 config SND_SOC_DA7210
 	tristate
-	depends on I2C
+	depends on SND_SOC_I2C_AND_SPI
 
 config SND_SOC_DA7213
 	tristate "Dialog DA7213 CODEC"
@@ -1569,7 +1569,7 @@ config SND_SOC_WM8978
 
 config SND_SOC_WM8983
 	tristate
-	depends on I2C
+	depends on SND_SOC_I2C_AND_SPI
 
 config SND_SOC_WM8985
 	tristate "Wolfson Microelectronics WM8985 and WM8758 codec driver"
-- 
2.25.1

