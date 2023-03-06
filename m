Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF536ABD59
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 11:50:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbjCFKus (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 05:50:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbjCFKu2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 05:50:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9466526853
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 02:50:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1BF7160DE3
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 10:50:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35A97C433D2;
        Mon,  6 Mar 2023 10:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678099803;
        bh=dn1jVfUPyxBrpEiCicjmjbu2rDV41QVcFrU5MZyqLkU=;
        h=Subject:To:Cc:From:Date:From;
        b=bjFuCF5y4RU+VYbvQWsJVW7sHGYso3QcarxfN9IT7bBK5EDBsJ0YrATFemI48LBaF
         5Tra2V4NlVROGmEyYcQu2tttoj2wGMFA5UkuVUPiHAmGd5urJNEMTsWJ9PieBqBvfv
         sEl4N3oVDevBfT7Uv1KT5mmYG9qBG7x1zcNm0UBg=
Subject: FAILED: patch "[PATCH] io_uring: remove MSG_NOSIGNAL from recvmsg" failed to apply to 5.15-stable tree
To:     equinox@diac24.net, axboe@kernel.dk, edumazet@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Mar 2023 11:49:52 +0100
Message-ID: <1678099792191220@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.15.y
git checkout FETCH_HEAD
git cherry-pick -x 7605c43d67face310b4b87dee1a28bc0c8cd8c0f
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '1678099792191220@kroah.com' --subject-prefix 'PATCH 5.15.y' HEAD^..

Possible dependencies:

7605c43d67fa ("io_uring: remove MSG_NOSIGNAL from recvmsg")
f9ead18c1058 ("io_uring: split network related opcodes into its own file")
e0da14def1ee ("io_uring: move statx handling to its own file")
a9c210cebe13 ("io_uring: move epoll handler to its own file")
4cf90495281b ("io_uring: add a dummy -EOPNOTSUPP prep handler")
99f15d8d6136 ("io_uring: move uring_cmd handling to its own file")
cd40cae29ef8 ("io_uring: split out open/close operations")
453b329be5ea ("io_uring: separate out file table handling code")
f4c163dd7d4b ("io_uring: split out fadvise/madvise operations")
0d5847274037 ("io_uring: split out fs related sync/fallocate functions")
531113bbd5bf ("io_uring: split out splice related operations")
11aeb71406dd ("io_uring: split out filesystem related operations")
e28683bdfc2f ("io_uring: move nop into its own file")
5e2a18d93fec ("io_uring: move xattr related opcodes to its own file")
97b388d70b53 ("io_uring: handle completions in the core")
de23077eda61 ("io_uring: set completion results upfront")
e27f928ee1cb ("io_uring: add io_uring_types.h")
4d4c9cff4f70 ("io_uring: define a request type cleanup handler")
890968dc0336 ("io_uring: unify struct io_symlink and io_hardlink")
9a3a11f977f9 ("io_uring: convert iouring_cmd to io_cmd_type")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7605c43d67face310b4b87dee1a28bc0c8cd8c0f Mon Sep 17 00:00:00 2001
From: David Lamparter <equinox@diac24.net>
Date: Fri, 24 Feb 2023 16:01:24 +0100
Subject: [PATCH] io_uring: remove MSG_NOSIGNAL from recvmsg

MSG_NOSIGNAL is not applicable for the receiving side, SIGPIPE is
generated when trying to write to a "broken pipe".  AF_PACKET's
packet_recvmsg() does enforce this, giving back EINVAL when MSG_NOSIGNAL
is set - making it unuseable in io_uring's recvmsg.

Remove MSG_NOSIGNAL from io_recvmsg_prep().

Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: David Lamparter <equinox@diac24.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20230224150123.128346-1-equinox@diac24.net
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/io_uring/net.c b/io_uring/net.c
index cbd4b725f58c..b7f190ca528e 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -567,7 +567,7 @@ int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	sr->flags = READ_ONCE(sqe->ioprio);
 	if (sr->flags & ~(RECVMSG_FLAGS))
 		return -EINVAL;
-	sr->msg_flags = READ_ONCE(sqe->msg_flags) | MSG_NOSIGNAL;
+	sr->msg_flags = READ_ONCE(sqe->msg_flags);
 	if (sr->msg_flags & MSG_DONTWAIT)
 		req->flags |= REQ_F_NOWAIT;
 	if (sr->msg_flags & MSG_ERRQUEUE)

