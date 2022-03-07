Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50A974D0819
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 21:03:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245224AbiCGUCP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 15:02:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242723AbiCGUCO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 15:02:14 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0086D8AE68
        for <stable@vger.kernel.org>; Mon,  7 Mar 2022 12:01:19 -0800 (PST)
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id BA2BC3F7E0
        for <stable@vger.kernel.org>; Mon,  7 Mar 2022 20:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1646683278;
        bh=MYa3HOnxdRf4zgP873BwgLR5fhhIJBKgyitcscinRGs=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=gjPng0wlHZOwhrUtjoppSZhPMZ7tmg5vA2wzniAEx04C9y8uXIW1ZhQXMnHm4WNy3
         vEb0jaP+6Koycg08Uvu6eVVpS2u/6LWFn+87bdP+saXhcU7Pk53zxE1T2LQr8yXOy4
         0E74/8dnUsAmC9FJufqNcigkqjjF97gdq1jBaSJRwPIUj6mYDjHRvuOZuEwIJjbm2a
         mUxSeS8yUhe6a+eCbcjYG9Tte6jo1V92PlvCkimJn1nTcUB7YeP7N6/wFDz0qaFPlB
         DwEsJn5us7+HPdHctCN2umSTpIqmyfjJ35gwLNAoH4aPBVHIjOVVNuvkmPHlkXpN99
         +ihyHidkFZ4KA==
Received: by mail-io1-f72.google.com with SMTP id s14-20020a0566022bce00b00645e9bc9773so1102200iov.20
        for <stable@vger.kernel.org>; Mon, 07 Mar 2022 12:01:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MYa3HOnxdRf4zgP873BwgLR5fhhIJBKgyitcscinRGs=;
        b=rHY+dHJ4HEFzVV7SfrjRbvOqogb/4DRJyMXYhher1OPEKAT+8GPHfsbimI7EpJedsD
         OclOFJqJJETGLBCEyUdESPI6b+WEASTlaVcK0AfbqbvEAvP/+y/pmI93skArSYkfRmUG
         Ho0rfFbmW+x0T7CWuQ4IJic8zLO26RIRq8wdEK7tIYp0JC+jFpgHIdkGixDWF2nZsOy3
         6j90VnOY03VoifhtewsJlZlVFRG12ufugh8JOgxWm+cf3pI+4zqgs5dkw7xujVs6VEMI
         GdZoktZixNZDjxmlObWdGupVwNBqdrJDt6f1JHldkYdQDZWLXSbJVvkw5XCziUY2FEY6
         ggjg==
X-Gm-Message-State: AOAM533l5MHct7Z8noaVn+tDZ7t9Fsuyn4XJK9Pq0h+Nn+4zo7ltz06C
        /LdWaEu6piaYSqdQuwSl9iTwZOIc3a+z2IBKKM2JEpQq3t9vdPa0x71EKrSjTukYGmcLP5rC/t3
        t0YFbi+WFmr2ZjUAdCflxmjgFIi2iYb2XDw==
X-Received: by 2002:a05:6e02:12c8:b0:2c6:343f:b38d with SMTP id i8-20020a056e0212c800b002c6343fb38dmr9044945ilm.191.1646683276066;
        Mon, 07 Mar 2022 12:01:16 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy96vcAbo82iuBKo9tD9gfr0H6HRXTec4IyY9lWSXwZ/FMfpgnRmWgQl1B4puiYokwT6kHEiA==
X-Received: by 2002:a05:6e02:12c8:b0:2c6:343f:b38d with SMTP id i8-20020a056e0212c800b002c6343fb38dmr9044912ilm.191.1646683275731;
        Mon, 07 Mar 2022 12:01:15 -0800 (PST)
Received: from localhost (c-71-196-238-11.hsd1.co.comcast.net. [71.196.238.11])
        by smtp.gmail.com with ESMTPSA id q4-20020a056e0215c400b002c5fdff3087sm12302924ilu.29.2022.03.07.12.01.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 12:01:14 -0800 (PST)
From:   dann frazier <dann.frazier@canonical.com>
To:     stable@vger.kernel.org
Cc:     Valentin Schneider <valentin.schneider@arm.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Sergei Trofimovich <slyfox@gentoo.org>,
        Anatoly Pugachev <matorola@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4.19 3/3] ia64: ensure proper NUMA distance and possible map initialization
Date:   Mon,  7 Mar 2022 13:01:09 -0700
Message-Id: <20220307200109.459214-1-dann.frazier@canonical.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307195941.459076-1-dann.frazier@canonical.com>
References: <20220307195941.459076-1-dann.frazier@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
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
[ dannf: minor context adjustment in arch/ia64/kernel/acpi.c ]
Signed-off-by: dann frazier <dann.frazier@canonical.com>
---
 arch/ia64/kernel/acpi.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/ia64/kernel/acpi.c b/arch/ia64/kernel/acpi.c
index 1dacbf5e9e09..3856894e86b8 100644
--- a/arch/ia64/kernel/acpi.c
+++ b/arch/ia64/kernel/acpi.c
@@ -537,7 +537,8 @@ void __init acpi_numa_fixup(void)
 	if (srat_num_cpus == 0) {
 		node_set_online(0);
 		node_cpuid[0].phys_id = hard_smp_processor_id();
-		return;
+		slit_distance(0, 0) = LOCAL_DISTANCE;
+		goto out;
 	}
 
 	/*
@@ -580,7 +581,7 @@ void __init acpi_numa_fixup(void)
 			for (j = 0; j < MAX_NUMNODES; j++)
 				node_distance(i, j) = i == j ? LOCAL_DISTANCE :
 							REMOTE_DISTANCE;
-		return;
+		goto out;
 	}
 
 	memset(numa_slit, -1, sizeof(numa_slit));
@@ -605,6 +606,8 @@ void __init acpi_numa_fixup(void)
 		printk("\n");
 	}
 #endif
+out:
+	node_possible_map = node_online_map;
 }
 #endif				/* CONFIG_ACPI_NUMA */
 
-- 
2.25.1

