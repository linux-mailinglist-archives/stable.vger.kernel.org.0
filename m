Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E87B6E737A
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 08:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232289AbjDSGqr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 02:46:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232210AbjDSGqi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 02:46:38 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9114A7DBA
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 23:46:35 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id 38308e7fff4ca-2a7b02615f1so26571601fa.0
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 23:46:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681886792; x=1684478792;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mg3hFFEYg9rjeRRqNxH7dxRCsGy2Ei2NZXADrlDawGE=;
        b=fSptfvGlYyYMLDAmKGHM6aYgYLR45w64zlDTLiWj5cOtwA68nYiGORAnlDvTtZk8wA
         KnmBzyxYVcmYCWtpGHq7gyFsxms3fdKMT0nVHhP/ubB+QgGfGkQKG+9/XpSYTy1+cEUM
         TkCM8w5L6hcFmoWS2Ub0ySKKLa/zEBih7kgknIrcNVKoYobXOu/O5xbr+GZESoOe83Ye
         3HK+8TomCVCIhDTNhkh4MYMl8V1TyKU2ZRn4WPMh2V2x1+R3PG83ub5HhxMf6va9IRx7
         z0fkyIIvFOpDnWeO8otaqNyvmSQqN2zGLQeJ4TkTVcIdfDFAdN2bUSn1vdy+y4XiORuR
         ZH7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681886792; x=1684478792;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mg3hFFEYg9rjeRRqNxH7dxRCsGy2Ei2NZXADrlDawGE=;
        b=kyRU7tq0fSHTOnTmvnny3l9PUP2jtY9tfmG65zWpMefhIp270ZGSU62JCoprdgOzSx
         SZUKR5ZZFAC7DL+e/ukKMMaxVOfHOGHl++GC7J5XzRwyeQNVXkai5bbhrqTcRlBfYTFO
         2PhZ+Svlc/S6dKKBwea6tR/Su9WGzK14FpuMxd3LOWk909LobwdYDJDvltUGrWh9Upg4
         Ng+5V9/CG1B4J//mvRAar6x5m/csdkwkbdy+GI4+NFfY4m8lNeCCDnMnvEbWbz0NdtkJ
         om3JNnkfuUHfgu49+uCWDrfoVJCZRXnawWRTQM32kBCjr3vTJQMjN88secWV6LI7yQJH
         vi1Q==
X-Gm-Message-State: AAQBX9dDEZi5bcIakfIQNspv9+3N8zO6mNXPOXVwtZG6Qy/JQeBIYKDh
        7Vq3vVqnI6aEwtoce44nK+0LBOO7CFAYMh6plaIq4Q==
X-Google-Smtp-Source: AKy350ZJ+8tqcc55x9d49dQOePwISnYLrozPMVqlrVMlCrrFdGR91J/i/F7qKRekszkAGVTNzwEgaQ==
X-Received: by 2002:ac2:4578:0:b0:4ed:d5b0:7fd9 with SMTP id k24-20020ac24578000000b004edd5b07fd9mr851088lfm.19.1681886792672;
        Tue, 18 Apr 2023 23:46:32 -0700 (PDT)
Received: from ta1.c.googlers.com.com (61.215.228.35.bc.googleusercontent.com. [35.228.215.61])
        by smtp.gmail.com with ESMTPSA id e24-20020ac25478000000b004edce1d338csm438208lfn.89.2023.04.18.23.46.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 23:46:29 -0700 (PDT)
From:   Tudor Ambarus <tudor.ambarus@linaro.org>
To:     stable@vger.kernel.org
Cc:     tytso@mit.edu, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        joneslee@google.com, Baokun Li <libaokun1@huawei.com>,
        stable@kernel.org, Hulk Robot <hulkci@huawei.com>,
        Ritesh Harjani <ritesh.list@gmail.com>,
        Jan Kara <jack@suse.cz>,
        Tudor Ambarus <tudor.ambarus@linaro.org>
Subject: [PATCH][for stable [4.14, 5.10] 3/3] ext4: fix use-after-free in ext4_xattr_set_entry
Date:   Wed, 19 Apr 2023 06:46:10 +0000
Message-ID: <20230419064610.1918038-4-tudor.ambarus@linaro.org>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
In-Reply-To: <20230419064610.1918038-1-tudor.ambarus@linaro.org>
References: <20230419064610.1918038-1-tudor.ambarus@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit 67d7d8ad99beccd9fe92d585b87f1760dc9018e3 ]

Hulk Robot reported a issue:
==================================================================
BUG: KASAN: use-after-free in ext4_xattr_set_entry+0x18ab/0x3500
Write of size 4105 at addr ffff8881675ef5f4 by task syz-executor.0/7092

