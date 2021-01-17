Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 857AA2F92CA
	for <lists+stable@lfdr.de>; Sun, 17 Jan 2021 15:17:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728907AbhAQORW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Jan 2021 09:17:22 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:58213 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728875AbhAQORW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Jan 2021 09:17:22 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id AF63B198257A;
        Sun, 17 Jan 2021 09:16:30 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 17 Jan 2021 09:16:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Olof7u
        VlWBRaPRgnSafxHWhgvxkUj7NuBY8Q+kMUm88=; b=bRjwwu9GKuLnBvCvQ2yke5
        tgPbTe+m1+csi7hRai8tXjjdDFyPV2V0BmdNr5gqotzujfU8ZQe4uEm1gaYO3FIV
        gL5PyNaKbHU+XMWgzZ48KwABjLwUy9HfMrn3aDlr3lVQGCPbRgpTvZzZxN7fogtl
        YJDqEGMr5Y1gjkTVpifH2eKxj4kVHWrnyAf2Yo5nMqU77Fwnp8pq7Wt7ugDE1ynK
        h1hFIQ2LutYY43SL52liElokJxs3Av5/u8wR9pQMrlof5RP7ETT/Cr8oeA4nX3XY
        n/nNDkQjb2tL9B3WQttolZZrTbFkefs6vnxbs3ZawzHNIT8iEI3qoGpxby2VHRqg
        ==
X-ME-Sender: <xms:vkYEYLr82M2NYcB9-__ktqNiR-tRZw0_iFMPqD-fBomjnxHntxyc_Q>
    <xme:vkYEYFrT4Cchq5Y0nk68RTTOp_ohDVMZD5muwWJrAl4lqivNITH1bre3rvtA3AvUf
    AwOTPxMEzkHOQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtdeigdeigecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:vkYEYIMx9dLJ0HC19OQRSS4DJxTYIizi1XyrGCDsbb0mnBUJLaeMXQ>
    <xmx:vkYEYO4yiaAwIdVKkBIIUMWF61eGnWGsjcUaAChqnluuTNCuEmwkwA>
    <xmx:vkYEYK5H2DEfRmI0thWG8wMuT_0MfIWCo9xViHAsbN2EvdqbfnjMNQ>
    <xmx:vkYEYARuDjJmIF2XlDmcla6WknWYjkkU1gtH59tkGXcDVRXssxpTKA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 38FEA1080057;
        Sun, 17 Jan 2021 09:16:30 -0500 (EST)
Subject: FAILED: patch "[PATCH] cifs: check pointer before freeing" failed to apply to 5.4-stable tree
To:     trix@redhat.com, natechancellor@gmail.com, stable@vger.kernel.org,
        stfrench@microsoft.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 17 Jan 2021 15:16:28 +0100
Message-ID: <161089298836182@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 77b6ec01c29aade01701aa30bf1469acc7f2be76 Mon Sep 17 00:00:00 2001
From: Tom Rix <trix@redhat.com>
Date: Tue, 5 Jan 2021 12:21:26 -0800
Subject: [PATCH] cifs: check pointer before freeing

clang static analysis reports this problem

dfs_cache.c:591:2: warning: Argument to kfree() is a constant address
  (18446744073709551614), which is not memory allocated by malloc()
        kfree(vi);
        ^~~~~~~~~

In dfs_cache_del_vol() the volume info pointer 'vi' being freed
is the return of a call to find_vol().  The large constant address
is find_vol() returning an error.

Add an error check to dfs_cache_del_vol() similar to the one done
in dfs_cache_update_vol().

Fixes: 54be1f6c1c37 ("cifs: Add DFS cache routines")
Signed-off-by: Tom Rix <trix@redhat.com>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
CC: <stable@vger.kernel.org> # v5.0+
Signed-off-by: Steve French <stfrench@microsoft.com>

diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
index 6ad6ba5f6ebe..0fdb0de7ff86 100644
--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -1260,7 +1260,8 @@ void dfs_cache_del_vol(const char *fullpath)
 	vi = find_vol(fullpath);
 	spin_unlock(&vol_list_lock);
 
-	kref_put(&vi->refcnt, vol_release);
+	if (!IS_ERR(vi))
+		kref_put(&vi->refcnt, vol_release);
 }
 
 /**

