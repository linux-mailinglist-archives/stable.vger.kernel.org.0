Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE2C24B11E
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 10:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726835AbgHTIda (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 04:33:30 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:35937 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726825AbgHTId3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 04:33:29 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 9AF80194008D;
        Thu, 20 Aug 2020 04:33:28 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Thu, 20 Aug 2020 04:33:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=DRmOrj
        5mzzW+/b7nxzRFYl31sKvrrNb4gW63tUKN+II=; b=iKhZ3TAt6kdvgnTm6x7Q2Z
        +nMrvsW/q01KIQCQHii6Ok0rPI+AR7Hn5jcaNXbJ4np9oqMvGp/9HJQQ+PsL740T
        goQuxfaj6bw2o+WteQ9ioN1JttFeVf3lk4evKXKZFiEgyZtGexqthKxV8AIlYlll
        +rE20VhVdRb6dupizu7j6OSn/xoPeAyC2YU71efbqkik2Rwz3mCWh/0fB6q4LYwc
        mu3vceTN0U9i1YPZ19hclTYdLCInhniUpHwnTAj96lAqu2/YAqvmXEXpvcmIkLji
        sYnumIRBoXsIrXrEHr1ii/vqTkgx4rpsf7IqORZs35IZT5NJ5E11rwmNwIMT4i5A
        ==
X-ME-Sender: <xms:WDU-X6722WuA0_TvJG4ok8akR0VwAsVBOyKjoTqhsHleFstL9f9AZA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddutddgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:WDU-Xz54zFOZR2yZwUKa7EFqDb1sgcsa9HVpHb7Y0HzA6MFfBEzCkg>
    <xmx:WDU-X5c-n_YI8p0G98ZJPU-Gz4xuGQ1DOv65CWxpZglAqSmoroJ4jQ>
    <xmx:WDU-X3K8IP7XmOGUI-YtBaPezCjith2rSOiIgc-8oZjuucZ7WJrQEA>
    <xmx:WDU-X9k0xB7hWmUQao1PG1zvsUFDU3eoxsQ7ebui_iIx0ihtpoNK5A>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2BAA930600A3;
        Thu, 20 Aug 2020 04:33:28 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/amd/display: Use kvfree() to free coeff in" failed to apply to 5.7-stable tree
To:     efremov@linux.com, alexander.deucher@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 20 Aug 2020 10:33:50 +0200
Message-ID: <1597912430250242@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.7-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8425400759749e23aaa831f2482b96211201af33 Mon Sep 17 00:00:00 2001
From: Denis Efremov <efremov@linux.com>
Date: Fri, 5 Jun 2020 20:37:43 +0300
Subject: [PATCH] drm/amd/display: Use kvfree() to free coeff in
 build_regamma()

Use kvfree() instead of kfree() to free coeff in build_regamma()
because the memory is allocated with kvzalloc().

Fixes: e752058b8671 ("drm/amd/display: Optimize gamma calculations")
Cc: stable@vger.kernel.org
Signed-off-by: Denis Efremov <efremov@linux.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>

diff --git a/drivers/gpu/drm/amd/display/modules/color/color_gamma.c b/drivers/gpu/drm/amd/display/modules/color/color_gamma.c
index 9431b48aecb4..56bb1f9f77ce 100644
--- a/drivers/gpu/drm/amd/display/modules/color/color_gamma.c
+++ b/drivers/gpu/drm/amd/display/modules/color/color_gamma.c
@@ -843,7 +843,7 @@ static bool build_regamma(struct pwl_float_data_ex *rgb_regamma,
 	pow_buffer_ptr = -1; // reset back to no optimize
 	ret = true;
 release:
-	kfree(coeff);
+	kvfree(coeff);
 	return ret;
 }
 

