Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F40D363513
	for <lists+stable@lfdr.de>; Sun, 18 Apr 2021 14:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbhDRMSO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Apr 2021 08:18:14 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:44013 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230096AbhDRMSO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Apr 2021 08:18:14 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id EBA5E1B06;
        Sun, 18 Apr 2021 08:17:45 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 18 Apr 2021 08:17:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ij0Wy5
        7tithaL2lmch41y6GBgbul3lVqoPmFYojw0Ww=; b=TNuD33tTmee35sU2ZUxHoo
        bz/vBul8iqRfKMmNwvxo/ndin039C0x2vu/kEipqMr5x441/MvDYpMYL5csZBa8t
        wEPxjOaRojkTrWvuKbiwiVUJgqL/fiQH2cqqdhJidm9GIPWzQ5DasG3pOidh+b2A
        KR29hsh1AnuTklvuXVn7oScgWFzcKvQXWS8gzFOJx/Db3Av2xUA6x2GfIVeQDQrG
        0memiiRf9Gry+HfQIZPB71mDBhK4QuRZoPWr4ncOfWh1h1YaJjYpPVM4c/WblQo9
        fC5pZ8eyMLOJOS6hq6NyQoIAWNi6Yf/8Qk2mRBdlh6cCoUwIkF2yNj6q/QEBadZw
        ==
X-ME-Sender: <xms:aSN8YI0IJfdHjRFPn5SJHPBJqDe7FWSsaDZ_lcSfSqGaGvnSUkrGVw>
    <xme:aSN8YDFuZfAKOu7cXvw8AJWgfHitQRloQOd4DLpuRSIOU7pe4o32KJNnzPks5wlHZ
    nmMsALRm62log>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudelkedgkeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepgeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:aSN8YA5JvIarYGuBG8txr9jEXHw_Y15njzGhpzn7ap4RUBWSghSuSQ>
    <xmx:aSN8YB0bmUlQAg1TBKzAYVXy7Ay9Hz6D4zRji2GGmkdvu3afwmPgug>
    <xmx:aSN8YLFdjEXYxfkBmg-cbLMZVCuJTSyq8uZzR1xua6n46OkvgI1mAQ>
    <xmx:aSN8YOM5-LgpinBsUlEOQfoC3jMJxe6LIXMb0sHxSj5-xq3niTyIsYIirj4>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 13D5C240054;
        Sun, 18 Apr 2021 08:17:44 -0400 (EDT)
Subject: FAILED: patch "[PATCH] net: sit: Unregister catch-all devices" failed to apply to 4.4-stable tree
To:     hristo@venev.name, davem@davemloft.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 18 Apr 2021 14:17:43 +0200
Message-ID: <161874826328174@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From 610f8c0fc8d46e0933955ce13af3d64484a4630a Mon Sep 17 00:00:00 2001
From: Hristo Venev <hristo@venev.name>
Date: Mon, 12 Apr 2021 20:41:16 +0300
Subject: [PATCH] net: sit: Unregister catch-all devices

A sit interface created without a local or a remote address is linked
into the `sit_net::tunnels_wc` list of its original namespace. When
deleting a network namespace, delete the devices that have been moved.

The following script triggers a null pointer dereference if devices
linked in a deleted `sit_net` remain:

    for i in `seq 1 30`; do
        ip netns add ns-test
        ip netns exec ns-test ip link add dev veth0 type veth peer veth1
        ip netns exec ns-test ip link add dev sit$i type sit dev veth0
        ip netns exec ns-test ip link set dev sit$i netns $$
        ip netns del ns-test
    done
    for i in `seq 1 30`; do
        ip link del dev sit$i
    done

Fixes: 5e6700b3bf98f ("sit: add support of x-netns")
Signed-off-by: Hristo Venev <hristo@venev.name>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 63ccd9f2dccc..9fdccf0718b5 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -1867,9 +1867,9 @@ static void __net_exit sit_destroy_tunnels(struct net *net,
 		if (dev->rtnl_link_ops == &sit_link_ops)
 			unregister_netdevice_queue(dev, head);
 
-	for (prio = 1; prio < 4; prio++) {
+	for (prio = 0; prio < 4; prio++) {
 		int h;
-		for (h = 0; h < IP6_SIT_HASH_SIZE; h++) {
+		for (h = 0; h < (prio ? IP6_SIT_HASH_SIZE : 1); h++) {
 			struct ip_tunnel *t;
 
 			t = rtnl_dereference(sitn->tunnels[prio][h]);

