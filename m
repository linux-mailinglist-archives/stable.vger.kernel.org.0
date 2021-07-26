Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B72F13D6207
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234870AbhGZPeA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:34:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:49346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233894AbhGZPcv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:32:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B8DD360240;
        Mon, 26 Jul 2021 16:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315996;
        bh=vVvy4hSjIT2YYFx/pQUOBThGuioYUH/O9n9ljY/k+qw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JkNeP558CfAGZcqP1dMzHq4tFPclRfqzU/tu+bFAFNgUI/bgGts1S1Pdde6B/98tA
         j9FQHei8te5GbQMLEMV9xKA59jjtksluJ6B9fDCW0XpRhlDTWl96pSh9qyG+jbmMGb
         3OTEaK5umvIFC+XR2bhGlHsilpjK/PGR5z8OPr50=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 112/223] ALSA: hda: intel-dsp-cfg: add missing ElkhartLake PCI ID
Date:   Mon, 26 Jul 2021 17:38:24 +0200
Message-Id: <20210726153849.938790309@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 114613f62f42e7cbc1242c4e82076a0153043761 ]

We missed the fact that ElkhartLake platforms have two different PCI
IDs. We only added one so the SOF driver is never selected by the
autodetection logic for the missing configuration.

BugLink: https://github.com/thesofproject/linux/issues/2990
Fixes: cc8f81c7e625 ('ALSA: hda: fix intel DSP config')
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20210719231746.557325-1-pierre-louis.bossart@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/intel-dsp-config.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/hda/intel-dsp-config.c b/sound/hda/intel-dsp-config.c
index d8be146793ee..c9d0ba353463 100644
--- a/sound/hda/intel-dsp-config.c
+++ b/sound/hda/intel-dsp-config.c
@@ -319,6 +319,10 @@ static const struct config_entry config_table[] = {
 		.flags = FLAG_SOF | FLAG_SOF_ONLY_IF_DMIC,
 		.device = 0x4b55,
 	},
+	{
+		.flags = FLAG_SOF | FLAG_SOF_ONLY_IF_DMIC,
+		.device = 0x4b58,
+	},
 #endif
 
 /* Alder Lake */
-- 
2.30.2



