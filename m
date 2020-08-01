Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91C1B235303
	for <lists+stable@lfdr.de>; Sat,  1 Aug 2020 17:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbgHAPnu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Aug 2020 11:43:50 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:53529 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726432AbgHAPnt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 Aug 2020 11:43:49 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 9EDCD5C00F1;
        Sat,  1 Aug 2020 11:43:48 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sat, 01 Aug 2020 11:43:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm3; bh=138EtoiNOuOs5U9pvNEstgflm8
        9KYVe/SnhbzLU1en4=; b=tstKvIUfpsmzh0gGpUmBdP0HyLRht058hew7gfDAIL
        Jjziv9wUYZwBnjJieMiG410ZPi8X8ezjDeiUg/6FWh/YbFDyRrRIKQGoJ+V+6qEb
        /XEIC3eEdioqyv/3/JsL6kI2Pu2xfooCKNo/lc9JDi4JRU189J5WF+aYNh8JCOMD
        IJKLcuuRc1gzZq8JQE2hel5AeoyGQNClxE7ddqzHXKIVv3hLtevg8dofKt45gTE6
        7x7KqZ+JCaowChFuhFg4o9yuvn7tA2e7srgjmDMZ56poTqK/qMVKWHNOOqK+iFgY
        1XR2+d5VXJ+ob8Ct2gDzFcdPUBudJnDU51+ENEMQCreQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=138EtoiNOuOs5U9pv
        NEstgflm89KYVe/SnhbzLU1en4=; b=BSqHk3AglAwx1eCAHXsXsnVAterQ5JHci
        MheL7fAkktGuxj5Qrj3lYSJvNVQsqSIhbenqYAC/S9DHIz5RgoI8jGIv/IL08mUq
        Tk6e5YGW6/d9CohDdJU88KA4T4+bCC0VqgRq53hEi2vhkY9IOj4bc0ksjkAQSvS5
        qDCP7z2tW2MWjmLQe8/Q8T/n+hB6Ub+N3tC+AE9RsmUc/cZBGbdcfG0zUVusCHMb
        xVKSBfi7Y1ZfKKwUaJ0f5F0tEIULdcenIALXLGlMHmouN5Sy4bFcSdozSvSOv3FP
        d31ZySxN60jR/WGfBEMBnigGIvdeH6L+Zx+62obfZbMiN1EIlRfOw==
X-ME-Sender: <xms:tI0lX_rlZJwvCw475eDDZ3w_5CDrW4NpvadhQZGobq80AKCva-S5Hw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrjedtgdelfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgggfestdekredtredttdenucfhrhhomhepufgrmhhuvghlucfj
    ohhllhgrnhguuceoshgrmhhuvghlsehshhholhhlrghnugdrohhrgheqnecuggftrfgrth
    htvghrnhepieetkefhheduudfgledtudefjeejfeegveehkeeufffhhfejkeehiefftdev
    tdevnecukfhppeejtddrudefhedrudegkedrudehudenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehsrghmuhgvlhesshhhohhllhgrnhgurdho
    rhhg
X-ME-Proxy: <xmx:tI0lX5qjAlQaNm9D6H326U26FKL3wk9P35HvW-rCeMVfnalDHbf9DQ>
    <xmx:tI0lX8NcdHn7hVd7kSbNHe79ltstTIF5v7ffMGioVlj71pg9gGfciQ>
    <xmx:tI0lXy4diiTaXcIWw01bZ4xHUwg-_TG2y_SoY-BloqJtfXP8Babpkw>
    <xmx:tI0lX0n8gqnUXVdy-On7mbmiycoYYWIJb7IEAUhB7nZFSHFGDdhDpw>
Received: from titanium.stl.sholland.net (70-135-148-151.lightspeed.stlsmo.sbcglobal.net [70.135.148.151])
        by mail.messagingengine.com (Postfix) with ESMTPA id BFF1430600DC;
        Sat,  1 Aug 2020 11:43:47 -0400 (EDT)
From:   Samuel Holland <samuel@sholland.org>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Samuel Holland <samuel@sholland.org>, stable@vger.kernel.org
Subject: [PATCH 1/2] Bluetooth: hci_h5: Stop erroneously setting HCI_UART_REGISTERED
Date:   Sat,  1 Aug 2020 10:43:45 -0500
Message-Id: <20200801154346.63882-1-samuel@sholland.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This code attempts to set the HCI_UART_RESET_ON_INIT flag. However,
it sets the bit in the wrong flag word: HCI_UART_RESET_ON_INIT goes in
hu->hdev_flags, not hu->flags. So it is actually setting
HCI_UART_REGISTERED, which is bit 1 in hu->flags.

Since commit cba736465e5c ("Bluetooth: hci_serdev: Remove setting of
HCI_QUIRK_RESET_ON_CLOSE."), this flag is ignored for hci_serdev users,
so instead of fixing which flag is set, let's remove the flag entirely.

Cc: stable@vger.kernel.org
Fixes: ce945552fde4 ("Bluetooth: hci_h5: Add support for serdev enumerated devices")
Signed-off-by: Samuel Holland <samuel@sholland.org>
---
 drivers/bluetooth/hci_h5.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/bluetooth/hci_h5.c b/drivers/bluetooth/hci_h5.c
index e60b2e0773db..981d96cc7695 100644
--- a/drivers/bluetooth/hci_h5.c
+++ b/drivers/bluetooth/hci_h5.c
@@ -793,8 +793,6 @@ static int h5_serdev_probe(struct serdev_device *serdev)
 	if (!h5)
 		return -ENOMEM;
 
-	set_bit(HCI_UART_RESET_ON_INIT, &h5->serdev_hu.flags);
-
 	h5->hu = &h5->serdev_hu;
 	h5->serdev_hu.serdev = serdev;
 	serdev_device_set_drvdata(serdev, h5);
-- 
2.26.2

