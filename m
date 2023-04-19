Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DBAC6E7376
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 08:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232322AbjDSGqh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 02:46:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232288AbjDSGqf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 02:46:35 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BECC06592
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 23:46:29 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id 2adb3069b0e04-4edb26f762dso2745048e87.3
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 23:46:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681886787; x=1684478787;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jqQrXVgyVsPhDEPu1uf0moF6UXupAeK1HLmcmrWKNZc=;
        b=pyZBCFKVXGkGtbNForbz4oqn9aALt1yJ2qTv21sFpWCaPs7y3o3itPZwNlXYxDZ1X4
         e2+zXbK8haPOL7atJAqJz3TSRswo+gxu2t3IOjoqXN+nKgGAPQEKIs6gmNj9ZwPHo+pW
         i00fxryFOga+RLGQZG0wffM8kE2IdiRgzBj2SgYHsU/t7UDAxJdONcYzSuzuvQgFR0Dr
         0UeoU6NeLGqs2xvDOoXgvOMajG6MbEDkhvOqeqtFDBeWcjvp0OkTTpa53BOuYx++tWV5
         la1d+FNAmh6NW2vBz2cTao+YfxDcFTDneLEhSmsAF0fv97V+CUwOm+62Tx0CD3e0vWa7
         IehQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681886787; x=1684478787;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jqQrXVgyVsPhDEPu1uf0moF6UXupAeK1HLmcmrWKNZc=;
        b=HMO9/xF43PtLoM/8YzMHad9ThC72ogtuVce+1rqO+OAUTkkAQ/1ROewaPU+f4chaX6
         XLn1FiLLEWJfrWIP/WVXPLbz1MOlghhXJpu+LxQNUL6EQv6AX8QwndoGz+pd7cJXWvVj
         KHk1yPRSim9vqzvUkVlllD8BJoBXX/UlvR1Sm6FXV5AFX6d9qlWmJpiJnZlQNPR00Ah8
         G9fvWu43za79UDO7EZiUL7UwgdLgS0+sBeqei3IoHXDiDPzyxgf+T9o6mgoFRTd08LKj
         nuSDG6Wl67zR7JHO7A6JCYKyW0rMYtjcwPHZd9zjrIdjfO1qZaUPBBJggEG/Nnc0XTeY
         5jDw==
X-Gm-Message-State: AAQBX9ceiKvG4MLMcL1UMDjr5yxOt26KjpMmnZyC3Z7BnA1+Ar/PitD8
        wxzrdZYIlPESLfDkJEQ0cKNL4J+F7Di5MAVL1hZzng==
X-Google-Smtp-Source: AKy350ZSoyLtR6o5cPRvICRvp1lsGOds+9tzMOxz12zRKhJyDZr6pFvB1bcIhGVaVtcu56QNgqioVQ==
X-Received: by 2002:ac2:551c:0:b0:4e7:dd1e:e521 with SMTP id j28-20020ac2551c000000b004e7dd1ee521mr3977750lfk.9.1681886787736;
        Tue, 18 Apr 2023 23:46:27 -0700 (PDT)
Received: from ta1.c.googlers.com.com (61.215.228.35.bc.googleusercontent.com. [35.228.215.61])
        by smtp.gmail.com with ESMTPSA id e24-20020ac25478000000b004edce1d338csm438208lfn.89.2023.04.18.23.46.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 23:46:26 -0700 (PDT)
From:   Tudor Ambarus <tudor.ambarus@linaro.org>
To:     stable@vger.kernel.org
Cc:     tytso@mit.edu, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        joneslee@google.com, Ritesh Harjani <riteshh@linux.ibm.com>,
        Tudor Ambarus <tudor.ambarus@linaro.org>
Subject: [PATCH][for stable [4.14, 5.10] 2/3] ext4: remove duplicate definition of ext4_xattr_ibody_inline_set()
Date:   Wed, 19 Apr 2023 06:46:09 +0000
Message-ID: <20230419064610.1918038-3-tudor.ambarus@linaro.org>
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

From: Ritesh Harjani <riteshh@linux.ibm.com>

[ Upstream commit 310c097c2bdbea253d6ee4e064f3e65580ef93ac ]

ext4_xattr_ibody_inline_set() & ext4_xattr_ibody_set() have the exact
same definition.  Hence remove ext4_xattr_ibody_inline_set() and all
its call references. Convert the callers of it to call
ext4_xattr_ibody_set() instead.

[ Modified to preserve ext4_xattr_ibody_set() and remove
  ext4_xattr_ibody_inline_set() instead. -- TYT ]

