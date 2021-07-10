Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0433C2E87
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233622AbhGJC13 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:27:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:42926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233459AbhGJC0u (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:26:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1FFC61404;
        Sat, 10 Jul 2021 02:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883839;
        bh=LxCwRtxaKji1/yWWC225oB97o2nP1W9knzaC4LCyCzA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jEB8NxiPL8/bmuQROB22O6634L5slEeJbCuXopZq/9DJZxZin+9LLzoCEqpOMopFl
         pSHgsClv2JWrFM0YTtx55NV9l/cOQJBT/v8RLJSfI3xt5xXOQtjmhmIC/Ad5xvb1ZY
         RhBJX+3fCxcqWJTecQJSd7lSB0dYm9QUfd/oM4hsehLlKjbniprwb3Gmt3rLIpgjjC
         2Peb5sDSzzPx07dPRPCykdKYA376FQLVpWw0t46K9E4yR2a/FoDqu86Lb35T2/1Hcm
         ItFDqGbf2jp2B2lG/2Xk7ZTnursHJ5RVxe/UFRYnPZ+4hScfVyKbsN14Js7gomKZZb
         yfP/h0itkh45A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Geoffrey D. Bennett" <g@b4.vu>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.12 085/104] ALSA: usb-audio: scarlett2: Fix 18i8 Gen 2 PCM Input count
Date:   Fri,  9 Jul 2021 22:21:37 -0400
Message-Id: <20210710022156.3168825-85-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022156.3168825-1-sashal@kernel.org>
References: <20210710022156.3168825-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Geoffrey D. Bennett" <g@b4.vu>

[ Upstream commit c5210f213456383482b4a77c5310282a89a106b5 ]

The 18i8 Gen 2 has 8 PCM Inputs, not 20. Fix the ports entry in
s18i8_gen2_info.

Signed-off-by: Geoffrey D. Bennett <g@b4.vu>
Link: https://lore.kernel.org/r/20210620164625.GA9165@m.b4.vu
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_scarlett_gen2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/mixer_scarlett_gen2.c b/sound/usb/mixer_scarlett_gen2.c
index 4caf379d5b99..b2fa317ba2ab 100644
--- a/sound/usb/mixer_scarlett_gen2.c
+++ b/sound/usb/mixer_scarlett_gen2.c
@@ -356,7 +356,7 @@ static const struct scarlett2_device_info s18i8_gen2_info = {
 		},
 		[SCARLETT2_PORT_TYPE_PCM] = {
 			.id = 0x600,
-			.num = { 20, 18, 18, 14, 10 },
+			.num = { 8, 18, 18, 14, 10 },
 			.src_descr = "PCM %d",
 			.src_num_offset = 1,
 			.dst_descr = "PCM %02d Capture"
-- 
2.30.2

