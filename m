Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8430E477D00
	for <lists+stable@lfdr.de>; Thu, 16 Dec 2021 21:05:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231918AbhLPUFU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Dec 2021 15:05:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbhLPUFU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Dec 2021 15:05:20 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D719C061574
        for <stable@vger.kernel.org>; Thu, 16 Dec 2021 12:05:20 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id j18so114086wrd.2
        for <stable@vger.kernel.org>; Thu, 16 Dec 2021 12:05:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=m7t0In2Z+8eXup9nxpux3+MIuAHnYX89TuGt7U8lqyI=;
        b=QE7tKSuBWpBLudqAlJm2Pv6CLyPeUBa4LKui4Ne0k1mGUfOFunR3bVM1tlC5QoovIB
         o3Lg9ARF7+Rjc5K40zEStx0ozeLVPGnqOlY7m0SKi0dfsiI+ojedGOCONMk45lJDojqB
         qWc14JXutnODIxZ2VwVkMY8Q8WoYN5JVxJK0/4J0lk2MZ/gvg2IufYIOsCsJK7UvBd+F
         TDetgn13QdnVh/6mdnNKIgn9d6vntTX1LBIENL+iVD7qzgXxJP7m/yL91MQJv8ucNcLL
         UYSqOnIoFPL043xW7bpGoUeBLvgmy0NtlBl0UygXPxeBvp/SYYQcYJrWwX3ubq6eUX0p
         O3ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=m7t0In2Z+8eXup9nxpux3+MIuAHnYX89TuGt7U8lqyI=;
        b=JmAGA1+HRe9GZKw+oRW5W9ojk6c4nJFLnjGDik3UuJUpq2fcQFNeh0rzaHCDMwTRfZ
         +Luz2SfMrawmLZ0FyqUxfmVCoAPDEyHRvAcSwAnSxdivKs+ZLAVCnVQI/9VprxK3+aSU
         oTpryiFqHcFNo9rhg1ejS/IPe3wMwWQUMkIm8Q/GaXzZefWUtEY3uosr/EM06WSLbxdC
         vpyIsIry2Y13bFcjoRhS+XSZy0Hp2RkFCCAanh+g6JUEy4aD5TThejweEqkkxWv7k1+T
         B9b/QTaS/BIkselRQdfMyisX9m43/kLzUBsm9HtzPL5fN8bSPEgEWT/meybHM3MSOpgW
         dHoA==
X-Gm-Message-State: AOAM5321l4r1Cz1zVgwB6WETerIUuBafSa/CEgCZ2d0kJv8C52h2/BFc
        tm3e+Jpqq6p9sjuGW6yN6B1N2EDxVhrFjA==
X-Google-Smtp-Source: ABdhPJzEYojihz9bf2Vjt2h1Fj09tiCCmhDZxTPijrxgJQPpmd805FDloK81R/zzWYKn1IWAH99eng==
X-Received: by 2002:adf:bc89:: with SMTP id g9mr10072518wrh.578.1639685118637;
        Thu, 16 Dec 2021 12:05:18 -0800 (PST)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id d2sm5362806wmb.31.2021.12.16.12.05.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 12:05:18 -0800 (PST)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Date:   Thu, 16 Dec 2021 21:05:17 +0100
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     gregkh@linuxfoundation.org
Cc:     bfields@redhat.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] nfsd: fix use-after-free due to
 delegation race" failed to apply to 4.19-stable tree
Message-ID: <Ybub/RYZeQkEBGcI@eldamar.lan>
References: <1639314690415@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1639314690415@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Bruce, hi Greg,

On Sun, Dec 12, 2021 at 02:11:30PM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Unless I'm completely wrong this only does not apply to the older
series because in 5.6-rc1 we had 20b7d86f29d3 ("nfsd: use boottime for
lease expiry calculation") soe there is a minor context change in one
hunk.

Attached is a patch accounting for that, Bruce is this okay?

This would apply as well back on top of v4.9.293.

Regards,
Salvatore

From eeeaf376a2efabdad46ce03516552f4290949834 Mon Sep 17 00:00:00 2001
From: "J. Bruce Fields" <bfields@redhat.com>
Date: Mon, 29 Nov 2021 15:08:00 -0500
Subject: [PATCH] nfsd: fix use-after-free due to delegation race

commit 548ec0805c399c65ed66c6641be467f717833ab5 upstream.

A delegation break could arrive as soon as we've called vfs_setlease.  A
delegation break runs a callback which immediately (in
nfsd4_cb_recall_prepare) adds the delegation to del_recall_lru.  If we
then exit nfs4_set_delegation without hashing the delegation, it will be
freed as soon as the callback is done with it, without ever being
removed from del_recall_lru.

Symptoms show up later as use-after-free or list corruption warnings,
usually in the laundromat thread.

I suspect aba2072f4523 "nfsd: grant read delegations to clients holding
writes" made this bug easier to hit, but I looked as far back as v3.0
and it looks to me it already had the same problem.  So I'm not sure
where the bug was introduced; it may have been there from the beginning.

Cc: stable@vger.kernel.org
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[Salvatore Bonaccorso: Backport for context changes to versions which do
not have 20b7d86f29d3 ("nfsd: use boottime for lease expiry
calculation")]
Signed-off-by: Salvatore Bonaccorso <carnil@debian.org>
---
 fs/nfsd/nfs4state.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 655079ae1dd1..dfb2a790efc1 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -975,6 +975,11 @@ hash_delegation_locked(struct nfs4_delegation *dp, struct nfs4_file *fp)
 	return 0;
 }
 
+static bool delegation_hashed(struct nfs4_delegation *dp)
+{
+	return !(list_empty(&dp->dl_perfile));
+}
+
 static bool
 unhash_delegation_locked(struct nfs4_delegation *dp)
 {
@@ -982,7 +987,7 @@ unhash_delegation_locked(struct nfs4_delegation *dp)
 
 	lockdep_assert_held(&state_lock);
 
-	if (list_empty(&dp->dl_perfile))
+	if (!delegation_hashed(dp))
 		return false;
 
 	dp->dl_stid.sc_type = NFS4_CLOSED_DELEG_STID;
@@ -3912,7 +3917,7 @@ static void nfsd4_cb_recall_prepare(struct nfsd4_callback *cb)
 	 * queued for a lease break. Don't queue it again.
 	 */
 	spin_lock(&state_lock);
-	if (dp->dl_time == 0) {
+	if (delegation_hashed(dp) && dp->dl_time == 0) {
 		dp->dl_time = get_seconds();
 		list_add_tail(&dp->dl_recall_lru, &nn->del_recall_lru);
 	}
-- 
2.34.1

