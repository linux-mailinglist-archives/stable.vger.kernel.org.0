Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F216E39509A
	for <lists+stable@lfdr.de>; Sun, 30 May 2021 13:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbhE3LNS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 May 2021 07:13:18 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:50505 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229500AbhE3LNS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 May 2021 07:13:18 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.nyi.internal (Postfix) with ESMTP id 6CDC51940532;
        Sun, 30 May 2021 07:11:40 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Sun, 30 May 2021 07:11:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=uzFf7H
        CLkmmg9ra0Fa0so8sPhXKS41p3TY8y9if6ZTk=; b=S42A3V3Hb4KYMoOEueUsFH
        FuZfwclQj0QgpydM40O9cjWGwr4zX40qr8F7bnX47FM3+J8QFvU0bVACwoJZv3a3
        jaEEVf/nQhq5emugaQkAmgakcrOrcnuQM4mS5ikVL1sbuC+vk/wZAAzrHvM8g8jB
        GXNqr4IIUKJZXHFRxj8xalpjt+ZLb+ha0Sv7bR4iyoAqJpmiPpUOyt2wuXS2kNb5
        8+g+y+GjaxLIeczQeFo+kQtG2MaXGghnS9vmCKXjUSevE/FLZQeXrMqmNfjMsCrk
        4NSvkP8j/uZBdHBDBdon+SCf6+yZRGi00mLLl/f90mmjAesv4NXR9IkCu7u9l+Qg
        ==
X-ME-Sender: <xms:63KzYOXckI4uqw2iNVJfpBlSmRtktQeSWVTR7DseVn1LcOv0-C2c-g>
    <xme:63KzYKnnNVu8xOEnNKRvQqbAvwH5SqBHXsdZ4U_4RjrdggBdYzXrglhY2BL9zbcRx
    tblpd4cycqFZw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeluddgfeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:63KzYCbRQVmGIRkWT2Bo0tXW2jp8iZm8_dtSSAy-ue0JZQKi1KMgww>
    <xmx:63KzYFWd2SpPMO8YcbGY2uplpJ_iRlvMY0sGfLwNYqJanxHhovT-eA>
    <xmx:63KzYIkfor73TxLmocJa7bzsvREoZj7wqupXI9u-feaMl9UdDsQ7DQ>
    <xmx:7HKzYJBX2nfIslpoDddI_616-mrbVMZKTi0ZKCaxYE8m0tGRWSSDtw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sun, 30 May 2021 07:11:39 -0400 (EDT)
Subject: FAILED: patch "[PATCH] usb: typec: tcpm: Use LE to CPU conversion when accessing" failed to apply to 5.10-stable tree
To:     andriy.shevchenko@linux.intel.com,
        Adam.Thomson.Opensource@diasemi.com, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, linux@roeck-us.net,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 30 May 2021 13:11:35 +0200
Message-ID: <1622373095227162@kroah.com>
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

