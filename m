Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74AD32E3F97
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503814AbgL1O0a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:26:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:34074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503810AbgL1O03 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:26:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8895322B2C;
        Mon, 28 Dec 2020 14:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165574;
        bh=AKnz6m8x89h9wAhRc4txYXMGEUPM4bXyTYHoqBlQJ/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q48QpJ2fzORn5zNp52xQXUgtNohPOnMSn0KOkk36G/uSJTAsmPr5D82FSc5DYl+He
         KJX25Eo9FdjRsotPELxfOZAjf1NLS3vPr9egsFFblnV7v36NxGzbL9wOnuje07gKGX
         iAhIM51GMtu8BLXW9/5F1TvGI3UsFljj9Zc5eM5Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 549/717] ALSA: usb-audio: Add alias entry for ASUS PRIME TRX40 PRO-S
Date:   Mon, 28 Dec 2020 13:49:07 +0100
Message-Id: <20201228125047.244418615@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 525d9c57d0eeeb660d9b25e5b2d1c95975e3ba95 upstream.

ASUS PRIME TRX40 PRO-S mobo with 0b05:1918 needs the same quirk alias
for another ASUS mobo (0b05:1917) for the proper mixer mapping, etc.
Add the corresponding entry.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=210783
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201221080159.24468-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/card.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -382,6 +382,9 @@ static const struct usb_audio_device_nam
 	/* ASUS ROG Strix */
 	PROFILE_NAME(0x0b05, 0x1917,
 		     "Realtek", "ALC1220-VB-DT", "Realtek-ALC1220-VB-Desktop"),
+	/* ASUS PRIME TRX40 PRO-S */
+	PROFILE_NAME(0x0b05, 0x1918,
+		     "Realtek", "ALC1220-VB-DT", "Realtek-ALC1220-VB-Desktop"),
 
 	/* Dell WD15 Dock */
 	PROFILE_NAME(0x0bda, 0x4014, "Dell", "WD15 Dock", "Dell-WD15-Dock"),


