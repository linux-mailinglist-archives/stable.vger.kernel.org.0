Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 385123C3089
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233646AbhGJCft (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:35:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:53316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235628AbhGJCe4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:34:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82469613BE;
        Sat, 10 Jul 2021 02:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884316;
        bh=7iLZnB+H2+FdhJR40Zgrh0rpjt5NcQ0fU7XtOb7D+Bs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d41vSwrMAe5JrG7+dnfghRQLDmFmJqcBQho4+q1MplO5cn0TvChai2ZQvFvIaDiLz
         KQK5LJmr+5XW1+t88/CaikxNBBXcUxu/aEniNcIzyNb7W2ph8s9Wwcl9Ve65Z/Z/T0
         XePnoyiUGCrCrFhPkeilBAgufEhqaijX/FPMG+HljZcGENNAK3lCZBO2tyCoITV0cJ
         +78vbAVvlCjYAlPNlxBedxIhKOCmg5tcTDfK2lAfcx6V+2JFdDkQAcBUQulCQOTX3l
         N4xUiHNeYw6GKjCHrIuL+ttXeyM32ZHoenD04+mmz+vyasxWTZ3CnDMPy6gofU8P5M
         WbkPS5pbfLyTg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Geoffrey D. Bennett" <g@b4.vu>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 58/63] ALSA: usb-audio: scarlett2: Fix 6i6 Gen 2 line out descriptions
Date:   Fri,  9 Jul 2021 22:27:04 -0400
Message-Id: <20210710022709.3170675-58-sashal@kernel.org>
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
index 8fd1f948a892..ddab4c77a690 100644
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

