Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E91403FDFE4
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 18:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343748AbhIAQ3L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 12:29:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:45282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245484AbhIAQ3K (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 12:29:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C3C161053;
        Wed,  1 Sep 2021 16:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630513693;
        bh=fmOdVLIoHRP0uybJSMzliPgeLHikRzrbnj9mRMHwsVI=;
        h=From:To:Cc:Subject:Date:From;
        b=rFGSjUtgu2o8WUxV1cD9ekzKEXwohpHncP3cA/Klzfkc+TzlW+ItUIOV9VjA/fgci
         25aOGDMYYhlaiszzakBpjXF8kE3H63mrczpGcVzYmzHe3UVrxln5VN4TmboZQUDm+L
         NDWnc+7VobjJEACrDJEFafozFlyFyjMysDvtnKIj/fooIWoHBh8TiI+7GhYTalCC/a
         t0Ka0W9UT8Mrs/j6gTebf8YOaSA7ExfZsfHft8uI/JqGWOP9hd9wAL3Jz/a2WjWnZs
         f+JLqerG3ES+tJD8HCirfxe8Ipjzlenba2+zSwp7wGQZj35WFRDirxZycQ0xHJVVUi
         5NpA6UrWT9fAQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH 5.10 0/4] backport fscrypt symlink fixes to 5.10
Date:   Wed,  1 Sep 2021 09:27:17 -0700
Message-Id: <20210901162721.138605-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This series resolves some silent cherry-pick conflicts due to the
prototype of inode_operations::getattr having changed in v5.12, as well
as a conflict in the ubifs patch.  Please apply to 5.10-stable.

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

