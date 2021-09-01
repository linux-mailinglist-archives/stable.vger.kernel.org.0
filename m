Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49ECA3FE01F
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 18:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343948AbhIAQln (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 12:41:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:57826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245345AbhIAQlm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 12:41:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 909566108B;
        Wed,  1 Sep 2021 16:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630514444;
        bh=mB2cwuX11vBXy1XtIvBkgbVTYycu/wT4dazyfxEhyIw=;
        h=From:To:Cc:Subject:Date:From;
        b=Nx3R5G91wUdm/u5yAlifz4js1QqtEwfml0EHVmqE3hWmjaA2NFzpiBraUo4PFSWOz
         fRYFrLXMBJeytxKQU0oa4FUzxbyxicwpraxknzgzLNTwYZKY45s6Mc2XhMzC39j4HG
         fvL07lASQFvCmefOMQSW2oaqUopXFO2ajIwQonzbQCOhYMD+wlBN53DPpOH4WI94k7
         r45PYUBYwQQ3aHb5PvsKN325REiyMUbyZqapdObzfzMkO/cEU1WcTnEB+WgWimPVHb
         Dk8N/LjoQFR1DvYk1FV3YYwqRfNTNC1mgVXyXIqXIPEN7DJ3VPbHSWyNALHDF86ijp
         pGETRjYVsuiUA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org
Subject: [PATCH 5.4 0/4] backport fscrypt symlink fixes to 5.4
Date:   Wed,  1 Sep 2021 09:40:37 -0700
Message-Id: <20210901164041.176238-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This series backports some patches that failed to apply to 5.4-stable
due to the prototype of inode_operations::getattr having changed in
v5.12, as well several other conflicts.  Please apply to 5.4-stable.

Eric Biggers (4):
  fscrypt: add fscrypt_symlink_getattr() for computing st_size
  ext4: report correct st_size for encrypted symlinks
  f2fs: report correct st_size for encrypted symlinks
  ubifs: report correct st_size for encrypted symlinks

 fs/crypto/hooks.c       | 44 +++++++++++++++++++++++++++++++++++++++++
 fs/ext4/symlink.c       | 11 ++++++++++-
 fs/f2fs/namei.c         | 11 ++++++++++-
 fs/ubifs/file.c         | 12 ++++++++++-
 include/linux/fscrypt.h |  7 +++++++
 5 files changed, 82 insertions(+), 3 deletions(-)

-- 
2.33.0

