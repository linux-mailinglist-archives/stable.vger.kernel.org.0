Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA7016E76B8
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 11:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232584AbjDSJtm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 05:49:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232577AbjDSJtj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 05:49:39 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20FA44C01;
        Wed, 19 Apr 2023 02:49:39 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id h24-20020a17090a9c1800b002404be7920aso456493pjp.5;
        Wed, 19 Apr 2023 02:49:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681897778; x=1684489778;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KSIQbw75eFFmcyo44AtEoA6kDkKcUqP4sxKGrhsBuD8=;
        b=L1e8st9M9nOfnbQv6jUMUKSpglmyEQxUQoPywwAqhqAKMQkqDfownds4R//QSkP8kR
         HMpGvziMawtXDRwLTlV6XHEIhDFg+eqWoQvORv9dtwUEwmIEOSRNFzX58YZCIPlg9l2I
         YkaB7zdASzd1PTXFPidwjGvynDdm8jkxjnw5vjTZHmnsVuXhFNa87NoDeiuEQp8iwnvd
         poRJXF6TwSSeEpO/kc+QL3ZEarAlZyQOkF5ZM6MtAzMNrpSSyOD/atEUCb71vvn6RazM
         2CXr8xlQSVRx/htbvBPnc+UN6MB3MDE+oLZijqCV+6NGROP4DKx8KUsmqlsYKxvuBM0i
         Zrtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681897778; x=1684489778;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KSIQbw75eFFmcyo44AtEoA6kDkKcUqP4sxKGrhsBuD8=;
        b=I1xM/OVASAalDvVKaQj2KLBceqpdhhVcQxybflnpbqmPZU+AnLH4fikYlo39IMEPYp
         IrJYEKqI0oGfT2VLipgwAlwLoINs3fCrEV1dhmWnvMaOYIzcWUi99/YbYkIje95Bvjxh
         0myv8YUl7JXhQY4QNIoPfHa8/85mR7ftUqxlE4ClWyXEb0EcBYXwVCEsUQ9f+dhsDczc
         w+BnOaLc9qFpbdKCBHzmxXT5lKdEBKanvZ6gjQDnzwfIAGGFKePFa5Nw81qUvO3j/GYT
         Z9YqwEGXLr5JD7YnB2AjwYAS4+wzVc+TG5CX5q/kZg3/TzATmGHrDpl8OTMv1Z2V3Yiq
         cW+Q==
X-Gm-Message-State: AAQBX9e2wQJ177t0qndNplDUWOTcai3OZebf3dlhPpiyakJ1yws3gZkb
        MJiGVqx33aCPzCY9IlAYiZFx44miYNy9JQ==
X-Google-Smtp-Source: AKy350YsjTwxai9e8vcgyTbKZdDuLzFl4BYR0SfHSe+kdMXLhTHKrfqk04hchwebLQLOEoaP3pkOgQ==
X-Received: by 2002:a05:6a21:620c:b0:ec:7cc:2da6 with SMTP id wm12-20020a056a21620c00b000ec07cc2da6mr2146284pzb.56.1681897778351;
        Wed, 19 Apr 2023 02:49:38 -0700 (PDT)
Received: from localhost.localdomain ([47.96.236.37])
        by smtp.gmail.com with ESMTPSA id g15-20020a62e30f000000b0063b86aff031sm6231207pfh.108.2023.04.19.02.49.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 02:49:37 -0700 (PDT)
From:   Yang Bo <yyyeer.bo@gmail.com>
X-Google-Original-From: Yang Bo <yb203166@antfin.com>
To:     stable@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, mszeredi@redhat.com,
        Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>,
        Zhang Tianci <zhangtianci.1997@bytedance.com>,
        Yang Bo <yb203166@antfin.com>
Subject: [PATCH 5/6] fuse: always revalidate rename target dentry
Date:   Wed, 19 Apr 2023 17:48:43 +0800
Message-Id: <20230419094844.51110-6-yb203166@antfin.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230419094844.51110-1-yb203166@antfin.com>
References: <20230419094844.51110-1-yb203166@antfin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>

commit ccc031e26afe60d2a5a3d93dabd9c978210825fb upstream.

[backport for 5.10.y]

The previous commit df8629af2934 ("fuse: always revalidate if exclusive
create") ensures that the dentries are revalidated on O_EXCL creates.  This
commit complements it by also performing revalidation for rename target
dentries.  Otherwise, a rename target file that only exists in kernel
dentry cache but not in the filesystem will result in EEXIST if
RENAME_NOREPLACE flag is used.

Signed-off-by: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
Signed-off-by: Zhang Tianci <zhangtianci.1997@bytedance.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Yang Bo <yb203166@antfin.com>
---
 fs/fuse/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 80a9e50392a0..bdb04bea0da9 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -205,7 +205,7 @@ static int fuse_dentry_revalidate(struct dentry *entry, unsigned int flags)
 	if (inode && fuse_is_bad(inode))
 		goto invalid;
 	else if (time_before64(fuse_dentry_time(entry), get_jiffies_64()) ||
-		 (flags & (LOOKUP_EXCL | LOOKUP_REVAL))) {
+		 (flags & (LOOKUP_EXCL | LOOKUP_REVAL | LOOKUP_RENAME_TARGET))) {
 		struct fuse_entry_out outarg;
 		FUSE_ARGS(args);
 		struct fuse_forget_link *forget;
-- 
2.40.0

