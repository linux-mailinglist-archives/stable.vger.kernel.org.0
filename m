Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41AFA452515
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:43:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343949AbhKPBqm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:46:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:36756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237648AbhKOSZn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:25:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4BA6E6342C;
        Mon, 15 Nov 2021 17:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998959;
        bh=BtdU/AhAQVKVAJVxlY/pIFBd6/zN2jJdWZx6fDtfBBw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TwktU57XjSzXbrb4ERf68nxmXMvHezTCd0e7kGYmrYhpD0SXdL4HXDs/QJTTEcsB6
         AgiBDXbUGCJoh5GoH8xmKhthz2LgFhHzelOP2QSZpkBc8UCc7EfXAKcxlEQBj4xTna
         No5i5c8R7HILuSPuX4G8CkNsx77UV4FEkWhm4ekc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maximilian Luz <luzmaximilian@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.14 124/849] HID: surface-hid: Allow driver matching for target ID 1 devices
Date:   Mon, 15 Nov 2021 17:53:27 +0100
Message-Id: <20211115165424.289838259@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maximilian Luz <luzmaximilian@gmail.com>

commit ab5fe33925c6b03f646a1153771dab047548e4d8 upstream.

Until now we have only ever seen HID devices with target ID 2. The new
Surface Laptop Studio however uses HID devices with target ID 1. Allow
matching this driver to those as well.

Cc: stable@vger.kernel.org # 5.14+
Signed-off-by: Maximilian Luz <luzmaximilian@gmail.com>
Acked-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Link: https://lore.kernel.org/r/20211021130904.862610-4-luzmaximilian@gmail.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/surface-hid/surface_hid.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hid/surface-hid/surface_hid.c
+++ b/drivers/hid/surface-hid/surface_hid.c
@@ -230,7 +230,7 @@ static void surface_hid_remove(struct ss
 }
 
 static const struct ssam_device_id surface_hid_match[] = {
-	{ SSAM_SDEV(HID, 0x02, SSAM_ANY_IID, 0x00) },
+	{ SSAM_SDEV(HID, SSAM_ANY_TID, SSAM_ANY_IID, 0x00) },
 	{ },
 };
 MODULE_DEVICE_TABLE(ssam, surface_hid_match);


