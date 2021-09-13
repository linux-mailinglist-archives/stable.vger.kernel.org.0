Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B39AC409782
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 17:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243621AbhIMPho (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 11:37:44 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:40912 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242502AbhIMPhh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 11:37:37 -0400
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18DFWGwe016966;
        Mon, 13 Sep 2021 15:36:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=sPjU47ANvl7sP4znSE4Nyj47R6xAfyf2bv05+es4IQM=;
 b=quPv1IkncavUxSlD/EaCf7s2cBMhs8qd1eDhApeA2rnNxtIuNKl5Y1RpysYowYIkumSj
 zlP641xWJvVZvos/z4pnjaCmlfWRlrmv/Epuo+vcvGfA1IzYsKnhhFPGHu5vgndUt6ew
 WlEJlZKLlS8+uSgW8semq3+j6ByL55L1uFSQHjrkCJYPN6NCuKYX/liOZ3KWEMWAk03F
 2qOAcM92i60AxeG1nPJD3OFbpXHgtR6yp8ubKdi3DH2VlBOZaY8U3Tgjr5kEFBClXagq
 Qb1f9xxh2j5AQhGOUVzUn8z7dNYp85QvevcFq9Pc+nz4F/9GgwuB998QcK3j8X2xOv0B vA== 
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2040.outbound.protection.outlook.com [104.47.56.40])
        by mx0a-0064b401.pphosted.com with ESMTP id 3b26m1854b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Sep 2021 15:36:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KEMPvp4qfxUpGRKuz7b1pI8BwE0PqK+kUJ2N4JuNSytrwyqiIR+FRrF+FtRF2kt6KkY83uCxIb305dTGqq5Ml02znW79R4XnSRhoArA3oPT6o+qwUxC5kJpin8Zqi9BCNz4USyWYOTWYZ+rotljWTIfbHCq+dDFLJkfqPNdaBOvnzzcIWZel9Soin2ieYFVFzxhoktkrEPB6CFjxeob/2q56VU9IDdyKaqKs++5Z2k8IzjvpKsqEguZGbfsP5KeY9I3ffez5WwjPsX2QRiEvi30j5PWgaU0Om7IoJxP4Dzxt+GSZR53gTtf1geNV5V+1g5Jl+5XR5ip6NOsGDhl7bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=sPjU47ANvl7sP4znSE4Nyj47R6xAfyf2bv05+es4IQM=;
 b=jIr9z9Ojr6dy4VdNESQHBZ6GsKCpKEaRLnSrYnaLHFEUG1XKUz7+BFJIn42FQ4GBy2eN2KSdzWvAlAh1dHmtfITmXNKfLjehUYnZldOf5ndz4t9djjpeACtN2ym+5GoJjNn+g/bj7ELuHZcboLTfNfh0zcaXrSQS0GJlrXqZTXzf0+d9zvFicE0DJG/xRxhQLWT/HoLMtyOCf0j9HLnZpmZqrkOLxTbvsuB39AMC+7BpZsYnqufX7CIuP9VySjgjLCj2KKH8mjkRUFrGoBeqK35CMu8pO3/9TscvQS10DpJuejI4n1hayEDYvQE6jj/00qKA/5r48+G/I16Uul1j9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM5PR1101MB2201.namprd11.prod.outlook.com (2603:10b6:4:51::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.15; Mon, 13 Sep
 2021 15:36:07 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::952a:bdc6:20c3:94cb]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::952a:bdc6:20c3:94cb%7]) with mapi id 15.20.4500.019; Mon, 13 Sep 2021
 15:36:07 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     bpf@vger.kernel.org, daniel@iogearbox.net
