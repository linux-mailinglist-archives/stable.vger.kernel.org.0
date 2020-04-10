Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19A661A4421
	for <lists+stable@lfdr.de>; Fri, 10 Apr 2020 11:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725858AbgDJJBp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Apr 2020 05:01:45 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:41103 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725839AbgDJJBp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Apr 2020 05:01:45 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 7155C5C015E;
        Fri, 10 Apr 2020 05:01:45 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 10 Apr 2020 05:01:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=EnYyG1
        W8df9m6HhiQmvRYpmxsV1UXTW8xnJX45n/Ch0=; b=rIDuvrHrTbngmr0y2niwva
        wwxCiVF4nSWLxTq1xIRMjdQwDk35rSOTONcmzCOb27r+646g346kMEsy8lrI2lJX
        tadWhD1PrIBRwL1RVUtja23nUoi3agEY75EglvNCj/UNEAHBUM30kgVOyc8nEpan
        Pir3aOFMeEy9MLTFLJxfrTfC4FV/HufvIzQQ9BVA7wLSMKZ9c9EmaC0JscTrO35F
        vRGjdEzKUyYhm1Ghl3maVLu7TSIVYExY+o74jHDO3dU8u+hMjBkQ4RGadU1hUO07
        8GtXiaOyLPIZ2cvtAq4Z0ZmgKauXCyr5C3ottbuaoNvNiNMJjLaPUT5I4VpVPEyg
        ==
X-ME-Sender: <xms:-TWQXpuZAxa7WiimYDvpYU7BQTqIrWlLbqEm5lJ-NUmWtqalhpfWkg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrvddvgdduudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledrud
    dtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehg
    rhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:-TWQXrBbC49uBIFUhRfuDjXJxCltr3dJpSiZ9z1kbuS0Sv6KuIkCSw>
    <xmx:-TWQXkjmHXqFyVNda9o-VnGnGoVkQWbiSJoXiDRZZgIMwCMnMtg7yA>
    <xmx:-TWQXpIh2K_OK1KdHzTux5hPVGs4B0R4oX43CyMcBsU80O11a65--A>
    <xmx:-TWQXn6wDxVGZ-0ne8-TYyByKBWrq8tbcG3OZkBk75ToH_ebrlW_OA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id CE0E6306005C;
        Fri, 10 Apr 2020 05:01:44 -0400 (EDT)
Subject: FAILED: patch "[PATCH] IB/mlx5: Replace tunnel mpls capability bits for" failed to apply to 4.19-stable tree
To:     valex@mellanox.com, jgg@mellanox.com, lariel@mellanox.com,
        leonro@mellanox.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 10 Apr 2020 11:01:43 +0200
Message-ID: <1586509303211183@kroah.com>
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

From 41e684ef3f37ce6e5eac3fb5b9c7c1853f4b0447 Mon Sep 17 00:00:00 2001
From: Alex Vesker <valex@mellanox.com>
Date: Thu, 5 Mar 2020 14:38:41 +0200
Subject: [PATCH] IB/mlx5: Replace tunnel mpls capability bits for
 tunnel_offloads

Until now the flex parser capability was used in ib_query_device() to
indicate tunnel_offloads_caps support for mpls_over_gre/mpls_over_udp.

Newer devices and firmware will have configurations with the flexparser
but without mpls support.

Testing for the flex parser capability was a mistake, the tunnel_stateless
capability was intended for detecting mpls and was introduced at the same
time as the flex parser capability.

Otherwise userspace will be incorrectly informed that a future device
supports MPLS when it does not.

Link: https://lore.kernel.org/r/20200305123841.196086-1-leon@kernel.org
Cc: <stable@vger.kernel.org> # 4.17
Fixes: e818e255a58d ("IB/mlx5: Expose MPLS related tunneling offloads")
Signed-off-by: Alex Vesker <valex@mellanox.com>
Reviewed-by: Ariel Levkovich <lariel@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index eba7604eaa76..9c3993c7e9a1 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1192,12 +1192,10 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 		if (MLX5_CAP_ETH(mdev, tunnel_stateless_gre))
 			resp.tunnel_offloads_caps |=
 				MLX5_IB_TUNNELED_OFFLOADS_GRE;
-		if (MLX5_CAP_GEN(mdev, flex_parser_protocols) &
-		    MLX5_FLEX_PROTO_CW_MPLS_GRE)
+		if (MLX5_CAP_ETH(mdev, tunnel_stateless_mpls_over_gre))
 			resp.tunnel_offloads_caps |=
 				MLX5_IB_TUNNELED_OFFLOADS_MPLS_GRE;
-		if (MLX5_CAP_GEN(mdev, flex_parser_protocols) &
-		    MLX5_FLEX_PROTO_CW_MPLS_UDP)
+		if (MLX5_CAP_ETH(mdev, tunnel_stateless_mpls_over_udp))
 			resp.tunnel_offloads_caps |=
 				MLX5_IB_TUNNELED_OFFLOADS_MPLS_UDP;
 	}
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index f9bcbe653fda..f3a7189f9d6d 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -877,7 +877,11 @@ struct mlx5_ifc_per_protocol_networking_offload_caps_bits {
 	u8         swp_csum[0x1];
 	u8         swp_lso[0x1];
 	u8         cqe_checksum_full[0x1];
-	u8         reserved_at_24[0x5];
+	u8         tunnel_stateless_geneve_tx[0x1];
+	u8         tunnel_stateless_mpls_over_udp[0x1];
+	u8         tunnel_stateless_mpls_over_gre[0x1];
+	u8         tunnel_stateless_vxlan_gpe[0x1];
+	u8         tunnel_stateless_ipv4_over_vxlan[0x1];
 	u8         tunnel_stateless_ip_over_ip[0x1];
 	u8         reserved_at_2a[0x6];
 	u8         max_vxlan_udp_ports[0x8];

