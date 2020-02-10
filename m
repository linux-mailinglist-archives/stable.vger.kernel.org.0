Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 379DC157BE1
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:33:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728041AbgBJNdM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:33:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:52932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728039AbgBJMfi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:35:38 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7561720661;
        Mon, 10 Feb 2020 12:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338137;
        bh=pLBrPPaQS2GhopK8qUIU8hGxqYRmdITki044AIYuEj4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wxap7g+MM9lR36eT6lvREFunNikwnsMFnQtocelSvz2oklIfrWYN23i9T8l4Umogt
         wAGtZaQ3VW4BWrvo3h17ePrJjJd2Vqj9CsNam/hFnzs4/mHe5gtNOskduq0J+OS8XS
         ZAfPHJ1fC0ZIcnvzgFZ3cKAPm8WYFLDGkEyWrrlc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 046/195] ALSA: hda: Add Clevo W65_67SB the power_save blacklist
Date:   Mon, 10 Feb 2020 04:31:44 -0800
Message-Id: <20200210122310.665367415@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122305.731206734@linuxfoundation.org>
References: <20200210122305.731206734@linuxfoundation.org>
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
@@ -2324,6 +2324,8 @@ static struct snd_pci_quirk power_save_b
 	/* https://bugzilla.redhat.com/show_bug.cgi?id=1581607 */
 	SND_PCI_QUIRK(0x1558, 0x3501, "Clevo W35xSS_370SS", 0),
 	/* https://bugzilla.redhat.com/show_bug.cgi?id=1525104 */
+	SND_PCI_QUIRK(0x1558, 0x6504, "Clevo W65_67SB", 0),
+	/* https://bugzilla.redhat.com/show_bug.cgi?id=1525104 */
 	SND_PCI_QUIRK(0x1028, 0x0497, "Dell Precision T3600", 0),
 	/* https://bugzilla.redhat.com/show_bug.cgi?id=1525104 */
 	/* Note the P55A-UD3 and Z87-D3HP share the subsys id for the HDA dev */


