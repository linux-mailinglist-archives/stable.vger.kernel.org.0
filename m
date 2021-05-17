Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7831638265E
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 10:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235406AbhEQIMb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 04:12:31 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:40631 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235428AbhEQIMZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 04:12:25 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 04B56499;
        Mon, 17 May 2021 04:11:08 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 17 May 2021 04:11:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=SC0voZ
        Gm1LusCb8oZb1QQaj7KhtXa6ly1Z05oOm4AuI=; b=v/ZH9pQ72p2QvRag95cJMo
        DzjS6Y5F1gn1LGpe6kkOyUfJNxTnnScfObbJGqvKVZ2JpLoHEVkA0x1kl/uba9J3
        JelhHP5GsJid62efpZbkUzrOkGb1NQV4r6Dt9pvvU90KUCOKLTo+yc2bxw9m0Hvg
        ayIiffTHZPXkOwy/Bm0zj4eY/rmifAAlpp5mu7nwEOMhfTr8BrTv+Fk9fu7FgyWz
        nmjpklsiKmjy6ESTdlKcou3EuIjib8BRH/kXDRYuu/n+HZ6/wIf3hnPYTzfLXKMo
        2Nmp/c9tUdXdpvcSVmJ4sT7zvPFKHDPnGNKxYQIccM32bUSoMDYwfIExp4ayl1og
        ==
X-ME-Sender: <xms:GyWiYBOVUmZ12Z2guAIoYv0A98nSaeoakO0crGidMqiPaL4TLd32Eg>
    <xme:GyWiYD-nkvImfG7xJrNE1c85E731ZcIitNWDna-f1Z2kRKFcVcf5QfZ9HNP-UPaqv
    T9BXrtgQrw0Rg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeihedgtdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:GyWiYAQoKNJRc4XinBHn4WluQSaY28NoUjKiLEGuJZWayncI28lDiw>
    <xmx:GyWiYNsNoC_CxdxfkuSQdQkh0a5hngWPiF2ZB1_xxBIUwkGbgropYg>
    <xmx:GyWiYJdswP84wRwCj3gTFIiH0rIWSkforg5wsX5DtzB-j9mj7q87yw>
    <xmx:HCWiYKrV3bLHkBiAZIfHaJsN4wWGkqJU6hnztkQ4oa5DzpCglxbJ-5Xng7A>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 17 May 2021 04:11:07 -0400 (EDT)
Subject: FAILED: patch "[PATCH] usb: typec: ucsi: Put fwnode in any case during ->probe()" failed to apply to 5.4-stable tree
To:     andy.shevchenko@gmail.com, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 May 2021 10:11:05 +0200
Message-ID: <162123906513147@kroah.com>
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

From b9a0866a5bdf6a4643a52872ada6be6184c6f4f2 Mon Sep 17 00:00:00 2001
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Wed, 5 May 2021 01:23:37 +0300
Subject: [PATCH] usb: typec: ucsi: Put fwnode in any case during ->probe()

device_for_each_child_node() bumps a reference counting of a returned variable.
We have to balance it whenever we return to the caller.

Fixes: c1b0bc2dabfa ("usb: typec: Add support for UCSI interface")
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20210504222337.3151726-1-andy.shevchenko@gmail.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
index 282c3c825c13..0e1cec346e0f 100644
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -999,6 +999,7 @@ static const struct typec_operations ucsi_ops = {
 	.pr_set = ucsi_pr_swap
 };
 
+/* Caller must call fwnode_handle_put() after use */
 static struct fwnode_handle *ucsi_find_fwnode(struct ucsi_connector *con)
 {
 	struct fwnode_handle *fwnode;
@@ -1033,7 +1034,7 @@ static int ucsi_register_port(struct ucsi *ucsi, int index)
 	command |= UCSI_CONNECTOR_NUMBER(con->num);
 	ret = ucsi_send_command(ucsi, command, &con->cap, sizeof(con->cap));
 	if (ret < 0)
-		goto out;
+		goto out_unlock;
 
 	if (con->cap.op_mode & UCSI_CONCAP_OPMODE_DRP)
 		cap->data = TYPEC_PORT_DRD;
@@ -1151,6 +1152,8 @@ static int ucsi_register_port(struct ucsi *ucsi, int index)
 	trace_ucsi_register_port(con->num, &con->status);
 
 out:
+	fwnode_handle_put(cap->fwnode);
+out_unlock:
 	mutex_unlock(&con->lock);
 	return ret;
 }

