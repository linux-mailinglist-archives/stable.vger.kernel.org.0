Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A79B3A6376
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235153AbhFNLNO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:13:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:42878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234315AbhFNLLU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:11:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3A4F6194B;
        Mon, 14 Jun 2021 10:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667672;
        bh=Dksp/bCgj6burLYfea58pNgbY4OU8wSkl1Iduw4ho3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BMmay9w27o2DHeriHffqpEzQWmpHDaBIC07VHCo7sm+9w5n0gBfN/NBQq1yHIZ6YP
         6Ja2NAg9Eu5O8x6FinvVn+8Rh70BxhSgDoV3KUJOdnRGJAdiUmvIYyEdDAWedLUWYR
         vzb2XTM9nQNFFXgJSE0xy0y7zJYUziHf8UXwV3SY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 007/173] ASoC: codecs: lpass-rx-macro: add missing MODULE_DEVICE_TABLE
Date:   Mon, 14 Jun 2021 12:25:39 +0200
Message-Id: <20210614102658.407568975@linuxfoundation.org>
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

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit d4335d058f8430a0ce2b43dab9531f3a3cf9fe2c ]

Fix module loading by adding missing MODULE_DEVICE_TABLE.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20210510103844.1532-1-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/lpass-rx-macro.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/lpass-rx-macro.c b/sound/soc/codecs/lpass-rx-macro.c
index 7878da89d8e0..b7b9c891e2f0 100644
--- a/sound/soc/codecs/lpass-rx-macro.c
+++ b/sound/soc/codecs/lpass-rx-macro.c
@@ -3581,6 +3581,7 @@ static const struct of_device_id rx_macro_dt_match[] = {
 	{ .compatible = "qcom,sm8250-lpass-rx-macro" },
 	{ }
 };
+MODULE_DEVICE_TABLE(of, rx_macro_dt_match);
 
 static struct platform_driver rx_macro_driver = {
 	.driver = {
-- 
2.30.2



