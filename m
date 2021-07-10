Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64B783C307C
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232493AbhGJCfm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:35:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:53324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235268AbhGJCel (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:34:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18D35613DF;
        Sat, 10 Jul 2021 02:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884304;
        bh=PkSew/L7a5CZA8pzZm2Fs4l+YfiSZQ4+TPIomgX1wAI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JFy0Uah2L8bNoBhbhX5HTeK90ezKHbLBnjsAcCEIhskUYpio7p5GOPgBxgAHfdBCV
         0Znud8SqFX5Q67v3xktRUkleVz8hXjiMXA2Vq+j1fD76Tw9S78YmsmlGe9H/b2nrXJ
         VolA652xdflNrTpoTmj745V9Mu6WVVfn//bTFCluHTRFpGNUTY+U/K46eonv3kmWWO
         zH1/deTigOIn7SGewCuW85fmSACTUIjGc9KCMon1HSCF2V3BAWROMzeYHjyFyR7OFt
         sn9aMd8uZe9lQQbY79S6r/+iX1XvNmthOvgpieVsTAe9tLm8lXeb7QTkZ6Ei+kbnig
         gFpa9kiV3bQYg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Geoffrey D. Bennett" <g@b4.vu>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 49/63] ALSA: usb-audio: scarlett2: Fix 18i8 Gen 2 PCM Input count
Date:   Fri,  9 Jul 2021 22:26:55 -0400
Message-Id: <20210710022709.3170675-49-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022709.3170675-1-sashal@kernel.org>
References: <20210710022709.3170675-1-sashal@kernel.org>
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
index 7a10c9e22c46..a1f1ff72be4f 100644
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

