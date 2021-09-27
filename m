Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84987419AB8
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236546AbhI0RLs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:11:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:47542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236307AbhI0RJq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:09:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54FD96113A;
        Mon, 27 Sep 2021 17:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762453;
        bh=f91TnhFd8ef1ubRJrXJUlfDGZkPjpb5piUcuIZ7W6ho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pne2qU42pQTb0o097/PWx1c1f/fKiVhXeBveyeGPicX+gHxxXGOBBmkX7b5JHHrjn
         yV9XRLNn8U/QglcjuTI68WwcbwdeM11M5XpQhiZ7wxhU7ZS8ExyO7yuxmoGrB0Ek80
         B6usFTK+XvqQN8R2bw4rVGAapLaMlObOUQtpOJms=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 021/103] USB: serial: option: remove duplicate USB device ID
Date:   Mon, 27 Sep 2021 19:01:53 +0200
Message-Id: <20210927170226.448470394@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170225.702078779@linuxfoundation.org>
References: <20210927170225.702078779@linuxfoundation.org>
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
@@ -1658,7 +1658,6 @@ static const struct usb_device_id option
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0060, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0070, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0073, 0xff, 0xff, 0xff) },
-	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0094, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0130, 0xff, 0xff, 0xff),
 	  .driver_info = RSVD(1) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0133, 0xff, 0xff, 0xff),


