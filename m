Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A759F5AF00A
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 18:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233884AbiIFQNQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 12:13:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234388AbiIFQMt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 12:12:49 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3EDEA18B
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 08:39:35 -0700 (PDT)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 286BJQjU019175;
        Tue, 6 Sep 2022 08:39:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=gPLyUboCM7KgVhhyd5HeVzNjaBK5LtJVJeK6FkxU/sY=;
 b=Q1W/q3J5bxn3wb+WQLnyT82NklZqH2EjqWUzUitqf2qpwlb02aw9TL8AbLoQ9qWzoa0n
 RXxgTtzl+XVy0OTwUyGN9xnXR3sFLCf3oA1bPKmb5gBNu+KJgOGWlMRyDuNQ00IrOF0N
 lGMzC3ih7QfGx78V+fL58gWccLqLrM/pS59DkXYqJlS/IlAbbOG576v9hzgy5Mm/xYOu
 pcaZeiGSLJuuERdKnkwzD+VPaYF3ZwzzQBWyoY6b2ZvT1pNbeqWyZbqns0v9M0Zh35oW
 NEh8bRWKGG6glGVsvfFrZgRQdbVmflKAf/YANlQ4qxjMZZ+tTpkWq8jPZkoDFL9mEH3K uw== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3jc272tkrp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Sep 2022 08:39:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cbn5tB2mwRp6c3eZWFQiiIx2n5RKN9SXEzLuEvQXX4jwX8znc8VuKS9KXsntv/OlqzycGedbIKfKZ2Bl7gEpNNAfo8LjeP4ws4ydQ17grWo1GWAUO6fiVio9AxWeQjJ239iJoqPnEM1vTclDQAROIjpaHVit1AzzqcbRV0wRCBlzI4BwTpFksiTP3gG6I1+QjdIXlSojpFrilU60zmFf39rU623lA/IpMd84yodalYWeZYzic6aaFax1FxpncwWrG7pAZincySVpWTTCU8/DJkpYdjVG+uRkW9z2oHPU1uTCb2ifrSZD0/jXBCoSg/J4SBoA32Xk8XTa0n1onx+Hdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gPLyUboCM7KgVhhyd5HeVzNjaBK5LtJVJeK6FkxU/sY=;
 b=Mlov2JBwUP7jLmF2hNaZqfWBSy/PtmqjbRuEsF+VhSUsUmHhPnnIAGUJwyJaWcg20pfrgr0Ptp7EzKJk5QXKxZHhCyabbYR7DaKWLIiceQ1MMlfxQQCUNgu9LLCNXJwwMRDKvtdN+3+/dP++wtHBSafJqV9YgZncu+5MpVPmspLu/q0/DlE0dbx5YI5g5V7D3yotpCIkxytGpoI7d+2Wmrpl7NcVJxCp4gU1yJb/9Uw5U1NuGItsvY+uwqloFSAP4xHddCUjWZlKVKfAsjUsk+xav9RUiI5z90lsdJfKAOrFNwYSGXYp6VQha2YiQ8fTDC+ZlhLJwpRPc52rS07OnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by MWHPR1101MB2095.namprd11.prod.outlook.com (2603:10b6:301:5b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.15; Tue, 6 Sep
 2022 15:39:15 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::b4a9:c48a:51c2:d3fd]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::b4a9:c48a:51c2:d3fd%4]) with mapi id 15.20.5588.018; Tue, 6 Sep 2022
 15:39:15 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.14 2/3] selftests/bpf: Fix test_align verifier log patterns
