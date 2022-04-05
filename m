Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C48324F3B48
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347675AbiDELwl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356933AbiDEKZF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:25:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB731C3355;
        Tue,  5 Apr 2022 03:09:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8462C6172B;
        Tue,  5 Apr 2022 10:09:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C63DC385A0;
        Tue,  5 Apr 2022 10:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153356;
        bh=ZAgF3J4S+uCj4AeiS6e4Lb48/8VFC5Jn8D9Zq1E/Wf8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CgIVCO9ntOgLH4M9rjWTZhXUKe9sEgb66EFdOXj67wCWP2bCwFsFb7IgNzmEn+TQF
         5ebifVYbU2UbaxUxaV5INUVinggqlDDzb/tyDwiV7sNZSlwBSVF8NDWn8Tkq+2nqDF
         qw5guMoVSjuDJniu5W6uQzdHbBG8/6FW9tat95yw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 192/599] ASoC: generic: simple-card-utils: remove useless assignment
Date:   Tue,  5 Apr 2022 09:28:06 +0200
Message-Id: <20220405070304.555140051@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit bd029fc86834760276171bd2301d6c43e45a65b0 ]

cppcheck warning:

sound/soc/generic/simple-card-utils.c:258:10: style: Variable 'ret' is
assigned a value that is never used. [unreadVariable]
 int ret = 0;
         ^

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20210218221921.88991-7-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/generic/simple-card-utils.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/generic/simple-card-utils.c b/sound/soc/generic/simple-card-utils.c
index 6cada4c1e283..d0d79f47bfdd 100644
--- a/sound/soc/generic/simple-card-utils.c
+++ b/sound/soc/generic/simple-card-utils.c
@@ -255,7 +255,7 @@ int asoc_simple_hw_params(struct snd_pcm_substream *substream,
 	struct simple_dai_props *dai_props =
 		simple_priv_to_props(priv, rtd->num);
 	unsigned int mclk, mclk_fs = 0;
-	int ret = 0;
+	int ret;
 
 	if (dai_props->mclk_fs)
 		mclk_fs = dai_props->mclk_fs;
-- 
2.34.1



