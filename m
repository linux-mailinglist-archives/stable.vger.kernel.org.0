Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4B65200445
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 10:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731300AbgFSIqV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 04:46:21 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:48723 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731332AbgFSIqT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 04:46:19 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 2AFEA194439F;
        Fri, 19 Jun 2020 04:46:13 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 19 Jun 2020 04:46:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=9eP9bj
        lyN62XtaAzyzdNSMjS1OH/iem7TOFn3QSP1FU=; b=al9fp0Ex5Gc4JOJEfBGyEW
        s92udXyG45t9Vc6VeENtmcbkB6iN1KuqwbC7fGxL1Bz0BaCL9MaWbTdxgM39mjZs
        mGOq0BvOTMXDQusp3ZzJ2coI9z9VDrpgtqTvtECcEyrCbdTvjyoLTT5HB/Dac4Fs
        GeNJ+K40MBFjOIHd/1qNjq9H1oEiLB1JFnrZSOLPfpe6wjhGrsmqij5nYn6KjPNO
        B4bkCV/eEli3SWZbUF34deDVzJKh7KhZTXnEmwGnEmxcrwdwmK/u1kbHvgwFQbke
        FC98ACQ9917dNK5NsSA203fbiPX6jvP8iqIHc0+lDJ1ZwhEFgvUMfdrzWeltP7Nw
        ==
X-ME-Sender: <xms:VXvsXjNnFJYD1SiclrnNdddZjeGfYreeu-zZMydsXpBtitXIV7SzLA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejiedgtdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:VXvsXt_eYeBhRG8pzEV5txm8q4mTtEKdZV7_Lh1h_oC_wU1Jwa5o3g>
    <xmx:VXvsXiSX3EbqaXYR1sWzAwjTPZu6O7U6VJp4eSV3H4krdku9p_z11w>
    <xmx:VXvsXnseyi30VjHtUi8pyKtwAbVMCmv3OoAfwx9iFGzChmVkTT31WA>
    <xmx:VXvsXrn0z4Dhm86wo7pdY7qqNttQ2O4vDouTYtu4z7lncimGG2DWfw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8A3183280059;
        Fri, 19 Jun 2020 04:46:12 -0400 (EDT)
Subject: FAILED: patch "[PATCH] serial: 8250: Avoid error message on reprobe" failed to apply to 4.14-stable tree
To:     lukas@wunner.de, andriy.shevchenko@linux.intel.com,
        gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 19 Jun 2020 10:46:03 +0200
Message-ID: <1592556363116150@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e0a851fe6b9b619527bd928aa93caaddd003f70c Mon Sep 17 00:00:00 2001
From: Lukas Wunner <lukas@wunner.de>
Date: Tue, 12 May 2020 14:40:01 +0200
Subject: [PATCH] serial: 8250: Avoid error message on reprobe

If the call to uart_add_one_port() in serial8250_register_8250_port()
fails, a half-initialized entry in the serial_8250ports[] array is left
behind.

A subsequent reprobe of the same serial port causes that entry to be
reused.  Because uart->port.dev is set, uart_remove_one_port() is called
for the half-initialized entry and bails out with an error message:

bcm2835-aux-uart 3f215040.serial: Removing wrong port: (null) != (ptrval)

The same happens on failure of mctrl_gpio_init() since commit
4a96895f74c9 ("tty/serial/8250: use mctrl_gpio helpers").

Fix by zeroing the uart->port.dev pointer in the probe error path.

The bug was introduced in v2.6.10 by historical commit befff6f5bf5f
("[SERIAL] Add new port registration/unregistration functions."):
https://git.kernel.org/tglx/history/c/befff6f5bf5f

The commit added an unconditional call to uart_remove_one_port() in
serial8250_register_port().  In v3.7, commit 835d844d1a28 ("8250_pnp:
do pnp probe before legacy probe") made that call conditional on
uart->port.dev which allows me to fix the issue by zeroing that pointer
in the error path.  Thus, the present commit will fix the problem as far
back as v3.7 whereas still older versions need to also cherry-pick
835d844d1a28.

Fixes: 835d844d1a28 ("8250_pnp: do pnp probe before legacy probe")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: stable@vger.kernel.org # v2.6.10
Cc: stable@vger.kernel.org # v2.6.10: 835d844d1a28: 8250_pnp: do pnp probe before legacy
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/b4a072013ee1a1d13ee06b4325afb19bda57ca1b.1589285873.git.lukas@wunner.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index 45d9117cab68..9548d3f8fc8e 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -1040,7 +1040,7 @@ int serial8250_register_8250_port(struct uart_8250_port *up)
 			gpios = mctrl_gpio_init(&uart->port, 0);
 			if (IS_ERR(gpios)) {
 				ret = PTR_ERR(gpios);
-				goto out_unlock;
+				goto err;
 			} else {
 				uart->gpios = gpios;
 			}
@@ -1089,8 +1089,10 @@ int serial8250_register_8250_port(struct uart_8250_port *up)
 			serial8250_apply_quirks(uart);
 			ret = uart_add_one_port(&serial8250_reg,
 						&uart->port);
-			if (ret == 0)
-				ret = uart->port.line;
+			if (ret)
+				goto err;
+
+			ret = uart->port.line;
 		} else {
 			dev_info(uart->port.dev,
 				"skipping CIR port at 0x%lx / 0x%llx, IRQ %d\n",
@@ -1112,10 +1114,14 @@ int serial8250_register_8250_port(struct uart_8250_port *up)
 		}
 	}
 
-out_unlock:
 	mutex_unlock(&serial_mutex);
 
 	return ret;
+
+err:
+	uart->port.dev = NULL;
+	mutex_unlock(&serial_mutex);
+	return ret;
 }
 EXPORT_SYMBOL(serial8250_register_8250_port);
 

