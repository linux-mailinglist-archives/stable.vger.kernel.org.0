Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55DB7E1EEF
	for <lists+stable@lfdr.de>; Wed, 23 Oct 2019 17:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406545AbfJWPKa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Oct 2019 11:10:30 -0400
Received: from mail-eopbgr720073.outbound.protection.outlook.com ([40.107.72.73]:23212
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2406544AbfJWPKa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Oct 2019 11:10:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ADcp0+JxDMQf8zqur9puQk/zv1AR/PcUKEnn2qViEzKqm6SJx/tnSq2w0OgnfHtlzowgbdrmAuTV2w1Eu1JygcU1ITzGlsV/bqjRCUFb2UFDp7CuUQr2/nIs0HSpTt1dRoUltDP/UgB/cc1ADNJZjSgvZaf/5zYiQrO77eN4Ver/iBUXlhW4rec1UW+bzw1UwOIW7gszBCM1MWbM+SBwqrubytj8hOaW6K1stTlII3+YFPRm8DDFcxbgWQpX2mMnXyjme/UBJ0o5bU40MH9UA32ifAeq3L/LnreEmCZmuWq88DM/tl7S+gCjPwvRwqCguzocdDB2yGQ/3nHWLZEiIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NYVqaNguwvQNGohg3eYIEB3nVDcm3Twlycg/gMk33FU=;
 b=PdbHOXywD5lFNb3BNrGXbP8M/bCtslSxAn1HSIXP3+o3DFeyPmJ9/cbu441yH3aVXbCPSPPEUZoziH5kUYan0LhWNlboBoHBRSqs/JO+FRb1KblFKNqrw+dIqRrqDnf47ARV3JE4dhPuAqT338B7mIifHwqXtu0YS6Y6vDAViChfkhsh4LePeX25S/w+jkaahxGH0VfnGqVeBVQGdDwylool1M0FYsmDzCBBCUnJlu/yMMBJJJ9wG5WLF6HmtdXVBrV7oQbMgJzC4yZYRohY/JRMbTD6H7Am1Y5m4qj7NdJRxnw8+WMeKvXcx7QwYQj69KOJdr4gcEwQ+q2U/1AMEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none (sender ip is
 165.204.84.17) smtp.rcpttodomain=infradead.org smtp.mailfrom=amd.com;
 dmarc=permerror action=none header.from=amd.com; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NYVqaNguwvQNGohg3eYIEB3nVDcm3Twlycg/gMk33FU=;
 b=CsdOxpTLuI7YDMJ6UjdRuDi0tRkkYm0nKqL0SoJBFPZIG+BdxRL2q4btlSY3RXBBJSFcD3aRO3E+2nywDeGA8ZDtH1FwqntJcQAna1r1CDGX+8tjFC02NJeGYhYaRB4eeaP8GaoNueKWdH4HwKCIVtIll/KGwstrDOPQ0g3CE6Y=
Received: from MWHPR12CA0062.namprd12.prod.outlook.com (2603:10b6:300:103::24)
 by BYAPR12MB2918.namprd12.prod.outlook.com (2603:10b6:a03:13c::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2387.20; Wed, 23 Oct
 2019 15:10:26 +0000
Received: from BY2NAM03FT043.eop-NAM03.prod.protection.outlook.com
 (2a01:111:f400:7e4a::209) by MWHPR12CA0062.outlook.office365.com
 (2603:10b6:300:103::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2387.20 via Frontend
 Transport; Wed, 23 Oct 2019 15:10:26 +0000
Authentication-Results: spf=none (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=permerror action=none header.from=amd.com;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
Received: from SATLEXMB01.amd.com (165.204.84.17) by
 BY2NAM03FT043.mail.protection.outlook.com (10.152.85.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.20.2387.20 via Frontend Transport; Wed, 23 Oct 2019 15:10:26 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB01.amd.com
 (10.181.40.142) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Wed, 23 Oct
 2019 10:10:24 -0500
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
Subject: [PATCH 1/2] perf/x86/amd/ibs: Fix reading of the IBS OpData register and thus precise RIP validity
Date:   Wed, 23 Oct 2019 10:09:54 -0500
Message-ID: <20191023150955.30292-1-kim.phillips@amd.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB01.amd.com (10.181.40.142) To SATLEXMB01.amd.com
 (10.181.40.142)
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:165.204.84.17;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(6029001)(4636009)(396003)(39860400002)(376002)(346002)(136003)(428003)(189003)(199004)(3846002)(14444005)(316002)(110136005)(7049001)(336012)(48376002)(47776003)(54906003)(6116002)(4326008)(386003)(51416003)(53416004)(6666004)(7696005)(5660300002)(2870700001)(356004)(478600001)(486006)(16526019)(2906002)(70586007)(26005)(36756003)(1076003)(86362001)(7416002)(426003)(44832011)(50466002)(7736002)(8936002)(70206006)(8676002)(50226002)(476003)(305945005)(126002)(81156014)(81166006)(186003)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR12MB2918;H:SATLEXMB01.amd.com;FPR:;SPF:None;LANG:en;PTR:InfoDomainNonexistent;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e472328f-4354-42ca-ec1e-08d757cb2253
X-MS-TrafficTypeDiagnostic: BYAPR12MB2918:
X-Microsoft-Antispam-PRVS: <BYAPR12MB291825087DE7337F36466E72876B0@BYAPR12MB2918.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 019919A9E4
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vQwIRZlMu9o4JnTZsl7O7xwxIXlfRuc0jm3qXTCwgb/57RlQoX9WqZGDpYALfn7K2C2UURlXQ4GajDOGeaYyvpmt9UVYeJbFz/fSgVTzwTCww0Y+lRUy6KlstI54QMwQhTo6ftR0rya3j4plXeMqdr3JUXulIInva9sjDi/PbBlrPIK/HDQsh0k+L79xCtSBDbNUbo0nOOegT5HQPQgnohq0gIMCd6YaegYq16+gUh+h7lG7rCAEgSbDhMHWt1Ct2eoflYDgY2iSfLIuaFpbbirE2zZQXFWq6jUJdsQGt4ZZnW6MIgPkrMw4L+y9YFFxDH3ymISSW/ObXMR5pT6DRdgFLja4bT4PHins9whWegn57DBe7qZSh7Rubi234i7VOE8HlYCA92qwVq5a1JtiFIyMfo71fGUl1OIz3H7jhEYZ2AvzapZhJ1tXQY8c8T8l
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2019 15:10:26.0796
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e472328f-4354-42ca-ec1e-08d757cb2253
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB01.amd.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2918
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The loop that reads all the IBS MSRs into *buf stopped one MSR short of
reading the IbsOpData register, which contains the RipInvalid status bit.

Fix the offset_max assignment so the MSR gets read, so the RIP invalid
evaluation is based on what the IBS h/w output, instead of what was
left in memory.

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Fixes: d47e8238cd76 ("perf/x86-ibs: Take instruction pointer from ibs sample")
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
 arch/x86/events/amd/ibs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/events/amd/ibs.c b/arch/x86/events/amd/ibs.c
index 5b35b7ea5d72..98ba21a588a1 100644
--- a/arch/x86/events/amd/ibs.c
+++ b/arch/x86/events/amd/ibs.c
@@ -614,7 +614,7 @@ static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
 	if (event->attr.sample_type & PERF_SAMPLE_RAW)
 		offset_max = perf_ibs->offset_max;
 	else if (check_rip)
-		offset_max = 2;
+		offset_max = 3;
 	else
 		offset_max = 1;
 	do {
-- 
2.23.0

