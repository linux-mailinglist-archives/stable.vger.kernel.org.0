Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDD9C3A588B
	for <lists+stable@lfdr.de>; Sun, 13 Jun 2021 14:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231733AbhFMM5f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Jun 2021 08:57:35 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:59593 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231649AbhFMM5f (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Jun 2021 08:57:35 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.nyi.internal (Postfix) with ESMTP id 34ADD19409EA;
        Sun, 13 Jun 2021 08:55:34 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Sun, 13 Jun 2021 08:55:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=/8WLLY
        McQdjfgqbpw1yJgJYw78oXlcuR88yOKaMm1q4=; b=dHwm/+aMDRqdnMpMRI/+0n
        bOPhb7bw/9Y++B1J0vD43H6sO3YWeeVWtsIXVe/2LAgZjWR837mwNFSJow8uqmWB
        n5dt9zx52oBtb74EQJ6pMcQvPcObbzlq8/wHa9XQzI8kL2GDAZtt6UDJjxW4PgIa
        tyFXzBTU/WQXCe3USydRf/DfFIXZCb0ghg7Pbx5Hp7nnCEYqT8RIApV6Zzp6P3Rm
        ebwGmV8DKAkgZnyk/XYuXFcXd8UAiU7D34RVEBjDztIAB8dOUPX+aQWXNXvCLyvA
        55yWdhB3uFBrE3ul2Jz4qhpWg1gfJx54zxRtuUd3BelwF2uZkVKTK5hTGg4xP7zA
        ==
X-ME-Sender: <xms:RgDGYOBvCACU8jNruZQbov9dyvJfr9o2C-1oY5BNPIfikzN5LofcWw>
    <xme:RgDGYIj-kEI095ISHDSgsrfwsQSV9Hm7iy97k_ItsyMSKLUHLOjWDYHWkcoi1hgA2
    tLLk7w_Z8HqUg>
X-ME-Received: <xmr:RgDGYBnoKilk1kGiVM-W4pcJw4_38tIRzqizdMoraeZNsNMFo-dNGDrkaHQlsyagb4QJh9Wqj_4ovMaJWAv6zDf6g-J7hoKN>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedvfedgheelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:RgDGYMy0uv300Nhf5iST_K0mqR27gnNQ5J9u9PzY53QfiCb9GXxAQw>
    <xmx:RgDGYDQHQpcN6XMrIRnUY-Q7EmBhuBD_EtzO_ibkdgWM_6Lnv-nEsw>
    <xmx:RgDGYHZlbPaItC3wghMRoa8Q7Ni77699qkR97n_xkpVsOwsVHBg9hg>
    <xmx:RgDGYNfDs_D2dyRj8HqawvxNqy8cRWakO3xd_4LQWnocoV42NaL1Vg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 13 Jun 2021 08:55:33 -0400 (EDT)
Subject: FAILED: patch "[PATCH] RDMA/mlx5: Block FDB rules when not in switchdev mode" failed to apply to 5.4-stable tree
To:     mbloch@nvidia.com, jgg@nvidia.com, leonro@nvidia.com,
        maorg@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 13 Jun 2021 14:55:31 +0200
Message-ID: <162358893110067@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From edc0b0bccc9c80d9a44d3002dcca94984b25e7cf Mon Sep 17 00:00:00 2001
From: Mark Bloch <mbloch@nvidia.com>
Date: Mon, 7 Jun 2021 11:03:12 +0300
Subject: [PATCH] RDMA/mlx5: Block FDB rules when not in switchdev mode

Allow creating FDB steering rules only when in switchdev mode.

The only software model where a userspace application can manipulate
FDB entries is when it manages the eswitch. This is only possible in
switchdev mode where we expose a single RDMA device with representors
for all the vports that are connected to the eswitch.

Fixes: 52438be44112 ("RDMA/mlx5: Allow inserting a steering rule to the FDB")
Link: https://lore.kernel.org/r/e928ae7c58d07f104716a2a8d730963d1bd01204.1623052923.git.leonro@nvidia.com
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

diff --git a/drivers/infiniband/hw/mlx5/fs.c b/drivers/infiniband/hw/mlx5/fs.c
index 2fc6a60c4e77..f84441ff0c81 100644
--- a/drivers/infiniband/hw/mlx5/fs.c
+++ b/drivers/infiniband/hw/mlx5/fs.c
@@ -2134,6 +2134,12 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_FLOW_MATCHER_CREATE)(
 	if (err)
 		goto end;
 
+	if (obj->ns_type == MLX5_FLOW_NAMESPACE_FDB &&
+	    mlx5_eswitch_mode(dev->mdev) != MLX5_ESWITCH_OFFLOADS) {
+		err = -EINVAL;
+		goto end;
+	}
+
 	uobj->object = obj;
 	obj->mdev = dev->mdev;
 	atomic_set(&obj->usecnt, 0);