Subject: [PATCH 4.19 09/13] selftests/bpf: fix tests due to const spill/fill
Date:   Mon, 13 Sep 2021 18:35:33 +0300
Message-Id: <20210913153537.2162465-10-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210913153537.2162465-1-ovidiu.panait@windriver.com>
References: <20210913153537.2162465-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR10CA0095.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:28::24) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR10CA0095.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:803:28::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 15:36:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9e471de9-06dc-4a81-c2e4-08d976cc342c
X-MS-TrafficTypeDiagnostic: DM5PR1101MB2201:
X-Microsoft-Antispam-PRVS: <DM5PR1101MB2201CE320423834D364A4903FED99@DM5PR1101MB2201.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:227;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aA4zVqZYFPfpFv8dukmntAs8J95RO9w0sVyBFLKvTCS8VBS/UwdKFpom0i+n3QxTThZdsfq4eVVAimvWwBPMVD3WA3ZDK8Imn3wACY6rGKKOAOHCh04XUKe1/y/Byy40+Njpu4cEfrDK2gZ2nsUMeYbMjk9MAOiCi+jhtQ2NlXRkb0t0A+BPb6QV6bsmjL80heX2+hacDeTD/7JyCR9shQ/jMbt1hgW+vCxEr82srW9xV6/eRo9bVz6+uFHVs+yctws1JxRJGYeXQENavpG0PlX4B0XdMTS+GENqtzuaZ6IeIqL4mFyudF5ksmA7q9e2UMVm2jtEyr2ldaI39SXb5cedhT/jh1h2cxKeHXVqsl7D0hP9wl/PYcokV/yiU/gLQ9ybhSGYEuua404B8PbGRegxs3Mpr2ST64Lmm+VxxfxO4WYmnoYNZIjBACg9/Mun9bmStT5MJt9Sn8ychUBQuFKgmPMb3rWJbq02SFAYeEKL6ghtKRCAieM5BVNFl02VhNvI83GVH89y2jOV1E7l2HGwQ7Mnw5QZ7t8SHoi9aQYnaLk+XcXg5O+ndi3k9QM9V5+sUzrE20eeStNJfacOYqvRX9YxEapwfcht3+lIA9/ULbFU766318bKeZILLcm0zAwaQ7jHGdOMChaSm6wpc7KHZ5Y0hxttcBDVCoReEbUPLQHzXwOxzCFMu6AoWoAwZ2t0FfcoRIzzaWY5/Hbcdw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(366004)(39850400004)(376002)(346002)(52116002)(6916009)(316002)(6486002)(38350700002)(6666004)(86362001)(5660300002)(2616005)(4326008)(8936002)(26005)(38100700002)(6512007)(6506007)(956004)(83380400001)(478600001)(1076003)(36756003)(186003)(44832011)(66476007)(2906002)(8676002)(66946007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gNSFJscMZwOqiBPnPh+F50tv0S3oQBVbcttKWbTl2kc1H3tKUjylNpfRnte6?=
 =?us-ascii?Q?6a3earDiIxB/yl33cfb7vknLqo/zEHYZ4ljI6AxPifJYgTzFWUnvtmmMlyFk?=
 =?us-ascii?Q?WRzq5rGzSvtx12gu9BCuWf3304vePwz/+2j8epJokeBGIWab0F1uei74BrIO?=
 =?us-ascii?Q?N3qsfmlxC5Ndmjm24ThT/6Pu2pMsIjdNV1SaLVvY7zvlZeKbIHySI+Oxe3dV?=
 =?us-ascii?Q?sVZ4m+hkh4KSQ4qSYH7XDl/mmX6jiSzAZQMhLgCYKMXl/zfNc9tidPzpNIu1?=
 =?us-ascii?Q?hKM6km+3FKWPceU88fPzV1grofevtxXUZOzhZAppjh8/BdVweI3U3Tl2CAKp?=
 =?us-ascii?Q?YAqXTta6TDKSU2qXnkKXxGCl9ilo8gdv8Rp0TUloAdb9x98+OgwlhO31d//c?=
 =?us-ascii?Q?d8/n50XAnKV1mADzCcJsNSQDEJeb38kBAho8sd0mR/5y8tI42onrIYhPdHVU?=
 =?us-ascii?Q?exvGBKbV2bdkuTn/KxoYnVFZekW5R1v5CBY5KUML7M/q8iGLhGs0B8EaH+NH?=
 =?us-ascii?Q?nx5RHp/VFAciDu79pvVJZIdVYJsWo+M6wia1HrzU26XlhOCFx6UZ/yq0UNJ0?=
 =?us-ascii?Q?6AWuCDnzi/i+XKJbXvLO/QjFtz2anp+ncDDtAhH32tR1p24OD/MwDzkIIoxP?=
 =?us-ascii?Q?Kb5Pjr/UVJeISQHaTMV7RJW+VyNnXztPPlRE7teUeSGFUtxw6QlVMzTh7lth?=
 =?us-ascii?Q?fqYrlZea3wJqZHzm2FCbBwPo4HniL2TsJJYTEXWEiyxxfRrzYVSirnt9bYth?=
 =?us-ascii?Q?w7dG44weG3CLdcW3M3Ot5vjHRYknw0ZUBOQiHYBRsR4A8pK/AXB+QRaAn6Bh?=
 =?us-ascii?Q?ONWmGAh8Pe5YLSYdNb5ovLLZA8Uz8cn4fepb+/fUF3gcbDbMBxcO/0atrifg?=
 =?us-ascii?Q?+VTL6Fl0qWBhYkPH1PeydOboIFGD4khXcZ5MnvlFqE5Vflarhne0R90pPOoX?=
 =?us-ascii?Q?A0VrS3pe2GprPKY3lctGbuYgw/qAgCZlNTA+qOpiyywYI0UjAwgVjmA8kXFe?=
 =?us-ascii?Q?Z7ZtpnlI6B6+gUjx20D8RBQ70AUjkjbf3AnvrVsV5ZhCgEIIAI7xBaAyDxJl?=
 =?us-ascii?Q?L14xLdgdbWwoBOhbUxp2nqI/YXj6+esu0D5dRALU13e1zan0VJJk8HnFTahX?=
 =?us-ascii?Q?zoLVdcsDOHAR2vy6wXOdH/JNyqyzXsEBy7sCYeH9Y5p85CI4KWozY1ekxsUE?=
 =?us-ascii?Q?Y11x4JuXGcmhK1oIWmA7j+Ii9X7o3hzHpt7KzcdVpfa0l8eQEH0gMV6lbUca?=
 =?us-ascii?Q?9qDmjjOBzmPahpsul3GiavqYO2X4RzUQ0PluOA+7TjwuMocmgxLURU07Qk0W?=
 =?us-ascii?Q?GXm4/BAauf6jHy9hK0oYVsR9?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e471de9-06dc-4a81-c2e4-08d976cc342c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 15:36:07.1734
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PT5VuN4lFSvJ9IbXu7vMJYYegr3/VCLYGMdNU8QzelRaRFuj7awwz+bWFaIcEGWvkmCEx8kz/9OIglDlVNLVE5GPDqSc4VK7SSphcz7KWc4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1101MB2201
X-Proofpoint-GUID: lgX_8f0NqrfQfO1sz3eGcJgXW5X7tZLB
X-Proofpoint-ORIG-GUID: lgX_8f0NqrfQfO1sz3eGcJgXW5X7tZLB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-13_07,2021-09-09_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 adultscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 bulkscore=0 spamscore=0 clxscore=1015 mlxlogscore=667
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109130103
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

commit fc559a70d57c6ee5443f7a750858503e94cdc941 upstream.

fix tests that incorrectly assumed that the verifier
cannot track constants through stack.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
[OP: backport to 4.19]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 tools/testing/selftests/bpf/test_verifier.c | 31 +++++++++++----------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index 1ded69b9fd77..858e55143233 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -3888,7 +3888,8 @@ static struct bpf_test tests[] = {
 				    offsetof(struct __sk_buff, data)),
 			BPF_LDX_MEM(BPF_W, BPF_REG_3, BPF_REG_1,
 				    offsetof(struct __sk_buff, data_end)),
-			BPF_MOV64_IMM(BPF_REG_0, 0xffffffff),
+			BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct __sk_buff, mark)),
 			BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_0, -8),
 			BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_10, -8),
 			BPF_ALU64_IMM(BPF_AND, BPF_REG_0, 0xffff),
