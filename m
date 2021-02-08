Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0B5A312EAA
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 11:15:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbhBHKO4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 05:14:56 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:60795 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231987AbhBHKMw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 05:12:52 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 66458302;
        Mon,  8 Feb 2021 05:11:50 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 08 Feb 2021 05:11:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=589Vi5
        XKrbgGLPheJKNybuU6JaQT0f+Roa5vP11YP4k=; b=tl/S7hVbI62cf+I7yzUEii
        q6MNUqqXw9gkL8WXsokTMAY0qxlGaruKSd2tBNC+VgMfvEmds67AmzOFZHQo8hK6
        kXHKaYJ4RPp4+lQ8wxw8c/Ysx07aAcFsf1dFsUwAe/JlwbzShfMHP7mhr9cLn9WA
        tTVDWFlw+Nm3rkrxw5YmYf7GMOXzN0Wr9T+CnghZaydxlSkaIEfcFo9Qzx/ZyY4J
        O9wnkELkritnqyGguDVdCucfUhwpIyLQcnEsQikPPRZnWxDhVqsmbidFJSA2L63T
        alu0XZPodbdJly69ToBe1ejoOqgFv+I5KWMgxXH8AvBXWczoqFmH6Xva7MI9r7SQ
        ==
X-ME-Sender: <xms:ZQ4hYET1ZNiv9fv1JzMML7l7NltW1aaqFheR75WTCBdqcpinpj1UgA>
    <xme:ZQ4hYByi_TFYnRiA6jU4op4hORCVSbnRS6P6NBnGwFAAwBhzNJg_3khEVoZvwBqBm
    97bSprwJoiTqg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrheefgdduudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:ZQ4hYB2G09kH5hKA5Y8FXbLAlzSE8ym_yCg7y_tuJ3jBlmmzB5s-Xw>
    <xmx:ZQ4hYICULde3Sm5y5eDt28_psWgthXpnA_HZp1h0T2uZjxd5a6xhkA>
    <xmx:ZQ4hYNj-FrQpeIXJ_4eO53Ybi14ojs3jXi0dbu1RbnbkJvY7Zndvow>
    <xmx:Zg4hYNav8h2f53KmYgEHzU_7LOji4O9Ws6zwiAkLch9ZxWD753ok0wvgaXM>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 179F424005D;
        Mon,  8 Feb 2021 05:11:49 -0500 (EST)
Subject: FAILED: patch "[PATCH] gpiolib: cdev: clear debounce period if line set to output" failed to apply to 5.10-stable tree
To:     warthog618@gmail.com, bgolaszewski@baylibre.com,
        linus.walleij@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 08 Feb 2021 11:11:47 +0100
Message-ID: <1612779107255191@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 03a58ea5905fdbd93ff9e52e670d802600ba38cd Mon Sep 17 00:00:00 2001
From: Kent Gibson <warthog618@gmail.com>
Date: Thu, 21 Jan 2021 22:10:38 +0800
Subject: [PATCH] gpiolib: cdev: clear debounce period if line set to output

When set_config changes a line from input to output debounce is
implicitly disabled, as debounce makes no sense for outputs, but the
debounce period is not being cleared and is still reported in the
line info.

So clear the debounce period when the debouncer is stopped in
edge_detector_stop().

Fixes: 65cff7046406 ("gpiolib: cdev: support setting debounce")
Cc: stable@vger.kernel.org
Signed-off-by: Kent Gibson <warthog618@gmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>

diff --git a/drivers/gpio/gpiolib-cdev.c b/drivers/gpio/gpiolib-cdev.c
index 1a7b51163528..1631727bf0da 100644
--- a/drivers/gpio/gpiolib-cdev.c
+++ b/drivers/gpio/gpiolib-cdev.c
@@ -776,6 +776,8 @@ static void edge_detector_stop(struct line *line)
 	cancel_delayed_work_sync(&line->work);
 	WRITE_ONCE(line->sw_debounced, 0);
 	WRITE_ONCE(line->eflags, 0);
+	if (line->desc)
+		WRITE_ONCE(line->desc->debounce_period_us, 0);
 	/* do not change line->level - see comment in debounced_value() */
 }
 

