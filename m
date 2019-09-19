Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 641AEB8698
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404641AbfISWQG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:16:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:56292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406259AbfISWQF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:16:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72CBE218AF;
        Thu, 19 Sep 2019 22:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931365;
        bh=w0mXBtSUrIzsdWESWOJCWbodkrbx6BxZ6vrtYietXXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s69kvgXa4MJVv7MsQROrpTF+LYgJNJMg+KmDWVJ9USm2GHauqsDWosuw2fCTUdpdZ
         027i0QU/qZ4CR08/Lmjfv5qCqZ/BeN+nm5/3UEEUllGx+/O1Wzp9DcZ4KsW/9Wl4ED
         rf/6W0PikEqxhuXv5yNGb/M+pSxQByHPrRMDXE9w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 4.14 02/59] Input: elan_i2c - remove Lenovo Legion Y7000 PnpID
Date:   Fri, 20 Sep 2019 00:03:17 +0200
Message-Id: <20190919214756.510013600@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214755.852282682@linuxfoundation.org>
References: <20190919214755.852282682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Tissoires <benjamin.tissoires@redhat.com>

commit 0c043d70d04711fe6c380df9065fdc44192c49bf upstream.

Looks like the Bios of the Lenovo Legion Y7000 is using ELAN061B
when the actual device is supposed to be used with hid-multitouch.

Remove it from the list of the supported device, hoping that
no one will complain about the loss in functionality.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=203467
Fixes: 738c06d0e456 ("Input: elan_i2c - add hardware ID for multiple Lenovo laptops")
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/mouse/elan_i2c_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/mouse/elan_i2c_core.c
+++ b/drivers/input/mouse/elan_i2c_core.c
@@ -1274,7 +1274,7 @@ static const struct acpi_device_id elan_
 	{ "ELAN0618", 0 },
 	{ "ELAN0619", 0 },
 	{ "ELAN061A", 0 },
-	{ "ELAN061B", 0 },
+/*	{ "ELAN061B", 0 }, not working on the Lenovo Legion Y7000 */
 	{ "ELAN061C", 0 },
 	{ "ELAN061D", 0 },
 	{ "ELAN061E", 0 },


