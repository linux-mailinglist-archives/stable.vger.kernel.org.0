Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD4420DB5F
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729522AbgF2UGF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:06:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:40566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732969AbgF2Ta2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:30:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B270D2521F;
        Mon, 29 Jun 2020 15:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444938;
        bh=YxjOEaanIKF2s27K3i4x261+HzRK38qM6YsIAFXNqrs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J+9TXstU4WSHlMkIIg7+RkjYqkBWKYCUv/1fz7ilLRK/SiCXYAOKwGnugnd0jARcw
         Sa7Bi1doqcbxoUvPsLD2WcbMBCYyA0Wz8/dl0hWdMmGtNMIvuBSz02W8Xfrh25psxj
         KVno8Xl0lHVlUNzYGNpBPDRDbVxYrs9bVPtv4/GA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.19 035/131] sch_cake: fix a few style nits
Date:   Mon, 29 Jun 2020 11:33:26 -0400
Message-Id: <20200629153502.2494656-36-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629153502.2494656-1-sashal@kernel.org>
References: <20200629153502.2494656-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.131-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.131-rc1
X-KernelTest-Deadline: 2020-07-01T15:34+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

[ Upstream commit 3f608f0c41360b11b04c763f348b712f651c8bac ]

I spotted a few nits when comparing the in-tree version of sch_cake with
the out-of-tree one: A redundant error variable declaration shadowing an
outer declaration, and an indentation alignment issue. Fix both of these.

Fixes: 046f6fd5daef ("sched: Add Common Applications Kept Enhanced (cake) qdisc")
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_cake.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index c0d92a251bcb6..d8064cb521c4c 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -2649,7 +2649,7 @@ static int cake_init(struct Qdisc *sch, struct nlattr *opt,
 	qdisc_watchdog_init(&q->watchdog, sch);
 
 	if (opt) {
-		int err = cake_change(sch, opt, extack);
+		err = cake_change(sch, opt, extack);
 
 		if (err)
 			return err;
@@ -2963,7 +2963,7 @@ static int cake_dump_class_stats(struct Qdisc *sch, unsigned long cl,
 			PUT_STAT_S32(BLUE_TIMER_US,
 				     ktime_to_us(
 					     ktime_sub(now,
-						     flow->cvars.blue_timer)));
+						       flow->cvars.blue_timer)));
 		}
 		if (flow->cvars.dropping) {
 			PUT_STAT_S32(DROP_NEXT_US,
-- 
2.25.1

