Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 774235A4BC4
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 14:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiH2M1a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 08:27:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230502AbiH2M04 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 08:26:56 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B877BA3D19
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 05:10:40 -0700 (PDT)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27TAgb4I012990;
        Mon, 29 Aug 2022 04:51:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=9B5ViggIdQ3VJlE5Eifr1SKX8RbYGTAmKipiceFfLoQ=;
 b=Emx2+Hb698DzB5ocVuIvX7eIN9k8aqVTY3l4BOu8CZOWwTnd1Gntq5E+u3TFiMLSA61o
 h2PSuGPB+deFePbVAeyW6Jjr8uRIr3fGYbTHPkgHBV30wFnksmPg+xybc6KVgZm5RXxS
 ZratksUxn4Yo8v41VNNOxxiXuTkPm8kA/vQQ9HfMqBvk9j/IU/AL32YxDYShOT8Bh9+s
 OnyHpWPVSWWA7jL+bP++A2Cvz1+7rj3JAsReWjGmj3JypiHNpXMiHFPRRtWmo/+MvffX
 pf4TCpjSJuLVvk4irDPSsL7ycXZmUrl1kb2TDnGUp/28GnKknmgzhqw0x+taoZSHvBp9 ew== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3j7jsk9b85-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Aug 2022 04:51:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bPnBLVYNDEJAyWIltHVmqCiat22qSLyuIl1F9DzwFxKV9QLt+JLFVlrTSd9nzgcqABDWnYvHKxpTuYtV4a2Mnr+r5ZEYT7F00Zt0+Ki68xjZZwxvdSdx1F6L4Rl3gCFaPgg5KSuUlb50NhtHg5b7e/zqOLyZj21kc4QyAlBFc/VukLLQOQo6N49UQQWvd0rs8gL+Ljp0njSj61LVcADzWzNpHXaH0PEXyBoPxHhVdve7wuzsTT0NP8twa1aYVD4HIg8v1de+2R88ob4j9iYpIfAr4Xb6wOgaIxNH+mB7YHgbrfArbjxAfgoQZxhs5E01YDstEmxRId5z6K+658h3Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9B5ViggIdQ3VJlE5Eifr1SKX8RbYGTAmKipiceFfLoQ=;
 b=iR9+MZ14fdhSKib7tqAb819jtvJ1WEgDqAVGJIwGiXifiWcVhGZL2ANsZlX9b/LSlEWYu2t7Yv4CWnWBbyYLBs1QqOmU7k1osHFeE6Iz6drLbdN5IxUBumzUjXIGhz+pZqAmYWEfZrawgia7yrknHHbeXNKz+pCRnNWbdIRa147mQnPr3NSn9dSueNqnLfbyMum1mGEKvbqrIkQxRrh10pJc+ePNNRCtG/p8tVofDOgp8JJJoNcysDMXQdgXvTz6TVKHP3nrMo3mG1JV9WqxvGo3Hw5ZW1RDaJJUz2GjqcBId4q7YCMF+TjQoQT69YoyUALDVnJcUm6/l7/Gzdgftg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by BL1PR11MB5366.namprd11.prod.outlook.com (2603:10b6:208:31c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Mon, 29 Aug
 2022 11:51:16 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::b4a9:c48a:51c2:d3fd]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::b4a9:c48a:51c2:d3fd%5]) with mapi id 15.20.5566.021; Mon, 29 Aug 2022
 11:51:16 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     raajeshdasari@gmail.com, jean-philippe@linaro.org,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 2/2] selftests/bpf: Fix test_align verifier log patterns
