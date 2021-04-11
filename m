Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00C1935B230
	for <lists+stable@lfdr.de>; Sun, 11 Apr 2021 09:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232180AbhDKHXY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Apr 2021 03:23:24 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:39163 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229792AbhDKHXY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Apr 2021 03:23:24 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 4CF5314BF;
        Sun, 11 Apr 2021 03:23:08 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 11 Apr 2021 03:23:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=gK/uVo
        JEIn5qnOxFjTNtAUhN/r4OfAg59qMYpXNBWb8=; b=rTg0La0bCozX5DtdF8QoRe
        RpGoyJsTvepO9tovKSs3cWfDxAyEAkrTo8dvqVXbXve50W2LDp/PFzaFupnlMKej
        LWSWxwkIhJqVRyjryQR88qxShIxxkBZN2d4i95mV5OwrY88MVM6YqRat5XQdQ3oY
        2n53YtMaCHXm4uDuRKMmTApGnCRnHFK9qoxVAiT54XjDEtnv4a5B6J9f9Es7FQ8q
        m4XZDIxB5Y5tGp7AAb5XsmZAs+U2RdMBnc+UcihHDijWQNZrj9eAyFN1996UpojF
        hG0V21WwWaFgLA5Z+zKm/vtHG1PMLP0/HC5knZihJVBVRRdswdcfxZTbRkVNIETg
        ==
X-ME-Sender: <xms:26NyYESsK2hdxSpRANpDdOvxuLknad8n_uva7E5iDx7CbSivwT_-HQ>
    <xme:26NyYByNA6ZUgftStgk88pA--6vHqpUUNpps-A3VqWXX58Ud4TClQb-b9qYHEQOQL
    yIWOsQGdnQfzA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudekgedguddulecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepuddtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:26NyYB2VejWbybFO_n-ZcFOjrlp_3OZsSk5oTVyj9gHXHrbTxa5vww>
    <xmx:26NyYID3yMibC2gXn2H_pfcV-XNzRgHWH1hN3OVOfwjHvzpBoyAkSg>
    <xmx:26NyYNglMnJB_ge40uvuvLOTx5te-EX1biZongRd8_txjlhbE0Yf3A>
    <xmx:26NyYNJY6L_7WGCcHj2JIWU4knacN-lL8Lez26--wPA__laNXGQSlFxRVc0>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 892AB1080057;
        Sun, 11 Apr 2021 03:23:07 -0400 (EDT)
Subject: FAILED: patch "[PATCH] driver core: Fix locking bug in" failed to apply to 5.4-stable tree
To:     saravanak@google.com, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Apr 2021 09:22:57 +0200
Message-ID: <16181257779120@kroah.com>
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

From eed6e41813deb9ee622cd9242341f21430d7789f Mon Sep 17 00:00:00 2001
From: Saravana Kannan <saravanak@google.com>
Date: Thu, 1 Apr 2021 21:03:40 -0700
Subject: [PATCH] driver core: Fix locking bug in
 deferred_probe_timeout_work_func()

list_for_each_entry_safe() is only useful if we are deleting nodes in a
linked list within the loop. It doesn't protect against other threads
adding/deleting nodes to the list in parallel. We need to grab
deferred_probe_mutex when traversing the deferred_probe_pending_list.

Cc: stable@vger.kernel.org
Fixes: 25b4e70dcce9 ("driver core: allow stopping deferred probe after init")
Signed-off-by: Saravana Kannan <saravanak@google.com>
Link: https://lore.kernel.org/r/20210402040342.2944858-2-saravanak@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index e2cf3b29123e..37a5e5f8b221 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -292,14 +292,16 @@ int driver_deferred_probe_check_state(struct device *dev)
 
 static void deferred_probe_timeout_work_func(struct work_struct *work)
 {
-	struct device_private *private, *p;
+	struct device_private *p;
 
 	driver_deferred_probe_timeout = 0;
 	driver_deferred_probe_trigger();
 	flush_work(&deferred_probe_work);
 
-	list_for_each_entry_safe(private, p, &deferred_probe_pending_list, deferred_probe)
-		dev_info(private->device, "deferred probe pending\n");
+	mutex_lock(&deferred_probe_mutex);
+	list_for_each_entry(p, &deferred_probe_pending_list, deferred_probe)
+		dev_info(p->device, "deferred probe pending\n");
+	mutex_unlock(&deferred_probe_mutex);
 	wake_up_all(&probe_timeout_waitqueue);
 }
 static DECLARE_DELAYED_WORK(deferred_probe_timeout_work, deferred_probe_timeout_work_func);