Signed-off-by: Ritesh Harjani <riteshh@linux.ibm.com>
Link: https://lore.kernel.org/r/fd566b799bbbbe9b668eb5eecde5b5e319e3694f.1622685482.git.riteshh@linux.ibm.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
---
 fs/ext4/inline.c | 11 +++++------
 fs/ext4/xattr.c  | 26 +-------------------------
 fs/ext4/xattr.h  |  6 +++---
 3 files changed, 9 insertions(+), 34 deletions(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 61cb50e8fcb7..0758f606f006 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -206,7 +206,7 @@ static int ext4_read_inline_data(struct inode *inode, void *buffer,
 /*
  * write the buffer to the inline inode.
  * If 'create' is set, we don't need to do the extra copy in the xattr
- * value since it is already handled by ext4_xattr_ibody_inline_set.
+ * value since it is already handled by ext4_xattr_ibody_set.
  * That saves us one memcpy.
  */
 static void ext4_write_inline_data(struct inode *inode, struct ext4_iloc *iloc,
@@ -288,7 +288,7 @@ static int ext4_create_inline_data(handle_t *handle,
 
 	BUG_ON(!is.s.not_found);
 
-	error = ext4_xattr_ibody_inline_set(handle, inode, &i, &is);
+	error = ext4_xattr_ibody_set(handle, inode, &i, &is);
 	if (error) {
 		if (error == -ENOSPC)
 			ext4_clear_inode_state(inode,
@@ -360,7 +360,7 @@ static int ext4_update_inline_data(handle_t *handle, struct inode *inode,
 	i.value = value;
 	i.value_len = len;
 
-	error = ext4_xattr_ibody_inline_set(handle, inode, &i, &is);
+	error = ext4_xattr_ibody_set(handle, inode, &i, &is);
 	if (error)
 		goto out;
 
@@ -433,7 +433,7 @@ static int ext4_destroy_inline_data_nolock(handle_t *handle,
 	if (error)
 		goto out;
 
-	error = ext4_xattr_ibody_inline_set(handle, inode, &i, &is);
+	error = ext4_xattr_ibody_set(handle, inode, &i, &is);
 	if (error)
 		goto out;
 
@@ -1930,8 +1930,7 @@ int ext4_inline_data_truncate(struct inode *inode, int *has_inline)
 			i.value = value;
 			i.value_len = i_size > EXT4_MIN_INLINE_DATA_SIZE ?
 					i_size - EXT4_MIN_INLINE_DATA_SIZE : 0;
-			err = ext4_xattr_ibody_inline_set(handle, inode,
-							  &i, &is);
+			err = ext4_xattr_ibody_set(handle, inode, &i, &is);
 			if (err)
 				goto out_error;
 		}
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 948da799abab..71e83e815258 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -2214,31 +2214,7 @@ int ext4_xattr_ibody_find(struct inode *inode, struct ext4_xattr_info *i,
 	return 0;
 }
 
-int ext4_xattr_ibody_inline_set(handle_t *handle, struct inode *inode,
-				struct ext4_xattr_info *i,
-				struct ext4_xattr_ibody_find *is)
-{
-	struct ext4_xattr_ibody_header *header;
-	struct ext4_xattr_search *s = &is->s;
-	int error;
-
-	if (EXT4_I(inode)->i_extra_isize == 0)
-		return -ENOSPC;
-	error = ext4_xattr_set_entry(i, s, handle, inode, false /* is_block */);
-	if (error)
-		return error;
-	header = IHDR(inode, ext4_raw_inode(&is->iloc));
-	if (!IS_LAST_ENTRY(s->first)) {
-		header->h_magic = cpu_to_le32(EXT4_XATTR_MAGIC);
-		ext4_set_inode_state(inode, EXT4_STATE_XATTR);
-	} else {
-		header->h_magic = cpu_to_le32(0);
-		ext4_clear_inode_state(inode, EXT4_STATE_XATTR);
-	}
-	return 0;
-}
-
-static int ext4_xattr_ibody_set(handle_t *handle, struct inode *inode,
+int ext4_xattr_ibody_set(handle_t *handle, struct inode *inode,
 				struct ext4_xattr_info *i,
 				struct ext4_xattr_ibody_find *is)
 {
diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
index b357872ab83b..e5e36bd11f05 100644
--- a/fs/ext4/xattr.h
+++ b/fs/ext4/xattr.h
@@ -200,9 +200,9 @@ extern int ext4_xattr_ibody_find(struct inode *inode, struct ext4_xattr_info *i,
 extern int ext4_xattr_ibody_get(struct inode *inode, int name_index,
 				const char *name,
 				void *buffer, size_t buffer_size);
-extern int ext4_xattr_ibody_inline_set(handle_t *handle, struct inode *inode,
-				       struct ext4_xattr_info *i,
-				       struct ext4_xattr_ibody_find *is);
+extern int ext4_xattr_ibody_set(handle_t *handle, struct inode *inode,
+				struct ext4_xattr_info *i,
+				struct ext4_xattr_ibody_find *is);
 
 extern struct mb_cache *ext4_xattr_create_cache(void);
 extern void ext4_xattr_destroy_cache(struct mb_cache *);
-- 
2.40.0.634.g4ca3ef3211-goog

