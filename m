Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EAD13AE745
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 12:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbhFUKlF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 06:41:05 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:36037 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230118AbhFUKlF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Jun 2021 06:41:05 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 948D91940A90;
        Mon, 21 Jun 2021 06:38:50 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 21 Jun 2021 06:38:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=A35ITa
        ofGsMjsMZ47ie7R8J2PGNX+n8c5ba58lQUv0w=; b=udqrG63y2EAKFgaA4jaiwu
        tU1t8gOaMmEYkRbAj1PHmkLN2gySqX7j2fPI5ytJKEEJxxjFQV6kwbFOROZ0RmTE
        vu6QqwrB4EAC/tC8rTcaahUTdg9rUYFboMBgNUtm9GwrQPMI5jOohsmvFtglH0PW
        hW3F+nqSlX8rckwiOXTdJzs4daXjwg2pSWX9OHMZNFuZhCteIMRi5IT0to7NYgHM
        cwBhnjZsG8WdhPUbRM2xjpX0Lc4IeChBL6wFgXpcjSmkWDc9LEiD3MpkWLuYBDPy
        2GENMxC/K7vLUb5LB2GeYVpepSiVgkhW/AMTBTZed7ww2oBZ0idb+0Z+3Gi9eSHA
        ==
X-ME-Sender: <xms:OmzQYFyYnu7XT3aaBggq2FrdfAKah4a7Yr74aZq_TZWfCEwHrBS4Qg>
    <xme:OmzQYFSjL5v9j2szgto5JBknhO1CIt5-Bedx2_IoTBmP45NCzwuTxJVEmDNhqYK9S
    1-_Zqxgu7reLQ>
X-ME-Received: <xmr:OmzQYPVa1kBMnQ9k55MXcvTWXNpF6EaUiOpwzsPWv_OFhRSDozPgnmOmgpW9WirZ24n_OIriye3tnN9__kQTCQ3wjoeGFd2W>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeefledgfeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepgffhfffffedtkedvkeeiteehheetkefffefhtddvhf
    egudefvddtvedvheegheevnecuffhomhgrihhnpehshiiikhgrlhhlvghrrdgrphhpshhp
    ohhtrdgtohhmpdhkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurf
    grrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:OmzQYHhEvMULYhCgtEMkzMiNwmk8TSkJtpYcqKGeowq-CcEFDv5eUg>
    <xmx:OmzQYHC7kMHuDtzB2IBPI6C1Ne09WdL84d8OtyPOggBGNau1qraT6Q>
    <xmx:OmzQYAILLd9kkW1rIJIv5MjsOYmk0U0ZtmDpPMYcfYax7GABGQLGCQ>
    <xmx:OmzQYJCq2DrHL-o0O1rqtWm0KL5PZTPYLXLyWu_XwoHI2HRtzJMDqA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 21 Jun 2021 06:38:49 -0400 (EDT)
Subject: FAILED: patch "[PATCH] can: bcm/raw/isotp: use per module netdevice notifier" failed to apply to 4.14-stable tree
To:     penguin-kernel@i-love.sakura.ne.jp, ktkhai@virtuozzo.com,
        mkl@pengutronix.de, penguin-kernel@I-love.SAKURA.ne.jp,
        socketcan@hartkopp.net, stable@vger.kernel.org,
        syzbot+0f1827363a305f74996f@syzkaller.appspotmail.com,
        syzbot+355f8edb2ff45d5f95fa@syzkaller.appspotmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 21 Jun 2021 12:38:36 +0200
Message-ID: <162427191651154@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From 8d0caedb759683041d9db82069937525999ada53 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Date: Sat, 5 Jun 2021 19:26:35 +0900
Subject: [PATCH] can: bcm/raw/isotp: use per module netdevice notifier

syzbot is reporting hung task at register_netdevice_notifier() [1] and
unregister_netdevice_notifier() [2], for cleanup_net() might perform
time consuming operations while CAN driver's raw/bcm/isotp modules are
calling {register,unregister}_netdevice_notifier() on each socket.

