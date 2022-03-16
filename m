Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF694DB6A9
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 17:49:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353981AbiCPQt4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 12:49:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357560AbiCPQtw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 12:49:52 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F96F36E31
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 09:48:37 -0700 (PDT)
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id ECC3B3F5F3
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 16:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1647449314;
        bh=jZQBsUn3wIG3eVoA03h8vq3ENW/tPMnuHuTwlaAjs3A=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=VlfYOU1l0p8qrXo98PUp1fALGRGv0IDc8rD/bpyizmFZVKhSuFf5JjeA3HA5qjepK
         s63lQyy+frQ71d57sQhmOFM8qWRTwBcwLOiPrgyPRXcM5tMlxmWQpMVpWBBaex6U09
         m8tkdJ5chy5P5aB1Ak0NrpS98SBQueFSoHKuc9X7ysAxP9YmfLc7XhXFpJczoFX3tZ
         cfRTziIOpvYdY1OezPmc/mcmkkp4w6forD1qWLdWCuSsh70c2qvuVAq1o3u+PqsNa1
         hplPhbUp2zfyHEl0bsYFhROQ99bIBrImx7pkGpaDChKewQcas5k5/k29eH6KDMnvw2
         n5IdH0ptn311Q==
Received: by mail-io1-f70.google.com with SMTP id g11-20020a056602072b00b00645cc0735d7so1640073iox.1
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 09:48:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jZQBsUn3wIG3eVoA03h8vq3ENW/tPMnuHuTwlaAjs3A=;
        b=yZHMlyKI/gH24KQMv2YT955HM1T6b7c0JShIM13LcDemVjwiMKqwlxmJVd1R5b6Bvo
         j1+RTsXHe1q+5uw01RvcN2wlkYgN9z+rkb3sXsca+6C+7/kSWGiPbbJh3jq9MkPBqhKP
         HP1qz+3tvCCkDiDFDtit6beKydNQxfn4h7yVTsr2Vqv0QDuH2LjDeapO+iw3IK7kKVHn
         VBrtvmmnFMZ9/8qwu/n66+sf4o9wwbpTEv56bWa65i59lxojqxAjFSmwdhGpXi+NdQ0e
         NspshEK6f+DLYmSQeTq7Hh6pDfvcQzntf01BOKI0bVRLnLx0rL19pamIXzmXXyiguVeQ
         VCJA==
X-Gm-Message-State: AOAM532wkjlLd1z72p6Sd0RLsj8lFideKVNAWqIA+oXu8kAn9dlv3vEH
        xrqDYcCDQb10hxOU+hUpoxvVdpI7IXUCg48zm/ecQxM5dyr0znu5rUtQNljLUniruQyJ9SXB6v1
        3Cv6xTemSPmM+dToBRKX7miLAzyZUly6j/Q==
X-Received: by 2002:a05:6638:dcf:b0:319:e022:ad6c with SMTP id m15-20020a0566380dcf00b00319e022ad6cmr183593jaj.143.1647449313457;
        Wed, 16 Mar 2022 09:48:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyFaewy8vMjHZO8EI5N0GQNtdqiTn+3Sz+JmHzqa1Rhk7u8HS3EzRcA5cUE7AkkyG6jq0PpFg==
X-Received: by 2002:a05:6638:dcf:b0:319:e022:ad6c with SMTP id m15-20020a0566380dcf00b00319e022ad6cmr183567jaj.143.1647449312727;
        Wed, 16 Mar 2022 09:48:32 -0700 (PDT)
Received: from localhost (c-71-196-238-11.hsd1.co.comcast.net. [71.196.238.11])
        by smtp.gmail.com with ESMTPSA id i11-20020a056e020d8b00b002c79690d56esm1449277ilj.10.2022.03.16.09.48.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 09:48:31 -0700 (PDT)
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
Subject: [PATCH v2 4.19 2/3] sched/topology: Fix sched_domain_topology_level alloc in sched_init_numa()
Date:   Wed, 16 Mar 2022 10:48:07 -0600
Message-Id: <20220316164808.569272-3-dann.frazier@canonical.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220316164808.569272-1-dann.frazier@canonical.com>
References: <20220316164808.569272-1-dann.frazier@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dietmar Eggemann <dietmar.eggemann@arm.com>

commit 71e5f6644fb2f3304fcb310145ded234a37e7cc1 upstream.

Commit "sched/topology: Make sched_init_numa() use a set for the
deduplicating sort" allocates 'i + nr_levels (level)' instead of
'i + nr_levels + 1' sched_domain_topology_level.

This led to an Oops (on Arm64 juno with CONFIG_SCHED_DEBUG):

sched_init_domains
  build_sched_domains()
    __free_domain_allocs()
      __sdt_free() {
	...
        for_each_sd_topology(tl)
	  ...
          sd = *per_cpu_ptr(sdd->sd, j); <--
	  ...
      }

Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Vincent Guittot <vincent.guittot@linaro.org>
Tested-by: Barry Song <song.bao.hua@hisilicon.com>
Link: https://lkml.kernel.org/r/6000e39e-7d28-c360-9cd6-8798fd22a9bf@arm.com
Signed-off-by: dann frazier <dann.frazier@canonical.com>
---
 kernel/sched/topology.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 0826f3f4920a..02e85cd233d4 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -1428,7 +1428,7 @@ void sched_init_numa(void)
 	/* Compute default topology size */
 	for (i = 0; sched_domain_topology[i].mask; i++);
 
-	tl = kzalloc((i + nr_levels) *
+	tl = kzalloc((i + nr_levels + 1) *
 			sizeof(struct sched_domain_topology_level), GFP_KERNEL);
 	if (!tl)
 		return;
-- 
2.35.1

