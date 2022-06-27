Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8172B55CFA6
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232550AbiF0GwM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 02:52:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232531AbiF0GwF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 02:52:05 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F9A026C3;
        Sun, 26 Jun 2022 23:52:03 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id k129so3360997wme.0;
        Sun, 26 Jun 2022 23:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cXA+/dAUwgRQc5EpwS/X0n2pUieK6tax4HxbsNJh6Rw=;
        b=HBG2JgJWn1H2765iGqIVvafKAWajPv7fVVqfxilqZ75yu5ajAgaqSUXwMRT5+gCL0B
         Qhv2xsPsmtriHPUV4z4TZP1rr0eoCd+dXxCcpjAl52UKuZXYLqqOuaE4Eje8ERD8R7R+
         2HsLAhkyo3evqn/e3JsWypeO86IzxerGN509bPdsEqwXZL0DeaCwabzJRrM/87lBjTx9
         1aL582AlH8Qhe+vo45jZoEEq8XOn591OygSGnvv9tHgrfsI+AvcVU7jO2S/1e1ZNQYd3
         wqah/AcpKF1BJN0kmLWP4YY0Qe4hSSF+Q27S0YGuUjwWl33X0bHApSME7Al8B4K4gkSD
         nLDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cXA+/dAUwgRQc5EpwS/X0n2pUieK6tax4HxbsNJh6Rw=;
        b=LfVJSgZs4SnxeFBeUf6sbovLC5D5MhuJ5CtkyOTw9F1yPbk9KhF12Ly4ut9Yp6BJeu
         7QwMPAI9z0bXDjpYGj2pD/SxBg/XkRn4KS8c4v2KVaJsxkTrtXrOJ5QKWuwtfgWzywuX
         OwU1SjF0/Z2MmESpXzee1+NJMnuEeEfzxT9L/GacYIzWj/O5MgQzyCihbZ5m1CDmkiG8
         /quDa42GAhQh/WKt/Aob4pBVtYdRmofYT3e7UllpsJqGat9nRzcEtyFAVHPhAF2Eydvh
         X1zj8UbK4l1Yd0e3nYMJj8/grLQprJ1GD8bxV2NrqFBzE3WGhpKVdg2ZQh10/Hel06x7
         VIUg==
X-Gm-Message-State: AJIora/6HOQ1nBZUL/kKxCHoRPbVLQdj7e0W9R2+t0NwAOKvXg5yCYyG
        EItXTwTLdDDJkpHPeP773NY=
X-Google-Smtp-Source: AGRyM1uukK3LlvNhgRdLlMtRwbh5h/ZVkpAEq6NeKdvFNBZjMGsdniUJdCdp1O1WP6KS1MKSfwM3vQ==
X-Received: by 2002:a05:600c:1553:b0:39c:87fc:579e with SMTP id f19-20020a05600c155300b0039c87fc579emr13005339wmg.102.1656312722036;
        Sun, 26 Jun 2022 23:52:02 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([77.137.66.49])
        by smtp.gmail.com with ESMTPSA id e10-20020adffd0a000000b0021a3dd1c5d5sm9415076wrr.96.2022.06.26.23.52.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jun 2022 23:52:01 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org,
        Yang Xu <xuyang2018.jy@fujitsu.com>
Subject: [PATCH 5.10 v4 3/5] xfs: Fix the free logic of state in xfs_attr_node_hasname
Date:   Mon, 27 Jun 2022 09:51:38 +0300
Message-Id: <20220627065140.2798412-4-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220627065140.2798412-1-amir73il@gmail.com>
References: <20220627065140.2798412-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Xu <xuyang2018.jy@fujitsu.com>

commit a1de97fe296c52eafc6590a3506f4bbd44ecb19a upstream.

When testing xfstests xfs/126 on lastest upstream kernel, it will hang on some machine.
Adding a getxattr operation after xattr corrupted, I can reproduce it 100%.

