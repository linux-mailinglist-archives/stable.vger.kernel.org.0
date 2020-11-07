Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83F102AA659
	for <lists+stable@lfdr.de>; Sat,  7 Nov 2020 16:38:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726053AbgKGPi6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Nov 2020 10:38:58 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:49457 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726060AbgKGPi6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Nov 2020 10:38:58 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id BB47DED1;
        Sat,  7 Nov 2020 10:38:56 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sat, 07 Nov 2020 10:38:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=tzcRRw
        q9gi3B1RsTEyLlm2zRz8olgrdx855GYOfTjXE=; b=cuSfSNChTmqTWvdkWV8FTT
        VZ1aR0F+IHl1MHnxGlGIqWw7x0mo7DWQM9Oi0XxszU3871HTqYDMSwOrURaV5T2a
        kjNwvxw2sEV1Qe+sP7ZZUVdTG2tjPomHmYcYZCQpWJEgDQ7b6bVaBqlTVPGrJ52r
        ChGUOqAK19Z9P2OIl8pJOVxOghQw0VneSsz9Yk/Tl4gy6D5ZsGQ5iyncuKlCP9We
        9SAgL8fcQ8Xi22Psn5+nouj3gRphyrruSyxFik2Lb0lmARHmHHbTW0uNQ+St/pbJ
        1Bl539eu5Js6CYX13J43vpmqB5dNXBFVHhDQmX0yDKxx6oFHLoH5UABqHvS5tn9Q
        ==
X-ME-Sender: <xms:j7-mXwm9r5NbqQMDaNC_bOuDJyRcddSoABXw2TLMHBQAOIHRZwp43g>
    <xme:j7-mX_2u6x_pbu2BUgDN-vd1LddQvCWlbXnqHSZ4Kpb0KHfKRoVAYTugVve4Pn8fM
    LmPGxfO50Rnwg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudduuddgkedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnheptedvveduiefhtefggfduffefkedvhfevgefhvddthf
    etfeekveffudetffegkeeinecuffhomhgrihhnpehophgvnhhsuhhsvgdrohhrghdpkhgv
    rhhnvghlrdhorhhgnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:j7-mX-onLQVVHc8rcUQCn1AHT7JwkygiWng4XdzXoMVQCzLpDGSe0w>
    <xmx:j7-mX8mmscKBoiZtgjmp4X7npl-pU18DhEHyNcQgzgxpeO7KCykK8g>
    <xmx:j7-mX-1dDM25aeJcAWCyL0ecWWIWqJ94kq_AUS5H56gcrOu89d8f0A>
    <xmx:kL-mX3nyQg-cKNH2jNqR1rElXr4RbVn0uoKiXvPMXbxg0d6tT6ghDRSymGA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 20F4B3280414;
        Sat,  7 Nov 2020 10:38:55 -0500 (EST)
Subject: FAILED: patch "[PATCH] mm: memcg: link page counters to root if use_hierarchy is" failed to apply to 5.9-stable tree
To:     guro@fb.com, akpm@linux-foundation.org, hannes@cmpxchg.org,
        ltp@lists.linux.it, mhocko@kernel.org, mkoutny@suse.com,
        rpalethorpe@suse.com, shakeelb@google.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 07 Nov 2020 16:39:37 +0100
Message-ID: <1604763577148237@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8de15e920dc85d1705ab9c202c95d56845bc2d48 Mon Sep 17 00:00:00 2001
From: Roman Gushchin <guro@fb.com>
Date: Sun, 1 Nov 2020 17:07:34 -0800
Subject: [PATCH] mm: memcg: link page counters to root if use_hierarchy is
 false
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Richard reported a warning which can be reproduced by running the LTP
madvise6 test (cgroup v1 in the non-hierarchical mode should be used):

  WARNING: CPU: 0 PID: 12 at mm/page_counter.c:57 page_counter_uncharge (mm/page_counter.c:57 mm/page_counter.c:50 mm/page_counter.c:156)
  Modules linked in:
  CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 5.9.0-rc7-22-default #77
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.13.0-48-gd9c812d-rebuilt.opensuse.org 04/01/2014
  Workqueue: events drain_local_stock
  RIP: 0010:page_counter_uncharge (mm/page_counter.c:57 mm/page_counter.c:50 mm/page_counter.c:156)
  Call Trace:
    __memcg_kmem_uncharge (mm/memcontrol.c:3022)
    drain_obj_stock (./include/linux/rcupdate.h:689 mm/memcontrol.c:3114)
    drain_local_stock (mm/memcontrol.c:2255)
    process_one_work (./arch/x86/include/asm/jump_label.h:25 ./include/linux/jump_label.h:200 ./include/trace/events/workqueue.h:108 kernel/workqueue.c:2274)
    worker_thread (./include/linux/list.h:282 kernel/workqueue.c:2416)
    kthread (kernel/kthread.c:292)
    ret_from_fork (arch/x86/entry/entry_64.S:300)

The problem occurs because in the non-hierarchical mode non-root page
counters are not linked to root page counters, so the charge is not
propagated to the root memory cgroup.

After the removal of the original memory cgroup and reparenting of the
object cgroup, the root cgroup might be uncharged by draining a objcg
stock, for example.  It leads to an eventual underflow of the charge and
triggers a warning.

Fix it by linking all page counters to corresponding root page counters
in the non-hierarchical mode.

Please note, that in the non-hierarchical mode all objcgs are always
reparented to the root memory cgroup, even if the hierarchy has more
than 1 level.  This patch doesn't change it.

The patch also doesn't affect how the hierarchical mode is working,
which is the only sane and truly supported mode now.

Thanks to Richard for reporting, debugging and providing an alternative
version of the fix!

Fixes: bf4f059954dc ("mm: memcg/slab: obj_cgroup API")
Reported-by: <ltp@lists.linux.it>
Signed-off-by: Roman Gushchin <guro@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Michal Koutný <mkoutny@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20201026231326.3212225-1-guro@fb.com
Debugged-by: Richard Palethorpe <rpalethorpe@suse.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c3b6dc7d5c94..3dcbf24d2227 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5345,17 +5345,22 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 		memcg->swappiness = mem_cgroup_swappiness(parent);
 		memcg->oom_kill_disable = parent->oom_kill_disable;
 	}
-	if (parent && parent->use_hierarchy) {
+	if (!parent) {
+		page_counter_init(&memcg->memory, NULL);
+		page_counter_init(&memcg->swap, NULL);
+		page_counter_init(&memcg->kmem, NULL);
+		page_counter_init(&memcg->tcpmem, NULL);
+	} else if (parent->use_hierarchy) {
 		memcg->use_hierarchy = true;
 		page_counter_init(&memcg->memory, &parent->memory);
 		page_counter_init(&memcg->swap, &parent->swap);
 		page_counter_init(&memcg->kmem, &parent->kmem);
 		page_counter_init(&memcg->tcpmem, &parent->tcpmem);
 	} else {
-		page_counter_init(&memcg->memory, NULL);
-		page_counter_init(&memcg->swap, NULL);
-		page_counter_init(&memcg->kmem, NULL);
-		page_counter_init(&memcg->tcpmem, NULL);
+		page_counter_init(&memcg->memory, &root_mem_cgroup->memory);
+		page_counter_init(&memcg->swap, &root_mem_cgroup->swap);
+		page_counter_init(&memcg->kmem, &root_mem_cgroup->kmem);
+		page_counter_init(&memcg->tcpmem, &root_mem_cgroup->tcpmem);
 		/*
 		 * Deeper hierachy with use_hierarchy == false doesn't make
 		 * much sense so let cgroup subsystem know about this

