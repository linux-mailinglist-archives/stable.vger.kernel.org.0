Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 638D915616E
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 00:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbgBGXE4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Feb 2020 18:04:56 -0500
Received: from mail-bn8nam12on2089.outbound.protection.outlook.com ([40.107.237.89]:6143
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727048AbgBGXE4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Feb 2020 18:04:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yk0hrjFba5HzT+dG/CtBVUmlCy4numjyV+++GcaoW9/Yut+03Yw4UYRMnbdY6/UQtt84w/mJEr1e70od1wkxFAHUixc3MjQ4TAeq6XAr5Z/qoU89TNNkD9fNwVH4MgoK7eB24+8t9zbsfPE2PPJDBadfW8QKwe5Sem8VmHJv/ovQhOpeWjNFcNS5a2CW4zRkuM4/37oSR2AtY/Fkm6OygZFePeEtMsnCaiuGQVDMrfXIACT+4Itrbd4UkUhdD3uVjmH+0ViksHb8d+N6pe/tUghXpDOTcqSJObJlhXCFknvRVWAlSTOGKlYHQhuyb1rEJbGV6YWgbwuVreEdp3OqKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8xYQEzITvANk/hoERQpnsWfh1xMjBwoHyXkd7+KHLhg=;
 b=ckAWKsQx97RcO40siVFHDpbOHGNjDV5CAXyu0EdgbMgciXyNN4/j56x0kPlA57P0sFBs5YEVCvfBKTz70kGro47MSXMbcPL15MyJj3lhESzHFR46Oh/lJf69A51F4Vay540s5qD0U/phVZ468rLABKLP77TNp6Ncn+K8sbIZKSKitDkYTn+EjWV3irPqyhoMWSEJy4wH+qRto0m2UNifVvCfV8pFnWwsDNIqsn8yvzWewiz+vwECLebSEB5f/SghQJAuWXqQM9tEHVzjJqglzb36nvHsSFIWVcGmK/9voEfMTkKcQq4rv5+4mWiY/Hd0+lCS1ICQk8h8xp1T8YG6pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8xYQEzITvANk/hoERQpnsWfh1xMjBwoHyXkd7+KHLhg=;
 b=n/Q6w/yqOIQauWSMOEz/5onxMafs+aLhc/912jlv6rXz0vDjwuNTORPmyFh2SfTiGsTURkQ0czGHmYV+E9t4+lGVpsgC4zDB6Fhmp92QfSm7x3lz/Q0iHa1dsIZbxCV6+cSLlFx8L3pk+vE7qWHOrQl+ouxkBUOgggGU3C0LjVQ=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=kim.phillips@amd.com; 
Received: from SN6PR12MB2845.namprd12.prod.outlook.com (52.135.106.33) by
 SN6PR12MB2766.namprd12.prod.outlook.com (52.135.107.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.32; Fri, 7 Feb 2020 23:04:48 +0000
Received: from SN6PR12MB2845.namprd12.prod.outlook.com
 ([fe80::dd6f:a575:af8e:4f1b]) by SN6PR12MB2845.namprd12.prod.outlook.com
 ([fe80::dd6f:a575:af8e:4f1b%7]) with mapi id 15.20.2707.024; Fri, 7 Feb 2020
 23:04:48 +0000
From:   Kim Phillips <kim.phillips@amd.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.com>
Cc:     Kim Phillips <kim.phillips@amd.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Babu Moger <babu.moger@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Frank van der Linden <fllinden@amazon.com>,
        "H . Peter Anvin" <hpa@zytor.com>, Huang Rui <ray.huang@amd.com>,
        Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>,
        Jan Beulich <jbeulich@suse.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luwei Kang <luwei.kang@intel.com>,
        =?UTF-8?q?Martin=20Li=C5=A1ka?= <mliska@suse.cz>,
        Matt Fleming <matt@codeblueprint.co.uk>,
        Michael Petlan <mpetlan@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tom Lendacky <thomas.lendacky@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 1/2 v2 RESEND] perf/x86/amd: Add missing L2 misses event spec to AMD Family 17h's event map
Date:   Fri,  7 Feb 2020 17:04:26 -0600
Message-Id: <20200207230427.26515-1-kim.phillips@amd.com>
X-Mailer: git-send-email 2.25.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0501CA0073.namprd05.prod.outlook.com
 (2603:10b6:803:22::11) To SN6PR12MB2845.namprd12.prod.outlook.com
 (2603:10b6:805:75::33)
MIME-Version: 1.0
Received: from fritz.amd.com (165.204.77.1) by SN4PR0501CA0073.namprd05.prod.outlook.com (2603:10b6:803:22::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.9 via Frontend Transport; Fri, 7 Feb 2020 23:04:47 +0000
X-Mailer: git-send-email 2.25.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2ec5e8a7-fb0f-4852-daa9-08d7ac22211f
X-MS-TrafficTypeDiagnostic: SN6PR12MB2766:|SN6PR12MB2766:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB27668F1FF1E6723DBA29DE48871C0@SN6PR12MB2766.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 0306EE2ED4
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(366004)(396003)(376002)(346002)(199004)(189003)(16526019)(186003)(81156014)(66476007)(81166006)(26005)(7696005)(8676002)(478600001)(4326008)(1076003)(966005)(2906002)(52116002)(66946007)(7416002)(66556008)(5660300002)(6666004)(316002)(110136005)(956004)(36756003)(54906003)(44832011)(2616005)(8936002)(86362001)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR12MB2766;H:SN6PR12MB2845.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8jM2WNibvbkFQrMfleRmB5gLpjoPafWXruyLpaNQRvKKGFp32z+/lzzoVSnwbngmStIbo5/nyHQkWbz68HxOf1Ih9rO22ed2NwftFKTnCPnC0tWCQw4F+MZUy85JGuTLzRrDFzJ5BlzZh5RcVrGqtMsWC9m+E3B5146d2iqPTlDeZWxCV6G6ESIzIZK/RQ5v6UNdgSuJLcrGx0uHrxOK8l8YfOs+HBOsRJChGW34U7n9/TZJeWJYqyJhUx3Kdw3RkZAKA9KeUm/HrrtSU/rM+7mKypfUUhDFvpAu9bEPsT/6pCrNwWwg63iblFZlGDwOnEOdIST881HtJqzsL7Y6ZmEGFeKkbPiJNV/+1O2QeUTB2lsvQog6VO0q9n/p+yYcwQIpu1LEsztcafIC+C8AIHSGpw3S2F3Zy2ZNTtJwcu0K11BEq0FO6E18vrXFxUDy5mlEJ1BTtAEqbfJ/If/napYfBOIXvt2pX4Lg7Yd3nEm6hlzq4W9VLOTo1h9Ou7SImxrZ5EYYMaz36ohHr8iHXw==
X-MS-Exchange-AntiSpam-MessageData: mKoZFfs24qWcQbEitba0oJZ4ZIJrXelQNvvapF/07sIZK0pUBl37noMV0BuMmcitmVu3l2RG0CPDp2ssvtqk3YmizkO7AmWQ8cplUVTyRC8gRV5w8Eeu9j7ZCXYsP+VryjNAkGFIPIvl1Ppue4k6jA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ec5e8a7-fb0f-4852-daa9-08d7ac22211f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2020 23:04:48.3404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2CRW/mLDSI44xFgxOlGO5KieT0hdabwpA4TQoEZiNmYBjiH1U653WxA02A/4ladC43dsraGjE2mOtE/X77vR4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2766
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 3fe3331bb285 ("perf/x86/amd: Add event map for AMD Family 17h"),
claimed L2 misses were unsupported, due to them not being found in its
referenced documentation, whose link has now moved [1].

That old documentation listed PMCx064 unit mask bit 3 as:

    "LsRdBlkC: LS Read Block C S L X Change to X Miss."

and bit 0 as:

    "IcFillMiss: IC Fill Miss"

We now have new public documentation [2] with improved descriptions, that
clearly indicate what events those unit mask bits represent:

Bit 3 now clearly states:

    "LsRdBlkC: Data Cache Req Miss in L2 (all types)"

and bit 0 is:

    "IcFillMiss: Instruction Cache Req Miss in L2."

So we can now add support for L2 misses in perf's genericised events as
PMCx064 with both the above unit masks.

[1] The commit's original documentation reference, "Processor Programming
    Reference (PPR) for AMD Family 17h Model 01h, Revision B1 Processors",
    originally available here:

        https://www.amd.com/system/files/TechDocs/54945_PPR_Family_17h_Models_00h-0Fh.pdf

    is now available here:

        https://developer.amd.com/wordpress/media/2017/11/54945_PPR_Family_17h_Models_00h-0Fh.pdf

[2] "Processor Programming Reference (PPR) for Family 17h Model 31h,
    Revision B0 Processors", available here:

	https://developer.amd.com/wp-content/resources/55803_0.54-PUB.pdf

Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Babu Moger <babu.moger@amd.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Frank van der Linden <fllinden@amazon.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Huang Rui <ray.huang@amd.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>
Cc: Jan Beulich <jbeulich@suse.com>
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Luwei Kang <luwei.kang@intel.com>
Cc: Martin Liška <mliska@suse.cz>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Michael Petlan <mpetlan@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Reported-by: Babu Moger <babu.moger@amd.com>
Tested-by: Babu Moger <babu.moger@amd.com>
Fixes: 3fe3331bb285 ("perf/x86/amd: Add event map for AMD Family 17h")
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
---
RESEND, adding Michael Petlan to cc. Original v2:

https://lore.kernel.org/lkml/20200121171232.28839-1-kim.phillips@amd.com/

v2: no changes.

 arch/x86/events/amd/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/events/amd/core.c b/arch/x86/events/amd/core.c
index 1f22b6bbda68..39eb276d0277 100644
--- a/arch/x86/events/amd/core.c
+++ b/arch/x86/events/amd/core.c
@@ -250,6 +250,7 @@ static const u64 amd_f17h_perfmon_event_map[PERF_COUNT_HW_MAX] =
 	[PERF_COUNT_HW_CPU_CYCLES]		= 0x0076,
 	[PERF_COUNT_HW_INSTRUCTIONS]		= 0x00c0,
 	[PERF_COUNT_HW_CACHE_REFERENCES]	= 0xff60,
+	[PERF_COUNT_HW_CACHE_MISSES]		= 0x0964,
 	[PERF_COUNT_HW_BRANCH_INSTRUCTIONS]	= 0x00c2,
 	[PERF_COUNT_HW_BRANCH_MISSES]		= 0x00c3,
 	[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND]	= 0x0287,
-- 
2.25.0

