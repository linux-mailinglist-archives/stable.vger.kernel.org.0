Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09DDA2E6A55
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 20:14:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729003AbgL1TN5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 14:13:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:41780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729000AbgL1TN4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 14:13:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 328CF229EF;
        Mon, 28 Dec 2020 19:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609182796;
        bh=WfRrNEImpr0j+Oo7HcTLI/gAY4EckaLzvRW0Nnzz9QA=;
        h=From:To:Cc:Subject:Date:From;
        b=QOEccFRDvvHr/4eKSIAJZC9fjOwN3vBNabeHqiWacoH3tyHdSDbB8u4lpQ+8ivZxl
         Vj85wtNi/mrufL/iKzCrKR1/nEgU9SrebR++4bzxFl2/Mshw+ScfXbUGolntZpLcZE
         zR/pJJuYEA50Ka0SdVTXsXN6PD2pSUJF8c7MYQoQhutE/MoeyIxxhKk6gUyxpWeFUi
         +0bbHBksTbZrbahMx4nfKbVwhjK/ZpuA+wCDeiY7tX1IQ55bIU4t4Mgo21/1nR8+sT
         8+BUv+NXhmRp7IYFdAl2VBy8p/RCY7xctzJSOrcD5z4ydBVzm8Z0p4lpURPSIy4ONa
         Ecy4xLRIL/voA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org
Subject: [PATCH 4.19 0/4] fscrypt: prevent creating duplicate encrypted filenames
Date:   Mon, 28 Dec 2020 11:12:07 -0800
Message-Id: <20201228191211.138300-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Backport four commits from v5.11-rc1.  I resolved conflicts in the first
two.

Eric Biggers (4):
  fscrypt: add fscrypt_is_nokey_name()
  ext4: prevent creating duplicate encrypted filenames
  f2fs: prevent creating duplicate encrypted filenames
  ubifs: prevent creating duplicate encrypted filenames

 fs/crypto/hooks.c               | 10 +++++-----
 fs/ext4/namei.c                 |  3 +++
 fs/f2fs/f2fs.h                  |  2 ++
 fs/ubifs/dir.c                  | 17 +++++++++++++----
 include/linux/fscrypt_notsupp.h |  5 +++++
 include/linux/fscrypt_supp.h    | 29 +++++++++++++++++++++++++++++
 6 files changed, 57 insertions(+), 9 deletions(-)

-- 
2.29.2

