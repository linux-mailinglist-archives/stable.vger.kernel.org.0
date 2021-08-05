Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 784623E18D1
	for <lists+stable@lfdr.de>; Thu,  5 Aug 2021 17:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242656AbhHEPys (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Aug 2021 11:54:48 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:9340 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242533AbhHEPys (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Aug 2021 11:54:48 -0400
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 175Dic6S032453;
        Thu, 5 Aug 2021 08:54:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=FCfqUZsPS2ifpqoupsJ1L+ZnwqAlzS81J8jaVkgiCaw=;
 b=efEdnQ/N26tkwCd/+SU/ILbkilKs2nuynOpTVYOwGrcp+rzeNKmHjC4HVrDROc56FVGw
 gcvwyfVHKxSUf04VbjrlcsQHWgnFeE3twLwBQ46PYE+/h+yMYMkj0pIb4x29KJ++FghR
 YJUI4Ey1IBwtQ7+89BjeBRfhCtSGfrJrK461froM8zBPW+wL6GlNhcD1acR7EpPmvHLr
 TjAq5Vukl28Vc8QGfw25JmOlz2JqEPPOHTmdHkckbvNQCITd0QQWozM8mmuVfTRGjY8m
 27RIZmXmpvPAmKfrF+mIepR2BMTUDHWZG5h1bi3OXX0LGUz13z5LN/4vf5lyy5laPveL KA== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
        by mx0a-0064b401.pphosted.com with ESMTP id 3a7vt6rx0s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Aug 2021 08:54:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MlcLomj9bn2NZGq0CvJy3bVWaNEtFIt0AJRs6/z6GaPT1dsvTdUpGbYyZnYcgJt8eyTMg6aPchb86+sbxpnFGLYXFgldifqIKKzHmXF9qtxM/sqo10ZaRAiuc2YShovba/8LsdH8KXIKd1t8qeQ6/C8HGsflzGctXnmkB3XzNAemaaxKNnr910FOT2kVF2KONBuJVV/XWAPCge2KhMxtGxRty2p/JeSsY2hUJsW76x33okW2knEIw3u+/FpSLjIMndf/EEXwsT1xI+y0b93Q6xd31neslc/fs79O/T/lyTZUG9jfy4Z8O6B9R2Th6TAzOIYc1PkFo1spHYUhNzHNfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FCfqUZsPS2ifpqoupsJ1L+ZnwqAlzS81J8jaVkgiCaw=;
 b=Bd2wHuy8sN9BjDexDQDjPJk/HGnHy5Axt/pA0apsZKeWqgQJcMqyXouRmnZYmm3KcG+q2aJNTw+G4hv2VRSPOSy+z2VFvaUngc7AFxYPDbnr3eKmkSvc5llu5chXshe53iFzWMTUMeam6zHaDRzfEho47G3kTvqJuAJZjOjWMqy/IFPI9fmGbmHMqzr7bcLY5mEXyNEzFfL13HJb5rV6q8OsAY8YGHkAQhKGVxeLMlXhlvU3Trv2V/r8LbeMjK+qJr2kWMQ+ACay0Q8ugRaHcoYZZ/XT7uKbWyJedK77POgvIB0Sx/zcKkoFNSfpZTImUHknZmU180CXvAvmn2ze0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM5PR1101MB2204.namprd11.prod.outlook.com (2603:10b6:4:58::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.18; Thu, 5 Aug
 2021 15:54:11 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::ccb:2bce:6896:a0c3]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::ccb:2bce:6896:a0c3%7]) with mapi id 15.20.4394.017; Thu, 5 Aug 2021
 15:54:11 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     bpf@vger.kernel.org, daniel@iogearbox.net, ast@kernel.org,
        john.fastabend@gmail.com, benedict.schlueter@rub.de,
        piotras@gmail.com
