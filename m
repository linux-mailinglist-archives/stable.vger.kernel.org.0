Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9055D309D2C
	for <lists+stable@lfdr.de>; Sun, 31 Jan 2021 15:51:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbhAaOsY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 31 Jan 2021 09:48:24 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:34843 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231891AbhAaOof (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 31 Jan 2021 09:44:35 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 660B7FDC;
        Sun, 31 Jan 2021 09:43:32 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 31 Jan 2021 09:43:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=rarQGj
        ZWXWbz+FsSLdatrjPm0FegaWopNKv3hXySBIE=; b=pmAwVeX48QqstSuFQgwpsB
        hiO+XZRbzWh89PHy6Ei0yufJRW+syW9CGyTfTp2K66od0CwqInUfYwJrBey9AQ8R
        PD6DwUCaAyP5fyXZtfeLmDeO308CgjnYLFKTuhfSY/EI5fhnne4L3M1+DOggewVL
        v/0pFc0hlp6MrY31cNrW+SO0IuawbFHiqpFa3YeucleVz7kbkA308LqHlCDW+C4o
        idHnRnp6P6FsSk367UMo8TOMv/7DK22hOQGEI8QSmXj5qccyJvC3mYLq3aLhr1rF
        OAwPqfS4YI7W9tKa6t5js9VsHfrLGB3eFz4ERuV9vcp7nljjYiUG8/jNxcazXjIA
        ==
X-ME-Sender: <xms:E8IWYJ1CPWF1DTjlT_wRAk8Wc_9WZ6H_WvpTRLBt-bnaMgntfN3rPQ>
    <xme:E8IWYAGHoEd3DuTCtByeYaiah6vaPaVhbUruUyVudxatGQ4ar_Q1SSwVacFv5TVpM
    4NNAX3mBZfPGg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeeigdeifecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    ejnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeehgefguedvheejffeiheehuedvjeefhfegvefggedvue
    dufeevgeffuedvteelueenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:E8IWYJ658AIqKzqUvx2iXxj5vomHI5XGrkyuiYjJgLFSTZ2gvPb_-Q>
    <xmx:E8IWYG1ozu3W8FShYNsPG87JP2K4RlPGgXLtqSa6Ya0WxYj4MmxAbg>
    <xmx:E8IWYMEodLnXNqC755snN1ZF8ia-y_XAjHirMz76ZtVIRc8Z3i6vUg>
    <xmx:FMIWYHMsdAI_6DGI2RbJJqcvfWmTx18WATJEz8o7IeiuJQoFF0OyuB96qVc>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id AD7261080057;
        Sun, 31 Jan 2021 09:43:31 -0500 (EST)
Subject: FAILED: patch "[PATCH] PM: hibernate: flush swap writer after marking" failed to apply to 4.9-stable tree
To:     laurentbadel@eaton.com, rafael.j.wysocki@intel.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 31 Jan 2021 15:43:21 +0100
Message-ID: <161210420119485@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From fef9c8d28e28a808274a18fbd8cc2685817fd62a Mon Sep 17 00:00:00 2001
From: Laurent Badel <laurentbadel@eaton.com>
Date: Fri, 22 Jan 2021 17:19:41 +0100
Subject: [PATCH] PM: hibernate: flush swap writer after marking
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

﻿Flush the swap writer after, not before, marking the files, to ensure the
signature is properly written.

Fixes: 6f612af57821 ("PM / Hibernate: Group swap ops")
Signed-off-by: Laurent Badel <laurentbadel@eaton.com>
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index c73f2e295167..72e33054a2e1 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -497,10 +497,10 @@ static int swap_writer_finish(struct swap_map_handle *handle,
 		unsigned int flags, int error)
 {
 	if (!error) {
-		flush_swap_writer(handle);
 		pr_info("S");
 		error = mark_swapfiles(handle, flags);
 		pr_cont("|\n");
+		flush_swap_writer(handle);
 	}
 
 	if (error)

