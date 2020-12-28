Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB55C2E6A37
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 19:56:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728864AbgL1S4J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 13:56:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:39472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728860AbgL1S4I (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 13:56:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26B51221F8;
        Mon, 28 Dec 2020 18:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609181728;
        bh=VkM+zALiqlg97TIjo+lgwe+6aK90+NNjU4+Z9i2Ja24=;
        h=From:To:Cc:Subject:Date:From;
        b=ESLnjXJ1nWfg071HzMKi/VfMc46fxKf9sg+yrbZG3jQShKB2zf8GvycxGjG9U0Wq0
         zxZ/M3JAGElSFaoJ3DvCZhYO8QqQzYTFYSIpwnTG7D4XPRncnVmEjney2iv0O4MWbp
         5ex621LfQTUa4CnDtpFtITCIexEo2MIA7qCcTD4pZU9S+r+vro3DysR3L7bAYy4jYp
         Ecn8zRekNnyoQY7zRxZu0drNqbMSKb+cv9C5BQnKrYQdEy/sW1SWWyK4uqDgQtzFNz
         DDRxrxOGQe6cwRBmMnWrp41pfs8t1krRUDkAWK0xaDYjiWLZXDvWumXu6XsfETJQZ5
         N+xvAYvaKrGPQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org
Subject: [PATCH 5.4 0/4] fscrypt: prevent creating duplicate encrypted filenames
Date:   Mon, 28 Dec 2020 10:54:29 -0800
Message-Id: <20201228185433.61129-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Backport four commits from v5.11-rc1.  I resolved a conflict in the
first one.  The rest are clean cherry-picks which didn't get picked up
yet because they depend on the first one.

Eric Biggers (4):
  fscrypt: add fscrypt_is_nokey_name()
  ext4: prevent creating duplicate encrypted filenames
  f2fs: prevent creating duplicate encrypted filenames
  ubifs: prevent creating duplicate encrypted filenames

 fs/crypto/hooks.c       | 10 +++++-----
 fs/ext4/namei.c         |  3 +++
 fs/f2fs/f2fs.h          |  2 ++
 fs/ubifs/dir.c          | 17 +++++++++++++----
 include/linux/fscrypt.h | 34 ++++++++++++++++++++++++++++++++++
 5 files changed, 57 insertions(+), 9 deletions(-)

-- 
2.29.2