Date:   Tue,  6 Sep 2022 18:38:54 +0300
Message-Id: <20220906153855.2515437-3-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220906153855.2515437-1-ovidiu.panait@windriver.com>
References: <20220906153855.2515437-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0125.eurprd08.prod.outlook.com
 (2603:10a6:800:d4::27) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 18266839-d912-41fd-968a-08da901df449
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2095:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JYSOJ1dgiKovd4el/hcOhpylLx1UO/smrFT2VusBWJS87KJ4zVjqByrT4QsqIHL3Q/D2B7B8uN7aP+tltf4tg4Tj/acGgIpvcUNUUhJqn3Ch15x+N7o6gRxxkiBR4iTaGfJ1Q6ZnuFb28V/IFs2DcYrK/XH/fwU3vc9do2jHXIJirwjxsUdNPTeW9pmlRmhRfZ1NZy/wx5xXMKNfZAxvZN9dmf9DpFOr4s9HOqi8QoD6EXQO5Ef9VZSxgLedkEWr1mYp/wJ50NEbZDgyBajU2WSfd4rDgV9kjX9OPqYeRpMs3q4erk1Yzunu8UNcKiN1GNDWIY6Set0STpy1Qmkk5P3PLW/yU/bFtE8iZTn2/n4aJJkCWwpXIeHuyq8YjoZM3/crBaWN/QxRzBoIS5vSav1t2Vuc8VIzeOe0NJeZi8pSx8nfUN9drI7FtF7wARi3RapY2t2cQfMJoc70FrZi00yM/b0p+yUo56ePsapRUFq/Wwg4LbrOf9QYinTcQrfr1y1aZyxEOna3RkiIdkYrvMVSDKGNJfCoSvPUBfNpGnS2Dz0177GxjH/eLFzkPh+ep6aj8qvAK6/PtXyIJTu7P9yzFRLzRZwF4ZWz0xQM2f5qSVCWgXk1p1r10lpOZ+fvnBs5wGHcxcvMda7PDOWFvL6seztV35Kc/k3svvCladhN7dM/m/r/PAvCZjaPO2/GjgjtwDTYE1Ozd8gM2FgZsyDVune31B6yBPzGFAZ9F9bNEsGxm41MoHqGzyCpTPaylQN/FsEmpO6VfAWXkwNpP3AuXkVILbLxFHMLF1ywAvE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39850400004)(366004)(346002)(136003)(396003)(6666004)(38100700002)(107886003)(5660300002)(41300700001)(6512007)(52116002)(38350700002)(6486002)(83380400001)(966005)(26005)(186003)(6506007)(2616005)(478600001)(1076003)(316002)(66476007)(66946007)(86362001)(44832011)(36756003)(8936002)(8676002)(2906002)(4326008)(54906003)(66556008)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bla28ocgvJDdGU85s62quHyEu+NObGv7AhY8aFsaEi66ItSDZaL+P+akZBEG?=
 =?us-ascii?Q?pPhZdTd5+XOtkUDYLF8+sdZrB2y5FVyYeq0mUQi/GfU6ZW8+W2i0a1sCZsgM?=
 =?us-ascii?Q?OsEInr60nxC0VYJqf7r5hjZHNw5ArOtGWv61NWJjDc0MyviQ87fyUwR4tKxn?=
 =?us-ascii?Q?qjFKXNyXTqwUT2V47fYOzO4kkoZb63yHZ2UtH9WweXSgWH8eEhjVWg1czMEg?=
 =?us-ascii?Q?9K1DBVoQ/ch2WQOZmHPzbVv4qq+XgfJuuChBetBwy7HelPIJQMXQ6N0USswL?=
 =?us-ascii?Q?ZgimmshqXuDAuiuRoYdEPUn9WQExk6h4AbDRMlGJSzAekQ4DaQrSulPhHTXw?=
 =?us-ascii?Q?CYvMIQxwaoE+DKdSlUcK1ZNaqie2MXYBmANAKH/0Gyy40bbtS///ckoMFZ7J?=
 =?us-ascii?Q?/GWRrlXYxPNI12VG4OIRKDpiy16uVgJCAO6UQc+iDw7dHeX8cZDxPsvwox0c?=
 =?us-ascii?Q?ViirJCl7CEIvxH+y/I/FEzbzcDjnPxARx1jqYzIRJ4goUEYa0OZ1eA1LfEVS?=
 =?us-ascii?Q?tpI1HEEWIUR8TUhPcLJyxD8US2uCknDslzZj7KkEzofDkMrp5hqnlhNK+8E/?=
 =?us-ascii?Q?BU7/0hOEd1e6YrMcnINMuelrYsv5SAs4K+9l9xKNyT73cIQzWkWeCl3OsJmf?=
 =?us-ascii?Q?6nhYnmZLmMrcG5YMQkWA9qPyMSQbIDahTiSCXlgxVXePxqO9D6Z0g3hx23Tl?=
 =?us-ascii?Q?pz2QtXlLUqiymDj7V6q1m2h3YsbJzFpk+immFJXneCpWjIgGaUohueIIme+R?=
 =?us-ascii?Q?7+pXARPk4GgTXFIugyImF1srcF3/AxdMRKSZDsLdsQ9zsXjdJpk7umjEBTek?=
 =?us-ascii?Q?rSNfxMsAqRVdZt0fv5QRPBS23zUUQz2oUvq3cHQhtOYq+WWrRluYfFjYuUtn?=
 =?us-ascii?Q?PMpaKmJYh8whLRvl9v+ZsbfWJPrFY7deSS2AH2bD3kf93j55oUEW2qiL9ux+?=
 =?us-ascii?Q?dPmHW/W0mJiuEEofIxk/Jv+2AtqtRFa//tKbnz2CJMRfRluMji1cpSY36IfE?=
 =?us-ascii?Q?mIsYIdR/YYiD9OmTuopp3vIyRnTaXTlo5yRzllT2j7JzcxGP11fvkL6Bauqy?=
 =?us-ascii?Q?ApsDqT1N9s4dVibvN0L7MTDvDK2cHXHAGbdhmHaZ0pG/5fTBB9JOIVeMFwOy?=
 =?us-ascii?Q?5gs5urMM+uYZAQypVTDxhvZ10mVNiUy6q6Fb8nQIwsdntKyvEeiSABxjmlm8?=
 =?us-ascii?Q?daGBncd3qNFeoiB4MW3ba2oHihEkddON7DDRtNkLFfsdgOg6tuTyBM166/p6?=
 =?us-ascii?Q?wMswAqjTTStL+/sbWr/GTRZwi5h2TLszVwVBO4FVcN7vPghRAvUCwlaqlnqX?=
 =?us-ascii?Q?PhYElwiuI2aOauFoEMXWj7zNBxfM2JUBfF1di72ob1BFxEEhLr8TAkl0BOSm?=
 =?us-ascii?Q?pi9g3bWkGc6M50AZnIZdXF7oZwjIdq62U9wJqtK6JkhEEjWyiK0GQaRp/0Xn?=
 =?us-ascii?Q?jqM4L0XT4LpmGofE3B2BmtyPTXRz4x0sT5J99ALqX/7Z2ccBI0tJl0Jn3+oB?=
 =?us-ascii?Q?fWbGg2jKIQEn1UTec5WhUKVk1JD4fOBMk2JFUWLE23iWcvNhwVfJM7kcavFk?=
 =?us-ascii?Q?2JbUl//ONT/i4CrxkgjyLONmOWn7WLqGQnPkKMnAIRQQeKjG7DCQZgMmfewO?=
 =?us-ascii?Q?Uw=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18266839-d912-41fd-968a-08da901df449
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2022 15:39:15.5604
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /41MdnMmvDDwMxtwGM2fAGtk0hquqPSEsmzQPmyxkDvAbJUnnjpy5Pzv4iCT348/MhKtvN89Z2/ytoljsFBOt0SLfEg8pKZLjjDMT1Vxfzo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2095
X-Proofpoint-GUID: YlnjzM6AOtl0UY5ppAWGl3TgH0DTkVsB
X-Proofpoint-ORIG-GUID: YlnjzM6AOtl0UY5ppAWGl3TgH0DTkVsB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-06_09,2022-09-06_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 adultscore=0 spamscore=0 clxscore=1015 impostorscore=0
 mlxscore=0 lowpriorityscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209060074
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
[OP: adjust for 4.14 selftests, apply only the relevant diffs]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 tools/testing/selftests/bpf/test_align.c | 27 ++++++++++++------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_align.c b/tools/testing/selftests/bpf/test_align.c
index 5d530c90779e..6004ae268a80 100644
--- a/tools/testing/selftests/bpf/test_align.c
+++ b/tools/testing/selftests/bpf/test_align.c
@@ -363,15 +363,15 @@ static struct bpf_align_test tests[] = {
 			 * is still (4n), fixed offset is not changed.
 			 * Also, we create a new reg->id.
 			 */
-			{29, "R5=pkt(id=4,off=18,r=0,umax_value=2040,var_off=(0x0; 0x7fc))"},
+			{29, "R5=pkt(id=4,off=18,r=0,umax_value=2040,var_off=(0x0; 0x7fc)"},
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
@@ -414,15 +414,15 @@ static struct bpf_align_test tests[] = {
 			/* Adding 14 makes R6 be (4n+2) */
 			{9, "R6=inv(id=0,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc))"},
 			/* Packet pointer has (4n+2) offset */
-			{11, "R5=pkt(id=1,off=0,r=0,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc))"},
-			{13, "R4=pkt(id=1,off=4,r=0,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc))"},
+			{11, "R5=pkt(id=1,off=0,r=0,umin_value=14,umax_value=1034,var_off=(0x2; 0x7fc)"},
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
@@ -430,15 +430,15 @@ static struct bpf_align_test tests[] = {
 			/* Added (4n) to packet pointer's (4n+2) var_off, giving
 			 * another (4n+2).
 			 */
-			{19, "R5=pkt(id=2,off=0,r=0,umin_value=14,umax_value=2054,var_off=(0x2; 0xffc))"},
-			{21, "R4=pkt(id=2,off=4,r=0,umin_value=14,umax_value=2054,var_off=(0x2; 0xffc))"},
+			{19, "R5=pkt(id=2,off=0,r=0,umin_value=14,umax_value=2054,var_off=(0x2; 0xffc)"},
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
@@ -473,11 +473,11 @@ static struct bpf_align_test tests[] = {
 		.matches = {
 			{4, "R5=pkt_end(id=0,off=0,imm=0)"},
 			/* (ptr - ptr) << 2 == unknown, (4n) */
-			{6, "R5=inv(id=0,smax_value=9223372036854775804,umax_value=18446744073709551612,var_off=(0x0; 0xfffffffffffffffc))"},
+			{6, "R5=inv(id=0,smax_value=9223372036854775804,umax_value=18446744073709551612,var_off=(0x0; 0xfffffffffffffffc)"},
 			/* (4n) + 14 == (4n+2).  We blow our bounds, because
 			 * the add could overflow.
 			 */
-			{7, "R5=inv(id=0,var_off=(0x2; 0xfffffffffffffffc))"},
+			{7, "R5=inv(id=0,smin_value=-9223372036854775806,smax_value=9223372036854775806,umin_value=2,umax_value=18446744073709551614,var_off=(0x2; 0xfffffffffffffffc)"},
 			/* Checked s>=0 */
 			{9, "R5=inv(id=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc))"},
 			/* packet pointer + nonnegative (4n+2) */
@@ -532,7 +532,7 @@ static struct bpf_align_test tests[] = {
 			/* New unknown value in R7 is (4n) */
 			{11, "R7=inv(id=0,umax_value=1020,var_off=(0x0; 0x3fc))"},
 			/* Subtracting it from R6 blows our unsigned bounds */
-			{12, "R6=inv(id=0,smin_value=-1006,smax_value=1034,var_off=(0x2; 0xfffffffffffffffc))"},
+			{12, "R6=inv(id=0,smin_value=-1006,smax_value=1034,umin_value=2,umax_value=18446744073709551614,var_off=(0x2; 0xfffffffffffffffc)"},
 			/* Checked s>= 0 */
 			{14, "R6=inv(id=0,umin_value=2,umax_value=1034,var_off=(0x2; 0x7fc))"},
 			/* At the time the word size load is performed from R5,
@@ -541,7 +541,8 @@ static struct bpf_align_test tests[] = {
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

