Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 722053C4AD3
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240800AbhGLGxy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:53:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:52482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239159AbhGLGwe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:52:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A2D7611CC;
        Mon, 12 Jul 2021 06:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072584;
        bh=XwEVRZ314tMEVsxVp+27ZoaTWo7AxiN+BV5O74CmQgo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CpEYSRoHGNLtQs7KB7FqEep0uWJuX0vC4lPvh+ECcHrmwbpMhBH0pr1s56F4ir56i
         a2oCWgdCE+r3TMOuX/jIRZYnOJNMY6n59hdM0n+Q7V883BO1A8zJFjARoE5IlSD7uA
         qj4/KRjVenWxCoIgaQQZgldf5ilnekhAXlLmRihQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 546/593] ASoC: Intel: sof_sdw: use mach data for ADL RVP DMIC count
Date:   Mon, 12 Jul 2021 08:11:46 +0200
Message-Id: <20210712060954.208202405@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai Vehmanen <kai.vehmanen@linux.intel.com>

[ Upstream commit 505351329d26e684588a6919c0407b8a0f5c3813 ]

On the reference boards, number of PCH dmics may vary and the number
should be taken from driver machine data. Remove the SOF_SDW_PCH_DMIC
quirk to make DMIC number configurable.

Fixes:d25bbe80485f8 ("ASoC: Intel: sof_sdw: add quirk for new ADL-P Rvp")

BugLink: https://github.com/thesofproject/sof/issues/4185
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20210621194057.21711-2-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_sdw.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index f0a9aad4f385..2a7b5de6da60 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -197,7 +197,6 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
 		.driver_data = (void *)(SOF_RT711_JD_SRC_JD1 |
 					SOF_SDW_TGL_HDMI |
 					SOF_RT715_DAI_ID_FIX |
-					SOF_SDW_PCH_DMIC |
 					SOF_BT_OFFLOAD_SSP(2) |
 					SOF_SSP_BT_OFFLOAD_PRESENT),
 	},
-- 
2.30.2



