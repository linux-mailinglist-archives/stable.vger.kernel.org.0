Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7C7D2FC80F
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 03:34:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387421AbhATCbm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 21:31:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:46630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730790AbhATB32 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Jan 2021 20:29:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CED7223441;
        Wed, 20 Jan 2021 01:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611106084;
        bh=9zKkvOfDNwl6eBjoQDcLMVhaf5ppRyV83Q/SpXcoSqw=;
        h=From:To:Cc:Subject:Date:From;
        b=gWFNERlShBFV90kdBOtR5g3agkZNOxzZJoBkG8Vb+RBSPqXpSzucqStStAHOgHKvd
         GKVvV3JNF8Xf99Lze7fiVWCKiWn0lbI8vAMXy0Rz5fyY7QAAJe5St7yxMVCUjMF5ti
         LBop4OckLlXbGKp4rWZR5xRG0Rgbj52tDqWc9qgYxrYiiJBczW5QXYnbLfKEX9uQuU
         AD5oLFZ4r4oIBqrMW09pMTivj38JGwdSA8eBh9YZlJERN6Iky5n11g1ZEpGQSqVG5k
         h2KsEhOSyOFVnv+nrvtIaQHkdEDAPYq8x+/5gmyjceh3KN21uU/pbDCmgacmlSOUdk
         tbnCpf1rAolpA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Cezary Rojewski <cezary.rojewski@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.14 1/9] ASoC: Intel: haswell: Add missing pm_ops
Date:   Tue, 19 Jan 2021 20:27:54 -0500
Message-Id: <20210120012802.770525-1-sashal@kernel.org>
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
index 8158409921e02..c6007aa95fff1 100644
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

