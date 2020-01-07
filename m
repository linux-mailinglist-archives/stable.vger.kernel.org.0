Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 388F21333DF
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:22:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbgAGVCe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:02:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:42468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728251AbgAGVCd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:02:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08796214D8;
        Tue,  7 Jan 2020 21:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430952;
        bh=yc4EOZPFPEzXA/VNN41oGWVR1ukZwqiYOdknVIsvHE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zypG9naqW7o39zJ1eivPDjxk5SYYZWZzjopGWIKCy83gS1DL+WKhLpFLWoHT2+XXO
         qUvrI+Be2E+CdLA0UMY8fX9YkGjbUOyK3LbbC7rQUsvsi7UJE7laxghAR0W6EHr15E
         vwtnMGcktMMAHf0SjHuj5kDJMUdFmEjQh4NxCqkI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 127/191] ALSA: firewire-motu: Correct a typo in the clock proc string
Date:   Tue,  7 Jan 2020 21:54:07 +0100
Message-Id: <20200107205339.773019672@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 0929249e3be3bb82ee6cfec0025f4dde952210b3 upstream.

Just fix a typo of "S/PDIF" in the clock name string.

Fixes: 4638ec6ede08 ("ALSA: firewire-motu: add proc node to show current statuc of clock and packet formats")
Acked-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Link: https://lore.kernel.org/r/20191030100921.3826-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/firewire/motu/motu-proc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/firewire/motu/motu-proc.c
+++ b/sound/firewire/motu/motu-proc.c
@@ -16,7 +16,7 @@ static const char *const clock_names[] =
 	[SND_MOTU_CLOCK_SOURCE_SPDIF_ON_OPT] = "S/PDIF on optical interface",
 	[SND_MOTU_CLOCK_SOURCE_SPDIF_ON_OPT_A] = "S/PDIF on optical interface A",
 	[SND_MOTU_CLOCK_SOURCE_SPDIF_ON_OPT_B] = "S/PDIF on optical interface B",
-	[SND_MOTU_CLOCK_SOURCE_SPDIF_ON_COAX] = "S/PCIF on coaxial interface",
+	[SND_MOTU_CLOCK_SOURCE_SPDIF_ON_COAX] = "S/PDIF on coaxial interface",
 	[SND_MOTU_CLOCK_SOURCE_AESEBU_ON_XLR] = "AESEBU on XLR interface",
 	[SND_MOTU_CLOCK_SOURCE_WORD_ON_BNC] = "Word clock on BNC interface",
 };


