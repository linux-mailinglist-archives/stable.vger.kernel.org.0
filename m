Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73C87EEF65
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:21:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730199AbfKDV6J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 16:58:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:54926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730217AbfKDV6I (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:58:08 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 734F2217F4;
        Mon,  4 Nov 2019 21:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904687;
        bh=kjo9ICuQPkhOav4Yl9dBwJDDgT/2AfUsxxAO5HKP1Sg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QbKw3EJCh2IF/CdtEUgV0AU6zGEiDnjfB6wy50RB1iFg6DxqTYnkb9Y2L1/+a57ue
         bsP1ogjDMMOuibBjQzAzesU8aZez3Y99gDH/WiihS38tAoha87++K61rqQfF0ooKNW
         1g6HQfXU7k2N6VN4sRLtq3WbMOfehUxILY8P9lIQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, NOGUCHI Hiroshi <drvlabo@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 033/149] HID: Add ASUS T100CHI keyboard dock battery quirks
Date:   Mon,  4 Nov 2019 22:43:46 +0100
Message-Id: <20191104212138.116388277@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212126.090054740@linuxfoundation.org>
References: <20191104212126.090054740@linuxfoundation.org>
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
index d988b92b20c82..01bed2f6862ee 100644
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



