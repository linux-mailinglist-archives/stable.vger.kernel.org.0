Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CCAA259A7D
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732302AbgIAQuT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:50:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:52170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727931AbgIAP03 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:26:29 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2AD6D2078B;
        Tue,  1 Sep 2020 15:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973988;
        bh=fRMoqr4/w2YvC2L0ERB/A4WVkG0CZBpH9dm1ycTIcfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HXcFF2HcgAOt6ErPCJhos8UXG5ebs1jDfaD0GS70FR3KESiPYv3HS8p3i0ohet7X8
         nzeBJJrTxqEDL4JXToIqM3jYhe6+JZh8HLvMBAiis9EYx+IioREI0fCpvIjORDMNag
         iELPZoy4+yN3lXOPoJwjaxEcEzVueO2uv1L5TasE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hector Martin <marcan@marcan.st>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 125/125] ALSA: usb-audio: Update documentation comment for MS2109 quirk
Date:   Tue,  1 Sep 2020 17:11:20 +0200
Message-Id: <20200901150940.730505107@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150934.576210879@linuxfoundation.org>
References: <20200901150934.576210879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hector Martin <marcan@marcan.st>

commit 74a2a7de81a2ef20732ec02087314e92692a7a1b upstream.

As the recent fix addressed the channel swap problem more properly,
update the comment as well.

Fixes: 1b7ecc241a67 ("ALSA: usb-audio: work around streaming quirk for MacroSilicon MS2109")
Signed-off-by: Hector Martin <marcan@marcan.st>
Link: https://lore.kernel.org/r/20200816084431.102151-1-marcan@marcan.st
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/quirks-table.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -3524,8 +3524,8 @@ ALC1220_VB_DESKTOP(0x26ce, 0x0a01), /* A
  * they pretend to be 96kHz mono as a workaround for stereo being broken
  * by that...
  *
- * They also have swapped L-R channels, but that's for userspace to deal
- * with.
+ * They also have an issue with initial stream alignment that causes the
+ * channels to be swapped and out of phase, which is dealt with in quirks.c.
  */
 {
 	.match_flags = USB_DEVICE_ID_MATCH_DEVICE |


