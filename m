Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E00A73E0655
	for <lists+stable@lfdr.de>; Wed,  4 Aug 2021 19:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239760AbhHDRKE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Aug 2021 13:10:04 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:44802 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239784AbhHDRKD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Aug 2021 13:10:03 -0400
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 174GjQ7f019523;
        Wed, 4 Aug 2021 17:09:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=L/0SUfiM0Rayh5+sRs78n2ETdYtwpYP7KbsOvumttEM=;
 b=l/p7KMdIEYr8+dAJP04BpOTDXAkGDzm2bmP1vtWnLq5NY2Cri5TCJ7BLhHl9Ya1+jz5a
 TOq2Vuet76lmIh+swzeVNmb7AF6TXSNeVEaTbtX3FV7NH4ES5ebAidSEvrj2rjK+Ixro
 uOLc5dBsI+ZHrbmALgrmLAve5Gi/ZBGynS7nq9b+usUsVzUalLXQp9fdlv6/mGvfSRsF
 WZLyOyEvnJoqwhSbY+1wRzvb+9lxWXMRnb/8AIBS680MKQ72V/kYW2MO/KdEfHFRPang
 KrDKdUBlE0TTPbIMLUUZ6XvxVX047XQIeBB8tX45BfR6MNR+R599xe/ENdKLE3W9nMqe zw== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by mx0a-0064b401.pphosted.com with ESMTP id 3a7w71834x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Aug 2021 17:09:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ms9MEsfAR2WQopHxRtHTvY6PVZNt1QlWVP7eAUvAKPNQyzdPBFY3XJoeu3dYe+kXdJQ3GDMWHODhBJmktc1ar3qrUrCA2mffWEY9jyny6dOlw63pQ8S7ZaI27FiYB3UOxLGdLvfZORKy0wA1pEN6ndX0I9RQkWqAKovqURTcDxc7M3iDZZwURaMllYcCfcIDNVl3o6+TT7P6b78a+2/hzAcPGCR8e1Tn1LF6/DnpeAeyn8FmtEsyKOrcqfMxJpXKPSSQwMvgOxTdAkVtvobKqVOPFd5PB/rgn+hzqqa588gA72cIYjG+ix1N/Q0tkZH1tsA87/tl9YdP4887oTKavQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L/0SUfiM0Rayh5+sRs78n2ETdYtwpYP7KbsOvumttEM=;
 b=EwPkEOwkzn7NYEVbWH8s84ZqV2RVQv+acWOP/D71MBx+Gk+AMh6ouDUWDqICwiJWrLgwq6ecWqPWnljLkIVzhCXHFTbh1/NTD7yp3vufUETC8PJCVBVZGYLRD75CAxZ1leoDD66D5z2fzMF47MQPFgDQ/B5qVvOkhBjtbOXnDhF7MeJQ3DZZ5W9zGKDuVCy5x9bq9s1BdhyH4XQB7ePxxMolevSH0U/zUZJmx4qSe8BLujt6xN0YEOvNwfC4jc6kS/Ha14fS5Lu2IhFJVVEgXzIRXf4eK/HwKTENz5zpkP54PLzVeRP6VpbzLe9vrfRFi55ksdeBrDvYeZnORBXxqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM5PR11MB1834.namprd11.prod.outlook.com (2603:10b6:3:113::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.25; Wed, 4 Aug
 2021 17:09:36 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::ccb:2bce:6896:a0c3]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::ccb:2bce:6896:a0c3%7]) with mapi id 15.20.4394.017; Wed, 4 Aug 2021
 17:09:36 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     bpf@vger.kernel.org, daniel@iogearbox.net
