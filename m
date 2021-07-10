Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE0CA3C2DA8
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231704AbhGJCYq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:24:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:41438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231682AbhGJCYp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:24:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59023613D4;
        Sat, 10 Jul 2021 02:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883721;
        bh=SpiHFREnLL2B44HMcfeUmVP5369lUqdfhCawiBvqcEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z9UhaWCWz6LjB5FxaIoAT6Jp+YHR2fSjsTbFyIYOnbZeKbzwMn+QT3U8Xlc8fWWvL
         AF3sDsBE3pSQ3G68PDi436dFhrDP/eJEsGz3C/hjS3hWGCBUPUpcQNs8l7cTultoEJ
         o19YsaveAehosDBLCN4coohl0e6DBEuP5ery/2Hcydh92AwiuNRVuLCaZH5RLvtgSc
         SNWnxlIt0stx0zL9CUxYlzROkzoh4/+lzB7gxPsDxqvjnuzjwiGOBu/HXCbYc9u6qJ
         k1zrQFZqtlHVHOWFlEkf6TZKfyd+aRZgUQD1p5c1edy9XoxbSHWH2pErHj2FsCkt3p
         ZuDxVx3ByEjPA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Libin Yang <libin.yang@intel.com>, Bard Liao <bard.liao@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.12 003/104] ASoC: Intel: sof_sdw: add SOF_RT715_DAI_ID_FIX for AlderLake
Date:   Fri,  9 Jul 2021 22:20:15 -0400
Message-Id: <20210710022156.3168825-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022156.3168825-1-sashal@kernel.org>
References: <20210710022156.3168825-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Libin Yang <libin.yang@intel.com>

[ Upstream commit 81cd42e5174ba7918edd3d006406ce21ebaa8507 ]

AlderLake needs the flag SOF_RT715_DAI_ID_FIX if it is using the
rt715 DMIC.

Reviewed-by: Bard Liao <bard.liao@intel.com>
Signed-off-by: Libin Yang <libin.yang@intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20210505163705.305616-11-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_sdw.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index 85a2797c2550..5827a16773c9 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -196,6 +196,7 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
 		},
 		.driver_data = (void *)(SOF_RT711_JD_SRC_JD1 |
 					SOF_SDW_TGL_HDMI |
+					SOF_RT715_DAI_ID_FIX |
 					SOF_SDW_PCH_DMIC),
 	},
 	{}
-- 
2.30.2