Date:   Mon, 29 Aug 2022 14:50:54 +0300
Message-Id: <20220829115054.1714528-3-ovidiu.panait@windriver.com>
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
X-MS-Office365-Filtering-Correlation-Id: 99a36b38-a07e-40cf-fc93-08da89b4c7bd
X-MS-TrafficTypeDiagnostic: BL1PR11MB5366:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yQykkVmnpQS4TbCQcDjt2QXd1oLDS1Bbm6PJXHcoSRDXtpeqAcNvEZJPvZq3m9qDyAixugVRKLRUX5GyeP2ZEZPxCuxMQuEYRc0GU8nxd/DyY5lZ1qPGewJwcpWd2ijGZhX4JiSaxtR3TP1wPrfS8ceqK4/lP2/kItv51HqyYKnh8J/xj6z/Plt6eiKW+Lr0WmTqzLKYDkooe2Kt+4tN4o3mZmZuNlaoBS74bwBw0ITaKXnuFgkPzAzDS00lm9mIE5ng9g1Numy8UzE6K6RVR+VnRR+HXt6MQLTgJOCwc4Gw5QlcC363rn/fqfCIcOxv/nB1k3AeqHF52q+7yl6v5O5+UlF9TSU7BvuaWcsouBaVClKOjKOMaOhE9A5BKtBXNw1Tn5mV/d+INx90o4EbK/KU1F8Sd3MAFfmAxSGw/0VoN1/hl8feV85b87QJUu8BPduvv9A9rjebFwWQ2oglPcTHkAdj101i7+NMGbouuKvZorNViwWrCZKPMvlT51SlvITXD0F+3iXSJS7yNXn2anLaJHu8ib/RyPXRGK04sIsyXr0pBxRtX7NsxspE9LwlZEHh3xvpJxyPrYf3m1tlfH34H+IYMGRgyceZmhko544Flyey9ZxgBkucrXJx5Yp7cmcRoDXBQ7pvePn7cAUf1zwR7RY+ndRJ6jp1YmkTdMRIudQUzWQtpjLXcaLeQ+ZBgcDh4V8QDUTrDYqlqzqqEfuTOuda/n7G5FXeHAAUqJHdk3u5ODc1/bDuvnZLKsJ1sEIisd3Im0zzCX7QGaHIoJpscFueD/bE4DK5JN+aX4A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(39850400004)(366004)(346002)(396003)(376002)(54906003)(66476007)(66946007)(66556008)(5660300002)(8936002)(8676002)(4326008)(1076003)(44832011)(2616005)(316002)(36756003)(2906002)(6916009)(6486002)(478600001)(966005)(107886003)(6666004)(41300700001)(6506007)(26005)(38350700002)(52116002)(86362001)(6512007)(83380400001)(186003)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/MXn7fIVq4WVmaQGFJiq4QMi0jttUY3Xpo7poHe7/oRNske1y8mfiU71HGLF?=
 =?us-ascii?Q?DYN9ru/iMmJFJRs4oes8FHllPsFloQ4bHyFf/WaI/VSMS3L7K1xU4RVXSgYw?=
 =?us-ascii?Q?fX9HD/MHdCC8fsaCSdbUb+9cJ91sCdDzFBskq3bC4qmVl+YTei37ml15/ezp?=
 =?us-ascii?Q?o7wvnCUhtxrc+1WzFvTMDk//lzMiF0a4opSvLBNDbNX3SIz6sqQc0uoS5lED?=
 =?us-ascii?Q?7zPuMgqMDjsj7MduWMBUVz1CEAo3p5/JkA/4LGlGltiCpKLiGehERBXOv3Id?=
 =?us-ascii?Q?2zrF3cSBgK4qvEmT3YeRSrX+pHjMgLWFR2/MM+5FBhRQ4J/eblbS+/++/GH3?=
 =?us-ascii?Q?cD5Y1zOSnngGoEM6a/WgMmjnMgk1V1HiN+IsSIlS2vvSHFJBoZ5IbfDg8kLu?=
 =?us-ascii?Q?hdEzTtcfU3Xq3vvzuEFntZYo5f/g6g3Il7T5LjXgn8GfJZZyYQijiZNsBtRv?=
 =?us-ascii?Q?dNz7/EeVvQ8hxWU0QnXdSsMq1bCFrGQFLuhLjPvaDFz7wbYQy6HSGtu8AfVN?=
 =?us-ascii?Q?Sx6JWR3sUHcL+9odjBUA0xvMK5guJ60MF8uSl2yV4QlVRP9sPtN20jiV8KBd?=
 =?us-ascii?Q?vsiyDM78SbXPintKO/ogLZ2hZEun4dy+C9ECt8kK566ZzTl7hMlIbLIrzVT4?=
 =?us-ascii?Q?4QJZnbxvrNlpTrSoQwrCrRoZW4bTtg25M0kY4Aa5t+xRfiZvD/JhqyWeQx6r?=
 =?us-ascii?Q?13pd0Fw8NzYSletT6vrSexksF5X3ZbfEKbdu0ie515m1UCBcV1uup8a0qiF1?=
 =?us-ascii?Q?mM41KF3fPBNi/+dr1YzQl55VfjV1OVjRJekyTqIjrOlRCxkN6CTJ8IvEs57S?=
 =?us-ascii?Q?Bp81bv/pil0CQ5cR1VMNDy3+ji7qlV+mgZc755A/iQ7Y2RqvLKKN/ruhbj9i?=
 =?us-ascii?Q?ASulexjtH5kZnKeg6HImgWPIbS09NvCxajHDq9luyMeudYkjFS8+zpY1aqKJ?=
 =?us-ascii?Q?r6ifIbMK5vyIgbopaTZDRJ1+Mxz9V0mQQrss1A/XFFRUGsn6L7TRxpJM+nbo?=
 =?us-ascii?Q?hZIQIpf/rmzQKo+iB5eNrhYj5eg8suxNDvDlaiJ1/bEQ4GL6uLL3d3CPbsXk?=
 =?us-ascii?Q?E1gASVjFyGAnbcxNq51sR1t7s0qZwWL6s+xNOVKvR9Z0+hjAlvtY+DJA+ADH?=
 =?us-ascii?Q?qirifUOK9mH6E9BmfepcAyhUiR4Gd1F2RNwYyP14wGHQtVCkcDvcpAql/3JG?=
 =?us-ascii?Q?DH4LkZ9Olvd+jF5/jHFT2WWvwjscejfhr+fmbemNcLMoXcTeDzIRLDQqP7ST?=
 =?us-ascii?Q?wMEIWLB0fdtwoxlfnoo5BrVIKGU7CAj2hE1qHv0xbPsTYlJGr035tBIixrTt?=
 =?us-ascii?Q?5CtKFR31B9KahQej9SN7RYSjgxJ0nXZxvnp2tEv5mZQLoZQJcixSfQMgXx5g?=
 =?us-ascii?Q?79IT25RFcZjQsZc5fgGwbFKmr/fnnBZQVQO9Vo8bBCXgi2dXgeQVxGyNaI33?=
 =?us-ascii?Q?U9IzZmJcNSIIvNsL3DQE1in7qiGIC4xPS5H4p+ZBTGWeUPDiqZwmT2GJkOMJ?=
 =?us-ascii?Q?oD/kqRVNvGujR25Km0uCGT+lMteS5iIjcHVynvBKZgu1wQEJatOhyFbQOeeK?=
 =?us-ascii?Q?typixvFtPnw19vNwoE7NuTBxtpruV+TNG5Eg1rRaU8l3O9w6aZkwjFIoMHPE?=
 =?us-ascii?Q?Qw=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99a36b38-a07e-40cf-fc93-08da89b4c7bd
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2022 11:51:16.5674
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NwefTThTw2iAv0s6XJLiP5KttXYEV5igpqQipsRXldeTxJSl5zWYRtMRaH2pO3NTcsaX88gs+60EU1ii8+LnKT+LP81wOH6yf3eHSweubjA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5366
X-Proofpoint-GUID: jZr_VhUmxp7PzCDKLLG3nSxirQ8mKpS8
X-Proofpoint-ORIG-GUID: jZr_VhUmxp7PzCDKLLG3nSxirQ8mKpS8
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

