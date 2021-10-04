Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8630420C17
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234578AbhJDNCf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:02:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:60936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234591AbhJDNBJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:01:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4EB161A08;
        Mon,  4 Oct 2021 12:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352304;
        bh=780dyysR3rOK5VjuRacIsg7c1xyCT69xdp13r16mHd4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z8DQ9SCNvi2kHmKXwjRoU7XvfLGUzHcF7ggvYE0taiQjetBrG1WEMnL4Bea76ucuS
         Ip8r5ATMMnao6TfMTP/LHJzZnztZ0FNI0SbgI5CzuucW1KYn4OhuWpDWi10LuBlNcS
         jnGx9x5rAywGDJwnkFLIm4VDCUEntXCRuqh1eHps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.14 10/75] USB: serial: mos7840: remove duplicated 0xac24 device ID
Date:   Mon,  4 Oct 2021 14:51:45 +0200
Message-Id: <20211004125031.878400383@linuxfoundation.org>
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
@@ -126,7 +126,6 @@
 #define BANDB_DEVICE_ID_USOPTL4_2P       0xBC02
 #define BANDB_DEVICE_ID_USOPTL4_4        0xAC44
 #define BANDB_DEVICE_ID_USOPTL4_4P       0xBC03
-#define BANDB_DEVICE_ID_USOPTL2_4        0xAC24
 
 /* This driver also supports
  * ATEN UC2324 device using Moschip MCS7840
@@ -207,7 +206,6 @@ static const struct usb_device_id id_tab
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL4_2P)},
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL4_4)},
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL4_4P)},
-	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL2_4)},
 	{USB_DEVICE(USB_VENDOR_ID_ATENINTL, ATENINTL_DEVICE_ID_UC2324)},
 	{USB_DEVICE(USB_VENDOR_ID_ATENINTL, ATENINTL_DEVICE_ID_UC2322)},
 	{USB_DEVICE(USB_VENDOR_ID_MOXA, MOXA_DEVICE_ID_2210)},


