Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD0D2AA662
	for <lists+stable@lfdr.de>; Sat,  7 Nov 2020 16:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726132AbgKGPox (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Nov 2020 10:44:53 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:54095 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726043AbgKGPow (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Nov 2020 10:44:52 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id E96B1F86;
        Sat,  7 Nov 2020 10:44:51 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sat, 07 Nov 2020 10:44:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=WRyPYr
        qMcmaYeibqq63HOQDrznHCjXC2Pf96XZUbGqM=; b=JADl1dHV8oTr2uJXtNp9ky
        c30IoqnYz6VO1r8VlNb/WOGbOCTU5Y3Hg0uFmgC8lHVigyFeUoHGkEfZ/m9enKRv
        FsqzE0SLgrPSMPRQYNx7oaHqrFnJVuoaokvBTI7QusKXZSyxQtNcXoZATr6UAgYY
        omSjfOTf+M8eYoLWLfD8vjgyQO22PJeIghKz3vpn5bxw4AcI9cSDy7bLp79ZDAqi
        1HkuxaPZI058R2k0UfAjWJZ/124G7Sz0OmQ1v1p6DyNo3kqcoKCZWpUa/5xLXmgW
        ne0abJrVZc9+dgKRajRCF3MLBia8hzMggyqnT06PwamUpccCIJeqHQ9XHlKPwSlg
        ==
X-ME-Sender: <xms:8sCmX2zaaxo7TC0StreNVbEJBPqu3Pccetec17CAwb26ZlvTpJPy-g>
    <xme:8sCmXyQkr3H9Zik6iSN_viycJwJzhzPLcoAAg3zm3RU2d7i5Wo8ut2TW4yA6VTpRp
    8KIyezYB_rI5w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudduuddgkeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:8sCmX4UTm0K7ifjothPE5J7XmYILBRUmv5M6NDNmM0w6IxKJOyU8fg>
    <xmx:8sCmX8g5EEkt_Ek7XZnyDAFnW6KzjZAjh_MnUFDme5ZMgdZBiC7YiA>
    <xmx:8sCmX4AOdqAJ0Fg3HvHv0oFHNXJ917N7Mlwua9M3E-07ETz_zyy7gw>
    <xmx:8sCmXzo8o3yAnk0BazpFQnnfUnb-4TvlTQltplsmuGbmhpZ-zWZ3ok5Cveo>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id B4AF43280414;
        Sat,  7 Nov 2020 10:44:49 -0500 (EST)
Subject: FAILED: patch "[PATCH] gfs2: Wake up when sd_glock_disposal becomes zero" failed to apply to 4.4-stable tree
To:     aahringo@redhat.com, agruenba@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 07 Nov 2020 16:45:34 +0100
Message-ID: <1604763934189157@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
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

