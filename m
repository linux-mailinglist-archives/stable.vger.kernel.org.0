Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC3322466E9
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 15:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728338AbgHQNFL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 09:05:11 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:35955 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728022AbgHQNFJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Aug 2020 09:05:09 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id B75591941458;
        Mon, 17 Aug 2020 09:05:08 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 17 Aug 2020 09:05:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=CeDI8t
        xxmZEr+rulfiVCY2Dia8wZSUkX+cefFToBOu4=; b=jN3SRc1dyj0IM1/fsBJDXb
        rhDpDdRebsSKYPY//tG49z++P4LO3mPpMGLYdRqLcxf+xF+bqee/Tfp1YVqZNd1q
        MRoNbswP7uBFjYGF6IT0Qrt4xLTTVbeLdzY1h8trT+RNpAmIC8mQK1xIobTWb0C+
        AfjHS+ODM18ICtkW2vzvr+b3P4l3pZ5w+fp12hClexnaOQLnt9nlca/84yISh8lt
        eBrvDO1w5h9KL4rimZxmbCLK4peOTKOuxvs4eyHHwuqfB+pMkIfz0eYay6AqXUT2
        5K2JW4rcK9VsUYHlPmPQZ9nGvMAy2ZloHghtmHxriH1tK1MeBViapNTPWGgcIHdw
        ==
X-ME-Sender: <xms:hIA6X48Ixg1pckXcrCpTl9NqD9unBQXJMefL3dAL22muDU5VIVCnRQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtfedgheelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:hIA6Xws7zPaf1pr2D28fTldku_wq5DOAOK1NyThHx-zbxX7eznC1yQ>
    <xmx:hIA6X-BdhYFt8vDq7SkzH9nckcN3XacVxezs5xeHZ8wdbBLip66c5g>
    <xmx:hIA6X4ekgwfCf33HvfTeIj6kFVFZaS8u0Wc0CpHb1Wjp8hsTuV06Dg>
    <xmx:hIA6X0akWnbup1-tG7AfrzLQ9PoBGj5dwpNkPtLuvwpxDUivyCj8EA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id BFA9B3280060;
        Mon, 17 Aug 2020 09:05:06 -0400 (EDT)
Subject: FAILED: patch "[PATCH] s390/numa: set node distance to LOCAL_DISTANCE" failed to apply to 5.4-stable tree
To:     agordeev@linux.ibm.com, hca@linux.ibm.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 Aug 2020 15:05:26 +0200
Message-ID: <159766952617417@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 535e4fc623fab2e09a0653fc3a3e17f382ad0251 Mon Sep 17 00:00:00 2001
From: Alexander Gordeev <agordeev@linux.ibm.com>
Date: Tue, 4 Aug 2020 20:35:49 +0200
Subject: [PATCH] s390/numa: set node distance to LOCAL_DISTANCE

The node distance is hardcoded to 0, which causes a trouble
for some user-level applications. In particular, "libnuma"
expects the distance of a node to itself as LOCAL_DISTANCE.
This update removes the offending node distance override.

Cc: <stable@vger.kernel.org> # 4.4
Fixes: 3a368f742da1 ("s390/numa: add core infrastructure")
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>

diff --git a/arch/s390/include/asm/topology.h b/arch/s390/include/asm/topology.h
index fbb507504a3b..3a0ac0c7a9a3 100644
--- a/arch/s390/include/asm/topology.h
+++ b/arch/s390/include/asm/topology.h
@@ -86,12 +86,6 @@ static inline const struct cpumask *cpumask_of_node(int node)
 
 #define pcibus_to_node(bus) __pcibus_to_node(bus)
 
-#define node_distance(a, b) __node_distance(a, b)
-static inline int __node_distance(int a, int b)
-{
-	return 0;
-}
-
 #else /* !CONFIG_NUMA */
 
 #define numa_node_id numa_node_id