Change raw/bcm/isotp modules to call register_netdevice_notifier() from
module's __init function and call unregister_netdevice_notifier() from
module's __exit function, as with gw/j1939 modules are doing.

Link: https://syzkaller.appspot.com/bug?id=391b9498827788b3cc6830226d4ff5be87107c30 [1]
Link: https://syzkaller.appspot.com/bug?id=1724d278c83ca6e6df100a2e320c10d991cf2bce [2]
Link: https://lore.kernel.org/r/54a5f451-05ed-f977-8534-79e7aa2bcc8f@i-love.sakura.ne.jp
Cc: linux-stable <stable@vger.kernel.org>
Reported-by: syzbot <syzbot+355f8edb2ff45d5f95fa@syzkaller.appspotmail.com>
Reported-by: syzbot <syzbot+0f1827363a305f74996f@syzkaller.appspotmail.com>
Reviewed-by: Kirill Tkhai <ktkhai@virtuozzo.com>
Tested-by: syzbot <syzbot+355f8edb2ff45d5f95fa@syzkaller.appspotmail.com>
Tested-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>

diff --git a/net/can/bcm.c b/net/can/bcm.c
index 909b9e684e04..f00176b2a6c3 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -125,7 +125,7 @@ struct bcm_sock {
 	struct sock sk;
 	int bound;
 	int ifindex;
-	struct notifier_block notifier;
+	struct list_head notifier;
 	struct list_head rx_ops;
 	struct list_head tx_ops;
 	unsigned long dropped_usr_msgs;
@@ -133,6 +133,10 @@ struct bcm_sock {
 	char procname [32]; /* inode number in decimal with \0 */
 };
 
+static LIST_HEAD(bcm_notifier_list);
+static DEFINE_SPINLOCK(bcm_notifier_lock);
+static struct bcm_sock *bcm_busy_notifier;
+
 static inline struct bcm_sock *bcm_sk(const struct sock *sk)
 {
 	return (struct bcm_sock *)sk;
@@ -1378,20 +1382,15 @@ static int bcm_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 /*
  * notification handler for netdevice status changes
  */
-static int bcm_notifier(struct notifier_block *nb, unsigned long msg,
-			void *ptr)
+static void bcm_notify(struct bcm_sock *bo, unsigned long msg,
+		       struct net_device *dev)
 {
-	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
-	struct bcm_sock *bo = container_of(nb, struct bcm_sock, notifier);
 	struct sock *sk = &bo->sk;
 	struct bcm_op *op;
 	int notify_enodev = 0;
 
 	if (!net_eq(dev_net(dev), sock_net(sk)))
-		return NOTIFY_DONE;
-
-	if (dev->type != ARPHRD_CAN)
-		return NOTIFY_DONE;
+		return;
 
 	switch (msg) {
 
@@ -1426,7 +1425,28 @@ static int bcm_notifier(struct notifier_block *nb, unsigned long msg,
 				sk->sk_error_report(sk);
 		}
 	}
+}
 
+static int bcm_notifier(struct notifier_block *nb, unsigned long msg,
+			void *ptr)
+{
+	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+
+	if (dev->type != ARPHRD_CAN)
+		return NOTIFY_DONE;
+	if (msg != NETDEV_UNREGISTER && msg != NETDEV_DOWN)
+		return NOTIFY_DONE;
+	if (unlikely(bcm_busy_notifier)) /* Check for reentrant bug. */
+		return NOTIFY_DONE;
+
+	spin_lock(&bcm_notifier_lock);
+	list_for_each_entry(bcm_busy_notifier, &bcm_notifier_list, notifier) {
+		spin_unlock(&bcm_notifier_lock);
+		bcm_notify(bcm_busy_notifier, msg, dev);
+		spin_lock(&bcm_notifier_lock);
+	}
+	bcm_busy_notifier = NULL;
+	spin_unlock(&bcm_notifier_lock);
 	return NOTIFY_DONE;
 }
 
@@ -1446,9 +1466,9 @@ static int bcm_init(struct sock *sk)
 	INIT_LIST_HEAD(&bo->rx_ops);
 
 	/* set notifier */
-	bo->notifier.notifier_call = bcm_notifier;
-
-	register_netdevice_notifier(&bo->notifier);
+	spin_lock(&bcm_notifier_lock);
+	list_add_tail(&bo->notifier, &bcm_notifier_list);
+	spin_unlock(&bcm_notifier_lock);
 
 	return 0;
 }
@@ -1471,7 +1491,14 @@ static int bcm_release(struct socket *sock)
 
 	/* remove bcm_ops, timer, rx_unregister(), etc. */
 
-	unregister_netdevice_notifier(&bo->notifier);
+	spin_lock(&bcm_notifier_lock);
+	while (bcm_busy_notifier == bo) {
+		spin_unlock(&bcm_notifier_lock);
+		schedule_timeout_uninterruptible(1);
+		spin_lock(&bcm_notifier_lock);
+	}
+	list_del(&bo->notifier);
+	spin_unlock(&bcm_notifier_lock);
 
 	lock_sock(sk);
 
@@ -1692,6 +1719,10 @@ static struct pernet_operations canbcm_pernet_ops __read_mostly = {
 	.exit = canbcm_pernet_exit,
 };
 
+static struct notifier_block canbcm_notifier = {
+	.notifier_call = bcm_notifier
+};
+
 static int __init bcm_module_init(void)
 {
 	int err;
@@ -1705,12 +1736,14 @@ static int __init bcm_module_init(void)
 	}
 
 	register_pernet_subsys(&canbcm_pernet_ops);
+	register_netdevice_notifier(&canbcm_notifier);
 	return 0;
 }
 
 static void __exit bcm_module_exit(void)
 {
 	can_proto_unregister(&bcm_can_proto);
+	unregister_netdevice_notifier(&canbcm_notifier);
 	unregister_pernet_subsys(&canbcm_pernet_ops);
 }
 
