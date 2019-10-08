Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF478CF3F2
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 09:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730309AbfJHHec (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 03:34:32 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:34923 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730144AbfJHHec (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 03:34:32 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 8DE145C6;
        Tue,  8 Oct 2019 03:34:30 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 08 Oct 2019 03:34:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Vmc292
        OdCJH3szmCIO0aQP1M+EJDxdNfhmV/bacg5+0=; b=QuepF55PfBpVdq2ZK6CuSR
        3Dm7tFmEj7YIW/8SNd1M8Bt4SN57y9W9dZT8Xbv5LKHvayPuUmUcFFTHZmcXaERr
        JMOs4BMNIeNmokSm1sZWm/ghjX6BFf2ZxEU2vhEaWx/WuJPE86oY1duRyR7f+LHf
        NK3VGl56KyGW40Mn36GsV6/TjUrXOudzGJ/ADJXi9s5Dsu4I5ZdYqLQihhPXPYc/
        9EU90jgd/6DAL60pIUhW0qmPsxJfD8GNHilxtza+kHOPkj8k3pZ07QlzIIp+PdtX
        cOOZmcaz7AA2tuSrssAAD9hpru/dkYcGbzp7xPNFEdO4bJGs+Ttqm8sG3s2AOaFQ
        ==
X-ME-Sender: <xms:BjycXZ9HG0FyME6cMKXfQVRbMGKdh2hRbvm22_UKQFSNDtwu0TZh9Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrheekgdduudelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedv
X-ME-Proxy: <xmx:BjycXb_L9dgbjfZ4N7wtvsMueJBBDsb5b2GG6tJHH0vfEkirSDKwYA>
    <xmx:BjycXRLetbJxA_ZVZlMOf7hK8WSYnGwSi1Jd1MGGrEFbRQHNFwba9g>
    <xmx:BjycXZ0UbqFCVoyxRnYZd8Pc48Ie-umBDnhrMwn69hJQHhdOdtcJNg>
    <xmx:BjycXbf9ndDq6Bb9jeCroW3RGjP2TX0RgCDhHZwuQFRxF9IJe1oxJg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id CBD48D60057;
        Tue,  8 Oct 2019 03:34:29 -0400 (EDT)
Subject: FAILED: patch "[PATCH] tools lib traceevent: Do not free tep->cmdlines in" failed to apply to 4.19-stable tree
To:     rostedt@goodmis.org, acme@redhat.com, akpm@linux-foundation.org,
        jolsa@redhat.com, namhyung@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Oct 2019 09:34:18 +0200
Message-ID: <1570520058216250@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From b0215e2d6a18d8331b2d4a8b38ccf3eff783edb1 Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Date: Wed, 28 Aug 2019 15:05:28 -0400
Subject: [PATCH] tools lib traceevent: Do not free tep->cmdlines in
 add_new_comm() on failure

If the re-allocation of tep->cmdlines succeeds, then the previous
allocation of tep->cmdlines will be freed. If we later fail in
add_new_comm(), we must not free cmdlines, and also should assign
tep->cmdlines to the new allocation. Otherwise when freeing tep, the
tep->cmdlines will be pointing to garbage.

Fixes: a6d2a61ac653a ("tools lib traceevent: Remove some die() calls")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: linux-trace-devel@vger.kernel.org
Cc: stable@vger.kernel.org
Link: http://lkml.kernel.org/r/20190828191819.970121417@goodmis.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index b36b536a9fcb..13fd9fdf91e0 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -269,10 +269,10 @@ static int add_new_comm(struct tep_handle *tep,
 		errno = ENOMEM;
 		return -1;
 	}
+	tep->cmdlines = cmdlines;
 
 	cmdlines[tep->cmdline_count].comm = strdup(comm);
 	if (!cmdlines[tep->cmdline_count].comm) {
-		free(cmdlines);
 		errno = ENOMEM;
 		return -1;
 	}
@@ -283,7 +283,6 @@ static int add_new_comm(struct tep_handle *tep,
 		tep->cmdline_count++;
 
 	qsort(cmdlines, tep->cmdline_count, sizeof(*cmdlines), cmdline_cmp);
-	tep->cmdlines = cmdlines;
 
 	return 0;
 }