@@ -6560,9 +6561,9 @@ static struct bpf_test tests[] = {
 	{
 		"helper access to variable memory: stack, bitwise AND, zero included",
 		.insns = {
+			BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_1, 8),
 			BPF_MOV64_REG(BPF_REG_1, BPF_REG_10),
 			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, -64),
-			BPF_MOV64_IMM(BPF_REG_2, 16),
 			BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_2, -128),
 			BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_1, -128),
 			BPF_ALU64_IMM(BPF_AND, BPF_REG_2, 64),
@@ -6577,9 +6578,9 @@ static struct bpf_test tests[] = {
 	{
 		"helper access to variable memory: stack, bitwise AND + JMP, wrong max",
 		.insns = {
+			BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_1, 8),
 			BPF_MOV64_REG(BPF_REG_1, BPF_REG_10),
 			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, -64),
-			BPF_MOV64_IMM(BPF_REG_2, 16),
 			BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_2, -128),
 			BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_1, -128),
 			BPF_ALU64_IMM(BPF_AND, BPF_REG_2, 65),
@@ -6653,9 +6654,9 @@ static struct bpf_test tests[] = {
 	{
 		"helper access to variable memory: stack, JMP, bounds + offset",
 		.insns = {
+			BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_1, 8),
 			BPF_MOV64_REG(BPF_REG_1, BPF_REG_10),
 			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, -64),
-			BPF_MOV64_IMM(BPF_REG_2, 16),
 			BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_2, -128),
 			BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_1, -128),
 			BPF_JMP_IMM(BPF_JGT, BPF_REG_2, 64, 5),
