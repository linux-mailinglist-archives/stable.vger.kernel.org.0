Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2D6239509B
	for <lists+stable@lfdr.de>; Sun, 30 May 2021 13:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbhE3LN0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 May 2021 07:13:26 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:58591 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229500AbhE3LN0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 May 2021 07:13:26 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id 30F6A194051E;
        Sun, 30 May 2021 07:11:48 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 30 May 2021 07:11:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ga1SHB
        A71KCeynObTmUAuHbas7Zn+EthdYgYPZ6z0KM=; b=Eubey5BfGtr5gqMaPbFyg+
        B0YQRllr0XpruWq86IMjxftWh1IQdfwAErbML4+2dhMg27SuHU1ZjqyxFMpm5hhD
        tXolyeYRUBfIxY1Ak69gpexVDIoSMlg0EI+QTxidecNvk5wkZFzoRFdI9eZbPLQm
        4RT8cxI0t7vqCHDCKVyTEWo05fsGaJ+V6IkAbaJwA1eDo3uxvra5/Aj3mWqKkVqj
        BIHXVow/qh4R/onOsEx1MD+yo1tsZrlymaBDDSrXKI+zFmTTzAOaj/6JQwXc2LdR
        Jelwwh/h0Mo4AKxMYJyi/czMy0Ym4NNSC6bYyYALqTxpUIFPSKAE3jbguYS/kdcw
        ==
X-ME-Sender: <xms:9HKzYEmeH3Cfzk96FoVkeuZVUE87lU-H1bhCiJsQdbAKWFpNl07klg>
    <xme:9HKzYD0X7qaP15dIN5LyEdFF3monDab_GUVXw27iCBQzpEF7bYZ5PCxV7UIvaFLl5
    jXTpepn48OpKg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeluddgfeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:9HKzYCoL3UW3sXAbDPmdmrGJwtKIEbpbSBIsAvE_-taZd_SZgpxYxw>
    <xmx:9HKzYAnpwFI4mphcbAUfgpzTY-5FXfW_3IDnvAhC7cF-9mAWwijGlQ>
    <xmx:9HKzYC0TEWwrBfpt301aAos1Rr2P1UupL5NEkqzqdD7MA_H0Q0egog>
    <xmx:9HKzYFSyk3ECADnj3bQpg7DvUaRvS7vroUkWO1pvvfeeMIr1kuZXkw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sun, 30 May 2021 07:11:47 -0400 (EDT)
Subject: FAILED: patch "[PATCH] usb: typec: tcpm: Use LE to CPU conversion when accessing" failed to apply to 5.4-stable tree
To:     andriy.shevchenko@linux.intel.com,
        Adam.Thomson.Opensource@diasemi.com, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, linux@roeck-us.net,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 30 May 2021 13:11:38 +0200
Message-ID: <162237309822029@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c58bbe3477f75deb7883983e6cf428404a107555 Mon Sep 17 00:00:00 2001
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Wed, 19 May 2021 13:03:58 +0300
Subject: [PATCH] usb: typec: tcpm: Use LE to CPU conversion when accessing
 msg->header

Sparse is not happy about strict type handling:
  .../typec/tcpm/tcpm.c:2720:27: warning: restricted __le16 degrades to integer
  .../typec/tcpm/tcpm.c:2814:32: warning: restricted __le16 degrades to integer

Fix this by converting LE to CPU before use.

Fixes: ae8a2ca8a221 ("usb: typec: Group all TCPCI/TCPM code together")
Fixes: 64f7c494a3c0 ("typec: tcpm: Add support for sink PPS related messages")
Cc: stable <stable@vger.kernel.org>
Cc: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20210519100358.64018-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index 64133e586c64..8fdfd7f65ad7 100644
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -2717,7 +2717,7 @@ static void tcpm_pd_ext_msg_request(struct tcpm_port *port,
 	enum pd_ext_msg_type type = pd_header_type_le(msg->header);
 	unsigned int data_size = pd_ext_header_data_size_le(msg->ext_msg.header);
 
-	if (!(msg->ext_msg.header & PD_EXT_HDR_CHUNKED)) {
+	if (!(le16_to_cpu(msg->ext_msg.header) & PD_EXT_HDR_CHUNKED)) {
 		tcpm_pd_handle_msg(port, PD_MSG_CTRL_NOT_SUPP, NONE_AMS);
 		tcpm_log(port, "Unchunked extended messages unsupported");
 		return;
@@ -2811,7 +2811,7 @@ static void tcpm_pd_rx_handler(struct kthread_work *work)
 				 "Data role mismatch, initiating error recovery");
 			tcpm_set_state(port, ERROR_RECOVERY, 0);
 		} else {
-			if (msg->header & PD_HEADER_EXT_HDR)
+			if (le16_to_cpu(msg->header) & PD_HEADER_EXT_HDR)
 				tcpm_pd_ext_msg_request(port, msg);
 			else if (cnt)
 				tcpm_pd_data_request(port, msg);

