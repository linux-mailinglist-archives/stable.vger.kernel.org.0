Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E04822FC903
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 04:35:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732042AbhATC3v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 21:29:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:47420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730132AbhATB2i (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Jan 2021 20:28:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F87223359;
        Wed, 20 Jan 2021 01:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611106026;
        bh=PGuMs4WIllYlMcEsKh2EnKnF4jCyBPRhs34xat9Jk1g=;
        h=From:To:Cc:Subject:Date:From;
        b=YC+MPEIMLU1fW1KWtO58W4/EObZUN0gMLrplqUeeSGaM9XhsI3x7LFiwHfm2cdOAk
         QZNORmO55b3mIurY2qdCVz3R/X4aKF4apYwMCpSr85192patOd3iNt3gd/FLmRgDM7
         2UnldqnjHxOmeL5pbELsvT9+nyT+V4z8K3gTHoXol4bWsJ6VEBSQJNU8so5pLy3PY+
         eS+8FKEw5E42nrDuHXuytp1JtrwDKO0NpAxP6h2V6PHQACYPwOLhWk6yflXgwNUgmR
         GWrZMs9BYrH0NfEsQ6PjK19AHmSHKdY55nOx5tRT1GdZG6swJ85J9QeKmQVss3Exif
         9G1n0TlJ4m9Zg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Cezary Rojewski <cezary.rojewski@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 01/26] ASoC: Intel: haswell: Add missing pm_ops
Date:   Tue, 19 Jan 2021 20:26:38 -0500
Message-Id: <20210120012704.770095-1-sashal@kernel.org>
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
index 3dadf9bff796a..cf47fd9cd506b 100644
--- a/sound/soc/intel/boards/haswell.c
+++ b/sound/soc/intel/boards/haswell.c
@@ -206,6 +206,7 @@ static struct platform_driver haswell_audio = {
 	.probe = haswell_audio_probe,
 	.driver = {
 		.name = "haswell-audio",
+		.pm = &snd_soc_pm_ops,
 	},
 };
 
-- 
2.27.0

