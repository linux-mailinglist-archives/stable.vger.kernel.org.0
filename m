Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE985A4C2A
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 14:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbiH2Mnx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 08:43:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbiH2Mn0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 08:43:26 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1189AC251
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 05:28:12 -0700 (PDT)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27TAgb4J012990;
        Mon, 29 Aug 2022 04:51:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=uwe522SGym+/OX/Hm796XU96QicP8CcoZtFljq6oni8=;
 b=BQ4CmoKXvcudALS1XqwCaz7w8gqYf00pEV2N1n35Iw/c6Y7mSkzkhkpEIuzW09QZh4xR
 YZaoHKnFudGY6w0AOBdfUulQ19EIEpfRL9yCSAQhY2kJduvxFhu9Z8BKXqqEd4X62GAd
 PoLjz0QNnZLufX9mTZZXOAC5WTOEpZfHZGJPSE0Ri98r20PLeg8OBeqSAdZdbRWF8EwZ
 Ov1ouNop0RlujPJP2GTdZ3iLdT/WEQ2mx9W095OUgfNh/8wMUjFZ5mLl39t4Aryr5lEs
 aDlHOqFy+QtfO1KgCB9tgcODOvLzuM0P+QsjzgoXwbSolbcI0VhFPCu+hUikgH3mcwdu Bg== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3j7jsk9b85-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Aug 2022 04:51:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z4QDEi5F+JuPtc1cszWYU/tVmgsjhyA2oObq4f0vPCMGIvXGqJLUyBRxdOALaNg0tqEzQLSHChrjepYgKlhr/nBUv+T0aa0NbVYduPds1TeWjRM6oTgBEacP+Jm3edFcxZqxPyc+ysxmg4fsjNRCbXhwKKXkHKL4SOozjm5Hb6lRLcea/q7P46XhIszOMp83HOFjFqayrQXrGFTCha4YpkWYvYzT2to+VxALsQc/Y6QDlx71iAjfqpp14oP1m98Pvcjm2mVSCAtnGt73IheNLhO1/vdgwCPKa6+Bpw3yFhk/F+Z+annJyXgZ3qDJHYORe8ss7dxg2e3NoVLzZo9Zbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uwe522SGym+/OX/Hm796XU96QicP8CcoZtFljq6oni8=;
 b=cFsiaMQCyAkBzNjeimyYxC7KmrxUPomE1wJHPnbK0hO4G5whP1gHavkIlkOPKf6+RiH7ROM/Uw1XGsgQA+A8GJfetfxT+nwXLQ+HrMqk6GK/CTFBRbiqOjOSX5AlT2mkKI85uLfLuKIc4REhNOs+d2TlRxiDKrUiBYZmdK0T/N27o53WFjphp/xBVqBPQby8bwN2ZevkC0PwmvRBCNDaUDAMmmp9OtnGBkO3eUPovKu9IsLvk9bhDoVlshMxfMYCPkxY8+8LaORO4IG7d+2+6Lu3021+g6lrzjNr8xUVQBO/7zZZqQH2IMBMxdyPv7Kka5v5oCAvd/pBsLug3XypGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by BL1PR11MB5366.namprd11.prod.outlook.com (2603:10b6:208:31c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Mon, 29 Aug
 2022 11:51:15 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::b4a9:c48a:51c2:d3fd]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::b4a9:c48a:51c2:d3fd%5]) with mapi id 15.20.5566.021; Mon, 29 Aug 2022
 11:51:15 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     raajeshdasari@gmail.com, jean-philippe@linaro.org,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 1/2] bpf: Fix the off-by-two error in range markings
Date:   Mon, 29 Aug 2022 14:50:53 +0300
Message-Id: <20220829115054.1714528-2-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829115054.1714528-1-ovidiu.panait@windriver.com>
References: <20220829115054.1714528-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0202CA0025.eurprd02.prod.outlook.com
 (2603:10a6:803:14::38) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d0d30040-6d90-462e-ab2a-08da89b4c68c
