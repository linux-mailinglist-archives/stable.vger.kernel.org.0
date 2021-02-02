Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75CC830C507
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 17:11:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235796AbhBBQKQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 11:10:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:38189 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235150AbhBBPJm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 10:09:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7409664E8C;
        Tue,  2 Feb 2021 15:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612278389;
        bh=NOcRe0VCK/Dl7v9QBx5nOMkcdzVJUUGVG2DqpXFpPcI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pWd7wAuXzDRbV6r9586bg/orrGun/9o2Sh7sLT9533KjNApGp/zRGWveLyEr3X3r9
         964VFMLxzRNWpYdVBoVeYlCNMMI14MTdELcKXIicllU7HhFL6SFy9rXJYx1Tm4+ot/
         TVXlVJYJlx/M154nIv+KrogO/JlKwm4RtKNLEEP7vRknx8fuAXGP50iCuT1dX4MmH9
         VgLnEy4UQLtVP4U5dXm4Y21ED87lBxSEhjW+Z2sQVlOVQCQp+DjrnCFEqC0ohdPZpJ
         F85YEexEQRWKymQ4kXjVu3Rj0W+97Z2EvQ1Lh49CEmC+rG8tGW1Wty7ltwVIkPPr+K
         L1xggGAKWao3Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bard Liao <bard.liao@intel.com>, Xiuli Pan <xiuli.pan@intel.com>,
        Libin Yang <libin.yang@intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 10/25] ALSA: hda: intel-dsp-config: add PCI id for TGL-H
Date:   Tue,  2 Feb 2021 10:06:00 -0500
Message-Id: <20210202150615.1864175-10-sashal@kernel.org>
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

From: Bard Liao <bard.liao@intel.com>

[ Upstream commit c5b5ff607d6fe5f4284acabd07066f96ecf96ac4 ]

Adding PCI id for TGL-H. Like for other TGL platforms, SOF is used if
Soundwire codecs or PCH-DMIC is detected.

Signed-off-by: Bard Liao <bard.liao@intel.com>
Reviewed-by: Xiuli Pan <xiuli.pan@intel.com>
Reviewed-by: Libin Yang <libin.yang@intel.com>
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20210125083051.828205-1-kai.vehmanen@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/intel-dsp-config.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/hda/intel-dsp-config.c b/sound/hda/intel-dsp-config.c
index 1c5114dedda92..fe49e9a97f0ec 100644
--- a/sound/hda/intel-dsp-config.c
+++ b/sound/hda/intel-dsp-config.c
@@ -306,6 +306,10 @@ static const struct config_entry config_table[] = {
 		.flags = FLAG_SOF | FLAG_SOF_ONLY_IF_DMIC_OR_SOUNDWIRE,
 		.device = 0xa0c8,
 	},
+	{
+		.flags = FLAG_SOF | FLAG_SOF_ONLY_IF_DMIC_OR_SOUNDWIRE,
+		.device = 0x43c8,
+	},
 #endif
 
 /* Elkhart Lake */
-- 
2.27.0

