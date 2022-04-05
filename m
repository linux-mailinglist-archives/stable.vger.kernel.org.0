Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24D644F2D3D
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236580AbiDEJDJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238205AbiDEIaY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:30:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F43D22BF3;
        Tue,  5 Apr 2022 01:21:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E75ABB81BAF;
        Tue,  5 Apr 2022 08:21:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FF29C385A0;
        Tue,  5 Apr 2022 08:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146913;
        bh=s0wj/LBQJuAxdPrtimr7Muy8fa/7WRNCVbi4aDUt0iY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DDntSgq+LWS9K4f3iLPv0XOw+lDiKIORPRdnm5qTrO7EgN9/S5tpmOTAf8Xquosae
         bTPw3i+wmUxpcsvszfOIPmNX/oLGNUk01kmJka8bTUADoOKb7a6Zqp2i1e/lLia+FL
         xjPskvROawyWFADkWfWrUNgPJWtXgHgs7+q0JFe0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ranjani Sridharan <ranjani.sridharan@intel.com>,
        =?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0935/1126] ASoC: SOF: debug: clarify operator precedence
Date:   Tue,  5 Apr 2022 09:28:02 +0200
Message-Id: <20220405070434.958826957@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

[ Upstream commit 9188812539d1d9a13dac690c95ec657259859ba4 ]

cppcheck warning:

for '&' and '?'. [clarifyCalculation]
 char *level = flags & SOF_DBG_DUMP_OPTIONAL ? KERN_DEBUG : KERN_ERR;
                                             ^

sound/soc/sof/debug.c:398:46: style: Clarify calculation precedence
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20220304205733.62233-10-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/sof/debug.c b/sound/soc/sof/debug.c
index 6d6757075f7c..e755c0c5f86c 100644
--- a/sound/soc/sof/debug.c
+++ b/sound/soc/sof/debug.c
@@ -960,7 +960,7 @@ static void snd_sof_dbg_print_fw_state(struct snd_sof_dev *sdev, const char *lev
 
 void snd_sof_dsp_dbg_dump(struct snd_sof_dev *sdev, const char *msg, u32 flags)
 {
-	char *level = flags & SOF_DBG_DUMP_OPTIONAL ? KERN_DEBUG : KERN_ERR;
+	char *level = (flags & SOF_DBG_DUMP_OPTIONAL) ? KERN_DEBUG : KERN_ERR;
 	bool print_all = sof_debug_check_flag(SOF_DBG_PRINT_ALL_DUMPS);
 
 	if (flags & SOF_DBG_DUMP_OPTIONAL && !print_all)
-- 
2.34.1



