Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 372D513FF62
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:42:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389189AbgAPX0W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:26:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:56772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389043AbgAPX0V (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:26:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4399220684;
        Thu, 16 Jan 2020 23:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217180;
        bh=++ih1uuZ0bYBKz46Wt4vma2E5KK7w5eA52Hcw2OUv70=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SnPhcSdYWIhPLM/FHT4+kA4PCQ0GBzj12eTR9BFqTFaJPy/Rzd1nLAq2Gr4aAikGd
         XzyuZ3PQGe4apamQuB1NuY0ypCxsAwONK1BB5TkZDhwuyg5b8loEHBb23t2/VlyF1N
         tWM5i+5orOWXIPtP7ABThvejjqXk5pXFUH69VBJ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 5.4 180/203] rtc: bd70528: Add MODULE ALIAS to autoload module
Date:   Fri, 17 Jan 2020 00:18:17 +0100
Message-Id: <20200116231800.144113702@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>

commit c3e12e66b14a043daac6b3d0559df80b9ed7679c upstream.

The bd70528 RTC driver is probed by MFD driver. Add MODULE_ALIAS
in order to allow udev to load the module when MFD sub-device cell
for RTC is added.

I'm not sure if this is a bugfix or feature addition but I guess
fixes tag won't harm in this case.

Fixes: 32a4a4ebf768 ("rtc: bd70528: Initial support for ROHM bd70528 RTC")
Signed-off-by: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
Link: https://lore.kernel.org/r/20191023114711.GA13954@localhost.localdomain
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/rtc/rtc-bd70528.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/rtc/rtc-bd70528.c
+++ b/drivers/rtc/rtc-bd70528.c
@@ -491,3 +491,4 @@ module_platform_driver(bd70528_rtc);
 MODULE_AUTHOR("Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>");
 MODULE_DESCRIPTION("BD70528 RTC driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platofrm:bd70528-rtc");