Subject: [PATCH 5.10 2/6] selftest/bpf: Adjust expected verifier errors
Date:   Wed,  4 Aug 2021 20:09:13 +0300
Message-Id: <20210804170917.3842969-3-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210804170917.3842969-1-ovidiu.panait@windriver.com>
References: <20210804170917.3842969-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P190CA0033.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:2b::46) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1P190CA0033.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:2b::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Wed, 4 Aug 2021 17:09:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 10cab9c5-2394-4e4d-cde1-08d9576aa2c1
X-MS-TrafficTypeDiagnostic: DM5PR11MB1834:
X-Microsoft-Antispam-PRVS: <DM5PR11MB183493CBBBCA775A67938228FEF19@DM5PR11MB1834.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1002;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4cjiUZZp50euhXEODJKCX6wb2wzq6Ads7+guFHlsMezAOgpWMJRtaGdDcyVanA2EHDt4CARq3CvWHtB86tLiZp1w2e1B5WcAts+lOD8AmSQnVvpa8HcstYh7n5c8FkDXiYWVrLkfXf58vMq0bvdekEZN0Uu31AXBjjA+jlS3SC13J5eYFDWFSruYT0F8cAPshMN4Bff6kR1n7dwsS3DvGIHuSthoGmi1rYZ/iet9yHURbeERCHly+aWMslTfEY9QuN1SWSLrapcT8+VJI2lwwCi0ZOVPr/Tse85WDjGUgFPaZ0DhNbEEtPLBxsjo6+wxLDElNo4q5jYAIWybPH9nshLPcdXqd1owXQLV27BgTzw/IQ28Fhn6Bq10VeWu7tENGhuZ+Skav6K3BEIaiiBYCiPfPgrLhcT0rNcgmUiQYlHHO7nm7yPgFaOavyCmWl8vs7EmQ1ZKkT+YuyCcNdF0J5300l1Tvfoy7Y1ro249krwgRRuY1HlxLyWA2IXBfx9bkvK6Sz7V/hXhlKP/EFcj6jC104iq9krC0BBGw4XOgQ/yB70wIiITHdtoltsCg2rLHmyceRDVAtkBH8cawzAOgaSMcUUhzC3XpEjQi3pSExH0iFLrrq2fCzJb3jPTsHPxfYAc2uMVLan+B0g4FJQoGYV1d3yUXZ9mwV+GHNdowrxhvS1XJSIMuhrPJCI3ogbiyuH0S0ejmSxmwPyGjdI5xtuORZ9RXPKeULAJEYDPxhlLN2eobpJh5B4blDn3qXqvDJ2dvgtYCkHsKz7207hT50NFmHxqot6Q6tzbhNA9YZw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(136003)(366004)(396003)(346002)(376002)(6666004)(38100700002)(316002)(6506007)(1076003)(86362001)(38350700002)(52116002)(83380400001)(478600001)(30864003)(44832011)(2906002)(5660300002)(8936002)(956004)(6486002)(2616005)(4326008)(966005)(6916009)(186003)(36756003)(66556008)(66476007)(8676002)(6512007)(66946007)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KRp0DCUhjRfxfksYTqOrEu+RjXBy/lxmEyMLQ8y1kc5HKvyUPg81Qo8QigxU?=
 =?us-ascii?Q?yJRZhFKUbDqXhvPQsfbjtA3BcO6JWY7ksEoGLgWpCiuzat4tUyfoxWEf/4pR?=
 =?us-ascii?Q?hRYZue5OlL8YH39rebAoRMgpbU07jdE+Clo0XllncXl4mrM2k9ocdc+6G9vL?=
 =?us-ascii?Q?nfOTIGNJpErO1vL5KEEu619FonM+JO8RdABF/xr6pZ0evOmFZ8Xpv1+nAJmu?=
 =?us-ascii?Q?hmxTOG2bKnEodunOXFDCOCMWXPSqSCsbWMv816bGS9LJEvKT4IUMlgP16eNJ?=
 =?us-ascii?Q?CrRAOlYgmECp6A9k63cAkrollXIFByVcMqP3/IEDUT2bquSANXb+vi+v08DO?=
 =?us-ascii?Q?KT8x3UEfILP96XUHivdnOHO+hNtpjySCPGe0XJQ3YxP95ShWtspa1/dpbTzv?=
 =?us-ascii?Q?x7GSvso/JCqR2DPm0QlPqsJKDxagXZQIKEqXjuYygl5re/qgPttJkTmLyOk9?=
 =?us-ascii?Q?3aYXg1aJbeOnymJ4V8HOPXtYiT8ZsiZkviy/lmaV2bCrMcJtuRV8QybcDIpA?=
 =?us-ascii?Q?MDaC44b//c99TnVSCUETgCeDQCdz6T2cefNYVnCsHNSv8bD0YEutMPLPK9oY?=
 =?us-ascii?Q?ApHj3v6K8xPh9QVAT2WA7xo19xXmuWb88pczs0rELljL3zeRhb8vKTo9gpk2?=
 =?us-ascii?Q?/jwCyz4JGLXVvyy1BLWnqwnOhllDWGEQrebWOITeswSPC0MPRIf0+UbJeHXx?=
 =?us-ascii?Q?2PL4hk5OzAdYFvV1AQb0ZWCeFClk5w4V/V04PctK34bZHKct+Ect/Tp3ygjT?=
 =?us-ascii?Q?jTeuQddtwle6TqMOvTwb1+epU/nMeFURk9HNyjjNjT7+9jlNFrGJ0zfncitZ?=
 =?us-ascii?Q?qkr8fcrtDPLsJehTOZ5ZDQRCMJCfe0GMGgWPc2SNrpW3oZBwONhKjUKOSZE4?=
 =?us-ascii?Q?Xlif1mOY4BJmBTRuzjmKjwV6pBI5vxJiFXtGhiPG/qPXvy7OHLOgWmZCtRt9?=
 =?us-ascii?Q?xe8utEsc2enFckyF+HXsl0i+OBcxnZlnTuC28jQiVkFX59dYU0aJezY6xKO5?=
 =?us-ascii?Q?HzYMKnhFEdk+Baxygr0X4w+uVQjGhjznwHOU+Q7nOATaHTUxO7VU1YRtQAn2?=
 =?us-ascii?Q?J3Ai5j6fS1nwSVYTUTnBCpJr4uEoMkaWel7A74PV0m93XpUkhmqLDMLt79WA?=
 =?us-ascii?Q?jbB/OEGpDoXs5MaMAqqTHJrhmroHWzK+5MsQQ/ZWW074NXJb3brgGcCksu3W?=
 =?us-ascii?Q?UzfJIZHOZlky1xsq1JSDaJXkm446YCbw6P6FbgWSclWXUh/9gSVDAijoeYJ3?=
 =?us-ascii?Q?Vq8lQ1AgbJ5xfxtyd8z2BBCTxf/qOZn5+49MyJmlFxeX0K5m5I6JLNbP4C2c?=
 =?us-ascii?Q?sZVWPkRBDM42IZZoXdCUq3hB?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10cab9c5-2394-4e4d-cde1-08d9576aa2c1
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2021 17:09:36.0018
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FMBNxqC/MbhnCoTPzsxC5g9xhEuLtRxUOG/PueBvWhjYhAJMGXOZTLN8+eIYg9kiupAHtB7rKPlp4vjHu1vF39rb+zAbzCPRTp2UqhNGn3s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1834
X-Proofpoint-ORIG-GUID: GU-GREhRcBZLNuUyJih-WCzVyJMGF5Cb
X-Proofpoint-GUID: GU-GREhRcBZLNuUyJih-WCzVyJMGF5Cb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-04_05,2021-08-04_03,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 impostorscore=0 spamscore=0 mlxlogscore=999 suspectscore=0 clxscore=1015
 mlxscore=0 malwarescore=0 adultscore=0 priorityscore=1501 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108040098
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrei Matei <andreimatei1@gmail.com>

