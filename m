Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E13C558D4C6
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 09:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239651AbiHIHkM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 03:40:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232748AbiHIHkL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 03:40:11 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB7AC1EED3
        for <stable@vger.kernel.org>; Tue,  9 Aug 2022 00:40:10 -0700 (PDT)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2796rMfL013562;
        Tue, 9 Aug 2022 00:40:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=wr2TUt5p4hEJIz/FWpdC2VJGxxcGSJcpwikfyKC2cXY=;
 b=hmalEZTqlgMiszzVbi0iF+SzLSt2e68/bHFZBQHketrh/GD0aMUP2aU9EwgGzjsx85z4
 d1m3hYHYBGMIlvZMEJW8hKhhYDUgb+Gop8HBEHvgqOQpsBuafQo4Zg+HE5fxK5STVEB4
 qnVAqsdE/X3BP7fRZ/lB2ieHcXqCfy+x00/WGk6T9BgTN73xwwZpl8+RJg8T0VmLbMZE
 isUtj7cOqa4918mbLNiSDimvYzAVsbkfuqKUrzp7iSaiwyYR0lFN7K55Dyt39t4zgqoW
 8HRItweszH5Q/fPw/a5IoKW3moUBJl7Yrk9b9LVL0ZRyVdra/E7OwxSUpfot3aXUTkyp 4w== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3hskk4j77w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Aug 2022 00:40:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W54uxKoHyjewXVG+KCM3x72FjmAW12xZNFg62/6ydEeqhXwjqcFgWFqo1mnQsFYdqwY/ObL2bUok7f4l8iJtZzYtNRV6IT2CtJkf2ZU3jR1WwF5LIOoPhGYliFoftM3mI4Q9ZRyi9yAFnAqDMuOMLTSl0eMdKBIN2g0N1s5x1oKZUlL6mciMmD4YOTu0lKSmq2siwKwlXay0Y40RyV2Q7c3/L9Lg6LbPaOYBDQoSWhD5ePaxC5jqCKj8ojz9hMAYSWdLwMkarh9Uz7xODJ3q46qAp02V3gv8kPGouR8nVKJ+Z8ufDmNwMFQZwB8eVdLqCdjgifzPmtkpb0ZNPqhUdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wr2TUt5p4hEJIz/FWpdC2VJGxxcGSJcpwikfyKC2cXY=;
 b=gan5CTIITAcXnX0iPXyb2Imocyzl5Dl0FIRYe5bdRtLCAOdt8sWOkzzIHq2j75OiNZqELA1ci8nYE9j0cyFlvXq5BEeqQ9+lcsndFhfFzhcPSdyJU6Ox15qsiS5Zi9Lhheo/tDTkTsTlxKlaS2VnxEZLRvNZblcvqarddokJBCtzInQT/pKR8mBBfLq89kMYshdHtIsSLV4pPiZ3ZyeImgXSlkoo0GcNRC6dw8nJ53AoPZ7CA2iNXeRuPrExlTmjKz+CWfsrHg+bjjjMI1qKm0BEUEH/YwRmMfcuIPwEoBgV9qFMNm63bAEesJBDNt8zoWNkl8UJL28/K7Z5KTbHmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by SN6PR11MB3070.namprd11.prod.outlook.com (2603:10b6:805:d4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Tue, 9 Aug
 2022 07:40:05 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::e500:5c9f:fb41:287b]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::e500:5c9f:fb41:287b%9]) with mapi id 15.20.5504.020; Tue, 9 Aug 2022
 07:40:05 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Maxim Mikityanskiy <maximmi@nvidia.com>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 1/4] selftests/bpf: add selftest part of "bpf: Fix the off-by-two error in range markings"
Date:   Tue,  9 Aug 2022 10:39:44 +0300
Message-Id: <20220809073947.33804-2-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220809073947.33804-1-ovidiu.panait@windriver.com>
References: <20220809073947.33804-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0060.eurprd09.prod.outlook.com
 (2603:10a6:802:28::28) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c1a85c23-a147-4bcf-518e-08da79da605c