The deadlock as below:
[983.923403] task:setfattr        state:D stack:    0 pid:17639 ppid: 14687 flags:0x00000080
[  983.923405] Call Trace:
[  983.923410]  __schedule+0x2c4/0x700
[  983.923412]  schedule+0x37/0xa0
[  983.923414]  schedule_timeout+0x274/0x300
[  983.923416]  __down+0x9b/0xf0
[  983.923451]  ? xfs_buf_find.isra.29+0x3c8/0x5f0 [xfs]
[  983.923453]  down+0x3b/0x50
[  983.923471]  xfs_buf_lock+0x33/0xf0 [xfs]
[  983.923490]  xfs_buf_find.isra.29+0x3c8/0x5f0 [xfs]
[  983.923508]  xfs_buf_get_map+0x4c/0x320 [xfs]
[  983.923525]  xfs_buf_read_map+0x53/0x310 [xfs]
[  983.923541]  ? xfs_da_read_buf+0xcf/0x120 [xfs]
[  983.923560]  xfs_trans_read_buf_map+0x1cf/0x360 [xfs]
[  983.923575]  ? xfs_da_read_buf+0xcf/0x120 [xfs]
[  983.923590]  xfs_da_read_buf+0xcf/0x120 [xfs]
[  983.923606]  xfs_da3_node_read+0x1f/0x40 [xfs]
[  983.923621]  xfs_da3_node_lookup_int+0x69/0x4a0 [xfs]
[  983.923624]  ? kmem_cache_alloc+0x12e/0x270
[  983.923637]  xfs_attr_node_hasname+0x6e/0xa0 [xfs]
[  983.923651]  xfs_has_attr+0x6e/0xd0 [xfs]
[  983.923664]  xfs_attr_set+0x273/0x320 [xfs]
[  983.923683]  xfs_xattr_set+0x87/0xd0 [xfs]
[  983.923686]  __vfs_removexattr+0x4d/0x60
[  983.923688]  __vfs_removexattr_locked+0xac/0x130
[  983.923689]  vfs_removexattr+0x4e/0xf0
[  983.923690]  removexattr+0x4d/0x80
[  983.923693]  ? __check_object_size+0xa8/0x16b
[  983.923695]  ? strncpy_from_user+0x47/0x1a0
[  983.923696]  ? getname_flags+0x6a/0x1e0
[  983.923697]  ? _cond_resched+0x15/0x30
[  983.923699]  ? __sb_start_write+0x1e/0x70
[  983.923700]  ? mnt_want_write+0x28/0x50
[  983.923701]  path_removexattr+0x9b/0xb0
[  983.923702]  __x64_sys_removexattr+0x17/0x20
[  983.923704]  do_syscall_64+0x5b/0x1a0
[  983.923705]  entry_SYSCALL_64_after_hwframe+0x65/0xca
[  983.923707] RIP: 0033:0x7f080f10ee1b

When getxattr calls xfs_attr_node_get function, xfs_da3_node_lookup_int fails with EFSCORRUPTED in
xfs_attr_node_hasname because we have use blocktrash to random it in xfs/126. So it
free state in internal and xfs_attr_node_get doesn't do xfs_buf_trans release job.

Then subsequent removexattr will hang because of it.

This bug was introduced by kernel commit 07120f1abdff ("xfs: Add xfs_has_attr and subroutines").
It adds xfs_attr_node_hasname helper and said caller will be responsible for freeing the state
in this case. But xfs_attr_node_hasname will free state itself instead of caller if
xfs_da3_node_lookup_int fails.

Fix this bug by moving the step of free state into caller.

[amir: this text from original commit is not relevant for 5.10 backport:
Also, use "goto error/out" instead of returning error directly in xfs_attr_node_addname_find_attr and
xfs_attr_node_removename_setup function because we should free state ourselves.
]

Fixes: 07120f1abdff ("xfs: Add xfs_has_attr and subroutines")
Signed-off-by: Yang Xu <xuyang2018.jy@fujitsu.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 96ac7e562b87..fcca36bbd997 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -876,21 +876,18 @@ xfs_attr_node_hasname(
 
 	state = xfs_da_state_alloc(args);
 	if (statep != NULL)
-		*statep = NULL;
+		*statep = state;
 
 	/*
 	 * Search to see if name exists, and get back a pointer to it.
 	 */
 	error = xfs_da3_node_lookup_int(state, &retval);
-	if (error) {
-		xfs_da_state_free(state);
-		return error;
-	}
+	if (error)
+		retval = error;
 
-	if (statep != NULL)
-		*statep = state;
-	else
+	if (!statep)
 		xfs_da_state_free(state);
+
 	return retval;
 }
 
-- 
2.25.1

