Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 582FB122043
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 01:56:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727576AbfLQAxe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 19:53:34 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35368 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727076AbfLQAvo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:44 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15L-0003NI-0i; Tue, 17 Dec 2019 00:51:35 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15J-0005aV-6Y; Tue, 17 Dec 2019 00:51:33 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Takashi Sakamoto" <o-takashi@sakamocchi.jp>,
        "Takashi Iwai" <tiwai@suse.de>
Date:   Tue, 17 Dec 2019 00:47:07 +0000
Message-ID: <lsq.1576543535.51536194@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 093/136] ALSA: bebob: Fix prototype of helper
 function to return negative value
In-Reply-To: <lsq.1576543534.33060804@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.80-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

commit f2bbdbcb075f3977a53da3bdcb7cd460bc8ae5f2 upstream.

A helper function of ALSA bebob driver returns negative value in a
function which has a prototype to return unsigned value.

This commit fixes it by changing the prototype.

Fixes: eb7b3a056cd8 ("ALSA: bebob: Add commands and connections/streams management")
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Link: https://lore.kernel.org/r/20191026030620.12077-1-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/firewire/bebob/bebob_stream.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/sound/firewire/bebob/bebob_stream.c
+++ b/sound/firewire/bebob/bebob_stream.c
@@ -196,8 +196,7 @@ end:
 	return err;
 }
 
-static unsigned int
-map_data_channels(struct snd_bebob *bebob, struct amdtp_stream *s)
+static int map_data_channels(struct snd_bebob *bebob, struct amdtp_stream *s)
 {
 	unsigned int sec, sections, ch, channels;
 	unsigned int pcm, midi, location;

