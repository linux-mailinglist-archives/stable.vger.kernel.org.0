Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73D996B455C
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:33:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232576AbjCJOdV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:33:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232531AbjCJOdB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:33:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80DA417CE6
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:32:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3DFA2B822BB
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:32:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EAF0C433EF;
        Fri, 10 Mar 2023 14:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458740;
        bh=FI+4ILnJi4OdEpqjWZQmWvque4LccXJCLE24wc0D2fo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WYSl9BH6nNWZZe4DHmAU4kZUkzMGCSkgYvLWT+sFOYVDUZk6Jaga/VRleHxScb/qL
         RBnqVD00B6s6g5i+vtYM1xGfW1pVeTpMAoF0mSOkrzdOtkwYA1TKvwOB6ccss8M5EF
         IVLsku/Pt03bHwROXJHpw7gWfrexLfYSFonkd3V4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tzung-Bi Shih <tzungbi@google.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 129/357] ASoC: dapm: declare missing structure prototypes
Date:   Fri, 10 Mar 2023 14:36:58 +0100
Message-Id: <20230310133740.367027115@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
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

From: Tzung-Bi Shih <tzungbi@google.com>

[ Upstream commit 3d62ef4280a377bb2ccaee4e8f6c5093f5b8f9d4 ]

To fix compilation warnings:

- struct 'snd_soc_pcm_runtime' declared inside parameter list will not
  be visible outside of this definition or declaration
- struct 'soc_enum' declared inside parameter list will not be visible
  outside of this definition or declaration

Declares the missing structure prototypes.

Signed-off-by: Tzung-Bi Shih <tzungbi@google.com>
Link: https://lore.kernel.org/r/20200625153543.85039-3-tzungbi@google.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: fdff966bfde7 ("ASoC: soc-dapm.h: fixup warning struct snd_pcm_substream not declared")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/soc-dapm.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/sound/soc-dapm.h b/include/sound/soc-dapm.h
index 6e8a312253838..8c8988bfef8f4 100644
--- a/include/sound/soc-dapm.h
+++ b/include/sound/soc-dapm.h
@@ -16,6 +16,8 @@
 #include <sound/asoc.h>
 
 struct device;
+struct snd_soc_pcm_runtime;
+struct soc_enum;
 
 /* widget has no PM register bit */
 #define SND_SOC_NOPM	-1
-- 
2.39.2



