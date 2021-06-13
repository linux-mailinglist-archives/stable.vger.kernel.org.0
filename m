Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 598AE3A58A4
	for <lists+stable@lfdr.de>; Sun, 13 Jun 2021 15:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231667AbhFMNJ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Jun 2021 09:09:59 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:52525 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231286AbhFMNJ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Jun 2021 09:09:59 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.nyi.internal (Postfix) with ESMTP id CCA091940B07;
        Sun, 13 Jun 2021 09:07:57 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Sun, 13 Jun 2021 09:07:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Q913Og
        Q7iVEcKXMM4SOc7ZHuJT/TYrmcwTI1O2Ff5KI=; b=aJlkMQG5D583uvV8pGX1FN
        4nrN0Uo97eflV4/f4OQcrH1cObc++7ryPU+qG77QqZuqFUpw17yImxUQQDIoBrYZ
        mvRD1nirPHIPIWnU7o13IhmGXOvBN6nyKO4kPywYr5EEVfahgqYtYvCa4YYoI/fD
        zasUkDhZJ6Ssau7P50d1URqXnhfnXHK2wndlAHUuslCVaNXjT2LlSB9MoWL36NvW
        YQSQnjdaemx4j4z22HF6ouZbKxj1vM4IFSMdO7xnNYIO1YHMP6roYRDNazL74UMx
        f+5HacqhEk1Bz1LHVvooLNfPPXgrdnUv1ujg0ibj2cbkm5gQPMjiXZs21/qTn/OQ
        ==
X-ME-Sender: <xms:LQPGYJP4QmorQ8Z1z_MQkxJsp-C_VYtX77fVflkTz3Apm_S2Ya389A>
    <xme:LQPGYL8EUlNQq2G2J3y-69q8n3SZeukHeWUFCJylorBHd63HNBvFK2JL2xfe4Q8mZ
    OBqnAZk5T5ONA>
X-ME-Received: <xmr:LQPGYIT3oyOJsNoCuwsp3CeF91e4WpmWJojxS10x2yZqceH8EysEpwauMYr20HQrOKc71hzF7gwM8My54Hep32WsiDA-eKFP>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedvfedgiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:LQPGYFtnxGetX213U3Gk2Edb7IXL_OJ_FRp-u-pSKRrjPiaHYVDn7w>
    <xmx:LQPGYBeIoxEgXaIJhcNnXcxRWaCVNcF5Nqys_Ot1axbCioWEu573uw>
    <xmx:LQPGYB04AFfBxQVX6uTVngQJz8bPern7aQg3GzyLrnQdVegLNVPsJA>
    <xmx:LQPGYF6kul7EkzdtRcj7poWla6G_R8JTJlqR63q5L8An5d36h8ZVQw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 13 Jun 2021 09:07:57 -0400 (EDT)
Subject: FAILED: patch "[PATCH] RDMA/mlx5: Block FDB rules when not in switchdev mode" failed to apply to 5.10-stable tree
To:     mbloch@nvidia.com, jgg@nvidia.com, leonro@nvidia.com,
        maorg@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 13 Jun 2021 15:07:54 +0200
Message-ID: <1623589674120109@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
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

