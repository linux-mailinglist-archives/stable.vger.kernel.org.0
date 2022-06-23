Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 172B655771A
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 11:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbiFWJuN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 05:50:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbiFWJuM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 05:50:12 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C77279FC6;
        Thu, 23 Jun 2022 02:50:11 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id t3-20020a17090a510300b001ea87ef9a3dso2050200pjh.4;
        Thu, 23 Jun 2022 02:50:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OrccWdamTvgOFcK19T+WIMvuOqIZDWIcCJSvAHqZYgQ=;
        b=XjhOaxiES3eKDxQTefCRzGhA0CftQ33Vaeb7/1vjcIeITxNJ2ZAZbBA0eFNioDm0AO
         Z5r6T9DPWXsq/H4BGJ4aDNolUGGYlOJT8B0yM26QcE+0hp7W5qnCiUaSULWvw92UzbSd
         Z2BZv8p/4hqesWUtQrS0Rf1OfPZTIqzcP6L8+tAqdBkkwQTmHLoAnomd1/qtCV9Yy9RO
         bPAJao5jlYLqYtxkbfENzP99y2XZYLndJN9dkaEQDZOFFBQ7qVMdzSkMojHdqAojm43s
         ExysRASALskXVUEOvFQMnLbpQAZzIEgJN1btk36g9BBx6vhiACwDGKeHnSZI/0+VkwTk
         6zYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OrccWdamTvgOFcK19T+WIMvuOqIZDWIcCJSvAHqZYgQ=;
        b=iF+9ECwkkxeWBOck/TnJqylkAPG4x0O8TZICjbnQDSccK4fsn1rXTso7ZpI6EGhTuP
         8q292EV9zPwtIa6ag6zWiHjn3+yW8O8cJfpUP6kPHztpCH/z8q3A0+qSkISaTIK7zIdQ
         yDKRs+3avArTJXmsmNYOvL0bzDUubGhwrAdzR27BqTc9TcGaPr33IKkeKY9kfvvQW7Hs
         z5XVidt95lOEdz5HekspS3g5ZpXrKfSaoS5pkMrfwlNUSRo7Fk/Px2Hn2zhckWJ3KOR0
         BkVx873pap8/nzJdbx0An7OguchKhmySL2riyHFkPo/3HByO6jGiH+4h2cCQKuvbSO6G
         X1WQ==
X-Gm-Message-State: AJIora8lGJcAlSNWQyeZflZAy7klTbz7d0J+CRCadbY+gHfWATNIny/x
        0HvLD4fLqpchWd5n0huedLfmT6aK78Y=
X-Google-Smtp-Source: AGRyM1vXNXQtf2JKIcz4hWc7g4muk3EZd3qtFB/vvHoJgWjPRgUKMqqvlySR52Ijuv1LnDibSicp3g==
X-Received: by 2002:a17:902:d2c1:b0:16a:4028:4748 with SMTP id n1-20020a170902d2c100b0016a40284748mr10367479plc.37.1655977811369;
        Thu, 23 Jun 2022 02:50:11 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id y2-20020a17090264c200b0016a12fab6c2sm10055543pli.307.2022.06.23.02.50.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 02:50:10 -0700 (PDT)
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
Subject: [PATCH v2] fs/ntfs: fix BUG_ON of ntfs_read_block()
Date:   Thu, 23 Jun 2022 09:49:56 +0000
Message-Id: <20220623094956.977053-1-xu.xin16@zte.com.cn>
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

As the bug description at
https://lore.kernel.org/lkml/20220623033635.973929-1-xu.xin16@zte.com.cn/
attckers can use this bug to crash the system.

So to avoid panic, remove the BUG_ON, and use ntfs_warning to output a
warning to the syslog and return instead until someone really solve
the problem.

Cc: stable@vger.kernel.org
Reported-by: Zeal Robot <zealci@zte.com.cn>
Reported-by: syzbot+6a5a7672f663cce8b156@syzkaller.appspotmail.com
Reviewed-by: Songyi Zhang <zhang.songyi@zte.com.cn>
Reviewed-by: Yang Yang <yang.yang29@zte.com.cn>
Reviewed-by: Jiang Xuexin<jiang.xuexin@zte.com.cn>
Reviewed-by: Zhang wenya<zhang.wenya1@zte.com.cn>
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
---

Change for v2:
 - Use ntfs_warning instead of WARN().
 - Add the tag Cc: stable@vger.kernel.org.
---
 fs/ntfs/aops.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs/aops.c b/fs/ntfs/aops.c
index 5f4fb6ca6f2e..84d68efb4ace 100644
--- a/fs/ntfs/aops.c
+++ b/fs/ntfs/aops.c
@@ -183,7 +183,12 @@ static int ntfs_read_block(struct page *page)
 	vol = ni->vol;
 
 	/* $MFT/$DATA must have its complete runlist in memory at all times. */
-	BUG_ON(!ni->runlist.rl && !ni->mft_no && !NInoAttr(ni));
+	if (unlikely(!ni->runlist.rl && !ni->mft_no && !NInoAttr(ni))) {
+		ntfs_warning(vi->i_sb, "Error because ni->runlist.rl, ni->mft_no, "
+				"and NInoAttr(ni) is null.");
+		unlock_page(page);
+		return -EINVAL;
+	}
 
 	blocksize = vol->sb->s_blocksize;
 	blocksize_bits = vol->sb->s_blocksize_bits;
-- 
2.25.1