X-MS-TrafficTypeDiagnostic: SN6PR11MB3070:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UejbafWY5nSRC2G+vmTSiaDhf9dKFT5XagvxwE0aiEEIcFP0+n6+HMqDLU+RcQ/k1Z2rwmXlcVodSoPawpvD5coI2ZEVDVZBc19eTIhA8Vne24y4kowffPjNwRB317y7Z1SOplV+UAACX04PkmTn5SKpLpw6/2/7ub1npgkf7P/cs5cb1TiL7rk0+3ThAJ2djc9YX6hTsfehb5NdxVYkjpbgVDHeyks5KfeV304WdeZZeJqTJ9x9vOU6JFMyyL9GgtFj26YSZwrNnSlH1wJ9ApuaRkZMqKK0BOybhPobb2uE4kIXtUnlYSumZBKgsndR6TFOxsbhdjUX3E3BaQSYaEuUb0m4GBjQcp4D9RlY6epN9QOhW7rTQXKavgITTmSPqdZ5ki8nnsVIo+jDHZUJ5WIuVFew8wnDCbXJ6qWpAQvXM1ZzjCSSqxEqWAzQCOdF5u5ikR50Y7qP/TIpeKnT7ePo75U3Y9LOBZYydI9FdVchIHLHI57U8bxpK5QurNKRoi44u3WvG5udltzZXSAowwBfZI80P3K96HE8wXnSWaoVMXRY7SGBEQeIfmVI/0wr5s54SeogUbEfqPgCbHPB/BygF+XG9ox+SqARTHz6QZKwLB/lLVCQzRD3kR/V1wg7J5RnHv+vuLpKW4LKpmCm2ze8Bz/ZLpMfvYdJ5WcO9XHdfe05cSnynMwr3lQcnxt6D4+AW1bblomeIPRplZ/N40GCPU7ViY8q7RW5vynv1gVUdDiL59LlA+rLW57W326+aWaczRD4vy7EDXw8U5WPb/qQ08ApgDIujuBCiqqvzohZ/yZcRla5RYToSL/4t0J5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(136003)(366004)(376002)(39850400004)(41300700001)(6666004)(26005)(6512007)(38350700002)(52116002)(38100700002)(186003)(6506007)(2616005)(107886003)(86362001)(1076003)(83380400001)(44832011)(66946007)(66556008)(8676002)(4326008)(66476007)(2906002)(8936002)(54906003)(6916009)(478600001)(5660300002)(36756003)(6486002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uFFdDK9mpqTdjXYBtZ9sSZG115Ox7n3PDkzk11NxHDvHPEc1Sk5gv9gJyoth?=
 =?us-ascii?Q?4jQbo/kmwz/E8faVKl7Rw5U67uS46M7tp1zHsuvnYLLxJwAziqbxIfaY6HhE?=
 =?us-ascii?Q?KsqzBHiKscHU8KeIoZKykG4wKZQ44893jAvjtcBpneQUgp+cKCIJ6WdemUuQ?=
 =?us-ascii?Q?/Bvm+NRPQoqyBTKRep0wEMMsZkVMbsHsTZ+Y+xcNR2pah+oTAYuS9i0gaNhP?=
 =?us-ascii?Q?vTQC5uo+HIQTid2LbH0LgpCxjJgxvsPrvJa8G6LcGiBfgN4kJYDsPobVUma/?=
 =?us-ascii?Q?RpYPGNsPH1ZveYHZVK5RKh4Md7ggr32/WXc85jrNgRv/vCrUudcF39k4kch4?=
 =?us-ascii?Q?ajBCQuuAZzKD2hKgyseflYuUcwUB32GciheyEHK4ug2jk6vZ9HO+3vBxQoWs?=
 =?us-ascii?Q?9ok6Adm+DjBapz9xifWyfLLr8fbQdy1IHg00tpRqSqaYxgcpAvUSrfriCfno?=
 =?us-ascii?Q?+OBSs2dle8S3xrvnwjxiMkuA7XszqSeYoxgo6S3QPu37rSVNJyTdZGyLT59u?=
 =?us-ascii?Q?0qyBTlzjyEXy9/hYbM3/bTTfVeHTl1g070+5UbKs+wlAeItFJ0dgUcHoUDPL?=
 =?us-ascii?Q?dbPlXUu9SXJ13JjPiwXhlMNpEAN00X5frc6reeCCggU7md0bj1UhPnLFBIw2?=
 =?us-ascii?Q?zCQqpab7iCGepfYfyghOd906pegHxTeih1GCp1Vrb2fwoCpsXURlwG72O4jZ?=
 =?us-ascii?Q?30N6cdY/EeWPdLPuyUKXq/f4N+rQ17X7Uj0b11bZ0LbDFuY0jaBB+y6dzEzy?=
 =?us-ascii?Q?iIzQtMYfDPfyz/7t989ZBRYUnIzBjm11QaCyarjhRoiQQnA7T3xiUyFFJCj6?=
 =?us-ascii?Q?9e/sRpYV2gDBBHvNdMHQ3zZKDjaijJcuXzC7MtjwmcRQr6CXwbqZx/zw+Bvj?=
 =?us-ascii?Q?k0XT5zoq2Jxya/3ziZjuAUCYHCiC7AFr9qP7g0TatDCuTfxDCOD6/4c1iUEV?=
 =?us-ascii?Q?51ErAXKPF7HCiqzM5SrTNiKlQEB4SCem8Gfrxv2D1O67rT843nRxNCihr8GU?=
 =?us-ascii?Q?6Tt+uqt5dOHKiUH9NapP2fdjC8N3cgt1iH2aYKz04fO84n5fGWqKc1pnOZht?=
 =?us-ascii?Q?CKbKsO4Cuu25gUKIqhfbL+ShLWm9IIjiO/1VTbIcqgkqzqlGNCXlQwqTcorw?=
 =?us-ascii?Q?e83Z7rJxXimCAClJxBm0xH8K14FSf8IEkLQ1FylVOM58K6VEiYGDlhMidwrn?=
 =?us-ascii?Q?NxyX/hEPq/YiEDKthTKdfGG6PQusSJoF9cI+rING/2yBCOkmUXF0TMhAzkA1?=
 =?us-ascii?Q?hXPywbCmMbEOBcZzSlpvQUSRMxsQqjXdRfPyka8QEPfd00F6KXjyykRL9w2s?=
 =?us-ascii?Q?OcquwmPWmxeB0y8c7CfELic0I+UJj3A4IxYXaogHntZ/Is8OyZB/L16sUXSS?=
 =?us-ascii?Q?DqXU8+IjxhyhA9XRsmbz6ss4CbvX0iQ38shoYlgMRQ/matgQvkHtUgcrKj+R?=
 =?us-ascii?Q?4M5Meg8jgSmiKkkdeqluUUWrXwwJd3tbOf4YD5xq0d+t8CrO/TpsGfjfOXjm?=
 =?us-ascii?Q?Alwl4E8Ag8ZSzxH70Fm+1kZCgLIlGVSSbCcLtGbU7U5UGLkCbLZpTXT0T5wf?=
 =?us-ascii?Q?PcouzSWWIXViLjVDVp/Z4ssf5NPCOylDBdoLsTtH5hm7O8zSDoYFlcx+SNlc?=
 =?us-ascii?Q?tA=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1a85c23-a147-4bcf-518e-08da79da605c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2022 07:40:05.4246
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dyt5dZXzKPqAZJDQS/qOtTgo5k+MTCPxMCUVUaCNm0gqpVh0g3u75r3XfZU3iBuYvAL7hy/tuBmIjowOdxAuz4G5ucsb2AMAFVVadrl/Cvw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3070
X-Proofpoint-GUID: 8s62YPfPsbcBuDHQICr1ipzq2OaOk1jG
X-Proofpoint-ORIG-GUID: 8s62YPfPsbcBuDHQICr1ipzq2OaOk1jG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-09_03,2022-08-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 clxscore=1011 mlxscore=0 spamscore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208090034
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UPPERCASE_50_75 autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

The 4.19 backport of upstream commit 2fa7d94afc1a ("bpf: Fix the off-by-two
error in range markings") did not include the selftest changes, so currently
there are 8 verifier selftests that are failing:
 # root@intel-x86-64:~# ./test_verifier
 ...
 #495/p XDP pkt read, pkt_end > pkt_data', bad access 1 FAIL
 #498/p XDP pkt read, pkt_data' < pkt_end, bad access 1 FAIL
 #504/p XDP pkt read, pkt_data' >= pkt_end, bad access 1 FAIL
 #513/p XDP pkt read, pkt_end <= pkt_data', bad access 1 FAIL
 #519/p XDP pkt read, pkt_data > pkt_meta', bad access 1 FAIL
 #522/p XDP pkt read, pkt_meta' < pkt_data, bad access 1 FAIL
 #528/p XDP pkt read, pkt_meta' >= pkt_data, bad access 1 FAIL
 #537/p XDP pkt read, pkt_data <= pkt_meta', bad access 1 FAIL
 Summary: 924 PASSED, 0 SKIPPED, 8 FAILED

Cherry-pick the selftest changes to fix these.

Fixes: c315bd962528 ("bpf: Fix the off-by-two error in range markings")
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 tools/testing/selftests/bpf/test_verifier.c | 32 ++++++++++-----------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index 858e55143233..9a103bd3542c 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -9108,10 +9108,10 @@ static struct bpf_test tests[] = {
 			BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
 				    offsetof(struct xdp_md, data_end)),
 			BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
-			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 8),
+			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 6),
 			BPF_JMP_REG(BPF_JGT, BPF_REG_3, BPF_REG_1, 1),
 			BPF_JMP_IMM(BPF_JA, 0, 0, 1),
