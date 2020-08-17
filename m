Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 825D92466EC
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 15:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbgHQNFU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 09:05:20 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:53835 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728274AbgHQNFT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Aug 2020 09:05:19 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 8B944194116A;
        Mon, 17 Aug 2020 09:05:17 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 17 Aug 2020 09:05:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=TZZC7R
        saSNeFQHJzA9ZI6yM8cEQC7eKAVeFZOwrasq4=; b=AM/siEd2DWF6h+WDiALq3X
        0hb9cIdkcqeKGVVVc0i8nabH/tN740hHSCSgLz3b1wknQIEMnNZjnOk80N6K8SCD
        B4g3BnMKTwPyUwXy0yoe/W5AmEyvSZSaeLgVmsazLZ4vULGyQYGNiueAPbCXb3bV
        bgmAzETjoi2HusJZD0yU05iJTz3za8Qtu0MDEsWDY9PB/bZo0SE1xLi4sR1QPy0/
        rk4+HyjNmwMjBKkwiI+VL58aQ+0+3lhz/5Cs5lBPvIkB3fhcM3FmnOxCLsgZ93+Y
        8n2Um0nUrGNChOK0NlwnrMP83pk5SnH4abWDA/hqgGXpyRRVu3YjQ/Gv4MVYLcTg
        ==
X-ME-Sender: <xms:jYA6Xy9UpvJ6xwXELxce7M3FzrdHNDRTSh8mCiohZV3wXNsNrv48tA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtfedgheelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:jYA6XysuvmX9a_k7kXe_A4DB-rEzKKB6o3r9uRFlcXJFCs2sqscfJQ>
    <xmx:jYA6X4CieADy1q0Ci2IDxez0DtQl8I_zTZ44AHTDuI162B1pbxuskQ>
    <xmx:jYA6X6ecP6i6GIFISqjhTuiUVe90eLK0mve3HozepmRxDQx3gX8WSg>
    <xmx:jYA6X2bbKw0pqBJi_jvwkwIFbfexpXhzFGu0nT9m8gYNkL7--qWm7w>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0D51C3280059;
        Mon, 17 Aug 2020 09:05:16 -0400 (EDT)
Subject: FAILED: patch "[PATCH] s390/numa: set node distance to LOCAL_DISTANCE" failed to apply to 4.19-stable tree
To:     agordeev@linux.ibm.com, hca@linux.ibm.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 Aug 2020 15:05:27 +0200
Message-ID: <1597669527147151@kroah.com>
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

