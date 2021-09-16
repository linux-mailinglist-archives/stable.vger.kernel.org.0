Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA8F40DEE8
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240503AbhIPQE4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:04:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:44252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240493AbhIPQEz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:04:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0215460232;
        Thu, 16 Sep 2021 16:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808214;
        bh=p7d4bhnfqECFEqdOK8IMNRXLJgepolXAuK357mixdk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dDn1dimlGQ/SBZ9P/Izl2jWHXwJ26aI8Wsk22I4iPPt0W0I3A+ancET+921UDtgSv
         OblPkrhIkqCU1gajlbK5Oz5W3KINy/99JGIYKNQS+NHwGCnaeLPi34lwRkIg8/CzKe
         g4mnQrYSAvJO9V5uQ1wmdV+HojhsWH0+LMElWP7Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anton Bambura <jenneron@protonmail.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 5.10 001/306] rtc: tps65910: Correct driver module alias
Date:   Thu, 16 Sep 2021 17:55:46 +0200
Message-Id: <20210916155753.956237388@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

commit 8d448fa0a8bb1c8d94eef7647edffe9ac81a281e upstream.

The TPS65910 RTC driver module doesn't auto-load because of the wrong
module alias that doesn't match the device name, fix it.

Cc: stable@vger.kernel.org
Reported-by: Anton Bambura <jenneron@protonmail.com>
Tested-by: Anton Bambura <jenneron@protonmail.com>
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20210808160030.8556-1-digetx@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/rtc-tps65910.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/rtc/rtc-tps65910.c
+++ b/drivers/rtc/rtc-tps65910.c
@@ -469,6 +469,6 @@ static struct platform_driver tps65910_r
 };
 
 module_platform_driver(tps65910_rtc_driver);
-MODULE_ALIAS("platform:rtc-tps65910");
+MODULE_ALIAS("platform:tps65910-rtc");
 MODULE_AUTHOR("Venu Byravarasu <vbyravarasu@nvidia.com>");
 MODULE_LICENSE("GPL");


