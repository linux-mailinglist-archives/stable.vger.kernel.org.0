Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45DE34EC0B1
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344326AbiC3Lwi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:52:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344259AbiC3LwR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:52:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2356275CB1;
        Wed, 30 Mar 2022 04:48:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8DE9CB81C4A;
        Wed, 30 Mar 2022 11:48:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F23FDC34112;
        Wed, 30 Mar 2022 11:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648640896;
        bh=ESR58k0+i9Fcq2CL1NwXMkUZoliC3eLirvD6WS7Nz4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VVwb4Kudegm6xzzzcGg8Go2dn83sEGEz2jjVnuzRjp+6K0Do131AuzLIpifWqoVU9
         XtbMt6fqvTwCrqj9uFSRlvX6yiI3E4/v/c888whd+6wvO9uJjr7e+y7W7emqq5si7K
         s1YLALGWMpQ3P9NV9SYR2GWhR+F+tlo//ELFhvZrcIoc9CKybFhPyDj5ZwuIRrHaPa
         JBuUWcT5V1RRcnaV6coozfLe2Ci978Tzg8MFAv5B6ZJV/FT0HeHTHmn7x59RgPVm78
         +GbPA4Up4jRfMi6lFA/o5J8+RF6+LIy6h/lE/nVAgxWcRNYqUZYZOhqCizm8bqppvt
         +ForFtUMZDBnw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Nikolai Kostrigin <nickel@altlinux.org>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        =?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, perex@perex.cz,
        tiwai@suse.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.17 57/66] ALSA: intel-dspconfig: add ES8336 support for CNL
Date:   Wed, 30 Mar 2022 07:46:36 -0400
Message-Id: <20220330114646.1669334-57-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330114646.1669334-1-sashal@kernel.org>
References: <20220330114646.1669334-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit cded07a2dccd5493696a3adce175f01e413423c6 ]

We're missing this check for the CNL PCI id

Reported-by: Nikolai Kostrigin <nickel@altlinux.org>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Acked-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20220308192610.392950-10-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/intel-dsp-config.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/sound/hda/intel-dsp-config.c b/sound/hda/intel-dsp-config.c
index b9b7bf5a5553..70fd8b13938e 100644
--- a/sound/hda/intel-dsp-config.c
+++ b/sound/hda/intel-dsp-config.c
@@ -199,6 +199,11 @@ static const struct config_entry config_table[] = {
 			{}
 		}
 	},
+	{
+		.flags = FLAG_SOF,
+		.device = 0x09dc8,
+		.codec_hid =  &essx_83x6,
+	},
 	{
 		.flags = FLAG_SOF | FLAG_SOF_ONLY_IF_DMIC_OR_SOUNDWIRE,
 		.device = 0x9dc8,
-- 
2.34.1

