Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0558137F7B
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:20:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729326AbgAKKUS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:20:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:41486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729211AbgAKKUR (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:20:17 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4105A20848;
        Sat, 11 Jan 2020 10:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738017;
        bh=jmJB1y3x5UX3kTWCdOAhvNiSyyyMa/BYn7obqSdk+PY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sdgWSD4ONJqLuxw8B7Hzso4cM0C8fRzmQZIQ645dX3PrOsjXjSkdKqSGkpwOM0ApE
         5LyMWJTbd7++o3ux2FGH6qCtS9UhQdPWRGa/VX1OVxhMwxQstw1k53H9lizTtxHTtr
         zBof8N2VYQ/8Rad8rDXX+BsTwnbCTCvgHRbhHrU8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Qi Zhou <atmgnd@outlook.com>
Subject: [PATCH 4.19 84/84] usb: missing parentheses in USE_NEW_SCHEME
Date:   Sat, 11 Jan 2020 10:51:01 +0100
Message-Id: <20200111094913.052164288@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094845.328046411@linuxfoundation.org>
References: <20200111094845.328046411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qi Zhou <atmgnd@outlook.com>

commit 1530f6f5f5806b2abbf2a9276c0db313ae9a0e09 upstream.

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
 drivers/usb/core/hub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -2657,7 +2657,7 @@ static unsigned hub_is_wusb(struct usb_h
 #define SET_ADDRESS_TRIES	2
 #define GET_DESCRIPTOR_TRIES	2
 #define SET_CONFIG_TRIES	(2 * (use_both_schemes + 1))
-#define USE_NEW_SCHEME(i, scheme)	((i) / 2 == (int)scheme)
+#define USE_NEW_SCHEME(i, scheme)	((i) / 2 == (int)(scheme))
 
 #define HUB_ROOT_RESET_TIME	60	/* times are in msec */
 #define HUB_SHORT_RESET_TIME	10


