Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8755C3D7E8E
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 21:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232002AbhG0Tfi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 15:35:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:33898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231932AbhG0Tfh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Jul 2021 15:35:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 900B760FC0;
        Tue, 27 Jul 2021 19:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627414536;
        bh=267PIO/Q/Z/swiMVmO5I3Io2gZyj2QBLk7hMJ/bN2wM=;
        h=Date:From:To:Subject:From;
        b=F/o2TBPgpT/6dKnyvT/uKUm0b+iss3QHmezrYhNyae1bRZojnUoBk2hRTqzxXx92T
         g+nlTzLAPZQu7k0cB1shKst1AnuHIiSan8CHDqTaVYtY9GjyVz6CALHQv9wRE/oT+L
         lBtsa7pqCckY5/uL5L+HI4StDz+zqouyKjACL2Ho=
Date:   Tue, 27 Jul 2021 12:35:36 -0700
From:   akpm@linux-foundation.org
To:     bugs+kernel.org@dtnr.ch, dhowells@redhat.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, viro@zeniv.linux.org.uk,
        willy@infradead.org
Subject:  [merged]
 hugetlbfs-fix-mount-mode-command-line-processing.patch removed from -mm
 tree
Message-ID: <20210727193536.kY_oivuVS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: hugetlbfs: fix mount mode command line processing
has been removed from the -mm tree.  Its filename was
     hugetlbfs-fix-mount-mode-command-line-processing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlbfs: fix mount mode command line processing

In commit 32021982a324 ("hugetlbfs: Convert to fs_context") processing of
the mount mode string was changed from match_octal() to fsparam_u32.  This
changed existing behavior as match_octal does not require octal values to
have a '0' prefix, but fsparam_u32 does.

Use fsparam_u32oct which provides the same behavior as match_octal.

Link: https://lkml.kernel.org/r/20210721183326.102716-1-mike.kravetz@oracle.com
Fixes: 32021982a324 ("hugetlbfs: Convert to fs_context")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reported-by: Dennis Camera <bugs+kernel.org@dtnr.ch>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/hugetlbfs/inode.c~hugetlbfs-fix-mount-mode-command-line-processing
+++ a/fs/hugetlbfs/inode.c
@@ -77,7 +77,7 @@ enum hugetlb_param {
 static const struct fs_parameter_spec hugetlb_fs_parameters[] = {
 	fsparam_u32   ("gid",		Opt_gid),
 	fsparam_string("min_size",	Opt_min_size),
-	fsparam_u32   ("mode",		Opt_mode),
+	fsparam_u32oct("mode",		Opt_mode),
 	fsparam_string("nr_inodes",	Opt_nr_inodes),
 	fsparam_string("pagesize",	Opt_pagesize),
 	fsparam_string("size",		Opt_size),
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlb-simplify-prep_compound_gigantic_page-ref-count-racing-code.patch
hugetlb-drop-ref-count-earlier-after-page-allocation.patch
hugetlb-before-freeing-hugetlb-page-set-dtor-to-appropriate-value.patch

