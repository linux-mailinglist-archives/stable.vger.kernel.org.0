Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2759635E32
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 13:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238059AbiKWMux (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 07:50:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238062AbiKWMu2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 07:50:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5BF87C021;
        Wed, 23 Nov 2022 04:43:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 766E1B81F6E;
        Wed, 23 Nov 2022 12:43:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D694EC433C1;
        Wed, 23 Nov 2022 12:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669207432;
        bh=L9r4kjJsiW5M3NLw6MrsVcUMzqrSzh2vWjRZgkrCBiM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t0EXdee+/J7ZQnPZhlTX3MZwpXKy+nqcOLEg7R2qIisCnj9tKWeqsRd5AUclipYmW
         drL3Udwu7J3fzTTzX7GQ0/GjdwuKa86DKQgmxjpFNS4EQN8qBFL0yFHftCOJFgRqpp
         aTdOT4gV7MPz2eiQ95xAiieEwqZE0kWdud6JvOu+WogRXB4NU0rQv9VfMJcLrMd7l7
         C5wRyB+KSY/9OZ4e9KdnvIYmWCwA8hmlnMPd6OBme3ohAQSA6Cfm4PxzLbKoLx/JTU
         NR0CRcbJLiYVZ08wncy+VhWvtHHZpbgg0kbd9D69FcPc/l6pNzO0A9omE3IKTFiMyA
         D1my+IkIi2aUQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, perex@perex.cz,
        tiwai@suse.com, kai.vehmanen@linux.intel.com, brent.lu@intel.com,
        muralidhar.reddy@intel.com, gongjun.song@intel.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 04/22] ASoC: hda: intel-dsp-config: add ES83x6 quirk for IceLake
Date:   Wed, 23 Nov 2022 07:43:19 -0500
Message-Id: <20221123124339.265912-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221123124339.265912-1-sashal@kernel.org>
References: <20221123124339.265912-1-sashal@kernel.org>
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

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 5d73263f9e7c54ccb20814dc50809b9deb9e2bc7 ]

Yet another hardware variant we need to handle.

Link: https://github.com/thesofproject/linux/issues/3873
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20221031195639.250062-1-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/intel-dsp-config.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/sound/hda/intel-dsp-config.c b/sound/hda/intel-dsp-config.c
index 2a5ba9dca6b0..7fd5c819ec36 100644
--- a/sound/hda/intel-dsp-config.c
+++ b/sound/hda/intel-dsp-config.c
@@ -302,6 +302,11 @@ static const struct config_entry config_table[] = {
 			{}
 		}
 	},
+	{
+		.flags = FLAG_SOF,
+		.device = 0x34c8,
+		.codec_hid =  &essx_83x6,
+	},
 	{
 		.flags = FLAG_SOF | FLAG_SOF_ONLY_IF_DMIC_OR_SOUNDWIRE,
 		.device = 0x34c8,
-- 
2.35.1

