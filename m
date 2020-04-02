Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA07019C990
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389342AbgDBTNL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:13:11 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52095 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389214AbgDBTNL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:13:11 -0400
Received: by mail-wm1-f67.google.com with SMTP id z7so4610177wmk.1
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:13:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=yaJJtBeg9pW+fx6OVq7h64qYCeUsMdpitM20LISFeq8=;
        b=W4sBNWJFH39f9VSOqVDuJJEcLp2SN7vq34oYsPQch030ji+5bLLRqGjSmmqsOhlP4H
         Q+qYyPItfy5gOj1T+/AnTdEZbZYrl+BY6SipxKxyV06rG87zW0kEYxo6bSWQjFzouUvg
         52OCVuIzS63VcVWjqnZUyiqq6SGsVUtvS15bvVBXxtCjYf+j23Sq3srLLG+69Fnm+W4l
         p5r7WBqEcz2lfC85bxKUTD1G4icXlg+7VMCdKZQQem3tEsTpmXp+ofjqQWXP40xJzqyD
         uA85VCAoCCmSc8kZ6M8b152K4GV0JBj4iUoY2IpEoqY7+yDFyXzUc/ZAQhVe2kWES0il
         S6GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yaJJtBeg9pW+fx6OVq7h64qYCeUsMdpitM20LISFeq8=;
        b=qgwtKlWmBiGhQCIlMehXdWglKuh0OWgWnU21eX3Wrlf9JCraSp/0clApiZdpSMXG1n
         16e7/A/m0UsTQfB6k6lddUSFPvHNY2tAB+9bjJTiMMgCKta/heYWn14QQpseDLexL1dH
         5dOUp0KU3N1X9PML8YHMROCZL7c/f+D3rosTYlVQUGfb/AWCOOroopJjwmBa2oOqQdDJ
         CcFte61kRFp6GvkDHDL/hmhfrA0xswOvi7KTEvJwf3rCWCWKu1mhVIls7pwB1UkUiOiD
         gy190Uu5JUieD5PppoCGR08SyPcastCxmfeNlQkiDDFwSfzlEwUN2QMGF6TaJe3YSiRR
         3vgA==
X-Gm-Message-State: AGi0Pua4aKx5RyHVid0So5RrmX5ZmYaLGNp/Zbmzl9uu0wb3kxGXFXVq
        EIGNf5U+KDreJhTOHUTeoH5lIAiCOMhu1w==
X-Google-Smtp-Source: APiQypJKAWEdRzB/NeOKvCm3q6sAj4BaLh5NzwSWzkZh0oT1XAnApVNKDpuonI+Nnb+Cht53TKD36A==
X-Received: by 2002:a7b:cf02:: with SMTP id l2mr2410430wmg.4.1585854789208;
        Thu, 02 Apr 2020 12:13:09 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id y12sm5511514wrn.55.2020.04.02.12.13.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:13:08 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.14 10/33] android: binder: Use true and false for boolean values
Date:   Thu,  2 Apr 2020 20:13:30 +0100
Message-Id: <20200402191353.787836-10-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191353.787836-1-lee.jones@linaro.org>
References: <20200402191353.787836-1-lee.jones@linaro.org>
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

