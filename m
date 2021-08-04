Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B7EE3E06AC
	for <lists+stable@lfdr.de>; Wed,  4 Aug 2021 19:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbhHDRUb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Aug 2021 13:20:31 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:46896 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229993AbhHDRUa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Aug 2021 13:20:30 -0400
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 174HGmCP012138
        for <stable@vger.kernel.org>; Wed, 4 Aug 2021 10:20:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=CsrQcm/hcFu5bvKMjJxXwduU6EHO3YRIO9TTD3s5b0k=;
 b=CSdpZSse1fC5KvSYPabzxmRruEy50PO97DQw/vFvy6yqoBypQeEPT/ZnM700tTN14VlJ
 tVJQydAfI3Eq/8XuiCVEzds6H8EYJkFXXsda3va6Fv2DbWrwctJD6mHjSLrYofOLPtnz
 B5UMfHOJM3QbjnTLcowrZrO8iXV9FrDwDyxL8vU5J2sDv7F561AbzrzGTNRPlvUn5yVN
 g36V5enz3aUUOxy1k0mT7/ZZUjzNmI5Vj4FA6p2QxdQ4Ae279JiLPI0J/ntCujE6XVxN
 1xu3d5i6DTEB+bLm+DVdwBRtZ7uSiP5Jpm5v8Fabj7x/lC3Id1PHEsHBS+NiofehcaYW SQ== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by mx0a-0064b401.pphosted.com with ESMTP id 3a7vt6r4a6-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Wed, 04 Aug 2021 10:20:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DofM+C5Fzh+I0G16btLHehJEolWDWuwLXVjz8oPRCY5mBY+yzMTFwiN0jjU5i3qXA3ChXmZS4LrPie7KEO2fXB0h0lxFjeLKrmhZeGoJ4VTDW74aiMjEgikhu+Yxm6V2KUDBzmwjzkAEKUIrTPd2D5glEf+71AcnHcGtyewsNzlwI38iYMTeSRRWI7Xxt8j+uche2h3yMCi1LbeeLqV8sW9nTUKZErumBzKsylQZfKyO7GP5u/o9Ef6W3wzjh4ShGj+NsKzFIxRA6En/EYoMJQhDAirDcvx3AvuoGDhbPpkHDyYddm9zLjFl+1AbmQTC07ogacPfpPlFFOhx3buuxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CsrQcm/hcFu5bvKMjJxXwduU6EHO3YRIO9TTD3s5b0k=;
 b=UIOi+qjW/Gr+1cJ0xk4yoxD9u8nuSU+nuaiP1OSxMlS92F5xN9oOYgqvMKgcgOKMarSBhDmU/10VjMhmjA5wND1pYOQAkuijGR9s1veRLSe0DsCLB+FoudQFiBONpiu5FlJp75VmWaajEE4lvgqPzCVYbXyh3Iduudwc0fz7RsWdtd4BAU0xRor1o3Ic5Nv4D3f0YHOs2+AQOl+zBQSX/LSR9y+qB/dO9d5DNW/m6g0aCj18oXQsAuISWXXSB8Wh1ZesL4IeUw03LR7Z6KEp/Fi/RL5p3m9CXkPidPi0oi6UJLml0zRXzyUcrkD4cDCaGrujDCjXlplCTi0jU39h3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB4169.namprd11.prod.outlook.com (2603:10b6:5:19b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.20; Wed, 4 Aug
 2021 17:20:16 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::ccb:2bce:6896:a0c3]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::ccb:2bce:6896:a0c3%7]) with mapi id 15.20.4394.017; Wed, 4 Aug 2021
 17:20:16 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Subject: [PATCH 5.4 1/1] bpf, selftests: Adjust few selftest result_unpriv outcomes
