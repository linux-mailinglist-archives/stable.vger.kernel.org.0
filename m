Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91DF91B14A
	for <lists+stable@lfdr.de>; Mon, 13 May 2019 09:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727371AbfEMHlM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 May 2019 03:41:12 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:49753 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727272AbfEMHlM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 May 2019 03:41:12 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 46E5E20D84;
        Mon, 13 May 2019 03:41:11 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 13 May 2019 03:41:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=0Js0TM
        nXBWVx/g+EfTeBrqLroO8IcdRH2q7QpRBz1QE=; b=XKxuBBJxjLI16XAGB3P2Ho
        u+yCHEVSl/nRG+HjviKl1Xeln3NEjUMfXLcxWPxsCYG2wfA0X7t+dGWr89WtB5Od
        r2OJFsPm0BaaWWHP2MiIr8UOqhSN8dyraT/DYz7rW5gHONZKZuyZYPr6Uz9hzWf/
        gilHsZoNzQN3H6A6PHBMBmUMyqfaOClwQgoIRO5wKSk28WXmt+SZ1ryfAgDGaVHz
        /auuK4tGdm4kYuD7+ZsUcwIBA9pwd16sZLnNRXDVY6ZJ1VGFh7jIj0oRAo2+/q6m
        dXcynJo/0B+WwW2cRK0I7oVTfhkx9dn1LWEHNF0KI0E10m3Bp/guzVZZJpNDH/JA
        ==
X-ME-Sender: <xms:lh_ZXCTzhLUr2FbjNIPv4x03FTWTmQ3q_NoKtR7CQpJ_oNpKEqN8uw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrleefgdduvddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:lh_ZXNDnPCikAziBSOGQ-M9ip2l1YEAoKZ1MzZnGaWOigysgA9i1-Q>
    <xmx:lh_ZXBgzh8bzpXnaIUePiRRSL86J6kby7lx0iKTGrjRakAjDseZkBw>
    <xmx:lh_ZXGNH4R2b59WXlJIlFfa7fVN4panurYhEaZGKhm7xHIpDW-f9uw>
    <xmx:lx_ZXFHO9FubapjZzawL7qLswUCJg-Rbil2mX5Lgm20cnxUjeBVMkA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id E354710378;
        Mon, 13 May 2019 03:41:09 -0400 (EDT)
Subject: FAILED: patch "[PATCH] platform/x86: dell-laptop: fix rfkill functionality" failed to apply to 4.14-stable tree
To:     mario.limonciello@dell.com, dvhart@infradead.org,
        pali.rohar@gmail.com, pepijndevos@gmail.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 13 May 2019 09:41:08 +0200
Message-ID: <155773326874172@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From 6cc13c28da5beee0f706db6450e190709700b34a Mon Sep 17 00:00:00 2001
From: Mario Limonciello <mario.limonciello@dell.com>
Date: Wed, 27 Mar 2019 09:25:34 -0500
Subject: [PATCH] platform/x86: dell-laptop: fix rfkill functionality
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When converting the driver two arguments were transposed leading
to rfkill not working.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=201427
Reported-by: Pepijn de Vos <pepijndevos@gmail.com>
Fixes: 549b49 ("platform/x86: dell-smbios: Introduce dispatcher for SMM calls")
Signed-off-by: Mario Limonciello <mario.limonciello@dell.com>
Acked-by: Pali Rohár <pali.rohar@gmail.com>
Cc: <stable@vger.kernel.org> # 4.14.x
Signed-off-by: Darren Hart (VMware) <dvhart@infradead.org>

diff --git a/drivers/platform/x86/dell-laptop.c b/drivers/platform/x86/dell-laptop.c
index 95e6ca116e00..a561f653cf13 100644
--- a/drivers/platform/x86/dell-laptop.c
+++ b/drivers/platform/x86/dell-laptop.c
@@ -531,7 +531,7 @@ static void dell_rfkill_query(struct rfkill *rfkill, void *data)
 		return;
 	}
 
-	dell_fill_request(&buffer, 0, 0x2, 0, 0);
+	dell_fill_request(&buffer, 0x2, 0, 0, 0);
 	ret = dell_send_request(&buffer, CLASS_INFO, SELECT_RFKILL);
 	hwswitch = buffer.output[1];
 
@@ -562,7 +562,7 @@ static int dell_debugfs_show(struct seq_file *s, void *data)
 		return ret;
 	status = buffer.output[1];
 
-	dell_fill_request(&buffer, 0, 0x2, 0, 0);
+	dell_fill_request(&buffer, 0x2, 0, 0, 0);
 	hwswitch_ret = dell_send_request(&buffer, CLASS_INFO, SELECT_RFKILL);
 	if (hwswitch_ret)
 		return hwswitch_ret;
@@ -647,7 +647,7 @@ static void dell_update_rfkill(struct work_struct *ignored)
 	if (ret != 0)
 		return;
 
-	dell_fill_request(&buffer, 0, 0x2, 0, 0);
+	dell_fill_request(&buffer, 0x2, 0, 0, 0);
 	ret = dell_send_request(&buffer, CLASS_INFO, SELECT_RFKILL);
 
 	if (ret == 0 && (status & BIT(0)))

