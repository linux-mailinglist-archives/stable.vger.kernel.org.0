Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA1796AEA43
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:32:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231710AbjCGRcS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:32:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231616AbjCGRcA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:32:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD6409F062
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:27:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A53AB818F6
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:27:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0E4FC433EF;
        Tue,  7 Mar 2023 17:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210038;
        bh=Ed/Gnb6Dioor4lM/pwGnTJjJuZQFFzidX40torlALKo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lsLxLTzNJr3jO1X0hP72x7qJIsY0qkSQLTnILC39A7haHEgtZc2HdYsaPhjGl/nvA
         JH8RybrJi/W/przVZlI8/tC0jhyGGM2n4g8uG2TsRV/wyZC5mDG4mu1VnLWZv9DmCX
         M/Ig0/pNxTnAllE7tjJPLwxSPScKPLb4MLGrHiBo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0412/1001] ASoC: rsnd: fixup #endif position
Date:   Tue,  7 Mar 2023 17:53:04 +0100
Message-Id: <20230307170039.211505411@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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