commit a680cb3d8e3f4f84205720b90c926579d04eedb6 upstream

The verifier errors around stack accesses have changed slightly in the
previous commit (generally for the better).

Signed-off-by: Andrei Matei <andreimatei1@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20210207011027.676572-3-andreimatei1@gmail.com
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 .../selftests/bpf/verifier/basic_stack.c      |  2 +-
 tools/testing/selftests/bpf/verifier/calls.c  |  4 ++--
 .../testing/selftests/bpf/verifier/const_or.c |  4 ++--
 .../bpf/verifier/helper_access_var_len.c      | 12 +++++-----
 .../testing/selftests/bpf/verifier/int_ptr.c  |  6 ++---
 .../selftests/bpf/verifier/raw_stack.c        | 10 ++++-----
 .../selftests/bpf/verifier/stack_ptr.c        | 22 +++++++++++--------
 tools/testing/selftests/bpf/verifier/unpriv.c |  2 +-
 .../testing/selftests/bpf/verifier/var_off.c  | 16 +++++++-------
 9 files changed, 41 insertions(+), 37 deletions(-)

diff --git a/tools/testing/selftests/bpf/verifier/basic_stack.c b/tools/testing/selftests/bpf/verifier/basic_stack.c
index b56f8117c09d..f995777dddb3 100644
--- a/tools/testing/selftests/bpf/verifier/basic_stack.c
+++ b/tools/testing/selftests/bpf/verifier/basic_stack.c
@@ -4,7 +4,7 @@
 	BPF_ST_MEM(BPF_DW, BPF_REG_10, 8, 0),
 	BPF_EXIT_INSN(),
 	},
