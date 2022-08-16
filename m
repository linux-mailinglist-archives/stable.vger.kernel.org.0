Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7291659592C
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 13:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235094AbiHPLBi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 07:01:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235048AbiHPLBP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 07:01:15 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63C5A58B4D
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 03:27:16 -0700 (PDT)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27G8rjPp019911;
        Tue, 16 Aug 2022 03:27:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=sQwcbZHI/0JlopHep+U5CtNNK1NpyjINzmOjHQeWRnA=;
 b=fmAz/5qXUEol+fKsXDq7+H8e/1DGnN/wIi/0KiK7/JAR+4UOzUqqeY1gdN7ThXda94N4
 BoBkHVHEgnU1q2n8c0JBq8jDyfTAR6/htf6lE5SWwSYqghnRDBcng9KHcv9ziCv88jjn
 g/cYuLv3YmtmRj/7SO2MhRpZz6PqKnfIrAx5YYYtUv6MMXbIVQ79RmNUOvts7R+pnxof
 V+OC9lnZkulx/OfOnlp9JrEYRqcNDYKD6smJg4W1qWtHNYFVXsDVHmSQHFEfpCvpsTk9
 nAf+tS3NTJmCkcGKRjQvrDFEpYI63r0MtD99G29UCA6J1c/Afh+HdlNywJ0aZ6+B4SX6 eQ== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3hxbfjj6eh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Aug 2022 03:27:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OwMZx7BdrmGKT2my2tCZH3DTYQ6WNAMm6zg6D8/nzrXArJVjx30WFIsO/71npCClkzKGGyAr8+Ah+LLbgtKO7TmtsqP+8kpmotzT9ZgBwFmRcX6FRExwQu2/Jh8rQFsG2T/FvpawlVM16ofM9qm3Uz2ikzNilNFlsvaMCixIPQ4fPeRQ2Hv/25TMej9zQBd9QrpCuLyTWxGVboOjdAzS7gZ9dVWeX2Vz/YQcLPh4mZJBALZr1fUXR4dHUxKVLkeSDKxw1p5pTZXw1JVEYVXXbhrt5FYOIp7iq+qwFKFsOfS/m41UCvrXp7W4OyuXYMs/5Z05RD74CrxOxdefEaVt6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sQwcbZHI/0JlopHep+U5CtNNK1NpyjINzmOjHQeWRnA=;
 b=POWjJK+x8QH1kUcM3OlnBN2wsElZ2dGHTiYtZlwQ8GM6nkwbIH1KWxsw87NpO8x6ns5VnvJ3jyzI5B8oUNqHeMr7rdlkJlsQnAzQzDGBfUZt3pUwDCY332Kh4vChvhaLaYkSS0FQ7SewHDd23tvejA9Y616a+YCioS2VAillXjccjP2ovI88Ayo0NJNvBBbUDdaspw7lB/D7j/QNc1mW7PPClMtsf054fqdeNl3csuZO6XLYkJpIQoeUxjOJRNy46CUUKKyj97gwNfabBQj2FvpjvxEXg0cmgLFRLP60jfwYJO43FtaemJ8mV8dkCMuuYNxPgTv4e4CpuzG0irnt/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by MWHPR11MB1869.namprd11.prod.outlook.com (2603:10b6:300:108::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Tue, 16 Aug
 2022 10:27:11 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::e500:5c9f:fb41:287b]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::e500:5c9f:fb41:287b%9]) with mapi id 15.20.5504.028; Tue, 16 Aug 2022
 10:27:11 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 v2 1/1] selftests/bpf: add selftest part of "bpf: Fix the off-by-two error in range markings"
