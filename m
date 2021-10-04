Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B06B9420C1D
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234635AbhJDNCq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:02:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:32806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234633AbhJDNBP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:01:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04FC961528;
        Mon,  4 Oct 2021 12:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352309;
        bh=mnkJT49VvAXRSAQkoctsO9IGjbbCIfgmocQyrYppJV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IVPWavMu5iy5L/csNWMm5+dJFDRBDgqihM1gSm8Mr+N3IGEUUqGvGVmwT+WI8I6fo
         pidta8cAuSgJU7EcCKBmwkA8RDIdDGVsbP6y/T4vVDovw2sz6QsaAZaceafpsTG3RU
         ALVZ+2EWepus7WEgyjx+MsU4+fMJL+8XC7wUO1Hs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.14 12/75] USB: serial: option: remove duplicate USB device ID
Date:   Mon,  4 Oct 2021 14:51:47 +0200
Message-Id: <20211004125031.948999085@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125031.530773667@linuxfoundation.org>
References: <20211004125031.530773667@linuxfoundation.org>
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
@@ -1661,7 +1661,6 @@ static const struct usb_device_id option
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0060, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0070, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0073, 0xff, 0xff, 0xff) },
-	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0094, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0130, 0xff, 0xff, 0xff),
 	  .driver_info = RSVD(1) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0133, 0xff, 0xff, 0xff),


