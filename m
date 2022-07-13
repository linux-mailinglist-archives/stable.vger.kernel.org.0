Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8B1573DA7
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 22:14:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236437AbiGMUOH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 16:14:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231473AbiGMUOD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 16:14:03 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F046422B3A
        for <stable@vger.kernel.org>; Wed, 13 Jul 2022 13:14:01 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id r14so17064610wrg.1
        for <stable@vger.kernel.org>; Wed, 13 Jul 2022 13:14:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8iUBBrb6uG/19bm/v23Fimvl6BboTcp4QDBEzmTrjdg=;
        b=fm6ab41NSU4yNgbUjQD+sYLajpDyGw9fme/aK0+A760Ng1WKDnrGhuwJuq/lYXdtko
         Eb3cb1z2a3mcKTPnYi2GE6ERdUjG4/zmNk3Epn1780tLZKYEJk8sLqS/QkTccQJwj1EA
         GoNT6CykZOL6UfGLzFips3OXA+GguDh+IF7dEmgETHUo3a6rYaLcv0jWsk3k129N+uLv
         cfO4PNjQ7gsyeLulZEvuJR/0wZnwJw5LQO3K+zrXNGQIPt/EKYvXehcHui6zFJDXIUnE
         J2Fgkoa4rzxdQ6kmOws/hV47J1kGOaP1fxcq8M743f+WtNV2ZZ9DYHlsh1iqPpDbGt1B
         aE0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8iUBBrb6uG/19bm/v23Fimvl6BboTcp4QDBEzmTrjdg=;
        b=fthhk+PtS78vHqp1EECSrtJDdPanSHcopLf0y4HcFKtPFGDxkw2aLZkZILfzMBmqbv
         hV578fnyz5lHVDfv0NqQdRu4SxjR/eyosjWtNK8xSNgqt4jjt7jdBHHUUrzCLNJsUYAL
         LXZe37FET8I/yiyweb21ZNoP/6UMOk83P1vZNim+4gVFmGUnxrtWIiuB6D3MfTWZwOZ6
         RMxO0V5U3Mf/8V7Gdcg429OwbdE/1WIWAr9hRINP37AvGl/VA9G6gmFGYhbv6Asii64F
         v/mUQyoHy/pnB0eJVJ8u/t34HmH9Ek+1S3bweJ/PdcnZWl1sip1hqvOr2AV0rHzGI4km
         9IRg==
X-Gm-Message-State: AJIora+pyRqO/FqaoOnJLWTognbwdXfZ29iX3FZBqpb4Ko9KsOv/yIcJ
        KhyuKvzZVXHhlq7Yyo8L9ThNHp7fzItiIg==
X-Google-Smtp-Source: AGRyM1vBaep606UCHWFftQtm+W2nZYrHC/Vug8RDPVzTvvv12xj1eDl18Dh1ERhbXyEhHLM8GSGmpw==
X-Received: by 2002:a5d:6b81:0:b0:21d:72a8:73c9 with SMTP id n1-20020a5d6b81000000b0021d72a873c9mr4685926wrx.630.1657743240378;
        Wed, 13 Jul 2022 13:14:00 -0700 (PDT)
Received: from debian (host-78-150-47-22.as13285.net. [78.150.47.22])
        by smtp.gmail.com with ESMTPSA id o15-20020a05600c4fcf00b003a04962ad3esm3172474wmq.31.2022.07.13.13.13.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 13:13:59 -0700 (PDT)
Date:   Wed, 13 Jul 2022 21:13:57 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     riel@surriel.com, akpm@linux-foundation.org, hannes@cmpxchg.org,
        jhubbard@nvidia.com, linmiaohe@huawei.com, mgorman@suse.de,
        naoya.horiguchi@nec.com, osalvador@suse.de, stable@vger.kernel.org,
        torvalds@linux-foundation.org, willy@infradead.org
Subject: Re: FAILED: patch "[PATCH] mm: invalidate hwpoison page cache page
 in fault path" failed to apply to 4.9-stable tree
Message-ID: <Ys8nhREHBqv64dxR@debian>
References: <1648820031141132@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8e73YR91cTf3proM"
Content-Disposition: inline
In-Reply-To: <1648820031141132@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--8e73YR91cTf3proM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Fri, Apr 01, 2022 at 03:33:51PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.9-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport.

--
Regards
Sudip

--8e73YR91cTf3proM
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-mm-invalidate-hwpoison-page-cache-page-in-fault-path.patch"

From 37252de40b42bfaf259bf35b63f4e362b631844a Mon Sep 17 00:00:00 2001
From: Rik van Riel <riel@surriel.com>
Date: Tue, 22 Mar 2022 14:44:09 -0700
Subject: [PATCH] mm: invalidate hwpoison page cache page in fault path

commit e53ac7374e64dede04d745ff0e70ff5048378d1f upstream.

Sometimes the page offlining code can leave behind a hwpoisoned clean
page cache page.  This can lead to programs being killed over and over
and over again as they fault in the hwpoisoned page, get killed, and
then get re-spawned by whatever wanted to run them.

This is particularly embarrassing when the page was offlined due to
having too many corrected memory errors.  Now we are killing tasks due
to them trying to access memory that probably isn't even corrupted.

This problem can be avoided by invalidating the page from the page fault
handler, which already has a branch for dealing with these kinds of
pages.  With this patch we simply pretend the page fault was successful
if the page was invalidated, return to userspace, incur another page
fault, read in the file from disk (to a new memory page), and then
everything works again.

Link: https://lkml.kernel.org/r/20220212213740.423efcea@imladris.surriel.com
Signed-off-by: Rik van Riel <riel@surriel.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[sudip: use int instead of vm_fault_t and adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 mm/memory.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 1b31cdce936e9..36d46e19df960 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2891,10 +2891,15 @@ static int __do_fault(struct fault_env *fe, pgoff_t pgoff,
 	}
 
 	if (unlikely(PageHWPoison(vmf.page))) {
-		if (ret & VM_FAULT_LOCKED)
+		int poisonret = VM_FAULT_HWPOISON;
+		if (ret & VM_FAULT_LOCKED) {
+			/* Retry if a clean page was removed from the cache. */
+			if (invalidate_inode_page(vmf.page))
+				poisonret = 0;
 			unlock_page(vmf.page);
+		}
 		put_page(vmf.page);
-		return VM_FAULT_HWPOISON;
+		return poisonret;
 	}
 
 	if (unlikely(!(ret & VM_FAULT_LOCKED)))
-- 
2.30.2


--8e73YR91cTf3proM--
