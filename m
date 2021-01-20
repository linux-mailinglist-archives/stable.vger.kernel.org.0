Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F1192FC806
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 03:34:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732604AbhATCbZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 21:31:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:48234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728242AbhATB3T (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Jan 2021 20:29:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12C1423437;
        Wed, 20 Jan 2021 01:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611106062;
        bh=4a17WWqCWMg+33SgzqVc9aR8rOqnpBy9FNYj0IklNsA=;
        h=From:To:Cc:Subject:Date:From;
        b=uPSOA72gW7aM+LbjHGTMCLR5WwP5h8DBd2K8ac5+W2QXDyulqvQMhkl9RkgFWkxDS
         Ou3by9fb2bfuMXKDB9AOZJVOIx5X7PuUVszXStSPU0iafr0cBckDAYMa81UYdH9Nhj
         5uZ5j4/GqlLTxlrvj/BGlME2eslv5acEx3/Coel3KMCju331xTEAwYeXYJDsK3ALsH
         zIYloqcmYZljxv9+TRpzvJ2PnfdytTvi/v838Jp3RfxRi7hN/miIvfy5FZUJPaeMPK
         p6nD5MHYv+a3ksdv3diGqyj3cHIOqPVl+Gs1qfn3PnkQZz93DccvLjW349f7OlJKol
         ySrxH+Q1l1ICA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Cezary Rojewski <cezary.rojewski@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.19 01/15] ASoC: Intel: haswell: Add missing pm_ops
Date:   Tue, 19 Jan 2021 20:27:26 -0500
Message-Id: <20210120012740.770354-1-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit bb224c3e3e41d940612d4cc9573289cdbd5cb8f5 ]

haswell machine board is missing pm_ops what prevents it from undergoing
suspend-resume procedure successfully. Assign default snd_soc_pm_ops so
this is no longer the case.

Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://lore.kernel.org/r/20201217105401.27865-1-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/haswell.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/intel/boards/haswell.c b/sound/soc/intel/boards/haswell.c
index a4022983a7ce0..67eb4a446c3cb 100644
--- a/sound/soc/intel/boards/haswell.c
+++ b/sound/soc/intel/boards/haswell.c
@@ -198,6 +198,7 @@ static struct platform_driver haswell_audio = {
 	.probe = haswell_audio_probe,
 	.driver = {
 		.name = "haswell-audio",
+		.pm = &snd_soc_pm_ops,
 	},
 };
 
-- 
2.27.0

