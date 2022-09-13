Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 774C05B6FA3
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233043AbiIMORb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:17:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233098AbiIMOQ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:16:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8D9D62AA1;
        Tue, 13 Sep 2022 07:12:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93B8E614A9;
        Tue, 13 Sep 2022 14:11:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7B39C433C1;
        Tue, 13 Sep 2022 14:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078294;
        bh=9qR2vE0TaAtvgYNE2U/OAFbyfMPmGyvXGok/KtnlwBo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l2t4v/VEyOdUKCOylSGjuzBTz+GwLNFSFMERcKeSWYYwGd5YmRWYN3ZfbOZWg96dS
         i71CYAenWb4BhRqvuO6rz/+ix4S6dlQg8zxECtGngltEK+gkzshXLFXiQCbZQUq2nz
         QIKg7ouVwVKPRmCJy6HsMkAh6aPa7Ha9sQPW3f0k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 085/192] ASoC: SOF: Kconfig: Make IPC_FLOOD_TEST depend on SND_SOC_SOF
Date:   Tue, 13 Sep 2022 16:03:11 +0200
Message-Id: <20220913140414.197967085@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit 3942499fba11de048c3ac1390b808e9e6ae88de5 ]

Make sure that the IPC_FLOOD client can not be built in when SND_SOC_SOF is
built as module.

Fixes: 6e9548cdb30e5 ("ASoC: SOF: Convert the generic IPC flood test into SOF client")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20220823121554.4255-2-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/sof/Kconfig b/sound/soc/sof/Kconfig
index 4542868cd730f..96c40542446db 100644
--- a/sound/soc/sof/Kconfig
+++ b/sound/soc/sof/Kconfig
@@ -196,6 +196,7 @@ config SND_SOC_SOF_DEBUG_ENABLE_FIRMWARE_TRACE
 
 config SND_SOC_SOF_DEBUG_IPC_FLOOD_TEST
 	tristate "SOF enable IPC flood test"
+	depends on SND_SOC_SOF
 	select SND_SOC_SOF_CLIENT
 	help
 	  This option enables a separate client device for IPC flood test
-- 
2.35.1



