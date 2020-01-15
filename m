Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7474613CE5F
	for <lists+stable@lfdr.de>; Wed, 15 Jan 2020 21:57:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728916AbgAOU5S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jan 2020 15:57:18 -0500
Received: from mail-mw2nam12on2043.outbound.protection.outlook.com ([40.107.244.43]:3361
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726187AbgAOU5S (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Jan 2020 15:57:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g7klwDPzIt2D+anRlc9PHwxlBNMGgSjKOpVii4Fq4MmMD0dVa5uanEmZW8sta7Bqa50xOn6j5EB2kix7SeqXXgyLrLQjHpeRWVx1Japg35BhRtKwvrNEEabcu3yeYMgs1Lmif/4urgeVpKZ13w3aUqlj1PfSRJ+M6JAC7b6peA2ZN3PW448tskGFZBxP3sYTYo/YLxMu9HznWEDWBy1kXB4nmD2KzzXTFzY6sZG4k+yRIVRoYroo4X5u0/FpBr070pvPQPmmotgGAV1upnLn81ez5ofRkt63/3DxNrSXzFiJ56lsG2D422/9d0LEJ8/r5dKaNueZPxJ/HqdU6+MfXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XpbW5csogjXGbbIoP55U1jmbMngXqXo7QL7pdVFyp3c=;
 b=A5jq5ORpuE4FSTtdtfQz8S7yyRi52tpWPRUdgF74w+6JLAZp2JL6QN8l3UAR5ScgwYvEONYbrZoVtj5SZZ+wGbqWsw7c+aS5bPS8XKBrnnDWqVw1Dn7pcsxIxHewcty3XeHcwF+1ZIBenQwpy+1JJTMpp7Qv2BJz0AYmKYepNPCNWQFFensc3LCVFf5g7nN/pvwqYC0KH46rUg/Vy9nrKdMH3WbbjjsNv+3MCX0dUKE2s/C+l5Eff7NgnoCP6dsb+2J0LFSsXttn2LlB4Finga1sUefWQltlzVDrBfi4YG63f1dhCk6e4TinSFA6i+Qg0OYfGyeJrQXcnyXtAx4mXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XpbW5csogjXGbbIoP55U1jmbMngXqXo7QL7pdVFyp3c=;
 b=FjAUBR41uCh9pDmqCHKVB0hpwvwWCLPh/Bgj9pYp+k5HFGsghiLaO243GGXbrJUzuuB97wjvTxNgpfvBSbtVOPflXAA1o20zL/OluZ8wFOMF+8EF2IZf0g7cpUJc5wq2EDBt45Uzx5/tsZ5HW4CcaMERltC4VyeIPHjcWffPEkg=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=kim.phillips@amd.com; 
Received: from SN6PR12MB2845.namprd12.prod.outlook.com (52.135.106.33) by
 SN6PR12MB2813.namprd12.prod.outlook.com (52.135.100.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.18; Wed, 15 Jan 2020 20:57:09 +0000
Received: from SN6PR12MB2845.namprd12.prod.outlook.com
 ([fe80::48af:8c71:edee:5bc]) by SN6PR12MB2845.namprd12.prod.outlook.com
 ([fe80::48af:8c71:edee:5bc%7]) with mapi id 15.20.2644.015; Wed, 15 Jan 2020
 20:57:09 +0000
From:   Kim Phillips <kim.phillips@amd.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        kim.phillips@amd.com
Cc:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
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
        Namhyung Kim <namhyung@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tom Lendacky <thomas.lendacky@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 2/2] x86/cpu/amd: Enable the fixed intructions retired free counter IRPERF
Date:   Wed, 15 Jan 2020 14:56:46 -0600
Message-Id: <20200115205646.10678-2-kim.phillips@amd.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200115205646.10678-1-kim.phillips@amd.com>
References: <20200115205646.10678-1-kim.phillips@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0201CA0049.namprd02.prod.outlook.com
 (2603:10b6:803:20::11) To SN6PR12MB2845.namprd12.prod.outlook.com
 (2603:10b6:805:75::33)
MIME-Version: 1.0
Received: from fritz.amd.com (165.204.77.1) by SN4PR0201CA0049.namprd02.prod.outlook.com (2603:10b6:803:20::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 20:57:07 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 37e3c44c-548d-4cc9-c03a-08d799fd7c68
X-MS-TrafficTypeDiagnostic: SN6PR12MB2813:|SN6PR12MB2813:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2813DDCB6CAA3EC48620A16387370@SN6PR12MB2813.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-Forefront-PRVS: 02830F0362
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(346002)(376002)(396003)(39860400002)(199004)(189003)(86362001)(186003)(52116002)(7696005)(16526019)(110136005)(26005)(966005)(478600001)(316002)(66946007)(44832011)(54906003)(4326008)(66476007)(36756003)(6666004)(7416002)(2906002)(6486002)(81166006)(956004)(8676002)(66556008)(8936002)(2616005)(81156014)(66574012)(1076003)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR12MB2813;H:SN6PR12MB2845.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vYHZNYXPUiv1iqjgv+2rL0odI3foZBLipW53IqpkWY19gUP4A9QvqW1r8jexwA5ywGKNxhzi9z70QoAv51BGITEzJiPb/EVy1Gbao8uk8qO7cl454l3J/u+ZH8afl7n4cRowjlgWXXTC0zg0hJx4pr1VfPQy5/Xenhw/w5wfUGhqY/zfViWeuK4hxVonvgvoV13gGxeaBRrS8BBebR9SkIH7JJ2JQvAzLQkzeW5laxve5PGGmAvHz3HQ/h4B3QB/hcr6D2fs93gIGYdRukycL2hqp3CpAJJvFNt5TBpodt+jMwZQMMW8eoLVaMumsLiEvnHf9PV2IOMTGJF40OuIHI6SK84VdLwE76dEOskvIF28pi4s5ptNimJGaSPyQf0YjIiWMksDhPeVWEkanA19LcEQB8ocCbF5NJ4erqdG1iGEGw3sBa0KvHc9AoKwmsD/eEe3lNPe6P1eq+TDCV1fZLY28oni7JMDejgoivZ1aVQ=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37e3c44c-548d-4cc9-c03a-08d799fd7c68
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2020 20:57:09.1568
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fof3B2W/R9nS2ld5j8ryuZ8sKjLSWj7kQJevmCUZ1ii7235dNrRJHeOiOu30QU9oalaIsv/W6jWIR76pU1kpmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2813
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit aaf248848db50 ("perf/x86/msr: Add AMD IRPERF (Instructions
Retired) performance counter") added support for 'perf -e msr/irperf/',
but when exercised, we always get a 0 count:

BEFORE:

$ sudo perf stat -e instructions,msr/irperf/ true

 Performance counter stats for 'true':

           624,833      instructions
                                                  #    0.00  stalled cycles per insn
                 0      msr/irperf/

It turns out it simply needs its enable bit - HWCR bit 30 - set.  This patch
does just that.

Enablement is restricted to all machines advertising IRPERF capability,
except those susceptible to an erratum that makes the IRPERF return
bad values.

That erratum occurs in Family 17h models 00-1fh [1], but not in F17h
models 20h and above [2].

AFTER (on a family 17h model 31h machine):

$ sudo perf stat -e instructions,msr/irperf/ true

 Performance counter stats for 'true':

           621,690      instructions
                                                  #    0.00  stalled cycles per insn
           622,490      msr/irperf/

[1] "Revision Guide for AMD Family 17h Models 00h-0Fh Processors",
    currently available here:

    https://www.amd.com/system/files/TechDocs/55449_Fam_17h_M_00h-0Fh_Rev_Guide.pdf

[2] "Revision Guide for AMD Family 17h Models 30h-3Fh Processors",
    currently available here:

    https://developer.amd.com/wp-content/resources/56323-PUB_0.74.pdf

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
Fixes: aaf248848db50 ("perf/x86/msr: Add AMD IRPERF (Instructions Retired) performance counter")
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
---
 arch/x86/include/asm/msr-index.h | 2 ++
 arch/x86/kernel/cpu/amd.c        | 9 +++++++++
 2 files changed, 11 insertions(+)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 084e98da04a7..717660f82f8f 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -512,6 +512,8 @@
 #define MSR_K7_HWCR			0xc0010015
 #define MSR_K7_HWCR_SMMLOCK_BIT		0
 #define MSR_K7_HWCR_SMMLOCK		BIT_ULL(MSR_K7_HWCR_SMMLOCK_BIT)
+#define MSR_K7_HWCR_IRPERF_EN_BIT	30
+#define MSR_K7_HWCR_IRPERF_EN		BIT_ULL(MSR_K7_HWCR_IRPERF_EN_BIT)
 #define MSR_K7_FID_VID_CTL		0xc0010041
 #define MSR_K7_FID_VID_STATUS		0xc0010042
 
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 90f75e515876..765b2b6672eb 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -978,6 +978,15 @@ static void init_amd(struct cpuinfo_x86 *c)
 	/* AMD CPUs don't reset SS attributes on SYSRET, Xen does. */
 	if (!cpu_has(c, X86_FEATURE_XENPV))
 		set_cpu_bug(c, X86_BUG_SYSRET_SS_ATTRS);
+
+	/*
+	 * Turn on the Instructions Retired free counter on machines not
+	 * susceptible to erratum #1054 "Instructions Retired Performance
+	 * Counter May Be Inaccurate"
+	 */
+	if (cpu_has(c, X86_FEATURE_IRPERF) &&
+	    !(c->x86 == 0x17 && c->x86_model <= 0x1f))
+		msr_set_bit(MSR_K7_HWCR, MSR_K7_HWCR_IRPERF_EN_BIT);
 }
 
 #ifdef CONFIG_X86_32
-- 
2.24.1

