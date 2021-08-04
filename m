Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 493AB3E0652
	for <lists+stable@lfdr.de>; Wed,  4 Aug 2021 19:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbhHDRKE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Aug 2021 13:10:04 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:44560 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230161AbhHDRKD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Aug 2021 13:10:03 -0400
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 174FTHdE019136;
        Wed, 4 Aug 2021 17:09:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=t48ay0rRoDSWI6JfuK/AwxpBPT9IKO3iNRr04Ffe4LM=;
 b=aniHV9z7X6rwIxt3k2CHQ1t1dMdDloceyhbDr4PXzd8R7DQIeYLpq8E7dk9JHePq/ve4
 YB4fYdlNi/4Ahag469qpFBSksIZpvlV3sRp5NTj2LJ/acXtmPCgiu2TaIGDzKZtSs+LQ
 vRxy54lugz183Qwf0YXbAMA3lEZwWqjKmR41GvDSEXxWeYlRsru8z/cGhzpiIts624xZ
 1Ke/XSqthxylGCuOD1WXj9UDbfhwu1rxeWztVFZXS4qTP28p8LUz5ZMuFhZr0bdXHhuR
 f33z63LqwbtbLmbI0f9Ppz1e3gOsI8GFTB5ubgW5CQytvHyM30tTIZMTlXWjDWH+7be2 iw== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by mx0a-0064b401.pphosted.com with ESMTP id 3a7uekg62r-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Aug 2021 17:09:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=llNjNlxBX8s6ce+9Ih4GVA/A9t/FJLjz/zjxo4r41E+st9P7qnUPBx0b3Vm94xWEYvFFdaoIEGseo1U4A7fyQxQVjb9WIT4IuVJJ7+K8ItFiDv8VnyYzGrvVA7L48A0x0sotgSOtWGyHIORN0sVFKbykQeKy9SztV9b3AhH7N66ItzsOE7wsbHeSgh1XuRHgCFBKp6itJf0WDvM5QI8n6hFHKkbZsxr1AwZ3qmyeQjl22CzUNfXt8BcnFZhhMiTCVngeNYjEL9yDUV2Z0Jwx+XQ6773fWv+OGI+9RKr4SIgqXH2HDVsxcCi/CriC2NLZjdyXs7qgrFjuMdlyo2dQmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t48ay0rRoDSWI6JfuK/AwxpBPT9IKO3iNRr04Ffe4LM=;
 b=K8iSbJ5UyXwTQzoGjPJp97kNf7ClN+uanmiqj2ajrNhQKf1NMlHG+jVxzBDLOs51yargHuzvc0VyHGO1VRbds+1MfToC8Ny99z74l91+/3HF4wylBkTGgt7M1C/EV1fHX/jvGfaGGmzguHXb+Uyo1gozZUxyvUV+INp711oyI71HJ3yCUvFKZvCzWCb06gimKjePcwpy5oAwVJNaaD9TZZqMfALFMPs9FCoeIH3VfoZFcB963tIQou5B8N6u8hXQTipcKwSCvcXAR+Mltcwjyw1QSDWt+H7KSSp7TzWtRKEMwzOWxp1WOKOKDMEeaTgaNoF9lTRw8KsqBZsG4tqJGg==
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
 2021 17:09:34 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::ccb:2bce:6896:a0c3]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::ccb:2bce:6896:a0c3%7]) with mapi id 15.20.4394.017; Wed, 4 Aug 2021
 17:09:34 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     bpf@vger.kernel.org, daniel@iogearbox.net
