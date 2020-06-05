Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14FB71EFA1F
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 16:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728076AbgFEOLG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 10:11:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:42192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728077AbgFEOLC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 10:11:02 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF8EC20820;
        Fri,  5 Jun 2020 14:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591366261;
        bh=YKJVHzXXq2VAMYT4rnlQ6FLHVU/ktgvPpJGIFjY1AFQ=;
        h=Date:From:To:To:To:Cc:CC:Cc:Subject:In-Reply-To:References:From;
        b=ULHedspxsrNLQVLlyMQbEIG16ueMTt+Rb8074CgT6b1hsCX89TfGllQZpP3PzaYlL
         rX3lQDDiy5W1CJRwGAg8IZage8oEDZJz0ZXL60l/QYT11iDXsDm5KRISmLGQoQbCLy
         fmk/b2b5+C+rlc9SHLebfqkAaOk4rRFt2Qs02x58=
Date:   Fri, 05 Jun 2020 14:11:00 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Jan Kara <jack@suse.cz>
To:     <linux-fsdevel@vger.kernel.org>
Cc:     Ted Tso <tytso@mit.edu>, Martijn Coenen <maco@android.com>
CC:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 1/3] writeback: Avoid skipping inode writeback
In-Reply-To: <20200601091904.4786-1-jack@suse.cz>
References: <20200601091904.4786-1-jack@suse.cz>
Message-Id: <20200605141100.EF8EC20820@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 0ae45f63d4ef ("vfs: add support for a lazytime mount option").

The bot has tested the following trees: v5.6.15, v5.4.43, v4.19.125, v4.14.182, v4.9.225, v4.4.225.

v5.6.15: Build OK!
v5.4.43: Build OK!
v4.19.125: Build OK!
v4.14.182: Failed to apply! Possible dependencies:
    80ea09a002bf ("vfs: factor out inode_insert5()")
    c2b6d621c4ff ("new primitive: discard_new_inode()")

v4.9.225: Failed to apply! Possible dependencies:
    09d8b586731b ("ovl: move __upperdentry to ovl_inode")
    13c72075ac9f ("ovl: move impure to ovl_inode")
    2aff4534b6c4 ("ovl: check lower existence when removing")
    2b8c30e9ef14 ("ovl: use d_is_dir()")
    32a3d848eb91 ("ovl: clean up kstat usage")
    370e55ace59c ("ovl: rename: simplify handling of lower/merged directory")
    38e813db61c3 ("ovl: get rid of PURE type")
    3ee23ff1025a ("ovl: check lower existence of rename target")
    42f269b92540 ("ovl: rearrange code in ovl_copy_up_locked()")
    5cf5b477f0ca ("ovl: opaque cleanup")
    6c02cb59e6fe ("ovl: rename ovl_rename2() to ovl_rename()")
    804032fabb3b ("ovl: don't check rename to self")
    80ea09a002bf ("vfs: factor out inode_insert5()")
    8ee6059c58ea ("ovl: simplify lookup")
    a6c606551141 ("ovl: redirect on rename-dir")
    ad0af7104dad ("vfs: introduce inode 'inuse' lock")
    bbb1e54dd53c ("ovl: split super.c")
    c2b6d621c4ff ("new primitive: discard_new_inode()")
    c412ce498396 ("ovl: add ovl_dentry_is_whiteout()")
    ca4c8a3a8000 ("ovl: treat special files like a regular fs")
    d8514d8edb5b ("ovl: copy up regular file using O_TMPFILE")

v4.4.225: Failed to apply! Possible dependencies:
    09d8b586731b ("ovl: move __upperdentry to ovl_inode")
    1175b6b8d963 ("ovl: do operations on underlying file system in mounter's context")
    13c72075ac9f ("ovl: move impure to ovl_inode")
    2864f3014242 ("iget_locked et.al.: make sure we don't return bad inodes")
    32a3d848eb91 ("ovl: clean up kstat usage")
    38b256973ea9 ("ovl: handle umask and posix_acl_default correctly on creation")
    42f269b92540 ("ovl: rearrange code in ovl_copy_up_locked()")
    6b2553918d8b ("replace ->follow_link() with new method that could stay in RCU mode")
    80ea09a002bf ("vfs: factor out inode_insert5()")
    aa80deab33a8 ("namei: page_getlink() and page_follow_link_light() are the same thing")
    ad0af7104dad ("vfs: introduce inode 'inuse' lock")
    bb0d2b8ad296 ("ovl: fix sgid on directory")
    c2b6d621c4ff ("new primitive: discard_new_inode()")
    d6335d77a762 ("security: Make inode argument of inode_getsecid non-const")
    d8514d8edb5b ("ovl: copy up regular file using O_TMPFILE")
    d8ad8b496184 ("security, overlayfs: provide copy up security hook for unioned files")
    fceef393a538 ("switch ->get_link() to delayed_call, kill ->put_link()")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
