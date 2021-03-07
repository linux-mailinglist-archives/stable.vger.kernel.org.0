Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79337330170
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 14:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbhCGNxM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 08:53:12 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:40349 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231535AbhCGNwy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Mar 2021 08:52:54 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 892FB1A5E;
        Sun,  7 Mar 2021 08:52:53 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 07 Mar 2021 08:52:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=DLPHPT
        78eXWcIuwFxaDIur5TEkrrCXyKXcvQKJZCC10=; b=d5kmvSfKWQZ3wBMmdhzWvK
        0woOi0zDadsBkppYIIsTY7hyBQzkEGTbtlNIYx6k+al2sc8eUGMIqYtg/yn8B18X
        dsWvFMrVPWv3if17UzIHS2vcvsxcW0kXQl+zXM9uK87E568PPe8zR94Tuy44sOaJ
        2amdrX2otGjdO4nwYQY6PQT7DKssc0OoKXrTvOiqEnb4RpZkSuCHQTvCk+a2AXXF
        vPJofcteFHZAv9soHLitx9LZYNZbN7hWms8wOhMAG1kHdWWSO+TSkAX8/9/xhDjH
        8pzhbkKKmu7cERj1IOJe/xA1X62RhnztFO6jIQXaYJGWR8ixpLg/mX0lGe6pUSsQ
        ==
X-ME-Sender: <xms:tdpEYJtw79RBvjPHJcyTQ5Kz-azT3N9F_yRhu04y0DcwMP1F9ZSGVg>
    <xme:tdpEYCdQ-EnoCCEdmk4U6LbTaEWXXgMTxTAEZNCsKgrPr-IcPthqlmPq_cKCXT3rx
    tWv4YEjL7s3GA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddutddghedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepgeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:tdpEYMyCEUQssRzOM-mNhRkcqDJRelxtLpDVRYobT_MCfm6kZzFiMQ>
    <xmx:tdpEYANl63cqazZqy4gcoHxj0v5fLaAdpsLolmul3lZrKKossLKGbg>
    <xmx:tdpEYJ94AoG8ITDxfOTEJU1iBcZQes6UV9lUMjX7jz0MttnVnetbuA>
    <xmx:tdpEYOLAMQG4lVZBAplZzaRNaf5aH2xZsg5rMhiCCA5K-XpEBW1e-GFqYF4>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id D2458240054;
        Sun,  7 Mar 2021 08:52:52 -0500 (EST)
Subject: FAILED: patch "[PATCH] io_uring: clear IOCB_WAITQ for non -EIOCBQUEUED return" failed to apply to 5.10-stable tree
To:     axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 07 Mar 2021 14:52:43 +0100
Message-ID: <1615125163195169@kroah.com>
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

From b5b0ecb736f1ce1e68eb50613c0cfecff10198eb Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Thu, 4 Mar 2021 21:02:58 -0700
Subject: [PATCH] io_uring: clear IOCB_WAITQ for non -EIOCBQUEUED return

The callback can only be armed, if we get -EIOCBQUEUED returned. It's
important that we clear the WAITQ bit for other cases, otherwise we can
queue for async retry and filemap will assume that we're armed and
return -EAGAIN instead of just blocking for the IO.

Cc: stable@vger.kernel.org # 5.9+
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 044170165402..5762750c666c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3286,6 +3286,7 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 		if (ret == -EIOCBQUEUED)
 			return 0;
 		/* we got some bytes, but not all. retry. */
+		kiocb->ki_flags &= ~IOCB_WAITQ;
 	} while (ret > 0 && ret < io_size);
 done:
 	kiocb_done(kiocb, ret, issue_flags);

