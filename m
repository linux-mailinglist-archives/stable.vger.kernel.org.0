Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95AF036353E
	for <lists+stable@lfdr.de>; Sun, 18 Apr 2021 14:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236966AbhDRMay (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Apr 2021 08:30:54 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:34369 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236909AbhDRMax (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Apr 2021 08:30:53 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id C316C1B92;
        Sun, 18 Apr 2021 08:30:24 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 18 Apr 2021 08:30:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=gWGeGH
        1o2MqOcgdV81qWppKF6XDjoiO6CUX3CUzb3gM=; b=Pi2USxnhfbHubKbVY93nM+
        rkjql4H5L+czHcuqgw4QC9q6/GEvv6PsL08v9LOVU03Pl78Kg87hRYtvKAKSXVQz
        s/ZDrAG6O/jEHA4kCkMTfJhYFvNXfotRpd7E9mZ3cTN4qvu0lxC8zngui9c4+BfZ
        Ia8D5VV/T7exS0RfFQhXifhYe+0bKTd6TNaMYYfolXMAnTE6bjFd0B7OCwld8wz2
        ao9dtnTNN4znenuocJc6AqDJFpRD3Stfc32GBCH4DP7g+3eZxAZqSYCPQwlT60mr
        GgqZIxCIaVvkGZXOPLiKPVo7zgRi/7qRGcLv5Cr2qZKQpO3iulgkrYI9Y0BIUurQ
        ==
X-ME-Sender: <xms:YCZ8YAIPqSqHQkVBdN_Wzr44tm68gbGyAbb94LB4kMetPuGxqw_uBg>
    <xme:YCZ8YAJMRefkCJkMrqbxczM6ZXUzifJHOKp-39_isiC7octB1qETmnbG37soZwkkH
    C_2vVoIm4v12A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudelkedgkeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:YCZ8YAuBA4DwizBl2TbNedKJOxO2qQlC98IuQlwVvppZs7v978s9nw>
    <xmx:YCZ8YNY_dWzikYPrHQUOWMgyST2gz9LvNVFWygpbqUstm4ECic5k4g>
    <xmx:YCZ8YHY20i7tEqgOLTtqck3uEzEkvPvYkevuLizP41bJvH3Cyr8nuQ>
    <xmx:YCZ8YGUS79PNHZFrGqms3ghNKY_Nm07x7-hRfelMkpDScNeq12n2p5QaoPo>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 007EE240054;
        Sun, 18 Apr 2021 08:30:23 -0400 (EDT)
Subject: FAILED: patch "[PATCH] gro: ensure frag0 meets IP header alignment" failed to apply to 4.19-stable tree
To:     edumazet@google.com, davem@davemloft.net, jasowang@redhat.com,
        linux@roeck-us.net, mst@redhat.com, xuanzhuo@linux.alibaba.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 18 Apr 2021 14:30:18 +0200
Message-ID: <1618749018155126@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From 38ec4944b593fd90c5ef42aaaa53e66ae5769d04 Mon Sep 17 00:00:00 2001
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 13 Apr 2021 05:41:35 -0700
Subject: [PATCH] gro: ensure frag0 meets IP header alignment

After commit 0f6925b3e8da ("virtio_net: Do not pull payload in skb->head")
Guenter Roeck reported one failure in his tests using sh architecture.

After much debugging, we have been able to spot silent unaligned accesses
in inet_gro_receive()

The issue at hand is that upper networking stacks assume their header
is word-aligned. Low level drivers are supposed to reserve NET_IP_ALIGN
bytes before the Ethernet header to make that happen.

This patch hardens skb_gro_reset_offset() to not allow frag0 fast-path
if the fragment is not properly aligned.

Some arches like x86, arm64 and powerpc do not care and define NET_IP_ALIGN
as 0, this extra check will be a NOP for them.

Note that if frag0 is not used, GRO will call pskb_may_pull()
as many times as needed to pull network and transport headers.

Fixes: 0f6925b3e8da ("virtio_net: Do not pull payload in skb->head")
Fixes: 78a478d0efd9 ("gro: Inline skb_gro_header and cache frag0 virtual address")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Guenter Roeck <linux@roeck-us.net>
Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/net/core/dev.c b/net/core/dev.c
index af8c1ea040b9..1f79b9aa9a3f 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5924,7 +5924,8 @@ static void skb_gro_reset_offset(struct sk_buff *skb)
 	NAPI_GRO_CB(skb)->frag0_len = 0;
 
 	if (!skb_headlen(skb) && pinfo->nr_frags &&
-	    !PageHighMem(skb_frag_page(frag0))) {
+	    !PageHighMem(skb_frag_page(frag0)) &&
+	    (!NET_IP_ALIGN || !(skb_frag_off(frag0) & 3))) {
 		NAPI_GRO_CB(skb)->frag0 = skb_frag_address(frag0);
 		NAPI_GRO_CB(skb)->frag0_len = min_t(unsigned int,
 						    skb_frag_size(frag0),

