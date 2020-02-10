Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05EF4157C56
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:36:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730257AbgBJNgh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:36:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:51524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727753AbgBJMfL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:35:11 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2CE3208C3;
        Mon, 10 Feb 2020 12:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338109;
        bh=jS83w47p1mXqjnFe6p2467wdGU/BA9mLrI7pCQeZL54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mEfSvonRvZova9xDHm9cdfQUZBSB40IBqzLquzKkfDlZn0DdVuUuS7ecg4TN9Vnp4
         y3/kmtJ3ZrqxEo3pykIDF8pxvT5/1Q79mRrn0hCDPeynSV8RolKdQ8Qi/rvNrPm8wV
         NiggCtmvs938cPP7UGpMYPPtzXbRuNuoSAWPXkP0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roger Quadros <rogerq@ti.com>,
        Felipe Balbi <balbi@kernel.org>
Subject: [PATCH 4.19 033/195] usb: gadget: legacy: set max_speed to super-speed
Date:   Mon, 10 Feb 2020 04:31:31 -0800
Message-Id: <20200210122309.808176252@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122305.731206734@linuxfoundation.org>
References: <20200210122305.731206734@linuxfoundation.org>
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


