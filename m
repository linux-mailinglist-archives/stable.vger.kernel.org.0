Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC07C2F0E8A
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 09:51:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728061AbhAKIvO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 03:51:14 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:55847 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728024AbhAKIvO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 03:51:14 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 131CBFBE;
        Mon, 11 Jan 2021 03:50:06 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 11 Jan 2021 03:50:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=mQYsFm
        deAa8BfylwjTM9uhmJNQZGzolCxROANIIpaDY=; b=TCBSoxfxOakiYZNsXzlrAz
        R7clvdRkhmW29CAd7IvLmZmu8u68IDJZTt5EFoBzA88uZ3hUTYJIfUFV/HOA1jGX
        RcFvtcmCjNrpy3IT0qmx9myA0gxWGSaSg/grcPSPaIdrjSqsGOtSxLg5PoMRyfyT
        FcYx1wGp63LnBQ2Uct2RYhcWm4rc0DJL63WFOWWE6XWUwI/mgJWdbx2sYzdhQtWS
        Vh8WgwBak3McuGwk3l2dLLK4qENcsF7UCvp+GjaG8uCEntg4j9HyotC6M4egiAxB
        irhdrOQ1BGVWIWJzXWuOxpGmE2BiGNyg13Z8PfTlBSIUXwffJ+uosjNnVpfh+eAQ
        ==
X-ME-Sender: <xms:PRH8X2hP4YO8ohplM6iiPw_MgIDzPv0YkllCJhYPZg7oofRhrH6TYQ>
    <xme:PRH8X3BbHEDjEs-zMdaTju_B_fpTJZ8MQ0fQMEqC7mqrh8S_4Me4q1tbdZJ9LfR9Y
    tJ9C1XQy5Jmew>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdehtddguddvudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushht
    vghrufhiiigvpeegnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:PRH8X-Hm2Shk1LuackI23kkAJ_-Pfgtr5Nwr1wNBAzLlo_J-tS9wUg>
    <xmx:PRH8X_TfhGTaLWPh1m7r6FEZP_iAjpsetCog5901lTvEC--xu7BWlg>
    <xmx:PRH8XzxX_HakEm2Mx-j-N9Uh1muOatUga39yL8C8L-Fgc-nm4isGrQ>
    <xmx:PhH8X8p11IGXYGeC7gk6xkOkaw6O8KprVglC63n4wCUBcqivkFIkm2sF_n0>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id A915824005C;
        Mon, 11 Jan 2021 03:50:05 -0500 (EST)
Subject: FAILED: patch "[PATCH] blk-iocost: fix NULL iocg deref from racing against" failed to apply to 5.4-stable tree
To:     tj@kernel.org, axboe@kernel.dk, bsd@fb.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Jan 2021 09:51:18 +0100
Message-ID: <1610355078186128@kroah.com>
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

From d16baa3f1453c14d680c5fee01cd122a22d0e0ce Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Tue, 5 Jan 2021 12:37:23 -0500
Subject: [PATCH] blk-iocost: fix NULL iocg deref from racing against
 initialization

When initializing iocost for a queue, its rqos should be registered before
the blkcg policy is activated to allow policy data initiailization to lookup
the associated ioc. This unfortunately means that the rqos methods can be
called on bios before iocgs are attached to all existing blkgs.

While the race is theoretically possible on ioc_rqos_throttle(), it mostly
happened in ioc_rqos_merge() due to the difference in how they lookup ioc.
The former determines it from the passed in @rqos and then bails before
dereferencing iocg if the looked up ioc is disabled, which most likely is
the case if initialization is still in progress. The latter looked up ioc by
dereferencing the possibly NULL iocg making it a lot more prone to actually
triggering the bug.

* Make ioc_rqos_merge() use the same method as ioc_rqos_throttle() to look
  up ioc for consistency.

* Make ioc_rqos_throttle() and ioc_rqos_merge() test for NULL iocg before
  dereferencing it.

* Explain the danger of NULL iocgs in blk_iocost_init().

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Jonathan Lemon <bsd@fb.com>
Cc: stable@vger.kernel.org # v5.4+
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index ac6078a34939..98d656bdb42b 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2551,8 +2551,8 @@ static void ioc_rqos_throttle(struct rq_qos *rqos, struct bio *bio)
 	bool use_debt, ioc_locked;
 	unsigned long flags;
 
-	/* bypass IOs if disabled or for root cgroup */
-	if (!ioc->enabled || !iocg->level)
+	/* bypass IOs if disabled, still initializing, or for root cgroup */
+	if (!ioc->enabled || !iocg || !iocg->level)
 		return;
 
 	/* calculate the absolute vtime cost */
@@ -2679,14 +2679,14 @@ static void ioc_rqos_merge(struct rq_qos *rqos, struct request *rq,
 			   struct bio *bio)
 {
 	struct ioc_gq *iocg = blkg_to_iocg(bio->bi_blkg);
-	struct ioc *ioc = iocg->ioc;
+	struct ioc *ioc = rqos_to_ioc(rqos);
 	sector_t bio_end = bio_end_sector(bio);
 	struct ioc_now now;
 	u64 vtime, abs_cost, cost;
 	unsigned long flags;
 
-	/* bypass if disabled or for root cgroup */
-	if (!ioc->enabled || !iocg->level)
+	/* bypass if disabled, still initializing, or for root cgroup */
+	if (!ioc->enabled || !iocg || !iocg->level)
 		return;
 
 	abs_cost = calc_vtime_cost(bio, iocg, true);
@@ -2863,6 +2863,12 @@ static int blk_iocost_init(struct request_queue *q)
 	ioc_refresh_params(ioc, true);
 	spin_unlock_irq(&ioc->lock);
 
+	/*
+	 * rqos must be added before activation to allow iocg_pd_init() to
+	 * lookup the ioc from q. This means that the rqos methods may get
+	 * called before policy activation completion, can't assume that the
+	 * target bio has an iocg associated and need to test for NULL iocg.
+	 */
 	rq_qos_add(q, rqos);
 	ret = blkcg_activate_policy(q, &blkcg_policy_iocost);
 	if (ret) {

