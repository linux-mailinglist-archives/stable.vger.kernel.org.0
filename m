Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBCBC3C3C47
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 14:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232792AbhGKM1m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 08:27:42 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:39155 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232730AbhGKM1l (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 08:27:41 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailforward.west.internal (Postfix) with ESMTP id B2CC51AC04A7;
        Sun, 11 Jul 2021 08:24:54 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 11 Jul 2021 08:24:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=GzFyx1
        i05nJfYCbGRHdNcb4+0odYzC9gA60vT44PZng=; b=II+eMqcm7hUYq3fiTlErRm
        v2BvH3zJpjyBv7sLuCWNSyLlARM/wb72xWax8oikwH5L3MxuvEYQx3aaU/Ml5xBt
        A2jbYZZPhWDuSuqvP5LT3RrYIdk0hvCLUiarUo9cjv/ZYwzD+cs4tJH96B6yOFQO
        taLgSOHXZzUKgfszcOhnEmrfVj0Zh09oQHop6BKloJMeikPncMEuisM0jkW48Y/o
        gpiyU321vIz5O3EU9v1S4syYqp14AE59UzAYpk+5Rduxr5LMuLbw+d/h2xjRJB2q
        8TLXRrsUYCOjzYVtR9FdGtsamIlOYplawSHpoPhLk+V+DWac5+hBL7rbJVs1C2Xg
        ==
X-ME-Sender: <xms:FePqYA7sztjmQx4nAyLONFn-WKULhIGq3hhHKD-RxACyNDNttHd6yA>
    <xme:FePqYB4yDUHQfF3re2ACHzyZYIBoBOlA2nW4NglQvew8sTPCEl-E-rf8kX5AINei5
    01JuqqTctnBRg>
X-ME-Received: <xmr:FePqYPeirbxoJybpPRc-cc93S-tsJWTEz4aoJz-f7zK950aoKU1OuYrXUW33uam1cSGI_eE9qAK5zGGDd1HYwo9beg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtgdehvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:FePqYFK57wjG01Rd-cClXuGPIgzdTxva_rbvInnDTDEM0voKhRgYrA>
    <xmx:FePqYEJYbV5AnUzyINwFD5WyAc8XQuyw4CK9k4NyaYp9A6bqeHXn4A>
    <xmx:FePqYGx8mIvK8h2gdj1YYNS3nfLLTKHOD3zE4svueMqA-YFZwp1jyQ>
    <xmx:FuPqYJFQr7ds-hto_9Iqu4DvWNAimNljXoSN-sXeCNKJlz26OPdYVbzODhM>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 11 Jul 2021 08:24:53 -0400 (EDT)
Subject: FAILED: patch "[PATCH] can: bcm: delay release of struct bcm_op after" failed to apply to 4.4-stable tree
To:     cascardo@canonical.com, mkl@pengutronix.de, nslusarek@gmx.net,
        socketcan@hartkopp.net, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Jul 2021 14:24:51 +0200
Message-ID: <162600629174130@kroah.com>
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

