Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE5A8EEFFA
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:25:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388285AbfKDWYs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:24:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:45904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730727AbfKDVw0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:52:26 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8963A218BA;
        Mon,  4 Nov 2019 21:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904346;
        bh=pmfg6LHYW/5retXYbGcvyYYHCQHShynOoxt3PYSYyg8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wqdsb7fFlEUefPTDZln27eI8Z1tiCmxQT5eF5ZufymvOKoPHHdqpk+rb14qkj+bcg
         Wv4a8QG+UhFWD57MzjFS1UZriHVIzTLCEPhMHY0UOOoHQ+ozwXVC1MVqROT1s12OyN
         +3B5xpbR7xT2fTBA+Ir7cJqi1zp25dlKMJo+RAfc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, NOGUCHI Hiroshi <drvlabo@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 15/95] HID: Add ASUS T100CHI keyboard dock battery quirks
Date:   Mon,  4 Nov 2019 22:44:13 +0100
Message-Id: <20191104212045.008895309@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212038.056365853@linuxfoundation.org>
References: <20191104212038.056365853@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: NOGUCHI Hiroshi <drvlabo@gmail.com>

[ Upstream commit a767ffea05d2737f6542cd78458a84a157fa216d ]

Add ASUS Transbook T100CHI/T90CHI keyboard dock into battery quirk list, in
order to add specific implementation in hid-asus.

Signed-off-by: NOGUCHI Hiroshi <drvlabo@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-input.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index d723185de3ba2..9d24fb0715ba3 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -328,6 +328,9 @@ static const struct hid_device_id hid_battery_quirks[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SYMBOL,
 		USB_DEVICE_ID_SYMBOL_SCANNER_3),
 	  HID_BATTERY_QUIRK_IGNORE },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_ASUSTEK,
+		USB_DEVICE_ID_ASUSTEK_T100CHI_KEYBOARD),
+	  HID_BATTERY_QUIRK_IGNORE },
 	{}
 };
 
-- 
2.20.1



