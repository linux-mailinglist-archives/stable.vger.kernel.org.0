Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A98D39A6C7
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 19:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230392AbhFCRJ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 13:09:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:40400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230378AbhFCRJ2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Jun 2021 13:09:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E089F613F4;
        Thu,  3 Jun 2021 17:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740063;
        bh=32aGDjf/ggu6KGnPHa/nyJsoyREiVd0JXqFVsWpBbBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FglUumLocQoGZRXANeN7xCXvHKUpJniuK8E7XX3rYLRKW4uGtWetArI9SkFwpvdaq
         wYhO0Z95KnjZg5Th/k/gq7VBcNdyRsI204qQSAS8D1fVOTNmTM+kHDRtM8fcglIcKh
         KMP4tT+xva9JZYC5E6izm+lc/4dgyAw99Nec3suqHa2zN2NGdSROCFtHNfOHyXDPXq
         Pyu89N91vYSHAvXSB6PvzomuiOm6CDKW1yNXYX4pStnNdkg72PLB0WRSth/7XsdAVZ
         uDqNZY+zmlCDzAEwrV8fj4hag6et+7roDs1OJxtYXtk0i7zeSDs4eSf17PpP8PliiX
         rotPori05su4g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bixuan Cui <cuibixuan@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.12 07/43] ASoC: codecs: lpass-tx-macro: add missing MODULE_DEVICE_TABLE
Date:   Thu,  3 Jun 2021 13:06:57 -0400
Message-Id: <20210603170734.3168284-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603170734.3168284-1-sashal@kernel.org>
References: <20210603170734.3168284-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bixuan Cui <cuibixuan@huawei.com>

[ Upstream commit 14c0c423746fe7232a093a68809a4bc6233eed60 ]

This patch adds missing MODULE_DEVICE_TABLE definition which generates
correct modalias for automatic loading of this driver when it is built
as an external module.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Bixuan Cui <cuibixuan@huawei.com>
Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20210508031512.53783-1-cuibixuan@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/lpass-tx-macro.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/lpass-tx-macro.c b/sound/soc/codecs/lpass-tx-macro.c
index e8c6c738bbaa..5341ca02951c 100644
--- a/sound/soc/codecs/lpass-tx-macro.c
+++ b/sound/soc/codecs/lpass-tx-macro.c
@@ -1846,6 +1846,7 @@ static const struct of_device_id tx_macro_dt_match[] = {
 	{ .compatible = "qcom,sm8250-lpass-tx-macro" },
 	{ }
 };
+MODULE_DEVICE_TABLE(of, tx_macro_dt_match);
 static struct platform_driver tx_macro_driver = {
 	.driver = {
 		.name = "tx_macro",
-- 
2.30.2

