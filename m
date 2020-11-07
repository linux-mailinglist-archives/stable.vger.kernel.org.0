Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A98492AA663
	for <lists+stable@lfdr.de>; Sat,  7 Nov 2020 16:45:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726144AbgKGPpB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Nov 2020 10:45:01 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:44185 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726043AbgKGPpB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Nov 2020 10:45:01 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 244DDF85;
        Sat,  7 Nov 2020 10:45:00 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 07 Nov 2020 10:45:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=VW0qob
        NRyGUWYKSyWYDWwSN3ikpCFuqTssW2b9ZuK3Y=; b=FCzWlYg2oBD2VjTJ57Ougd
        ntzfTlb/DWdmBXqBN1cKRnKIxOgSaIO0ctxQILmHYDybI+YMr5cElVh3dndMYk4z
        0RiD6UZL2wMKoG12g6r4HLSZUnWQs9jni9wfFDS/tX/f65apAtpHUH87GhONajYk
        fN5MJ/msfzyXezWsDR6aEOBvCWwg1NRH/4DaVPUIchIoj71y+udV/m1AfhaiWQYq
        3auV8U1hp7EQu9Y8ooyr8J0D19ijqtw5qloFRrZ7bfkAT9thiQ7cTnn94xMuhEL8
        EByds1Tzqldm/x0iC5e2d406zeJxHFUeX+ThIxExITzxDPjsFas0ccpflKFfB2+A
        ==
X-ME-Sender: <xms:-8CmX4MluaojBc9uN3onkiv3rPwHYQgkgqAcLFz9bZH6VUEsG-PFRQ>
    <xme:-8CmX-_GQn8zTYd7d9Qrua_pnH4kaoD1r6JmiBrSDYZRhfgNzZTtsBjMTmZskWYnZ
    HYWiQ2PX9AWrg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudduuddgkeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:-8CmX_TF3cuk63ga1X2ZSSXxTY6zO-z8HeAtZwyJ1AA5O4_G4fKdFA>
    <xmx:-8CmXwvtGWf1M8SuckWe0y3CnOOt4Kc23tkgCulGyXEQVps2MOL2tQ>
    <xmx:-8CmXweUaX2CklssmNHZzMMGXww1dbfM3P20zl7jc75UCo8PhiITbg>
    <xmx:-8CmX4ktGlZIcSNSjWI2W6xCXEYk2Ph9hv7ZG2Pfdekid6eue1Vr2rLoH5g>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5D9583060505;
        Sat,  7 Nov 2020 10:44:59 -0500 (EST)
Subject: FAILED: patch "[PATCH] gfs2: Wake up when sd_glock_disposal becomes zero" failed to apply to 4.9-stable tree
To:     aahringo@redhat.com, agruenba@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 07 Nov 2020 16:45:36 +0100
Message-ID: <160476393691156@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From da7d554f7c62d0c17c1ac3cc2586473c2d99f0bd Mon Sep 17 00:00:00 2001
From: Alexander Aring <aahringo@redhat.com>
Date: Mon, 26 Oct 2020 10:52:29 -0400
Subject: [PATCH] gfs2: Wake up when sd_glock_disposal becomes zero

Commit fc0e38dae645 ("GFS2: Fix glock deallocation race") fixed a
sd_glock_disposal accounting bug by adding a missing atomic_dec
statement, but it failed to wake up sd_glock_wait when that decrement
causes sd_glock_disposal to reach zero.  As a consequence,
gfs2_gl_hash_clear can now run into a 10-minute timeout instead of
being woken up.  Add the missing wakeup.

Fixes: fc0e38dae645 ("GFS2: Fix glock deallocation race")
Cc: stable@vger.kernel.org # v2.6.39+
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 5441c17562c5..d98a2e5dab9f 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1078,7 +1078,8 @@ int gfs2_glock_get(struct gfs2_sbd *sdp, u64 number,
 out_free:
 	kfree(gl->gl_lksb.sb_lvbptr);
 	kmem_cache_free(cachep, gl);
-	atomic_dec(&sdp->sd_glock_disposal);
+	if (atomic_dec_and_test(&sdp->sd_glock_disposal))
+		wake_up(&sdp->sd_glock_wait);
 
 out:
 	return ret;

