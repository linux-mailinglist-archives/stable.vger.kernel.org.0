Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1513C6B4A36
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:20:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233877AbjCJPUO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:20:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233916AbjCJPTo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:19:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85A5B1241D0
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:10:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1DFE561A41
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:09:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B0FDC433D2;
        Fri, 10 Mar 2023 15:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460961;
        bh=dbSSL7UfkQvfSdnbKXTrqM3K/6VmFXkDeB6hvcKtfmk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pjt7J3H7JPBvkmrv/GTLrBh+UAfsACP2gecZ+2sHYbjz9extJKe203ByyvWbCNk8e
         5blsYU8ibFOPKB6yTqvOlRJ7AIngqI3hvK3Jiwf0XsX/TndFu+ypVeLhAFOxEUTqBV
         zpOSvtM+nIRkdWjTbN0KYBTDRFdE4N6Ih0Y4kMW4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 479/529] ASoC: zl38060: Remove spurious gpiolib select
Date:   Fri, 10 Mar 2023 14:40:22 +0100
Message-Id: <20230310133827.034123278@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 8e70aaae32b72d3088d18a3447b67112b3f5979a ]

The usage of GPIOs is optional in the code so don't force on gpiolib when
building it, avoiding warnings in randconfigs.

Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20220202192333.3655269-6-broonie@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 0de2cc3707b6 ("ASoC: zl38060 add gpiolib dependency")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index 25f331551f689..a96f18a9479e8 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -1701,7 +1701,6 @@ config SND_SOC_WSA881X
 config SND_SOC_ZL38060
 	tristate "Microsemi ZL38060 Connected Home Audio Processor"
 	depends on SPI_MASTER
-	select GPIOLIB
 	select REGMAP
 	help
 	  Support for ZL38060 Connected Home Audio Processor from Microsemi,
-- 
2.39.2