-			BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8),
+			BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -6),
 			BPF_MOV64_IMM(BPF_REG_0, 0),
 			BPF_EXIT_INSN(),
 		},
@@ -9166,10 +9166,10 @@ static struct bpf_test tests[] = {
 			BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
 				    offsetof(struct xdp_md, data_end)),
 			BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
-			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 8),
+			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 6),
 			BPF_JMP_REG(BPF_JLT, BPF_REG_1, BPF_REG_3, 1),
 			BPF_JMP_IMM(BPF_JA, 0, 0, 1),
-			BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8),
+			BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -6),
 			BPF_MOV64_IMM(BPF_REG_0, 0),
 			BPF_EXIT_INSN(),
 		},
@@ -9279,9 +9279,9 @@ static struct bpf_test tests[] = {
 			BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
 				    offsetof(struct xdp_md, data_end)),
 			BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
-			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 8),
+			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 6),
 			BPF_JMP_REG(BPF_JGE, BPF_REG_1, BPF_REG_3, 1),
-			BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8),
+			BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -6),
 			BPF_MOV64_IMM(BPF_REG_0, 0),
 			BPF_EXIT_INSN(),
 		},
@@ -9451,9 +9451,9 @@ static struct bpf_test tests[] = {
 			BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
 				    offsetof(struct xdp_md, data_end)),
 			BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
