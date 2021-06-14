Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3396F3A6368
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234931AbhFNLMY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:12:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:42880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235703AbhFNLLI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:11:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 314E761948;
        Mon, 14 Jun 2021 10:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667674;
        bh=32aGDjf/ggu6KGnPHa/nyJsoyREiVd0JXqFVsWpBbBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cxsyPfBR+BFzvhFOdQyVS6FNfHd6MkWCBfKLwpyNe5hfJhMFLX1VOGaaqeB3bmIi1
         5mqDV0dMFmxzbben9Zm3elBbT5S0OwqPcmDryeJf9s2+lxSthRYK2Di7Blw4bT18U0
         KZkXa2UdowII25JAlXESziDYXPj8bm69/8gSdSFM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Bixuan Cui <cuibixuan@huawei.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 008/173] ASoC: codecs: lpass-tx-macro: add missing MODULE_DEVICE_TABLE
Date:   Mon, 14 Jun 2021 12:25:40 +0200
Message-Id: <20210614102658.437827571@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