diff --git a/net/can/isotp.c b/net/can/isotp.c
index 253b24417c8e..be6183f8ca11 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -143,10 +143,14 @@ struct isotp_sock {
 	u32 force_tx_stmin;
 	u32 force_rx_stmin;
 	struct tpcon rx, tx;
-	struct notifier_block notifier;
+	struct list_head notifier;
 	wait_queue_head_t wait;
 };
 
+static LIST_HEAD(isotp_notifier_list);
+static DEFINE_SPINLOCK(isotp_notifier_lock);
+static struct isotp_sock *isotp_busy_notifier;
+
 static inline struct isotp_sock *isotp_sk(const struct sock *sk)
 {
 	return (struct isotp_sock *)sk;
@@ -1013,7 +1017,14 @@ static int isotp_release(struct socket *sock)
 	/* wait for complete transmission of current pdu */
 	wait_event_interruptible(so->wait, so->tx.state == ISOTP_IDLE);
 
-	unregister_netdevice_notifier(&so->notifier);
+	spin_lock(&isotp_notifier_lock);
+	while (isotp_busy_notifier == so) {
+		spin_unlock(&isotp_notifier_lock);
+		schedule_timeout_uninterruptible(1);
+		spin_lock(&isotp_notifier_lock);
+	}
+	list_del(&so->notifier);
+	spin_unlock(&isotp_notifier_lock);
 
 	lock_sock(sk);
 
@@ -1317,21 +1328,16 @@ static int isotp_getsockopt(struct socket *sock, int level, int optname,
 	return 0;
 }
 
-static int isotp_notifier(struct notifier_block *nb, unsigned long msg,
-			  void *ptr)
+static void isotp_notify(struct isotp_sock *so, unsigned long msg,
+			 struct net_device *dev)
 {
-	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
-	struct isotp_sock *so = container_of(nb, struct isotp_sock, notifier);
 	struct sock *sk = &so->sk;
 
 	if (!net_eq(dev_net(dev), sock_net(sk)))
-		return NOTIFY_DONE;
-
-	if (dev->type != ARPHRD_CAN)
-		return NOTIFY_DONE;
+		return;
 
 	if (so->ifindex != dev->ifindex)
-		return NOTIFY_DONE;
+		return;
 
 	switch (msg) {
 	case NETDEV_UNREGISTER:
@@ -1357,7 +1363,28 @@ static int isotp_notifier(struct notifier_block *nb, unsigned long msg,
 			sk->sk_error_report(sk);
 		break;
 	}
+}
 
+static int isotp_notifier(struct notifier_block *nb, unsigned long msg,
+			  void *ptr)
+{
+	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+
+	if (dev->type != ARPHRD_CAN)
+		return NOTIFY_DONE;
+	if (msg != NETDEV_UNREGISTER && msg != NETDEV_DOWN)
+		return NOTIFY_DONE;
+	if (unlikely(isotp_busy_notifier)) /* Check for reentrant bug. */
+		return NOTIFY_DONE;
+
+	spin_lock(&isotp_notifier_lock);
+	list_for_each_entry(isotp_busy_notifier, &isotp_notifier_list, notifier) {
+		spin_unlock(&isotp_notifier_lock);
+		isotp_notify(isotp_busy_notifier, msg, dev);
+		spin_lock(&isotp_notifier_lock);
+	}
+	isotp_busy_notifier = NULL;
+	spin_unlock(&isotp_notifier_lock);
 	return NOTIFY_DONE;
 }
 
@@ -1394,8 +1421,9 @@ static int isotp_init(struct sock *sk)
 
 	init_waitqueue_head(&so->wait);
 
-	so->notifier.notifier_call = isotp_notifier;
-	register_netdevice_notifier(&so->notifier);
+	spin_lock(&isotp_notifier_lock);
+	list_add_tail(&so->notifier, &isotp_notifier_list);
+	spin_unlock(&isotp_notifier_lock);
 
 	return 0;
 }
@@ -1442,6 +1470,10 @@ static const struct can_proto isotp_can_proto = {
 	.prot = &isotp_proto,
 };
 
+static struct notifier_block canisotp_notifier = {
+	.notifier_call = isotp_notifier
+};
+
 static __init int isotp_module_init(void)
 {
 	int err;
@@ -1451,6 +1483,8 @@ static __init int isotp_module_init(void)
 	err = can_proto_register(&isotp_can_proto);
 	if (err < 0)
 		pr_err("can: registration of isotp protocol failed\n");
+	else
+		register_netdevice_notifier(&canisotp_notifier);
 
 	return err;
 }
@@ -1458,6 +1492,7 @@ static __init int isotp_module_init(void)
 static __exit void isotp_module_exit(void)
 {
 	can_proto_unregister(&isotp_can_proto);
+	unregister_netdevice_notifier(&canisotp_notifier);
 }
 
 module_init(isotp_module_init);
diff --git a/net/can/raw.c b/net/can/raw.c
index 139d9471ddcf..ac96fc210025 100644
--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -83,7 +83,7 @@ struct raw_sock {
 	struct sock sk;
 	int bound;
 	int ifindex;
-	struct notifier_block notifier;
+	struct list_head notifier;
 	int loopback;
 	int recv_own_msgs;
 	int fd_frames;
@@ -95,6 +95,10 @@ struct raw_sock {
 	struct uniqframe __percpu *uniq;
 };
 
+static LIST_HEAD(raw_notifier_list);
+static DEFINE_SPINLOCK(raw_notifier_lock);
+static struct raw_sock *raw_busy_notifier;
+
 /* Return pointer to store the extra msg flags for raw_recvmsg().
  * We use the space of one unsigned int beyond the 'struct sockaddr_can'
  * in skb->cb.
@@ -263,21 +267,16 @@ static int raw_enable_allfilters(struct net *net, struct net_device *dev,
 	return err;
 }
 
-static int raw_notifier(struct notifier_block *nb,
-			unsigned long msg, void *ptr)
+static void raw_notify(struct raw_sock *ro, unsigned long msg,
+		       struct net_device *dev)
 {
-	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
-	struct raw_sock *ro = container_of(nb, struct raw_sock, notifier);
 	struct sock *sk = &ro->sk;
 
 	if (!net_eq(dev_net(dev), sock_net(sk)))
-		return NOTIFY_DONE;
-
-	if (dev->type != ARPHRD_CAN)
-		return NOTIFY_DONE;
+		return;
 
 	if (ro->ifindex != dev->ifindex)
-		return NOTIFY_DONE;
+		return;
 
 	switch (msg) {
 	case NETDEV_UNREGISTER:
@@ -305,7 +304,28 @@ static int raw_notifier(struct notifier_block *nb,
 			sk->sk_error_report(sk);
 		break;
 	}
+}
+
+static int raw_notifier(struct notifier_block *nb, unsigned long msg,
+			void *ptr)
+{
+	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+
+	if (dev->type != ARPHRD_CAN)
+		return NOTIFY_DONE;
+	if (msg != NETDEV_UNREGISTER && msg != NETDEV_DOWN)
+		return NOTIFY_DONE;
+	if (unlikely(raw_busy_notifier)) /* Check for reentrant bug. */
+		return NOTIFY_DONE;
 
+	spin_lock(&raw_notifier_lock);
+	list_for_each_entry(raw_busy_notifier, &raw_notifier_list, notifier) {
+		spin_unlock(&raw_notifier_lock);
+		raw_notify(raw_busy_notifier, msg, dev);
+		spin_lock(&raw_notifier_lock);
+	}
+	raw_busy_notifier = NULL;
+	spin_unlock(&raw_notifier_lock);
 	return NOTIFY_DONE;
 }
 
@@ -334,9 +354,9 @@ static int raw_init(struct sock *sk)
 		return -ENOMEM;
 
 	/* set notifier */
-	ro->notifier.notifier_call = raw_notifier;
-
-	register_netdevice_notifier(&ro->notifier);
+	spin_lock(&raw_notifier_lock);
+	list_add_tail(&ro->notifier, &raw_notifier_list);
+	spin_unlock(&raw_notifier_lock);
 
 	return 0;
 }
