Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEFB2136859
	for <lists+stable@lfdr.de>; Fri, 10 Jan 2020 08:36:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbgAJHgE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jan 2020 02:36:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:50796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726549AbgAJHgE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Jan 2020 02:36:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22B322072E;
        Fri, 10 Jan 2020 07:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578641763;
        bh=28UsxldREJ16JoozMn50gEh9Cvrqlg1LTxMj+nPfB1s=;
        h=Subject:To:From:Date:From;
        b=hH75bAACqiJAv2E+lGOahEGv5JjDkFZialnWEg8AMxa9HKQFltHPdb/qlXDYm6zU4
         TPpUumBRPIh1Pv3RAjgBx0oyu91z/MURabvf5+l5oMVTo5ygCqnFg7VYbAJ3aB4+kh
         8IpGik6OCiTHjq4wVlJp3B07vNOaAtRXNLDp5y3k=
Subject: patch "usb: missing parentheses in USE_NEW_SCHEME" added to usb-linus
To:     atmgnd@outlook.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, stern@rowland.harvard.edu
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 10 Jan 2020 08:36:01 +0100
Message-ID: <1578641761021@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: missing parentheses in USE_NEW_SCHEME

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 1530f6f5f5806b2abbf2a9276c0db313ae9a0e09 Mon Sep 17 00:00:00 2001
From: Qi Zhou <atmgnd@outlook.com>
Date: Sat, 4 Jan 2020 11:02:01 +0000
Subject: usb: missing parentheses in USE_NEW_SCHEME

According to bd0e6c9614b9 ("usb: hub: try old enumeration scheme first
for high speed devices") the kernel will try the old enumeration scheme
first for high speed devices.  This can happen when a high speed device
is plugged in.

But due to missing parentheses in the USE_NEW_SCHEME define, this logic
can get messed up and the incorrect result happens.

Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Qi Zhou <atmgnd@outlook.com>
Link: https://lore.kernel.org/r/ht4mtag8ZP-HKEhD0KkJhcFnVlOFV8N8eNjJVRD9pDkkLUNhmEo8_cL_sl7xy9mdajdH-T8J3TFQsjvoYQT61NFjQXy469Ed_BbBw_x4S1E=@protonmail.com
[ fixup changelog text - gregkh]
Cc: stable <stable@vger.kernel.org>
Fixes: bd0e6c9614b9 ("usb: hub: try old enumeration scheme first for high speed devices")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/hub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index f229ad6952c0..8c4e5adbf820 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -2692,7 +2692,7 @@ static unsigned hub_is_wusb(struct usb_hub *hub)
 #define SET_ADDRESS_TRIES	2
 #define GET_DESCRIPTOR_TRIES	2
 #define SET_CONFIG_TRIES	(2 * (use_both_schemes + 1))
-#define USE_NEW_SCHEME(i, scheme)	((i) / 2 == (int)scheme)
+#define USE_NEW_SCHEME(i, scheme)	((i) / 2 == (int)(scheme))
 
 #define HUB_ROOT_RESET_TIME	60	/* times are in msec */
 #define HUB_SHORT_RESET_TIME	10
-- 
2.24.1


