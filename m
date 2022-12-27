Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA498656EF6
	for <lists+stable@lfdr.de>; Tue, 27 Dec 2022 21:36:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232585AbiL0UgW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Dec 2022 15:36:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232282AbiL0Uer (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Dec 2022 15:34:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A95AD110;
        Tue, 27 Dec 2022 12:33:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0BDA4B81023;
        Tue, 27 Dec 2022 20:33:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8184C43392;
        Tue, 27 Dec 2022 20:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672173236;
        bh=/BbpzhDYMphEHBAQuZT/NpHTPQH7dEvj3hXsXcq8IaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SwqfRM9KIG9KCggvtZCd7hlQ15TprECuyAbzY3YaJ+Z8pEMk1kFU4ccQGQCq2/Rom
         JtpiYRM5dAbrvOd3XzQfI446iBX3D9o3h0ZjX/thujyj26ndEC2bjbwjvD+is1zNFP
         vBBixls73nqCzUpr0MM1HN8i5lxmOUPve8Nyt/nifa7oBnaNn5TZ7mpZ4hEXqyGcmW
         HqA59Goht+m/iTLOKWlhxI+k799MfpuEfy2fc9SNfAEHHjRCENSpAdgooHEnmNpUb8
         ZamRf0FxM4B+zQd8sy/FsykX/xn6UfoiaHvbWIgxwoVWG1sLF8ulr+3UkkYCTmWQ4x
         Rlmf1YVQDJ6OA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 6.0 11/27] soundwire: dmi-quirks: add quirk variant for LAPBC710 NUC15
Date:   Tue, 27 Dec 2022 15:33:26 -0500
Message-Id: <20221227203342.1213918-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221227203342.1213918-1-sashal@kernel.org>
References: <20221227203342.1213918-1-sashal@kernel.org>
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
index f81cdd83ec26..7969881f126d 100644
--- a/drivers/soundwire/dmi-quirks.c
+++ b/drivers/soundwire/dmi-quirks.c
@@ -90,6 +90,14 @@ static const struct dmi_system_id adr_remap_quirk_table[] = {
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

