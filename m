Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA71958D4C8
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 09:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232748AbiHIHkS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 03:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239687AbiHIHkQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 03:40:16 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BECFADF3
        for <stable@vger.kernel.org>; Tue,  9 Aug 2022 00:40:15 -0700 (PDT)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2796rM3f012604;
        Tue, 9 Aug 2022 00:40:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=QqoU0R/qH0YaVMBpApOa3RWMAdDA2jpYbw7Tm2cNHWs=;
 b=hbA05OdlhRzJnVyGgmT3FxWdTNNgdCGLV3zFYYRN33OBLTKAIokQdaAQNZpnlLNsbvDb
 a4egWRAH7A46GuDg48KKo2rQpivX4t5L8CUu78OBVFPSZqX3qa0Uv2Fv7oUenapyst0e
 LUy4UQJRZSYyAs5KGMrqAhxVMJyyHH6n2csel5eT+MveBdv4UPfDZYt2m8gHxjeLoTMZ
 iNMd+CXcalRLZx044EkePovqVo4joWLPfRln+8bPRK4/VfYsZaPAIxG2EYnu9C/jcJoa
 9S7veSkJMKQzEW7S7BV+/wWP7pw6z5a+TOGR1ynNKLAQLbsoMcipMnqJmGI53t5m8Dgj kQ== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3hsqtka34x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Aug 2022 00:40:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jrQ/4O0srCPQYnSxap/EsAHuwsc1kkyqKA7Bb6tRNEKLMi9Wuby7f2WDULH3X6J89/z8WA1B1w+C0PKYWKhB9Pfm86YiGz4AyvSk5wR+phReE5N5Nrf7m5/SuNgsdexKsrOsiBm0f6WJuDmkjsivcah1bb5mmyvBKOGuLUI79zKY/OUZmHBNfFM4RdrRnleug29sykdtyzcOJVtp1hvmRmnV2wMlZHpuFAU79vlcm4WpwTVXT1uzGgZWaYym7zQNcz1zBQEb87WLoBhDKicu98vv5HDZci7OlTd528VnrrbsyvsqTnnD9ETXtGTEf5BGbTxL4b8t9rVMMzXgAfzPeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QqoU0R/qH0YaVMBpApOa3RWMAdDA2jpYbw7Tm2cNHWs=;
 b=V8qcW/zLUTpXA9FlEDGeJcXQLtrjGrJMfyx1cIg3UpblTrIh+T4xYWdirhvx0bZ9ASkHtG9l+uUlwq4Xyg+euYli9cSVUY5fE9suL2o0DtGA1f9F6d4yTHbwt/nDkDGSUAPLUTQl8i9znYp51VjssopjgDZ/WxlEPILXGT7Dpz9VOrep2vG7t1d45lx2rgfh8C9DN89chggJ31YTC3xCRGSnN9R3lYN6WIP79a2YLq3fXNo1SakkHbe0MwQKQVH2O9oH4deRl7fOjv/oxfBXthODoJUQqhH+xLS9+M1Vy8mWXfqzPytBonbYqTd/++CRmsZFPYGl1FGNEV7FKRdqWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by SN6PR11MB3070.namprd11.prod.outlook.com (2603:10b6:805:d4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Tue, 9 Aug
 2022 07:40:09 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::e500:5c9f:fb41:287b]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::e500:5c9f:fb41:287b%9]) with mapi id 15.20.5504.020; Tue, 9 Aug 2022
 07:40:09 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 4/4] selftests/bpf: Fix "dubious pointer arithmetic" test
