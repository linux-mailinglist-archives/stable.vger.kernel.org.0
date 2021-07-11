Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB483C3C48
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 14:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232793AbhGKM1u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 08:27:50 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:32983 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232730AbhGKM1t (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 08:27:49 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailforward.west.internal (Postfix) with ESMTP id B36E81AC0D0B;
        Sun, 11 Jul 2021 08:25:02 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 11 Jul 2021 08:25:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=PIiO6c
        Dn2jgn0IL/h76FjVKXj0T3TVAR5OR72eRorr0=; b=b/4cIlhDA2ArhkfIQXc90Y
        6KdGbicIQRL2AwDrlGzPujJuHaFwjWDZGpt5R/2enToEE6ZssAdYCOgOy6tFukA/
        LGxx4+ExdwQEMvd2G7R4PRKg1C4/nayQCg72emSdy12YIeDnVHLmczElLbF4/IhK
        0Y8SoTz+EV9wGVFEfB68pneoTCm1daFuKdFAhej3Jl/8koyoXyFQc1OnuChrVwN+
        6oyXii0gwcuKsOZDdQxf6ub1cl2lbyaWfZYqJVxGDoqTVgU7AS3z/feouXmoneVr
        EB2sSwsDjVQtYHv7ePzgHCrv8D+HR4JLsf3E9+ZxQolMT+wZOQFx+ZCDcOP9ji5A
        ==
X-ME-Sender: <xms:HuPqYP4I0j6grEpbAum-EqGRxfI73ywzfG43zRXEHFcTFyWCqInfJA>
    <xme:HuPqYE4koElVW9DpuggC6beV4EKJr6OO8VQ4a_VXXES2kjwEMa6lHQaYWSzCk5eVj
    EpThAK1OU7CVg>
X-ME-Received: <xmr:HuPqYGfhFU3iQ_EuocdEhGz__uKuk6bWFqlMr71SWYRfMMFCnGnDHSDD0iF9wmzfkuPFWhc0TXaAEkf13skAyKxDIw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtgdehvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhs
    thgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:HuPqYALvqtykbf3lcJ40r0ms5ixZpgpCaocSlv8nTG09IQ0KdH79AA>
    <xmx:HuPqYDJUn9U6UJyJTUAspMlYLGLMMbNeAOk_V_gCorfPdIF4fRrCHw>
    <xmx:HuPqYJxhepXWLpBtGSM2DO6fm1WLlF3HxFVm0dVL610kdPr-PUEfdQ>
    <xmx:HuPqYAFE3jYqF5Nd99zd5Us5-OG7thWqQX8WqzMjXeTNCVTReY9eGtLOob0>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 11 Jul 2021 08:25:01 -0400 (EDT)
Subject: FAILED: patch "[PATCH] can: bcm: delay release of struct bcm_op after" failed to apply to 4.9-stable tree
To:     cascardo@canonical.com, mkl@pengutronix.de, nslusarek@gmx.net,
        socketcan@hartkopp.net, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Jul 2021 14:24:52 +0200
Message-ID: <162600629218492@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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

From d5f9023fa61ee8b94f37a93f08e94b136cf1e463 Mon Sep 17 00:00:00 2001
From: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Date: Sat, 19 Jun 2021 13:18:13 -0300
Subject: [PATCH] can: bcm: delay release of struct bcm_op after
 synchronize_rcu()

can_rx_register() callbacks may be called concurrently to the call to
can_rx_unregister(). The callbacks and callback data, though, are
protected by RCU and the struct sock reference count.

So the callback data is really attached to the life of sk, meaning
that it should be released on sk_destruct. However, bcm_remove_op()
calls tasklet_kill(), and RCU callbacks may be called under RCU
softirq, so that cannot be used on kernels before the introduction of
HRTIMER_MODE_SOFT.

However, bcm_rx_handler() is called under RCU protection, so after
calling can_rx_unregister(), we may call synchronize_rcu() in order to
wait for any RCU read-side critical sections to finish. That is,
bcm_rx_handler() won't be called anymore for those ops. So, we only
free them, after we do that synchronize_rcu().

Fixes: ffd980f976e7 ("[CAN]: Add broadcast manager (bcm) protocol")
Link: https://lore.kernel.org/r/20210619161813.2098382-1-cascardo@canonical.com
Cc: linux-stable <stable@vger.kernel.org>
Reported-by: syzbot+0f7e7e5e2f4f40fa89c0@syzkaller.appspotmail.com
Reported-by: Norbert Slusarek <nslusarek@gmx.net>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>

diff --git a/net/can/bcm.c b/net/can/bcm.c
index f3e4d9528fa3..0928a39c4423 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -785,6 +785,7 @@ static int bcm_delete_rx_op(struct list_head *ops, struct bcm_msg_head *mh,
 						  bcm_rx_handler, op);
 
 			list_del(&op->list);
+			synchronize_rcu();
 			bcm_remove_op(op);
 			return 1; /* done */
 		}
@@ -1533,9 +1534,13 @@ static int bcm_release(struct socket *sock)
 					  REGMASK(op->can_id),
 					  bcm_rx_handler, op);
 
-		bcm_remove_op(op);
 	}
 
+	synchronize_rcu();
+
+	list_for_each_entry_safe(op, next, &bo->rx_ops, list)
+		bcm_remove_op(op);
+
 #if IS_ENABLED(CONFIG_PROC_FS)
 	/* remove procfs entry */
 	if (net->can.bcmproc_dir && bo->bcm_proc_read)

