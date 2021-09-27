Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE5234199F9
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235883AbhI0RFy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:05:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:44402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235838AbhI0RFi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:05:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 632C36109F;
        Mon, 27 Sep 2021 17:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762239;
        bh=J2lFQRkZ3VNG8KWYoO99vskLL4IvJPJ40iwrcC1nPF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tzDOwPyIeHvmOkIZNz9JY39nGuXA6oHbnnSeEqTbaIFYfXCnBXBiQgG596+hF6D9T
         kWNcJMwcx6fGGzmjv9x7++8OmUsnFKEYl+EAHs5cuZFAa+lO7eDjM8a6znXfH/eux2
         Z9W2GSNwmTvwsixQDu+CfpaBxOXUVFRcG+jB0p5w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.4 15/68] USB: serial: mos7840: remove duplicated 0xac24 device ID
Date:   Mon, 27 Sep 2021 19:02:11 +0200
Message-Id: <20210927170220.469852390@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170219.901812470@linuxfoundation.org>
References: <20210927170219.901812470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

commit 211f323768a25b30c106fd38f15a0f62c7c2b5f4 upstream.

0xac24 device ID is already defined and used via
BANDB_DEVICE_ID_USO9ML2_4.  Remove the duplicate from the list.

Fixes: 27f1281d5f72 ("USB: serial: Extra device/vendor ID for mos7840 driver")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/mos7840.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -114,7 +114,6 @@
 #define BANDB_DEVICE_ID_USOPTL4_2P       0xBC02
 #define BANDB_DEVICE_ID_USOPTL4_4        0xAC44
 #define BANDB_DEVICE_ID_USOPTL4_4P       0xBC03
-#define BANDB_DEVICE_ID_USOPTL2_4        0xAC24
 
 /* This driver also supports
  * ATEN UC2324 device using Moschip MCS7840
@@ -196,7 +195,6 @@ static const struct usb_device_id id_tab
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL4_2P)},
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL4_4)},
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL4_4P)},
-	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL2_4)},
 	{USB_DEVICE(USB_VENDOR_ID_ATENINTL, ATENINTL_DEVICE_ID_UC2324)},
 	{USB_DEVICE(USB_VENDOR_ID_ATENINTL, ATENINTL_DEVICE_ID_UC2322)},
 	{USB_DEVICE(USB_VENDOR_ID_MOXA, MOXA_DEVICE_ID_2210)},


