Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD335571E7
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 06:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbiFWEnl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 00:43:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243803AbiFWDvj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jun 2022 23:51:39 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1B5D3DA6B;
        Wed, 22 Jun 2022 20:51:37 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id 128so10886119pfv.12;
        Wed, 22 Jun 2022 20:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SE8Cyd5D2F3Gapqonu8kjnsg469j0MuWbe97VzxGp0Y=;
        b=mzdriuBZ08DLZXLAn8XMYCJ4traDlEFDGJFl2MWA8LWIAIlzp2d4ST0Wb6RZ7k4SGG
         8NaancbgYYiDNSYXxq5L9xqULz4/3dv2K2VlMLTuL2a5nUBLceDY8Z+7hjgeXlJ7TAV3
         7vwuCbRlha7LlZxkMDQw3OTrVLuw7+1mwA9wMn5GxAmVDyvMooVwNjnppsvgCNNF8byj
         XbsK160moO+Ar7UuyqA4hpXciiFlp9VSTkadud5AkkovAx+UkOhy5Mc7PIFNT/Vrs80T
         r25cShcvPpEcU7HiaRVz7O9wE9U3P1ACWdPU78MRX5luTRdRvjYkO5CwJ+PXNODdePJ6
         hDZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SE8Cyd5D2F3Gapqonu8kjnsg469j0MuWbe97VzxGp0Y=;
        b=48WfK3zCuGdSFBW/3rSkYbL84nETt4RhXcw6ZM8suISgbBELByaVa65JsynZ0auh8y
         ELsC246L0JWkETSjIpLsgDxsbQv2u5GZ08CCfAsttLgUNOQaz8Deicqj5neKGADLyG9w
         38IXo8l0bAKc1c/LSkz9CLLpZwJ4Q5bVjDT1CFZhN/1sMHXuJCXloMKbV7+bE92umXFN
         tgpoNKJ+YwmRLoUY9E8TAgSV5Cn5TZ/JkWllSzQyNWzkNO8ex2vpTPAILc3snErbFjTp
         pgXh0FNMQrQzetXkwPRnkjMyZzxW8vGSALsFO7gBX9ZUl7Jn3gvuVvgjtc5R4JOYRq+W
         BS3Q==
X-Gm-Message-State: AJIora9y+oFtJK1UCeZH9RUng8L7q6KTNmxpRUtsQ4agre4YcDmyDVK0
        p4KyIR3BAZ84i/lGeyqPaDo=
X-Google-Smtp-Source: AGRyM1seNpP6PU74KVHMDfnFNv2Yp8QA/MoGChiUdkdh4xJA2T88T+REoG+NB7OEzbDOwVmA4V9F8Q==
X-Received: by 2002:a05:6a00:1a0e:b0:523:1e7c:e26e with SMTP id g14-20020a056a001a0e00b005231e7ce26emr38289798pfv.60.1655956297312;
        Wed, 22 Jun 2022 20:51:37 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id p6-20020a62d006000000b0051b9a2d639dsm4969205pfg.43.2022.06.22.20.51.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jun 2022 20:51:36 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: xu.xin16@zte.com.cn
To:     anton@tuxera.com, linux-ntfs-dev@lists.sourceforge.net,
        stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, xu.xin16@zte.com.cn,
        linux-fsdevel@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>,
        syzbot+6a5a7672f663cce8b156@syzkaller.appspotmail.com,
        Songyi Zhang <zhang.songyi@zte.com.cn>,
        Yang Yang <yang.yang29@zte.com.cn>,
        Jiang Xuexin <jiang.xuexin@zte.com.cn>,
        Zhang wenya <zhang.wenya1@zte.com.cn>
Subject: [PATCH] fs/ntfs: fix BUG_ON of ntfs_read_block()
Date:   Thu, 23 Jun 2022 03:51:31 +0000
Message-Id: <20220623035131.974098-1-xu.xin16@zte.com.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220623033635.973929-1-xu.xin16@zte.com.cn>
References: <20220623033635.973929-1-xu.xin16@zte.com.cn>
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

From: xu xin <xu.xin16@zte.com.cn>

As the bug description, attckers can use this bug to crash the system
When CONFIG_NTFS_FS is set.

So remove the BUG_ON, and use WARN and return instead until someone
really solve the bug.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Reported-by: syzbot+6a5a7672f663cce8b156@syzkaller.appspotmail.com
Reviewed-by: Songyi Zhang <zhang.songyi@zte.com.cn>
Reviewed-by: Yang Yang <yang.yang29@zte.com.cn>
Reviewed-by: Jiang Xuexin<jiang.xuexin@zte.com.cn>
Reviewed-by: Zhang wenya<zhang.wenya1@zte.com.cn>
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
---
 fs/ntfs/aops.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs/aops.c b/fs/ntfs/aops.c
index 5f4fb6ca6f2e..b6fd7e711420 100644
--- a/fs/ntfs/aops.c
+++ b/fs/ntfs/aops.c
@@ -183,7 +183,11 @@ static int ntfs_read_block(struct page *page)
 	vol = ni->vol;
 
 	/* $MFT/$DATA must have its complete runlist in memory at all times. */
-	BUG_ON(!ni->runlist.rl && !ni->mft_no && !NInoAttr(ni));
+	if (unlikely(!ni->runlist.rl && !ni->mft_no && !NInoAttr(ni))) {
+		WARN(1, "NTFS: ni->runlist.rl, ni->mft_no, and NInoAttr(ni) is null!\n");
+		unlock_page(page);
+		return -EINVAL;
+	}
 
 	blocksize = vol->sb->s_blocksize;
 	blocksize_bits = vol->sb->s_blocksize_bits;
-- 
2.25.1

