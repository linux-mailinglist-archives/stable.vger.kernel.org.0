Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC7D395075
	for <lists+stable@lfdr.de>; Sun, 30 May 2021 12:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbhE3KqG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 May 2021 06:46:06 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:56803 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229579AbhE3KqF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 May 2021 06:46:05 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id 0767719404F9;
        Sun, 30 May 2021 06:44:26 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 30 May 2021 06:44:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=w7soGe
        S8cmbjOtrMG75xgF1hHiPPlMwE5H+t1Zame88=; b=Ti9i01y/TnYn4Luq/J5RLa
        ESqu0lLDyaso4dfj+suoRZC3+C4XKUp8MXMP+WyqoEjDQj66SIoh8gWvD1ot8CWb
        F1cKXIgu6ko1bsfxdHGn55oNJSgNIkdlccnGSS9ELDuEEiICBuBEXnk8KwghpunG
        /5nw49YAL2cYRVyRnDY69OwVp/uT/AA2cCICqzk4DPOQXGXbjFoYpy4FnGycAB8F
        oVB8Nfqw4qA2vG1N2PRa31bAv6ZI9oz+uGPgyZA7/L5Qe0XaGtO4u2utVFzCzwSa
        OHLo0sjbpJYl1r4yzeh0VGz/i0Dq7r317hg+GaXesW+3cpWDjHXI0HjGknppsWSA
        ==
X-ME-Sender: <xms:iWyzYNX97eRA9G1HwQPTpMkDbP3lSYO1casKYnyB4IDCWgSK6LmDLA>
    <xme:iWyzYNmNtEnVMsOM076XqGa1Sh01nyXt09temQFVYMMokAXR9ZQeLZkcezwYppVLW
    iE_zo9EgbVTMA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeluddgfedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:iWyzYJazvYKLrWp-IYS-XIcNih5qaHIPyJbIRh1MIN_THK6VQD9ctA>
    <xmx:iWyzYAWnSQHHT7hReKSoNCVP_2I3tI-F8kbaBvyDNGV4w8ZESXqrmw>
    <xmx:iWyzYHlfSkP9N2uJZdBybz8LC_GTCrQRTPi9t0h3cJtUhMQthDBMgw>
    <xmx:imyzYPutSkMUVsyO6-FvkWlRFStKI9KQPqAliae5y9gllJYR3sfxcQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sun, 30 May 2021 06:44:25 -0400 (EDT)
Subject: FAILED: patch "[PATCH] debugfs: fix security_locked_down() call for SELinux" failed to apply to 5.10-stable tree
To:     omosnace@redhat.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 30 May 2021 12:44:23 +0200
Message-ID: <162237146337236@kroah.com>
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

From 5881fa8dc2de9697a89451f6518e8b3a796c09c6 Mon Sep 17 00:00:00 2001
From: Ondrej Mosnacek <omosnace@redhat.com>
Date: Fri, 7 May 2021 14:53:04 +0200
Subject: [PATCH] debugfs: fix security_locked_down() call for SELinux

When (ia->ia_valid & (ATTR_MODE | ATTR_UID | ATTR_GID)) is zero, then
the SELinux implementation of the locked_down hook might report a denial
even though the operation would actually be allowed.

To fix this, make sure that security_locked_down() is called only when
the return value will be taken into account (i.e. when changing one of
the problematic attributes).

Note: this was introduced by commit 5496197f9b08 ("debugfs: Restrict
debugfs when the kernel is locked down"), but it didn't matter at that
time, as the SELinux support came in later.

Fixes: 59438b46471a ("security,lockdown,selinux: implement SELinux lockdown")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
Link: https://lore.kernel.org/r/20210507125304.144394-1-omosnace@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 1d252164d97b..8129a430d789 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -45,10 +45,13 @@ static unsigned int debugfs_allow __ro_after_init = DEFAULT_DEBUGFS_ALLOW_BITS;
 static int debugfs_setattr(struct user_namespace *mnt_userns,
 			   struct dentry *dentry, struct iattr *ia)
 {
-	int ret = security_locked_down(LOCKDOWN_DEBUGFS);
+	int ret;
 
-	if (ret && (ia->ia_valid & (ATTR_MODE | ATTR_UID | ATTR_GID)))
-		return ret;
+	if (ia->ia_valid & (ATTR_MODE | ATTR_UID | ATTR_GID)) {
+		ret = security_locked_down(LOCKDOWN_DEBUGFS);
+		if (ret)
+			return ret;
+	}
 	return simple_setattr(&init_user_ns, dentry, ia);
 }
 

