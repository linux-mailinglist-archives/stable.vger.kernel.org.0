Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 364F748038A
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 20:03:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231984AbhL0TD4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 14:03:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231938AbhL0TDz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 14:03:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3815C061401;
        Mon, 27 Dec 2021 11:03:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6418BB81131;
        Mon, 27 Dec 2021 19:03:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C1B2C36AEC;
        Mon, 27 Dec 2021 19:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640631833;
        bh=/kSEnqtez9OT93Y5Sy+PlkKcCvRC+O6KWnWnGa+Hdhw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R3n1EALRcdGh61grHfjJnkVVXpKXOCQ1tyOcl7H5dQeUgrn6vxAQPIuWR68jZHMzO
         yf8JDCjNT0uCmJT4LaQXJea0Zt2U2XvPdApZd4nz23FchV+sLzV6xE0Qv/1iTIyPUJ
         8JBU6a4h8K2InqU0WXq4OnsliiU/M3X9zo9Xs9jrRYVusdU/COy8WST3dGtkjiuM7q
         vSB5YKFDpLCHI05J4XNGtTtRRmULwvDHcAWzgknonvt3+FNuAljW+QJYOPhvn1AjfR
         kQTpvXiTHegOduETJ8e8JJsHJNJiEgXZXeclf73sbz/cbIgDn0NEkr1VL+hlecv09P
         L0s3SBuPq/tkg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        ranjani.sridharan@linux.intel.com, daniel.baluta@nxp.com,
        perex@perex.cz, tiwai@suse.com, bard.liao@intel.com,
        libin.yang@intel.com, sathya.prakash.m.r@intel.com,
        peter.ujfalusi@linux.intel.com,
        sound-open-firmware@alsa-project.org, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.15 04/26] ASoC: SOF: Intel: pci-tgl: add ADL-N support
Date:   Mon, 27 Dec 2021 14:03:05 -0500
Message-Id: <20211227190327.1042326-4-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227190327.1042326-1-sashal@kernel.org>
References: <20211227190327.1042326-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai Vehmanen <kai.vehmanen@linux.intel.com>

[ Upstream commit cd57eb3c403cb864e5558874ecd57dd954a5a7f7 ]

Add PCI DID for Intel AlderLake-N.

Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20211203171542.1021399-1-kai.vehmanen@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/pci-tgl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/sof/intel/pci-tgl.c b/sound/soc/sof/intel/pci-tgl.c
index d04ce84fe7cc2..665add8a3029b 100644
--- a/sound/soc/sof/intel/pci-tgl.c
+++ b/sound/soc/sof/intel/pci-tgl.c
@@ -119,6 +119,8 @@ static const struct pci_device_id sof_pci_ids[] = {
 		.driver_data = (unsigned long)&adl_desc},
 	{ PCI_DEVICE(0x8086, 0x51cc), /* ADL-M */
 		.driver_data = (unsigned long)&adl_desc},
+	{ PCI_DEVICE(0x8086, 0x54c8), /* ADL-N */
+		.driver_data = (unsigned long)&adl_desc},
 	{ 0, }
 };
 MODULE_DEVICE_TABLE(pci, sof_pci_ids);
-- 
2.34.1