@@ -351,7 +371,14 @@ static int raw_release(struct socket *sock)
 
 	ro = raw_sk(sk);
 
-	unregister_netdevice_notifier(&ro->notifier);
+	spin_lock(&raw_notifier_lock);
+	while (raw_busy_notifier == ro) {
+		spin_unlock(&raw_notifier_lock);
+		schedule_timeout_uninterruptible(1);
+		spin_lock(&raw_notifier_lock);
+	}
+	list_del(&ro->notifier);
+	spin_unlock(&raw_notifier_lock);
 
 	lock_sock(sk);
 
@@ -889,6 +916,10 @@ static const struct can_proto raw_can_proto = {
 	.prot       = &raw_proto,
 };
 
+static struct notifier_block canraw_notifier = {
+	.notifier_call = raw_notifier
+};
+
 static __init int raw_module_init(void)
 {
 	int err;
@@ -898,6 +929,8 @@ static __init int raw_module_init(void)
 	err = can_proto_register(&raw_can_proto);
 	if (err < 0)
 		pr_err("can: registration of raw protocol failed\n");
+	else
+		register_netdevice_notifier(&canraw_notifier);
 
 	return err;
 }
@@ -905,6 +938,7 @@ static __init int raw_module_init(void)
 static __exit void raw_module_exit(void)
 {
 	can_proto_unregister(&raw_can_proto);
+	unregister_netdevice_notifier(&canraw_notifier);
 }
 
 module_init(raw_module_init);