Subject: [PATCH 5.4 5/6] bpf, selftests: Add a verifier test for assigning 32bit reg states to 64bit ones
Date:   Thu,  5 Aug 2021 18:53:42 +0300
Message-Id: <20210805155343.3618696-6-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210805155343.3618696-1-ovidiu.panait@windriver.com>
References: <20210805155343.3618696-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0002.eurprd05.prod.outlook.com
 (2603:10a6:800:92::12) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR0501CA0002.eurprd05.prod.outlook.com (2603:10a6:800:92::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Thu, 5 Aug 2021 15:54:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5a91a253-d64d-4f05-83f9-08d95829441a
X-MS-TrafficTypeDiagnostic: DM5PR1101MB2204:
X-Microsoft-Antispam-PRVS: <DM5PR1101MB220437BFB809DA71BBD507B4FEF29@DM5PR1101MB2204.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:370;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jHeMfmkZEIrvCj6oVXONKu05RixL4Watm4Y5ef9CkeXI+bsI4hqKYdBHQm78k2IhZu6quBmjtPrACRbPOAFZ0f/li+eTB29xh+E4TsMZ8hzQBA8rfKsEbcSxG2Y7jGtFXRKNZoJckCasdb9Ht2nPlou1+Q84h/usMWculfV3TBDeSvVjfPO21P1fvNnEPjn2QcmRWKLM3e6SioxgsVuzaVi57yIIuiv/IIOhF7j5s83epZe7a4MEcZplHtbgcpjYQwzIbSukv+LwbHZE4m98+kWOF0lFEzZZu6kAFPXFCJq0gvhjCwTFrqaUEL6Bx9a0TTBO18w+Ij2jry9/APAAVf4YvaCCU5jyaVmUQDaLvxkfpFXRBLImGUQyM5kblal+Ko2RojFRKmHta5eg2AsutN9Lc1QvCT1UeXQETOOiifKmvENJkI8FWlg8sMNEhivLGDSTKhoCaUa72zd8N5bDHsqvTNh46DBEgVI6UjZgJzhUtySsdOd++jcBi4JrqbFjupDJh+iLsuA4cT+1Po51aDddetNX4WS+l+xXe3Hl4+2l2FIVcR1dNQDa/HRK7yiHYwWBTYRV6HNQARjNjokfJFKnOlwKJXRSDaM3CFCplluPTFQ5be+FJ8UOe2aOvIvq7n91M9VXlax7vCBBP411E3h6h2S9xCalzrw1Bgv4jUUpAGxxX2AYO6EaqizOj7bkliZuo7BEd2LcZDFI2iaLsU8+sbUFHZrG7wTXKnVGj3R9tWuZKHsK0T/EWtEfczg98GvVjeCOWAnnbkMwr6YWIQUQOk2Kol/YOaoyaKpbLJE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39850400004)(346002)(396003)(376002)(366004)(4326008)(2616005)(38350700002)(38100700002)(956004)(6916009)(66946007)(66476007)(6512007)(66556008)(316002)(6666004)(52116002)(86362001)(2906002)(5660300002)(8676002)(26005)(8936002)(83380400001)(186003)(1076003)(6506007)(44832011)(478600001)(36756003)(966005)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?H9rMqBuBvnuuclEBEJ/0jW1FN7oirGRCLEKxU/lJiUl9PcSd8e/WEsc+4fUA?=
 =?us-ascii?Q?L1VOIE2riP8yUiVAj8cuE6MAKY/Awxe7SBGVrAywEbbMt7DRqxLFQVXYg/EW?=
 =?us-ascii?Q?wEfpY/EAIU+funs9XvBpM9dAdK+DFhDMCO+P5IDRJ+3e5PS/yDkDDVhSH+8S?=
 =?us-ascii?Q?n1s+t2HRGJnSUk9v6rKjUaGRVtBvSpCCjH7F1QONBj0rNFDwFj/Rbqz9loR5?=
 =?us-ascii?Q?OF25QvUu6aQAOiFIwztE9FYGCoh+bYWpwjvauwnZQlc99ErZXGuHodrSB9nt?=
 =?us-ascii?Q?vFv0F5FbOIGjRnOW9Y4PykSU0crc1Its4Vzumn/xG6m6hjGmb6BN+cwq6g/g?=
 =?us-ascii?Q?nq6ji2xxvJ6NaNGFg6SnxTzYS+xXwDxRo7964BCGeXrgnULeZbqI7hMX6jCP?=
 =?us-ascii?Q?qfic70M2ph6fZtgrAk6qsQ9tEBMEGPkNcn73hpdbNbbW+cv6p4JDiNwLJYaE?=
 =?us-ascii?Q?uSy/b8QUMIiHJelGfBJfPzqpC4xXbi9wpttaLp2ftGtB2PJso0AXhFFxjawD?=
 =?us-ascii?Q?kShu5P/TdLrXH248QuNxtdCZl7RdF41UZDIxHb8Ov/1OmH7d2gsWSwt2gA+K?=
 =?us-ascii?Q?Wq1hWd63JV3fcRKT+9mYnLC8Gjk9n84W8yyoZqVafUrBZhKkD1qtYoeAFkqv?=
 =?us-ascii?Q?YpnRiDRlONM/Hb+ZYUvmwa+0v9ylTwFf1OQhkR1Z5LTH+IHF3g0QY7emL2qo?=
 =?us-ascii?Q?ug865iOMNUF+aAwSGUupjuRGl3ku794hX/f18rYIi3PgSi0cCpQf8mXZHxs/?=
 =?us-ascii?Q?HF5CGPvzbFaCz66ovfOOXm/kZjRge3uxk8Hnxteb5lrYwacntQz3vtokDn0/?=
 =?us-ascii?Q?sP9+Bfx+lwHOcETWweTtOcQh5YbHU3cefhezEk/mKM2ioSjWhNlsbFsj+tJu?=
 =?us-ascii?Q?XqDnkRV6fjG9HoQR3WBUPWPfQ36HddUiEOStjbKSMzZBtoQvy1t+mEMIwKWt?=
 =?us-ascii?Q?VqlhAolPHffeJrG+jRA6PBFkqjfQVIzz/1smfa1PkeXdauYY+Uf3ZI008ddU?=
 =?us-ascii?Q?DMXiYNtln2OmdG9jnUIEd4QjfgDAnZmdzoeJ4A7LdRWriBkzhI7jGMf/4cND?=
 =?us-ascii?Q?FxrgcON0aAw7MplasfVopdPwzLvDmAk9IjiszJ8khYcx2YyOa9XMOS9622Ub?=
 =?us-ascii?Q?OL1gfPY6JDJcc4X5A3vk9u5FC5zSWOdre41DTRWkYSmpQShJmADUG1divPRd?=
 =?us-ascii?Q?sRPKzzYSJefcmqH7jS25ttlWTrYPiH/rZEPiScRYnPJTJ0H7p5/s0lcVjsMt?=
 =?us-ascii?Q?nK4nyWIeao3v6YNksCM8aYG9wZ2H+Y/bVonDKza6urgaDTe0bnx3cdsX3E+R?=
 =?us-ascii?Q?j+ZTPD1Y5ALFOkRxinuWwn/A?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a91a253-d64d-4f05-83f9-08d95829441a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2021 15:54:11.0481
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /csgaP3uDZC6OPLhqS5KEQgydiIf3UF9fsEuBGt13+kO/m/wHM0HsLzqsaL9GJVYSxIK7vSWSEqIyBFn2AsNennGwR/6rVPt4xX+P3vZbJA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1101MB2204
X-Proofpoint-GUID: ekoyp5-AgOMoS-Efx4LdMKm9L2dphYO3
X-Proofpoint-ORIG-GUID: ekoyp5-AgOMoS-Efx4LdMKm9L2dphYO3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-05_05,2021-08-05_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=727 mlxscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0
 priorityscore=1501 phishscore=0 clxscore=1015 spamscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108050097
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Fastabend <john.fastabend@gmail.com>

