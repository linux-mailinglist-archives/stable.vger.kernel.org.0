Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5C993D608E
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237472AbhGZPXE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:23:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:37860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237457AbhGZPXB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:23:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97BAF60E09;
        Mon, 26 Jul 2021 16:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315410;
        bh=Tn4kNRivwd3RJsQBSRjCaHiGwFs1/kvZSyA+RyKawfc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NPzKQ7b4cCOSLlA6bsutlzij4x7NEN8audBz0JexemC71FdbvmPXBZffHYHhjy8+7
         ULbUEFkyYOy5kZEe1srA4Jq+QNU/b04hHIVzj9FsvtbLDrsPRNMz0Qrngp61OnbHZx
         3o9MA8En6MIIlPygMszPA1eFHAGBZ7svCBLFIMOU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 086/167] ALSA: hda: intel-dsp-cfg: add missing ElkhartLake PCI ID
Date:   Mon, 26 Jul 2021 17:38:39 +0200
Message-Id: <20210726153842.294831078@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153839.371771838@linuxfoundation.org>
References: <20210726153839.371771838@linuxfoundation.org>
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
index fe49e9a97f0e..61e1de6d7be0 100644
--- a/sound/hda/intel-dsp-config.c
+++ b/sound/hda/intel-dsp-config.c
@@ -318,6 +318,10 @@ static const struct config_entry config_table[] = {
 		.flags = FLAG_SOF | FLAG_SOF_ONLY_IF_DMIC,
 		.device = 0x4b55,
 	},
+	{
+		.flags = FLAG_SOF | FLAG_SOF_ONLY_IF_DMIC,
+		.device = 0x4b58,
+	},
 #endif
 
 };
-- 
2.30.2



