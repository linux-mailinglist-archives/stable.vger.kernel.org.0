Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38DB93C2F78
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233004AbhGJCba (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:31:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:41746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234604AbhGJC3h (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:29:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0DD81613D1;
        Sat, 10 Jul 2021 02:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884012;
        bh=CW1WmbuVl1Tuj60stuh6NuzXVGlP0X1tiTCK37+XWn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RJIz0NEmeuHE4si3NSRmtnVbRNFN4+nhFv1kwuks5tQD79MjAg508uCfb4HrFXVBn
         XR1TIc83AqfnMOogRV/lSVplqVX1PFOaCAwbd/aHVHQiFBMsjZid6iUC0Ag3Rrf42V
         LAHYwNQbVEQt56B9Z9YPT3aKGpUDNz/nqwxh9zLrCxqZSOHTmYnBs/oy167GbDmCOV
         gmvGKn8toD04J5KwbAzfdXaKSaJcpCxeKI3stc1iTVhrmvn6rLU2gRhSIP/o57hjqy
         lD55wVnH7UYUyzrwqhBzi290V4VzPJELm+ddj2rr9vJHC435+kZkO3LJp4eGCbq+fN
         apSkuziOYV/cA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Geoffrey D. Bennett" <g@b4.vu>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 84/93] ALSA: usb-audio: scarlett2: Fix 6i6 Gen 2 line out descriptions
Date:   Fri,  9 Jul 2021 22:24:18 -0400
Message-Id: <20210710022428.3169839-84-sashal@kernel.org>
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

From: "Geoffrey D. Bennett" <g@b4.vu>

[ Upstream commit c712c6c0ff2d60478582e337185bcdd520a7dc2e ]

There are two headphone outputs, and they map to the four analogue
outputs.

Signed-off-by: Geoffrey D. Bennett <g@b4.vu>
Link: https://lore.kernel.org/r/205e5e5348f08ded0cc4da5446f604d4b91db5bf.1624294591.git.g@b4.vu
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_scarlett_gen2.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/usb/mixer_scarlett_gen2.c b/sound/usb/mixer_scarlett_gen2.c
index 6d7805d3c39a..d93ae8c244ba 100644
--- a/sound/usb/mixer_scarlett_gen2.c
+++ b/sound/usb/mixer_scarlett_gen2.c
@@ -254,10 +254,10 @@ static const struct scarlett2_device_info s6i6_gen2_info = {
 	.pad_input_count = 2,
 
 	.line_out_descrs = {
-		"Monitor L",
-		"Monitor R",
-		"Headphones L",
-		"Headphones R",
+		"Headphones 1 L",
+		"Headphones 1 R",
+		"Headphones 2 L",
+		"Headphones 2 R",
 	},
 
 	.ports = {
-- 
2.30.2