X-MS-TrafficTypeDiagnostic: BL1PR11MB5366:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: koeNg9jhDLJM8swkm65HcBtoE/d8bQl2MwQbgMk9qAYP3YgQ4VY7DnFMmt3ybv3dO0+SPpSPXXfAzUX1Gv0T3f49xl2OPMmLvTms9WPwfziZTWTFhuxahfv596i+n0LwHR4ojVWSRPqLmdII3lkDcADqs/HKD+deArK3q1yBw71+lYMhIiL6umrRaYELD33CFm/t1DS4nClW7GFXMLUD3FJl+EfdBf1Zh2U/epabmN5YfTANVbPRBFfLSsAEaWhwPH5cIPj39s+gLzGD/IjkswLREjN51CPyhw82HIPY9x6SanslnasDqRJSIAS4M1shfO2R4qTncNV5Zu1ft9faRTof8fnjcjfcp2bJZjySLlj5GwyTiWs07XHs3JPKis2/EQPO4g4ex5+D0jjcNkLXiiECvnpSNeRygF41juThxV+Ic1yoLJhkcREkRK0BEszUJwpI3fgH2cyjThz5WflKLB2NesOCAau0STPfytUDFLCkCU3nWGt3UA2WLgk0Pev8sfZkiMbgBLaqUEdm+t2IaxO+GCjnaraCOR2lx+lEegw9ShMjtiKP+FsfRSoXIbYkhM7Ypr/TWDMIIFvKf8WBzNT6H9VDdg6UKhse0F0rl6j4qDdmOjhrHvgC4aZ9pUYfy5Twq2OlpQqyWFPlNIahUukuSVWktFzsucyQ5gpaa/KpSiBsXBMlLL7zUjeX93ovA23XuvYgA9jStdP1WAocNGZPxmdyjJ9pXZNDXaHtBp6AxHjnul+QI/Um9Q9JMJfs3T3ljWx+5CB20l7Sb6ZK1sSZNKTsftis83KlaTrEb94=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(39850400004)(366004)(346002)(396003)(376002)(54906003)(66476007)(66946007)(66556008)(5660300002)(8936002)(8676002)(4326008)(1076003)(44832011)(2616005)(316002)(36756003)(2906002)(6916009)(6486002)(478600001)(966005)(107886003)(6666004)(41300700001)(6506007)(26005)(38350700002)(52116002)(86362001)(6512007)(83380400001)(186003)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OhIK0TXnSwojK/N25VMkl/MhWDy9ykJXotAGB+zIfAONl/c+WBD2R53wYy96?=
 =?us-ascii?Q?p9kFbNI+l7FBcmuH4ohhDy2cOHOKrkI9/GsuPEmuC4iTihPqE7XFwDNasy5B?=
 =?us-ascii?Q?CureLZ7fZ/uzb0b3MBeq6jqpdYqCmo8c6fnEiiPO0cHYKZDtk+UPt8BBPhdj?=
 =?us-ascii?Q?++SslRl5y+Pi8Kp3l4YcarRyP4yPx1QqlWJ09HTasaudyyFZ/TkEDm6/M9Yw?=
 =?us-ascii?Q?7CySC/TJutFTl9ONzToJEicRXe+1hlnslgh8K1JoAAn8//lB+BNBC3MjZfQC?=
 =?us-ascii?Q?Qoq1ElP0JtERfgy+yKr7H61vKZD4Ytwes/wLwo1k9qYV3KeBjZz9HBtxmKsc?=
 =?us-ascii?Q?hZMW/CgfxXSIb9fAVhDlmo89eSQNp4FbJpxd2Dt7aIV2Rdw2wCl75y2biB+l?=
 =?us-ascii?Q?S0do62F1U97q2FlbnFu0n5fgD34tPPIhq8IcmSUXA5cp6Z51Doy4FXnZiPmd?=
 =?us-ascii?Q?TqWSoM6bWBmEhs6lo3xc7r21EQVLRtGcatPBmOZBauo4xZNa5Pz+7D7TfEpI?=
 =?us-ascii?Q?B2OqQLdGxedlZkPLpHE8k2j+cuRG/SE3L6Q9ZvYHjXKrqczd4M1gXwI6gi4t?=
 =?us-ascii?Q?Pvb8brHozHdm3A8mj3cJ36c2VMyXxfq+uVl/Z2x3ghQcAyJ703NGgf4sO/HX?=
 =?us-ascii?Q?5+7cRnWpUl+uQKRu/D0H9AwlDCcF8J42ecAzzKix/CCM34H1/BV9Y2VmHY2O?=
 =?us-ascii?Q?vBzme5GDe/ovbg0KxGGvOaLnEeQ1NSe1BNHbwHMXnLNSx4YBCUcp1vwKtyAU?=
 =?us-ascii?Q?8gykcZ+vs2to2ytGL9ffYoiJsWjIKyvPAO8dFGShPfEpbNYIz7iv4zuTT6IY?=
 =?us-ascii?Q?P7h3ptqqwAhs4k2m9lM6K6K5t+8d4+yHpjTtcZcjWlFdblfa2hybdi3ysCQj?=
 =?us-ascii?Q?qid7TThrCzYMrHiBGORKeoYBk+Du2KZcWJe0wIj+V5RXPQJKD3ek/ha9bq18?=
 =?us-ascii?Q?y9EsN1Nnfl2WR0CrwQra/uIxv9qotQ9wcswWsqwJuX+dThQdxp9MB9CuXGas?=
 =?us-ascii?Q?OYbSccywXDqbiyS7GK7OW43/hs6N/Oqtlmr24uKSeP3+7kIkOLf5mOfb398U?=
 =?us-ascii?Q?lKYgUxy4nWuSXIY0hHawrem62XfjlRpkUyY/klamxOpEZgFnP+dSVLBk9/mH?=
 =?us-ascii?Q?kffkLId7tNN9/pyJ4jpm70kBYlaDCaymMiifvNH6UC2oo89cppnbWfcX5jew?=
 =?us-ascii?Q?C7kHPuDDqT5EdP08BuHqNlrADc7rjP0XJddJUn3O5J6VYtZx93+s7y/HDHJx?=
 =?us-ascii?Q?NkO1I7v3ts3h1zwWbABJcRu70Y0QjdSOgqo2jUuNNu/0lBiqpszjNAXSSJ7d?=
 =?us-ascii?Q?f7I2Ho8IOWgKmRNd6FEtb8n331zM082NJ/3wYOrz9r4/26AfPubb46PVEgNr?=
 =?us-ascii?Q?r3ioEC7RG47x6ksUcFOck9A5S8apiR31/TRsjWe81HUxk7ym/t4GAKuadFkV?=
 =?us-ascii?Q?Dq4aqCHRm3jflY2bFpg/WsJb6m9y8sASVHN1DrUg7YAlBXtitqYXkapxngBK?=
 =?us-ascii?Q?3YZknl70IW9RLhmlkU/jhDOwBz/16B+/3V8v8DNHmgvTNrufiOLzI5fiKNYN?=
 =?us-ascii?Q?phTZFfraOiC/VXDxplEqQJDzXOkcwCQ/f7jksIFU2KI3mL2EAlsTAqeHn32j?=
 =?us-ascii?Q?TQ=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0d30040-6d90-462e-ab2a-08da89b4c68c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2022 11:51:14.5666
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hiyCAA+ApmjcVlCtYTj5aDJSN0g5IyQU1h6sI54rYRb/UBqyHEfmHZ2OBc0pPuAiVhmag07G9djFjqp1zrKQEDdXz0HjPCivqBpxde0QxLQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5366
X-Proofpoint-GUID: NfFMhxWfd0gI9XtDbVYM7LrBuSZw60XW
X-Proofpoint-ORIG-GUID: NfFMhxWfd0gI9XtDbVYM7LrBuSZw60XW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-29_07,2022-08-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 malwarescore=0 adultscore=0 suspectscore=0 impostorscore=0 mlxlogscore=999
 spamscore=0 phishscore=0 lowpriorityscore=0 bulkscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208290054
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

