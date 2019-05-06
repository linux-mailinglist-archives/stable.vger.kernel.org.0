Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBB2314E9E
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbfEFOjT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:39:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:60662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727338AbfEFOjT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:39:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48E8520449;
        Mon,  6 May 2019 14:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153558;
        bh=xPgd8CVYn+3t6ofnELmtPXFoaRsTH3BBU/Jc8ysuAfo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lVuInk0dlGE33d6KZ/DcLOSwIs2Oyo1XySrrOgBz+gGaCwApXGpWPWVvxtnYflQIS
         K+M4HTlQkt6kbW+c0UkwHjqfI0FN5q/R/DpAa4fv9jB8L/1LMV+TIMCGrj5+49ETy1
         xL66UF04T0Z9JygUj+s4EyXEZhVe1vUdiG6DJN80=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 12/99] ALSA: hda/realtek - Apply the fixup for ASUS Q325UAR
Date:   Mon,  6 May 2019 16:31:45 +0200
Message-Id: <20190506143054.976217718@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143053.899356316@linuxfoundation.org>
References: <20190506143053.899356316@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 3887c26c0e24d50a4d0ce20cf4726737cee1a2fd upstream.

Some ASUS models like Q325UAR with ALC295 codec requires the same
fixup that has been applied to ALC294 codec.  Just copy the entry with
the pin matching to cover ALC295 too.

BugLink: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1784485
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7451,6 +7451,10 @@ static const struct snd_hda_pin_quirk al
 		{0x12, 0x90a60130},
 		{0x17, 0x90170110},
 		{0x21, 0x04211020}),
+	SND_HDA_PIN_QUIRK(0x10ec0295, 0x1043, "ASUS", ALC294_FIXUP_ASUS_SPK,
+		{0x12, 0x90a60130},
+		{0x17, 0x90170110},
+		{0x21, 0x03211020}),
 	SND_HDA_PIN_QUIRK(0x10ec0295, 0x1028, "Dell", ALC269_FIXUP_DELL1_MIC_NO_PRESENCE,
 		{0x14, 0x90170110},
 		{0x21, 0x04211020}),


