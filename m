Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2B015787D
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:08:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729012AbgBJMjf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:39:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:37658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729446AbgBJMjf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:39:35 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 916F820661;
        Mon, 10 Feb 2020 12:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338374;
        bh=jS83w47p1mXqjnFe6p2467wdGU/BA9mLrI7pCQeZL54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TAjuNOY5/9aEfsV9CfFyjxFopicZTT1+zNs3KZPbvVUlRZjh3oostIgwMHjVeoEI9
         +0OuHB0x0dSEWDyVNiZYA2wcN/mht3/eXxthYgpwltWPS+/pinV82nNeL4F9ks/VeL
         eS5KQbf+DizEsAG2B1bzs71ct19Vent75FtSkVK0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roger Quadros <rogerq@ti.com>,
        Felipe Balbi <balbi@kernel.org>
Subject: [PATCH 5.5 048/367] usb: gadget: legacy: set max_speed to super-speed
Date:   Mon, 10 Feb 2020 04:29:21 -0800
Message-Id: <20200210122428.478442017@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roger Quadros <rogerq@ti.com>

commit 463f67aec2837f981b0a0ce8617721ff59685c00 upstream.

These interfaces do support super-speed so let's not
limit maximum speed to high-speed.

Cc: <stable@vger.kernel.org>
Signed-off-by: Roger Quadros <rogerq@ti.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/legacy/cdc2.c  |    2 +-
 drivers/usb/gadget/legacy/g_ffs.c |    2 +-
 drivers/usb/gadget/legacy/multi.c |    2 +-
 drivers/usb/gadget/legacy/ncm.c   |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/usb/gadget/legacy/cdc2.c
+++ b/drivers/usb/gadget/legacy/cdc2.c
@@ -225,7 +225,7 @@ static struct usb_composite_driver cdc_d
 	.name		= "g_cdc",
 	.dev		= &device_desc,
 	.strings	= dev_strings,
-	.max_speed	= USB_SPEED_HIGH,
+	.max_speed	= USB_SPEED_SUPER,
 	.bind		= cdc_bind,
 	.unbind		= cdc_unbind,
 };
--- a/drivers/usb/gadget/legacy/g_ffs.c
+++ b/drivers/usb/gadget/legacy/g_ffs.c
@@ -149,7 +149,7 @@ static struct usb_composite_driver gfs_d
 	.name		= DRIVER_NAME,
 	.dev		= &gfs_dev_desc,
 	.strings	= gfs_dev_strings,
-	.max_speed	= USB_SPEED_HIGH,
+	.max_speed	= USB_SPEED_SUPER,
 	.bind		= gfs_bind,
 	.unbind		= gfs_unbind,
 };
--- a/drivers/usb/gadget/legacy/multi.c
+++ b/drivers/usb/gadget/legacy/multi.c
@@ -482,7 +482,7 @@ static struct usb_composite_driver multi
 	.name		= "g_multi",
 	.dev		= &device_desc,
 	.strings	= dev_strings,
-	.max_speed	= USB_SPEED_HIGH,
+	.max_speed	= USB_SPEED_SUPER,
 	.bind		= multi_bind,
 	.unbind		= multi_unbind,
 	.needs_serial	= 1,
--- a/drivers/usb/gadget/legacy/ncm.c
+++ b/drivers/usb/gadget/legacy/ncm.c
@@ -197,7 +197,7 @@ static struct usb_composite_driver ncm_d
 	.name		= "g_ncm",
 	.dev		= &device_desc,
 	.strings	= dev_strings,
-	.max_speed	= USB_SPEED_HIGH,
+	.max_speed	= USB_SPEED_SUPER,
 	.bind		= gncm_bind,
 	.unbind		= gncm_unbind,
 };


