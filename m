Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05318382660
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 10:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235451AbhEQIMi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 04:12:38 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:51997 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234381AbhEQIMg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 04:12:36 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.west.internal (Postfix) with ESMTP id 8E47E45D;
        Mon, 17 May 2021 04:11:19 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Mon, 17 May 2021 04:11:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=PRh3JI
        3Of021FsaAHnXe1fuF0EIEQrbGOqiGMwDBMdA=; b=iItFkhaYkHzX9iy9P4Zup9
        WHIgYJrthBqR39DaH1mpbfyAG3sSVvBES7gSUAMjiBPtcopdE++k3RG0rlBCMk/B
        sNUpRSmNlno8J5CcWabLG7dgjgaUknKedjNYtTyrW3G5BI4qI3274AIePcZ+cnT/
        6aHhJRZtNQhqqrwIvQEkTNmQPuhOUgh6T+UHKroYKOXvD13HTYoQiHbEBt1GnW13
        Y0FNirCvBNqEsgk5/fy69oswKXaZq4lFAMJawy9esHdZQRu2raymhnLUgacYWy83
        b0YSgYDlaSXqox3bqLr/jq6KxUDnMH1hoAMIFEx/J9tNdEdfG820DO+Q8aE6wA4Q
        ==
X-ME-Sender: <xms:JyWiYO5xs2ml9sE7ftqPuSEKeBB4L4av1ngJe5UlyGGkX0L7Hm6Cuw>
    <xme:JyWiYH5yIe0gVOH2tepL6RGQM0ZKLDhyXvKUasXijZD52lXJURL1BW8zqHlYJHu2Z
    iXzbf22Y6qD2A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeihedgtdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:JyWiYNdLo8v_RNWZ2trHVc6zkadR-ts699-UwRs7bkevItqexm82TQ>
    <xmx:JyWiYLLgwQsHEVQiJ3_0aBw4qJ2m3bjzxPAIGiIum-KVwSK2zrmQ-A>
    <xmx:JyWiYCJcyO3bdIMT7s4oUW3Xwlkah4dwWlA8S3tTUNCga-2dE-AkbA>
    <xmx:JyWiYJULwkO2odKfVZXOCvpJy1fRQFBTDwvx5Bo3PtR27sOU_psub-n49bU>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 17 May 2021 04:11:18 -0400 (EDT)
Subject: FAILED: patch "[PATCH] usb: typec: ucsi: Put fwnode in any case during ->probe()" failed to apply to 4.19-stable tree
To:     andy.shevchenko@gmail.com, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 May 2021 10:11:06 +0200
Message-ID: <1621239066200111@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
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