commit cf66c29bd7534813d2e1971fab71e25fe87c7e0a upstream

Added a verifier test for assigning 32bit reg states to
64bit where 32bit reg holds a constant value of 0.

Without previous kernel verifier.c fix, the test in
this patch will fail.

Signed-off-by: Yonghong Song <yhs@fb.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/159077335867.6014.2075350327073125374.stgit@john-Precision-5820-Tower
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 tools/testing/selftests/bpf/verifier/bounds.c | 22 +++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/tools/testing/selftests/bpf/verifier/bounds.c b/tools/testing/selftests/bpf/verifier/bounds.c
index d8e5388c9ba7..c42ce135786a 100644
--- a/tools/testing/selftests/bpf/verifier/bounds.c
+++ b/tools/testing/selftests/bpf/verifier/bounds.c
@@ -545,3 +545,25 @@
 	},
 	.result = ACCEPT
 },
+{
+	"assigning 32bit bounds to 64bit for wA = 0, wB = wA",
+	.insns = {
+	BPF_LDX_MEM(BPF_W, BPF_REG_8, BPF_REG_1,
+		    offsetof(struct __sk_buff, data_end)),
+	BPF_LDX_MEM(BPF_W, BPF_REG_7, BPF_REG_1,
+		    offsetof(struct __sk_buff, data)),
+	BPF_MOV32_IMM(BPF_REG_9, 0),
+	BPF_MOV32_REG(BPF_REG_2, BPF_REG_9),
+	BPF_MOV64_REG(BPF_REG_6, BPF_REG_7),
+	BPF_ALU64_REG(BPF_ADD, BPF_REG_6, BPF_REG_2),
+	BPF_MOV64_REG(BPF_REG_3, BPF_REG_6),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_3, 8),
+	BPF_JMP_REG(BPF_JGT, BPF_REG_3, BPF_REG_8, 1),
+	BPF_LDX_MEM(BPF_W, BPF_REG_5, BPF_REG_6, 0),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
+	.result = ACCEPT,
+	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
+},
-- 
2.25.1