Date:   Wed,  4 Aug 2021 20:20:01 +0300
Message-Id: <20210804172001.3909228-2-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210804172001.3909228-1-ovidiu.panait@windriver.com>
References: <20210804172001.3909228-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0156.eurprd08.prod.outlook.com
 (2603:10a6:800:d5::34) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR08CA0156.eurprd08.prod.outlook.com (2603:10a6:800:d5::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16 via Frontend Transport; Wed, 4 Aug 2021 17:20:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 92f96949-6735-404c-94a9-08d9576c20bd
X-MS-TrafficTypeDiagnostic: DM6PR11MB4169:
X-Microsoft-Antispam-PRVS: <DM6PR11MB4169E1D908A4FE19FAFC4E77FEF19@DM6PR11MB4169.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1mFRVJ2SXLOhr0YuCoIU+yGHoNesFMQn3GfUJrDwsuxvssCIX1cdaCLyxHFeiAUJNyxAw41Xr7E5VVUZ3qyfo1OfDsQQC/DxaB6Flhst4Off7qj3P4iFoPmJ5l+v1rgz2rU0kE8LwYahhTQg4AKjTnuhJuRb3pSBQ6xfcmdrxMxTNzb1NYeo+idK5BpEfDMoSg+VHG9CvZcTF6xapqTp9JUygTGSHXR9gt01ESWhveMbtoojCUfFNn/B6L7eiVlYtRXpsf8YUZRT73cMSEiGgJwzW93aAXRIYTJbkeAzojX9W+GBfdJuIQ/xe7V3g+CEPjZEXdcMo83ZUFVZnYSRsIFYTDcz9fM3+sNaV/ToGK4frbZWYRpE0d+WimnBzwleUHxXLFvFtwqFX8V4lWl6hEouv2wBr+Qc0/nLI57GCN/kan3/B9jnQ3FP5DvUAbq+QphixZkrmGRcYfo+dcL0S64BJy1kK/rQhF8+0VnChDvp+GHdftiNDrmo1l6QaVP09rhjCW4cPctWRHdFt1dENVnx5ntNrUx3s+YudlYkx2kck3/aNzI0VTWWTTl1K4qk+exRKtC5QiK2mBPvciRoUMkxtdqXDILWjVVH6CBnkIuDf6hTV107zDbPD019/zMH4dfr7/37gERWrjsc1gAtVyMM/A7iabVXzSIAkDKW50oYK8pmPRiaNa4f53aITAil8cu4qBTMBhTlZMfxO6DK4Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(2616005)(38350700002)(66556008)(66476007)(44832011)(66946007)(8676002)(38100700002)(52116002)(26005)(36756003)(8936002)(316002)(86362001)(956004)(186003)(6506007)(6512007)(508600001)(6486002)(6916009)(5660300002)(1076003)(6666004)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xCrpProElstm65GMd95uj78irxM87+l4/k484x70QsZDG7UJy30HUFkuldpo?=
 =?us-ascii?Q?wZ7OxSIu83XrStdm/soiEJf21Wwlqya6HSwZYSk7QJDJ2PPSEP8miWDeVkAq?=
 =?us-ascii?Q?c+qn66onJkN1UzyV9DZQqm23HFP0ctiqgGXrJveg7WTfdauWZ063t3JOZg69?=
 =?us-ascii?Q?4DZXftv+VLj8vec5beaa4ZiCFyUgbYObceK4SUE+0W3ptym/H6irEIx/QNpr?=
 =?us-ascii?Q?Rf5dTm802adYw9gCURZbWlimHMTTRJb6r90NIoGqqZYL6+s47dYEufIVWKRv?=
 =?us-ascii?Q?LvrZZPwD0CUNE3JDOfmykWz9bdoEsACLWqNl83gyWzriPo1UYGbkjE2E3YWl?=
 =?us-ascii?Q?gfRYw46JCbti31G75/FdgVZ6zVbnY2Tafqukzq2JKjgLmTeXorm+0Q0lkWz1?=
 =?us-ascii?Q?3Gj/s5p8NBXopJFXcG4pS/WUpDqUZmjUqxjJrquqDqfuWS69ZFHiC5NL8UbK?=
 =?us-ascii?Q?rdOrmCdUb6yWezr8t6ROm42c6wUUboScXR8NnNoy5QYWJ5TNRLnY6oR0bScS?=
 =?us-ascii?Q?6n8aDwizWQBMXsHamFeEyo1ArOKH1AFxktHLRXu3VVM6nBtK3zXZ1F+p2l9T?=
 =?us-ascii?Q?5uGAykssS1GUH0dA48nGzcLQ2RDwcRUeyqyLkFB4tHK7jN5N7YfNb622Oc/Y?=
 =?us-ascii?Q?94ZLI4I6/PNd0vomklE5AzSdUDWwi+UEZIHj0gTSyMICeyeQWb/+Gx5lsAXT?=
 =?us-ascii?Q?hsXJNsx3j7d+jYHwK64td31T2k4AN8bhdKcc2SOPpT3VyY6PSFe8FAziOCgU?=
 =?us-ascii?Q?sFQ9KcCWBBowz3eN0hx1jVNXTBbFYXSsqC5XzSHTfEiwGuYM1cnxz7lA2d5p?=
 =?us-ascii?Q?/Np8dXDwWOkB2G8vzHYsU2Gj0uEk49TQ+yfczGDpOfQNp+4d/pCrpOpdFpM0?=
 =?us-ascii?Q?fo6eanKjXAjeaG9aJxayUVJ4hMMyCVHGyvbkqXvvxxaN4vhFw3Lt79FSDj7W?=
 =?us-ascii?Q?2mBulIMUGNY9GXChLGBQtCGo9VBtVAfk0RKafTHgHwrTEva3CY7fxRJZis04?=
 =?us-ascii?Q?DpbBrIJwYWiGSsBMfNUqDYX3QRqH/aeVsEg9Y4Zsdj3x4V+6fFRCh6rd7wHd?=
 =?us-ascii?Q?LpNGTURn9xbqZDJCAnyBhTKi3mTsPi+p7S9AD5V2thunVjiY21P80LLiIVSf?=
 =?us-ascii?Q?nKEsnLHxlnf51W0C404Zzy48iTPhZFn6PoqmXQM4FxUoiqc7k2kUILPnE2zJ?=
 =?us-ascii?Q?iaA2zA7Khzro8Hk8sLnDZ2QybyqTepuLp+1e/MUO2yUAThCf0I9SI903UHZc?=
 =?us-ascii?Q?iyRrEvHx1rQcHl0APL+A+W0yS/CbZ6w2De5wXbzfDywynRYSlSUo/HmNWKZD?=
 =?us-ascii?Q?c6lyhVjOPe0J0a885rdPHFXA?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92f96949-6735-404c-94a9-08d9576c20bd
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2021 17:20:16.8230
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b1X5FKpjUmcuK5qPQkEndwNKq5wW3evWpj11zfr4u21WdXh1n3PzUgq5ERvS+Wpg3knnCXpeCeIGeq2SHY+S3jxeWEvbpAGuBBP2NePzVwg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4169
X-Proofpoint-GUID: wVK4tjKdS5UNAe0Vo4v8_PmW52_dyJEW
X-Proofpoint-ORIG-GUID: wVK4tjKdS5UNAe0Vo4v8_PmW52_dyJEW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-04_05,2021-08-04_03,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=884 mlxscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0
 priorityscore=1501 phishscore=0 clxscore=1015 spamscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108040099
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

Given we don't need to simulate the speculative domain for registers with
immediates anymore since the verifier uses direct imm-based rewrites instead
of having to mask, we can also lift a few cases that were previously rejected.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Alexei Starovoitov <ast@kernel.org>
[OP: backport to 5.4, small context adjustment in stack_ptr.c]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 tools/testing/selftests/bpf/verifier/stack_ptr.c       | 2 --
 tools/testing/selftests/bpf/verifier/value_ptr_arith.c | 8 --------
 2 files changed, 10 deletions(-)

diff --git a/tools/testing/selftests/bpf/verifier/stack_ptr.c b/tools/testing/selftests/bpf/verifier/stack_ptr.c
index 7276620ef242..53d2a5a5ec58 100644
--- a/tools/testing/selftests/bpf/verifier/stack_ptr.c
+++ b/tools/testing/selftests/bpf/verifier/stack_ptr.c
@@ -291,8 +291,6 @@
 	BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1, 0),
 	BPF_EXIT_INSN(),
 	},