Date:   Tue, 16 Aug 2022 13:26:53 +0300
Message-Id: <20220816102653.1038200-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.37.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P189CA0018.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:802:2a::31) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5ae448c7-226a-4954-23dd-08da7f71e10b
X-MS-TrafficTypeDiagnostic: MWHPR11MB1869:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1REUkryro7DuGzBYcvOd9gH2jbkBPaiAtDGzyMb4b+zeNL52yqi9y8VOl4LByDbKEM/K5dtz2d7XBRxa8mHN83mEodOhY/dlCaooCnl6tmscFpIfmpvf6C3vQkzmOEkQXLIxrD/5j+O2bV7pU7KUxCZZfpwK2BUOEfvvzC8Pr4y0YCeWzJAjJZtbQkfirebUUubkqLBqB5keYShm5EvYjl/0NA4XgHd3i/wbsqdUNPODZQddLxiiWFs5RErE+bDg6OpgLe6SUDtbqaPsj7dNdyUlmzxUXlBjPHOqPVPaep0pg+Ad2DmK3ogY7tOjYoJKZmmrJMq9CykAPXU1JBnTR2nkzBDScq6wdRfQfo+SUnaNqO9rcrY3ZUKRI8p7mW8Prp/wrCqp/1ugCuNTWWtWv9KdodEC6StQqyU+UZP7kEwNJRysZX9TplXwEPOoqvODaR1dRPzURIOXTm1mK5EDgXjXK09Cy03h8MeAONdFcAKxoClOPHhv+VwkSySFw9Fzht/V7LieU/Z7Y39rz8j5aUmkNEmsI8qZP+AOSCsfqYnx6agra1sPPCaNi7QV5dFYEqmslvO9ONwaDjVyzIVkHON9c2DFCcvUGRZ6Wk5Bf1/S92Bd2o1CQOwlzAQbtBZCZ/XHNJ8ZF2fU9+wLDGq2NQWG9owqvArUN+pZomHE+JmRlPvVe+mfbodkw77F4PVpz2BT1McMQVFN1RPJ9NEJ4V9uvTTXofVM0Pg6pIeQhXVnNty+iR8bhRNvjzOLC1VPCnG5m814303cd9xrrbVQZI24c+b8c0tn53t+QCmw70U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(396003)(346002)(376002)(39850400004)(2906002)(6486002)(6916009)(26005)(316002)(36756003)(6666004)(8936002)(5660300002)(44832011)(41300700001)(6506007)(6512007)(107886003)(186003)(1076003)(52116002)(2616005)(86362001)(83380400001)(66946007)(66556008)(66476007)(478600001)(8676002)(4326008)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hSkLHvUeiMPqxVu/GZIJ7+r1a3163G9snnpWLTRiat+ZHKg7j91Z6j6YsJuG?=
 =?us-ascii?Q?HQ6nkoObrUd+CACxSPpNjSVgVEqx1l04C1vhppl/rtDEbOYNOMX3svjt8d5r?=
 =?us-ascii?Q?kL3DJ7I1ihbpUdUFqbjrFRgeNrFiQ5Q2w9uPlGSH/PnJtCcTglBaUU/DZGi6?=
 =?us-ascii?Q?rXXsJhZE77780B2O7IXh0cILR9RybKvllFo8vy4xSeGPPMfa/EB9iZEMXoUl?=
 =?us-ascii?Q?IyumJohMz2kDLY9XxvgbVGjvAvbLO7tp0SZNY9OtC3PhwkZXJ2NI43VvNrbp?=
 =?us-ascii?Q?Yu/Mdz3G54RSsGBl0R2kozYlEpFOVkAuwr04YgBqwfz+PZ452GCJ4hSRHKTo?=
 =?us-ascii?Q?MM4Asw81RuDXW+I7LPXRgUodPn3RtpumMIPJ1TgpSRUeGHnF6aGVkn7k/Z1z?=
 =?us-ascii?Q?t4SbQkVInP5kdPdj71af1AviA9j/eG6eX63QVkE9HJ8x9oPvZfHugPhDEDD0?=
 =?us-ascii?Q?8x8CuTt3cmmy/NPeFve+B3sI9ZdjKMcnDddJeNTpNd2SZL+u+9XSUJ/avdY4?=
 =?us-ascii?Q?XlpI79OrlLZsVpyjPcWCp5O1pY8kJVt0Xkshvdi+XvZ4gVdqWQ7+aXRCF3vQ?=
 =?us-ascii?Q?KlikCu036Pvg5cHLLINftCKFpzp5aethcd/vm9P/o25EAK4jj/tMiwH5O+LM?=
 =?us-ascii?Q?0g3IRCH7TXCVhCE39La7454wxD3voDyPVTUnnn6ZAqrPGrFCcSgC25lXua9C?=
 =?us-ascii?Q?chskWVXaK3XcmAynBQi7kgrxupQi9iUoESuz1iarZyz4KYDAJdFWtN3sD852?=
 =?us-ascii?Q?Nd/NfCj99m02KAWY6m0uq+uaoOC4F1/M5dEfmMZvXytIFWV+c/2vnZboElnF?=
 =?us-ascii?Q?GLHIqmhnOiKi/F39MEGBu6I+n5ZXppXRqwOdtRf6fTGNGAOrp1HpnM2BQDyR?=
 =?us-ascii?Q?6f5azhWdd9EAcjVlIePXF1JLfeRLB+D6QlQBQ6IvpF/Lw4K/bjO9meXPgaYr?=
 =?us-ascii?Q?7XjTEBtbC90UAZ/EhoF6SssMMBMgqe0WzQa4T90TkH0KRWJqEEl07TGLomHA?=
 =?us-ascii?Q?dDzo3LI5nJGiXSgcPcOqVLlnVUdnxxxu5OLpXbckaEFUtitI7OqqwJ7CnY0G?=
 =?us-ascii?Q?CByYRaFjwAFoIqvUn7EPRKAq1Qx7RaDrLFwlE+/HepfJJa4VHjiAs8z1NpAt?=
 =?us-ascii?Q?/TrxSIzCjeeDIyXHPtG5AU9ZPvVoc8JvrAtTkmzXY1dVqU4iGWjDIK8jhpXm?=
 =?us-ascii?Q?3vQbdmCy8U2YLKj9CukRW8IEynznlruy1x3mrR/kZw9LV56wdbGhOip+QhXt?=
 =?us-ascii?Q?Ed/b0YniBlMmGDbJF+0zkKEZwcLXyvDhM8eARXwwMlnQT/RZBwtmbhFfhdPv?=
 =?us-ascii?Q?6Mo0gWbjhWzFFoX87JDdLG04+UXsSl+oKbIIzv/C79IzEQZwSHp2kxJbRfH0?=
 =?us-ascii?Q?Ig/2898z9vIZVHcBuZ2ZUBknUESkY0asEqyM87+9DHT9zmOVhLVpsLNe8QNC?=
 =?us-ascii?Q?g6qEFAx5q6of6GxqRBZmzKju+gA7OXQ0u+5UAtg/6K0QEdcXoq5roZy3nX+/?=
 =?us-ascii?Q?Y9WDODvC2+XMgLbMTDcoIJ9WTupx3W+BiDLSCjt7aBm77eOevEBc+4xDM08J?=
 =?us-ascii?Q?H2Nwul/pSKa5RRaaiu9ZT+LY61fJBNxs2FhpBrcmJ/txXyXyHIWXo995nQ1I?=
 =?us-ascii?Q?4A=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ae448c7-226a-4954-23dd-08da7f71e10b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2022 10:27:11.1388
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VaScWebP5rsrhq6b55BGnld841oOhEW2lAXBFX8ahE4OWrKwa6WArJezJDIbhQheJKxa2smlMdBxPNK8+kouR5z2JAEuF3StSN2vwz7WVgs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1869
X-Proofpoint-GUID: 0C7Wb1_8yyLh5jedPs9z5Us2DvyPxXEZ
X-Proofpoint-ORIG-GUID: 0C7Wb1_8yyLh5jedPs9z5Us2DvyPxXEZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-16_07,2022-08-16_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 mlxlogscore=999 clxscore=1015 phishscore=0 bulkscore=0 priorityscore=1501
 impostorscore=0 spamscore=0 lowpriorityscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208160040
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UPPERCASE_50_75 autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Cherry-pick selftest changes from upstream commit 2fa7d94afc1a ("bpf: Fix the
off-by-two error in range markings") to fix the following verifier selftest
failures:
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

