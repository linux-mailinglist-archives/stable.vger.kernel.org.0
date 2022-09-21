Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C68BE5BF676
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 08:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbiIUGha (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 02:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiIUGh3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 02:37:29 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2057.outbound.protection.outlook.com [40.107.96.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A1EA804A1;
        Tue, 20 Sep 2022 23:37:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OIBf8qImdUMZUFwFYNCcsIhpR79OPV4kv0O9ITvp7KoKcTjqzH12gtwG0Hk6wQTlbqd96YwmHZxBIXNkWp7MMZaiGjVoHt87g2S22/oHqry1CqkUFqDGExeGzPk4a1SeCQQ3oEIA+zORhQJ4WBmfIJRvEVGELQOV8eHIdE6axPalb9uJJaYDcmbFJ2cW6YRCWWZs/x+njFCTTZvzgvLGcZM8dbGkWP0Wdr81sZdGeyJEsOG/+5T8EEXxF4e4iLt5kQBCP17qfrJo+SLCUmm4jtTO3+/JCLTMWrGSFnZ9v8MV+D6QLKzt+bryR9TtRP8OH127EJj+AWuINYIGJlUDuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OFZUrob1MKW8MJEFnvgdtmTB67esIn0EtMWyk4PUanw=;
 b=cIpaWyTZ7b/y6xzRHJ5o1gjDHO/kW7GfLbUDTF42cwF4wZUjsPSQl9KAWQnjlqwDtVQ11fqFTscEHuyZQTfC4AhCWfJJ6M1olFHAc5dBDqJQdOP9n/STUmHEFow52MR6NNgN+QuGwP/WyEqK0uRv2dSiD+3pqS5o9ChNC88KyGq9Kc1+OHHQ2ci/eheeZ0nb8G7Pk5pMG0NB4Vacr32nHCe/HIEX4UoriqxMrRvBpj9txjHccq/ysiLas7ohrjGW4jlref5MR/gw2frQR6hMJ+G/EvdmDmmN5znpQ8h73EKb4yamn8sjiDIztkIpwPCruSRush5neFL+LY9zhuGoWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OFZUrob1MKW8MJEFnvgdtmTB67esIn0EtMWyk4PUanw=;
 b=VQ9T4tISTzVqR5cVfVTf9hkAX6XHAAURLZ067TRwul8PEhkTVyZ3qqx+gEq5VVp4So3IIcLk3vdSU9YaOa8f1cxRJ2P/ZQnel/q4rgFB3FZ6KPBGUCsGOsgDnXGdmNstHmHh1iw8MC3SU9wSywH85ceBy2Tamd4mheiA7z2WsIE=
Received: from MW4P222CA0015.NAMP222.PROD.OUTLOOK.COM (2603:10b6:303:114::20)
 by DM4PR12MB6039.namprd12.prod.outlook.com (2603:10b6:8:aa::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.21; Wed, 21 Sep
 2022 06:37:25 +0000
Received: from CO1NAM11FT039.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:114:cafe::9b) by MW4P222CA0015.outlook.office365.com
 (2603:10b6:303:114::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.17 via Frontend
 Transport; Wed, 21 Sep 2022 06:37:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT039.mail.protection.outlook.com (10.13.174.110) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5654.14 via Frontend Transport; Wed, 21 Sep 2022 06:37:25 +0000
Received: from BLR5CG134614W.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 21 Sep
 2022 01:36:55 -0500
From:   K Prateek Nayak <kprateek.nayak@amd.com>
To:     <linux-kernel@vger.kernel.org>
CC:     <rafael@kernel.org>, <lenb@kernel.org>,
        <linux-acpi@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <dave.hansen@linux.intel.com>, <bp@alien8.de>,
        <tglx@linutronix.de>, <andi@lisas.de>, <puwen@hygon.cn>,
        <mario.limonciello@amd.com>, <peterz@infradead.org>,
        <rui.zhang@intel.com>, <gpiccoli@igalia.com>,
        <daniel.lezcano@linaro.org>, <ananth.narayan@amd.com>,
        <gautham.shenoy@amd.com>, K Prateek Nayak <kprateek.nayak@amd.com>,
        "Calvin Ong" <calvin.ong@amd.com>, <stable@vger.kernel.org>,
        <regressions@lists.linux.dev>
Subject: [PATCH] ACPI: processor_idle: Skip dummy wait for processors based on the Zen microarchitecture
Date:   Wed, 21 Sep 2022 12:06:38 +0530
Message-ID: <20220921063638.2489-1-kprateek.nayak@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT039:EE_|DM4PR12MB6039:EE_
X-MS-Office365-Filtering-Correlation-Id: f68be7b3-0c33-47da-7ce7-08da9b9bbf19
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: weARpWcvIWSaHbhk/RmyWRZ4YMLP+Ipn+m9Czcpq+0Sr42PDSnZIUf6iX0HSeeqtTKvzg/VbmFz3vzTaW7FCmdym+tx8PE7oJisfSCb0SNYCO4ZSVDPKJCEKGO1mV1tMZpTo7VRabOsy9b0kbTDdUwYdyUUTJAh87r6G/helCSkREfGHxx87bvFnpEFPNcRVKeExuYuwKsvbiDhiOGMzOLsktNO2ct25aZ/Ka1D96cpdNJtNiol+uri1SLdpfjSWIjTyhlvys2OW+qFAhvA/HDClyQ9TDWex3OXJibbhS4V/XGMtczFqOYC7kKBJxNlyq9/1DEWlUen0ouRj9NkO8mYt8rBNdsFoRpYgsLDAdjcsZ0TvV0jRAMA3rAeAWp3ZR0H+S1ups7Gh61jBu/IYi0lpWO0ui8s5ABRsfg1otXs23lyEQj71wAMYwpHzlMNbUAr6iQxUkf/B1v9YVNlktinlGoj7GotCQCsQNFWQoywXmFlzLmG20+BRVlHeJGiJiDcjXOrBMRVr49LSjzid18tyEq6hxFufstGGTjOt1iF1HWaQRPVF56lYSs3vluzyXhcJLiY7sdJ7EAVcXeO6B7CS+5BxKwFN7XgmTMgesjouCdRb5Ay+9WXtPoNwy5lYGtbe3d9meqai0uho2H3Rv3liZOjj9npXed2xSZgjTIHmikTZot6JDaKDtHUhGAsYZR4OX3IiKpX7d2KIWVVbT4OUFoBPIEsGf9UcCLOwF8CBI8eEGyAA8OuMsb42Cs5PJqawppp1Ivn/z1r88TVSF4hzXdY6q3Khmq6xbDaPa1W+en2BAqjWYk6MYxUxmbLYQQto4CT6svEspPf7jsfq4DZqUcY4T1jovEd1BPnYqj938q75OjBOOb0jFROhPrAD
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(136003)(39860400002)(451199015)(46966006)(36840700001)(40470700004)(36860700001)(40460700003)(36756003)(86362001)(40480700001)(81166007)(356005)(8676002)(316002)(82740400003)(6916009)(16526019)(83380400001)(54906003)(2906002)(70206006)(7416002)(5660300002)(8936002)(70586007)(41300700001)(4326008)(426003)(336012)(82310400005)(186003)(1076003)(47076005)(6666004)(2616005)(478600001)(966005)(26005)(7696005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2022 06:37:25.2982
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f68be7b3-0c33-47da-7ce7-08da9b9bbf19
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT039.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6039
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Processors based on the Zen microarchitecture support IOPORT based deeper
C-states. The idle driver reads the acpi_gbl_FADT.xpm_timer_block.address
in the IOPORT based C-state exit path which is claimed to be a
"Dummy wait op" and has been around since ACPI introduction to Linux
dating back to Andy Grover's Mar 14, 2002 posting [1].
The comment above the dummy operation was elaborated by Andreas Mohr back
in 2006 in commit b488f02156d3d ("ACPI: restore comment justifying 'extra'
P_LVLx access") [2] where the commit log claims:
"this dummy read was about: STPCLK# doesn't get asserted in time on
(some) chipsets, which is why we need to have a dummy I/O read to delay
further instruction processing until the CPU is fully stopped."

However, sampling certain workloads with IBS on AMD Zen3 system shows
that a significant amount of time is spent in the dummy op, which
incorrectly gets accounted as C-State residency. A large C-State
residency value can prime the cpuidle governor to recommend a deeper
C-State during the subsequent idle instances, starting a vicious cycle,
leading to performance degradation on workloads that rapidly switch
between busy and idle phases.

One such workload is tbench where a massive performance degradation can
be observed during certain runs. Following are some statistics gathered
by running tbench with 128 clients, on a dual socket (2 x 64C/128T) Zen3
system with the baseline kernel, baseline kernel keeping C2 disabled,
and baseline kernel with this patch applied keeping C2 enabled:

baseline kernel was tip:sched/core at
commit f3dd3f674555 ("sched: Remove the limitation of WF_ON_CPU on
wakelist if wakee cpu is idle")

Kernel        : baseline      baseline + C2 disabled   baseline + patch

Min (MB/s)    : 2215.06       33072.10 (+1393.05%)     33016.10 (+1390.52%)
Max (MB/s)    : 32938.80      34399.10                 34774.50
Median (MB/s) : 32191.80      33476.60                 33805.70
AMean (MB/s)  : 22448.55      33649.27 (+49.89%)       33865.43 (+50.85%)
AMean Stddev  : 17526.70      680.14                   880.72
AMean CoefVar : 78.07%        2.02%                    2.60%

The data shows there are edge cases that can cause massive regressions
in case of tbench. Profiling the bad runs with IBS shows a significant
amount of time being spent in acpi_idle_do_entry method:

Overhead  Command          Shared Object             Symbol
  74.76%  swapper          [kernel.kallsyms]         [k] acpi_idle_do_entry
   0.71%  tbench           [kernel.kallsyms]         [k] update_sd_lb_stats.constprop.0
   0.69%  tbench_srv       [kernel.kallsyms]         [k] update_sd_lb_stats.constprop.0
   0.49%  swapper          [kernel.kallsyms]         [k] psi_group_change
   ...

Annotation of acpi_idle_do_entry method reveals almost all the time in
acpi_idle_do_entry is spent on the port I/O in wait_for_freeze():

  0.14 │      in     (%dx),%al       # <------ First "in" corresponding to inb(cx->address)
  0.51 │      mov    0x144d64d(%rip),%rax
  0.00 │      test   $0x80000000,%eax
       │    ↓ jne    62 	     # <------ Skip if running in guest
  0.00 │      mov    0x19800c3(%rip),%rdx
 99.33 │      in     (%dx),%eax      # <------ Second "in" corresponding to inl(acpi_gbl_FADT.xpm_timer_block.address)
  0.00 │62:   mov    -0x8(%rbp),%r12
  0.00 │      leave
  0.00 │    ← ret

This overhead is reflected in the C2 residency on the test system where
C2 is an IOPORT based C-State. The total C-state residency reported by
"cpupower idle-info" on CPU0 for good and bad case over the 80s tbench
run is as follows (all numbers are in microseconds):

			    Good Run 		Bad Run
			   (Baseline)

POLL: 			       43338		   6231  (-85.62%)
C1 (MWAIT Based): 	    23576156 		 363861  (-98.45%)
C2 (IOPORT Based): 	    10781218 	       77027280  (+614.45%)

The larger residency value in bad case leads to the system recommending
C2 state again for subsequent idle instances. The pattern lasts till the
end of the tbench run. Following is the breakdown of "entry_method"
passed to acpi_idle_do_entry during good run and bad run:

                                        			Good Run    Bad Run
							       (Baseline)

Number of times acpi_idle_do_entry was called:             	6149573     6149050  (-0.01%)
 |-> Number of times entry_method was "ACPI_CSTATE_FFH":        6141494       88144  (-98.56%)
 |-> Number of times entry_method was "ACPI_CSTATE_HALT":             0           0  (+0.00%)
 |-> Number of times entry_method was "ACPI_CSTATE_SYSTEMIO":      8079     6060906  (+74920.49%)

For processors based on the Zen microarchitecture, this dummy wait op is
unnecessary and can be skipped when choosing IOPORT based C-States to
avoid polluting the C-state residency information.

Link: https://git.kernel.org/pub/scm/linux/kernel/git/mpe/linux-fullhistory.git/commit/?id=972c16130d9dc182cedcdd408408d9eacc7d6a2d [1]
Link: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=b488f02156d3deb08f5ad7816d565c370a8cc6f1 [2]

Suggested-by: Calvin Ong <calvin.ong@amd.com>
Cc: stable@vger.kernel.org
Cc: regressions@lists.linux.dev
Signed-off-by: K Prateek Nayak <kprateek.nayak@amd.com>
---
 drivers/acpi/processor_idle.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 16a1663d02d4..18850aa2b79b 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -528,8 +528,11 @@ static int acpi_idle_bm_check(void)
 static void wait_for_freeze(void)
 {
 #ifdef	CONFIG_X86
-	/* No delay is needed if we are in guest */
-	if (boot_cpu_has(X86_FEATURE_HYPERVISOR))
+	/*
+	 * No delay is needed if we are in guest or on a processor
+	 * based on the Zen microarchitecture.
+	 */
+	if (boot_cpu_has(X86_FEATURE_HYPERVISOR) || boot_cpu_has(X86_FEATURE_ZEN))
 		return;
 #endif
 	/* Dummy wait op - must do something useless after P_LVL2 read
-- 
2.25.1

