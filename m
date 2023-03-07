Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A02506AF41A
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:13:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233737AbjCGTNh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:13:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233749AbjCGTNK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:13:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D97960A4
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:56:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18D01B819DC
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:56:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CB91C4339B;
        Tue,  7 Mar 2023 18:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215410;
        bh=Ed/Gnb6Dioor4lM/pwGnTJjJuZQFFzidX40torlALKo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AYkR2Pwz2ocq9vkRGwKwxKcH1VenMgk4nBAbScIaMf13kyQnVqDpWi4TgadX84hSp
         ZhrUi8poNXsmyfM0V8XSd9CHClzEOZusWWV4LzUd+ianzuHTwhOMZ2WQepSUDzaaYb
         AnKZ5mHYFvfU+7i7GJaiSsqLHLRQ7cggdfAZU0Lc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 225/567] ASoC: rsnd: fixup #endif position
Date:   Tue,  7 Mar 2023 17:59:21 +0100
Message-Id: <20230307165915.667030836@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit 49123b51cd896e00b256a27c2ce9e6bfe1bbc22f ]

commit 1f9c82b5ab83ff2 ("ASoC: rsnd: add debugfs support") added
CONFIG_DEBUG_FS related definitions on rsnd.h, but it should be
added inside of RSND_H. This patch fixup it.

Fixes: 1f9c82b5ab83 ("ASoC: rsnd: add debugfs support")
Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://lore.kernel.org/r/877cx26t7r.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sh/rcar/rsnd.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sh/rcar/rsnd.h b/sound/soc/sh/rcar/rsnd.h
index d9cd190d7e198..f8ef6836ef84e 100644
--- a/sound/soc/sh/rcar/rsnd.h
+++ b/sound/soc/sh/rcar/rsnd.h
@@ -901,8 +901,6 @@ void rsnd_mod_make_sure(struct rsnd_mod *mod, enum rsnd_mod_type type);
 	if (!IS_BUILTIN(RSND_DEBUG_NO_DAI_CALL))	\
 		dev_dbg(dev, param)
 
-#endif
-
 #ifdef CONFIG_DEBUG_FS
 int rsnd_debugfs_probe(struct snd_soc_component *component);
 void rsnd_debugfs_reg_show(struct seq_file *m, phys_addr_t _addr,
@@ -913,3 +911,5 @@ void rsnd_debugfs_mod_reg_show(struct seq_file *m, struct rsnd_mod *mod,
 #else
 #define rsnd_debugfs_probe  NULL
 #endif
+
+#endif /* RSND_H */
-- 
2.39.2



