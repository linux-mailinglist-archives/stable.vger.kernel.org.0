Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0A3B24F30C
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 09:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbgHXHYQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 03:24:16 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:60805 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726413AbgHXHYP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Aug 2020 03:24:15 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 2DDBD19413F8;
        Mon, 24 Aug 2020 03:24:14 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 24 Aug 2020 03:24:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=B/p5V2
        wl4doHUDnaR04YIrwvS67fTDiuCc9Ek4rwdRw=; b=Nqg5lV459dLM6YN0fXOSNv
        RKy52jrAA8L5cC8AalX77L28U+43sqd7QJJl+zoypu6bSKnODlHQ58euR9Hdu2QN
        NBM+LD4jf8IbieJfa7TGY+zNLHGdmwvJSfvYdCbTRPhvpHuIDlpY9S/gNC2dagMo
        cWqBV17ZVVWXQWh6XCMHTZMn4yXYF4v5rw8VxG1H7jZSEP+BQ6g7jWYmqpi93U30
        /9BgOMu9sML9P4TLB6SdAFtrCZyOo9SadAVHf0FVrlEtsF0Injd3+EopJMvrAJLc
        bfSM1p9mwws+VPS1oqbXof/DSUlz5nc4AeTa9hu9uORaFWCq0hkCjSom6xAfrFDw
        ==
X-ME-Sender: <xms:HmtDX-Eghq5l6j7WDpEW4HOmob6WCRZKXnuEdEad9QQNHo4SMH9hGQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddujedgkeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:HmtDX_VBCIYbQOt3r0mnMEzKYQ8XO_8GL5JanHR7SMXC_tFOX7zUFg>
    <xmx:HmtDX4KLArhMpytUzCZagyEw3PrVL4y2vIgBwMg1-If1hdpRmfNe5g>
    <xmx:HmtDX4GeJz91YqjC_01WZCQSwWI5BqMetNKu_qg_SguYKlkzqb23fA>
    <xmx:HmtDX3DeNIu-mgpMHzvSCKia_Um5_d-CRPV_GnY2xC0PV1zTofvBeA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C180B30600A6;
        Mon, 24 Aug 2020 03:24:13 -0400 (EDT)
Subject: FAILED: patch "[PATCH] epoll: Keep a reference on files added to the check list" failed to apply to 4.14-stable tree
To:     maz@kernel.org, viro@zeniv.linux.org.uk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 24 Aug 2020 09:24:31 +0200
Message-ID: <1598253871105228@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From a9ed4a6560b8562b7e2e2bed9527e88001f7b682 Mon Sep 17 00:00:00 2001
From: Marc Zyngier <maz@kernel.org>
Date: Wed, 19 Aug 2020 17:12:17 +0100
Subject: [PATCH] epoll: Keep a reference on files added to the check list

When adding a new fd to an epoll, and that this new fd is an
epoll fd itself, we recursively scan the fds attached to it
to detect cycles, and add non-epool files to a "check list"
that gets subsequently parsed.

However, this check list isn't completely safe when deletions
can happen concurrently. To sidestep the issue, make sure that
a struct file placed on the check list sees its f_count increased,
ensuring that a concurrent deletion won't result in the file
disapearing from under our feet.

Cc: stable@vger.kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 12eebcdea9c8..196003d9242c 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1994,9 +1994,11 @@ static int ep_loop_check_proc(void *priv, void *cookie, int call_nests)
 			 * not already there, and calling reverse_path_check()
 			 * during ep_insert().
 			 */
-			if (list_empty(&epi->ffd.file->f_tfile_llink))
+			if (list_empty(&epi->ffd.file->f_tfile_llink)) {
+				get_file(epi->ffd.file);
 				list_add(&epi->ffd.file->f_tfile_llink,
 					 &tfile_check_list);
+			}
 		}
 	}
 	mutex_unlock(&ep->mtx);
@@ -2040,6 +2042,7 @@ static void clear_tfile_check_list(void)
 		file = list_first_entry(&tfile_check_list, struct file,
 					f_tfile_llink);
 		list_del_init(&file->f_tfile_llink);
+		fput(file);
 	}
 	INIT_LIST_HEAD(&tfile_check_list);
 }
@@ -2204,13 +2207,17 @@ int do_epoll_ctl(int epfd, int op, int fd, struct epoll_event *epds,
 					clear_tfile_check_list();
 					goto error_tgt_fput;
 				}
-			} else
+			} else {
+				get_file(tf.file);
 				list_add(&tf.file->f_tfile_llink,
 							&tfile_check_list);
+			}
 			error = epoll_mutex_lock(&ep->mtx, 0, nonblock);
 			if (error) {
 out_del:
 				list_del(&tf.file->f_tfile_llink);
+				if (!is_file_epoll(tf.file))
+					fput(tf.file);
 				goto error_tgt_fput;
 			}
 			if (is_file_epoll(tf.file)) {

