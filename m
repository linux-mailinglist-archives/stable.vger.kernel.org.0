Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9380D15780C
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:05:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729461AbgBJNEl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:04:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:39698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729654AbgBJMkN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:40:13 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85BEC20838;
        Mon, 10 Feb 2020 12:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338411;
        bh=0HoyKO07B0flucA91DLoS4VCK644iMhiylh9+BkIANw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YZ+DHyq+z0w2P8E521vSy8tM3IQK35lWLJnSGIJp9DRqtPDvSFY1Jb4BA8LCG4KP6
         fwgoGtv/c3P5c3tbpCEjb7T2uk3rH4kEaX+WPoVmCxMBbUD8R7U67dvTFcwcuBiqRB
         zIobWM4O44xyKMs0H/Ri+LNPuJ8Gj1zUxAonefSM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.5 069/367] ALSA: hda: Add Clevo W65_67SB the power_save blacklist
Date:   Mon, 10 Feb 2020 04:29:42 -0800
Message-Id: <20200210122430.486167177@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit d8feb6080bb0c9f4d799a423d9453048fdd06990 upstream.

Using HDA power-saving on the Clevo W65_67SB causes the first 0.5
seconds of audio to be missing every time audio starts playing.

This commit adds the Clevo W65_67SB the power_save blacklist to avoid
this issue.

Cc: stable@vger.kernel.org
BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1525104
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20200125181021.70446-1-hdegoede@redhat.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_intel.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2188,6 +2188,8 @@ static struct snd_pci_quirk power_save_b
 	/* https://bugzilla.redhat.com/show_bug.cgi?id=1581607 */
 	SND_PCI_QUIRK(0x1558, 0x3501, "Clevo W35xSS_370SS", 0),
 	/* https://bugzilla.redhat.com/show_bug.cgi?id=1525104 */
+	SND_PCI_QUIRK(0x1558, 0x6504, "Clevo W65_67SB", 0),
+	/* https://bugzilla.redhat.com/show_bug.cgi?id=1525104 */
 	SND_PCI_QUIRK(0x1028, 0x0497, "Dell Precision T3600", 0),
 	/* https://bugzilla.redhat.com/show_bug.cgi?id=1525104 */
 	/* Note the P55A-UD3 and Z87-D3HP share the subsys id for the HDA dev */


