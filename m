Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57016377629
	for <lists+stable@lfdr.de>; Sun,  9 May 2021 12:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbhEIKKS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 May 2021 06:10:18 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:47015 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229555AbhEIKKS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 May 2021 06:10:18 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.west.internal (Postfix) with ESMTP id EC9D11A02;
        Sun,  9 May 2021 06:09:14 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 09 May 2021 06:09:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=+W21hs
        dpGIidm8uTVBuxFcJOCEboF1UZr5zIf8TibM4=; b=SYkcvFcS9cTD0pS7q/w1sh
        WwKjfGXxFzk1a6QqaEz3S0Xibk4EFKTJ6BJARRtq9poAaB95i1YQnd23sxBkqcgb
        UrfLU8tfqPk1RZIDqx2tZSCxvOQHi7tkkAuWU7r5uPxXyaFEdWOqbz9FaViJ2G+r
        TPx9xlrrKqFhuxHKM7s7WINsllJMy2wqY9xRI3D1gct4nCqzrgZ/OoT81LrtbEXx
        Tpqz2L9sV2lFYrVUU7nePx2uQK56sLjjtj+i6xhudflrL4Cbinit5KtmxQXSCpah
        O8Xl6AjA169w71hsKocI7rh3kAleYtFatZbSlj7S7ObjGSQWeF2V51nmfoP5GkFQ
        ==
X-ME-Sender: <xms:yrSXYD50_8Ev7RBUBuM4dlAXV2vhFc8MGskDtYNaaCOzWmVqtyLQ4g>
    <xme:yrSXYI5OUlH7W4MobanrL536BpP49WwcrPLu0hmgHmV9ubG5XAj_6_rrUzh0ZybzY
    w9bw0rI8V8ZDA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegiedgvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:yrSXYKde5xgxkX4gwKsDh5njppYlHFgqjAtkzIcn9gGl0RStPs7JTQ>
    <xmx:yrSXYELDZNLGYSlWrNzcOejkH3Nb8EQKEEeuWeZP75q06wulduCB5A>
    <xmx:yrSXYHIzcJWzGMNPfZtdN1vT3b0fDg-1oEWnVStU0dkewWZG66Vz0Q>
    <xmx:yrSXYJwJDXk8AIZKHwQLhwZdIdULnZi7sVIlV7_jxrjVV1QAMrfJRQODRmk>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sun,  9 May 2021 06:09:13 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ubifs: Only check replay with inode type to judge if inode" failed to apply to 4.9-stable tree
To:     guochun.mao@mediatek.com, richard@nod.at
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 May 2021 12:09:12 +0200
Message-ID: <162055495264177@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From 3e903315790baf4a966436e7f32e9c97864570ac Mon Sep 17 00:00:00 2001
From: Guochun Mao <guochun.mao@mediatek.com>
Date: Tue, 16 Mar 2021 16:52:14 +0800
Subject: [PATCH] ubifs: Only check replay with inode type to judge if inode
 linked

Conside the following case, it just write a big file into flash,
when complete writing, delete the file, and then power off promptly.
Next time power on, we'll get a replay list like:
...
LEB 1105:211344 len 4144 deletion 0 sqnum 428783 key type 1 inode 80
LEB 15:233544 len 160 deletion 1 sqnum 428785 key type 0 inode 80
LEB 1105:215488 len 4144 deletion 0 sqnum 428787 key type 1 inode 80
...
In the replay list, data nodes' deletion are 0, and the inode node's
deletion is 1. In current logic, the file's dentry will be removed,
but inode and the flash space it occupied will be reserved.
User will see that much free space been disappeared.

We only need to check the deletion value of the following inode type
node of the replay entry.

Fixes: e58725d51fa8 ("ubifs: Handle re-linking of inodes correctly while recovery")
Cc: stable@vger.kernel.org
Signed-off-by: Guochun Mao <guochun.mao@mediatek.com>
Signed-off-by: Richard Weinberger <richard@nod.at>

diff --git a/fs/ubifs/replay.c b/fs/ubifs/replay.c
index 0f8a6a16421b..1929ec63a0cb 100644
--- a/fs/ubifs/replay.c
+++ b/fs/ubifs/replay.c
@@ -223,7 +223,8 @@ static bool inode_still_linked(struct ubifs_info *c, struct replay_entry *rino)
 	 */
 	list_for_each_entry_reverse(r, &c->replay_list, list) {
 		ubifs_assert(c, r->sqnum >= rino->sqnum);
-		if (key_inum(c, &r->key) == key_inum(c, &rino->key))
+		if (key_inum(c, &r->key) == key_inum(c, &rino->key) &&
+		    key_type(c, &r->key) == UBIFS_INO_KEY)
 			return r->deletion == 0;
 
 	}

