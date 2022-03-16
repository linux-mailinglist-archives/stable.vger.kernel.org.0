Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF5F64DB6AD
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 17:49:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357591AbiCPQuB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 12:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357571AbiCPQt5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 12:49:57 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 182EB3703B
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 09:48:41 -0700 (PDT)
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id C46003F609
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 16:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1647449319;
        bh=BYM5WDvDYDcwIeTSiyEk3x1GtL/EefMaA8BGpQ/2v1A=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=kkzvcofQrOzBD/Lr5K8/SNHOkTPPHoPJbbBfFXTU6u6GkSBwB9DiS/GC4HjWFqRWJ
         Lj5HybjaHIFvME/9xs7iA/rGqdp5nnLIB7MfPR95CGsLIWgYMJ7rYGNi9OPTTMfCDH
         GjhHNpthunoUI14vklocvEil8wFEO7TcgTgDQkJGq5r43PzmETrwXiB7aYnQpkqWDI
         8BOD53sEFcPBzwJHRayX9TkPs7SiOJ77iXDdu8NnvP+eWMciCpQh6FzJF/NwQlntXj
         UKDj6r6iiKhpOatfWTITrnnleFaLiqpzj0oc20PmNDxk9TVpP8vjy8RZoKtjx60iEw
         +E3fVrQroFeVw==
Received: by mail-io1-f71.google.com with SMTP id u10-20020a5ec00a000000b00648e5804d5bso1619666iol.12
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 09:48:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BYM5WDvDYDcwIeTSiyEk3x1GtL/EefMaA8BGpQ/2v1A=;
        b=cW2zcWOyOdK/AnWc1kOpQhcm2n6u9IsqcPvX8u9FUFUK9fxaAoWEjw+J+I/hBgZhsH
         zQCWJQYxw8eBdyFf/bBoBwZwUt48/mLdBIiT3H9Huma3pL6nRKM99kgEYUF8RORlAQ9B
         zKTh2/hORuhSznyOFYG4ePHhs641z++ESjndfAew3JcG4iUdHL1wL+QTMWEeyxLXbdsr
         ya2zUs3esVvVfEYAxnzsb6/nEYHk/w7LCCFWB/t6MlrrKaEQe5LJBCKGkj2ra2hgjceQ
         GuCnGtn8nWyc6KJIgNCIdyBOT50F+RZmuyrM4Xpp7wmFreh8HvHcgSIti3sCjNI6lfYw
         0zWQ==
X-Gm-Message-State: AOAM533vS62vE8AsBgLl3Ws1qPpvLq5RUnTJsxY0fAjgFfDS7e6k3mnx
        qFonQiAToEFbeNfm95z2HVIQnHfBgTkeUTg4b/vhq5QQ8OJOeRkElkV8XldDzky+QdW8s9JhnBw
        2V6Jq2SfSPvCGFOtLpOgnMfXsdrnfWbiBJw==
X-Received: by 2002:a05:6602:2f09:b0:648:dc2f:a42c with SMTP id q9-20020a0566022f0900b00648dc2fa42cmr468810iow.12.1647449317258;
        Wed, 16 Mar 2022 09:48:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxwi+EVDk5h5dOMGdwjwqvVTXFk0TbR/HsZRPrhye1D0AkZQ/TAwQP2NTnZi3zu2Oq1DbidUg==
X-Received: by 2002:a05:6602:2f09:b0:648:dc2f:a42c with SMTP id q9-20020a0566022f0900b00648dc2fa42cmr468796iow.12.1647449316977;
        Wed, 16 Mar 2022 09:48:36 -0700 (PDT)
Received: from localhost (c-71-196-238-11.hsd1.co.comcast.net. [71.196.238.11])
        by smtp.gmail.com with ESMTPSA id a6-20020a92c546000000b002c7a44bf1a5sm1381922ilj.48.2022.03.16.09.48.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 09:48:36 -0700 (PDT)
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
Subject: [PATCH v2 4.19 3/3] ia64: ensure proper NUMA distance and possible map initialization
Date:   Wed, 16 Mar 2022 10:48:08 -0600
Message-Id: <20220316164808.569272-4-dann.frazier@canonical.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220316164808.569272-1-dann.frazier@canonical.com>
References: <20220316164808.569272-1-dann.frazier@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
[ dannf: Use node_distance instead of slit_distance since this is before
  the rename that occurred in commit ef78e5ec9214 ("ia64: export
  node_distance function"), plus a minor context adjustment ]
Signed-off-by: dann frazier <dann.frazier@canonical.com>
---
 arch/ia64/kernel/acpi.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/ia64/kernel/acpi.c b/arch/ia64/kernel/acpi.c
index 1dacbf5e9e09..0c1dac64e77b 100644
--- a/arch/ia64/kernel/acpi.c
+++ b/arch/ia64/kernel/acpi.c
@@ -537,7 +537,8 @@ void __init acpi_numa_fixup(void)
 	if (srat_num_cpus == 0) {
 		node_set_online(0);
 		node_cpuid[0].phys_id = hard_smp_processor_id();
-		return;
+		node_distance(0, 0) = LOCAL_DISTANCE;
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
2.35.1

