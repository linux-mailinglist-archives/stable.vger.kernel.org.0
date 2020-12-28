Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13EBF2E37BC
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:01:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729247AbgL1M7n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 07:59:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:55980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729189AbgL1M7m (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 07:59:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59DC5208B6;
        Mon, 28 Dec 2020 12:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160341;
        bh=WaveH1Q9AVRFJF+yNl25odc0yleqi42jKABjuKowRTk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z8ZRzG6v66bCMTzPdJRkliQs3NlYmdA0QyO06vFNHg3+/a1yr7KkPAMZTXZVjCjZn
         2HybkfRxN/jjHqE2NvVprE2rvjj7ogxQ57Tj3ybzz2gGXYTsq5Pz5xAvC6RScSQByL
         0OU1uOfR+a2wppdfUPrYKy8+UEcbYRNSNfmTOEE8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 4.9 019/175] USB: add RESET_RESUME quirk for Snapscan 1212
Date:   Mon, 28 Dec 2020 13:47:52 +0100
Message-Id: <20201228124854.187260199@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
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
@@ -189,6 +189,9 @@ static const struct usb_device_id usb_qu
 	{ USB_DEVICE(0x06a3, 0x0006), .driver_info =
 			USB_QUIRK_CONFIG_INTF_STRINGS },
 
+	/* Agfa SNAPSCAN 1212U */
+	{ USB_DEVICE(0x06bd, 0x0001), .driver_info = USB_QUIRK_RESET_RESUME },
+
 	/* Guillemot Webcam Hercules Dualpix Exchange (2nd ID) */
 	{ USB_DEVICE(0x06f8, 0x0804), .driver_info = USB_QUIRK_RESET_RESUME },
 


