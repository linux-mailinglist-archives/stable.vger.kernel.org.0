Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62A04318ED3
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 16:39:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbhBKPfI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 10:35:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:55766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231401AbhBKPb6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 10:31:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3456864F02;
        Thu, 11 Feb 2021 15:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613055928;
        bh=PIvIrg/Ezj7k1jZbQ+Hy7tkM+UZcwVFygpMDtZgDeqY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b0ztMlLf2lph+4JlO8jQvT9MHeE8PIAlpvqnznP9RzHUslwSSrjIaFtb9Nvndmrcs
         sGmadiiwp+lf0bSfJ/0wSI7SEXl+QP50N7QnnWq/d71nVprOu9OFE6K1vObM9usQQy
         ezWCiNIVlN/fwnE9utWriV2/pcGZ9ZmZBQzgk+SI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Libin Yang <libin.yang@intel.com>,
        Hui Wang <hui.wang@canonical.com>,
        Bard Liao <bard.liao@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 30/54] ASoC: Intel: sof_sdw: set proper flags for Dell TGL-H SKU 0A5E
Date:   Thu, 11 Feb 2021 16:02:14 +0100
Message-Id: <20210211150154.200546593@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210211150152.885701259@linuxfoundation.org>
References: <20210211150152.885701259@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



