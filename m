Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF5E8328A82
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239648AbhCASSS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:18:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:60794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239341AbhCASLg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:11:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 280DC65023;
        Mon,  1 Mar 2021 17:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618802;
        bh=o8ctnPxP1ET9DsnSSXBHqkqtsqOBpLiFKYGoHMlwa5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l+kfzZb99t+iMYZN+99PISaAw6Ei1Nr21W1NvFmmma/A+wdHIsN4RfYGA9wOj4wM6
         y+sDQ3TKcS6+kb4BmU/mdhkGyakC9otWpq6Mrk8+p6MdGl1bPPvTV6Xj1NFDSCo8Zl
         QLh8L+LF7rdUGOxyqNhCVkw0hyXw9jz/KH/D9KeY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Stephan Gerhold <stephan@gerhold.net>,
        Jun Nie <jun.nie@linaro.org>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 222/663] ASoC: qcom: lpass: Fix i2s ctl register bit map
Date:   Mon,  1 Mar 2021 17:07:50 +0100
Message-Id: <20210301161152.782345256@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jun Nie <jun.nie@linaro.org>

[ Upstream commit 5e3277ab3baff6db96ae44adf6f85d6f0f6502cc ]

Fix bitwidth mapping in i2s ctl register per APQ8016 document.

Fixes: b5022a36d28f ("ASoC: qcom: lpass: Use regmap_field for i2sctl and dmactl registers")
Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Reviewed-by: Stephan Gerhold <stephan@gerhold.net>
Signed-off-by: Jun Nie <jun.nie@linaro.org>
Link: https://lore.kernel.org/r/20210201132941.460360-1-jun.nie@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/lpass-apq8016.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/qcom/lpass-apq8016.c b/sound/soc/qcom/lpass-apq8016.c
index 0aedb3a0a798a..7c0e774ad0625 100644
--- a/sound/soc/qcom/lpass-apq8016.c
+++ b/sound/soc/qcom/lpass-apq8016.c
@@ -250,7 +250,7 @@ static struct lpass_variant apq8016_data = {
 	.micmode		= REG_FIELD_ID(0x1000, 4, 7, 4, 0x1000),
 	.micmono		= REG_FIELD_ID(0x1000, 3, 3, 4, 0x1000),
 	.wssrc			= REG_FIELD_ID(0x1000, 2, 2, 4, 0x1000),
-	.bitwidth		= REG_FIELD_ID(0x1000, 0, 0, 4, 0x1000),
+	.bitwidth		= REG_FIELD_ID(0x1000, 0, 1, 4, 0x1000),
 
 	.rdma_dyncclk		= REG_FIELD_ID(0x8400, 12, 12, 2, 0x1000),
 	.rdma_bursten		= REG_FIELD_ID(0x8400, 11, 11, 2, 0x1000),
-- 
2.27.0