Date:   Tue,  9 Aug 2022 10:39:47 +0300
Message-Id: <20220809073947.33804-5-ovidiu.panait@windriver.com>
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
X-MS-Office365-Filtering-Correlation-Id: e7da0e7e-b766-4f03-abf6-08da79da6302
X-MS-TrafficTypeDiagnostic: SN6PR11MB3070:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lp8W/3oxUbs2ndj57V/YNElW1IsDZgBx5sZDkSGvzk9TxZxq0shlpX5FLwh1YPZdmlvqN/NGjBc4wTZR3pNybPpsvCQAY2jzzFcOwfTD2TskrQrUYWbH14hdBf/TLFBQt98LXLWdmNluu4A6f9IcAk5PjZ8qpTfWClvTOdiaxVDvlb5M6Q7844fe6Tw+ohVpHmr5oZQ70sYYY16EJDUYAhdCKGqOnUjytAZdPxJPW9dK1jrHrQakGX/bWFFxCEPwut6YC4E21qX0E833AGLNxzjYQbt5PmlXScKfR0UqXX/HSVfZ8tLdU6Vrlz12SQ+0jr8nKeRfwdAW2XX83Mv+zpLzgp8zL7n2zlO/w66CQ2WDDyoFGBwlp/OwXQ5vhb6rA4JobssEMPdIbJcnOvFtDMOAsK7jvrNicUBjojTlsa+s7Q454i+3Ap9D2E0EQ+ECIMX02LTBHjbj2HMtLBGrCtNWb7DZC33qTqS7hmHO5GLr5lCzaa2kLVvQOaUDmRStS2R1ukYmnJ4jw0g2ZqeSQYaqB93YUL1tBqYgkcSKiMnKcwYfsEjEUYrppNsdlgr0FoI6TTt6itHkzYMO7E+anbeRCUOXje+Ce4b2mVyGRN1H/7LzhhFwOgxOySZv6IcU9PDk7qvqNS+f45ivZgWq3+Ouqez9aJc4Ci58CMqEJdA/ypp6L5Irsr8xzPVBj9Z/gleQq7Zs79aOmsP591Vu3Ei3h2MEMIuknDzg5LG7CI+Mc3ZHm4rmYOJGZVSio86AbGWZdG1hT4DKn05QY4+F8c+fTS3/u9WBX69piE/ju3k4sxq34v6y1bym99StxXZt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(136003)(366004)(376002)(39850400004)(41300700001)(6666004)(26005)(6512007)(38350700002)(52116002)(38100700002)(186003)(6506007)(2616005)(107886003)(86362001)(1076003)(83380400001)(44832011)(66946007)(66556008)(8676002)(4326008)(66476007)(2906002)(8936002)(54906003)(6916009)(478600001)(5660300002)(36756003)(6486002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8E3YA3rsOmfcMq6pL0cG0KW0ecnHZ5/Avizsc1gtPFN6hhIsw6Xxe534MaEc?=
 =?us-ascii?Q?E1ZHJUZr7TYm8i4ni6nI7h4EYuNYWk4sO5WbhrhvKUCDLpejgsvDkSpdemen?=
 =?us-ascii?Q?i6DJfYz9OY33JtoYIESFEG1qLkqRYaE157atl+FZOoOKsyNgQYHqbbnFu3AQ?=
 =?us-ascii?Q?3+GXlS1TXGdneNbr2jmXkqn+qD9RErRM+1ado9BoP0PX1shRYURY7KqANhxR?=
 =?us-ascii?Q?ubxLqtPvkkdGsXNxu9VAFaCETsS7CCF4FXLkQ47DFiCHcs42GnmAdEFTTSna?=
 =?us-ascii?Q?hjqc75UHLJW3WZtiK5nSG4jmkaWP9CaDkL0W08uFOa3Hp6y4qTWOXGJERYVa?=
 =?us-ascii?Q?1UoDZxmxyllGWq6ds9cxddSuF9RQG2/W4eLqJsPXQz5wpDuwmeS0O9QQ0Tu9?=
 =?us-ascii?Q?Xzx7fwqJvKlSgKvVAM57uYSmTQB5t9sjAkI3PtLvkcfMSgiXYt9j5z57yp/2?=
 =?us-ascii?Q?J11+/kpZBOLGd3yCLlQPgF/zx0qh0sCht8AfsIy4mJ5SERTEB6WCSfY1GrQo?=
 =?us-ascii?Q?cVTY4QC434S/DP8/9zsKgOIXkWqUgTT5x8cEEWqglWIT5cZ4iBcMeHMP9SxM?=
 =?us-ascii?Q?DtJ4ZqjXGBe+p02muvXw0Mtr9DyhvX97b4X3xMVuEkAJ59dedstyEakKF2tm?=
 =?us-ascii?Q?DcGCuRsL0VUZedzrLnH6OR7zfLsAgkYz4ZPfwqBi7MKIAX9O6JOMr+OT2h1o?=
 =?us-ascii?Q?7b4Vqyk15DhAhM6vHIaEfQhSjC1rB31qnFFoRb7J64EQHEPJvJrr7R1LsSn5?=
 =?us-ascii?Q?0Pa7Sj0RrvFKcB/bTbGcqb4arNPEi4d6UH/jOz1o31QReiGbhiJjMd3nBD+r?=
 =?us-ascii?Q?4FPUtg/Gf7cn3s7VwndQZEl0JPZtos6+XGPa5/Pz2zuldC2vLiFqjICDzWXB?=
 =?us-ascii?Q?HRuuSYsKwDmA8KDwSFQOmDzGQOctIMLzlERo7k8u4+Ovievb7KlN7L6M8Rdb?=
 =?us-ascii?Q?KCJ18iEIk89evpyT+APeXyk7gOEInqaKSquejEEN6MxazcXD7akRfEcuL6Sq?=
 =?us-ascii?Q?0QEgGaSJ3QUtSkinfp4kxVZ48XKhxqA1Q3acQxGW/tRd2Xd7942B9dXgE+Z4?=
 =?us-ascii?Q?PyaRQBKGKN5GhVlG0Jsj38hwz/aruAlt7JX93IW1N1mK7V0yD1ONMjRMk7sZ?=
 =?us-ascii?Q?mw/h8NV/HZh2UArphpVHjzU1RsOc/9y7klJNuOUA1CtqL8VaLBJ9+h4vs4AC?=
 =?us-ascii?Q?lGs7DLXkKxIEQ823Nwu3jytpxLZVysVN6H8eCIGAWVnS7btzZrHgxr2F4YWo?=
 =?us-ascii?Q?q1NHOZjotfq5SVbc5jnLiIUWYqRXcCGNBGNDuvXKILHd7YhUatmOmogHETRI?=
 =?us-ascii?Q?P9s/78IJh5WmJ31yl4qYFPZuUstgwBdBB13IePOWGHYWvupx1YbqaBNQXEbg?=
 =?us-ascii?Q?EFA+7f8jNZkHLFN49Jitp9mCLCuv8XRhhOJ80KOs0Nodyggkk0y4SdQ35lT5?=
 =?us-ascii?Q?7c7NKpMRjoNPyJ2JmB7nTbKq/g7e1MEXyW6mRm/XGc9FDgqKxl8bOUSZYJxX?=
 =?us-ascii?Q?EZn+sw6OFrSEpBB2EUKjwzvl36+PVatAT/6MPwwMTynEOrRfqbqTdzwzHGaT?=
 =?us-ascii?Q?SGcTXnaK2CxSgMBs4u8TnrR+S4ax8Y81R0h6ZDelg9pdvaaWANtmB8iW6Mp+?=
 =?us-ascii?Q?bw=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7da0e7e-b766-4f03-abf6-08da79da6302
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2022 07:40:09.8547
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zXq+9diOVgxf12nhQxgP6TG6MWexfK5bdamhTzR2scJ0wMlfmeJn032vy4lJ3m4tn41P9P0j6/Pr9fBkbP4e1FvFa54gL1ACh+oFBTpE4nw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3070
X-Proofpoint-GUID: 3pu6b_jflRsec1OcOpKfqwRvk4P4-uBf
X-Proofpoint-ORIG-GUID: 3pu6b_jflRsec1OcOpKfqwRvk4P4-uBf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-09_03,2022-08-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1015
 bulkscore=0 phishscore=0 priorityscore=1501 mlxlogscore=921 spamscore=0
 impostorscore=0 lowpriorityscore=0 suspectscore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208090034
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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
[OP: adjust for 4.19 selftests]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 tools/testing/selftests/bpf/test_align.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_align.c b/tools/testing/selftests/bpf/test_align.c
index 7e057b47b27a..30bca0d82ad3 100644
--- a/tools/testing/selftests/bpf/test_align.c
+++ b/tools/testing/selftests/bpf/test_align.c
@@ -475,10 +475,10 @@ static struct bpf_align_test tests[] = {
 			 */
 			{7, "R5=inv(id=0,smin_value=-9223372036854775806,smax_value=9223372036854775806,umin_value=2,umax_value=18446744073709551614,var_off=(0x2; 0xfffffffffffffffc)"},
 			/* Checked s>=0 */
-			{9, "R5=inv(id=0,umin_value=2,umax_value=9223372034707292158,var_off=(0x2; 0x7fffffff7ffffffc)"},
+			{9, "R5=inv(id=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc)"},
 			/* packet pointer + nonnegative (4n+2) */
-			{11, "R6_w=pkt(id=1,off=0,r=0,umin_value=2,umax_value=9223372034707292158,var_off=(0x2; 0x7fffffff7ffffffc)"},
-			{13, "R4=pkt(id=1,off=4,r=0,umin_value=2,umax_value=9223372034707292158,var_off=(0x2; 0x7fffffff7ffffffc)"},
+			{11, "R6_w=pkt(id=1,off=0,r=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc)"},
+			{13, "R4=pkt(id=1,off=4,r=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc)"},
 			/* NET_IP_ALIGN + (4n+2) == (4n), alignment is fine.
 			 * We checked the bounds, but it might have been able
 			 * to overflow if the packet pointer started in the
@@ -486,7 +486,7 @@ static struct bpf_align_test tests[] = {
 			 * So we did not get a 'range' on R6, and the access
 			 * attempt will fail.
 			 */
-			{15, "R6=pkt(id=1,off=0,r=0,umin_value=2,umax_value=9223372034707292158,var_off=(0x2; 0x7fffffff7ffffffc)"},
+			{15, "R6=pkt(id=1,off=0,r=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc)"},
 		}
 	},
 	{
-- 
2.37.1