-	.result_unpriv = REJECT,
-	.errstr_unpriv = "invalid stack off=0 size=1",
 	.result = ACCEPT,
 	.retval = 42,
 },
diff --git a/tools/testing/selftests/bpf/verifier/value_ptr_arith.c b/tools/testing/selftests/bpf/verifier/value_ptr_arith.c
index 28d44e6aa0b7..f9c91b95080e 100644
--- a/tools/testing/selftests/bpf/verifier/value_ptr_arith.c
+++ b/tools/testing/selftests/bpf/verifier/value_ptr_arith.c
@@ -300,8 +300,6 @@
 	},
 	.fixup_map_array_48b = { 3 },
 	.result = ACCEPT,
-	.result_unpriv = REJECT,
-	.errstr_unpriv = "R0 pointer arithmetic of map value goes out of range",
 	.retval = 1,
 },
 {
@@ -371,8 +369,6 @@
 	},
 	.fixup_map_array_48b = { 3 },
 	.result = ACCEPT,
-	.result_unpriv = REJECT,
-	.errstr_unpriv = "R0 pointer arithmetic of map value goes out of range",
 	.retval = 1,
 },
 {
@@ -472,8 +468,6 @@
 	},
 	.fixup_map_array_48b = { 3 },
 	.result = ACCEPT,
-	.result_unpriv = REJECT,
-	.errstr_unpriv = "R0 pointer arithmetic of map value goes out of range",
 	.retval = 1,
 },
 {
@@ -766,8 +760,6 @@
 	},
 	.fixup_map_array_48b = { 3 },
 	.result = ACCEPT,
-	.result_unpriv = REJECT,
-	.errstr_unpriv = "R0 pointer arithmetic of map value goes out of range",
 	.retval = 1,
 },
 {
-- 
2.25.1

