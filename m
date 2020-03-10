Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00E6917FC22
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731278AbgCJNJr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:09:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:57048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730929AbgCJNJr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:09:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64E4E20873;
        Tue, 10 Mar 2020 13:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845786;
        bh=Vn8MA2JWAlQXOEu/9651uZO4QlqIhBvCV5/tHIIYK8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B7YgwhPKFEKsLJVJIK90lkeCU7n6kFovaOyX6YLVRIB3lWN+YqDYHRGzAvMoV0GQo
         /8ytFK0Zn1RT9ejq9F94ITHFeUb9A1J0vkTLbQH6Vob7BcEM05sUPUqAGYvNjk/3CB
         RWyKA5LCxQ9BBwVHalfx3Qp41LdcGmzyFokxYBvE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Lazewatsky <dlaz@chromium.org>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: [PATCH 4.14 093/126] usb: quirks: add NO_LPM quirk for Logitech Screen Share
Date:   Tue, 10 Mar 2020 13:41:54 +0100
Message-Id: <20200310124209.700570979@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310124203.704193207@linuxfoundation.org>
References: <20200310124203.704193207@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Lazewatsky <dlaz@chromium.org>

commit b96ed52d781a2026d0c0daa5787c6f3d45415862 upstream.

LPM on the device appears to cause xHCI host controllers to claim
that there isn't enough bandwidth to support additional devices.

Signed-off-by: Dan Lazewatsky <dlaz@chromium.org>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
Link: https://lore.kernel.org/r/20200226143438.1445-1-gustavo.padovan@collabora.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -86,6 +86,9 @@ static const struct usb_device_id usb_qu
 	/* Logitech PTZ Pro Camera */
 	{ USB_DEVICE(0x046d, 0x0853), .driver_info = USB_QUIRK_DELAY_INIT },
 
+	/* Logitech Screen Share */
+	{ USB_DEVICE(0x046d, 0x086c), .driver_info = USB_QUIRK_NO_LPM },
+
 	/* Logitech Quickcam Fusion */
 	{ USB_DEVICE(0x046d, 0x08c1), .driver_info = USB_QUIRK_RESET_RESUME },
 


