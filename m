Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44A8D504F2C
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 13:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237828AbiDRLEc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 07:04:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237808AbiDRLEa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 07:04:30 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB39E1A051
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 04:01:51 -0700 (PDT)
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id A74AF3F1E6
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 11:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1650279709;
        bh=A+yL7ON2iuqOiUoVBQTqru6xwFOuznFNTRIrUTGpo2k=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=SttgI0z5/9Eo8y7r9BZ1wzwnJGaZ0xwpv12yPc7eSx+Y24sNXQnpCELHGkU6Js5k1
         sNoXzCLbFjQZAuomPCkl2IAL5wYIY0mrOys09WdrSPTuY/CKgYuAFQRSNRvLy5+dPW
         LjMbbMFt5vgGpkm+PRq+mrrtbuuqMSMHJ88o4XCn2Mb8YmoPDqQ43t7KexwFQdwFRm
         QNmfmQGBgE8TGjklJQyiW8w9c8iEEUimxfiTkl7atYt3F3/2Dk8PJ193R8v857iQaB
         wW1sh4i9Py2GKS4HFD89b7h2mTc0OrHT6IeZNibCkV3FlGXh+IWV8bWBFmZ7+Vj2FP
         Y2eCr2GanIacA==
Received: by mail-wm1-f71.google.com with SMTP id bg8-20020a05600c3c8800b0038e6a989925so7579428wmb.3
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 04:01:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A+yL7ON2iuqOiUoVBQTqru6xwFOuznFNTRIrUTGpo2k=;
        b=MymYxl3hXhiX1L2/st1+pm7+YpzBe/4V01PsdhbuLbOmKfm28eA87bgpgDc7HdC7MD
         DUo0QTse9zRf8Jxi4JP093hcqm5Jw/gqzH1e4hjZyj85YVesvK0jhV2dv3yMLQgK2tOA
         SFZW77fFLx90HvmD/pknwLwqJIDZd5dSXql1l8YG6tybPy1BZmJSFXiq/lCnHB1VKlrM
         BqHkknUaFnNewSVB8VQoS1yNRtjzjmBSbco8rACmUvMd2XaMwinZl8/EFRu8Fs+DuoBO
         E5ub0nxlu2QEqmQIbW0YAJZt05L0ZRcwTLwmgkJvm3uV7EVgmHn4cb+iFPQ1MQSIbKAn
         C57Q==
X-Gm-Message-State: AOAM533934p2ko8a/QxUjnvPH7DFz4XGI789/h6jUTuKWWOMX+ULtZGD
        ZTX/lWlzywVwQoBAKPSE9UCwG/QtQCOicLqQphp5pib2PqFOGzd5VdcXfsNvkoKztgDFapVhQi2
        rcrxQp8akfeCyx83PKSkLsRvXhxTZXgafvA==
X-Received: by 2002:a05:6000:1a85:b0:205:a234:d0a5 with SMTP id f5-20020a0560001a8500b00205a234d0a5mr8072242wry.126.1650279708332;
        Mon, 18 Apr 2022 04:01:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx90ey+WTkAjRzEzm0bHiIcqEglCrBG3i37ZO1K437sKAxMdGxpZDKtE7koP+U/o+sZDavp4w==
X-Received: by 2002:a05:6000:1a85:b0:205:a234:d0a5 with SMTP id f5-20020a0560001a8500b00205a234d0a5mr8072205wry.126.1650279707499;
        Mon, 18 Apr 2022 04:01:47 -0700 (PDT)
Received: from localhost ([5.148.145.78])
        by smtp.gmail.com with ESMTPSA id m7-20020adfe0c7000000b002060e7bbe49sm12041658wri.45.2022.04.18.04.01.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 04:01:47 -0700 (PDT)
From:   Dimitri John Ledkov <dimitri.ledkov@canonical.com>
To:     stable@vger.kernel.org
Cc:     Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Michael Larabel <Michael@MichaelLarabel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH stable v5.15.y] cpufreq: intel_pstate: ITMT support for overclocked system
Date:   Mon, 18 Apr 2022 12:01:21 +0100
Message-Id: <20220418110121.63160-1-dimitri.ledkov@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

commit 03c83982a0278207709143ba78c5a470179febee upstream.

On systems with overclocking enabled, CPPC Highest Performance can be
hard coded to 0xff. In this case even if we have cores with different
highest performance, ITMT can't be enabled as the current implementation
depends on CPPC Highest Performance.

On such systems we can use MSR_HWP_CAPABILITIES maximum performance field
when CPPC.Highest Performance is 0xff.

Due to legacy reasons, we can't solely depend on MSR_HWP_CAPABILITIES as
in some older systems CPPC Highest Performance is the only way to identify
different performing cores.

Reported-by: Michael Larabel <Michael@MichaelLarabel.com>
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Tested-by: Michael Larabel <Michael@MichaelLarabel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Dimitri John Ledkov <dimitri.ledkov@canonical.com>
---
 drivers/cpufreq/intel_pstate.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index e15c3bc17a55..8a2c6b58b652 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -335,6 +335,8 @@ static void intel_pstste_sched_itmt_work_fn(struct work_struct *work)
 
 static DECLARE_WORK(sched_itmt_work, intel_pstste_sched_itmt_work_fn);
 
+#define CPPC_MAX_PERF	U8_MAX
+
 static void intel_pstate_set_itmt_prio(int cpu)
 {
 	struct cppc_perf_caps cppc_perf;
@@ -345,6 +347,14 @@ static void intel_pstate_set_itmt_prio(int cpu)
 	if (ret)
 		return;
 
+	/*
+	 * On some systems with overclocking enabled, CPPC.highest_perf is hardcoded to 0xff.
+	 * In this case we can't use CPPC.highest_perf to enable ITMT.
+	 * In this case we can look at MSR_HWP_CAPABILITIES bits [8:0] to decide.
+	 */
+	if (cppc_perf.highest_perf == CPPC_MAX_PERF)
+		cppc_perf.highest_perf = HWP_HIGHEST_PERF(READ_ONCE(all_cpu_data[cpu]->hwp_cap_cached));
+
 	/*
 	 * The priorities can be set regardless of whether or not
 	 * sched_set_itmt_support(true) has been called and it is valid to
-- 
2.32.0

