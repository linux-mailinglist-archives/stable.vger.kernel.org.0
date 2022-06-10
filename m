Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE3254692C
	for <lists+stable@lfdr.de>; Fri, 10 Jun 2022 17:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345270AbiFJPKh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jun 2022 11:10:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232537AbiFJPKV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jun 2022 11:10:21 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1E8A1A0756;
        Fri, 10 Jun 2022 08:10:19 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id w13-20020a17090a780d00b001e8961b355dso2522029pjk.5;
        Fri, 10 Jun 2022 08:10:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wBNaMPOmNVa4G2icGv1xc+3SBVgLzMMdSoup+c+wEz4=;
        b=oOgq7pJLSiedtyCi4kHQiicd4plXfUhPFMTcrsTEnbO5P2vuwO3Rc3aoc0UVW0RYfb
         UUaKqxrF/oxscxRY57RSCwQKg6OJQx9NOSnkRVhDB1Cs7RohLx55ZmcqyWHKkuyOjZlH
         PX2PEArGUlDWXhLRgRKMjZWv+6lDVkFVDs8zRlddsnSo+N4Qm/4OyhBCKpEGSgmlDj7r
         zHjZRPDq8P9Yl3MRh9en7TVRr2iYuYbL56e6M1gLEuyRjp58Vb0C5e6XC0R9KC9oUifU
         wnqMtnxf7TU48q96AjWsnxN3509y8BHJF/DBBhp7zZzHvF1qSRtPozPtvNwf8qDWIk3i
         WeNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wBNaMPOmNVa4G2icGv1xc+3SBVgLzMMdSoup+c+wEz4=;
        b=ohJ9Ff7LS+WMtjlHwQZFy5DMwSAzzZ9s+35E/saWOAGZl9zzCEg1Q8CrH1ZcFhm9BG
         Smxk21vHvf6RLAa67fHcSHk+0Ws7RYDtSa7UK4h8Jie5YgWO9i69nZ5qVumDZPTI2JI0
         UERIqjdcmwIn70TbwEsceOWwg9vZQgF3I3m1ncDGRrTTGGkY2+GJLoGdeeCecwdYF6TL
         tk6A1mmPpWuY8C0IUftKbumVeO5NrTrZumK/8y41LlxckEbPK8NSO8lKYsZxMXBGCL/f
         ozOCk/cDEfiZYUC6a3IC43S942UxHCb45LU8tp7iBysvHtq/udKRpaueGHYNUvmSj/+j
         2nXg==
X-Gm-Message-State: AOAM533UMw1/dDMoTHW7BuSryuYHhhiIdRQ3OqEPRSGtufOSVNEYrr+j
        OWXWhMQsNlTj8mQg26GwfHKXRSY0hWveLw==
X-Google-Smtp-Source: ABdhPJye5FwZb8pnA/cHUIXNM5pwta1SdJHGcBeQ8oUjIphXfkw4tVzR98D47d50BMhkXTiAjWeYnA==
X-Received: by 2002:a17:90b:4cca:b0:1e8:70ed:1a4a with SMTP id nd10-20020a17090b4cca00b001e870ed1a4amr183294pjb.243.1654873818951;
        Fri, 10 Jun 2022 08:10:18 -0700 (PDT)
Received: from localhost.localdomain ([47.242.114.172])
        by smtp.gmail.com with ESMTPSA id w4-20020a17090aaf8400b001e87bd6f6c2sm1832588pjq.50.2022.06.10.08.10.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jun 2022 08:10:18 -0700 (PDT)
From:   Chuang <nashuiliang@gmail.com>
Cc:     Chuang Wang <nashuiliang@gmail.com>, stable@vger.kernel.org,
        Jingren Zhou <zhoujingren@didiglobal.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jessica Yu <jeyu@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] kprobes: Rollback kprobe flags on failed arm_kprobe
Date:   Fri, 10 Jun 2022 23:09:33 +0800
Message-Id: <20220610150933.37770-1-nashuiliang@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuang Wang <nashuiliang@gmail.com>

In aggrprobe scenes, if arm_kprobe() returns an error(e.g. livepatch and
kprobe are using the same function X), kprobe flags, while has been
modified to ~KPROBE_FLAG_DISABLED, is not rollled back.

Then, __disable_kprobe() will be failed in __unregister_kprobe_top(),
the kprobe list will be not removed from aggrprobe, memory leaks or
illegal pointers will be caused.

WARN disarm_kprobe:
 Failed to disarm kprobe-ftrace at 00000000c729fdbc (-2)
 RIP: 0010:disarm_kprobe+0xcc/0x110
 Call Trace:
  __disable_kprobe+0x78/0x90
  __unregister_kprobe_top+0x13/0x1b0
  ? _cond_resched+0x15/0x30
  unregister_kprobes+0x32/0x80
  unregister_kprobe+0x1a/0x20

Illegal Pointers:
 BUG: unable to handle kernel paging request at 0000000000656369
 RIP: 0010:__get_valid_kprobe+0x69/0x90
 Call Trace:
  register_kprobe+0x30/0x60
  __register_trace_kprobe.part.7+0x8b/0xc0
  create_local_trace_kprobe+0xd2/0x130
  perf_kprobe_init+0x83/0xd0

Fixes: 12310e343755 ("kprobes: Propagate error from arm_kprobe_ftrace()")
Signed-off-by: Chuang Wang <nashuiliang@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Jingren Zhou <zhoujingren@didiglobal.com>
---
v1->v2:
- Supplement commit information: fixline, Cc stable

 kernel/kprobes.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index f214f8c088ed..c11c79e05a4c 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -2422,8 +2422,11 @@ int enable_kprobe(struct kprobe *kp)
 	if (!kprobes_all_disarmed && kprobe_disabled(p)) {
 		p->flags &= ~KPROBE_FLAG_DISABLED;
 		ret = arm_kprobe(p);
-		if (ret)
+		if (ret) {
 			p->flags |= KPROBE_FLAG_DISABLED;
+			if (p != kp)
+				kp->flags |= KPROBE_FLAG_DISABLED;
+		}
 	}
 out:
 	mutex_unlock(&kprobe_mutex);
-- 
2.34.1

