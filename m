Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3E9C588EED
	for <lists+stable@lfdr.de>; Wed,  3 Aug 2022 16:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236070AbiHCOun (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Aug 2022 10:50:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236547AbiHCOuj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Aug 2022 10:50:39 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6B7BBAF
        for <stable@vger.kernel.org>; Wed,  3 Aug 2022 07:50:37 -0700 (PDT)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 273BxHKI029871;
        Wed, 3 Aug 2022 14:50:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=VXd+KF3iD/Iy3/T1m44NJelKX/x1Aw5aJOfggjX1ixc=;
 b=WsuLhUObu+T+38yb+oswlEhhjP8UKB5MNtU4NaYj4/W1zAukFZLdvIhDt4hpIe5GZakC
 wOxTxGrR0ijOZ4kxgqeSZAxMfX0gRAN1UXvk6GVkpqQkfBLpu9ahcRYHKUTiPNr7ad5u
 i/E0U8fPWoceqEGQk/tHBjvVbcTe+jIq2tH19K2aeQ/cQL2y/eTCODg1GxL1B8BQISVh
 m6HOB/PM0PIDxx0Rgg9i4Yye/zdXFSp04geLSSkMqC+9wPSeETtpxVpxGqsNZWCU46rt
 C/An7KwivXXGl1ke5IhwVmHIJLqeZI7PWDC7uyV5BQpROGKjXocZHQeqdoBjT89vgp5a wg== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3hmsv23cm1-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Aug 2022 14:50:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DKZSbW79lBtoxBJnv1DeOtayxCkFuESgoh7vH0jGjv45qPBhGiPp+LnDI/Cy6Lzvh+1YxM4vpTa/VWP5l8rknDoZO4oCP6zqUeyVBFgFEI2Tl2TwrHI0/KaJM2Frm0uZv+Viz+LUl2J+18VrvnW/SriQpTjM7urKepenOcERxyfNFNq11RhSNzQuta97S+eJ8kSeSxIkZs7ugSXeOr1SWWZdwzI2QA58absXpxow5MNRx7skOQ1NSVxBGT1gIPWicHy3KL+9Eacp0MPpFevSdDiKmsAELLoKGl3ssERZQz4C9eY/yiYvI5W+5hXg3QzMKXoJnfL2MODHeWtBB0jtuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VXd+KF3iD/Iy3/T1m44NJelKX/x1Aw5aJOfggjX1ixc=;
 b=Tz8NLPUfpViG/AanGTFExfg4/v1YyGAJnILX/ZEdp1RUQRCIQe3yopKRVfmwQzM+NrrbvusUoPXbpvC2KOlLKU5KVk2USTnlpcKnf7c9B5qgiDsXmZuNu4AxRYYdA0DlUypdNg1liI3vP3WzuxieCphFxUluJyLqLzIKLlf9/QsVYWIXGPSPW9+qNpVClX29HJn8nv8g38ud3JxFqAXuKM/1oDidqT85wkuI8a88TvOZ1xJovbPcMYg5uDKc7znXxDMtQ2pjTZQ0w58op1y3RtBnflFBMvu+20AHNBmsXuhtLYi9+jumYbQ6FRYFr9HLEllYEs8gtRUx4V7k/00jMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by BN6PR11MB4067.namprd11.prod.outlook.com (2603:10b6:405:7e::35) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.14; Wed, 3 Aug
 2022 14:50:22 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::e500:5c9f:fb41:287b]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::e500:5c9f:fb41:287b%9]) with mapi id 15.20.5482.016; Wed, 3 Aug 2022
 14:50:22 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 5.4 1/5] bpf: Verifer, adjust_scalar_min_max_vals to always call update_reg_bounds()