commit 2fa7d94afc1afbb4d702760c058dc2d7ed30f226 upstream.

The first commit cited below attempts to fix the off-by-one error that
appeared in some comparisons with an open range. Due to this error,
arithmetically equivalent pieces of code could get different verdicts
from the verifier, for example (pseudocode):

  // 1. Passes the verifier:
  if (data + 8 > data_end)
      return early
  read *(u64 *)data, i.e. [data; data+7]

  // 2. Rejected by the verifier (should still pass):
  if (data + 7 >= data_end)
      return early
  read *(u64 *)data, i.e. [data; data+7]

The attempted fix, however, shifts the range by one in a wrong
direction, so the bug not only remains, but also such piece of code
starts failing in the verifier:

  // 3. Rejected by the verifier, but the check is stricter than in #1.
  if (data + 8 >= data_end)
      return early
  read *(u64 *)data, i.e. [data; data+7]

The change performed by that fix converted an off-by-one bug into
off-by-two. The second commit cited below added the BPF selftests
written to ensure than code chunks like #3 are rejected, however,
they should be accepted.

This commit fixes the off-by-two error by adjusting new_range in the
right direction and fixes the tests by changing the range into the
one that should actually fail.

Fixes: fb2a311a31d3 ("bpf: fix off by one for range markings with L{T, E} patterns")
Fixes: b37242c773b2 ("bpf: add test cases to bpf selftests to cover all access tests")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20211130181607.593149-1-maximmi@nvidia.com
[OP: cherry-pick selftest changes only]
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
2.37.2

