Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8E3B211995
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 03:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728373AbgGBBgX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 21:36:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:53646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728244AbgGBBXO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jul 2020 21:23:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C4CF2083E;
        Thu,  2 Jul 2020 01:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593652993;
        bh=K+8DiW78hpyxOFxK1fhgrYHAc5PufAYISdcBtUkSMz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eXGtN+Y/1XL9y2YWtxkFE1kgTvZizbzWIrmhtUhjVsFWz5sPcTAnagZUOly31VS8b
         636G61Jbu0KVWqonYma6mdQGtno1n+wNOYjMYeDNyWnh9q3/MitLENFVRMjPIa7Rr5
         SiA73IsqC2dVbJIOcO3dywJJUYde/5sGJ7uRWQro=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        sound-open-firmware@alsa-project.org, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.7 15/53] ASoC: SOF: Intel: add PCI IDs for ICL-H and TGL-H
Date:   Wed,  1 Jul 2020 21:21:24 -0400
Message-Id: <20200702012202.2700645-15-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200702012202.2700645-1-sashal@kernel.org>
References: <20200702012202.2700645-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit c8d2e2bfaeffa0f914330e8b4e45b986c8d30b58 ]

Usually the DSP is not traditionally enabled on H skews but this might
be used moving forward.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20200617164755.18104-4-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/sof-pci-dev.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sof/sof-pci-dev.c b/sound/soc/sof/sof-pci-dev.c
index 7b1846aeadd59..3a71f813fb563 100644
--- a/sound/soc/sof/sof-pci-dev.c
+++ b/sound/soc/sof/sof-pci-dev.c
@@ -411,8 +411,11 @@ static const struct pci_device_id sof_pci_ids[] = {
 		.driver_data = (unsigned long)&cfl_desc},
 #endif
 #if IS_ENABLED(CONFIG_SND_SOC_SOF_ICELAKE)
-	{ PCI_DEVICE(0x8086, 0x34C8),
+	{ PCI_DEVICE(0x8086, 0x34C8), /* ICL-LP */
 		.driver_data = (unsigned long)&icl_desc},
+	{ PCI_DEVICE(0x8086, 0x3dc8), /* ICL-H */
+		.driver_data = (unsigned long)&icl_desc},
+
 #endif
 #if IS_ENABLED(CONFIG_SND_SOC_SOF_JASPERLAKE)
 	{ PCI_DEVICE(0x8086, 0x38c8),
@@ -431,8 +434,11 @@ static const struct pci_device_id sof_pci_ids[] = {
 		.driver_data = (unsigned long)&cml_desc},
 #endif
 #if IS_ENABLED(CONFIG_SND_SOC_SOF_TIGERLAKE)
-	{ PCI_DEVICE(0x8086, 0xa0c8),
+	{ PCI_DEVICE(0x8086, 0xa0c8), /* TGL-LP */
 		.driver_data = (unsigned long)&tgl_desc},
+	{ PCI_DEVICE(0x8086, 0x43c8), /* TGL-H */
+		.driver_data = (unsigned long)&tgl_desc},
+
 #endif
 #if IS_ENABLED(CONFIG_SND_SOC_SOF_ELKHARTLAKE)
 	{ PCI_DEVICE(0x8086, 0x4b55),
-- 
2.25.1

