Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE09B39A6C6
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 19:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbhFCRJ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 13:09:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:40388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230368AbhFCRJ1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Jun 2021 13:09:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2585613F1;
        Thu,  3 Jun 2021 17:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740062;
        bh=Dksp/bCgj6burLYfea58pNgbY4OU8wSkl1Iduw4ho3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lJrvBo/Eu8Hp54nYWWirsxYKqXBKam9ZPJc5Hj3keEsaQA/p+GF/TJjiiuUq/xMdD
         12qnyD+Qd9NL2EOpo0+NxonXlEY9AYpggo85Fqgw65FEwxRiU/vjDTWmTnw9I2luNx
         Z0ehd+UvjcgKDBS6BitEnnYn3leyzU0K3I4aGZf/rY72bImKkGbBKwbHe2VkgaIpek
         iY+PdPONAaIw2d531wUJ1OG9aR8aQYGSM92ZjGBcJUGW3ZMSWpxHcnsHYIvG2woAU7
         gqWdbf5Np6DPDHLw6Lrm6Xi0c8b8XazWn9eovmlvnisRDhDlA3OAZqxSghq4/zglZW
         35JQzMXXQezgQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.12 06/43] ASoC: codecs: lpass-rx-macro: add missing MODULE_DEVICE_TABLE
Date:   Thu,  3 Jun 2021 13:06:56 -0400
Message-Id: <20210603170734.3168284-6-sashal@kernel.org>
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

