Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 730B32C02E4
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 11:02:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728076AbgKWKA0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 05:00:26 -0500
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:46979 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727108AbgKWKAZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Nov 2020 05:00:25 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id C604B7BC;
        Mon, 23 Nov 2020 05:00:24 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 23 Nov 2020 05:00:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=6XZp4y
        E/h8VqCsab3BfnjgdtGZStaSP7V+4SGqSfnUU=; b=JAZDI8vdVPWar+b4ilAJ1s
        7O6U7mAp8v1I6G9t3zw3rzuMkQPaTGxdDrPPlwjY/hMLBEXfgD9MFLTJ0tWf9HL4
        N1sTamVi9R4BWzVmvDrhw+z+wIXCWXRaMVlgdkvYrS1N+Eu/MBDXxhkikPuu3p7z
        fBYOHCfIHnDChkEdpsPYvmwhzzG1b1rNnHNnsnKfAgynl90WOS2vN+fvZ7OkavSU
        DMOnDW9JZpYWJy4MzkgkkFf59qT4GTpRux31dCC6r/qGsoRNtsBnI55+B7MVDDBr
        hcweGpys7WaYq518O/tuYpE/sEPrs1ttQfhxME5sYMHcAlt+bO8TfX5rfXjupIwA
        ==
X-ME-Sender: <xms:OIi7X4i645m1qJsWeoECHpwmsiLypJlxXpURa-nX7GgYs1uufcvPqA>
    <xme:OIi7XxC44kwGa6RITNctA4zU7yBL692l09PmcFRoToA-W6PdLy66iszB4LmjGcOyW
    2V94GS8cN5nfA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudegiedgudduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:OIi7XwEXB_Rd1vSTbwEBAYzSF0--RLtIk05t2eIsDYr_p0srFju4HQ>
    <xmx:OIi7X5Qdf50gs_WsQ1ZW3d1P3XdO7Zitk5WAAh8Te4GsBq-2MULuRQ>
    <xmx:OIi7X1xUZhw2n7wfzbqe8PLXqjlsbcdb1T_Xk0OdMthMz4jdCdhZbQ>
    <xmx:OIi7XzazpfZGaEeK4fHTTfoAqSHAktBRNC0GJ7NZaSBNbbWngHVJfgM-G6w>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id C32683280064;
        Mon, 23 Nov 2020 05:00:23 -0500 (EST)
Subject: FAILED: patch "[PATCH] io_uring: get an active ref_node from files_data" failed to apply to 5.9-stable tree
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 23 Nov 2020 11:01:34 +0100
Message-ID: <1606125694104150@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1e5d770bb8a23dd01e28e92f4fb0b1093c8bdbe6 Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Wed, 18 Nov 2020 14:56:25 +0000
Subject: [PATCH] io_uring: get an active ref_node from files_data

An active ref_node always can be found in ctx->files_data, it's much
safer to get it this way instead of poking into files_data->ref_list.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Cc: stable@vger.kernel.org # v5.7+
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b205c1df3f74..5cb194ca4fce 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6974,9 +6974,7 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 		return -ENXIO;
 
 	spin_lock(&data->lock);
-	if (!list_empty(&data->ref_list))
-		ref_node = list_first_entry(&data->ref_list,
-				struct fixed_file_ref_node, node);
+	ref_node = data->node;
 	spin_unlock(&data->lock);
 	if (ref_node)
 		percpu_ref_kill(&ref_node->refs);

