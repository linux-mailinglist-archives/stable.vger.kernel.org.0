Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28DD03C2EB7
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233559AbhGJC2L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:28:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:41746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233627AbhGJC1d (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:27:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2873F613EC;
        Sat, 10 Jul 2021 02:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883872;
        bh=FUpAEdQq+XfwL3GPsyMFhIPGfekmtIg7/BW20ILiQFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q8zmeyy6HAOM8glGPPIuJozy8dcC2ItVLixOTYMUouWd/eCae8yLwFQ+LJaZzNzmC
         nXTThFzy2SjTlZFk6whDlsd8X62BkLypudBu+ufG/RiNkMQpK8lmXkuXgsOBYY0Ztg
         2tOspkH8qfsCrLEw8huJt49kbSxyxGdL1EqcLp3+qZhI+AFu+uPK13p/wQp93Kpt8J
         xp6KNKG+UgbBkNMj3JtXDwSfbC/JtwZP4GhxkIo9bju+EY/uR1/zDwqH7+eWZMP7Rq
         Rj/iJVuO8rN3SwJ6PZOYDDNevdtjWpYpfPYKpLSKDe9XrLbBt983hn01vWbtgTHwfB
         3bKv4k0gIDikw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Libin Yang <libin.yang@intel.com>, Bard Liao <bard.liao@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 03/93] ASoC: Intel: sof_sdw: add SOF_RT715_DAI_ID_FIX for AlderLake
Date:   Fri,  9 Jul 2021 22:22:57 -0400
Message-Id: <20210710022428.3169839-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022428.3169839-1-sashal@kernel.org>
References: <20210710022428.3169839-1-sashal@kernel.org>
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
index 53c9b47d1ad4..2770e8179983 100644
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

