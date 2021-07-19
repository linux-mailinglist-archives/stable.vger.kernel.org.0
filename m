Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1A853CE221
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347787AbhGSP3K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:29:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:44194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239541AbhGSP1G (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:27:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2783C600EF;
        Mon, 19 Jul 2021 16:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710865;
        bh=YvIvqi+JbUnVFfasmfAGX/oC3C/tGydo5uv9M3lzemg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FZ2xj+GSoBG60Q0pFFVVHoxrz/rgCgQ9r/tirLPJRZF8m+261F+oOB/0sKdnXZizM
         xFq8mso9PQHQZudWXWpcbh69JyQEVjjLFHB9Eb1V7k6or0G6LC4I2hYB9m7VfWRhAt
         7GCp4mPb9ybPQu47PjdHdWGHZNXPNk1PiWoRrbv0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Geoffrey D. Bennett" <g@b4.vu>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 138/351] ALSA: usb-audio: scarlett2: Fix 6i6 Gen 2 line out descriptions
Date:   Mon, 19 Jul 2021 16:51:24 +0200
Message-Id: <20210719144949.053284739@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geoffrey D. Bennett <g@b4.vu>

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
index b92319928ddd..38f4a2a37e0f 100644
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



