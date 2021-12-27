Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 973E948038C
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 20:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231899AbhL0TEC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 14:04:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231926AbhL0TEC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 14:04:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9DBAC061401;
        Mon, 27 Dec 2021 11:04:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 958A3B81142;
        Mon, 27 Dec 2021 19:04:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1782C36AEA;
        Mon, 27 Dec 2021 19:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640631839;
        bh=th8OkAGeaMio9W3Yd4Ht0UEP+tvdNz4xYjx9vI8Dxbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PKfey/Cekv4DOI7DCvY3kHvWBQXOi9HCToq1n3D+NXfR1PFP7zp6M/C/kDPEJ0um9
         NObHaSUXwn8e2RM11MYcXXX2mWSJF22caBeUOfm6YdcNzp5h0q7zG0wwVXyyZzmeo1
         nqlmJWZEzXvt78HLjwk60JkdhRr3nPFSKoT+qKvA6lgWLJhAaRB3gcp5W1CZqvgMdo
         RRd/MuIXqL/uIMgIR8B0PpxzjoVdkfIpKor8HHl4hsN0gAPsO/2A8msou+XjSucJrE
         pJ9iAYCt02T86laRajrjY9w1P/RyyGnzoauTprlmz56BpQiSHCgsQAJJChht3DMS5y
         N7arw5iOxW2/g==
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
Subject: [PATCH AUTOSEL 5.15 05/26] ASoC: SOF: Intel: pci-tgl: add new ADL-P variant
Date:   Mon, 27 Dec 2021 14:03:06 -0500
Message-Id: <20211227190327.1042326-5-sashal@kernel.org>
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

[ Upstream commit de7dd9092cd38384f774d345cccafe81b4b866b0 ]

Add a PCI DID for a variant of Intel AlderLake-P.

Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20211203171542.1021399-2-kai.vehmanen@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/pci-tgl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/sof/intel/pci-tgl.c b/sound/soc/sof/intel/pci-tgl.c
index 665add8a3029b..beb2fb3cd0141 100644
--- a/sound/soc/sof/intel/pci-tgl.c
+++ b/sound/soc/sof/intel/pci-tgl.c
@@ -117,6 +117,8 @@ static const struct pci_device_id sof_pci_ids[] = {
 		.driver_data = (unsigned long)&adls_desc},
 	{ PCI_DEVICE(0x8086, 0x51c8), /* ADL-P */
 		.driver_data = (unsigned long)&adl_desc},
+	{ PCI_DEVICE(0x8086, 0x51cd), /* ADL-P */
+		.driver_data = (unsigned long)&adl_desc},
 	{ PCI_DEVICE(0x8086, 0x51cc), /* ADL-M */
 		.driver_data = (unsigned long)&adl_desc},
 	{ PCI_DEVICE(0x8086, 0x54c8), /* ADL-N */
-- 
2.34.1