-			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 8),
+			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 6),
 			BPF_JMP_REG(BPF_JLE, BPF_REG_3, BPF_REG_1, 1),
-			BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8),
+			BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -6),
 			BPF_MOV64_IMM(BPF_REG_0, 0),
 			BPF_EXIT_INSN(),
 		},
@@ -9564,10 +9564,10 @@ static struct bpf_test tests[] = {
 			BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
 				    offsetof(struct xdp_md, data)),
 			BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
-			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 8),
+			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 6),
 			BPF_JMP_REG(BPF_JGT, BPF_REG_3, BPF_REG_1, 1),
 			BPF_JMP_IMM(BPF_JA, 0, 0, 1),
-			BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8),
+			BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -6),
 			BPF_MOV64_IMM(BPF_REG_0, 0),
 			BPF_EXIT_INSN(),
 		},
@@ -9622,10 +9622,10 @@ static struct bpf_test tests[] = {
 			BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
 				    offsetof(struct xdp_md, data)),
 			BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
-			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 8),
+			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 6),
 			BPF_JMP_REG(BPF_JLT, BPF_REG_1, BPF_REG_3, 1),
 			BPF_JMP_IMM(BPF_JA, 0, 0, 1),
-			BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8),
+			BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -6),
 			BPF_MOV64_IMM(BPF_REG_0, 0),
 			BPF_EXIT_INSN(),
 		},
@@ -9735,9 +9735,9 @@ static struct bpf_test tests[] = {
 			BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
 				    offsetof(struct xdp_md, data)),
 			BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
-			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 8),
+			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 6),
 			BPF_JMP_REG(BPF_JGE, BPF_REG_1, BPF_REG_3, 1),
-			BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8),
+			BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -6),
 			BPF_MOV64_IMM(BPF_REG_0, 0),
 			BPF_EXIT_INSN(),
 		},
@@ -9907,9 +9907,9 @@ static struct bpf_test tests[] = {
 			BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
 				    offsetof(struct xdp_md, data)),
 			BPF_MOV64_REG(BPF_REG_1, BPF_REG_2),
-			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 8),
+			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 6),
 			BPF_JMP_REG(BPF_JLE, BPF_REG_3, BPF_REG_1, 1),
-			BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8),
+			BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -6),
 			BPF_MOV64_IMM(BPF_REG_0, 0),
 			BPF_EXIT_INSN(),
 		},
-- 
2.37.1

