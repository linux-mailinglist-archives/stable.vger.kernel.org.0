Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F75D588EF0
	for <lists+stable@lfdr.de>; Wed,  3 Aug 2022 16:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236284AbiHCOur (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Aug 2022 10:50:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236279AbiHCOuq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Aug 2022 10:50:46 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC4DCC66
        for <stable@vger.kernel.org>; Wed,  3 Aug 2022 07:50:44 -0700 (PDT)
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 273AwRKL012049;
        Wed, 3 Aug 2022 14:50:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=xK59GBDZoWxHcy/KtON5yw8bkN75F4+FfqHT6FuVNAI=;
 b=XNWVxEcE+vrnFf2ttJNQyXVv8410b7otV2E5qd7IVRA7ZRrE7COibtH+XTrZL2/3MYAT
 kjG8vU3UGVUcZrEah/h1JuZXbgzwiyRcqeFauTNfIgXbjqIZ+eG1TwYt7f2P/4SUa2mP
 yZ8e68E7rAoOFtpaZ//OL1mBvVo7FUfZFeI7E/84lzyVY7tDoBcJLNoB2UhfurtxMygI
 R0aT26SaFjEVOTQYztwmSnFa5OEa5ykEu0JlQnbIn5fxIWmy/18z6uTS3dwpKu9+i8+j
 hhAsc+rJ6H2cwlUZUWGSTuwKLu/9WLlMdcmlGir6nJIrImbvd7iddo4W0wU31DxJlwVC xQ== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3hqdbvrhkt-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Aug 2022 14:50:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K6CE9qv2GxIHjPfd5Nf0EeLhDDvkU6FcyubCuxZfDiVxtRSeYFVM0C9/HrHp8Nd9Q4imBqchnOXsEBELRYVnbvOsOJHbvUmDs1m2Bp10gkiBPozw3SAylh6jdZByUkhtZtVhBvRohMB2HCNT6MsuaqUYCZRhcdsN75hnramq/othgR8BCpAJEvuvxbHEbtx+dnMHrx22AyenwcSPBqDwhB0xvof6ntSb7UISXVbeySoqE3fqNpXLS9NGgX+wJMajPI7Mbh9EDACDziiJJncZmJb1GrdZ69aVl3vww6GyrVAQWVMNPkJYRGQBcGdleSaLxqf1lzzuKdAhoiEtP4wQvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xK59GBDZoWxHcy/KtON5yw8bkN75F4+FfqHT6FuVNAI=;
 b=KlmJrJzjTKfBxrZSUYG3FqQMgnVDGjrLj/4tdK9i178jJ8EmMyzZ4NQdY6mLjH4Aiq/MQ+Uy2RDBoIlHNXfSIF2vCvPqEPa7wfKnlXE9j1FqMag/ktem/S5dnlqHgu+1FP60/Dd4txPl2kxoOB5kX1lGBFoSO/j4uHcz0E5+blaySNtFzml7W8d7JpW61Y5Q93obKBmXpYCFJtq/7BdFu1Mx5zcKE4mSTno8rHUUfyugYT5blNmtoe5bFDhP6ajwy95mbpqs8s8Feqi+RILcwVCPb4lkqwcgE+yveMHwoDzilMxrKhaPCj8fcECt4mHBW9OGhJNnyKApzdTZJX9aBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by CH0PR11MB5505.namprd11.prod.outlook.com (2603:10b6:610:d4::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Wed, 3 Aug
 2022 14:50:27 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::e500:5c9f:fb41:287b]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::e500:5c9f:fb41:287b%9]) with mapi id 15.20.5482.016; Wed, 3 Aug 2022
 14:50:27 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 5.4 4/5] selftests/bpf: Fix test_align verifier log patterns
