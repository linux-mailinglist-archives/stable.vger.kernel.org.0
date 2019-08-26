Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0209D70C
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 21:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732800AbfHZT6C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Aug 2019 15:58:02 -0400
Received: from mail-eopbgr690047.outbound.protection.outlook.com ([40.107.69.47]:57070
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727504AbfHZT6B (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Aug 2019 15:58:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mi6+Blg88VIhlG/e+LkmbAL9pCU15leS3nkUUxUsCfayBTND4jSOqwtFdbi8qnbfdio3vQ4U94reA2WOQXRiR/az+UI1RbrAGQU3lbr0zbXDpMICEI89yh3fFyBKONzIBonf4wRO5Co/A+pn61HCPkERKGEyJjckZIa8I+FhPCFpCosFpEtnerucvja3CvQNFvRsUkUNv5sxAMAQpsdun7oZ8/eyuSbXSsA3UPpvIURfeLlVWkYiUjTG+ieLT0jg1cl5/aZIHP8tCmpLzEwkyJBty6xvn8p6ayPpfaTTMIOz/sdtSmAwhBOeWA1bguog8AuEnc5dkI6ZCq4TpSFgtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tPK6dknh5jRD3k+lcaLK7tlHQEue4vYHl05l8368KCQ=;
 b=cZYG8Z8lLrUC+pAmDd+DvHbqFaja5AtnSOuao9c2jkQYkSkYylTNVX55GSktHxQVdV/Vo4iMg/xX8JFZzLiWG3RNN40UQhyvQlT/5mPF4g2FZ1DG0KBIKVjiK/d/uOP0AKZ16xsYCvx5PTNpBMf3ncwpE/F80K6sofmqda67COl8zLIXjMsFReX9d8T4DqqqC5hjkS7yZ0BOuI7CG/0Pp/iLkb9npUjHBlTyh6nZe1bz0pFzE8GiMBX/y1DMNjScNmMqZDU2IJmWukTcipOzgZj/P7GojBK+H/3D5wDiVKN1EsUXr61YQ8UXxGcsDraXnP7PppotLy2eIp0eJKSCAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none (sender ip is
 165.204.84.17) smtp.rcpttodomain=alien8.de smtp.mailfrom=amd.com;
 dmarc=permerror action=none header.from=amd.com; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tPK6dknh5jRD3k+lcaLK7tlHQEue4vYHl05l8368KCQ=;
 b=1dbQ2InEGhrnFvE3NI0WqqhTe39LXIwMcw86/6o9HnTfQlLhh6ThIllaXVegXz33VLM+nVj90aJyarpErIS0dM7ykA5xppo9wsIxCk6K0dV5wyT9q+IajzDsvzYuhXXl06UQdUqjjP0dfcVNOnO7bfgjLPvc0lYksJkpXh5Bs8k=
Received: from SN1PR12CA0112.namprd12.prod.outlook.com (2603:10b6:802:21::47)
 by CY4PR12MB1271.namprd12.prod.outlook.com (2603:10b6:903:3d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2178.16; Mon, 26 Aug
 2019 19:57:59 +0000
Received: from CO1NAM03FT061.eop-NAM03.prod.protection.outlook.com
 (2a01:111:f400:7e48::205) by SN1PR12CA0112.outlook.office365.com
 (2603:10b6:802:21::47) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2178.18 via Frontend
 Transport; Mon, 26 Aug 2019 19:57:59 +0000
Authentication-Results: spf=none (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; alien8.de; dkim=none (message not signed)
 header.d=none;alien8.de; dmarc=permerror action=none header.from=amd.com;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
Received: from SATLEXCHOV02.amd.com (165.204.84.17) by
 CO1NAM03FT061.mail.protection.outlook.com (10.152.81.47) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2178.16 via Frontend Transport; Mon, 26 Aug 2019 19:57:57 +0000
Received: from totem.amd.com (10.180.168.240) by SATLEXCHOV02.amd.com
 (10.181.40.72) with Microsoft SMTP Server (TLS) id 14.3.389.1; Mon, 26 Aug
 2019 14:57:56 -0500
From:   Kim Phillips <kim.phillips@amd.com>
To:     Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     Kim Phillips <kim.phillips@amd.com>,
        Stephane Eranian <eranian@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        "Arnaldo Carvalho de Melo" <acme@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        "Namhyung Kim" <namhyung@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Borislav Petkov" <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        <x86@kernel.org>, <stable@vger.kernel.org>
Subject: [PATCH] perf/x86/amd/ibs: Fix sample bias for dispatched micro-ops
Date:   Mon, 26 Aug 2019 14:57:30 -0500
Message-ID: <20190826195730.30614-1-kim.phillips@amd.com>
X-Mailer: git-send-email 2.23.0.37.g745f6812895b
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:165.204.84.17;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(136003)(396003)(346002)(2980300002)(428003)(199004)(189003)(70206006)(316002)(6666004)(356004)(36756003)(26005)(14444005)(44832011)(4326008)(486006)(16526019)(476003)(2616005)(336012)(126002)(186003)(2870700001)(47776003)(70586007)(81156014)(6116002)(3846002)(8676002)(50226002)(81166006)(8936002)(305945005)(53936002)(478600001)(7736002)(50466002)(426003)(2906002)(7416002)(48376002)(53416004)(54906003)(5660300002)(1076003)(110136005)(51416003)(86362001)(7696005);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR12MB1271;H:SATLEXCHOV02.amd.com;FPR:;SPF:None;LANG:en;PTR:InfoDomainNonexistent;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 480dd344-3b2e-4c9a-c6fa-08d72a5fb156
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:CY4PR12MB1271;
X-MS-TrafficTypeDiagnostic: CY4PR12MB1271:
X-Microsoft-Antispam-PRVS: <CY4PR12MB1271209659DCC5FDC658BD2587A10@CY4PR12MB1271.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:923;
X-Forefront-PRVS: 01415BB535
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: bIdOfN0vXbdRopfAmLsg9kZffj7lA7eyBw4EvQThflheCJ1YfGON0rxr/lCCuvQOk5jqYOXbKhwRAoni5pcvWiRvCkNt+rTJHciqWk1rEM8BK5lmjcwSV22Czkdi4su+NWuMV/GQQlR94LXwoDNEe/cOVSeu3oNOh5n4dqtCW3p2RxKfyz6EZu9V36smcPmT+iyvpQ4jvrItMRf8vWN4Y6cdIWXXPvAnHPACNKunXyBRhJxZGs0NbBDfa/m2KnZzRr1OgAauH1pg61fKC6NCmf0ypVdpR+aRp5o3p0jinjYNxt6fmaheF1ZVJJq4IGM72ChcfEQmsC4PgxHJhc/EHNORZgtrcH5l9YZADbYxtgzUnBXZCscX0i6TT0iDvZSR23a7GSo1bwTU2WTp2KY2tMfU7+4JEt3MyNkAYgdsM1o=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2019 19:57:57.5843
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 480dd344-3b2e-4c9a-c6fa-08d72a5fb156
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXCHOV02.amd.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1271
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When counting dispatched micro-ops with cnt_ctl=1, in order to prevent
sample bias, IBS hardware preloads the least significant 7 bits of
current count (IbsOpCurCnt) with random values, such that, after the
interrupt is handled and counting resumes, the next sample taken
will be slightly perturbed.

The current count bitfield is in the IBS execution control h/w register,
alongside the maximum count field.

Currently, the IBS driver writes that register with the maximum count,
leaving zeroes to fill the current count field, thereby overwriting
the random bits the hardware preloaded for itself.

Fix the driver to actually retain and carry those random bits from the
read of the IBS control register, through to its write, instead of
overwriting the lower current count bits with zeroes.

Tested with:

perf record -c 100001 -e ibs_op/cnt_ctl=1/pp -a -C 0 taskset -c 0 <workload>

'perf annotate' output before:

 15.70  65:   addsd     %xmm0,%xmm1
 17.30        add       $0x1,%rax
 15.88        cmp       %rdx,%rax
              je        82
 17.32  72:   test      $0x1,%al
              jne       7c
  7.52        movapd    %xmm1,%xmm0
  5.90        jmp       65
  8.23  7c:   sqrtsd    %xmm1,%xmm0
 12.15        jmp       65

'perf annotate' output after:

 16.63  65:   addsd     %xmm0,%xmm1
 16.82        add       $0x1,%rax
 16.81        cmp       %rdx,%rax
              je        82
 16.69  72:   test      $0x1,%al
              jne       7c
  8.30        movapd    %xmm1,%xmm0
  8.13        jmp       65
  8.24  7c:   sqrtsd    %xmm1,%xmm0
  8.39        jmp       65

Tested on Family 15h and 17h machines.

Machines prior to family 10h Rev. C don't have the RDWROPCNT capability,
and have the IbsOpCurCnt bitfield reserved, so this patch shouldn't
affect their operation.

It is unknown why commit db98c5faf8cb ("perf/x86: Implement 64-bit
counter support for IBS") ignored the lower 4 bits of the IbsOpCurCnt
field; the number of preloaded random bits has always been 7, AFAICT.

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
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
Cc: stable@vger.kernel.org
---
 arch/x86/events/amd/ibs.c         | 11 +++++++++--
 arch/x86/include/asm/perf_event.h |  9 ++++++---
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/arch/x86/events/amd/ibs.c b/arch/x86/events/amd/ibs.c
index 62f317c9113a..f2625b4a5a8b 100644
--- a/arch/x86/events/amd/ibs.c
+++ b/arch/x86/events/amd/ibs.c
@@ -663,8 +663,15 @@ static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
 out:
 	if (throttle)
 		perf_ibs_stop(event, 0);
-	else
-		perf_ibs_enable_event(perf_ibs, hwc, period >> 4);
+	else {
+		period >>= 4;
+
+		if ((ibs_caps & IBS_CAPS_RDWROPCNT) &&
+		    (*config & IBS_OP_CNT_CTL))
+			period |= *config & IBS_OP_CUR_CNT_RAND;
+
+		perf_ibs_enable_event(perf_ibs, hwc, period);
+	}
 
 	perf_event_update_userpage(event);
 
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 1392d5e6e8d6..67d94696a1d6 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -259,9 +259,12 @@ struct pebs_lbr {
 #define IBS_FETCH_CNT		0xFFFF0000ULL
 #define IBS_FETCH_MAX_CNT	0x0000FFFFULL
 
-/* ibs op bits/masks */
-/* lower 4 bits of the current count are ignored: */
-#define IBS_OP_CUR_CNT		(0xFFFF0ULL<<32)
+/* ibs op bits/masks
+ * The lower 7 bits of the current count are random bits
+ * preloaded by hardware and ignored in software
+ */
+#define IBS_OP_CUR_CNT		(0xFFF80ULL<<32)
+#define IBS_OP_CUR_CNT_RAND	(0x0007FULL<<32)
 #define IBS_OP_CNT_CTL		(1ULL<<19)
 #define IBS_OP_VAL		(1ULL<<18)
 #define IBS_OP_ENABLE		(1ULL<<17)
-- 
2.23.0