Subject: [PATCH 5.10 1/6] selftests/bpf: Add a test for ptr_to_map_value on stack for helper access
Date:   Wed,  4 Aug 2021 20:09:12 +0300
Message-Id: <20210804170917.3842969-2-ovidiu.panait@windriver.com>
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
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1P190CA0033.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:2b::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Wed, 4 Aug 2021 17:09:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd8ebee0-a9b7-4241-0324-08d9576aa1d1
X-MS-TrafficTypeDiagnostic: DM5PR11MB1834:
X-Microsoft-Antispam-PRVS: <DM5PR11MB1834FB02A362917B90753388FEF19@DM5PR11MB1834.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:655;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /3kI7btxTmTgbr8xy45nfQYUM8TwIDO6wTb29NxLTfTD3LRJm5h2s/5jBeW7Ki9uI7xE6dneaTBAiZyIEIFPkaksnqx1c3THHECUkb9mIbIFeTRNksf9qwUmBKf08CKhO5eoTcD0fffYJmfNGSj0CR2Up+/yEv/lupIOjvIobiMPyJFPLmjBmWdaDzUJaFTG0wSJk8wmpHawYjZRLyXbx/GR81tW5Dwkl73h9m8T8gJTYckW6sKrVWeaotG38LLX3vuRa2pFsMnoejKnGB/8nLjuHDnr4qzSKb9PDrd4mX8RBLCX4WZwGcftUpX43JbaJVDFhvlNhTCJSNw8cpq+1cHV1kHzaXjaxJqCx5ZfjdbLsOyaZZxNkDQXMJr6jf1uTcrP/XfnBt3PvItWpFBXTYQ5JYeWr8I0ijAB0SnPn6bD/nMcJozPfrqfNB7HvVb7aM+vYPkrpSwDX3ZIgrICcdffzGHCgRRSb645Q/WbnAyDiVDcpHsRAu31JXduntWABnV1vjLkHDWtQRY9eIkSMgXq1OO60VGK9+n6iTBCWs4M4h2ZBYQ/DAMRy6/fB9vag6qarKtCTTrBzRBeL8dEKp0GJyTgSVgcSMCTREhg+CyB1BHTx6XvvW+gMM++7rRzSmhEEvowjLgvu2dZPYgvyzEZ85yA5kNbAVFAF3KRI0e3U2cjJOR4DwPTzxwjgUpGMlA46WaY3s1Q0j5+j4+STWlXUl/rLc1G0dFkPvI0VPji0E43vZGwoMg/NiumQWvjbfUC711uh3gl8IG28kUt0MWJ+8dMBrX8d8Vx7v4jMRY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(136003)(366004)(396003)(346002)(376002)(6666004)(38100700002)(316002)(6506007)(1076003)(86362001)(38350700002)(52116002)(83380400001)(478600001)(44832011)(2906002)(5660300002)(8936002)(956004)(6486002)(2616005)(4326008)(966005)(6916009)(186003)(36756003)(66556008)(66476007)(8676002)(6512007)(66946007)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wJI0y++l+F9YvN9akKVJUFvOfAvdyCp4o+XYHUGuFkxpdQXlLKdPKZ32ixyH?=
 =?us-ascii?Q?X7yrCHsbwNwipdSV4VnbFHigwTMnfEyzTHRg258GUhrC+DhHlzEU0mX4zxC0?=
 =?us-ascii?Q?bXe8ApZ/CYubPu1zOR2SA/I0u4X3sHNb8JKT2FwbuUU9+oclweBSQ3XHyoCu?=
 =?us-ascii?Q?hCN0bcUNbPBVy06IcbaOTxnUkYLudTm3BwIC9KdkwCjAs0uASFjFPQNA5IMH?=
 =?us-ascii?Q?qQLkcfKe5QNBWkMHOlQuedYrvbhvkfj4gFjNLzU3UMUAZrqleF4pElYMZE1R?=
 =?us-ascii?Q?EEQymQeWCT/28fT2/5RwHCl1o7w7cESq2JlpVI3dUa74brmWJHhtBpMoKtOw?=
 =?us-ascii?Q?hiqYZDVbbgk95D8VxqFYLmiUF1N2arETiNlAKgbXKwTwUe8W7TM2865Hgi+x?=
 =?us-ascii?Q?VlfxwGblZ6aLB45KID2FfLGCqgJtbcDMK4P0A6eliQdJrwVVHPQMf2HJugUU?=
 =?us-ascii?Q?AM6RfWP8MR6zUuayMJ4XcKy4JTKKgio8KBel27na+THfVe3WET1qseEpZxo5?=
 =?us-ascii?Q?+BhCUSpwwzaygL6XniZzQzxZLwr5Pspo/BvUKxADcTZeVznTj0gRpEb6q84v?=
 =?us-ascii?Q?sSHMck3rpEM5NQ3HGBmnd8XaUQ93CZXDjfGVR2UYqnXw6tWhK7V0xZv2dc24?=
 =?us-ascii?Q?PL67yE/SigJLBFQz+gbnkgNVMQBUd6xG3Gjob2p92et8Ry23vJWn9CO1zoPA?=
 =?us-ascii?Q?Ebbb93wyuQC/BrMQe03J5vAwQ/54mEnyZNVucqRj39VDfRTrFc5jmiqNxDL9?=
 =?us-ascii?Q?G2XV8KT4kGycYR61V+m/inNHQNkSgpFWaYd6NQLjAO8Bx4BSjhq7goW2tKcj?=
 =?us-ascii?Q?hvuowzE9kIS5J2PLzJRl1wLBGcW6/lXnkWFtz0NAnhdgUoo6LeoeZ/K2U9Nv?=
 =?us-ascii?Q?2t1RSYzgI1scmM2Y78I01sARjJLSL88ZRk8SaAqtNi+1wmB9np7Tybp57Jrc?=
 =?us-ascii?Q?aw8pVRwCLdHPOVE6SB7BDmKG5/7+sFl91LA+uJiAjzHzemnaoIXM/6bLDb8T?=
 =?us-ascii?Q?2F3mO3c0Z5KQoBDIU1r5yislwxA6ts2skgi2TeCvaxUgYxsLIDh634PBurxI?=
 =?us-ascii?Q?cOHuVB46cR57pyou8cCmWuikTxhNILszWc3Oi61uEG/S7Lwd7bU64XGIsxZy?=
 =?us-ascii?Q?ZuNnAqErGFpY0FrmFMjOabR2Juz7XwI/aPX0mWkmpM2mH7D8GZT6Hl6mDFG1?=
 =?us-ascii?Q?kPrsrzJlEwMgf2NmHrQWArxJ2bF43/wIuHnW2xXBxtCcUcIGMO88+cE3me8R?=
 =?us-ascii?Q?5CRhwqNGoD87jamEDP+rRuEFnvTZMDk4GZGFxSqvwC+Um8Dzgy3dJx1qQiFY?=
 =?us-ascii?Q?KuPMI7J32pwqTLeP++pdGXTy?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd8ebee0-a9b7-4241-0324-08d9576aa1d1
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2021 17:09:34.3790
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4uMPmoVbDlEET+zBf1f/y6IR5kSu+MM/y311WXN2q2klDvatgXrpo8iIJZlqYSi1Xww0YLRilMVTTZ9l4T94MPiHCOjN0JTo8a8Jqx9hplo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1834
X-Proofpoint-GUID: 9zbPOrbmYbrdpAiRMxqg4V0BwO0QUtgj
X-Proofpoint-ORIG-GUID: 9zbPOrbmYbrdpAiRMxqg4V0BwO0QUtgj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-04_05,2021-08-04_03,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 mlxscore=0 adultscore=0 clxscore=1015
 malwarescore=0 phishscore=0 mlxlogscore=999 spamscore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108040098
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yonghong Song <yhs@fb.com>

