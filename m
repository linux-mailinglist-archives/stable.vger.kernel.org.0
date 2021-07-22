Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 406203D2EF7
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 23:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231260AbhGVUhD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 16:37:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231154AbhGVUhD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Jul 2021 16:37:03 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F15DC061575
        for <stable@vger.kernel.org>; Thu, 22 Jul 2021 14:17:36 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 9-20020a05600c26c9b02901e44e9caa2aso413083wmv.4
        for <stable@vger.kernel.org>; Thu, 22 Jul 2021 14:17:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=imwylJOB3tLGS9yNrxkycmWB4XzAS1utu2lxgu3S5Ow=;
        b=rFlFLZVs1n7uLnQJdx6n1Gu2KDQZQqHEjsl4JbUCT8erh53f7z56Jnz+mBmlK9f9Fr
         lhSk/jQ4XTFCNmHNYC3X6HtiWQqNWGqFug6Fo7jZewdvTx4qqvZHVnvleFcv9LQOw/+b
         vHNhrYGkzxlo6/cm5HziC0i4+uA5+JbnfsZGj25wkMrfc9S2FPUBSrCCbVpToGEhrXxR
         VFpKKbaJl8UGvBKHDIB99Wc59S1cAopB5BIh9A1y+CG5+M6eSHszFf9Lj2NxveZfQprP
         Ab49sfhMTyn7zPFtgisY9LQCEDldByYNUEt4Wd3ZBCV2c3/RVy9XXZ3a4505IV3FOSbT
         R8Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=imwylJOB3tLGS9yNrxkycmWB4XzAS1utu2lxgu3S5Ow=;
        b=KoAvogRDGKVgQRcj+9PNTjTrC9LG0t6U5DlraAj3wZYMX/tIYIz9ObsznrzKQRJudI
         uJVTP4q3WXXCC4ctZcrYmsnwntGxzfgj78tkbRXg+Dn2++2unj95CYMMNZdslGJzU/9C
         aCrRNiH6PLZR/UnvBuf7cOhLKVUuqCVW/tByTJiwxPH/IxXlRl13E3WKZcRSJUtCMBcW
         VfqC54MmfZobXrKklq4LVDYWkEyNPTsc/r7osulrSOLeFgwCldxOxhatlHUUfsmJK8Zv
         RjIqtZ2Ivs67UIriUJRvGqH/UeRirmJHdP7e7F9Mbw8aZIgazomDIU1916fH0Olb19B2
         r06w==
X-Gm-Message-State: AOAM530wG8mhCZgJ2k2NF9estGL/+IIhOH6lzBAXbeH/z0jUrFRsTYg8
        +MS0MLbIGFM+3ULVZgVRcI0=
X-Google-Smtp-Source: ABdhPJyJsvW30iH8aKeADiaKjPMbq2vv3Ogl9yicqx8FtJ8Klgb8/pZrHjFTf6Zltpv9Zv8OHmANmA==
X-Received: by 2002:a1c:38c7:: with SMTP id f190mr11195619wma.29.1626988655205;
        Thu, 22 Jul 2021 14:17:35 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id m187sm31591680wmm.16.2021.07.22.14.17.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jul 2021 14:17:34 -0700 (PDT)
Date:   Thu, 22 Jul 2021 22:17:33 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     dsterba@suse.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] btrfs: compression: don't try to compress
 if we don't have" failed to apply to 5.4-stable tree
Message-ID: <YPngbeb+IJpUY08E@debian>
References: <1626006084107128@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="JfNWPArEDSWXVnof"
Content-Disposition: inline
In-Reply-To: <1626006084107128@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--JfNWPArEDSWXVnof
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Sun, Jul 11, 2021 at 02:21:24PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport, will also apply to all branches till 4.14-stable.

--
Regards
Sudip

--JfNWPArEDSWXVnof
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-btrfs-compression-don-t-try-to-compress-if-we-don-t-.patch"

From 6a9596aacb9cc11149423390ac429f9ab5b30075 Mon Sep 17 00:00:00 2001
From: David Sterba <dsterba@suse.com>
Date: Mon, 14 Jun 2021 12:45:18 +0200
Subject: [PATCH] btrfs: compression: don't try to compress if we don't have
 enough pages

commit f2165627319ffd33a6217275e5690b1ab5c45763 upstream

The early check if we should attempt compression does not take into
account the number of input pages. It can happen that there's only one
page, eg. a tail page after some ranges of the BTRFS_MAX_UNCOMPRESSED
have been processed, or an isolated page that won't be converted to an
inline extent.

The single page would be compressed but a later check would drop it
again because the result size must be at least one block shorter than
the input. That can never work with just one page.

CC: stable@vger.kernel.org # 4.4+
Signed-off-by: David Sterba <dsterba@suse.com>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 fs/btrfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 64dd702a5448..025b02e9799f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -543,7 +543,7 @@ static noinline int compress_file_range(struct async_chunk *async_chunk)
 	 * inode has not been flagged as nocompress.  This flag can
 	 * change at any time if we discover bad compression ratios.
 	 */
-	if (inode_need_compress(inode, start, end)) {
+	if (nr_pages > 1 && inode_need_compress(inode, start, end)) {
 		WARN_ON(pages);
 		pages = kcalloc(nr_pages, sizeof(struct page *), GFP_NOFS);
 		if (!pages) {
-- 
2.30.2


--JfNWPArEDSWXVnof--