-	.errstr = "invalid stack",
+	.errstr = "invalid write to stack",
 	.result = REJECT,
 },
 {
diff --git a/tools/testing/selftests/bpf/verifier/calls.c b/tools/testing/selftests/bpf/verifier/calls.c
index c4f5d909e58a..eb888c8479c3 100644
--- a/tools/testing/selftests/bpf/verifier/calls.c
+++ b/tools/testing/selftests/bpf/verifier/calls.c
@@ -1228,7 +1228,7 @@
 	.prog_type = BPF_PROG_TYPE_XDP,
 	.fixup_map_hash_8b = { 23 },
 	.result = REJECT,
-	.errstr = "invalid read from stack off -16+0 size 8",
+	.errstr = "invalid read from stack R7 off=-16 size=8",
 },
 {
 	"calls: two calls that receive map_value via arg=ptr_stack_of_caller. test1",
@@ -1958,7 +1958,7 @@
 	BPF_EXIT_INSN(),
 	},
 	.fixup_map_hash_48b = { 6 },
-	.errstr = "invalid indirect read from stack off -8+0 size 8",
+	.errstr = "invalid indirect read from stack R2 off -8+0 size 8",
 	.result = REJECT,
 	.prog_type = BPF_PROG_TYPE_XDP,
 },
diff --git a/tools/testing/selftests/bpf/verifier/const_or.c b/tools/testing/selftests/bpf/verifier/const_or.c
index 6c214c58e8d4..0719b0ddec04 100644
--- a/tools/testing/selftests/bpf/verifier/const_or.c
+++ b/tools/testing/selftests/bpf/verifier/const_or.c
@@ -23,7 +23,7 @@
 	BPF_EMIT_CALL(BPF_FUNC_probe_read_kernel),
 	BPF_EXIT_INSN(),
 	},
-	.errstr = "invalid stack type R1 off=-48 access_size=58",
+	.errstr = "invalid indirect access to stack R1 off=-48 size=58",
 	.result = REJECT,
 	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
 },
@@ -54,7 +54,7 @@
 	BPF_EMIT_CALL(BPF_FUNC_probe_read_kernel),
 	BPF_EXIT_INSN(),
 	},
-	.errstr = "invalid stack type R1 off=-48 access_size=58",
+	.errstr = "invalid indirect access to stack R1 off=-48 size=58",
 	.result = REJECT,
 	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
 },
diff --git a/tools/testing/selftests/bpf/verifier/helper_access_var_len.c b/tools/testing/selftests/bpf/verifier/helper_access_var_len.c
index 87c4e7900083..0ab7f1dfc97a 100644
--- a/tools/testing/selftests/bpf/verifier/helper_access_var_len.c
+++ b/tools/testing/selftests/bpf/verifier/helper_access_var_len.c
@@ -39,7 +39,7 @@
 	BPF_EMIT_CALL(BPF_FUNC_probe_read_kernel),
 	BPF_EXIT_INSN(),
 	},