CPU: 1 PID: 7092 Comm: syz-executor.0 Not tainted 4.19.90-dirty #17
Call Trace:
[...]
 memcpy+0x34/0x50 mm/kasan/kasan.c:303
 ext4_xattr_set_entry+0x18ab/0x3500 fs/ext4/xattr.c:1747
 ext4_xattr_ibody_inline_set+0x86/0x2a0 fs/ext4/xattr.c:2205
 ext4_xattr_set_handle+0x940/0x1300 fs/ext4/xattr.c:2386
 ext4_xattr_set+0x1da/0x300 fs/ext4/xattr.c:2498
 __vfs_setxattr+0x112/0x170 fs/xattr.c:149
 __vfs_setxattr_noperm+0x11b/0x2a0 fs/xattr.c:180
 __vfs_setxattr_locked+0x17b/0x250 fs/xattr.c:238
 vfs_setxattr+0xed/0x270 fs/xattr.c:255
 setxattr+0x235/0x330 fs/xattr.c:520
 path_setxattr+0x176/0x190 fs/xattr.c:539
 __do_sys_lsetxattr fs/xattr.c:561 [inline]
 __se_sys_lsetxattr fs/xattr.c:557 [inline]
 __x64_sys_lsetxattr+0xc2/0x160 fs/xattr.c:557
 do_syscall_64+0xdf/0x530 arch/x86/entry/common.c:298
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x459fe9
RSP: 002b:00007fa5e54b4c08 EFLAGS: 00000246 ORIG_RAX: 00000000000000bd
RAX: ffffffffffffffda RBX: 000000000051bf60 RCX: 0000000000459fe9
RDX: 00000000200003c0 RSI: 0000000020000180 RDI: 0000000020000140
RBP: 000000000051bf60 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000001009 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffc73c93fc0 R14: 000000000051bf60 R15: 00007fa5e54b4d80
[...]
==================================================================

Above issue may happen as follows:
-------------------------------------
ext4_xattr_set
  ext4_xattr_set_handle
    ext4_xattr_ibody_find
      >> s->end < s->base
      >> no EXT4_STATE_XATTR
      >> xattr_check_inode is not executed
    ext4_xattr_ibody_set
      ext4_xattr_set_entry
       >> size_t min_offs = s->end - s->base
       >> UAF in memcpy

we can easily reproduce this problem with the following commands:
    mkfs.ext4 -F /dev/sda
    mount -o debug_want_extra_isize=128 /dev/sda /mnt
    touch /mnt/file
    setfattr -n user.cat -v `seq -s z 4096|tr -d '[:digit:]'` /mnt/file

In ext4_xattr_ibody_find, we have the following assignment logic:
  header = IHDR(inode, raw_inode)
         = raw_inode + EXT4_GOOD_OLD_INODE_SIZE + i_extra_isize
  is->s.base = IFIRST(header)
             = header + sizeof(struct ext4_xattr_ibody_header)
  is->s.end = raw_inode + s_inode_size

In ext4_xattr_set_entry
  min_offs = s->end - s->base
           = s_inode_size - EXT4_GOOD_OLD_INODE_SIZE - i_extra_isize -
	     sizeof(struct ext4_xattr_ibody_header)
  last = s->first
  free = min_offs - ((void *)last - s->base) - sizeof(__u32)
       = s_inode_size - EXT4_GOOD_OLD_INODE_SIZE - i_extra_isize -
         sizeof(struct ext4_xattr_ibody_header) - sizeof(__u32)

In the calculation formula, all values except s_inode_size and
i_extra_size are fixed values. When i_extra_size is the maximum value
s_inode_size - EXT4_GOOD_OLD_INODE_SIZE, min_offs is -4 and free is -8.
The value overflows. As a result, the preceding issue is triggered when
memcpy is executed.

Therefore, when finding xattr or setting xattr, check whether
there is space for storing xattr in the inode to resolve this issue.

Cc: stable@kernel.org
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220616021358.2504451-3-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
---
 fs/ext4/xattr.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 71e83e815258..28fa9a64dc4b 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -2193,8 +2193,9 @@ int ext4_xattr_ibody_find(struct inode *inode, struct ext4_xattr_info *i,
 	struct ext4_inode *raw_inode;
 	int error;
 
-	if (EXT4_I(inode)->i_extra_isize == 0)
+	if (!EXT4_INODE_HAS_XATTR_SPACE(inode))
 		return 0;
+
 	raw_inode = ext4_raw_inode(&is->iloc);
 	header = IHDR(inode, raw_inode);
 	is->s.base = is->s.first = IFIRST(header);
@@ -2222,8 +2223,9 @@ int ext4_xattr_ibody_set(handle_t *handle, struct inode *inode,
 	struct ext4_xattr_search *s = &is->s;
 	int error;
 
-	if (EXT4_I(inode)->i_extra_isize == 0)
+	if (!EXT4_INODE_HAS_XATTR_SPACE(inode))
 		return -ENOSPC;
+
 	error = ext4_xattr_set_entry(i, s, handle, inode, false /* is_block */);
 	if (error)
 		return error;
-- 
2.40.0.634.g4ca3ef3211-goog

