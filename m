Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DFCA1B2659
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 14:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728884AbgDUMkz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 08:40:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728874AbgDUMky (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 08:40:54 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F493C061A10
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 05:40:54 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id u127so3515991wmg.1
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 05:40:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yaJJtBeg9pW+fx6OVq7h64qYCeUsMdpitM20LISFeq8=;
        b=lu8K0xiOQyVkDkU3kapyNmhq8Ag8U4Pc18sehh68/yS25iFyM/Dy9YcCAbPQlG2PgO
         04jwZbd0jj/aHWi8Wq6N+3sqkyMQ/eEND1MgEnPA2eTyB1wfXMXIMT8XXOlJKwoqc90/
         EL+l++hl9daVos7Jl+H53gXgps5xzkZ4Mj7d91c8dk8ZkUm9/PSm9tDfDk2jQ62fJlTb
         5Nw+7OWsG60CFvhjbHCYOS5crsqpA4oC3s1W43XJvjkvzsvHDn6Ctr4Lyvoy48zShgVl
         u2Laei3w1XqlkYLmoK4ru/3JUSfO5UPz6bfB7dq1T1Uf1rrNmoTF1cKa/fM23ynxPemR
         kynA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yaJJtBeg9pW+fx6OVq7h64qYCeUsMdpitM20LISFeq8=;
        b=K+G6zPejoOCP2x/vbQTo45oTSzporIKKtBiebo5SzQvfH1B6L2WlcryBxfNk3jIhLs
         n+9kgl/F2PTKc8uc39ymBxaRqM1InMTWpjxGrM5xS5Y0WbYX5ZzpciXTgXzrX3PI2enx
         zT/qK85VY9VueqT6BVXdcNuFchh+8nBf4hUnWP2+SXYA7mkXtvnWZT0hOQw8IorB0h/8
         m33LxmeD+veyj/ZzBZQ6L3l50Eod5jmEeoaiaJoPl9Zx299Isa3qGzJ/CvSZLW6VfGEy
         v+fh92JwhEP7CPS4qysChBrM9sv0+FLeUVyMC04KyBtfnuw7RN5Pu1t0FuA93dAnMaKb
         D5gA==
X-Gm-Message-State: AGi0PubQih+CtX8//OGOGDc2wA2LGc8Df2hnlcKzijyKqRjVZbwoYJyX
        +bJNhwdtpd2Eaw5LOFA2NrqmxykCwPM=
X-Google-Smtp-Source: APiQypKszn+JoxaYQcsPb4nIwylYVL3u01Q16k+IFvCRNH7MttTMs1ttL49YHbjrBSXa0y1Cdv1PPg==
X-Received: by 2002:a1c:41d7:: with SMTP id o206mr4762543wma.89.1587472852674;
        Tue, 21 Apr 2020 05:40:52 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id u3sm3408232wrt.93.2020.04.21.05.40.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 05:40:51 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Todd Kjos <tkjos@android.com>,
        Martijn Coenen <maco@android.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.14 06/24] android: binder: Use true and false for boolean values
Date:   Tue, 21 Apr 2020 13:39:59 +0100
Message-Id: <20200421124017.272694-7-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200421124017.272694-1-lee.jones@linaro.org>
References: <20200421124017.272694-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>

[ Upstream commit 197410ad884eb18b31d48e9d8e64cb5a9e326f2f ]

Assign true or false to boolean variables instead of an integer value.

This issue was detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Cc: Todd Kjos <tkjos@android.com>
Cc: Martijn Coenen <maco@android.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/android/binder.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index 05e75d18b4d93..afb690ed31ed9 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -249,7 +249,7 @@ static struct binder_transaction_log_entry *binder_transaction_log_add(
 	unsigned int cur = atomic_inc_return(&log->cur);
 
 	if (cur >= ARRAY_SIZE(log->entry))
-		log->full = 1;
+		log->full = true;
 	e = &log->entry[cur % ARRAY_SIZE(log->entry)];
 	WRITE_ONCE(e->debug_id_done, 0);
 	/*
@@ -2598,7 +2598,7 @@ static bool binder_proc_transaction(struct binder_transaction *t,
 			target_list = &node->async_todo;
 			wakeup = false;
 		} else {
-			node->has_async_transaction = 1;
+			node->has_async_transaction = true;
 		}
 	}
 
@@ -3453,7 +3453,7 @@ static int binder_thread_write(struct binder_proc *proc,
 				w = binder_dequeue_work_head_ilocked(
 						&buf_node->async_todo);
 				if (!w) {
-					buf_node->has_async_transaction = 0;
+					buf_node->has_async_transaction = false;
 				} else {
 					binder_enqueue_work_ilocked(
 							w, &proc->todo);
-- 
2.25.1

