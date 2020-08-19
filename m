Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A223249DD5
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 14:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728063AbgHSM2x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 08:28:53 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:48117 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727986AbgHSM2v (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 08:28:51 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 656D9A39;
        Wed, 19 Aug 2020 08:28:50 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 19 Aug 2020 08:28:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=0URN/o
        489LHyEW09+EPIWCL/wRb2bz1eQCaQeeUs2nE=; b=ct0cxvHALS7Vs/fJeERolV
        NvdDJxLCVYU6xFRJGFh2hgq5u+yjiHUFSXdgEN+TFih7GoNBO+FcY7AMbfda5pdi
        sqUFJGOEpVEvvzkdxS47eigrC+R6pTutzmPd9JId+vvLJPFOWwRWQt/y4q22Ad7e
        E8unBy6IYaO2gkxQ8b36OJtUxgUUZs1l4M7sl7Exif8kiLW/HJ43VCnIvNuvvnLM
        e+2ysxqzoBV/Zhi+Eoe9WrMn8ytfeqbh7N+6Tw7WalAeNOQhDBmzftfoUyNjJiPG
        EiOGyqZUIibwFQORNuXC7b/I7UkYfoSxG1qiTsnMOUgTH1zi6vV5kIhoN/Z7Qo2Q
        ==
X-ME-Sender: <xms:ARs9X4qPA2-MN_hdmLBAbfPUhuPUfFPQteNGzXeEr-RpIQ-Jr4Xj9A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtkedgfeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:ARs9X-o1qL4a7X07w7mmjt6GjAJWXjCVXoA5I4hyamf0tosYteqQcg>
    <xmx:ARs9X9OIJ-Xlpn_1ccNHlvZzF_e6taRa20-bjQvB55ljeivXnt0K5g>
    <xmx:ARs9X_4_Kng06H7x8JbCJZ1lYhUls0eHK4WuG5TLcMVLGivtu-vXJw>
    <xmx:Ahs9X0jN3xM0tc1lyQJFb1Qoy_VtyBaXAtAQ3xDI8FrPLtbDC7r3xcsJz1U>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5888430600B7;
        Wed, 19 Aug 2020 08:28:49 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ftrace: Setup correct FTRACE_FL_REGS flags for module" failed to apply to 4.4-stable tree
To:     zhouchengming@bytedance.com, rostedt@goodmis.org,
        songmuchun@bytedance.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 19 Aug 2020 14:29:11 +0200
Message-ID: <159784015193138@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8a224ffb3f52b0027f6b7279854c71a31c48fc97 Mon Sep 17 00:00:00 2001
From: Chengming Zhou <zhouchengming@bytedance.com>
Date: Wed, 29 Jul 2020 02:05:53 +0800
Subject: [PATCH] ftrace: Setup correct FTRACE_FL_REGS flags for module

When module loaded and enabled, we will use __ftrace_replace_code
for module if any ftrace_ops referenced it found. But we will get
wrong ftrace_addr for module rec in ftrace_get_addr_new, because
rec->flags has not been setup correctly. It can cause the callback
function of a ftrace_ops has FTRACE_OPS_FL_SAVE_REGS to be called
with pt_regs set to NULL.
So setup correct FTRACE_FL_REGS flags for rec when we call
referenced_filters to find ftrace_ops references it.

Link: https://lkml.kernel.org/r/20200728180554.65203-1-zhouchengming@bytedance.com

Cc: stable@vger.kernel.org
Fixes: 8c4f3c3fa9681 ("ftrace: Check module functions being traced on reload")
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index c141d347f71a..d052f856f1cf 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -6198,8 +6198,11 @@ static int referenced_filters(struct dyn_ftrace *rec)
 	int cnt = 0;
 
 	for (ops = ftrace_ops_list; ops != &ftrace_list_end; ops = ops->next) {
-		if (ops_references_rec(ops, rec))
-		    cnt++;
+		if (ops_references_rec(ops, rec)) {
+			cnt++;
+			if (ops->flags & FTRACE_OPS_FL_SAVE_REGS)
+				rec->flags |= FTRACE_FL_REGS;
+		}
 	}
 
 	return cnt;
@@ -6378,8 +6381,8 @@ void ftrace_module_enable(struct module *mod)
 		if (ftrace_start_up)
 			cnt += referenced_filters(rec);
 
-		/* This clears FTRACE_FL_DISABLED */
-		rec->flags = cnt;
+		rec->flags &= ~FTRACE_FL_DISABLED;
+		rec->flags += cnt;
 
 		if (ftrace_start_up && cnt) {
 			int failed = __ftrace_replace_code(rec, 1);

