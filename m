Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F07972E35FD
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 11:45:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgL1Kog (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 05:44:36 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:35869 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726958AbgL1Kog (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 05:44:36 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 777E72D0;
        Mon, 28 Dec 2020 05:43:50 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 28 Dec 2020 05:43:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Zbx+zl
        hyqhjZi3G0MsVXvtHAQx8LPlRdhEGnadPpuxE=; b=LDwP8mJeR1OiiqRkbY2kd+
        b+z49IZSYb5uJXT3Tess+xo5cNh5Wj4J5oQnk5DJa2p+ZnL75uOnHOCp3ehO+yvW
        OY9GzxucaxSaMxZOHjP+enP4ivVGuQQUUwRqCl/0bBY9kv5BoVmtWgzV+I3XgtjQ
        rdcs1zCYPiUs0MVNB6J+h3Bf4HkiOnKXVe/JsX481yFzYY0Rw9tM0RD5YkmPaaux
        dZI0to/dKma47xpWz/x7r5Ro9quU0LaUKtlHtEkx2Tw19d0uMO9OGolW1s06up41
        lEmRbIypaLcGd45Y5KbH1ssr4BZcwZBAPXwdxZYAafycBijADj9s/eKVD+Yn1T6w
        ==
X-ME-Sender: <xms:5bbpXyxyc7bd_nB2DVD0OgICXV6kGhwhGt_MnOGrhDLrkQcFNa196A>
    <xme:5bbpX-OlwDhq3EV2IRqXv03GFiZMeweh5BA0b9ItHH4Ehqw63CeGRqkRUddoQBnvM
    mGJCbpUF42ifA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdduledgvdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnheptdevtefhjeffvdefuedvgfefueektddthffhtdegie
    ffvedvtdekffehueejfefhnecuffhomhgrihhnpehophgvnhhsuhhsvgdrohhrghenucfk
    phepkeefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:5bbpXxOJeafJO10rvPw1trjX__lW2_EqE_Qxff50Wy_y2Y362BJx2w>
    <xmx:5bbpXwRcFRngQSV8-O1NC3XXiTHl7RAZdRNwXTK3TPz8kNhracFn_g>
    <xmx:5bbpXzDPcjl56mXJoF-Oipdj-4p-mCMedadNm_PKpVQa0mAsCD_VUg>
    <xmx:5rbpXz-KI9CE457Aqo4X05Ua7wr-Qw2JtP-fMd7MJdxA5Td3PM4jRdRBjo0>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id F31BF1080064;
        Mon, 28 Dec 2020 05:43:48 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/amd/display: Don't invoke kgdb_breakpoint()" failed to apply to 5.10-stable tree
To:     tiwai@suse.de, alexander.deucher@amd.com,
        nicholas.kazlauskas@amd.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 11:45:11 +0100
Message-ID: <16091523111154@kroah.com>
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

From 0ca3418272a230a16d87d3302839d0ca1255f378 Mon Sep 17 00:00:00 2001
From: Takashi Iwai <tiwai@suse.de>
Date: Fri, 23 Oct 2020 09:46:55 +0200
Subject: [PATCH] drm/amd/display: Don't invoke kgdb_breakpoint()
 unconditionally

ASSERT_CRITICAL() invokes kgdb_breakpoint() whenever either
CONFIG_KGDB or CONFIG_HAVE_KGDB is set.  This, however, may lead to a
kernel panic when no kdb stuff is attached, since the
kgdb_breakpoint() call issues INT3.  It's nothing but a surprise for
normal end-users.

For avoiding the pitfall, make the kgdb_breakpoint() call only when
CONFIG_DEBUG_KERNEL_DC is set.

https://bugzilla.opensuse.org/show_bug.cgi?id=1177973
Cc: <stable@vger.kernel.org>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>

diff --git a/drivers/gpu/drm/amd/display/dc/os_types.h b/drivers/gpu/drm/amd/display/dc/os_types.h
index 330acaaed79a..32758b245754 100644
--- a/drivers/gpu/drm/amd/display/dc/os_types.h
+++ b/drivers/gpu/drm/amd/display/dc/os_types.h
@@ -94,7 +94,7 @@
  * general debug capabilities
  *
  */
-#if defined(CONFIG_HAVE_KGDB) || defined(CONFIG_KGDB)
+#if defined(CONFIG_DEBUG_KERNEL_DC) && (defined(CONFIG_HAVE_KGDB) || defined(CONFIG_KGDB))
 #define ASSERT_CRITICAL(expr) do {	\
 	if (WARN_ON(!(expr))) { \
 		kgdb_breakpoint(); \

