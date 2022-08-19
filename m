Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B97B559A244
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353137AbiHSQda (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:33:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353683AbiHSQcY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:32:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2563A50184;
        Fri, 19 Aug 2022 09:06:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 35AF8617F2;
        Fri, 19 Aug 2022 16:06:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36B45C433D6;
        Fri, 19 Aug 2022 16:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925174;
        bh=tU4ac5BcUagigWhh2q0bVegPLksKdY/ntuJok500HCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0IgDAxwjWMOrm3LeL173ymak6qhc59TQN9++WbLJVrh5+cI039Ofrmsz97mVgXDIU
         KugWU/X+zyeNjHeiZpCqPeyNzwkk2Gbape5LZq0VG3iL+2RPiPYkcgcg2O3PRxwpzw
         FI1PxsdDu6wgtoeVgXjSa8v3KV4Y95p5D9B+1m8Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 378/545] ASoC: samsung: h1940_uda1380: include proepr GPIO consumer header
Date:   Fri, 19 Aug 2022 17:42:28 +0200
Message-Id: <20220819153846.337701641@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit bd10b0dafdcf0ec1677cad70101e1f97b9e28f2e ]

h1940_uda1380 uses gpiod*/GPIOD* so it should include GPIO consumer
header.

Fixes: 9666e27f90b9 ("ASoC: samsung: h1940: turn into platform driver")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20220627141900.470469-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/samsung/h1940_uda1380.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/samsung/h1940_uda1380.c b/sound/soc/samsung/h1940_uda1380.c
index 8aa78ff640f5..adb6b661c799 100644
--- a/sound/soc/samsung/h1940_uda1380.c
+++ b/sound/soc/samsung/h1940_uda1380.c
@@ -8,7 +8,7 @@
 // Based on version from Arnaud Patard <arnaud.patard@rtp-net.org>
 
 #include <linux/types.h>
-#include <linux/gpio.h>
+#include <linux/gpio/consumer.h>
 #include <linux/module.h>
 
 #include <sound/soc.h>
-- 
2.35.1



