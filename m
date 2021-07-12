Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2663C55A7
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232724AbhGLIL3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:11:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:55948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353839AbhGLIDC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:03:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 323CE61D0C;
        Mon, 12 Jul 2021 07:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076677;
        bh=ISme6h0r/FtyvzCUzDjV9rmS4uc2dDEySDlIAW33QY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eju+i3KCZ0fMr/YhkleL8WK36i+hqJwO3iAVHWU7eZDIsjidbCmdyS4TOv/aGQdQk
         3PqoDhqWYI1Dy3K2uF0u7usbOSVZMAHs3sGP8NVoZp8bzlF4RAp39lkYEUtm+GMWR/
         shGdyb3x6Z2QlbpFnHDRsThe8Gt6wG2qaYDW9xDY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 744/800] ASoC: Intel: sof_sdw: use mach data for ADL RVP DMIC count
Date:   Mon, 12 Jul 2021 08:12:47 +0200
Message-Id: <20210712061045.935169155@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
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
index 35ad448902c7..dd93f663803b 100644
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



