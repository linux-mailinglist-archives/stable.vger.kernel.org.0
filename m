Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB6BE310E61
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 18:14:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbhBEP2v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 10:28:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232930AbhBEP1Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Feb 2021 10:27:16 -0500
X-Greylist: delayed 4284 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 05 Feb 2021 09:08:51 PST
Received: from mail.archlinux.org (mail.archlinux.org [IPv6:2a01:4f9:c010:3052::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D8E7C06178B
        for <stable@vger.kernel.org>; Fri,  5 Feb 2021 09:08:50 -0800 (PST)
Received: from localhost.localdomain (unknown [IPv6:2001:8a0:f24a:dd00:4cf5:7496:69c2:e329])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: ffy00)
        by mail.archlinux.org (Postfix) with ESMTPSA id D2E023C7995;
        Fri,  5 Feb 2021 14:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=archlinux.org;
        s=dkim-rsa; t=1612535704;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=NwiCsqnWonTULORaJqBJaMJZsYnHgHIEPKkCuvvEAZ4=;
        b=mQWT80szYfzewHP7IgXmYw7rd1Cj/3AhJpdefjHNrQXSQCAjczwQbsc8SnDE82Kim5xvnB
        opmGgULSPM/i/WBzdxPC3bs8P22QMLHT4NpN/RMaogbZQ7//VxBLxjvribPW5Q/fbJHkmX
        QX+qBOs5sTZ8Z0INcH1ghXPmDxUDlSM3njCWQ9KzA4eRNCmVZHHbWnxAarOsei2hrfs5BO
        8ZpI91za80iqD3h4c7xOdbEFpeSQel4Fvh6PJxEhX6VoSdo4xUXDYbAIKpHaSy+ChPlkxn
        yvnspLOiLK5UvmdZfwTOQlQ1wrU631EA8RZdm9YnMnYCA++aYfp6tfQukAapau8XMG8X/O
        Zl6jfDT9DlxbpQYJfTuueW7HtQYGPIKSwOijtLBxl0jrvXZrZz5y4UeKve7OSzAIpX/T85
        70Nred3ga3X2EzfLhj5+AKNv62TzhqjG7aiv5mVPsSxy1lq4B1H5H0mwN0ji9F2/+xxIWq
        2mWGvG0Ca/CWFPqdETbJmq5Xep3icpbeFxy89zD+ABmTX8UN3yPmoMyHQ4K+686UxZ8r+2
        bxSHOfHQAM9Qdy4EmIGDkUrdGPNMAS56jPrVyfeTGHKQBaWTERjwExd4qomlOzsdUJqHOf
        9f+9Vj/5tkmdp4ri4r4+yhkN4IOeHDgWjDnOvX+Y7GyCEAm5iGCI8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=archlinux.org;
        s=dkim-ed25519; t=1612535704;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=NwiCsqnWonTULORaJqBJaMJZsYnHgHIEPKkCuvvEAZ4=;
        b=AQJk+8TjWsZ35Cg8iEdUxvHDXHCFP8rg2j2n8egJSjp5KoqWyumUGZcrQvwkxtP6LCGz8j
        /ODgjUrXgljjXKBg==
From:   =?UTF-8?q?Filipe=20La=C3=ADns?= <lains@archlinux.org>
To:     Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?Filipe=20La=C3=ADns?= <lains@riseup.net>,
        stable@vger.kernel.org
Subject: [PATCH v2] HID: logitech-dj: add support for keyboard events in eQUAD step 4 Gaming
Date:   Fri,  5 Feb 2021 14:34:44 +0000
Message-Id: <20210205143444.1155367-1-lains@archlinux.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Authentication-Results: mail.archlinux.org;
        auth=pass smtp.auth=ffy00 smtp.mailfrom=lains@archlinux.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Laíns <lains@riseup.net>

In e400071a805d6229223a98899e9da8c6233704a1 I added support for the
receiver that comes with the G602 device, but unfortunately I screwed up
during testing and it seems the keyboard events were actually not being
sent to userspace.
This resulted in keyboard events being broken in userspace, please
backport the fix.

The receiver uses the normal 0x01 Logitech keyboard report descriptor,
as expected, so it is just a matter of flagging it as supported.

Reported in
https://github.com/libratbag/libratbag/issues/1124

Fixes: e400071a805d6 ("HID: logitech-dj: add the G602 receiver")
Cc: <stable@vger.kernel.org>
Signed-off-by: Filipe Laíns <lains@riseup.net>
---

Changes in v2:
- added missing Fixes: anc Cc: tags

 drivers/hid/hid-logitech-dj.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
index 6596c81947a8..2703333edc34 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -981,6 +981,7 @@ static void logi_hidpp_recv_queue_notif(struct hid_device *hdev,
 	case 0x07:
 		device_type = "eQUAD step 4 Gaming";
 		logi_hidpp_dev_conn_notif_equad(hdev, hidpp_report, &workitem);
+		workitem.reports_supported |= STD_KEYBOARD;
 		break;
 	case 0x08:
 		device_type = "eQUAD step 4 for gamepads";
-- 
2.30.0

