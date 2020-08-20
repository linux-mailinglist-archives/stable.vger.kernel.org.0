Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A166124B120
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 10:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbgHTIdm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 04:33:42 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:42595 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726825AbgHTIdk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 04:33:40 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 114C11940180;
        Thu, 20 Aug 2020 04:33:38 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Thu, 20 Aug 2020 04:33:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=//QDWu
        woll6lWnid2oiJv0rF5soyIEFXGteEiiguMvo=; b=nXlm6ncO4cjy0BNgsTev7t
        67YXU01Ra9Rl6zXbgaAf7aONfqXu3Q62kcTnZ31uof/QuK5niD56mxy1a10x70c7
        yX+lVT20FHDpHRr/yhEZ4nwDttnozYPyQvFoZFBhT7aQ5ZqnTl9Tj8ax2xlbpa0A
        Siw/VifRjlgZVJo2Hicgbuor2qONw1nx+zVwfob+waNxD3yeYkDoIExxJYbYuBsv
        O16GI7IL4O/nfYa7w2e3Xy4qeheEc64ioTwdX885XC/pG9grGsXFksZ280YIah0T
        3ttdjzdUAMH2FgJIpZjYycTBOzPDQ4PX4anvamZbhWTxOwxCPafD2VaNddpOjEGw
        ==
X-ME-Sender: <xms:YTU-Xyi40dpJAbbnOaUvbJ1IGML0G-QwztngNFpIo7gq-iYPxKlqqA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddutddgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:YTU-XzB1lVNn9TGewFvb_6ttziMIzvMhinKsYLKTlqd8mQBmrJ61HQ>
    <xmx:YTU-X6FdjH2nK1TqYM-NkkrHarb67UX9IOynpznWrMNVWqcp4q-pDA>
    <xmx:YTU-X7TvMcQk1sD2Rh8XE69EibDBF56HRuxx0QcfxBFguoMT3jx6gw>
    <xmx:YjU-XwsewckBsfT5bIBifqDsppBbKxuFPuJHtGycoeyiHKfwC1phdw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id AB5E230600B7;
        Thu, 20 Aug 2020 04:33:37 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/amd/display: Use kvfree() to free coeff in" failed to apply to 5.4-stable tree
To:     efremov@linux.com, alexander.deucher@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 20 Aug 2020 10:33:50 +0200
Message-ID: <1597912430162105@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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
 

