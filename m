Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6CF9656F35
	for <lists+stable@lfdr.de>; Tue, 27 Dec 2022 21:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232453AbiL0Ujo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Dec 2022 15:39:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232762AbiL0Uit (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Dec 2022 15:38:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13628DEC9;
        Tue, 27 Dec 2022 12:34:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A39FB61035;
        Tue, 27 Dec 2022 20:34:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49D00C43398;
        Tue, 27 Dec 2022 20:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672173288;
        bh=VkP2CjrJk+HD418/snu78RrFCmHyNBdJSy90Z6tPagA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ENF74Ed5qXiTMBu/tW5nVsTUyTgUFzIfz2+dmzg6bDXX4B3yTM3Tm0LqVHxjdqT0S
         VyHClnJq6G9Can3U5pFiZnNzXyI0ggEIzCVWXhGpf+kN71sfXIRQkEnL5XuNV7vVlt
         hmdBBeNaNNYL1Pf6mzcYwi8B8RPBssaMvukch12ZFkaJm3+/rxnoeBl4LXBVNL+1RF
         Bluxkga0bpYFyuMpzP8BTIFkVzdbaUQWox5hdRTOrin1vlIHJtZSPD0qzk8RmohHR7
         SOyKoqIbTGMs3a5RWQqi3gxYYWNU6MJVY6w74wyNADoTDaTBR0U6hbLPzfahNPrER8
         ZJzz72oYbBQsw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.15 11/22] soundwire: dmi-quirks: add quirk variant for LAPBC710 NUC15
Date:   Tue, 27 Dec 2022 15:34:21 -0500
Message-Id: <20221227203433.1214255-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221227203433.1214255-1-sashal@kernel.org>
References: <20221227203433.1214255-1-sashal@kernel.org>
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

[ Upstream commit f74495761df10c25a98256d16ea7465191b6e2cd ]

Some NUC15 LAPBC710 devices don't expose the same DMI information as
the Intel reference, add additional entry in the match table.

BugLink: https://github.com/thesofproject/linux/issues/3885
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20221018012500.1592994-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/dmi-quirks.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/soundwire/dmi-quirks.c b/drivers/soundwire/dmi-quirks.c
index 747983743a14..2bf534632f64 100644
--- a/drivers/soundwire/dmi-quirks.c
+++ b/drivers/soundwire/dmi-quirks.c
@@ -71,6 +71,14 @@ static const struct dmi_system_id adr_remap_quirk_table[] = {
 		},
 		.driver_data = (void *)intel_tgl_bios,
 	},
+	{
+		/* quirk used for NUC15 LAPBC710 skew */
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Intel Corporation"),
+			DMI_MATCH(DMI_BOARD_NAME, "LAPBC710"),
+		},
+		.driver_data = (void *)intel_tgl_bios,
+	},
 	{
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc"),
-- 
2.35.1

