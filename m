Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79C0E1F8794
	for <lists+stable@lfdr.de>; Sun, 14 Jun 2020 09:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725379AbgFNHyH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Jun 2020 03:54:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbgFNHyH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Jun 2020 03:54:07 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAAE9C03E969
        for <stable@vger.kernel.org>; Sun, 14 Jun 2020 00:54:06 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id x14so13975369wrp.2
        for <stable@vger.kernel.org>; Sun, 14 Jun 2020 00:54:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=sfYuL8kK5vaf1Vjcx1Nuh4vU+MM3NKAp0en06WK46xc=;
        b=maPiH9TxPa0LOonY16BjLoFZBwKUYqwq3gQxweYfm70fJ6H4DvW8DOOAyvsLmIt0qs
         +uBntFZhbeI2iNih7SrXb6HgaakW1V7aUF56zhdGeh8cFDJsz8uRgIMAVeISlInwK/te
         oEABYJDajx/lnQsF5a9AZScXZk9qQKrLvnATLHfhoQStilhfMQC4CZYRMAWR9B1816Pn
         NwKNSDhP97munAKKyTRCIfO56VhkVNLWGifQBv97RdjUg4G9oQBuOAw38Dh97ZA4bBiz
         ZhftNsjAJEXuu1rCo0G3FaH8D2miCi5XlonrA2lOX/7Z9xIDH9DgmNo+cBpiyKvxauvk
         REiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :mime-version:content-disposition;
        bh=sfYuL8kK5vaf1Vjcx1Nuh4vU+MM3NKAp0en06WK46xc=;
        b=sKkuKoN/AgDDDcf1uxXXhAQci3AZgPubYEZHmWYO5bgMCGM/Q4+Kn3bv9xt6tcq6yN
         rl296/9e0A4E2F2ogHwyFhrZbxEOSYBTEqcrz0ioc8cLl+Wx+X1ybjQyB1XR6IP2gLtV
         teVZSSanxjjsx0TcLOyHYoVuvyHPcmbUaSPPvPWGFhSLcB1VsfjSA79NXh9+f+zerPd9
         t5pmAodyvtj1B9waT+jf4T+Muf8fyUcpDe2IchIn209IRTW/72ARgATSgXsnQLv/sMwM
         8D4mpfLP4xlzA0jZv8TI6IBdUJSbbD269l8HlS8TPAhveGSKiz8dUFoigrECDHCoxo/6
         N1/w==
X-Gm-Message-State: AOAM531vX4ssJmGCf42RqxzsKwYRprYNxbQ9IWLg8h+choHtgAoopU0g
        2xqdQVCI3U8Q1OsJWgIiWKM=
X-Google-Smtp-Source: ABdhPJznpYvav2UgKYAQogl1xFCrsfnjEs+PLfMFzqO4cZu2ZCUTd/NgPn9uJRTY6Q0i9E14TaSndQ==
X-Received: by 2002:a5d:49c5:: with SMTP id t5mr23508269wrs.18.1592121245576;
        Sun, 14 Jun 2020 00:54:05 -0700 (PDT)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id b187sm17285129wmd.26.2020.06.14.00.54.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Jun 2020 00:54:04 -0700 (PDT)
Date:   Sun, 14 Jun 2020 09:54:03 +0200
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     stable <stable@vger.kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: Please apply backport of commit da2311a6385c ("can: kvaser_usb:
 kvaser_usb_leaf: Fix some info-leaks to USB devices") to v4.9.y
Message-ID: <20200614075403.GA450037@eldamar.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

The issue fixed with da2311a6385c ("can: kvaser_usb: kvaser_usb_leaf:
Fix some info-leaks to USB devices") seem to be present as well before
4.19, introduced in 3.8 by commit 080f40a6fa28 "can: kvaser_usb: Add
support for Kvaser CAN/USB devices" already.

For Debian (for 4.9.210-1 upload) and for 3.16.y upstream Ben
Hutchings did backport the commit.

Can you apply it please as well for v4.9.y?

Regards,
Salvatore

From fe8da238df185e6b55301eea0c762e1ab04df625 Mon Sep 17 00:00:00 2001
From: Xiaolong Huang <butterflyhuangxx@gmail.com>
Date: Sat, 7 Dec 2019 22:40:24 +0800
Subject: [PATCH] can: kvaser_usb: kvaser_usb_leaf: Fix some info-leaks to USB
 devices

Uninitialized Kernel memory can leak to USB devices.

Fix this by using kzalloc() instead of kmalloc().

Signed-off-by: Xiaolong Huang <butterflyhuangxx@gmail.com>
Fixes: 7259124eac7d ("can: kvaser_usb: Split driver into kvaser_usb_core.c and kvaser_usb_leaf.c")
Cc: linux-stable <stable@vger.kernel.org> # >= v4.19
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
[bwh: Backported to 4.9: adjust filename, context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/can/usb/kvaser_usb.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/usb/kvaser_usb.c b/drivers/net/can/usb/kvaser_usb.c
index 3a75352f632b..792a1afabf5d 100644
--- a/drivers/net/can/usb/kvaser_usb.c
+++ b/drivers/net/can/usb/kvaser_usb.c
@@ -791,7 +791,7 @@ static int kvaser_usb_simple_msg_async(struct kvaser_usb_net_priv *priv,
 	if (!urb)
 		return -ENOMEM;
 
-	buf = kmalloc(sizeof(struct kvaser_msg), GFP_ATOMIC);
+	buf = kzalloc(sizeof(struct kvaser_msg), GFP_ATOMIC);
 	if (!buf) {
 		usb_free_urb(urb);
 		return -ENOMEM;
@@ -1459,7 +1459,7 @@ static int kvaser_usb_set_opt_mode(const struct kvaser_usb_net_priv *priv)
 	struct kvaser_msg *msg;
 	int rc;
 
-	msg = kmalloc(sizeof(*msg), GFP_KERNEL);
+	msg = kzalloc(sizeof(*msg), GFP_KERNEL);
 	if (!msg)
 		return -ENOMEM;
 
@@ -1592,7 +1592,7 @@ static int kvaser_usb_flush_queue(struct kvaser_usb_net_priv *priv)
 	struct kvaser_msg *msg;
 	int rc;
 
-	msg = kmalloc(sizeof(*msg), GFP_KERNEL);
+	msg = kzalloc(sizeof(*msg), GFP_KERNEL);
 	if (!msg)
 		return -ENOMEM;
 
-- 
2.27.0

