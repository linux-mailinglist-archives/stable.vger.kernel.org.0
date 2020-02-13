Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3721315C684
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 17:12:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728874AbgBMQBY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 11:01:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:38702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728290AbgBMPYk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:24:40 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 687E0246B3;
        Thu, 13 Feb 2020 15:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607479;
        bh=SVhXEM5ip6DL8l6Fd0jQhEMKOcT/fCDb5xo5D0hWBBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BCcVU4BR+YTN8p+YX8EG+wWxbvohwFzNfRmX3+OtAnpc5KeFC4cVwxFm5j1kOZrXM
         3y8Jexj16xMM8udQnQcaSRqJgVoz0QszyGcqegjQMlYdD8sM2orzFnWaRYDMmmZRxY
         X6/o8KcysuE3TmIEnd5VfzZQ9MynIURpSFdxTTIk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roger Quadros <rogerq@ti.com>,
        Felipe Balbi <balbi@kernel.org>
Subject: [PATCH 4.14 022/173] usb: gadget: legacy: set max_speed to super-speed
Date:   Thu, 13 Feb 2020 07:18:45 -0800
Message-Id: <20200213151938.851892387@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151931.677980430@linuxfoundation.org>
References: <20200213151931.677980430@linuxfoundation.org>
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
@@ -229,7 +229,7 @@ static struct usb_composite_driver cdc_d
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
@@ -153,7 +153,7 @@ static struct usb_composite_driver gfs_d
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
@@ -486,7 +486,7 @@ static struct usb_composite_driver multi
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
@@ -203,7 +203,7 @@ static struct usb_composite_driver ncm_d
 	.name		= "g_ncm",
 	.dev		= &device_desc,
 	.strings	= dev_strings,
-	.max_speed	= USB_SPEED_HIGH,
+	.max_speed	= USB_SPEED_SUPER,
 	.bind		= gncm_bind,
 	.unbind		= gncm_unbind,
 };


