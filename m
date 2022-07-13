Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CBA4573DA5
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 22:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbiGMUL5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 16:11:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236437AbiGMUL4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 16:11:56 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C66DC2A73D
        for <stable@vger.kernel.org>; Wed, 13 Jul 2022 13:11:54 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id z12so17023124wrq.7
        for <stable@vger.kernel.org>; Wed, 13 Jul 2022 13:11:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=t4PfTSn1qhuTirXEQzPcMMCQA+yr5qCC4SSQsOkH2P0=;
        b=BpNcVj5BKKuRsx/T7FZeQyNUj13vM8DzBv6cjhvUvZpK8IX28eSOQJCWNzIFXLD7mc
         Eut62YvX+FkMJHKTMe2fwoYuYSY36SN+L4fncXHI1CPhca3haW0P7Ylq7i03B2AXK/gX
         MN3cUxxWnIXrx7MRcajPSBO3g9OV8dor7tncMckhOfDofY7J5oZXBXS3lfmj1HwLLgYt
         QS500zMP9bW4ezXmFRundI/Sg5hlKCjIqVmIjSWqgs/QfystXboOCoV5m9E4AHIb54VK
         QybWTwU30PggNA1gjjVs/ghXPsUWgUg2pC9sZKnAic/KMb5DQed15/ZQbn11m1D8wc9Y
         U08g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=t4PfTSn1qhuTirXEQzPcMMCQA+yr5qCC4SSQsOkH2P0=;
        b=tbjpaZcpom84E4Aw3bpbniWF488iPADxV6Cj4coUs67ScaHJFYUzIZ0n0JyBhW3ezV
         7XJoSvvt3FdnKdrL4wZxbxWXF/bYeZ+mFbfrXRPYylc1o92lrtE0h3b9hBUbuqiqAUcs
         X2ARTNdCqUb+pdsKV9j3P4mjbOzjn4Hem8PuxkQF98ksbBRWHId1YqcBWeTRY9A4dnOs
         2IAm+p7nY1Mn7N8TQD1F7BzUgimVVM8NOhBxK5bfxkLPImKUFyDiHxSxDaeegmqOo4+N
         H+PlMffLh67lVvqhMfWFlrb4DtXufZZLHyOyisx7tmodyVZvjv6kFYH8Y6l7f3h/Rs0F
         nrKw==
X-Gm-Message-State: AJIora/obQzCSwXMy80K0edoT9d5J6DCpcFn/j6L9442BXW2+5M9XKbd
        neSrWOzYBalGJVfmHhZshDM=
X-Google-Smtp-Source: AGRyM1vMsHjDEE51bHJgQxdUpoFScs6IKu54n1HFn+uD+n0heHZkmKxPN1llYIe5soIVSZMgpWl4WQ==
X-Received: by 2002:a05:6000:1205:b0:21d:aa9b:9993 with SMTP id e5-20020a056000120500b0021daa9b9993mr4902379wrx.476.1657743113325;
        Wed, 13 Jul 2022 13:11:53 -0700 (PDT)
Received: from debian (host-78-150-47-22.as13285.net. [78.150.47.22])
        by smtp.gmail.com with ESMTPSA id p185-20020a1c29c2000000b003a2e2a2e294sm3216276wmp.18.2022.07.13.13.11.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 13:11:52 -0700 (PDT)
Date:   Wed, 13 Jul 2022 21:11:50 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     riel@surriel.com, akpm@linux-foundation.org, hannes@cmpxchg.org,
        jhubbard@nvidia.com, linmiaohe@huawei.com, mgorman@suse.de,
        naoya.horiguchi@nec.com, osalvador@suse.de, stable@vger.kernel.org,
        torvalds@linux-foundation.org, willy@infradead.org
Subject: Re: FAILED: patch "[PATCH] mm: invalidate hwpoison page cache page
 in fault path" failed to apply to 4.14-stable tree
Message-ID: <Ys8nBq9dzw9gzVkw@debian>
References: <164882002824865@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="vRGKYmIPh8ztCVjm"
Content-Disposition: inline
In-Reply-To: <164882002824865@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--vRGKYmIPh8ztCVjm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Fri, Apr 01, 2022 at 03:33:48PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.14-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport.

--
Regards
Sudip

--vRGKYmIPh8ztCVjm
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-mm-invalidate-hwpoison-page-cache-page-in-fault-path.patch"

From c28271b2a06bf66bdbde09481ffb500387a50238 Mon Sep 17 00:00:00 2001
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
[sudip: use int instead of vm_fault_t]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 mm/memory.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 4154fb45ac0f7..615cb3fe763dd 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3342,11 +3342,16 @@ static int __do_fault(struct vm_fault *vmf)
 		return ret;
 
 	if (unlikely(PageHWPoison(vmf->page))) {
-		if (ret & VM_FAULT_LOCKED)
+		int poisonret = VM_FAULT_HWPOISON;
+		if (ret & VM_FAULT_LOCKED) {
+			/* Retry if a clean page was removed from the cache. */
+			if (invalidate_inode_page(vmf->page))
+				poisonret = 0;
 			unlock_page(vmf->page);
+		}
 		put_page(vmf->page);
 		vmf->page = NULL;
-		return VM_FAULT_HWPOISON;
+		return poisonret;
 	}
 
 	if (unlikely(!(ret & VM_FAULT_LOCKED)))
-- 
2.30.2


--vRGKYmIPh8ztCVjm--
