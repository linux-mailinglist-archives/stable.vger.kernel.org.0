Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 808824CE5FE
	for <lists+stable@lfdr.de>; Sat,  5 Mar 2022 17:49:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232046AbiCEQtz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Mar 2022 11:49:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiCEQtz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Mar 2022 11:49:55 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 222CE275DE
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 08:49:05 -0800 (PST)
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id E59AC3F5FC
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 16:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1646498943;
        bh=DX/QurX075N9jChok0VowAMIPvPGF/QQrCN/G/CBjQs=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=vfFxc4aH03sUT7L0y/uv8sMLOsebHfc+g2JkRj2OUbY4hM3NPvFfiv9lmr7VSiohi
         e3E7gB0HgCMcOjL7tGBvJJlo1HCVo5VjS8p7QcwFy2Wxn+PaSNvq10p08Kk1TEh6YU
         YDVGVlsokUNyWmboBj6doEDZkuA4C9+5e1PfwuNAaLmfRbpiOiKA1pa250P5THAo0G
         VJl8ubwvf2ps0LuteozlpT88WpK7+rY/guwNcl3WgVwSWGe3qXYxifxENsIHyQv5yg
         PlOtq2BCncw5CohToZHFK1F8QNj1Y4/cxjepoT0U6jk7ila+9scbszv+lzP19htn0C
         GiBlGr4WleWNQ==
Received: by mail-il1-f198.google.com with SMTP id m17-20020a923f11000000b002c10e8f4c44so7645765ila.1
        for <stable@vger.kernel.org>; Sat, 05 Mar 2022 08:49:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DX/QurX075N9jChok0VowAMIPvPGF/QQrCN/G/CBjQs=;
        b=fZcY6xgWv53pgyEo9ddTqJ9p4chHr72Gm4eTtGEofFqHUji7PuZCXv2dB/dmuY5Kqt
         QjB6EJQXqrBYtbBn3M0N1UoBzDCwR4u6Jn0UAEauZ9p9n/JmAA+MJdhoBD1diTyAGBDI
         bXL2ckDegemzMjqptjKYq8tix58hsSKChQKKUhEx7x6cuJX3QcZ/hNuP1OfG+1+OoGWY
         s1voC+33k5xEK1jpywpXYog6CPE4aFCuFaEET7qt+zpsirUDs+CG1JsmP+awdJebmIr3
         S9E6+fb6FX2HSZxK82YOMLSllZtuqNTTY7Dcuk0OsRtxVqQI/gyPDdyEY0ObNK24XuCm
         IxPw==
X-Gm-Message-State: AOAM533mTBwrMHFPfE9HXjI1g0YvVVQ4o0c5MJKhQlxVFhQYz9WOm5EA
        aJNr4oTW2IYLkuW8RphBH8OLA+7ucQRAk7NTnpG2nioeZxEPTwlRYB/HPba1stK/My3kMTQuXEV
        VsDI5di81FXoPvlrz8a8Q2C5gE9YQCNC4yQ==
X-Received: by 2002:a05:6602:281a:b0:640:d8a0:e14c with SMTP id d26-20020a056602281a00b00640d8a0e14cmr3511157ioe.164.1646498942365;
        Sat, 05 Mar 2022 08:49:02 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyTyYnmy/gdQNop+N3Fmp2YZeQ+TMA6NNQtQ8grUI8NpnEknc8/xl5TFVMzuwAYepf0hycF1w==
X-Received: by 2002:a05:6602:281a:b0:640:d8a0:e14c with SMTP id d26-20020a056602281a00b00640d8a0e14cmr3511138ioe.164.1646498942122;
        Sat, 05 Mar 2022 08:49:02 -0800 (PST)
Received: from localhost (c-71-196-238-11.hsd1.co.comcast.net. [71.196.238.11])
        by smtp.gmail.com with ESMTPSA id b25-20020a5d8059000000b00644ddaad77asm6351818ior.29.2022.03.05.08.49.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Mar 2022 08:49:01 -0800 (PST)
From:   dann frazier <dann.frazier@canonical.com>
To:     stable@vger.kernel.org
Cc:     Miao Xie <miaox@cn.fujitsu.com>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Barry Song <song.bao.hua@hisilicon.com>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Sergei Trofimovich <slyfox@gentoo.org>,
        Anatoly Pugachev <matorola@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5.10+5.4 3/3] ia64: ensure proper NUMA distance and possible map initialization
Date:   Sat,  5 Mar 2022 09:48:53 -0700
Message-Id: <20220305164853.245476-1-dann.frazier@canonical.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220305164430.245125-1-dann.frazier@canonical.com>
References: <20220305164430.245125-1-dann.frazier@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Valentin Schneider <valentin.schneider@arm.com>

commit b22a8f7b4bde4e4ab73b64908ffd5d90ecdcdbfd upstream.

John Paul reported a warning about bogus NUMA distance values spurred by
commit:

  620a6dc40754 ("sched/topology: Make sched_init_numa() use a set for the deduplicating sort")

In this case, the afflicted machine comes up with a reported 256 possible
nodes, all of which are 0 distance away from one another.  This was
previously silently ignored, but is now caught by the aforementioned
commit.

The culprit is ia64's node_possible_map which remains unchanged from its
initialization value of NODE_MASK_ALL.  In John's case, the machine
doesn't have any SRAT nor SLIT table, but AIUI the possible map remains
untouched regardless of what ACPI tables end up being parsed.  Thus,
!online && possible nodes remain with a bogus distance of 0 (distances \in
[0, 9] are "reserved and have no meaning" as per the ACPI spec).

Follow x86 / drivers/base/arch_numa's example and set the possible map to
the parsed map, which in this case seems to be the online map.

Link: http://lore.kernel.org/r/255d6b5d-194e-eb0e-ecdd-97477a534441@physik.fu-berlin.de
Link: https://lkml.kernel.org/r/20210318130617.896309-1-valentin.schneider@arm.com
Fixes: 620a6dc40754 ("sched/topology: Make sched_init_numa() use a set for the deduplicating sort")
Signed-off-by: Valentin Schneider <valentin.schneider@arm.com>
Reported-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Tested-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Tested-by: Sergei Trofimovich <slyfox@gentoo.org>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Anatoly Pugachev <matorola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: dann frazier <dann.frazier@canonical.com>
---
 arch/ia64/kernel/acpi.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/ia64/kernel/acpi.c b/arch/ia64/kernel/acpi.c
index a5636524af76..e2af6b172200 100644
--- a/arch/ia64/kernel/acpi.c
+++ b/arch/ia64/kernel/acpi.c
@@ -446,7 +446,8 @@ void __init acpi_numa_fixup(void)
 	if (srat_num_cpus == 0) {
 		node_set_online(0);
 		node_cpuid[0].phys_id = hard_smp_processor_id();
-		return;
+		slit_distance(0, 0) = LOCAL_DISTANCE;
+		goto out;
 	}
 
 	/*
@@ -489,7 +490,7 @@ void __init acpi_numa_fixup(void)
 			for (j = 0; j < MAX_NUMNODES; j++)
 				slit_distance(i, j) = i == j ?
 					LOCAL_DISTANCE : REMOTE_DISTANCE;
-		return;
+		goto out;
 	}
 
 	memset(numa_slit, -1, sizeof(numa_slit));
@@ -514,6 +515,8 @@ void __init acpi_numa_fixup(void)
 		printk("\n");
 	}
 #endif
+out:
+	node_possible_map = node_online_map;
 }
 #endif				/* CONFIG_ACPI_NUMA */
 
-- 
2.25.1

