Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A18C72E6669
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:14:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404075AbgL1QMS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:12:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:50062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387978AbgL1NVa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:21:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04A9622583;
        Mon, 28 Dec 2020 13:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161649;
        bh=JcsOVXdQSie53vVBDl8MrXzt8QPauUVbSSYASOo68Ek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BWs0XCThokn0q2gcL0nV3isNVpQkOv2WagzZkyd3xasy81ms/GCW5qbYtlQ03QguE
         Mhq/EcHLHywnCRi/bG2qc4hmCdfj2srNUWje4iQAeX/9gb2bdSXyYP/lYU77wBwBQo
         Xst93IMC838DYmrcSINSh2nbyHRabB/7EpOWYiZw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 4.19 040/346] USB: add RESET_RESUME quirk for Snapscan 1212
Date:   Mon, 28 Dec 2020 13:45:59 +0100
Message-Id: <20201228124921.724077445@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

commit 08a02f954b0def3ada8ed6d4b2c7bcb67e885e9c upstream.

I got reports that some models of this old scanner need
this when using runtime PM.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201207130323.23857-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -342,6 +342,9 @@ static const struct usb_device_id usb_qu
 	{ USB_DEVICE(0x06a3, 0x0006), .driver_info =
 			USB_QUIRK_CONFIG_INTF_STRINGS },
 
+	/* Agfa SNAPSCAN 1212U */
+	{ USB_DEVICE(0x06bd, 0x0001), .driver_info = USB_QUIRK_RESET_RESUME },
+
 	/* Guillemot Webcam Hercules Dualpix Exchange (2nd ID) */
 	{ USB_DEVICE(0x06f8, 0x0804), .driver_info = USB_QUIRK_RESET_RESUME },
 


