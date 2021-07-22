Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00D033D2EF8
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 23:18:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231295AbhGVUiQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 16:38:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231154AbhGVUiQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Jul 2021 16:38:16 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6B37C061575
        for <stable@vger.kernel.org>; Thu, 22 Jul 2021 14:18:49 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id j6-20020a05600c1906b029023e8d74d693so423233wmq.3
        for <stable@vger.kernel.org>; Thu, 22 Jul 2021 14:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uQ4/0jlqdqtENdWYg8ZHQh0yiJSMqgakQ6JFMt89Pe4=;
        b=LYXla9lV/0xko5lxRWCm71Kb7A8r+VOG9sT3dR7Pl1TqTlbpcfd1ckCSLappOgI7QT
         FKZ+8t8oPAoHfNC0p/N5NtMkWXB+/3cedi7Hdq4YRG02RcGB/osFHTEwwJPMY+pfBhJ5
         CiKUyWoXowfwqHmCDL8st77gZYzNogSDHXu0Kf8AjpWRLVoT4oQfAqEoGj3OXkiAwWtM
         mISEqlgLtGOiVmJIjQ+D+bkhYHe091PGr5wGvvyrcsDk/BTgXaEmEltngOpX29FHmzIR
         4XhsddKTelwcxDtHpu0G7U48x+4XOa2kOBnAxUXJFzTAJQB+Wz2kEISUwvUH2zhA59p1
         UGRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uQ4/0jlqdqtENdWYg8ZHQh0yiJSMqgakQ6JFMt89Pe4=;
        b=tE/zTvCMAnD1U0KyCAUJzsEQGhK6nF5OyNF2gJ69n/wpN0EfrGTyNhS14ekJBm/DYu
         hQMbNs2Kyi4kz8sKV9TixMWKm+m0wihHpjJyKoU9aen4QuzrSpdpjX8dwXEmmP1Z5tCT
         ryij2cOqV4UYOpCrqaBbV+x+BINtgWxmD8mwWYC5NrT9A4n4Suz0pdwsMx/Y5WbBuelZ
         Tk0BNW3RdE7OKJZ+fM6a5TYK/YD3F+L7ChhXBGahgAvg39VXMCBlLKw20bxrlydgRAS2
         cTwjlnwA7gGauydaIwlFAvABiPJEzML0ketO1WCzOREfbNDE8aBNNRxIz1WKi1vMTg3H
         NIiQ==
X-Gm-Message-State: AOAM533pE9xWj0uCwDK8jH4rAF+ietQzmYlM/KFXZnoy4XQVMXLwFri5
        xRKis74y/t5r6EHnA4SpWg0=
X-Google-Smtp-Source: ABdhPJyFxdD0dSvz0uN/BVKb7EAQjwnYBPTbwNs82lLN5K36KtRabjcNhX38LtHMuaMBtlvtyBHf0A==
X-Received: by 2002:a05:600c:1c93:: with SMTP id k19mr1422058wms.125.1626988728399;
        Thu, 22 Jul 2021 14:18:48 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id p8sm3512967wmc.24.2021.07.22.14.18.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jul 2021 14:18:47 -0700 (PDT)
Date:   Thu, 22 Jul 2021 22:18:46 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     dsterba@suse.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] btrfs: compression: don't try to compress
 if we don't have" failed to apply to 4.9-stable tree
Message-ID: <YPngtpwRabvjaoR1@debian>
References: <162600608216394@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="SZFOZevJIac9hZWu"
Content-Disposition: inline
In-Reply-To: <162600608216394@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--SZFOZevJIac9hZWu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Sun, Jul 11, 2021 at 02:21:22PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.9-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport, will also apply to 4.4-stable.

--
Regards
Sudip

--SZFOZevJIac9hZWu
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-btrfs-compression-don-t-try-to-compress-if-we-don-t-.patch"

From c2b38628ed59f7251f29e8cecb9f9d11c69c1ff0 Mon Sep 17 00:00:00 2001
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
index 4b671e5c33ce..a55d23a73cdb 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -484,7 +484,7 @@ static noinline void compress_file_range(struct inode *inode,
 	 * inode has not been flagged as nocompress.  This flag can
 	 * change at any time if we discover bad compression ratios.
 	 */
-	if (inode_need_compress(inode)) {
+	if (nr_pages > 1 && inode_need_compress(inode)) {
 		WARN_ON(pages);
 		pages = kcalloc(nr_pages, sizeof(struct page *), GFP_NOFS);
 		if (!pages) {
-- 
2.30.2


--SZFOZevJIac9hZWu--
