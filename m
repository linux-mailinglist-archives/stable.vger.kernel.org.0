Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75DD43C2E97
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233712AbhGJC1n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:27:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:42574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233719AbhGJC1F (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:27:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B812613D6;
        Sat, 10 Jul 2021 02:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883852;
        bh=Cq5+2Ebc6c6hl+v8/BtGJsmNhPOn2K1nEcnUhiM6loc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G0FkytNQYuk4HbGoFJoPx2iwXMGrQSHCZz9vpWqlaZTWjFH7AY7sQPEQYBOM7nlmp
         aTK8jO5h//Ao4AjcCDzZk/lp9Ucp3wI7iu+SyAqh9suwqZz+r1sU+hvNBvyOqXrEJj
         MSY5IwomtUeQ1GpgaogBDjARF2DjWBSN52DHgJ/gfYfLQeDDxr+wpYhvQ/XFFEPhvq
         uep2wflXsvLuB6Q/AxnAdLtr6vgub7DrwQsPPYywXumujl5kvZ7vXfdwnAsk8+JBxu
         81hhvNtTF6+OTqYRoFFIRK6OEQK5Zmd2XEQY5UzYbuuAsCLKfQSOYvNKcVDFRdBoFj
         wLoHEyjLfh/ZA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Geoffrey D. Bennett" <g@b4.vu>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.12 095/104] ALSA: usb-audio: scarlett2: Fix 6i6 Gen 2 line out descriptions
Date:   Fri,  9 Jul 2021 22:21:47 -0400
Message-Id: <20210710022156.3168825-95-sashal@kernel.org>
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
index a829c3c7a30c..558b51dc37da 100644
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

