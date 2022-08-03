Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77D3D588EEE
	for <lists+stable@lfdr.de>; Wed,  3 Aug 2022 16:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236080AbiHCOun (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Aug 2022 10:50:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236951AbiHCOul (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Aug 2022 10:50:41 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C30D0DF
        for <stable@vger.kernel.org>; Wed,  3 Aug 2022 07:50:39 -0700 (PDT)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 273CtPIE024578;
        Wed, 3 Aug 2022 07:50:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=y+XMsF6wuIupPXcX/K49B/ABr7GgwqSKgaZp52vIobo=;
 b=kVperi+UeSJcs52qbrPX3tFeA9Edqq+FXuWSICUb11buanFXm1meUg5KInoyttt/w2Ux
 Hs1oarebG2QDQBpeP88Wi+OZi58alX1ZdabKbKr4b09Ajm5aa/UujQyjWdi+W9wHkRuf
 logB8QbDLy9L4/qx+mU0wlQAZPVZRZEwIgYah3yl2YPO/+gZS1Kv7yEyg0NfsW/8tD2K
 Ms1YloOOQbyYFl1ucistl5LR/9ThTFnkAyiRtiigfMQ9Tu8yEbkFrzmjvDhA70C4QE2K
 UXUViJRDi/lwQRX0SmUojHm6q3QHPtvg7H4qT8RUz/cDnuU3BnRWi/Pv+QSoUkZQz1Xy rg== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3hn45ju4w4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Aug 2022 07:50:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ei1TLXcmwuUc0poY8uaor/aG7JdvXbRlOvtUWzYKzdWH+NETDzPyNz6YJjwEsz+bYmD71xcohpOLlkJgEtWM/4DMPuTFPKKZLQ7oBBId1By4c2qXBMKzTNxFwmJKK/eVrC8Dskc2tUbwDJKjq+f/Vq0USi8E1NcHsR7RuOIWIRn9Z3Iorv8LY5jhKbzJITy8zNSHs62fLYQZf9albv3y5v2S4tsRN9a5qStAE7zg4pMRu8f9tKAqj9CqzznltAKo10oZ3+Pg+B3DGeqjtC6kqRDgTteZ3Caa+yn5C7SxAeeT9+fXQK1NSJBOe5Wu88K9Ywz84Hdfng8ZhqRPFKSeeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y+XMsF6wuIupPXcX/K49B/ABr7GgwqSKgaZp52vIobo=;
 b=G1epkcKrhv8lK28n0EKQWC8KpeimvgGfhaHfKQfkXk2gpwzVhRHhwxuwws4EFiazb9J/rj7KoROz3RAUn8z7fnc/5J7XZWaJyKYFejoEubuFTzoKCVEgaqlAzsce/zy3GD7aC942PYMGgZ/4FJp8BPFKE4hTJZocHSqR18fHZeseIPEync5BAcyJIurV426B5WHe++AE64w0Nr77Ke+NiMTmFT/d6iGgM1IxeHwVqdo4hFZZR8d3hFVtHHZKvko+AEbLLmuOCji8edJMEqPgwaY3ISCzLBuq3Uk9ss9lLVNIv277SeIKrtq1kIifYfUmxMtp3rCe4VuBEQeuldBhNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM5PR11MB1993.namprd11.prod.outlook.com (2603:10b6:3:12::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.14; Wed, 3 Aug
 2022 14:50:28 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::e500:5c9f:fb41:287b]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::e500:5c9f:fb41:287b%9]) with mapi id 15.20.5482.016; Wed, 3 Aug 2022
 14:50:28 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 5.4 5/5] selftests/bpf: Fix "dubious pointer arithmetic" test
Date:   Wed,  3 Aug 2022 17:50:05 +0300
Message-Id: <20220803145005.2385039-6-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220803145005.2385039-1-ovidiu.panait@windriver.com>
References: <20220803145005.2385039-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0250.eurprd08.prod.outlook.com
 (2603:10a6:803:dc::23) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 64c80d52-23c1-4834-4b98-08da755f81b6
