Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C34312FC794
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 03:16:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728240AbhATCO4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 21:14:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:46620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730897AbhATB3q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Jan 2021 20:29:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5FECD2333D;
        Wed, 20 Jan 2021 01:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611106105;
        bh=En105Zd0+0J6+AvJH7BM2K78zAEVYYzM+RNhDWP4fts=;
        h=From:To:Cc:Subject:Date:From;
        b=F6pOd8qUapWwNvz1+4n/x8sJuf2fCgiXLXQ86OcG/HTDGTtaAVVvcJDm+UkwxPNKC
         vrUyCnec46r+t4U9hfuQTrlheyU9TYNGBVMpcjNZCYIIWwT5NHLNKmgQKJvOBnyEFH
         no9Vd0mhibplT6Dw9Bhnp4t7Y0UldIDREIUu0S5kT7js0h4EENqZbELUQZwnov1pyY
         nw9dwLPs/POYZz6YIOfMqEi7u/Y5aV4BkzwLmm52OxJvTLw0IynZVaJS7wiOP7d9Sf
         MtkIbeZMmiTF4RLfAU1lv2GNoPGRYm/HhA80piLbmCxAVfG4RcVSL1fL8XTSts+Faj
         x6XVQ+cURZfDA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Cezary Rojewski <cezary.rojewski@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.4 1/4] ASoC: Intel: haswell: Add missing pm_ops
Date:   Tue, 19 Jan 2021 20:28:20 -0500
Message-Id: <20210120012823.770731-1-sashal@kernel.org>
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
index de955c2e8c4e3..a0e67d5f59683 100644
--- a/sound/soc/intel/boards/haswell.c
+++ b/sound/soc/intel/boards/haswell.c
@@ -197,6 +197,7 @@ static struct platform_driver haswell_audio = {
 	.probe = haswell_audio_probe,
 	.driver = {
 		.name = "haswell-audio",
+		.pm = &snd_soc_pm_ops,
 	},
 };
 
-- 
2.27.0

