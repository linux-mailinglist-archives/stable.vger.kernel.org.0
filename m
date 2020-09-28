Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3DC27AFA1
	for <lists+stable@lfdr.de>; Mon, 28 Sep 2020 16:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726325AbgI1OES (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 10:04:18 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:38327 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726281AbgI1OES (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Sep 2020 10:04:18 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 5B51E92C;
        Mon, 28 Sep 2020 10:04:17 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 28 Sep 2020 10:04:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=2I3ppU
        wCcCPNNIRyPfpb0L2n/qAD80Rm0ZdAFxMpiE8=; b=p8kC0sddQcBlvuFLZSzVL5
        JV4cOM2ntxXtuVLuDQ/or7xjtZDe4Ded3NWKwRFJCxtueN6aebZvU1I/z+bLUiU+
        pO6yEeDotwfz4frCim0Ack3tEhjXbJONNDDSJUPowML8iSIr0oK6zCeSxDc6M2KF
        3L1YT5U3E8eV3KFyXXBb67UBGiZeH1AdYI3MaM971j2CKOc9W7OneuqWuBxpfV3y
        z0l/d+Jwwj7xPckyfsuZUvHXe0XSJthL6gfkjUo3Y6f/U9qV7Cx0cAFbof/J+n/F
        0gc8zDYvdXCzXo18auAaelclpkjdNEP0qTLuYGPJ0wIDAOV35kx0gfOOYOBZXz/w
        ==
X-ME-Sender: <xms:YO1xX0RyCpHfKJUoxcNldTC95dMrPOhi23eFmGxoIXAk7DhFtIXNuA>
    <xme:YO1xXxzbwbo8eLsCs7OP0wgnfSUr5724LtQ3QBNbbZa5MxtMoDnjEsdbjQiwzljSX
    6UFDKaid7XDog>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdeigdehudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:YO1xXx3LlezfnKr1-Mj4G5jCqOkYuuwaYqyxwu8rL_EcmdEsPLkP_w>
    <xmx:YO1xX4D14vkNgd5KJhHWuKZO4sFCkAtwM4Jfov5zwyLwFDSLBAuGcA>
    <xmx:YO1xX9hLd9wtG8ygRXi23anechZfyDXlTa8F317yYMSD5ysy6W_L9A>
    <xmx:YO1xX9JO9A4TAi2Pa97pmq9bgaj8Y9HPeeb0hqAAUOEFg04u0J15Cwj-kH0>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 23BBD3064680;
        Mon, 28 Sep 2020 10:04:16 -0400 (EDT)
Subject: FAILED: patch "[PATCH] io_uring: ensure open/openat2 name is cleaned on cancelation" failed to apply to 5.8-stable tree
To:     axboe@kernel.dk, sgarzare@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Sep 2020 16:04:25 +0200
Message-ID: <1601301865177128@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.8-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f3cd4850504ff612d0ea77a0aaf29b66c98fcefe Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Thu, 24 Sep 2020 14:55:54 -0600
Subject: [PATCH] io_uring: ensure open/openat2 name is cleaned on cancelation

If we cancel these requests, we'll leak the memory associated with the
filename. Add them to the table of ops that need cleaning, if
REQ_F_NEED_CLEANUP is set.

Cc: stable@vger.kernel.org
Fixes: e62753e4e292 ("io_uring: call statx directly")
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e6004b92e553..0ab16df31288 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5671,6 +5671,11 @@ static void __io_clean_op(struct io_kiocb *req)
 			io_put_file(req, req->splice.file_in,
 				    (req->splice.flags & SPLICE_F_FD_IN_FIXED));
 			break;
+		case IORING_OP_OPENAT:
+		case IORING_OP_OPENAT2:
+			if (req->open.filename)
+				putname(req->open.filename);
+			break;
 		}
 		req->flags &= ~REQ_F_NEED_CLEANUP;
 	}