X-MS-TrafficTypeDiagnostic: DM5PR11MB1993:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wiJo+GKTDUdx+QJk13KQQ7LsHx1bCZ9ii+2vqdTJRABJc1PT/qHlkRd+MahI344tE3m0o9PVWu0mC7/FFn07ri6/gU1Z7UNnsv9s19MLYGQPm7rhYtwLfaA0TAUryT1iH37B1xHq/Y7kEm8rJsRDgGunAgP8brhpCPLMoZ/kVDnVxbCaJWeaxRbfmnIFsGrCVq4wMcWmsvp33yLBLzkmRQ6/cioMeBmh02ldivx+yQAJhLpU/ZBqLmTv+snJgec+CDo6QLILzJrFE1sTaBA8Utca+/u2/lLe4JkL+tacnN0Oa/TTaVLUA4TV/rR1rZwahDbE6Ppzw6exquSdR3PDEAHxyPbFX+JhI1O7UWReT2pBXMSV4TnzaQX8noq5ZAcV5F2WiZdJzZeyF7h+N6C5zq2a6GsTJpQWWeCtUglq/D2j/LeD0MTyywKZ1GRmcWASRjpiQ6WhPK4h4YWOd3h3HX9lE4mA7MHmINYDoBq0kY21ddkiwmuQAcNFioe5ccDzzl/ywTjuPZ0HNMJYTKkdrRd/SYNGJO1mC0kzBH/j8Qty6/IJnUxagjm4apP8RmO+IYb4Sund/yqRMfzdSb7iaWOSQQJPIslG4o81y4L7GDkeP3j4jAeO4jt2+kKpOmE/ewqyaCUx4pOruBVgplfcaD8kfAp9PDZago7VBo1945KmyU2HI1G2pEnRu3BTQS2z2XVh0T7/SOoBaDLwwy+FVd53RmL96BoT3HGpommZg8l8vz8IHZDxi8KsIIVz0977GUeuONRHIih5QGNX14jZ8g7wmyiGoR1hdglbUbz98e8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(396003)(136003)(39850400004)(346002)(376002)(8936002)(6916009)(54906003)(107886003)(2616005)(4326008)(66556008)(8676002)(66476007)(86362001)(5660300002)(316002)(1076003)(52116002)(66946007)(83380400001)(186003)(38350700002)(41300700001)(6666004)(38100700002)(44832011)(26005)(6486002)(478600001)(36756003)(6512007)(2906002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TB44tWqoW8sOoRD7to2S9gH+STZpVH/XUGfh6MmQxTJFRwi2tXVW8pWfARGw?=
 =?us-ascii?Q?tYaYt7TmVMUfVjOgVk5amqMGC6I8Tj4dnD70IGbM5+bkpTRU3elzyqM0/F6H?=
 =?us-ascii?Q?++/GPQFx/CNbbZ9XRK8CAggtzV0C12Pws17oAHHLuYqf4+nai3wPXR+fISHN?=
 =?us-ascii?Q?gFHJDTaCZa5gEocTHzs2Vv+V2EssqufO9BSMuthmIL0WeiRj8Kv9bMDylLHF?=
 =?us-ascii?Q?s4tq6lsJj8lzk/erX2Js31jyOdMzogWxxMAg1HhUWNGgFCcZv2fghyj6P6TS?=
 =?us-ascii?Q?cJtSweYbTY173hcByh6ecSoB4AGKLXTC4v5CZWADHYa8X6ekTuj+h0qmXynv?=
 =?us-ascii?Q?5KVVyXwv9uMMR1AbU917xwu7/UlcRJtBjwa5CvZ7VZv2giIOMo5wyXSt7r16?=
 =?us-ascii?Q?wLoDa8+gYj6cF4bhid4QzNc1Skxjf2zmqiOKF7Ohu6xsGiLDzZl+ULfW2eOE?=
 =?us-ascii?Q?//XehY0N9SysdzaYCtJ3QrXSZDc2IKdAINYl2qq6aFl0UApX1/PXHTT8HqmG?=
 =?us-ascii?Q?ix1v7bpMt49WsvpZsuiG/gjHLXdBkgPwaboYim0RaZy2f8wHB7KOtW7Q5mI3?=
 =?us-ascii?Q?OGoz2tey+ZWyUvurZpB83EO72C7/wQzRVghdZVJogAhGsYAXjGQvlNuw8YBl?=
 =?us-ascii?Q?ma8ZAmyEiP8nIiXaFeN7hmQxzkbzC4dOa7BDYm3WqDGy6MzHAqayZoyEqPTQ?=
 =?us-ascii?Q?QcCxlEJk+55RBZ8Ze9RMldviAnW9qBJu/3M/ZPzKqe7PL496tHc9kAI/jv06?=
 =?us-ascii?Q?e2ZVK1LVUoOoohGjMxWyh0jIgqkuwoC9aAS4lartj4vfJYuKj13cldluTt3s?=
 =?us-ascii?Q?yns9Sr3vFbhpSEGC3DPJ692htG5VObAWc6KVRGDnAcIg5CBAbRiGrPfeMZAx?=
 =?us-ascii?Q?hDrx07fY5UsqoAQqMg68pk3tY/h+u6x/lZoxC5cxemFPB9cuOo6nHuFq/fwv?=
 =?us-ascii?Q?Dz+ngh6Wg2VsC3mNKNEu0JzkIUP5V0eNIXoR8qp1MJpTy+P3lKrbvfg3bYiv?=
 =?us-ascii?Q?oMUxfZcf5pmj2iASAiqpTXAMh6fIb523mS6EN2YidsMp2v3BrD7VYrptxvfu?=
 =?us-ascii?Q?IPhwSv2VdX8lS+o6yXhsksxX3tL33dqRoCGfZ4NbwRQXOE15Hnovj1/RBaZp?=
 =?us-ascii?Q?2waZ/UYltlpiEDVI8oikD4v/s19TA+jfyR7VezNQkapZrLFFYTFMVLyMCJZw?=
 =?us-ascii?Q?I0TGKpi6aPYxPLnEjqh2ewR9U6xSPvx61JRRA6sLPPX0CzkFq/pVB05e4GJl?=
 =?us-ascii?Q?mQExjcbUuOCRoX6+1q3o+ZnbYmvuhALlNcayL0TVuEOrtAgSVrn1ztNVpDgQ?=
 =?us-ascii?Q?UEzEKGIcOBReJt/TqXxdvqTF/Eb0ojTziFHvlrCTU6CIVRbElVm3eYfeyFW0?=
 =?us-ascii?Q?xsqgXAZt1OnXdkn/f5p7SsUaZJ46rDvFN2Kpp03PE5J4npRaPD4ak9+f+VK4?=
 =?us-ascii?Q?SDDz/mkNA4pYxu7aZWlYaw6QGvcv6xXLatXnD8Bq+cRUUowpWv4+JjOTCCcn?=
 =?us-ascii?Q?J2yFEPZp083+qtN0qejO6IRN+vVHTdLK7yAdIoE4I55txzXQeiEqUduSurEM?=
 =?us-ascii?Q?+vi8J3c5wAbryq15x6Ub8noewkAddqY/gtm6wSLjGQweqAR0fkFepsiyEH2z?=
 =?us-ascii?Q?ug=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64c80d52-23c1-4834-4b98-08da755f81b6
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2022 14:50:28.6146
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sNct8U/XJ/Htv1eNifJnj0TLTgqNdGTKUdNq+EASlga+O4wdNSVHjjUvINO/LO9Q6JlZ/p6zD3r6tLPYbbNh1Q5zFeXuUFun8zu6IWrNhQ0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1993
X-Proofpoint-GUID: 7wk1hf5VX_-Dd8tnz5BF8M3-_gJjI0GJ
X-Proofpoint-ORIG-GUID: 7wk1hf5VX_-Dd8tnz5BF8M3-_gJjI0GJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-03_03,2022-08-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 impostorscore=0 mlxscore=0 spamscore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1011 mlxlogscore=944
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208030066
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jean-Philippe Brucker <jean-philippe@linaro.org>

commit 3615bdf6d9b19db12b1589861609b4f1c6a8d303 upstream.

The verifier trace changed following a bugfix. After checking the 64-bit
sign, only the upper bit mask is known, not bit 31. Update the test
accordingly.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 tools/testing/selftests/bpf/test_align.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_align.c b/tools/testing/selftests/bpf/test_align.c
index c9c9bdce9d6d..4b9a26caa2c2 100644
--- a/tools/testing/selftests/bpf/test_align.c
+++ b/tools/testing/selftests/bpf/test_align.c
@@ -475,10 +475,10 @@ static struct bpf_align_test tests[] = {
 			 */
 			{7, "R5_w=inv(id=0,smin_value=-9223372036854775806,smax_value=9223372036854775806,umin_value=2,umax_value=18446744073709551614,var_off=(0x2; 0xfffffffffffffffc)"},
 			/* Checked s>=0 */
-			{9, "R5=inv(id=0,umin_value=2,umax_value=9223372034707292158,var_off=(0x2; 0x7fffffff7ffffffc)"},
+			{9, "R5=inv(id=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc)"},
 			/* packet pointer + nonnegative (4n+2) */
-			{11, "R6_w=pkt(id=1,off=0,r=0,umin_value=2,umax_value=9223372034707292158,var_off=(0x2; 0x7fffffff7ffffffc)"},
-			{13, "R4_w=pkt(id=1,off=4,r=0,umin_value=2,umax_value=9223372034707292158,var_off=(0x2; 0x7fffffff7ffffffc)"},
+			{11, "R6_w=pkt(id=1,off=0,r=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc)"},
+			{13, "R4_w=pkt(id=1,off=4,r=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc)"},
 			/* NET_IP_ALIGN + (4n+2) == (4n), alignment is fine.
 			 * We checked the bounds, but it might have been able
 			 * to overflow if the packet pointer started in the
@@ -486,7 +486,7 @@ static struct bpf_align_test tests[] = {
 			 * So we did not get a 'range' on R6, and the access
 			 * attempt will fail.
 			 */
-			{15, "R6_w=pkt(id=1,off=0,r=0,umin_value=2,umax_value=9223372034707292158,var_off=(0x2; 0x7fffffff7ffffffc)"},
+			{15, "R6_w=pkt(id=1,off=0,r=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc)"},
 		}
 	},
 	{
-- 
2.36.1

