Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF12B426EF6
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 18:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239651AbhJHQ23 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 12:28:29 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:3066 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240479AbhJHQ2J (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Oct 2021 12:28:09 -0400
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 198BHAot024921;
        Fri, 8 Oct 2021 16:25:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=Vt6MBVIOG73rhYe8ICwoq1u+LQx2Cg0kKmz5vdEm/eA=;
 b=SRfZY/XxiCcKIxdTmGqhWnMpDywkQnD98bAJJSVrnGHV2yO6zkWtgvxsQtNzFKeBBAKT
 LJRDEyc++IXWYU5MzI+jWUJmzF+zoTAEyqECTWcc2NXYQ4pyFFmTxzKcRufr3PjJoF9W
 xyHokocYZxQuOlNu/scnzytSJ2+WtABATf9Nc3OWJJqGE4Wn9yKgfZ8uX0lTIwH2eisp
 rJBM53HCeGSuWtGEQDUOrPMao+TZHSZPLbHj8STVrXMCm/2xvFHOTJ3qO5P2BdOG/fps
 sQZ1IPwPmQfHm4nJvaQUhc9ofVkKfCxwr0y2G6jMO8XgaHMC4aop+cMX+7VOSTNPkiT5 dg== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by mx0a-0064b401.pphosted.com with ESMTP id 3bjdt9ghrt-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Oct 2021 16:25:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=asDOpaOZGXFpEIhOCTCR4LbZ/3t3Bmf4A6bVF0Jm8zhePGu+w5CMslgQvAfnaA6ZBG85cqwrTlpGTu41vGMJARJM4vsWhSScQUXkNui2230dQ2TenzbNTSpyin7kAk7jHPKyWvtZa/G80BMORaEP+p5wQbvAEdAK+/TE7+xLq5N9KxMBoI+ZQjv3ubKhScagypEEOlMbjdrv2Dbeym3DRaFWKWJhi9C12mTY+yYlZ/OPodk4mLzzrlrEB+J5FWu8vbaRgA9JqOT6izQW0TIxLv8T53vdXPS2ezb9XKQNCgoHyhjtpMHXecSg8d0puUJsZr5vjXZ+uSmJkCRTcX/wbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vt6MBVIOG73rhYe8ICwoq1u+LQx2Cg0kKmz5vdEm/eA=;
 b=VNm93DbF4JcxIorpFAH0t7EbjaRJn6V9KXXtIYofNT+TepF+U+aMhbX7t2BDPo4VB6EMgDqAMVKQFbo9xTaDaMCXE1k8c7QlQSAxbhOiwN5IyWePjYmdQiJx3jEKz/tMHGI6XzXr9cO3CF0Rq+/CNDiMJo5EVw+ZUkSTVEX9P5V7lchZybH832dbpsIwEMegVBS8SYI4iW1KSmKhZmm3ntqdQw87FdtwDchl6jxGCvTz1CaaionjHbUqHZ6TCpMce0ZxmJCxOoPMxGCKNiKFsVTH26a74ZYp0v9qmuB+3h+SJ+1pwMcKEqU1TuOB+SUvxKUxZmHiMFzDnx1vm4J+XQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from BN9PR11MB5321.namprd11.prod.outlook.com (2603:10b6:408:136::8)
 by BN0PR11MB5728.namprd11.prod.outlook.com (2603:10b6:408:165::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Fri, 8 Oct
 2021 16:25:54 +0000
Received: from BN9PR11MB5321.namprd11.prod.outlook.com
 ([fe80::98b4:7a11:22a8:3916]) by BN9PR11MB5321.namprd11.prod.outlook.com
 ([fe80::98b4:7a11:22a8:3916%5]) with mapi id 15.20.4587.020; Fri, 8 Oct 2021
 16:25:54 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     piotras@gmail.com, daniel@iogearbox.net,
        johan.almbladh@anyfinetworks.com
Subject: [PATCH 4.14 1/2] bpf: add also cbpf long jump test cases with heavy expansion
Date:   Fri,  8 Oct 2021 19:25:27 +0300
Message-Id: <20211008162528.1233570-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0183.eurprd09.prod.outlook.com
 (2603:10a6:800:120::37) To BN9PR11MB5321.namprd11.prod.outlook.com
 (2603:10b6:408:136::8)
MIME-Version: 1.0
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR09CA0183.eurprd09.prod.outlook.com (2603:10a6:800:120::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15 via Frontend Transport; Fri, 8 Oct 2021 16:25:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f4e7daf0-4dea-457f-2e74-08d98a784d02
X-MS-TrafficTypeDiagnostic: BN0PR11MB5728:
X-Microsoft-Antispam-PRVS: <BN0PR11MB5728A2F1E235AFF8D35006E8FEB29@BN0PR11MB5728.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:102;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p+jvZX/99WDH0wlx/vpsn7YcpcfUivZEjvzaYI3ruXlBPVIvzrvea1OmJQ2DppPN56ol7wnb6LkQlZWqWaxhiAaPVvr5df0/e06wloJFiUM7RieBX4bNIdt0rxNWcAyazOJN/bQE218atPi4MEt3lBSiMcnYwNSnGRBpbUX94WkHS6DwtEogceTJ6esZXqKKy3wfWgcbzoMnEWCEMtzy5/UNg9Fw0tEIbmdFBcCiN8kKX/6B476S6ayhLXbcH/4cmrL2GlnZJONxN4Lrl57dlRs/WouyGAN9QmfqGG77K5yGNga8gVG9QARbYTGkDJBSpCrfFJLta+lzlwqph1YjA4GYT20RQ8eh9MMbxqGSCmJtDFKWtZEjNFccwdwab31H7QI2PSnsGwCdKcMJkandCM22tXPVfZPWTWXa27dpMIQQQhW4yiIvVcCKE9ca+3OE/Xe3apVAYz0j59SXMwpPJ+APPrANf/tnXslVJ1IuVe+bL1yXxn+sAtaZvFmW/mp5wwgJ+0ZdWEuNI+4+7XTqlMsJgAlOtAMSZbFNSvxkI0R9c0XiYxsge+SK3U0lpqp6sXqlfht9dv68F8tA76HGESa7vN3wHG/by1VyLxkARSMyLq3UtypYzI90dqyj6JEr5n4HRwM4tDemKHhKfFBMAfQhA10t4WmY0c+k6waJY0iTXoQMS0PsCs6CO3H9nNBUpAPTx0W7oNGaedkWMZRlag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5321.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(5660300002)(2906002)(316002)(6916009)(6666004)(508600001)(2616005)(186003)(6512007)(26005)(956004)(8676002)(8936002)(52116002)(66476007)(66946007)(66556008)(4326008)(38100700002)(38350700002)(6506007)(6486002)(44832011)(36756003)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5ogY2kfsMYuR0b/LldxiNbMvWMYETYo2SioX+CdbnLZRNRa4soWgCe9Belkh?=
 =?us-ascii?Q?6a9P0+1iSq2nBW3CPPfRIZ3OsIw+m9XFgb9pXElcxXtdswh/b10to+2Mcqwl?=
 =?us-ascii?Q?zave3Xnl7YSl3cWVdGJw9YNv8dyMS6t833KpbBVn58soX/ImkCqlwwBnyn+c?=
 =?us-ascii?Q?2SLgOfZt2V3JC1AlejGg78+BF4WAycJCvQwMPE/ZBLwSp0tDmLMsowX3wg4G?=
 =?us-ascii?Q?m1lZ7ocEKInl9lDiUs/wZq/h+Z7qad0fQuFxq6LDR7APyoqaWMm0h+Cl5Hn1?=
 =?us-ascii?Q?VJy/k9OgwWJz2yz7qxniSNNBIXiRHjJOMptBDetewPhA+I/f8aalI7NTHeKq?=
 =?us-ascii?Q?Nyl47HykkasEqR4y55PeyqJSU3iyUbBzQ8ruh23F0LZTOmarBpebqs57450C?=
 =?us-ascii?Q?y5HchzNQMR2+54hCUrH+j6Q5blTvvBdUmteBz35SlVHVtQI6/0emBEfSMcCs?=
 =?us-ascii?Q?i+Wmpz0a+RJ70z5lA18326yvmOM2ngm1/mJzWOvd0UshEm03xJSwAiu36zqh?=
 =?us-ascii?Q?lv80489to1VLEPJqq6zYsHuYMgM/Y3raeNfw7VwxWaipTU+tqnbZWNe5h/+H?=
 =?us-ascii?Q?P2v7eRlH8LUXFAh8F92vnCjENCEiqsf7wxdMtd2V3HfMRT6tjqJv7jJrmy3h?=
 =?us-ascii?Q?iZT8uE2TYhmeqt9H0ViYX1oKnBUb+EZbA6lfiFhVhv+8weshAEX0rN0TPoRB?=
 =?us-ascii?Q?357W0v18Cm/Sv39dOWW5p01pVdaip6+24ltHyI5xWfjASwuLIvyMsFjB7r/r?=
 =?us-ascii?Q?xeyAlwD/D80clM/I7QJHD1vZ6HLWmwfU20sn7AKg3G0kJVKDnLTIEZRG4Eqn?=
 =?us-ascii?Q?f96tHeyI16znxG6dUTrgm7Z9LkZTLs2WHo8JFdHMI2zWrgp7L/L9c5R/lHYO?=
 =?us-ascii?Q?vSAh0xUlutlfIMgRfa58ojuWtp6Brk/ItMZT5echnzXCQFY/Gc9UA/06ZTr7?=
 =?us-ascii?Q?zMk1MpxjXKsXeqBR+Lyv+0Aiof2DoHwwLsZqKJJvKqQF2gzSPyAnwCbULMRw?=
 =?us-ascii?Q?dIdoNxmDVIaZSu4EySzmudjW5gJOAKDSiwqm/XYSqKk3SQJc3OKvYrhW3swK?=
 =?us-ascii?Q?KOXfnmdeBpxItPaxmdxm8BeS4EJhgaZGsaNO1R/axAHGuhPv5W2CI8+3PZJm?=
 =?us-ascii?Q?LeXpEc6e4IuGDi3Tt0t5WNItpgfjlOrEddENbI390a/4j9gwsuBAhPhZ+b/h?=
 =?us-ascii?Q?Qp3wNMhVOP1JdFeabUctoG5K2S2y9duNmSnpy1dzyGCBVb1LJ11hwNL+hdqp?=
 =?us-ascii?Q?6RlL7UzO0HicosBzGXalYvAH1k5si9SB4pgbX8v5qtNE6Pk054n8RyV0GsHP?=
 =?us-ascii?Q?5Erwo2C//p46dr8EEht06F63?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4e7daf0-4dea-457f-2e74-08d98a784d02
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5321.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2021 16:25:54.4941
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UlDhsbSE6ZT8LxCLizMWmCCuyrSmznWNbQcYOyNaRHyPzVht/fpX8DGNfoiRHnCWEOih3OQwpniwuwfcc5/28E7T94AqyfqkmuMmh+2tWFk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR11MB5728
X-Proofpoint-GUID: TcivN-dJLyv4DIF9CtFDTTIc3F7RzBGK
X-Proofpoint-ORIG-GUID: TcivN-dJLyv4DIF9CtFDTTIc3F7RzBGK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-08_05,2021-10-07_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 mlxlogscore=943 suspectscore=0 adultscore=0 phishscore=0
 lowpriorityscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109230001 definitions=main-2110080093
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit be08815c5d3b25e53cd9b53a4d768d5f3d93ba25 upstream.

We have one triggering on eBPF but lets also add a cBPF example to
make sure we keep tracking them. Also add anther cBPF test running
max number of MSH ops.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 lib/test_bpf.c | 63 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 63 insertions(+)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index 9a8f957ad86e..724674c421ca 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -355,6 +355,52 @@ static int bpf_fill_maxinsns11(struct bpf_test *self)
 	return __bpf_fill_ja(self, BPF_MAXINSNS, 68);
 }
 
+static int bpf_fill_maxinsns12(struct bpf_test *self)
+{
+	unsigned int len = BPF_MAXINSNS;
+	struct sock_filter *insn;
+	int i = 0;
+
+	insn = kmalloc_array(len, sizeof(*insn), GFP_KERNEL);
+	if (!insn)
+		return -ENOMEM;
+
+	insn[0] = __BPF_JUMP(BPF_JMP | BPF_JA, len - 2, 0, 0);
+
+	for (i = 1; i < len - 1; i++)
+		insn[i] = __BPF_STMT(BPF_LDX | BPF_B | BPF_MSH, 0);
+
+	insn[len - 1] = __BPF_STMT(BPF_RET | BPF_K, 0xabababab);
+
+	self->u.ptr.insns = insn;
+	self->u.ptr.len = len;
+
+	return 0;
+}
+
+static int bpf_fill_maxinsns13(struct bpf_test *self)
+{
+	unsigned int len = BPF_MAXINSNS;
+	struct sock_filter *insn;
+	int i = 0;
+
+	insn = kmalloc_array(len, sizeof(*insn), GFP_KERNEL);
+	if (!insn)
+		return -ENOMEM;
+
+	for (i = 0; i < len - 3; i++)
+		insn[i] = __BPF_STMT(BPF_LDX | BPF_B | BPF_MSH, 0);
+
+	insn[len - 3] = __BPF_STMT(BPF_LD | BPF_IMM, 0xabababab);
+	insn[len - 2] = __BPF_STMT(BPF_ALU | BPF_XOR | BPF_X, 0);
+	insn[len - 1] = __BPF_STMT(BPF_RET | BPF_A, 0);
+
+	self->u.ptr.insns = insn;
+	self->u.ptr.len = len;
+
+	return 0;
+}
+
 static int bpf_fill_ja(struct bpf_test *self)
 {
 	/* Hits exactly 11 passes on x86_64 JIT. */
@@ -5437,6 +5483,23 @@ static struct bpf_test tests[] = {
 		.fill_helper = bpf_fill_maxinsns11,
 		.expected_errcode = -ENOTSUPP,
 	},
+	{
+		"BPF_MAXINSNS: jump over MSH",
+		{ },
+		CLASSIC | FLAG_EXPECTED_FAIL,
+		{ 0xfa, 0xfb, 0xfc, 0xfd, },
+		{ { 4, 0xabababab } },
+		.fill_helper = bpf_fill_maxinsns12,
+		.expected_errcode = -EINVAL,
+	},
+	{
+		"BPF_MAXINSNS: exec all MSH",
+		{ },
+		CLASSIC,
+		{ 0xfa, 0xfb, 0xfc, 0xfd, },
+		{ { 4, 0xababab83 } },
+		.fill_helper = bpf_fill_maxinsns13,
+	},
 	{
 		"BPF_MAXINSNS: ld_abs+get_processor_id",
 		{ },
-- 
2.25.1