Date:   Wed,  3 Aug 2022 17:50:01 +0300
Message-Id: <20220803145005.2385039-2-ovidiu.panait@windriver.com>
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
X-MS-Office365-Filtering-Correlation-Id: 5cde2daf-f482-44cb-c3cf-08da755f7dda
X-MS-TrafficTypeDiagnostic: BN6PR11MB4067:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ghVZpYmhAu3JB7cw247RSyPmXxuhvQummpmOQstQPdKS+aIlt/koIvy3IKnpGUMDigS7j8aO/Mv335Ku/V1shRO2m1A4cRZxHJv07n8quz42QU4tl/avYEInauc6YXywGbBR9Ndx/X+kMYn/ETdKP8sV+/kuvFZ+6uoUz27zBue/nLnObh3qxzwiPeDHrhVMJN8dE4bS7JRRA6wwhL+vGhGwjl5O59wBmwpXhBNVgaswUw7QW9m4l36o7wi2DSX2s0xF6RYpV8iWbr1jRLNEwIVlkBivNeGMuxCq2Aih+xzs/QlfMCXm06Hphm1gaAKU9NsWVw4kdfM8IqzONRhn2z+Nf827uVxHOXtF+0r/PC5jtNUVgobtg/88xiomwiCv3rKkDfuABdceAF2bzFJSooUqtgSLjf1/RJpXG31RaVy16QBhDSwjOY8P08hAJ2v+445D146QNi59Of54sZzRQ3a+nIQAPD1WlyZuoorxegceP9cvRQmx/wV1OQRqxQgM1UMKcJFT1na338bYcLM2GfoHkqXz2zPxhjZll4hIZc8Wo6GWY+/aELfmZiskNp24gvzw1lJ09BNobuRhzOiamOpMOc0I/DbAHodkfbmoccuc8mwPJc1M+KUErpdowYxnFuUQVri1KY8Mz2go9kVxVH4YCiZMGjdcvwCOJqdblJ03qOV5OnSRK6Yi9x7i6lSHaoqb+mWsQnoota6cdwV/jMvUl4OmBk9rrhiwwZI4HRWsqkLhoQiGND7+uaEf5N4wJy9QxIonSLuQNLcPhNHlX4KnB0WbEfadMiISMXKIMYkPvPfCNuedNQ0CG9lN/36SZ9VXmtDKZll0Dx5qkiyOzA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(39850400004)(376002)(396003)(366004)(38100700002)(44832011)(66946007)(966005)(38350700002)(6512007)(26005)(6486002)(6506007)(52116002)(6666004)(41300700001)(478600001)(15650500001)(66476007)(66556008)(5660300002)(4326008)(8676002)(2906002)(86362001)(8936002)(83380400001)(36756003)(54906003)(316002)(6916009)(1076003)(107886003)(186003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ab21lohmPwpWy9ld8Hfm41tSeEi3Y/5+aMu+geiQIdRkGC1+I95GAWg88Qav?=
 =?us-ascii?Q?pyXQD04AHauywHocaVc8MSrm6Er1mOYf1ovhbZcCfj61NoN7FqGvIGxAM5/I?=
 =?us-ascii?Q?REgm47Ym5JipCA6JOxJpP20Ht3NpIAFNWrr8mjC9rrP1VZuYi1ztsMyv6Wf+?=
 =?us-ascii?Q?rldeT9zwis6QMOrQLcIXjq9gB7Cgm1t7hCxlWduEoAMy/1O5htO8BNlSrOlF?=
 =?us-ascii?Q?32I9oHde/jP3IKKmxvGxWdzJkLqCYnKq1DZ9veaBb9zKf6XjzTziHrnLxEUv?=
 =?us-ascii?Q?dZzRhFaJWNNVc5mudG8d8KH4Qn3H6OgM3KjVwWR/hszEmiVK7jH0AT68m7/d?=
 =?us-ascii?Q?RER4X9R2rP7F16+c6yFB/yIDrddvdn7pzCu01utw1SKL0fuiHt7Wy4aJygrW?=
 =?us-ascii?Q?lX9sFFRM0UFsGeQrixEcwkVUxr2xOrJIcMpEykNa+LeLBgO8O0BWhsU+lhnh?=
 =?us-ascii?Q?hj2woM0Pp9Ww1jyYQKQaJRJC9FoFCGVV3ZidLNKd2rTDlnmlqWZRTUIVndBX?=
 =?us-ascii?Q?pSA/zFgBLuEaCABdBWGy8IvcBBhQjhAs1/KwpQXE3WAVwgp4zNUtE4nrdkXV?=
 =?us-ascii?Q?Dc7bFirQ434c2qzn0+x+f1BLWUlWQIGl9eNxHeozjQtErK++YeD3AyPLz/z/?=
 =?us-ascii?Q?u9RKjxf9kb0edeBf4oHvLOO0A7RDrKZwRu9/rPfeixGs8UXivczpKn6bjkNh?=
 =?us-ascii?Q?cGCDckEduhOnb91vUyaf12wqS5dVCYTx8b1ZCB1Wgicpw+abLbmNGSqAkfVz?=
 =?us-ascii?Q?Yqiyif/EaULJ99QpXfq/B9d5LJJFQ3Pi89IAO4A0YDGFPmjVgYEGhKK5N/C9?=
 =?us-ascii?Q?XYiNk1E9QGfiIMAx97Zt8ad8g1XfCYpDMJ/HBqquEJYvQzCuUhyODOAWifkn?=
 =?us-ascii?Q?bmsvJsgtWEd909qlbOGTk9FdPGO2el7FAYCWqHGtFGHQ+2sIvYFDaNnTDopm?=
 =?us-ascii?Q?qWf5msEIi9YGYI6yLf71nTOf3kF+d6MvrCKEGh/fylGG3dQnMORou7hxK+e5?=
 =?us-ascii?Q?X5gRw9j83Q3dgpW6mYS8ynHSBc3mX6V/7PIRrkIyzAn6GFbArSlhYF9mJchv?=
 =?us-ascii?Q?3bxyNLGRNHTVm1T/T8IrVrp6DVHHUTIs8xCxIokvGj+GJxaaBbXpRvDmsyi4?=
 =?us-ascii?Q?mgskaiPf7GMn793boRl0D3pcyqzBOapSgwibctKaROZ1DccLcY3tR7zJpDSk?=
 =?us-ascii?Q?ulX6JkCf6QqNY9mns5vwJzsUgldynjX+NwF9Fq9DGyxyDSFgV0kicaJA3/AM?=
 =?us-ascii?Q?T9Y0DZ6muMVYA4igop3T5OAqu9NzE8ZL7JPFKpwaHcPF2Q2s7euBBWR481y8?=
 =?us-ascii?Q?Ux8LsumPWBVBW6HwqcmC+Q2PMYjDd+E5YLVMgaPfDVammrC07SU6dFv10D5e?=
 =?us-ascii?Q?oni1zIrvHKSt5RZbWDpA2FIOhgCAjSwiTWAJ+uXCu9ZeMrCfVjkF2msjPohi?=
 =?us-ascii?Q?A168JL3LWMLu4fmkYEEUWugJvTJOpFdHDSvGkpG4fQu8CIoXfr2IPfM2mu/d?=
 =?us-ascii?Q?EYniNRlWXbblqA9k/QHwRTKUwxGu9bUY2ftKGdjbbXs+mc9INpPCWtbhrYmP?=
 =?us-ascii?Q?EfvJfuXjSVae8/anwmj9B77z9E3OFJm2hiY6Am+fM3uPaBLw/SkiGeEW6qy/?=
 =?us-ascii?Q?TA=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cde2daf-f482-44cb-c3cf-08da755f7dda
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2022 14:50:22.2209
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7kiVIA4KNVO4UG8my4CtO9ncrih4zhxo8bjBmPz8Ry6KHXV5d4Iyj+98tUk1HP/nIr56Hc+fN0yvWJxcN/wZnrg/YmLHx3OOX+MCyRNzpEg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB4067
X-Proofpoint-GUID: DSQC67696PugghbF1ldPVzprdq32tLJz
X-Proofpoint-ORIG-GUID: DSQC67696PugghbF1ldPVzprdq32tLJz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-03_03,2022-08-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 clxscore=1011 adultscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 priorityscore=1501 mlxlogscore=928 impostorscore=0 lowpriorityscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208030066
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Fastabend <john.fastabend@gmail.com>

commit 294f2fc6da27620a506e6c050241655459ccd6bd upstream.

Currently, for all op verification we call __red_deduce_bounds() and
__red_bound_offset() but we only call __update_reg_bounds() in bitwise
ops. However, we could benefit from calling __update_reg_bounds() in
BPF_ADD, BPF_SUB, and BPF_MUL cases as well.

For example, a register with state 'R1_w=invP0' when we subtract from
it,

 w1 -= 2

Before coerce we will now have an smin_value=S64_MIN, smax_value=U64_MAX
and unsigned bounds umin_value=0, umax_value=U64_MAX. These will then
be clamped to S32_MIN, U32_MAX values by coerce in the case of alu32 op
as done in above example. However tnum will be a constant because the
ALU op is done on a constant.

Without update_reg_bounds() we have a scenario where tnum is a const
but our unsigned bounds do not reflect this. By calling update_reg_bounds
after coerce to 32bit we further refine the umin_value to U64_MAX in the
alu64 case or U32_MAX in the alu32 case above.

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/158507151689.15666.566796274289413203.stgit@john-Precision-5820-Tower
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 kernel/bpf/verifier.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 34262d83dce1..f705d3752fe0 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5083,6 +5083,7 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
 		coerce_reg_to_size(dst_reg, 4);
 	}
 
+	__update_reg_bounds(dst_reg);
 	__reg_deduce_bounds(dst_reg);
 	__reg_bound_offset(dst_reg);
 	return 0;
-- 
2.36.1

