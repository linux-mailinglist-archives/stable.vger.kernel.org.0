Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9FB85F139B
	for <lists+stable@lfdr.de>; Fri, 30 Sep 2022 22:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbiI3U0F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Sep 2022 16:26:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231254AbiI3U0D (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Sep 2022 16:26:03 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3BD0169E48
        for <stable@vger.kernel.org>; Fri, 30 Sep 2022 13:26:01 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id x1-20020a17090ab00100b001fda21bbc90so10109009pjq.3
        for <stable@vger.kernel.org>; Fri, 30 Sep 2022 13:26:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=YE0SZ4gBncQDeK9j3l04fLVzWw7p9nvQyXdyQahbHpU=;
        b=MHuWmCgd4y4F8BHQakd4cyxU1e11wTMNHKWT5HVecIMb91/uknuOliHQyHF6xInjg4
         Sh8r647iHiEAXt1VUR2TW8sU4fW5H++kG9eFIeh/bG/dPm/kOTzjgt9gKQb45f2ss51R
         Z0Ud32t/dpzUpAmjITNzp6f6cIFkV2jSnwqhIehBt56431J5ZGvZwkW2WOtVtQiMp/TE
         35UceN9gk4izAiscbq5emiwV8Wn/DPe/aBP9jAPuq0LBK35c51MlV2U3PCQel04EpvUE
         o5zqEhq+9LPlNIdx1fy2Zmah67OPUm8TPHn/CVTpvzb5NUa1dBuw+q7ol+vX9tZGUtyn
         9yNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=YE0SZ4gBncQDeK9j3l04fLVzWw7p9nvQyXdyQahbHpU=;
        b=49y+/o2YDZ5lkCFtt5KqIaJG9Du0hONwkTDdsWwqKQYS+C0YeIFPhLEXvuWdg+q8eC
         EcDLuh/L6yOmMM7wnhUEiOinKJOWeesmkSQczORTobS3G0fqyuuLL06bJNTXaJ3mwwWy
         ZFQFpZGmLiDU/Frsh0fjDS6olx0c5QhpINaSXnfVJOAs2tbMb1IqfrH1IPLbUKRmGD4l
         90o+py1hW6LPBNtW+obHFkLbRtQkF+L1Xm5PR2a27u9Bbi3ARdOObYoEsyPLIjIw1fz5
         oUZ4NQuTMEdMSn58hIM3mKCUng7GsJiNOTcEfzTKpIszxV/2UXsVYvTM8uU+ALy9YRzp
         ijtg==
X-Gm-Message-State: ACrzQf3lDTkNXVZE0qPm5EX82boVcKv8GeDfFDAnhVEUYF5P0QDpGj4f
        TETz9ihoXMWwrDPj9a9x4J76yQ==
X-Google-Smtp-Source: AMsMyM4kckeDXdDRB8vLlvF8nF4/llXkzukZDaKrRq5NNopR/Xxw1hp5Jbv+YJlNvL4dg2C+zRTvQQ==
X-Received: by 2002:a17:902:dac4:b0:178:2a6f:bc7f with SMTP id q4-20020a170902dac400b001782a6fbc7fmr10891894plx.129.1664569561528;
        Fri, 30 Sep 2022 13:26:01 -0700 (PDT)
Received: from desktop.hsd1.or.comcast.net ([2601:1c0:4c81:c480:feaa:14ff:fe3a:b225])
        by smtp.gmail.com with ESMTPSA id i7-20020a170902c94700b0016d9d6d05f7sm2342237pla.273.2022.09.30.13.26.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 13:26:00 -0700 (PDT)
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
To:     "Theodore Ts'o" <tytso@mit.edu>
Cc:     Tadeusz Struk <tadeusz.struk@linaro.org>,
        "Andreas Dilger" <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        syzbot+a22dc4b0744ac658ed9b@syzkaller.appspotmail.com
Subject: [PATCH] ext4: Add extend check to prevent BUG() in ext4_es_end
Date:   Fri, 30 Sep 2022 13:25:36 -0700
Message-Id: <20220930202536.697396-1-tadeusz.struk@linaro.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Syzbot reported an issue with ext4 extents. The reproducer creates
a corrupted ext4 fs image in memory, and mounts it as a loop device.
It invokes the ext4_cache_extents() and ext4_find_extent(), which
eventually triggers a BUG() in ext4_es_end() causing a kernel crash.
It triggers on mainline, and every kernel version back to v4.14.
Add a call ext4_ext_check_inode() in ext4_find_extent() to prevent
the crash.

To: "Theodore Ts'o" <tytso@mit.edu>
Cc: "Andreas Dilger" <adilger.kernel@dilger.ca>
Cc: <linux-ext4@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: <stable@vger.kernel.org>

Link: https://syzkaller.appspot.com/bug?id=641e7a4b900015c5d7a729d6cc1fba7a928a88f9
Reported-by: syzbot+a22dc4b0744ac658ed9b@syzkaller.appspotmail.com
Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
---
 fs/ext4/extents.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 5235974126bd..c7b5a11e1abc 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -897,6 +897,12 @@ ext4_find_extent(struct inode *inode, ext4_lblk_t block,
 		goto err;
 	}
 
+	ret = ext4_ext_check_inode(inode);
+	if (ret) {
+		EXT4_ERROR_INODE(inode, "inode has invalid extent");
+		goto err;
+	}
+
 	if (path) {
 		ext4_ext_drop_refs(path);
 		if (depth > path[0].p_maxdepth) {
-- 
2.37.3