@@ -6674,9 +6675,9 @@ static struct bpf_test tests[] = {
 	{
 		"helper access to variable memory: stack, JMP, wrong max",
 		.insns = {
+			BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_1, 8),
 			BPF_MOV64_REG(BPF_REG_1, BPF_REG_10),
 			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, -64),
-			BPF_MOV64_IMM(BPF_REG_2, 16),
 			BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_2, -128),
 			BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_1, -128),
 			BPF_JMP_IMM(BPF_JGT, BPF_REG_2, 65, 4),
@@ -6694,9 +6695,9 @@ static struct bpf_test tests[] = {
 	{
 		"helper access to variable memory: stack, JMP, no max check",
 		.insns = {
+			BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_1, 8),
 			BPF_MOV64_REG(BPF_REG_1, BPF_REG_10),
 			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, -64),
-			BPF_MOV64_IMM(BPF_REG_2, 16),
 			BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_2, -128),
 			BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_1, -128),
 			BPF_MOV64_IMM(BPF_REG_4, 0),
@@ -6714,9 +6715,9 @@ static struct bpf_test tests[] = {
 	{
 		"helper access to variable memory: stack, JMP, no min check",
 		.insns = {
+			BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_1, 8),
 			BPF_MOV64_REG(BPF_REG_1, BPF_REG_10),
 			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, -64),
-			BPF_MOV64_IMM(BPF_REG_2, 16),
 			BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_2, -128),
 			BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_1, -128),
 			BPF_JMP_IMM(BPF_JGT, BPF_REG_2, 64, 3),
@@ -6732,9 +6733,9 @@ static struct bpf_test tests[] = {
 	{
 		"helper access to variable memory: stack, JMP (signed), no min check",
 		.insns = {
+			BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_1, 8),
 			BPF_MOV64_REG(BPF_REG_1, BPF_REG_10),
 			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, -64),
-			BPF_MOV64_IMM(BPF_REG_2, 16),
 			BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_2, -128),
 			BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_1, -128),
 			BPF_JMP_IMM(BPF_JSGT, BPF_REG_2, 64, 3),
