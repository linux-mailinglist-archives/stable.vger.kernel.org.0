Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E25D8594D4E
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232419AbiHPAmP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:42:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245211AbiHPAkF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:40:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9492CD34CE;
        Mon, 15 Aug 2022 13:38:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D750611E2;
        Mon, 15 Aug 2022 20:38:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36E4EC433D6;
        Mon, 15 Aug 2022 20:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595916;
        bh=FZm0ShEHKWhg1mnr4viGY8SZFullQW4AgpJgBMOed3o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LzZaYNV46XNEGJTmuAa56BZkXfFju1yZtAN45wOZeyI8/hqEOLrKf14/zqUPoYkVr
         pAUx62Y09cuaqqBPXWDctiDhppA26QDonWYq12yuWhL2xl+kaUxTCg5Dhvr277kkkY
         hA8VnNR4uxp6gB4Dx28phWUCaYie3CnZJmzfYluk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0916/1157] ASoC: samsung: h1940_uda1380: include proepr GPIO consumer header
Date:   Mon, 15 Aug 2022 20:04:32 +0200
Message-Id: <20220815180516.089414389@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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
index 907266aee839..fa45a54ab18f 100644
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



