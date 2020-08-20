Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC85524B11F
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 10:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726309AbgHTIdm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 04:33:42 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:39605 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726823AbgHTIdh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 04:33:37 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 9C5041940112;
        Thu, 20 Aug 2020 04:33:36 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 20 Aug 2020 04:33:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=wCfjGm
        Fj0ZQpy2kta/8FJn0e4S2eLw0Gmyv1uXKpdw8=; b=h1R8nlgCfbRhdyKaI4WKdi
        6avo8ijkpJCMmBoRHO+cdBIv1e5Lttmj1wP3zlDs1wnRMQopD5CYMpKcCWb6WpFQ
        BxTDIw+xwPHJ/NqY0sfbsN0H8H/z8yYxwM4GChJh91A38Cv7hOveSPiSWLp1YBoz
        wLjZHs/xF5v2BwlbU45B7J4q+Xv6ZrXmOerTElM0T3Q5abO/2r/McGQDjlv39IZ/
        83nqo6dmQJkMuVoUv+LLherHEuDDmb9Bh2gV0b+X7Ab2BPFkn2PhJ/y8EdunIju1
        J4/bIX3JLbNOxw1uOcXHWHx4z91wyTxGT6I1j99VEwJV+Vwsjg8Ln9/KeWhBA+bw
        ==
X-ME-Sender: <xms:YDU-X6Os94mN-M-hflQ2utOh7LmlIlH5YOrd9Y0VGzeMM5mb5MUllA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddutddgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:YDU-X48PyQuj0Fob77OeYK-w1HizdP_2QuIZlavrRoG6is-cd2fqVA>
    <xmx:YDU-XxRyyvneMahIUdb4RA_yVam43N-boFlGuswj051K6wdzikzW9g>
    <xmx:YDU-X6v2AwW4LkNoDXrtpVlX-oPXZq1PWSlvlVW_8jGu9bzQDXMzhA>
    <xmx:YDU-X0oFBOajUtKbyBCLsVCaoQOOPiK3ciWwsi-jlOgTi-8TUMVDjw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3C53D3280059;
        Thu, 20 Aug 2020 04:33:36 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/amd/display: Use kvfree() to free coeff in" failed to apply to 5.8-stable tree
To:     efremov@linux.com, alexander.deucher@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 20 Aug 2020 10:33:50 +0200
Message-ID: <1597912430214153@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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
 