Date:   Wed,  3 Aug 2022 17:50:04 +0300
Message-Id: <20220803145005.2385039-5-ovidiu.panait@windriver.com>
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
X-MS-Office365-Filtering-Correlation-Id: 4a7a821f-f6ec-41e7-df39-08da755f8090
X-MS-TrafficTypeDiagnostic: CH0PR11MB5505:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i1Tp6aGxw7/9Livic8LRiHXo4Ma/Q1sTpKXUAm057tDMiWpfXYHQEANWXl0MDFapbh4WgzU7grnBQEpUqoQR9ZPV+v8PfI0rkOUMrTTb9cbyqElPpNqpx/3t8tmUX0xwsYPN83fo87XFOCWvQnvnAMuBNPiJGLSqkXabnxbVv1b6EdSlx74ptwXMw6KtJopZRUFmLixgMfxQP9InnSRYgQvNG8bNuzkE4hkKq8a/bZEAh6wBKzXNmglsTQePZeyLEQ+yPidukwlYKrWVuB1yBLo/sIGQkCBJljFglal+FxgbrwBGNCDlEWNGySDrpGLeJvTOoYSrOV3N6sXAP5jHTyv6rdHPklfXv1eNUU0IV9fODghZ9PQjs4kbRlSglLwPkjuBLRZeZH52JHcd01n8c+dwZFl7JZI+jdKEdL8/GFeEvBzmr668Nj+Dcm6XYjeqDeengQUMEpRHXYr4DlbHj4A6S8H7ZrwZlq0Ar+64UobTW5Bs0caSw92IsYHs5meKup65e7j0ltteIInjImyJwonTmiT2o4ek2Zcth1SkNG1dL9EEDNp645YlCDKJO57oWU8TjzbkShX9PBp/YwcloP1J6o7tMNLgDECN/lZGtQuHuW/XbRL3VDIeV5NCyQWIHe24B1UxFPSzlgnrCkFlVrueEWpyZCQRhPSQJKS8K01ucd7iPhgCbCayc0C+XxbFtkc8OrVT+PfNpCFO+eeHopGGINNWno9B6xKQJ2WbDtZlC1uq2aC0c20j6KRQU4gqrUz4W/imcnYokfcCcHSHCAOfmxfHKr0o2GDRhi4zMWk7TnxssagN1UJpVicGHcdx+HJZBVJuDxarB+hJZPoxDg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(39850400004)(376002)(346002)(396003)(366004)(107886003)(2616005)(1076003)(2906002)(6666004)(83380400001)(186003)(5660300002)(36756003)(44832011)(6506007)(52116002)(41300700001)(6512007)(26005)(86362001)(966005)(6486002)(478600001)(54906003)(6916009)(316002)(38350700002)(38100700002)(4326008)(66476007)(8936002)(8676002)(66556008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZtiFUZw6iUXe1HIje3OKf6Xi1eOHFzHQk5Cj86gMlLeCxOVvD8pYZw9l2sSr?=
 =?us-ascii?Q?J7glO61QQOD9SAp2ZmKwcW3RhZBDBef2iPuJI8im8vxkmItrLtCJotkFxTz4?=
 =?us-ascii?Q?S62G7P6SBMbOEota8z42xtbcndYreqrJ1pNnNiIJQxGro8BRd17QlyAl/zXY?=
 =?us-ascii?Q?jOpjyGYtQgegjN+Z0Qh3CWcZmzsjRMT+Db6sh5JYV5td7vhSfVB65ohv+BdY?=
 =?us-ascii?Q?XTeuYchotyLuM/6OwrmHMX3foRK9PagSP/GLmf7pF34RV4hTazfEh/jRYLyZ?=
 =?us-ascii?Q?gYj9JiykNDWP685bcNswnyyjgQsru1+YjIuOrxgW77cf6qO1hH2t/hvj8a9b?=
 =?us-ascii?Q?2NpmbYzPENwVeZgex0b4ETrCLyS4QqcPqCcbvTWmUB8UNJMyNduu+Go2Nfoc?=
 =?us-ascii?Q?s0NEb1IxFw1gOuXWMocZW9jqk40m1X4E/KvF0WkOHccILmFsM9zlHfmqnJN6?=
 =?us-ascii?Q?EyGogi0wjgge6GaU9xTsGIAeN+EDmIZnfQV5A3kYMsDfGu59Mb8yyWWuoMp9?=
 =?us-ascii?Q?0q7Y4+9VHVQyax19qFjpDAFGEgE2sKOXOP9orpE8D+2IVA8uweudKXRPvFIv?=
 =?us-ascii?Q?My83C50VbMMY1bQVJ6pMK+hZGByzxzMiLIMEvIhB1K3DkETQLKmzw0LcOtSV?=
 =?us-ascii?Q?M4uFoUJ8gbFslgQaDW2zr26VfI+YAPYxEBzXQuFvdCDjtTmFQ3WW9HLYV6yF?=
 =?us-ascii?Q?kRCkmxnKyekbbaXPyfxCl2UaXJBhvaG5OhqgtZmaoTc1ipvNjcyYULneqDRE?=
 =?us-ascii?Q?CvLJoZxfWktQdFy6R6FQPiZXjj4Pmcb8H9tzSUufqiXopbkDFU294Guip22O?=
 =?us-ascii?Q?LmaCsf0X8doOX/jz7OynxXR//r8cq8dZBVzYd5w3xE1LLT5vLD+Z6VGIGm+p?=
 =?us-ascii?Q?6Ok53361T3XN0irdgkLJMLrbDNpiEMOi2anKLaLCauWTpuWi/JGk01AO5C2v?=
 =?us-ascii?Q?3VDdDTzTzMvus6DoxjEwEAQorUAjPxvXkqRwNdkjS/BKIC8m7hW2mwFp1jkg?=
 =?us-ascii?Q?2Gi3PS3ENnWBHU1H3/4OB2uD2b7c+NuQ/liLBD/3YiZfD8KnztYzI4wnG+xJ?=
 =?us-ascii?Q?um+xaL8qa5bFpbW2ZPoEojoceV4mROkrY4KBlPcNHwMZ4TV4ZinAnbXusDgP?=
 =?us-ascii?Q?6ZdoKLOiYyKqEBrHDecqtO5ps45JxaoqG/epAxlOQzoalsvszTKfB8gW2cj6?=
 =?us-ascii?Q?fAuKUb9syBzdnIKP9+W7gVG6efgreJ8ShteYHwPKj/VLzGuqSwk5e325zgWU?=
 =?us-ascii?Q?wz161kM6b/8BrrcKyypDrcLK3pe4rKBrneqsXlJqHIP06RZE6AYXXtcOizUW?=
 =?us-ascii?Q?hheaD3xV05gIDpnlXpFg2kZjBncgj7PY9v6TGT+hbFE3a8663WiXoMY4vghM?=
 =?us-ascii?Q?4bjD9m61lN4t4eiOVCIM7wCEZyOnOWDA25JOcDIa/VX0NjPjDAdm0tnrb+Cl?=
 =?us-ascii?Q?/vgAJzzFNK+OTKqE6tztapw9eLecRdzPC9rB7AcDUVNG0Liad+kcxe3TEb+t?=
 =?us-ascii?Q?S1bEt72dQ0EaQ9WXae9tdlRiMrN8E2OnYssX80A9dnItgqGwMbh92n/vxvdi?=
 =?us-ascii?Q?ud9+bRHl4RSaYps8ENAVlt2anzUv4zUFcObLjoY/LTeWyT8+Br2KMjwuzyNd?=
 =?us-ascii?Q?ZQ=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a7a821f-f6ec-41e7-df39-08da755f8090
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2022 14:50:26.9729
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 53AQOQRCK+jIFWBBvU/EWMR/DWmZpt2o3IpC78J2d1/sdjzRtKljbgfywVyPCuuzAMfWHVZmUGLBXPHqcpTwTxOjTXe48VSKTNCUAUgwjOs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5505
X-Proofpoint-ORIG-GUID: uexejKVdoAHz-eCUBxvMJ0Q0PKDgrI3_
X-Proofpoint-GUID: uexejKVdoAHz-eCUBxvMJ0Q0PKDgrI3_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-03_03,2022-08-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 phishscore=0 clxscore=1011 lowpriorityscore=0 suspectscore=0
 impostorscore=0 mlxscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
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
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 tools/testing/selftests/bpf/test_align.c | 41 ++++++++++++------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_align.c b/tools/testing/selftests/bpf/test_align.c
index 0262f7b374f9..c9c9bdce9d6d 100644
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
@@ -469,16 +469,16 @@ static struct bpf_align_test tests[] = {
 		.matches = {
 			{4, "R5_w=pkt_end(id=0,off=0,imm=0)"},
 			/* (ptr - ptr) << 2 == unknown, (4n) */
-			{6, "R5_w=inv(id=0,smax_value=9223372036854775804,umax_value=18446744073709551612,var_off=(0x0; 0xfffffffffffffffc))"},
+			{6, "R5_w=inv(id=0,smax_value=9223372036854775804,umax_value=18446744073709551612,var_off=(0x0; 0xfffffffffffffffc)"},
 			/* (4n) + 14 == (4n+2).  We blow our bounds, because
 			 * the add could overflow.
 			 */
-			{7, "R5_w=inv(id=0,var_off=(0x2; 0xfffffffffffffffc))"},
+			{7, "R5_w=inv(id=0,smin_value=-9223372036854775806,smax_value=9223372036854775806,umin_value=2,umax_value=18446744073709551614,var_off=(0x2; 0xfffffffffffffffc)"},
 			/* Checked s>=0 */
-			{9, "R5=inv(id=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc))"},
+			{9, "R5=inv(id=0,umin_value=2,umax_value=9223372034707292158,var_off=(0x2; 0x7fffffff7ffffffc)"},
 			/* packet pointer + nonnegative (4n+2) */
-			{11, "R6_w=pkt(id=1,off=0,r=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc))"},
-			{13, "R4_w=pkt(id=1,off=4,r=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc))"},
+			{11, "R6_w=pkt(id=1,off=0,r=0,umin_value=2,umax_value=9223372034707292158,var_off=(0x2; 0x7fffffff7ffffffc)"},
+			{13, "R4_w=pkt(id=1,off=4,r=0,umin_value=2,umax_value=9223372034707292158,var_off=(0x2; 0x7fffffff7ffffffc)"},
 			/* NET_IP_ALIGN + (4n+2) == (4n), alignment is fine.
 			 * We checked the bounds, but it might have been able
 			 * to overflow if the packet pointer started in the
@@ -486,7 +486,7 @@ static struct bpf_align_test tests[] = {
 			 * So we did not get a 'range' on R6, and the access
 			 * attempt will fail.
 			 */
-			{15, "R6_w=pkt(id=1,off=0,r=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc))"},
+			{15, "R6_w=pkt(id=1,off=0,r=0,umin_value=2,umax_value=9223372034707292158,var_off=(0x2; 0x7fffffff7ffffffc)"},
 		}
 	},
 	{
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
@@ -579,18 +580,18 @@ static struct bpf_align_test tests[] = {
 			/* Adding 14 makes R6 be (4n+2) */
 			{11, "R6_w=inv(id=0,umin_value=14,umax_value=74,var_off=(0x2; 0x7c))"},
 			/* Subtracting from packet pointer overflows ubounds */
-			{13, "R5_w=pkt(id=1,off=0,r=8,umin_value=18446744073709551542,umax_value=18446744073709551602,var_off=(0xffffffffffffff82; 0x7c))"},
+			{13, "R5_w=pkt(id=1,off=0,r=8,umin_value=18446744073709551542,umax_value=18446744073709551602,var_off=(0xffffffffffffff82; 0x7c)"},
 			/* New unknown value in R7 is (4n), >= 76 */
 			{15, "R7_w=inv(id=0,umin_value=76,umax_value=1096,var_off=(0x0; 0x7fc))"},
 			/* Adding it to packet pointer gives nice bounds again */
-			{16, "R5_w=pkt(id=2,off=0,r=0,umin_value=2,umax_value=1082,var_off=(0x2; 0x7fc))"},
+			{16, "R5_w=pkt(id=2,off=0,r=0,umin_value=2,umax_value=1082,var_off=(0x2; 0xfffffffc)"},
 			/* At the time the word size load is performed from R5,
 			 * its total fixed offset is NET_IP_ALIGN + reg->off (0)
 			 * which is 2.  Then the variable offset is (4n+2), so
 			 * the total offset is 4-byte aligned and meets the
 			 * load's requirements.
 			 */
-			{20, "R5=pkt(id=2,off=0,r=4,umin_value=2,umax_value=1082,var_off=(0x2; 0x7fc))"},
+			{20, "R5=pkt(id=2,off=0,r=4,umin_value=2,umax_value=1082,var_off=(0x2; 0xfffffffc)"},
 		},
 	},
 };
-- 
2.36.1