@@ -6776,6 +6777,7 @@ static struct bpf_test tests[] = {
 	{
 		"helper access to variable memory: map, JMP, wrong max",
 		.insns = {
+			BPF_LDX_MEM(BPF_DW, BPF_REG_6, BPF_REG_1, 8),
 			BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
 			BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
 			BPF_ST_MEM(BPF_DW, BPF_REG_2, 0, 0),
@@ -6783,7 +6785,7 @@ static struct bpf_test tests[] = {
 			BPF_EMIT_CALL(BPF_FUNC_map_lookup_elem),
 			BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 10),
 			BPF_MOV64_REG(BPF_REG_1, BPF_REG_0),
-			BPF_MOV64_IMM(BPF_REG_2, sizeof(struct test_val)),
+			BPF_MOV64_REG(BPF_REG_2, BPF_REG_6),
 			BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_2, -128),
 			BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_10, -128),
 			BPF_JMP_IMM(BPF_JSGT, BPF_REG_2,
@@ -6795,7 +6797,7 @@ static struct bpf_test tests[] = {
 			BPF_MOV64_IMM(BPF_REG_0, 0),
 			BPF_EXIT_INSN(),
 		},
-		.fixup_map2 = { 3 },
+		.fixup_map2 = { 4 },
 		.errstr = "invalid access to map value, value_size=48 off=0 size=49",
 		.result = REJECT,
 		.prog_type = BPF_PROG_TYPE_TRACEPOINT,
@@ -6830,6 +6832,7 @@ static struct bpf_test tests[] = {
 	{
 		"helper access to variable memory: map adjusted, JMP, wrong max",
 		.insns = {
+			BPF_LDX_MEM(BPF_DW, BPF_REG_6, BPF_REG_1, 8),
 			BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
 			BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
 			BPF_ST_MEM(BPF_DW, BPF_REG_2, 0, 0),
@@ -6838,7 +6841,7 @@ static struct bpf_test tests[] = {
 			BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 11),
 			BPF_MOV64_REG(BPF_REG_1, BPF_REG_0),
 			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, 20),
-			BPF_MOV64_IMM(BPF_REG_2, sizeof(struct test_val)),
+			BPF_MOV64_REG(BPF_REG_2, BPF_REG_6),
 			BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_2, -128),
 			BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_10, -128),
 			BPF_JMP_IMM(BPF_JSGT, BPF_REG_2,
@@ -6850,7 +6853,7 @@ static struct bpf_test tests[] = {
 			BPF_MOV64_IMM(BPF_REG_0, 0),
 			BPF_EXIT_INSN(),
 		},
-		.fixup_map2 = { 3 },
+		.fixup_map2 = { 4 },
 		.errstr = "R1 min value is outside of the array range",
 		.result = REJECT,
 		.prog_type = BPF_PROG_TYPE_TRACEPOINT,
@@ -6872,8 +6875,8 @@ static struct bpf_test tests[] = {
 	{
 		"helper access to variable memory: size > 0 not allowed on NULL (ARG_PTR_TO_MEM_OR_NULL)",
 		.insns = {
+			BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, 0),
 			BPF_MOV64_IMM(BPF_REG_1, 0),
-			BPF_MOV64_IMM(BPF_REG_2, 1),
 			BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_2, -128),
 			BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_10, -128),
 			BPF_ALU64_IMM(BPF_AND, BPF_REG_2, 64),
@@ -7100,6 +7103,7 @@ static struct bpf_test tests[] = {
 	{
 		"helper access to variable memory: 8 bytes leak",
 		.insns = {
+			BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_1, 8),
 			BPF_MOV64_REG(BPF_REG_1, BPF_REG_10),
 			BPF_ALU64_IMM(BPF_ADD, BPF_REG_1, -64),
 			BPF_MOV64_IMM(BPF_REG_0, 0),
@@ -7110,7 +7114,6 @@ static struct bpf_test tests[] = {
 			BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_0, -24),
 			BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_0, -16),
 			BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_0, -8),
-			BPF_MOV64_IMM(BPF_REG_2, 1),
 			BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_2, -128),
 			BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_10, -128),
 			BPF_ALU64_IMM(BPF_AND, BPF_REG_2, 63),
-- 
2.25.1