-	.errstr = "invalid indirect read from stack off -64+0 size 64",
+	.errstr = "invalid indirect read from stack R1 off -64+0 size 64",
 	.result = REJECT,
 	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
 },
@@ -59,7 +59,7 @@
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
-	.errstr = "invalid stack type R1 off=-64 access_size=65",
+	.errstr = "invalid indirect access to stack R1 off=-64 size=65",
 	.result = REJECT,
 	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
 },
@@ -136,7 +136,7 @@
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
-	.errstr = "invalid stack type R1 off=-64 access_size=65",
+	.errstr = "invalid indirect access to stack R1 off=-64 size=65",
 	.result = REJECT,
 	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
 },
@@ -156,7 +156,7 @@
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
-	.errstr = "invalid stack type R1 off=-64 access_size=65",
+	.errstr = "invalid indirect access to stack R1 off=-64 size=65",
 	.result = REJECT,
 	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
 },
@@ -194,7 +194,7 @@
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
-	.errstr = "invalid indirect read from stack off -64+0 size 64",
+	.errstr = "invalid indirect read from stack R1 off -64+0 size 64",
 	.result = REJECT,
 	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
 },
@@ -584,7 +584,7 @@
 	BPF_LDX_MEM(BPF_DW, BPF_REG_1, BPF_REG_10, -16),
 	BPF_EXIT_INSN(),
 	},
-	.errstr = "invalid indirect read from stack off -64+32 size 64",
+	.errstr = "invalid indirect read from stack R1 off -64+32 size 64",
 	.result = REJECT,
 	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
 },
diff --git a/tools/testing/selftests/bpf/verifier/int_ptr.c b/tools/testing/selftests/bpf/verifier/int_ptr.c
index ca3b4729df66..070893fb2900 100644
--- a/tools/testing/selftests/bpf/verifier/int_ptr.c
+++ b/tools/testing/selftests/bpf/verifier/int_ptr.c
@@ -27,7 +27,7 @@
 	},
 	.result = REJECT,
 	.prog_type = BPF_PROG_TYPE_CGROUP_SYSCTL,
-	.errstr = "invalid indirect read from stack off -16+0 size 8",
+	.errstr = "invalid indirect read from stack R4 off -16+0 size 8",
 },
 {
 	"ARG_PTR_TO_LONG half-uninitialized",
@@ -59,7 +59,7 @@
 	},
 	.result = REJECT,
 	.prog_type = BPF_PROG_TYPE_CGROUP_SYSCTL,
-	.errstr = "invalid indirect read from stack off -16+4 size 8",
+	.errstr = "invalid indirect read from stack R4 off -16+4 size 8",
 },
 {
 	"ARG_PTR_TO_LONG misaligned",
@@ -125,7 +125,7 @@
 	},
 	.result = REJECT,
 	.prog_type = BPF_PROG_TYPE_CGROUP_SYSCTL,
-	.errstr = "invalid stack type R4 off=-4 access_size=8",
+	.errstr = "invalid indirect access to stack R4 off=-4 size=8",
 },
 {
 	"ARG_PTR_TO_LONG initialized",
diff --git a/tools/testing/selftests/bpf/verifier/raw_stack.c b/tools/testing/selftests/bpf/verifier/raw_stack.c
index 193d9e87d5a9..cc8e8c3cdc03 100644
--- a/tools/testing/selftests/bpf/verifier/raw_stack.c
+++ b/tools/testing/selftests/bpf/verifier/raw_stack.c
@@ -11,7 +11,7 @@
 	BPF_EXIT_INSN(),
 	},
 	.result = REJECT,
-	.errstr = "invalid read from stack off -8+0 size 8",
+	.errstr = "invalid read from stack R6 off=-8 size=8",
 	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
 },
 {
@@ -59,7 +59,7 @@
 	BPF_EXIT_INSN(),
 	},
 	.result = REJECT,
-	.errstr = "invalid stack type R3",
+	.errstr = "invalid zero-sized read",
 	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
 },
 {
@@ -205,7 +205,7 @@
 	BPF_EXIT_INSN(),
 	},
 	.result = REJECT,
