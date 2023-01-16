Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC83766C0AB
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 15:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231745AbjAPOD3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 09:03:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231671AbjAPODA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 09:03:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9869227BB;
        Mon, 16 Jan 2023 06:02:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 650AF60FD9;
        Mon, 16 Jan 2023 14:02:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1345AC433EF;
        Mon, 16 Jan 2023 14:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673877757;
        bh=rKhjvkQjqw5KgkQ2IGqQE+M1sJPep97rfaS5IO0auYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NQ3kgJk1vmkTeA1lOwjtfoxP/rT4tY+1KhWg4RhMbiT77aX/ozV1XBKLXQUvBlYjg
         4ZdNbYK7X6qEo1Nz0xQfq9bZIAyygVGDnASxf+sU6HiTb06+XHvD/T6XJvJvlScQJ8
         LmRHDh5xQD1T0h8H0WmNBWFZBbq6LLpvsD1CL2C7xfRwBgaZEc8zZl6OS5UH7CSuyo
         5ZCzZqq/sUh3eUoSsXZq2Iba2GLU5Wc0gTy2Ef/kxtYmo6xAmTCgVeYxG/3FgnmBF/
         UuRIBtlpEMCedDWLznp5koEuOiebyX2Ty1CrrX4p4qshlh7JvN1EQHSEBz91+mqbmU
         DWEE/p7TK8Dng==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mars Chen <chenxiangrui@huaqin.corp-partner.google.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, matthias.bgg@gmail.com,
        angelogioacchino.delregno@collabora.com, jiaxin.yu@mediatek.com,
        tzungbi@kernel.org, trevor.wu@mediatek.com, julianbraha@gmail.com,
        allen-kh.cheng@mediatek.com, renzhijie2@huawei.com,
        alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 6.1 12/53] ASoC: support machine driver with max98360
Date:   Mon, 16 Jan 2023 09:01:12 -0500
Message-Id: <20230116140154.114951-12-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230116140154.114951-1-sashal@kernel.org>
References: <20230116140154.114951-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mars Chen <chenxiangrui@huaqin.corp-partner.google.com>

[ Upstream commit 810948f45d99c46b60852ef2a5a2777c12d6bb3e ]

Signed-off-by: Mars Chen <chenxiangrui@huaqin.corp-partner.google.com>
Link: https://lore.kernel.org/r/20221228103812.450956-1-chenxiangrui@huaqin.corp-partner.google.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/mediatek/Kconfig b/sound/soc/mediatek/Kconfig
index 7bdb0ded831c..b027fba8233d 100644
--- a/sound/soc/mediatek/Kconfig
+++ b/sound/soc/mediatek/Kconfig
@@ -187,6 +187,7 @@ config SND_SOC_MT8186_MT6366_RT1019_RT5682S
 	depends on SND_SOC_MT8186 && MTK_PMIC_WRAP
 	select SND_SOC_MAX98357A
 	select SND_SOC_MT6358
+	select SND_SOC_MAX98357A
 	select SND_SOC_RT1015P
 	select SND_SOC_RT5682S
 	select SND_SOC_BT_SCO
-- 
2.35.1

