Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA69F575193
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 17:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239055AbiGNPT2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 11:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231937AbiGNPT1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 11:19:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 998284B4AA
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 08:19:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657811963;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=3g/51Am7hhNBKok4aSvT7atGRsltefp8gJyPRmGJItU=;
        b=gchlmCA5PNulduXVaN01ZTMtSHk+1Dw2Z2WeuCz9Adrnw4rBd6V+T6OhBeFTS42kS9Q9XZ
        aXAvSzicpG/jesO4GuhTFb1ejaI9T3hOo8sVmoEKsrR6vTu6ZvNDkmj1xZYfehkaP8xSib
        v6Z+X1AacU/FnZRIw/apW6zarHC/CsY=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-119-WKlWo2EdNr-Qq9PUAEVOow-1; Thu, 14 Jul 2022 11:19:21 -0400
X-MC-Unique: WKlWo2EdNr-Qq9PUAEVOow-1
Received: by mail-qt1-f200.google.com with SMTP id cf20-20020a05622a401400b0031ed2d3fcd6so1271307qtb.20
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 08:19:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3g/51Am7hhNBKok4aSvT7atGRsltefp8gJyPRmGJItU=;
        b=eRiJG6X3joBw7ejvgV/mTuJPaVTtBQloDZtg6Bknlw7hhOxXhMEk1c8gD7bbQxBZrY
         vtlczCl+R/527j3vLbmQEVcYIJf8wvHxzKDRhnP2lGE3Frps34GB1k21Ooq8Gb2C2DEw
         whm5VWJUNagFpK1Jc33/4SDnKiFW9kubrQK7n4096DQLtfkreBI1fPuz627bVj/USTpf
         Xg2TWwuc5MQ4zbtJ1uVTk0zlIISyFRIkMJi01uhA6WXPCzEh8aHLp79mfaKZs1Hf61Mi
         6cRFpORoVkZZzwdiktq3E5Y9+y0daDNb+qvCMS6aYs8H5wFsFhshm+U/7zsBWUO+vuTz
         gYcg==
X-Gm-Message-State: AJIora/AyBb/CLpofgM7dL+Kdut8hwPnCmm2EKEF3imWQnDx7MPisFSi
        /f+GxrPi3aArIO0r5TMhDhKKonhMZ4r2CAQJhl4duJmAEpIQ+C3fwR8peaoa4sNd8BeMX6xaQHJ
        Tg/HkY4S4eNT6qYoJ
X-Received: by 2002:ac8:7fcf:0:b0:31e:cb6f:2487 with SMTP id b15-20020ac87fcf000000b0031ecb6f2487mr7776895qtk.528.1657811961173;
        Thu, 14 Jul 2022 08:19:21 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vuDG1f+p3VMd/jpv+jcJjxRHrYm4T6wO2lWr00narn1rhXbhrgFy56BIisbhuc7XIW2VKVrw==
X-Received: by 2002:ac8:7fcf:0:b0:31e:cb6f:2487 with SMTP id b15-20020ac87fcf000000b0031ecb6f2487mr7776859qtk.528.1657811960888;
        Thu, 14 Jul 2022 08:19:20 -0700 (PDT)
Received: from localhost.localdomain.com ([151.29.62.255])
        by smtp.gmail.com with ESMTPSA id w18-20020a05620a445200b006a37c908d33sm1662031qkp.28.2022.07.14.08.19.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 08:19:20 -0700 (PDT)
From:   Juri Lelli <juri.lelli@redhat.com>
To:     LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc:     "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>,
        Juri Lelli <juri.lelli@redhat.com>, stable@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Valentin Schneider <vschneid@redhat.com>
Subject: [PATCH v2] sched/deadline: Fix BUG_ON condition for deboosted tasks
Date:   Thu, 14 Jul 2022 17:19:08 +0200
Message-Id: <20220714151908.533052-1-juri.lelli@redhat.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Tasks the are being deboosted from SCHED_DEADLINE might enter
enqueue_task_dl() one last time and hit an erroneous BUG_ON condition:
since they are not boosted anymore, the if (is_dl_boosted()) branch is
not taken, but the else if (!dl_prio) is and inside this one we
BUG_ON(!is_dl_boosted), which is of course false (BUG_ON triggered)
otherwise we had entered the if branch above. Long story short, the
current condition doesn't make sense and always leads to triggering of a
BUG.

Fix this by only checking enqueue flags, properly: ENQUEUE_REPLENISH has
to be present, but additional flags are not a problem.

Fixes: 64be6f1f5f71 ("sched/deadline: Don't replenish from a !SCHED_DEADLINE entity")
Cc: stable@vger.kernel.org
Signed-off-by: Juri Lelli <juri.lelli@redhat.com>

---
v1->v2
 - Make detection of faulty condition less fatal [Peter Zijlstra]
 - Cc stable and update fixes tag [Srivatsa S. Bhat]
---
 kernel/sched/deadline.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 5867e186c39a..0ab79d819a0d 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1703,7 +1703,10 @@ static void enqueue_task_dl(struct rq *rq, struct task_struct *p, int flags)
 		 * the throttle.
 		 */
 		p->dl.dl_throttled = 0;
-		BUG_ON(!is_dl_boosted(&p->dl) || flags != ENQUEUE_REPLENISH);
+		if (!(flags & ENQUEUE_REPLENISH))
+			printk_deferred_once("sched: DL de-boosted task PID %d: REPLENISH flag missing\n",
+					     task_pid_nr(p));
+
 		return;
 	}
 
-- 
2.36.1

