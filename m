Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD65E1EF2
	for <lists+stable@lfdr.de>; Wed, 23 Oct 2019 17:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390437AbfJWPKp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Oct 2019 11:10:45 -0400
Received: from mail-eopbgr710041.outbound.protection.outlook.com ([40.107.71.41]:5680
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390472AbfJWPKo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Oct 2019 11:10:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YQZ6mwj0XgEXXffyam7Tg2jD+6naCDA7L1/k9oswjIFLsebOxiha5lP9mqyLxZ/Mvbxc8bZCVwBJaMsHbp0cCz0Ci45usYBu6niubRS1kBCWHTOyt55Dl/5WQ+NcCnulwt5miRwOP0MIXj8I9n+vrMBgK6HkiAColGI1rAeeaKQNGg8fHhq+YVuZgzfTsOFpTaU/u/+hncjzguRlKEAjHurmAIzLGqHlfqRsxy9lzlHRy9PZ7txxrupNYIDsBmaQPwTq0WCMqUxoBmXP7KLEHWlFatLabeaSqRfDqfzeM6AWi7NompJ4yxLeFj04CLO1ZjSlqez4raxoZ0ArnMpacQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xRsQ2Cw8ZI/ZBmjSCsFnNn6CE8QKP7cAVz9tHdA6UKg=;
 b=gJPzwzkh9fZOjZ7B45flPjE3Ljng9yBpdmJd54UIyPc9qJycBms2ipJQ+7wCsDBSJxrUCWbF+7acU359YH1P3DUAcGZQEQCmv0zFS09djml22j80SyYxhmPmNmZ4WMtQtmgKRSqqDxTrrpPud2JeXkc3ebqh/jZCnlmaaURZyh4+0LkrLHeO3ltEHEZtwbfCGJAxmmgvgVjZbNndN8OuMIpuzbYrF09bAx6cAtCCgqKX44M1bKpr98YmdMMZ02wQbpdTGBjroErxotiZJaIGwyd8XkKw+/+tjhSnSSEbEtAPWJpSz27x2TIHpqPnXpFdkz6HgPk31RRfUkfnFKU/cQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none (sender ip is
 165.204.84.17) smtp.rcpttodomain=infradead.org smtp.mailfrom=amd.com;
 dmarc=permerror action=none header.from=amd.com; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xRsQ2Cw8ZI/ZBmjSCsFnNn6CE8QKP7cAVz9tHdA6UKg=;
 b=UVv4XVhkF+/tDJwHkpVyZcdd0uSHFqzIpQqTJBgmmmHmcSsffGHCO/6jh+dJGk7Gv5rWmA20wEdP533VMYdp6lssAn/fbjEdsz/ELtU49tt3OsCqv3Zt10uIAT1rUPVSPFpvUlYimy53HmGw7nQUYFjh1vVOVLpkh4bREwlI4ZI=
Received: from SN1PR12CA0057.namprd12.prod.outlook.com (2603:10b6:802:20::28)
 by DM6PR12MB3050.namprd12.prod.outlook.com (2603:10b6:5:119::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2367.24; Wed, 23 Oct
 2019 15:10:37 +0000
Received: from BY2NAM03FT040.eop-NAM03.prod.protection.outlook.com
 (2a01:111:f400:7e4a::207) by SN1PR12CA0057.outlook.office365.com
 (2603:10b6:802:20::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2367.21 via Frontend
 Transport; Wed, 23 Oct 2019 15:10:37 +0000
Authentication-Results: spf=none (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=permerror action=none header.from=amd.com;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
Received: from SATLEXMB01.amd.com (165.204.84.17) by
 BY2NAM03FT040.mail.protection.outlook.com (10.152.85.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.20.2387.20 via Frontend Transport; Wed, 23 Oct 2019 15:10:37 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB01.amd.com
 (10.181.40.142) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Wed, 23 Oct
 2019 10:10:35 -0500
From:   Kim Phillips <kim.phillips@amd.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        <kim.phillips@amd.com>
CC:     <stable@vger.kernel.org>, Stephane Eranian <eranian@google.com>,
        "Arnaldo Carvalho de Melo" <acme@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        "Namhyung Kim" <namhyung@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Borislav Petkov" <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] perf/x86/amd/ibs: handle erratum #420 only on the affected CPU family (10h)
Date:   Wed, 23 Oct 2019 10:09:55 -0500
Message-ID: <20191023150955.30292-2-kim.phillips@amd.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191023150955.30292-1-kim.phillips@amd.com>
References: <20191023150955.30292-1-kim.phillips@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB01.amd.com (10.181.40.142) To SATLEXMB01.amd.com
 (10.181.40.142)
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:165.204.84.17;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(376002)(346002)(136003)(428003)(189003)(199004)(86362001)(14444005)(54906003)(53416004)(6666004)(386003)(6116002)(2906002)(3846002)(76176011)(316002)(70206006)(110136005)(70586007)(1076003)(50226002)(81166006)(11346002)(51416003)(8936002)(36756003)(446003)(486006)(2616005)(7416002)(2870700001)(336012)(426003)(16526019)(44832011)(26005)(186003)(476003)(50466002)(126002)(8676002)(4326008)(81156014)(478600001)(47776003)(5660300002)(7736002)(305945005)(356004)(7696005)(48376002)(7049001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3050;H:SATLEXMB01.amd.com;FPR:;SPF:None;LANG:en;PTR:InfoDomainNonexistent;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e7fe2c9b-e4e4-498f-561c-08d757cb28fb
X-MS-TrafficTypeDiagnostic: DM6PR12MB3050:
X-Microsoft-Antispam-PRVS: <DM6PR12MB3050B9EE3941E4126F47131B876B0@DM6PR12MB3050.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 019919A9E4
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yw73JJtDb8RXz24jGZ3+LoqeNU7cMcbZRTAQ4dg6K3zuaUZ0HCH24IISGtWjbIYeD0qodIE72ydF94P7UhH/od80cy3gGp2WyXQjO6yegNoqPayZu4xo2N2UqGY7qwK4SWFyOzdL3UbzwWDESrxOPkkDsoEFINaGamAkW65gRgQQLNCbR8izYEl/e63Y47wJqtFivVpiG695+pc9pJLdahdBDRkB6M+b28QWFQ6V5I503NXDnwZUJIqIkK5+fFftjCaNDc7YgS30GXD1xH2upg6LGy8zwuWP7fMqOeJyEpOc9xTYm0+t9Fxpq+u632kLKPyNaM4cUzpen9N6MAHG2H2ut0EW+twZ6ebV7HpxuhTZ+BOnfCSH6juEfWq35ucM80vyYshHxecTZ9CZA2egE8NLl5EgubRk+7ZKriGnkPl0444XMqjr9Ega2L+r2vpZ
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2019 15:10:37.0399
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e7fe2c9b-e4e4-498f-561c-08d757cb28fb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB01.amd.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3050
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This saves us writing the IBS control MSR twice when disabling the
event.

I searched revision guides for all families since 10h, and did not
find occurrence of erratum #420, nor anything remotely similar:
so we isolate the secondary MSR write to family 10h only.

Also unconditionally update the count mask for IBS Op implementations
that have read & writeable current count (CurCnt) fields in addition
to the MaxCnt field.  These bits were reserved on prior
implementations, and therefore shouldn't have negative impact.

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Fixes: c9574fe0bdb9 ("perf/x86-ibs: Implement workaround for IBS erratum #420")
Cc: stable@vger.kernel.org
Cc: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
---
 arch/x86/events/amd/ibs.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/events/amd/ibs.c b/arch/x86/events/amd/ibs.c
index 98ba21a588a1..26c36357c4c9 100644
--- a/arch/x86/events/amd/ibs.c
+++ b/arch/x86/events/amd/ibs.c
@@ -377,7 +377,8 @@ static inline void perf_ibs_disable_event(struct perf_ibs *perf_ibs,
 					  struct hw_perf_event *hwc, u64 config)
 {
 	config &= ~perf_ibs->cnt_mask;
-	wrmsrl(hwc->config_base, config);
+	if (boot_cpu_data.x86 == 0x10)
+		wrmsrl(hwc->config_base, config);
 	config &= ~perf_ibs->enable_mask;
 	wrmsrl(hwc->config_base, config);
 }
@@ -553,7 +554,8 @@ static struct perf_ibs perf_ibs_op = {
 	},
 	.msr			= MSR_AMD64_IBSOPCTL,
 	.config_mask		= IBS_OP_CONFIG_MASK,
-	.cnt_mask		= IBS_OP_MAX_CNT,
+	.cnt_mask		= IBS_OP_MAX_CNT | IBS_OP_CUR_CNT |
+				  IBS_OP_CUR_CNT_RAND,
 	.enable_mask		= IBS_OP_ENABLE,
 	.valid_mask		= IBS_OP_VAL,
 	.max_period		= IBS_OP_MAX_CNT << 4,
-- 
2.23.0

