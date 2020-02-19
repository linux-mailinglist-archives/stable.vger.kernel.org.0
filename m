Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE4E0165310
	for <lists+stable@lfdr.de>; Thu, 20 Feb 2020 00:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbgBSX23 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Feb 2020 18:28:29 -0500
Received: from mail-bn8nam11on2077.outbound.protection.outlook.com ([40.107.236.77]:6246
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726680AbgBSX23 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Feb 2020 18:28:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FV+2iXAe5eINPU5ZaE8PUUd6jLIUnd9VTHMmQ93X9EpNPGJ6bCWDyPuGhZqSSJLh2thuFk/vA67B7NykKB20ALPZ3vg08o38us48XZ6HYP5vTuG2eX+9CxLcdcHuyDx2uqIQBqBl40pl69aCo+NuY2hPeqN00AQtRwuunoj8cFrl1lbyHrbBnNSQLn6/SMd+oHDYDIFSAxDIVRJVLjt7zDC2hdt5UQt9azruxwWAppXXJNpUjsa73qwm3RgWt9kDHNJ8ABiyJDKwNXzklK/ZqEQl98wbFPOJtMJmK+jo1CWHqPL6X/qKqBkabuhOANROdUxY5LL3haRK4XHWFhWhMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GNf/ErxMfW8RimSQCTxUYZLIolSykVIh80nTZCktsao=;
 b=cFwDBDxyXlYQMdxjTf0N+4DdB5QBDXU9wYgnAaJ6PbSMmNgvI6u3/hNDNJO5069CGsvlNJwF8LBP1T5681RgGuB2eKvNlCa22ZDvBkyck21t6NeAdlQuAkzPkPzyKXEEFpCGbZxH2KN3ySVyxIqmj9MKS0s/zpiTrUaoisqYfhplqmDENBPW7nNikoPTHbtNxigEysd1uMas27qRRctWjzrF0Ebve/JCaRtSkdU+SBkvGcqDfmuS53YTIrJS1Y+79g5uPPs5OfvO5NF8OobpPhBcCyj/P3lAhLict8y4S7BvpsEzBtku9BVm22WuLMavxqE3kvpeKRXCHKrPfVNKOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GNf/ErxMfW8RimSQCTxUYZLIolSykVIh80nTZCktsao=;
 b=KUyld60WiEgOKbQLIx/0TvdOb8ApYlwxrhtek0yB8V4vVkDRtOKGwiCGhPJ1f7O2xmiVoCHuA2lWpzvOeqYdx30ArPi+V+oIXb1k5YDH/5WeiRTOWKxvJVNim1WkNdJs7bcCTLz3T//62wUONcFJs2zQLK7CKzkQ/+AUyQtwXns=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=kim.phillips@amd.com; 
Received: from SN6PR12MB2845.namprd12.prod.outlook.com (52.135.106.33) by
 SN6PR12MB2766.namprd12.prod.outlook.com (52.135.107.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.29; Wed, 19 Feb 2020 23:27:49 +0000
Received: from SN6PR12MB2845.namprd12.prod.outlook.com
 ([fe80::dd6f:a575:af8e:4f1b]) by SN6PR12MB2845.namprd12.prod.outlook.com
 ([fe80::dd6f:a575:af8e:4f1b%7]) with mapi id 15.20.2729.032; Wed, 19 Feb 2020
 23:27:49 +0000
From:   Kim Phillips <kim.phillips@amd.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.com>
Cc:     Kim Phillips <kim.phillips@amd.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Michael Petlan <mpetlan@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 1/3] perf/amd/uncore: Replace manual sampling check with CAP_NO_INTERRUPT flag
Date:   Wed, 19 Feb 2020 17:27:27 -0600
Message-Id: <20200219232729.21460-1-kim.phillips@amd.com>
X-Mailer: git-send-email 2.25.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR14CA0054.namprd14.prod.outlook.com
 (2603:10b6:5:18f::31) To SN6PR12MB2845.namprd12.prod.outlook.com
 (2603:10b6:805:75::33)
MIME-Version: 1.0
Received: from fritz.amd.com (165.204.77.1) by DM6PR14CA0054.namprd14.prod.outlook.com (2603:10b6:5:18f::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.23 via Frontend Transport; Wed, 19 Feb 2020 23:27:47 +0000
X-Mailer: git-send-email 2.25.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2ebaeb8b-0137-48e8-9916-08d7b5935515
X-MS-TrafficTypeDiagnostic: SN6PR12MB2766:|SN6PR12MB2766:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB276623B992BDCD234B8C4B3487100@SN6PR12MB2766.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 0318501FAE
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(39860400002)(366004)(376002)(396003)(189003)(199004)(16526019)(956004)(2616005)(54906003)(36756003)(7416002)(6666004)(44832011)(8936002)(478600001)(110136005)(316002)(26005)(186003)(81156014)(4326008)(66556008)(6486002)(66946007)(86362001)(52116002)(7696005)(1076003)(2906002)(8676002)(66476007)(5660300002)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR12MB2766;H:SN6PR12MB2845.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mT0wxFo/5vR0jdveeUNu1TFQg7h1pq+2pHgga0NKUoEF5++evuaXZWUDyR6Cyoy6vx6Y8tjQ7H21VosiC1yzuErcpo854o48E3hA8eBHZCRw7OVBNE/I+Q2v3YlWty06taYfDzOmlmAI7MY4ynlTe05Vd6HiUXZpOwZSFGpee7UjtWZsbmFH5WyB30V32qbIQJ1Pw2TnhsXRKw/PqKA4ncml0X1IdqrRG7CqRL8zvf0dLVQwKusp/9d3S4bZOYhxrDu+CSklhF6LhM/XlQyBuV3KB1yqJfxSBr6teOKsYooGouGtXM++/qQV7mQhmN18MQaAdqOcdJpL9UzvQyJBndNxSWWsR0P2EF84tJ09v2C+OK3KsXzHNkq1th6/7CM/KF7aTjh6tL+d91q5kTsdZINBkDBe+BXcxhBGOKwudGoH5D1e2C5x1TavNp1e5nGW
X-MS-Exchange-AntiSpam-MessageData: 5ZQyZ7WzS2D7N9OCNzsx8/MKkUu6V1oyxEv5SgqwkPi2nqArxx4f5NfdBhE2gmtUHSbDWNmdY/1WL5TKaV5ty4eDfjy7dZz7gffZDx1skoJzxZwszx7zHBnh5U5VwtZFnTS3tObBOSLA/UdD9sjaXg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ebaeb8b-0137-48e8-9916-08d7b5935515
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2020 23:27:49.0532
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e9zAmHrKhaxUcn6SepsPMr5RsTwtqJzg9qGkNiIDYhPtf27UyLc70fw3rRZqJ+P+GHG7cLMVZnfNXXDDVKoiQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2766
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This enables the sampling check in kernel/events/core.c's
perf_event_open, which returns the more appropriate -EOPNOTSUPP.

BEFORE:

$ sudo perf record -a -e instructions,l3_request_g1.caching_l3_cache_accesses true
Error:
The sys_perf_event_open() syscall returned with 22 (Invalid argument) for event (l3_request_g1.caching_l3_cache_accesses).
/bin/dmesg | grep -i perf may provide additional information.

With nothing relevant in dmesg.

AFTER:

$ sudo perf record -a -e instructions,l3_request_g1.caching_l3_cache_accesses true
Error:
l3_request_g1.caching_l3_cache_accesses: PMU Hardware doesn't support sampling/overflow-interrupts. Try 'perf stat'

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Michael Petlan <mpetlan@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Cc: x86@kernel.org
Cc: stable@vger.kernel.org
Fixes: c43ca5091a37 ("perf/x86/amd: Add support for AMD NB and L2I "uncore" counters")
---
 arch/x86/events/amd/uncore.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/arch/x86/events/amd/uncore.c b/arch/x86/events/amd/uncore.c
index a6ea07f2aa84..4d867a752f0e 100644
--- a/arch/x86/events/amd/uncore.c
+++ b/arch/x86/events/amd/uncore.c
@@ -190,15 +190,12 @@ static int amd_uncore_event_init(struct perf_event *event)
 
 	/*
 	 * NB and Last level cache counters (MSRs) are shared across all cores
-	 * that share the same NB / Last level cache. Interrupts can be directed
-	 * to a single target core, however, event counts generated by processes
-	 * running on other cores cannot be masked out. So we do not support
-	 * sampling and per-thread events.
+	 * that share the same NB / Last level cache.  On family 16h and below,
+	 * Interrupts can be directed to a single target core, however, event
+	 * counts generated by processes running on other cores cannot be masked
+	 * out. So we do not support sampling and per-thread events via
+	 * CAP_NO_INTERRUPT, and we do not enable counter overflow interrupts:
 	 */
-	if (is_sampling_event(event) || event->attach_state & PERF_ATTACH_TASK)
-		return -EINVAL;
-
-	/* and we do not enable counter overflow interrupts */
 	hwc->config = event->attr.config & AMD64_RAW_EVENT_MASK_NB;
 	hwc->idx = -1;
 
@@ -306,7 +303,7 @@ static struct pmu amd_nb_pmu = {
 	.start		= amd_uncore_start,
 	.stop		= amd_uncore_stop,
 	.read		= amd_uncore_read,
-	.capabilities	= PERF_PMU_CAP_NO_EXCLUDE,
+	.capabilities	= PERF_PMU_CAP_NO_EXCLUDE | PERF_PMU_CAP_NO_INTERRUPT,
 };
 
 static struct pmu amd_llc_pmu = {
@@ -317,7 +314,7 @@ static struct pmu amd_llc_pmu = {
 	.start		= amd_uncore_start,
 	.stop		= amd_uncore_stop,
 	.read		= amd_uncore_read,
-	.capabilities	= PERF_PMU_CAP_NO_EXCLUDE,
+	.capabilities	= PERF_PMU_CAP_NO_EXCLUDE | PERF_PMU_CAP_NO_INTERRUPT,
 };
 
 static struct amd_uncore *amd_uncore_alloc(unsigned int cpu)
-- 
2.25.0

