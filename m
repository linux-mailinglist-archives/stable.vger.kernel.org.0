Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0FD126A0C6
	for <lists+stable@lfdr.de>; Tue, 15 Sep 2020 10:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726217AbgIOIZO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 04:25:14 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:53027 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726200AbgIOIMY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Sep 2020 04:12:24 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 132995A3;
        Tue, 15 Sep 2020 04:12:14 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 15 Sep 2020 04:12:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=x9UrH4
        qf72PpLgnXb5i5XaLx5xuFMPoX0uLyJ+5Tz2I=; b=OjGXWLNxvv9UQfxCUHstf4
        gs1lpJhODsvPaS3WhF/C2rWRym9EPrMvQ1NIbRB9UpcWlz3nVzZoMZ6OFlvX8sok
        HxANl6phjrJ6U2Y8flcxHv8Ckt4hgZyEhd33dMRVgWAUXj5PpxJlmzqjrIc7gMTd
        goijVojuhcrGVj6dPg8QdEK57LzSsCPnSckpDdyz+gOtTdcG8l6mdUEH6CG/DVil
        NJFnj4MoWlnGFsuQXuZt+q71S0AAU+RuVoMLcU6I2sYFcvVQe9VkxTFxuM2wWnyi
        /zdkaE+KFFGJuOmAdLGzBgk5UpvFK/sUKh9Jehd+CQx94pRTIPSdNfSXfm4vhXLQ
        ==
X-ME-Sender: <xms:XXdgXy4__fVGtr_DyYFItysm7_OjEJM-mQ7ConXbFThRXLStTnXUow>
    <xme:XXdgX75W9a3kd5Gtm_lxJ9IptqF8JGeExcl-_-mcTNG8ABPlAzpRvSEF-h4n9LtL8
    M9_-VMRoSNYWA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudeikedgtdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:XXdgXxf77C81zBMrRtGDwwz3dVJRZ-MWg_J8-1zYaRrVWOUUI_V1ow>
    <xmx:XXdgX_L-lAG5bLCKXmE54Q2SoBpz5nvoXZsbIcTswoDjmUXb-zyICA>
    <xmx:XXdgX2K92ahWgzbo2QFsurIV4LS4Z6zQLWkxAlbq_et75zwI0ZXQjQ>
    <xmx:XXdgX4g23gDZlocZnTbH5hRd3WoKpRKT92JjkULed7Vkjn5zsHXoIwig9sQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 989D43280060;
        Tue, 15 Sep 2020 04:12:12 -0400 (EDT)
Subject: FAILED: patch "[PATCH] RDMA/rxe: Fix the parent sysfs read when the interface has 15" failed to apply to 4.9-stable tree
To:     yi.zhang@redhat.com, bvanassche@acm.org, jgg@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 15 Sep 2020 10:12:09 +0200
Message-ID: <16001575293494@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 60b1af64eb35074a4f2d41cc1e503a7671e68963 Mon Sep 17 00:00:00 2001
From: Yi Zhang <yi.zhang@redhat.com>
Date: Thu, 20 Aug 2020 23:36:46 +0800
Subject: [PATCH] RDMA/rxe: Fix the parent sysfs read when the interface has 15
 chars

'parent' sysfs reads will yield '\0' bytes when the interface name has 15
chars, and there will no "\n" output.

To reproduce, create one interface with 15 chars:

 [root@test ~]# ip a s enp0s29u1u7u3c2
 2: enp0s29u1u7u3c2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UNKNOWN group default qlen 1000
     link/ether 02:21:28:57:47:17 brd ff:ff:ff:ff:ff:ff
     inet6 fe80::ac41:338f:5bcd:c222/64 scope link noprefixroute
        valid_lft forever preferred_lft forever
 [root@test ~]# modprobe rdma_rxe
 [root@test ~]# echo enp0s29u1u7u3c2 > /sys/module/rdma_rxe/parameters/add
 [root@test ~]# cat /sys/class/infiniband/rxe0/parent
 enp0s29u1u7u3c2[root@test ~]#
 [root@test ~]# f="/sys/class/infiniband/rxe0/parent"
 [root@test ~]# echo "$(<"$f")"
 -bash: warning: command substitution: ignored null byte in input
 enp0s29u1u7u3c2

Use scnprintf and PAGE_SIZE to fill the sysfs output buffer.

Cc: stable@vger.kernel.org
Fixes: 8700e3e7c485 ("Soft RoCE driver")
Link: https://lore.kernel.org/r/20200820153646.31316-1-yi.zhang@redhat.com
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yi Zhang <yi.zhang@redhat.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
index bb61e534e468..756980f79951 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -1056,7 +1056,7 @@ static ssize_t parent_show(struct device *device,
 	struct rxe_dev *rxe =
 		rdma_device_to_drv_device(device, struct rxe_dev, ib_dev);
 
-	return snprintf(buf, 16, "%s\n", rxe_parent_name(rxe, 1));
+	return scnprintf(buf, PAGE_SIZE, "%s\n", rxe_parent_name(rxe, 1));
 }
 
 static DEVICE_ATTR_RO(parent);

