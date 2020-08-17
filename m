Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 417D52466EB
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 15:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728367AbgHQNFR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 09:05:17 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:39497 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728022AbgHQNFQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Aug 2020 09:05:16 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 42EFF1941455;
        Mon, 17 Aug 2020 09:05:15 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 17 Aug 2020 09:05:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=4rypzJ
        +mDGrK7m2RE8cnr1KL9xAb3UHmi+DHjuNqPLw=; b=OEUeUTrtZS1uUWNA4nqTBa
        Bzq3pyWv/TieFk1bdWBxqjZSi3M7fdfhkf0MWMRbkiqyDk1NxCfjEmoISWGNa0jo
        BAhe820Z/f/qgZMtGAmeZWBPP9pxaTyCUL+DvCn6xK1xS3BiBAr+UMNdyT5vf+EE
        xaYyrJXzC4qUI6FkOvakGN6K+UEpiVy8POAxe5gPMQ7ZHNYuU1BoYRHB9rprnLlR
        eIKmpOH1a8eS23a+YVYzwk6LfQmeGinbQ6AP+Pghm2MaMnAME24MbZPotak51ecj
        o++3zrcVROqTyEjn4zPszslJk3dgTILBE0RynAWef4w92n0Oa63nvSToemzhXerg
        ==
X-ME-Sender: <xms:i4A6X9123biCbNiknUzLLwYlOcKs720Z3U9lQWVvRqkpZt_-eFhwaw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtfedgheelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:i4A6X0FGyDAVhAEfJVGo3d5cMyHiqiIwniLlwjNciO0KbjFCiyat6A>
    <xmx:i4A6X96nsM3r-phpO2HhVTG014sCPi2ZZDynmv1NucuM5W0B-kJ-Uw>
    <xmx:i4A6X61ZlNS_7TwAzBKFcqzC5TaRCSoM5wRePfCx1yZTtnOalkT97Q>
    <xmx:i4A6XzygnKPB_TfGxXvUFW8eAcwKzo9h8c4Nt3Nc5CZyDd0wYJiU-g>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C69DB328005D;
        Mon, 17 Aug 2020 09:05:14 -0400 (EDT)
Subject: FAILED: patch "[PATCH] s390/numa: set node distance to LOCAL_DISTANCE" failed to apply to 4.14-stable tree
To:     agordeev@linux.ibm.com, hca@linux.ibm.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 Aug 2020 15:05:27 +0200
Message-ID: <1597669527198152@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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