-	.errstr = "invalid stack type R3 off=-513 access_size=8",
+	.errstr = "invalid indirect access to stack R3 off=-513 size=8",
 	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
 },
 {
@@ -221,7 +221,7 @@
 	BPF_EXIT_INSN(),
 	},
 	.result = REJECT,
-	.errstr = "invalid stack type R3 off=-1 access_size=8",
+	.errstr = "invalid indirect access to stack R3 off=-1 size=8",
 	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
 },
 {
@@ -285,7 +285,7 @@
 	BPF_EXIT_INSN(),
 	},
 	.result = REJECT,
-	.errstr = "invalid stack type R3 off=-512 access_size=0",
+	.errstr = "invalid zero-sized read",
 	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
 },
 {
diff --git a/tools/testing/selftests/bpf/verifier/stack_ptr.c b/tools/testing/selftests/bpf/verifier/stack_ptr.c
index 8bfeb77c60bd..07eaa04412ae 100644
--- a/tools/testing/selftests/bpf/verifier/stack_ptr.c
+++ b/tools/testing/selftests/bpf/verifier/stack_ptr.c
@@ -44,7 +44,7 @@
 	BPF_EXIT_INSN(),
 	},
 	.result = REJECT,
-	.errstr = "invalid stack off=-79992 size=8",
+	.errstr = "invalid write to stack R1 off=-79992 size=8",
 	.errstr_unpriv = "R1 stack pointer arithmetic goes out of range",
 },
 {
@@ -57,7 +57,7 @@
 	BPF_EXIT_INSN(),
 	},
 	.result = REJECT,
-	.errstr = "invalid stack off=0 size=8",
+	.errstr = "invalid write to stack R1 off=0 size=8",
 },
 {
 	"PTR_TO_STACK check high 1",
@@ -106,7 +106,7 @@
 	BPF_EXIT_INSN(),
 	},
 	.errstr_unpriv = "R1 stack pointer arithmetic goes out of range",
-	.errstr = "invalid stack off=0 size=1",
+	.errstr = "invalid write to stack R1 off=0 size=1",
 	.result = REJECT,
 },
 {
@@ -119,7 +119,8 @@
 	BPF_EXIT_INSN(),
 	},
 	.result = REJECT,
-	.errstr = "invalid stack off",
+	.errstr_unpriv = "R1 stack pointer arithmetic goes out of range",
+	.errstr = "invalid write to stack R1",
 },
 {
 	"PTR_TO_STACK check high 6",
@@ -131,7 +132,8 @@
 	BPF_EXIT_INSN(),
 	},
 	.result = REJECT,
-	.errstr = "invalid stack off",
+	.errstr_unpriv = "R1 stack pointer arithmetic goes out of range",
+	.errstr = "invalid write to stack",
 },
 {
 	"PTR_TO_STACK check high 7",
@@ -183,7 +185,7 @@
 	BPF_EXIT_INSN(),
 	},
 	.errstr_unpriv = "R1 stack pointer arithmetic goes out of range",
-	.errstr = "invalid stack off=-513 size=1",
+	.errstr = "invalid write to stack R1 off=-513 size=1",
 	.result = REJECT,
 },
 {
@@ -208,7 +210,8 @@
 	BPF_EXIT_INSN(),
 	},
 	.result = REJECT,
-	.errstr = "invalid stack off",
+	.errstr_unpriv = "R1 stack pointer arithmetic goes out of range",
+	.errstr = "invalid write to stack",
 },
 {
 	"PTR_TO_STACK check low 6",
@@ -220,7 +223,8 @@
 	BPF_EXIT_INSN(),
 	},
 	.result = REJECT,
-	.errstr = "invalid stack off",
+	.errstr = "invalid write to stack",
+	.errstr_unpriv = "R1 stack pointer arithmetic goes out of range",
 },
 {
 	"PTR_TO_STACK check low 7",
@@ -292,7 +296,7 @@
 	BPF_EXIT_INSN(),
 	},
 	.result_unpriv = REJECT,
-	.errstr_unpriv = "invalid stack off=0 size=1",
+	.errstr_unpriv = "invalid write to stack R1 off=0 size=1",
 	.result = ACCEPT,
 	.retval = 42,
 },
