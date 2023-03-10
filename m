Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFE306B4873
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:02:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233765AbjCJPCd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:02:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233776AbjCJPCL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:02:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A57412D422
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:55:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09B5A6187C
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:55:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CE2DC433EF;
        Fri, 10 Mar 2023 14:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460126;
        bh=ShLdE/4dbnsDhRpnFbbINmptL16Jv6alT+/S+1NKV3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wh24LbfjbrGUOfhuy5r89UIR2ISQFr/W6CJ3xuiMB/7vfog58OjS/hvw/peFbD/tH
         vVB2z0xRjGESWxf5qzZmeC6zo3i8mpWg44deHgOj0tP2TOFjBPU43+JMl9n7ksq/wp
         djf9McH8I4kSZtvBXYmFSD0ndvEv3aPY7Vcs4AoY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Lucas Tanure <lucas.tanure@collabora.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 214/529] ASoC: soc-dapm.h: fixup warning struct snd_pcm_substream not declared
Date:   Fri, 10 Mar 2023 14:35:57 +0100
Message-Id: <20230310133814.915747712@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
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

From: Lucas Tanure <lucas.tanure@collabora.com>

[ Upstream commit fdff966bfde7cf0c85562d2bfb1ff1ba83da5f7b ]

Add struct snd_pcm_substream forward declaration

Fixes: 078a85f2806f ("ASoC: dapm: Only power up active channels from a DAI")
Signed-off-by: Lucas Tanure <lucas.tanure@collabora.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20230215132851.1626881-1-lucas.tanure@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/soc-dapm.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/sound/soc-dapm.h b/include/sound/soc-dapm.h
index c3039e97929a5..32e93d55acf73 100644
--- a/include/sound/soc-dapm.h
+++ b/include/sound/soc-dapm.h
@@ -16,6 +16,7 @@
 #include <sound/asoc.h>
 
 struct device;
+struct snd_pcm_substream;
 struct snd_soc_pcm_runtime;
 struct soc_enum;
 
-- 
2.39.2