From: Stanislav Fomichev <sdf@google.com>

commit 5366d2269139ba8eb6a906d73a0819947e3e4e0a upstream.

Commit 294f2fc6da27 ("bpf: Verifer, adjust_scalar_min_max_vals to always
call update_reg_bounds()") changed the way verifier logs some of its state,
adjust the test_align accordingly. Where possible, I tried to not copy-paste
the entire log line and resorted to dropping the last closing brace instead.

Fixes: 294f2fc6da27 ("bpf: Verifer, adjust_scalar_min_max_vals to always call update_reg_bounds()")
Signed-off-by: Stanislav Fomichev <sdf@google.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20200515194904.229296-1-sdf@google.com
[OP: adjust for 4.19 selftests, apply only the relevant diffs]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 tools/testing/selftests/bpf/test_align.c | 27 ++++++++++++------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_align.c b/tools/testing/selftests/bpf/test_align.c
index 3c789d03b629..0ae7a7415414 100644
--- a/tools/testing/selftests/bpf/test_align.c
+++ b/tools/testing/selftests/bpf/test_align.c
@@ -359,15 +359,15 @@ static struct bpf_align_test tests[] = {
 			 * is still (4n), fixed offset is not changed.
 			 * Also, we create a new reg->id.
 			 */
-			{29, "R5_w=pkt(id=4,off=18,r=0,umax_value=2040,var_off=(0x0; 0x7fc))"},
+			{29, "R5_w=pkt(id=4,off=18,r=0,umax_value=2040,var_off=(0x0; 0x7fc)"},
 			/* At the time the word size load is performed from R5,
 			 * its total fixed offset is NET_IP_ALIGN + reg->off (18)
 			 * which is 20.  Then the variable offset is (4n), so
 			 * the total offset is 4-byte aligned and meets the
 			 * load's requirements.
 			 */
-			{33, "R4=pkt(id=4,off=22,r=22,umax_value=2040,var_off=(0x0; 0x7fc))"},
-			{33, "R5=pkt(id=4,off=18,r=22,umax_value=2040,var_off=(0x0; 0x7fc))"},
+			{33, "R4=pkt(id=4,off=22,r=22,umax_value=2040,var_off=(0x0; 0x7fc)"},
+			{33, "R5=pkt(id=4,off=18,r=22,umax_value=2040,var_off=(0x0; 0x7fc)"},
 		},
 	},
 	{
@@ -410,15 +410,15 @@ static struct bpf_align_test tests[] = {
 			/* Adding 14 makes R6 be (4n+2) */
 			{9, "R6_w=inv(id=0,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc))"},
 			/* Packet pointer has (4n+2) offset */
-			{11, "R5_w=pkt(id=1,off=0,r=0,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc))"},
-			{13, "R4=pkt(id=1,off=4,r=0,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc))"},
+			{11, "R5_w=pkt(id=1,off=0,r=0,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc)"},
+			{13, "R4=pkt(id=1,off=4,r=0,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc)"},
 			/* At the time the word size load is performed from R5,
 			 * its total fixed offset is NET_IP_ALIGN + reg->off (0)
 			 * which is 2.  Then the variable offset is (4n+2), so
 			 * the total offset is 4-byte aligned and meets the
 			 * load's requirements.
 			 */
-			{15, "R5=pkt(id=1,off=0,r=4,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc))"},
+			{15, "R5=pkt(id=1,off=0,r=4,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc)"},
 			/* Newly read value in R6 was shifted left by 2, so has
 			 * known alignment of 4.
 			 */
@@ -426,15 +426,15 @@ static struct bpf_align_test tests[] = {
 			/* Added (4n) to packet pointer's (4n+2) var_off, giving
 			 * another (4n+2).
 			 */
-			{19, "R5_w=pkt(id=2,off=0,r=0,umin_value=14,umax_value=2054,var_off=(0x2; 0xffc))"},
-			{21, "R4=pkt(id=2,off=4,r=0,umin_value=14,umax_value=2054,var_off=(0x2; 0xffc))"},
+			{19, "R5_w=pkt(id=2,off=0,r=0,umin_value=14,umax_value=2054,var_off=(0x2; 0xffc)"},
+			{21, "R4=pkt(id=2,off=4,r=0,umin_value=14,umax_value=2054,var_off=(0x2; 0xffc)"},
 			/* At the time the word size load is performed from R5,
 			 * its total fixed offset is NET_IP_ALIGN + reg->off (0)
 			 * which is 2.  Then the variable offset is (4n+2), so
 			 * the total offset is 4-byte aligned and meets the
 			 * load's requirements.
 			 */
-			{23, "R5=pkt(id=2,off=0,r=4,umin_value=14,umax_value=2054,var_off=(0x2; 0xffc))"},
+			{23, "R5=pkt(id=2,off=0,r=4,umin_value=14,umax_value=2054,var_off=(0x2; 0xffc)"},
 		},
 	},
 	{
@@ -469,11 +469,11 @@ static struct bpf_align_test tests[] = {
 		.matches = {
 			{4, "R5_w=pkt_end(id=0,off=0,imm=0)"},
 			/* (ptr - ptr) << 2 == unknown, (4n) */
-			{6, "R5_w=inv(id=0,smax_value=9223372036854775804,umax_value=18446744073709551612,var_off=(0x0; 0xfffffffffffffffc))"},
+			{6, "R5_w=inv(id=0,smax_value=9223372036854775804,umax_value=18446744073709551612,var_off=(0x0; 0xfffffffffffffffc)"},
 			/* (4n) + 14 == (4n+2).  We blow our bounds, because
 			 * the add could overflow.
 			 */
-			{7, "R5=inv(id=0,var_off=(0x2; 0xfffffffffffffffc))"},
+			{7, "R5=inv(id=0,smin_value=-9223372036854775806,smax_value=9223372036854775806,umin_value=2,umax_value=18446744073709551614,var_off=(0x2; 0xfffffffffffffffc)"},
 			/* Checked s>=0 */
 			{9, "R5=inv(id=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc))"},
 			/* packet pointer + nonnegative (4n+2) */
@@ -528,7 +528,7 @@ static struct bpf_align_test tests[] = {
 			/* New unknown value in R7 is (4n) */
 			{11, "R7_w=inv(id=0,umax_value=1020,var_off=(0x0; 0x3fc))"},
 			/* Subtracting it from R6 blows our unsigned bounds */
-			{12, "R6=inv(id=0,smin_value=-1006,smax_value=1034,var_off=(0x2; 0xfffffffffffffffc))"},
+			{12, "R6=inv(id=0,smin_value=-1006,smax_value=1034,umin_value=2,umax_value=18446744073709551614,var_off=(0x2; 0xfffffffffffffffc)"},
 			/* Checked s>= 0 */
 			{14, "R6=inv(id=0,umin_value=2,umax_value=1034,var_off=(0x2; 0x7fc))"},
 			/* At the time the word size load is performed from R5,
@@ -537,7 +537,8 @@ static struct bpf_align_test tests[] = {
 			 * the total offset is 4-byte aligned and meets the
 			 * load's requirements.
 			 */
-			{20, "R5=pkt(id=1,off=0,r=4,umin_value=2,umax_value=1034,var_off=(0x2; 0x7fc))"},
+			{20, "R5=pkt(id=1,off=0,r=4,umin_value=2,umax_value=1034,var_off=(0x2; 0x7fc)"},
+
 		},
 	},
 	{
-- 
2.37.2

