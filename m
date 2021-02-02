Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8B7D30C4EC
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 17:08:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235950AbhBBQGu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 11:06:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:38254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235151AbhBBPJo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 10:09:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 171CD64F68;
        Tue,  2 Feb 2021 15:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612278392;
        bh=PIvIrg/Ezj7k1jZbQ+Hy7tkM+UZcwVFygpMDtZgDeqY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p5e23Hwee7UWw28pQdO5+dZt8OnUvrpx56kvR/ck7L3K8M9MFTlW27fS5aTlXI1Wj
         ZlYtUfdfv4q8/Xa9r9tTOnUas3n3go0rFaVgWoCAMOvAbeePNr9iASkb9wT8UUOE2Q
         3b71vYedFip9YQOz8qx4YAqewHtd/TaEEAM7iy260dpWVj7ttr05OVPvlN9AlHH+TT
         L69VRl9BhfCYUNSORN9mn7vLtDHWaBCp2U4wmPcl9tdzVOLJztEqgeAYTz1BcniiFs
         5H1keg2w3C0/+UF1t98hrEfHEcfT0xjHw6mRLp+pqh5SlHQQ6iQzkGO6fV+3CDGopt
         A7Pdf5VsLfRPg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Libin Yang <libin.yang@intel.com>,
        Hui Wang <hui.wang@canonical.com>,
        Bard Liao <bard.liao@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 12/25] ASoC: Intel: sof_sdw: set proper flags for Dell TGL-H SKU 0A5E
Date:   Tue,  2 Feb 2021 10:06:02 -0500
Message-Id: <20210202150615.1864175-12-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210202150615.1864175-1-sashal@kernel.org>
References: <20210202150615.1864175-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Libin Yang <libin.yang@intel.com>

[ Upstream commit 9ad9bc59dde106e56dd59ce2bec7c1b08e1f0eb4 ]

Add flag "SOF_RT711_JD_SRC_JD2", flag "SOF_RT715_DAI_ID_FIX"
and "SOF_SDW_FOUR_SPK" to the Dell TGL-H based SKU "0A5E".

Signed-off-by: Libin Yang <libin.yang@intel.com>
Co-developed-by: Hui Wang <hui.wang@canonical.com>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
Reviewed-by: Bard Liao <bard.liao@intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20210125081117.814488-1-kai.vehmanen@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_sdw.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index b29946eb43551..a8d43c87cb5a2 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -57,6 +57,16 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
 		.driver_data = (void *)(SOF_RT711_JD_SRC_JD2 |
 					SOF_RT715_DAI_ID_FIX),
 	},
+	{
+		.callback = sof_sdw_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "0A5E")
+		},
+		.driver_data = (void *)(SOF_RT711_JD_SRC_JD2 |
+					SOF_RT715_DAI_ID_FIX |
+					SOF_SDW_FOUR_SPK),
+	},
 	{
 		.callback = sof_sdw_quirk_cb,
 		.matches = {
-- 
2.27.0

