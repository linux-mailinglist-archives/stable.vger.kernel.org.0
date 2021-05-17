Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5F94382F78
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238914AbhEQOQw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:16:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:46734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239036AbhEQOOq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:14:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 66F58613E1;
        Mon, 17 May 2021 14:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260550;
        bh=7Gsx0NlCcnmcG/bE9/p3aCDoy8vHXBtqUVeUVaBBtgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QTlrHrNd81YFyC4IpXorVfUn6HnlkkasMWI4FoQJjtDf9OX7sgpCW3Vnm8cyW3vUo
         T3yZYnxrJBclzHJD4i6fL2cRiNP/e26hLNt8xfZ/fty2CqnWogU+PVlXqkRS0SZ+DR
         Ur9+IRqwV7+i3kd11XwIm/Q5m8upy+FrNz7rh7ng=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Dmitry Osipenko <digetx@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 131/363] rtc: tps65910: include linux/property.h
Date:   Mon, 17 May 2021 15:59:57 +0200
Message-Id: <20210517140307.053624345@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 936d3685e62436a378f02b8b74759b054d4aeca1 ]

The added device_property_present() call causes a build
failure in some configurations because of the missing header:

drivers/rtc/rtc-tps65910.c:422:7: error: implicit declaration of function 'device_property_present' [-Werror,-Wimplicit-function-declaration]

Fixes: 454ba154a62c ("rtc: tps65910: Support wakeup-source property")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20210225134215.2263694-1-arnd@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-tps65910.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rtc/rtc-tps65910.c b/drivers/rtc/rtc-tps65910.c
index 288abb1abdb8..bc89c62ccb9b 100644
--- a/drivers/rtc/rtc-tps65910.c
+++ b/drivers/rtc/rtc-tps65910.c
@@ -18,6 +18,7 @@
 #include <linux/rtc.h>
 #include <linux/bcd.h>
 #include <linux/math64.h>
+#include <linux/property.h>
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
 #include <linux/mfd/tps65910.h>
-- 
2.30.2



