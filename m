Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16CAB51EEFB
	for <lists+stable@lfdr.de>; Sun,  8 May 2022 18:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235985AbiEHQ5f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 May 2022 12:57:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235979AbiEHQ5e (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 May 2022 12:57:34 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 322CDE016
        for <stable@vger.kernel.org>; Sun,  8 May 2022 09:53:42 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d17so11877606plg.0
        for <stable@vger.kernel.org>; Sun, 08 May 2022 09:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kylehuey.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7QE3zifA2u69/igKADLUNBhsOvUuQy9vMIUwiMYU8bs=;
        b=kYswZHMPQ2ixdwGtUPg8h5ZoD7/mX0/S2rhEMFCB4jryIrop0ttHr/g0d5iRxH0DU0
         aUv1T5PjGfZiYUdytIaagfLYjlHXwC1zameF4j8/33uaOvr+czELyrOEnGHSclrzZp6m
         cTj8jtTkYWEbjs15QT36BOahockaTdGfK4CVzpvHzbp3CR36Jtm3+moZmGHxd0rhEkck
         Z18iIVgU9X2dWjJHMy/qDJez+qZNZBgluAm0VdXa88ChvNARUL7/qvDGxbxgIIbxk11b
         H4D9KxU7+wacEvrbehL3yGGmt6uEaJU+GD8fpfYzGvNpQydAm7taXlSO6OUYYyiupyE/
         g89A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7QE3zifA2u69/igKADLUNBhsOvUuQy9vMIUwiMYU8bs=;
        b=oufkW8OEHODsi2wMbSzYfWm8ayIfwynnrAbcvevIPuPcYs6bBPRgcbM8SB4oKeu1GD
         QQMDbrlS6cXEhMcRbEH2yzFSWrHijxk/5Sh0MheUQodQPyP801zJoKFZ5aKkCiV01tFI
         8S5hWYjHR4FjlDa+pCnhnH0oypLZ1EvGM2kIkDUKG3A56eRo6jPWzuAyL5BhPK9xjsGI
         khUEBuZ19TPjgra0LpSiq94HAy/+s8F7zsAKglNzwpfP6ZhS0HyMXpS/PZ4jnlTjpMRN
         HwHVI5MpClzAI+KMPEa5S1VAFa20OvIoRPBMIzVf//9neH5W4WPef4ycj8kRGablBxfT
         SOiA==
X-Gm-Message-State: AOAM531EBnOS60Ub6JDwzYqvMqsss2o169CToDzKmaDAgpN0n2uEjE8X
        BgegQXlvSVMbTibQKmFT5+3h/Nq3qjcXxm6j
X-Google-Smtp-Source: ABdhPJxcRAOEfJq30nRmAdHReeqvsScK+Bd5DrOMryoUg6DQ9DX342M0+ffYMmAz51i7lfqXdjY31Q==
X-Received: by 2002:a17:902:ce8d:b0:15e:a95d:b4b0 with SMTP id f13-20020a170902ce8d00b0015ea95db4b0mr12926584plg.153.1652028821290;
        Sun, 08 May 2022 09:53:41 -0700 (PDT)
Received: from minbar.home.kylehuey.com (c-71-198-251-229.hsd1.ca.comcast.net. [71.198.251.229])
        by smtp.gmail.com with ESMTPSA id t15-20020a6549cf000000b003c14af50621sm6875167pgs.57.2022.05.08.09.53.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 May 2022 09:53:40 -0700 (PDT)
From:   Kyle Huey <me@kylehuey.com>
X-Google-Original-From: Kyle Huey <khuey@kylehuey.com>
To:     stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        Robert O'Callahan <robert@ocallahan.org>,
        Keno Fischer <keno@juliacomputing.com>,
        Kyle Huey <me@kylehuey.com>
Subject: [PATCH] KVM: x86/svm: Account for family 17h event renumberings in amd_pmc_perf_hw_id
Date:   Sun,  8 May 2022 09:53:38 -0700
Message-Id: <20220508165338.118886-1-khuey@kylehuey.com>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kyle Huey <me@kylehuey.com>

commit 5eb849322d7f7ae9d5c587c7bc3b4f7c6872cd2f upstream

Zen renumbered some of the performance counters that correspond to the
well known events in perf_hw_id. This code in KVM was never updated for
that, so guest that attempt to use counters on Zen that correspond to the
pre-Zen perf_hw_id values will silently receive the wrong values.

This has been observed in the wild with rr[0] when running in Zen 3
guests. rr uses the retired conditional branch counter 00d1 which is
incorrectly recognized by KVM as PERF_COUNT_HW_STALLED_CYCLES_BACKEND.

[0] https://rr-project.org/

Signed-off-by: Kyle Huey <me@kylehuey.com>
Message-Id: <20220503050136.86298-1-khuey@kylehuey.com>
Cc: stable@vger.kernel.org
[Check guest family, not host. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[Backport to 5.15: adjusted context]
Signed-off-by: Kyle Huey <me@kylehuey.com>
---
 arch/x86/kvm/svm/pmu.c | 28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index f337ce7e898e..d35c94e13afb 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -44,6 +44,22 @@ static struct kvm_event_hw_type_mapping amd_event_mapping[] = {
 	[7] = { 0xd1, 0x00, PERF_COUNT_HW_STALLED_CYCLES_BACKEND },
 };
 
+/* duplicated from amd_f17h_perfmon_event_map. */
+static struct kvm_event_hw_type_mapping amd_f17h_event_mapping[] = {
+	[0] = { 0x76, 0x00, PERF_COUNT_HW_CPU_CYCLES },
+	[1] = { 0xc0, 0x00, PERF_COUNT_HW_INSTRUCTIONS },
+	[2] = { 0x60, 0xff, PERF_COUNT_HW_CACHE_REFERENCES },
+	[3] = { 0x64, 0x09, PERF_COUNT_HW_CACHE_MISSES },
+	[4] = { 0xc2, 0x00, PERF_COUNT_HW_BRANCH_INSTRUCTIONS },
+	[5] = { 0xc3, 0x00, PERF_COUNT_HW_BRANCH_MISSES },
+	[6] = { 0x87, 0x02, PERF_COUNT_HW_STALLED_CYCLES_FRONTEND },
+	[7] = { 0x87, 0x01, PERF_COUNT_HW_STALLED_CYCLES_BACKEND },
+};
+
+/* amd_pmc_perf_hw_id depends on these being the same size */
+static_assert(ARRAY_SIZE(amd_event_mapping) ==
+	     ARRAY_SIZE(amd_f17h_event_mapping));
+
 static unsigned int get_msr_base(struct kvm_pmu *pmu, enum pmu_type type)
 {
 	struct kvm_vcpu *vcpu = pmu_to_vcpu(pmu);
@@ -136,19 +152,25 @@ static inline struct kvm_pmc *get_gp_pmc_amd(struct kvm_pmu *pmu, u32 msr,
 
 static unsigned int amd_pmc_perf_hw_id(struct kvm_pmc *pmc)
 {
+	struct kvm_event_hw_type_mapping *event_mapping;
 	u8 event_select = pmc->eventsel & ARCH_PERFMON_EVENTSEL_EVENT;
 	u8 unit_mask = (pmc->eventsel & ARCH_PERFMON_EVENTSEL_UMASK) >> 8;
 	int i;
 
+	if (guest_cpuid_family(pmc->vcpu) >= 0x17)
+		event_mapping = amd_f17h_event_mapping;
+	else
+		event_mapping = amd_event_mapping;
+
 	for (i = 0; i < ARRAY_SIZE(amd_event_mapping); i++)
-		if (amd_event_mapping[i].eventsel == event_select
-		    && amd_event_mapping[i].unit_mask == unit_mask)
+		if (event_mapping[i].eventsel == event_select
+		    && event_mapping[i].unit_mask == unit_mask)
 			break;
 
 	if (i == ARRAY_SIZE(amd_event_mapping))
 		return PERF_COUNT_HW_MAX;
 
-	return amd_event_mapping[i].event_type;
+	return event_mapping[i].event_type;
 }
 
 /* return PERF_COUNT_HW_MAX as AMD doesn't have fixed events */
-- 
2.36.0

