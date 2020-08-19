Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7972249E24
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 14:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728036AbgHSMgQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 08:36:16 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:56213 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727944AbgHSMgQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 08:36:16 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 5D1ABA58;
        Wed, 19 Aug 2020 08:36:13 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 19 Aug 2020 08:36:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=jgpOor
        FDJdzXYwpsIXadJ1FDzGoT97Rubp5uIWnoqhM=; b=l5UH3H6H/Cjtrrr64FIdRK
        s8gwFW+1udCDommXY0m1e8ZI39b7Vk+4cqpKHsHYx8/1oE/G/IRJFbW9kJIL+8K4
        1ObE8DtaW/U7Nwnd1HX4i5SGNnAgG6doaM7IOZBZL6HZ60kx/IWdN8AX+DwNRnur
        dv6PJxsuT4DRaWfwS6PyJCYIN3IM6onfGC1koQaDD9EFzNMCu65hCprl81/3pGjL
        96/kU/dqcPt852K43U3O3vFA+owd9WcNFiTVqIdK78ZSsH90ms4o7GM2Ao9MVDF3
        j8WyJf5Tah/dBptwT0klzdnxud06m3dS8dKrwM+/IccZ7ybe5PaRZrSa7+wfAFng
        ==
X-ME-Sender: <xms:vBw9X7jHkU6dQ_6XryfBJZogFQcdapZk9orwsx0NQx1pX_snj2r_NQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtkedgfeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:vBw9X4B1F2N2yPaI2KiBZNBscq15gjoPSxkZEH8XL0GM1FnxEssgQg>
    <xmx:vBw9X7Ff7o3V0Dh7qo7nTIwqW4EOom-cTTUSzay2LNLILiOzV4_ULA>
    <xmx:vBw9X4Qwh5LkEBXp7-bhYgAHluaRZVZMdckGl9mGosqoyoaaPaZXJw>
    <xmx:vRw9Xz-XNKzwIt6txT4MJ81hcgv0FfTxnB_BlsH-LF8XGvn2cVlieHydnqY>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 41DB93280066;
        Wed, 19 Aug 2020 08:36:12 -0400 (EDT)
Subject: FAILED: patch "[PATCH] net/compat: Add missing sock updates for SCM_RIGHTS" failed to apply to 4.4-stable tree
To:     keescook@chromium.org, christian.brauner@ubuntu.com, hch@lst.de,
        kuba@kernel.org, sargun@sargun.me
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 19 Aug 2020 14:36:35 +0200
Message-ID: <159784059513623@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From d9539752d23283db4692384a634034f451261e29 Mon Sep 17 00:00:00 2001
From: Kees Cook <keescook@chromium.org>
Date: Tue, 9 Jun 2020 16:11:29 -0700
Subject: [PATCH] net/compat: Add missing sock updates for SCM_RIGHTS

Add missed sock updates to compat path via a new helper, which will be
used more in coming patches. (The net/core/scm.c code is left as-is here
to assist with -stable backports for the compat path.)

Cc: Christoph Hellwig <hch@lst.de>
Cc: Sargun Dhillon <sargun@sargun.me>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: stable@vger.kernel.org
Fixes: 48a87cc26c13 ("net: netprio: fd passed in SCM_RIGHTS datagram not set correctly")
Fixes: d84295067fc7 ("net: net_cls: fd passed in SCM_RIGHTS datagram not set correctly")
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Kees Cook <keescook@chromium.org>

diff --git a/include/net/sock.h b/include/net/sock.h
index c53cc42b5ab9..2be67f1ee8b1 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -890,6 +890,8 @@ static inline int sk_memalloc_socks(void)
 {
 	return static_branch_unlikely(&memalloc_socks_key);
 }
+
+void __receive_sock(struct file *file);
 #else
 
 static inline int sk_memalloc_socks(void)
@@ -897,6 +899,8 @@ static inline int sk_memalloc_socks(void)
 	return 0;
 }
 
+static inline void __receive_sock(struct file *file)
+{ }
 #endif
 
 static inline gfp_t sk_gfp_mask(const struct sock *sk, gfp_t gfp_mask)
diff --git a/net/compat.c b/net/compat.c
index 5e3041a2c37d..2937b816107d 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -309,6 +309,7 @@ void scm_detach_fds_compat(struct msghdr *kmsg, struct scm_cookie *scm)
 			break;
 		}
 		/* Bump the usage count and install the file. */
+		__receive_sock(fp[i]);
 		fd_install(new_fd, get_file(fp[i]));
 	}
 
diff --git a/net/core/sock.c b/net/core/sock.c
index 6c4acf1f0220..bde394979041 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2840,6 +2840,27 @@ int sock_no_mmap(struct file *file, struct socket *sock, struct vm_area_struct *
 }
 EXPORT_SYMBOL(sock_no_mmap);
 
+/*
+ * When a file is received (via SCM_RIGHTS, etc), we must bump the
+ * various sock-based usage counts.
+ */
+void __receive_sock(struct file *file)
+{
+	struct socket *sock;
+	int error;
+
+	/*
+	 * The resulting value of "error" is ignored here since we only
+	 * need to take action when the file is a socket and testing
+	 * "sock" for NULL is sufficient.
+	 */
+	sock = sock_from_file(file, &error);
+	if (sock) {
+		sock_update_netprioidx(&sock->sk->sk_cgrp_data);
+		sock_update_classid(&sock->sk->sk_cgrp_data);
+	}
+}
+
 ssize_t sock_no_sendpage(struct socket *sock, struct page *page, int offset, size_t size, int flags)
 {
 	ssize_t res;

