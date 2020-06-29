Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D86E20D983
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387538AbgF2TsZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:48:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:47666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387784AbgF2Tkj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:40:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C9552483D;
        Mon, 29 Jun 2020 15:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444351;
        bh=jNkYSjwbnE1szYQtsX4wcYlRGkclymmGDzn1KMTTJA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S6EBLhM6IKG3lzPbYTkQz2cnuWixIbSQpRjtVgpd6HkfYPvO5ofIK1m3OIqXV7+yO
         x+PGSAmyqasVUJBT+yfgRiEPsZp3EeZA8hX4A+unOzEbxQ45hjzD0pQkzMc80TVEcy
         arJ8/bCkJgZS8xJs4GBaTDBY1TORLPxua2X3OmGE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.4 026/178] sch_cake: fix a few style nits
Date:   Mon, 29 Jun 2020 11:22:51 -0400
Message-Id: <20200629152523.2494198-27-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629152523.2494198-1-sashal@kernel.org>
References: <20200629152523.2494198-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.50-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.50-rc1
X-KernelTest-Deadline: 2020-07-01T15:25+00:00
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
index e1b93ff79ab53..5d605bab9afcb 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -2703,7 +2703,7 @@ static int cake_init(struct Qdisc *sch, struct nlattr *opt,
 	qdisc_watchdog_init(&q->watchdog, sch);
 
 	if (opt) {
-		int err = cake_change(sch, opt, extack);
+		err = cake_change(sch, opt, extack);
 
 		if (err)
 			return err;
@@ -3020,7 +3020,7 @@ static int cake_dump_class_stats(struct Qdisc *sch, unsigned long cl,
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

