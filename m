Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7335F9561
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 02:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232144AbiJJATD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 20:19:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232218AbiJJAS2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 20:18:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A437345051;
        Sun,  9 Oct 2022 16:53:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6345B80DEA;
        Sun,  9 Oct 2022 23:53:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D201C433D7;
        Sun,  9 Oct 2022 23:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665359607;
        bh=czNl4+zmuXGorycVi+NqCYslMNtgLRZLXGWQqwWbTkc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IZ+Du8KKOjgiCzHrSjpuJIHVrXsCfDseoeReD7oXVf9bUG2mB7TWTelkodsm4IkYj
         Le4fqWLEXk+is0d+Lw34BPhtyxxg6YvscBjrdrEFTtHk7hXrNrpRmtEnRDIucYcKKx
         zxSYU3AempnL/58BgRBJoO9iMPwF5Bso4AoZ21j5vwKr7fN2jk65Zsg+FpEqLES1r5
         YkCi2ScU5tpiMScV5k/u2mmoSS707VpSgvadGMIjwQVph+efYwX3V8e7kHdKfUjpzu
         VJzRAWcBifGPJ0qUOSGWruUO/bDVhhcONJCglYQare6KhlHiIVkgqqtPzAAZNf2XGN
         jcqlPt2P4fITg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Muralidhar Reddy <muralidhar.reddy@intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, perex@perex.cz,
        tiwai@suse.com, kai.vehmanen@linux.intel.com,
        yung-chuan.liao@linux.intel.com, brent.lu@intel.com,
        gongjun.song@intel.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.19 22/36] ALSA: intel-dspconfig: add ES8336 support for AlderLake-PS
Date:   Sun,  9 Oct 2022 19:52:08 -0400
Message-Id: <20221009235222.1230786-22-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009235222.1230786-1-sashal@kernel.org>
References: <20221009235222.1230786-1-sashal@kernel.org>
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

From: Muralidhar Reddy <muralidhar.reddy@intel.com>

[ Upstream commit 9db1c9fa214ef41d098633ff40a87284ca6e1870 ]

added quirks for ESS8336 for AlderLake-PS

Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Muralidhar Reddy <muralidhar.reddy@intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20220919114548.42769-1-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/intel-dsp-config.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/sound/hda/intel-dsp-config.c b/sound/hda/intel-dsp-config.c
index ec9cbb219bc1..dbc7dfd00c44 100644
--- a/sound/hda/intel-dsp-config.c
+++ b/sound/hda/intel-dsp-config.c
@@ -422,6 +422,11 @@ static const struct config_entry config_table[] = {
 		.device = 0x51cd,
 	},
 	/* Alderlake-PS */
+	{
+		.flags = FLAG_SOF,
+		.device = 0x51c9,
+		.codec_hid =  &essx_83x6,
+	},
 	{
 		.flags = FLAG_SOF | FLAG_SOF_ONLY_IF_DMIC_OR_SOUNDWIRE,
 		.device = 0x51c9,
-- 
2.35.1

