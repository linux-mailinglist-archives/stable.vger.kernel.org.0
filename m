Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3994C34B78D
	for <lists+stable@lfdr.de>; Sat, 27 Mar 2021 15:21:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbhC0OVY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 27 Mar 2021 10:21:24 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:42895 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229990AbhC0OVI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 27 Mar 2021 10:21:08 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id DC85E1599;
        Sat, 27 Mar 2021 10:21:07 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 27 Mar 2021 10:21:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=TtQ/50
        u5cgsv6+HWmJvTLeBGeblbFD5Y9INk0Gu4934=; b=NjTUdcDoFszmNfKylt3QBS
        aXp22CwgyhfkTsEhUlAmW2ShbxYkKdBLPhuE7pN55iV6pcmhcDxhip3mii4qxQxK
        ei2IC1zhlz6FM3Wbf4yw7V8kCJgjfc8q7xRI6GPG+AE8cad294Oz4/fhljjUhSNl
        gjJkU1C5TKRhQ429a5bHuH+4/hdLCpLoo18mdgyK1Dwhj0zTQvQQ6FYrRYvYDwrh
        DbRyKveV1r4jZ780ICz3kftDekMAEAd0NFAufbYV+YOocaQQu+9KgAVmD9WtOEJB
        ofjDvl/hjvHZEBXHXCz5Tfea3VYc6jyQFtSP62VlNUxDuIwr/WLxZ8witm9+voWg
        ==
X-ME-Sender: <xms:Uz9fYD5ETMIpiE7jluOGrYEWjxFnFrLNRzKXmT-oPPs_vvyOxDKyHw>
    <xme:Uz9fYI7e5jS6CrF5JUvAtRdd0rFZc-MLDOwfwD2k3RIv5ii0eZ9cveoZrPXF0HMT_
    4sCzaO6dV_i5A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudehgedgiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:Uz9fYKeuiDhGaVMYspy9jrZ5Yn0hq1O366_mhacnU_3YuGIjbSc7Nw>
    <xmx:Uz9fYELT8_eLfPH-UsLbZ2vlEZFzsIZTNkxemDkosWXpJAWsCkCP0Q>
    <xmx:Uz9fYHIDutta5qcvjAYGev1t5YsSPBXgFYydE4IFn0_-1ur1BIoBFA>
    <xmx:Uz9fYJxZiE22FnwAy6d_zO2lTJjAMzz2rq96d7jUjrSQKpWFt5WOjTAg7Yc>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id D4F4F1080063;
        Sat, 27 Mar 2021 10:21:06 -0400 (EDT)
Subject: FAILED: patch "[PATCH] dm verity: fix DM_VERITY_OPTS_MAX value" failed to apply to 4.19-stable tree
To:     jhs2.lee@samsung.com, snitzer@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 27 Mar 2021 15:21:05 +0100
Message-ID: <16168548654742@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 160f99db943224e55906dd83880da1a704c6e6b9 Mon Sep 17 00:00:00 2001
From: JeongHyeon Lee <jhs2.lee@samsung.com>
Date: Thu, 11 Mar 2021 21:10:50 +0900
Subject: [PATCH] dm verity: fix DM_VERITY_OPTS_MAX value

Three optional parameters must be accepted at once in a DM verity table, e.g.:
  (verity_error_handling_mode) (ignore_zero_block) (check_at_most_once)
Fix this to be possible by incrementing DM_VERITY_OPTS_MAX.

Signed-off-by: JeongHyeon Lee <jhs2.lee@samsung.com>
Fixes: 843f38d382b1 ("dm verity: add 'check_at_most_once' option to only validate hashes once")
Cc: stable@vger.kernel.org
Signed-off-by: Mike Snitzer <snitzer@redhat.com>

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 6b8e5bdd8526..808a98ef624c 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -34,7 +34,7 @@
 #define DM_VERITY_OPT_IGN_ZEROES	"ignore_zero_blocks"
 #define DM_VERITY_OPT_AT_MOST_ONCE	"check_at_most_once"
 
-#define DM_VERITY_OPTS_MAX		(2 + DM_VERITY_OPTS_FEC + \
+#define DM_VERITY_OPTS_MAX		(3 + DM_VERITY_OPTS_FEC + \
 					 DM_VERITY_ROOT_HASH_VERIFICATION_OPTS)
 
 static unsigned dm_verity_prefetch_cluster = DM_VERITY_DEFAULT_PREFETCH_SIZE;