diff --git a/tools/testing/selftests/bpf/verifier/unpriv.c b/tools/testing/selftests/bpf/verifier/unpriv.c
index 2df9871b169d..c30afb09ab6a 100644
--- a/tools/testing/selftests/bpf/verifier/unpriv.c
+++ b/tools/testing/selftests/bpf/verifier/unpriv.c
@@ -108,7 +108,7 @@
 	BPF_EXIT_INSN(),
 	},
 	.fixup_map_hash_8b = { 3 },
-	.errstr_unpriv = "invalid indirect read from stack off -8+0 size 8",
+	.errstr_unpriv = "invalid indirect read from stack R2 off -8+0 size 8",
 	.result_unpriv = REJECT,
 	.result = ACCEPT,
 },
diff --git a/tools/testing/selftests/bpf/verifier/var_off.c b/tools/testing/selftests/bpf/verifier/var_off.c
index 8504ac937809..49b78a1a261b 100644
--- a/tools/testing/selftests/bpf/verifier/var_off.c
+++ b/tools/testing/selftests/bpf/verifier/var_off.c
@@ -18,7 +18,7 @@
 	.prog_type = BPF_PROG_TYPE_LWT_IN,
 },
 {
-	"variable-offset stack access",
+	"variable-offset stack read, priv vs unpriv",
 	.insns = {
 	/* Fill the top 8 bytes of the stack */
 	BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
@@ -63,7 +63,7 @@
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
-	.errstr = "R4 unbounded indirect variable offset stack access",
+	.errstr = "invalid unbounded variable-offset indirect access to stack R4",
 	.result = REJECT,
 	.prog_type = BPF_PROG_TYPE_SOCK_OPS,
 },
@@ -88,7 +88,7 @@
 	BPF_EXIT_INSN(),
 	},
 	.fixup_map_hash_8b = { 5 },
-	.errstr = "R2 max value is outside of stack bound",
+	.errstr = "invalid variable-offset indirect access to stack R2",
 	.result = REJECT,
 	.prog_type = BPF_PROG_TYPE_LWT_IN,
 },
@@ -113,7 +113,7 @@
 	BPF_EXIT_INSN(),
 	},
 	.fixup_map_hash_8b = { 5 },
-	.errstr = "R2 min value is outside of stack bound",
+	.errstr = "invalid variable-offset indirect access to stack R2",
 	.result = REJECT,
 	.prog_type = BPF_PROG_TYPE_LWT_IN,
 },
@@ -138,7 +138,7 @@
 	BPF_EXIT_INSN(),
 	},
 	.fixup_map_hash_8b = { 5 },
-	.errstr = "invalid indirect read from stack var_off",
+	.errstr = "invalid indirect read from stack R2 var_off",
 	.result = REJECT,
 	.prog_type = BPF_PROG_TYPE_LWT_IN,
 },
@@ -163,7 +163,7 @@
 	BPF_EXIT_INSN(),
 	},
 	.fixup_map_hash_8b = { 5 },
-	.errstr = "invalid indirect read from stack var_off",
+	.errstr = "invalid indirect read from stack R2 var_off",
 	.result = REJECT,
 	.prog_type = BPF_PROG_TYPE_LWT_IN,
 },
@@ -189,7 +189,7 @@
 	BPF_EXIT_INSN(),
 	},
 	.fixup_map_hash_8b = { 6 },
-	.errstr_unpriv = "R2 stack pointer arithmetic goes out of range, prohibited for !root",
+	.errstr_unpriv = "R2 variable stack access prohibited for !root",
 	.result_unpriv = REJECT,
 	.result = ACCEPT,
 	.prog_type = BPF_PROG_TYPE_CGROUP_SKB,
@@ -217,7 +217,7 @@
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
-	.errstr = "invalid indirect read from stack var_off",
+	.errstr = "invalid indirect read from stack R4 var_off",
 	.result = REJECT,
 	.prog_type = BPF_PROG_TYPE_SOCK_OPS,
 },
-- 
2.25.1

