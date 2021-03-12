Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54374338DFA
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 13:58:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbhCLM5l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 07:57:41 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:57053 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231240AbhCLM5M (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Mar 2021 07:57:12 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 2DBFF1940CF4;
        Fri, 12 Mar 2021 07:57:11 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 12 Mar 2021 07:57:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=lCosvJ
        6I0oPOxJej7Qf4h5OEdBCQa2PctJe87mNbj1E=; b=OvnlXe29iPtfn3iPygMooA
        zunnf2VUAsjHQUL9SlSGr2oRySz8anLsQsA/mcGhiC4tHo11xD0FZWhwlIJRr8hd
        ZBe52OgsGkXeyE+jV0pb73gaUU3E+RFUmu6hYEOMQmTW3kkalZRXxoKauP+63pqD
        eG+79dyrIO6Sdpow0tbOBnFhWG42VAKniFV3NJHadlRia+OKAsdr31zgSkOAhhg+
        xS6Q4/2Ht1rgPSTs1kCAQVtOeAEKa922tGxK8Mjvb5iGAdRJo6Hk2872g0NHq+aJ
        Cx3a7aPJ3tLbvpITwIJT2Gg8/E7bffykxU6VJBmaFJrot89rQMYQqfnnxhO0Fqkg
        ==
X-ME-Sender: <xms:JmVLYCdOq9EZdlKETS1O9bgmY-4_2VJ0tOMG9tZ7RVebpvlskrRdEQ>
    <xme:JmVLYMNsEVSgHbxCndeBpBskDIbzLl2TSsNKZbEDU8ShFa5KS6uyovW0l6dGFDcNN
    C_fdjcjl4G-OQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvvddggeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:JmVLYDjZRshfzGqik17tK-W2gZh2vmSyJwfblaqIkJYtMKefQJJYNw>
    <xmx:JmVLYP841gHZzCqa_Hir-c12rxaPXVFceUfN536eRvb9yJOqUQF6Zw>
    <xmx:JmVLYOsiwyiR8b7ljEIH2KK6YVJB74XrsOhLEC2evPjY4myAzoIPGA>
    <xmx:J2VLYH6CmTFh2URM5LflRtwotdfg1lzH1_u7TchyLpcRWOtdbTy5Hg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id ADE6224005B;
        Fri, 12 Mar 2021 07:57:09 -0500 (EST)
Subject: FAILED: patch "[PATCH] ixgbe: fail to create xfrm offload of IPsec tunnel mode SA" failed to apply to 4.19-stable tree
To:     antony@phenome.org, anthony.l.nguyen@intel.com,
        snelson@pensando.io, tonyx.brelinski@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 12 Mar 2021 13:57:08 +0100
Message-ID: <161555382819838@kroah.com>
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

From d785e1fec60179f534fbe8d006c890e5ad186e51 Mon Sep 17 00:00:00 2001
From: Antony Antony <antony@phenome.org>
Date: Wed, 14 Oct 2020 16:17:48 +0200
Subject: [PATCH] ixgbe: fail to create xfrm offload of IPsec tunnel mode SA

Based on talks and indirect references ixgbe IPsec offlod do not
support IPsec tunnel mode offload. It can only support IPsec transport
mode offload. Now explicitly fail when creating non transport mode SA
with offload to avoid false performance expectations.

Fixes: 63a67fe229ea ("ixgbe: add ipsec offload add and remove SA")
Signed-off-by: Antony Antony <antony@phenome.org>
Acked-by: Shannon Nelson <snelson@pensando.io>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
index eca73526ac86..54d47265a7ac 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
@@ -575,6 +575,11 @@ static int ixgbe_ipsec_add_sa(struct xfrm_state *xs)
 		return -EINVAL;
 	}
 
+	if (xs->props.mode != XFRM_MODE_TRANSPORT) {
+		netdev_err(dev, "Unsupported mode for ipsec offload\n");
+		return -EINVAL;
+	}
+
 	if (ixgbe_ipsec_check_mgmt_ip(xs)) {
 		netdev_err(dev, "IPsec IP addr clash with mgmt filters\n");
 		return -EINVAL;
diff --git a/drivers/net/ethernet/intel/ixgbevf/ipsec.c b/drivers/net/ethernet/intel/ixgbevf/ipsec.c
index 5170dd9d8705..caaea2c920a6 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ipsec.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ipsec.c
@@ -272,6 +272,11 @@ static int ixgbevf_ipsec_add_sa(struct xfrm_state *xs)
 		return -EINVAL;
 	}
 
+	if (xs->props.mode != XFRM_MODE_TRANSPORT) {
+		netdev_err(dev, "Unsupported mode for ipsec offload\n");
+		return -EINVAL;
+	}
+
 	if (xs->xso.flags & XFRM_OFFLOAD_INBOUND) {
 		struct rx_sa rsa;
 

