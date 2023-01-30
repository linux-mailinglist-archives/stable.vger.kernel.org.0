Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9D068103B
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:01:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237006AbjA3OBv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:01:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236757AbjA3OBS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:01:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7AAD3B670
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:01:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 815E16102D
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:01:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AE61C433EF;
        Mon, 30 Jan 2023 14:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087259;
        bh=G4XPmdx5KaEEhEv2bHO6cgTlKpzA5zHAYv4LaMMmdPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CpMQxQN/q7dwGirUXqq6e8XrUXZ6fb3+fSusTSkWilOr44rgbmFsPfzuDTvjajZ2U
         ySuF4UnsHoBSKsqUOgpN63MRG7bIEyHMZK2B2LemYPpw/kkm/sRseu1f8b4gy7EMCb
         wrN2VDsLORLZ9vKbu7KJsfu25sbUlr7hsvGaMA8U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Allen-KH Cheng <allen-kh.cheng@mediatek.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 150/313] ASoC: mediatek: mt8186: Add machine support for max98357a
Date:   Mon, 30 Jan 2023 14:49:45 +0100
Message-Id: <20230130134343.644185973@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Allen-KH Cheng <allen-kh.cheng@mediatek.com>

[ Upstream commit 8a54f666db581bbf07494cca44a0124acbced581 ]

Add support for mt8186 with mt6366 and max98357a.

Signed-off-by: Allen-KH Cheng <allen-kh.cheng@mediatek.com>
Link: https://lore.kernel.org/r/20221228115756.28014-1-allen-kh.cheng@mediatek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/mediatek/Kconfig b/sound/soc/mediatek/Kconfig
index 363fa4d47680..7bdb0ded831c 100644
--- a/sound/soc/mediatek/Kconfig
+++ b/sound/soc/mediatek/Kconfig
@@ -182,9 +182,10 @@ config SND_SOC_MT8186_MT6366_DA7219_MAX98357
 	  If unsure select "N".
 
 config SND_SOC_MT8186_MT6366_RT1019_RT5682S
-	tristate "ASoC Audio driver for MT8186 with RT1019 RT5682S codec"
+	tristate "ASoC Audio driver for MT8186 with RT1019 RT5682S MAX98357A/MAX98360 codec"
 	depends on I2C && GPIOLIB
 	depends on SND_SOC_MT8186 && MTK_PMIC_WRAP
+	select SND_SOC_MAX98357A
 	select SND_SOC_MT6358
 	select SND_SOC_RT1015P
 	select SND_SOC_RT5682S
-- 
2.39.0