commit b4b638c36b7e7acd847b9c4b9c80f268e45ea30c upstream

Change bpf_iter_task.c such that pointer to map_value may appear
on the stack for bpf_seq_printf() to access. Without previous
verifier patch, the bpf_iter test will fail.

Signed-off-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Song Liu <songliubraving@fb.com>
Link: https://lore.kernel.org/bpf/20201210013350.943985-1-yhs@fb.com
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 tools/testing/selftests/bpf/progs/bpf_iter_task.c | 3 ++-
 tools/testing/selftests/bpf/verifier/unpriv.c     | 5 +++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_task.c b/tools/testing/selftests/bpf/progs/bpf_iter_task.c
index 4983087852a0..b7f32c160f4e 100644
--- a/tools/testing/selftests/bpf/progs/bpf_iter_task.c
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_task.c
@@ -11,9 +11,10 @@ int dump_task(struct bpf_iter__task *ctx)
 {
 	struct seq_file *seq = ctx->meta->seq;
 	struct task_struct *task = ctx->task;
+	static char info[] = "    === END ===";
 
 	if (task == (void *)0) {
-		BPF_SEQ_PRINTF(seq, "    === END ===\n");
+		BPF_SEQ_PRINTF(seq, "%s\n", info);
 		return 0;
 	}
 
diff --git a/tools/testing/selftests/bpf/verifier/unpriv.c b/tools/testing/selftests/bpf/verifier/unpriv.c
index 0d621c841db1..2df9871b169d 100644
--- a/tools/testing/selftests/bpf/verifier/unpriv.c
+++ b/tools/testing/selftests/bpf/verifier/unpriv.c
@@ -108,8 +108,9 @@
 	BPF_EXIT_INSN(),
 	},
 	.fixup_map_hash_8b = { 3 },
-	.errstr = "invalid indirect read from stack off -8+0 size 8",
-	.result = REJECT,
+	.errstr_unpriv = "invalid indirect read from stack off -8+0 size 8",
+	.result_unpriv = REJECT,
+	.result = ACCEPT,
 },
 {
 	"unpriv: mangle pointer on stack 1",
-- 
2.25.1

