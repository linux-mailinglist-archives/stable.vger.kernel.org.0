Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1940C420B5E
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 14:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233472AbhJDM4w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 08:56:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:58088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233465AbhJDM4g (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 08:56:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F04661381;
        Mon,  4 Oct 2021 12:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352087;
        bh=IPcfNl2ejP4tASh88d7qhUQZkOs/+1oLKrRjIEv6kiU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j20emtGSgAeywu16BbloLl3NKhoC4NwiUUVM8De3UxiM1OUv1kliA/EP+hMyNQyhM
         0bH6U7r8rTM2IJBbmJEVA0fUeRA01nGMGz8yTUpe5QzavV+8uOu7heuaJYByCAv81U
         fcZ5DY9BOdtbG8hvqEGzAYs7cn6ZK7rQiqboSuZk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.4 08/41] USB: serial: option: remove duplicate USB device ID
Date:   Mon,  4 Oct 2021 14:51:59 +0200
Message-Id: <20211004125026.856201991@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125026.597501645@linuxfoundation.org>
References: <20211004125026.597501645@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

commit 1ca200a8c6f079950a04ea3c3380fe8cf78e95a2 upstream.

The device ZTE 0x0094 is already on the list.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Fixes: b9e44fe5ecda ("USB: option: cleanup zte 3g-dongle's pid in option.c")
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1640,7 +1640,6 @@ static const struct usb_device_id option
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0060, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0070, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0073, 0xff, 0xff, 0xff) },
-	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0094, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0130, 0xff, 0xff, 0xff),
 	  .driver_info = RSVD(1) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0133, 0xff, 0xff, 0xff),


