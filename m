Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 207264EC169
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344519AbiC3L4Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:56:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344886AbiC3Lxo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:53:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 282AC26F920;
        Wed, 30 Mar 2022 04:49:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02DF3B81C24;
        Wed, 30 Mar 2022 11:49:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0FD4C340EE;
        Wed, 30 Mar 2022 11:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648640982;
        bh=v1luuvpj5UTKQupxrRu/rhsBPsNSE/Jx1YwX0tOiZ3g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sZWHiwuGqlLW1c8voCZk4tS8lex4t0Sis/xZwkStFSgr/qRB9m9L7hBkrXFOmqsgi
         eA5lE4Qoy6XhBk7bCiezc1C4jenaLPKKG9YKMlVgbO+IYmuU5U30PENpxF7nfs213j
         Agp4ClVd8E8zzqxkaovzZUV76sn33HfZm7b/9P7/Gd4UMZLMYafgg1WSv9sbNYqGXB
         yEbX/oCWIhQghK84+tEh2IVVx5Lm/IcayYd2/lOFIy+/oFtiVEpV3Xb79mn7Q7dSHD
         850msC16xvlCd1SiXiyheWL5IMZEIQhCixMhTCwXyMM9OmUqYO0H8XJWGea4YotW3U
         w+txDPgdGPc2w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.16 45/59] ASoC: amd: vangogh: fix uninitialized symbol warning in machine driver
Date:   Wed, 30 Mar 2022 07:48:17 -0400
Message-Id: <20220330114831.1670235-45-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330114831.1670235-1-sashal@kernel.org>
References: <20220330114831.1670235-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Vijendar Mukunda <Vijendar.Mukunda@amd.com>

[ Upstream commit 6f989800639a7a29ab9a02e165b04dc144dd4f2b ]

Fixed below smatch static checker warning.
sound/soc/amd/vangogh/acp5x-mach.c:190 acp5x_cs35l41_hw_params()
error: uninitialized symbol 'ret'.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Link: https://lore.kernel.org/r/20220225193054.24916-4-Vijendar.Mukunda@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/vangogh/acp5x-mach.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/amd/vangogh/acp5x-mach.c b/sound/soc/amd/vangogh/acp5x-mach.c
index 14cf325e4b23..5d7a17755fa7 100644
--- a/sound/soc/amd/vangogh/acp5x-mach.c
+++ b/sound/soc/amd/vangogh/acp5x-mach.c
@@ -165,6 +165,7 @@ static int acp5x_cs35l41_hw_params(struct snd_pcm_substream *substream,
 	unsigned int num_codecs = rtd->num_codecs;
 	unsigned int bclk_val;
 
+	ret = 0;
 	for (i = 0; i < num_codecs; i++) {
 		codec_dai = asoc_rtd_to_codec(rtd, i);
 		if ((strcmp(codec_dai->name, "spi-VLV1776:00") == 0) ||
-- 
2.34.1

