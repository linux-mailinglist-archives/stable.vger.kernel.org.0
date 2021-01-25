Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91A33302C32
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 21:06:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbhAYUGf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 15:06:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:37376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731647AbhAYUGN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 15:06:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 792BA224F9;
        Mon, 25 Jan 2021 20:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611605132;
        bh=S1Vb4+jiVc09lYRuMnR8egvP0fyMYo1EXgluj8O3eHs=;
        h=From:To:Cc:Subject:Date:From;
        b=V3CfXN+G/m0igcnq7YU5W1NyN7/nWAtChoMfY7YW5JqEFrSzLPlErgq7lnNXifdQD
         3nY8WFnZUmlndtMM+Ho7HmLxWRd+HlCKWxu3hTeeITsQyRTmasMEzVQr37eTUK66D/
         O1YTrbH2C0lJy9NH7QtEK2EBAPLPMsy1uRK1C5Ji0tmuyICDaVr7chW+KggVIo9aWV
         uMutqCODkROCvNu2WI4xWAEkiRRuP463L4uns0PV6xXld2sisdvi2fYkZHU3j2N9W7
         4hBfdAz1a2zPsk1R2KI2MLvnZJMF6X7OzXo2OVv1fYt7a3VqCQVp4sUXEjHJQWxCPU
         9iE6QjwJqBL4A==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4.19 0/2] backport lazytime fix to 4.19
Date:   Mon, 25 Jan 2021 12:05:07 -0800
Message-Id: <20210125200509.261295-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Backport a lazytime fix from upstream to 4.19-stable.  The first commit
had a trivial conflict in fs/xfs/ due to a file being renamed.
Following that, the second commit is a clean cherry-pick.

Eric Biggers (1):
  fs: fix lazytime expiration handling in __writeback_single_inode()

Jan Kara (1):
  writeback: Drop I_DIRTY_TIME_EXPIRE

 fs/ext4/inode.c                  |  2 +-
 fs/fs-writeback.c                | 36 ++++++++++++++------------------
 fs/xfs/xfs_trans_inode.c         |  4 ++--
 include/linux/fs.h               |  1 -
 include/trace/events/writeback.h |  1 -
 5 files changed, 19 insertions(+), 25 deletions(-)

-- 
2.30.0

