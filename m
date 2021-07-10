Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79FA83C2F6A
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234437AbhGJCbT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:31:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:42704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234530AbhGJC3f (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:29:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 171DA613CC;
        Sat, 10 Jul 2021 02:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884000;
        bh=JbCjgc8ev0nZxAc//eKoDLMYRNLvBgKM6lXAiMftk6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dZOCvpqAuSDe2S2bqt0gP3rTypJoqvFc/y2NWY903Zf9Zwa9K9OXCEyM9Kl/QdY7U
         VOybHB3jCWHEIMvID/dgW+IHv+8VLAYcDePt1f6t53YKNyPimBu4iQYuQgHiejIg+W
         v/1YjKRGIqr2zvP7XtF9c7lgtV81w55PSS7a1R7v1YV++VdpZJRLhvY5qjc6p9OJdI
         cmUeQeK91auL0S+l6vsmB6qyLUqPc1ImIXYsynsFUyhdvSbeXrGO0yolQSbe6OAzgv
         IuZqOMpbUkSv+MlUFYmLr0iO7SgQLtUOwobAUqY91rg5Ngc5V8LGMK7rodxxNRXN+I
         8el5OGIQbC0yA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Geoffrey D. Bennett" <g@b4.vu>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 75/93] ALSA: usb-audio: scarlett2: Fix 18i8 Gen 2 PCM Input count
Date:   Fri,  9 Jul 2021 22:24:09 -0400
Message-Id: <20210710022428.3169839-75-sashal@kernel.org>
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
index 9a98b0c048e3..e605ec5a91ba 100644
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

