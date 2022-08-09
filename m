Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC02658D4C9
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 09:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239687AbiHIHk0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 03:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239657AbiHIHkZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 03:40:25 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F7812AC5
        for <stable@vger.kernel.org>; Tue,  9 Aug 2022 00:40:24 -0700 (PDT)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2796rMfN013562;
        Tue, 9 Aug 2022 00:40:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=OzGILcIpG7cB0ge/eqDBEVdFEneoxSHYhHR/needsuA=;
 b=RkKvXjkmtJqkEGr97IkiNptO5qXjyGp6S1CLrJ2PMRaVZTO/tDsALYLv8L7w57vzh4Ts
 0x42XxubpPh9lHUEJ5muoUlkyzPLIxoaMZFfzLSdwF8nd5g7sRtYkF/BMjxFRakuL7X7
 +dUl7hTxwYR4lrlWRCiULfNtvxcK+q8vnxpy7dz2M6WDs9+zvh+qKW7R69cjLlyw7Zp4
 LHh9usCzXzUzpAxkE+a+vSbdpCR6O+UKgu2fIpat8jvD0LcsOpMnZuSE7oqGmsFNk9yj
 2Nq5aQ8D8PjU7TSl88gV7IwB8x9Pv2o70ijyhmdQ8hYJ+/+8fcak8VpAC5O1jEc5AI8B lw== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3hskk4j77w-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Aug 2022 00:40:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LNZyS1ovaKsr/xzzm4T3BielzY+HaOVF1WvHQjX6+/6NT/cF7+ilQLaDRvli/xOk6kiuDhYm+9D6JEZV2zhOqeYV0uY7enz21mSio83fM0twkj3MXGKXcZfdWsNo1UxsqGVoMwyQi8wBZLRxWK6JLWhYTwAtaLPVVASrs4YPcAfW/eiLycX7Rl05obFc4cX1yvQn72M82368LDBK9WN1G7l/S9P/kUxTXYFBuG4q8XkZfGujhSnRB5Tch4RBLjJL09cT2SPRGtSHSTQFI+5ZQFXj2jvO+xAGrhdY8B2Eu9bUoc334Q6Dt/cq6DA/lBXDV4WAMAQJ229ZaflRsxpQiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OzGILcIpG7cB0ge/eqDBEVdFEneoxSHYhHR/needsuA=;
 b=G9jRv1vEJiOVsakt6A+vmnJDzBLqyBH9HI1mGTHrS1xcBurCZAB+mdbBjG8ZvIXXAcber5QQCO4iKl9sW9L7xwJOPV4KMGIK3Ma4MN8AOK4GscoTZZv7h0zpOXYOMrU1f0TSJHIB1AxJrM7QJ42W2VqxsBctGdphQtcbCz6TAfyaz8Fj9A/mkQkSZSM72gJ2uvBdeW1toYBQGe/jZSgL9tPH4AOQ+x5YKTvmPBbdZE5LmAQkVWbzQOvtw6/6viUQmEv9E/oSGHWfDGfKY4Gdn0IzxXEurKUh3weXZuG2Mwd6U84oYEVe1RGDzV/VSfsTEFcgM0Of2PcvBeKWMgMQmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by SN6PR11MB3070.namprd11.prod.outlook.com (2603:10b6:805:d4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Tue, 9 Aug
 2022 07:40:08 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::e500:5c9f:fb41:287b]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::e500:5c9f:fb41:287b%9]) with mapi id 15.20.5504.020; Tue, 9 Aug 2022
 07:40:08 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 3/4] selftests/bpf: Fix test_align verifier log patterns
Date:   Tue,  9 Aug 2022 10:39:46 +0300
Message-Id: <20220809073947.33804-4-ovidiu.panait@windriver.com>
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
X-MS-Office365-Filtering-Correlation-Id: bcb13a57-164a-4634-309e-08da79da620c
X-MS-TrafficTypeDiagnostic: SN6PR11MB3070:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x3kM4muqw7vRwkpGN1xKSNRcZHDzpNd+mRN5G9/LlEpICihrsEo4hNDUEVLdazxs1ljv7xWc+YIXwiSSyxkpqyRyHGZkQZClxoPYeFAn9IB+uKHTFnI1DMuQkseX8KRKKVk6xM0f/jCItEalAtgym54eFBER+Wmm3SPpjBgS6o/uUnENC4PbESUMnZp2Xz3fSWT5XkMRvzyeI1h9cWxU7EmEU6FIWCA/3cyPDjmHQABmg+0lLiumtL1eOhlYXDsPCJsVQemJb1B0QuIEGXrxJCjZu+ofJkNivQ8nr1CR4uauviWsjoA9UI5AfUZMjF7eSj16xZh1i2xdBX5Tu+jasBm+32kedUUEXBLvT+96Ix68GAlxUdfkxDVfqweBLp74kSaoRZnnK9poQVitf5zwVAlZ7/egonZNVsHkGGf/MhfI5JBvWy2kS76iApTpfibC2ErRuLrLn/uOULM2wGi6zdwj0P61Xl40+K+9eVbhjosiTQUbpPa+SsRCh9pEU8c3BVh8WOqzoo8nbH7eowEnuZ1c5FpNkD7BMQvYKneGB/8SEauMx0B7Eqyv4RFY1GaHqI1shvmGDONfst4HpApSROEuWCvlSEPBepwXyOaRTHFdKx+KQYxuDmvI9C5L9LPAslWdj5DfY/pfXQc3oAk5K9S0PhrKOUMIZZgTbJcu1EclxLk1iLSrx6OuSJU2kGiFXnLRHRV2UsBSUGAYUmVGoUItiYOup4yuA+ymdAD0oDpRqnHy9FJGxviwQ/7gGT05vbVIao1bWoHP7S/0ngcl4erTSURckxmOlp7BMKKKWVv+uXoRVJmciD6f3egF+zrURnDp53sqC7huCEqSWJXuOg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(136003)(366004)(376002)(39850400004)(41300700001)(6666004)(26005)(6512007)(38350700002)(52116002)(38100700002)(186003)(6506007)(2616005)(107886003)(86362001)(1076003)(83380400001)(44832011)(66946007)(66556008)(8676002)(4326008)(66476007)(2906002)(8936002)(54906003)(6916009)(966005)(478600001)(5660300002)(36756003)(6486002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QxNSCajaO6GetzYk/E4on00VNy8oeYJ7wvcAkSMAHyUGoSTfwfO+m6GKy8xl?=
 =?us-ascii?Q?oPJqGDb07zNRAyNFkw/VFmk05ECK+H2/hIAwHdJxhPdD89CERaNKh8Hx0VNF?=
 =?us-ascii?Q?BY5ERAD8GOq/prwhL1Wjm4L8Lik3vvgfWpO2e1qf3GYnRyYxKAFlEx39jVCR?=
 =?us-ascii?Q?hk3rIHfwZ2cP92Ut1QUnOBtEGTa7FLE94+1u0g/SaEAja6g+Al0y0o4721ea?=
 =?us-ascii?Q?3TBf6ONEp9Ahi+VOpLfA6eB1bw+0m85jTqARgJcz4vo0GvjBYSbhPfZ20JPi?=
 =?us-ascii?Q?RgBQLcc+o9j/lfEpxZuz1eI+lB/EMqjLBUR5hhoz7O1XBkQECl0NZq9AY5Es?=
 =?us-ascii?Q?N8bMMP6qJw6hoLgZLE4r1X+bBQwyl6Izof/DlQW67quHJhdsvrqMMRP8aB+A?=
 =?us-ascii?Q?Yb12gQmKeKxXWMqqOCaGYW1tzLacvdHCp5iMkPVvN0U2h6ssTnh1GXjCY6tS?=
 =?us-ascii?Q?5CmC8caFzI2ZJI3lGCxgjpukTMqvkwsT6cizsH+/k+dTJRjgOg3N3Ws+m3CY?=
 =?us-ascii?Q?PaeBJFH1EqWLAFoP2woBfbmIh+y0Ht26POyrxae+cya/UtyILq8YtRWwljjw?=
 =?us-ascii?Q?mal9QxkhSJI95P+AQrdcsp7C/Uh1Kn/mojMGkbl9rwWamUt8/1Twf45GrNxJ?=
 =?us-ascii?Q?um7Oc1R3z7f720KuPr42dxm1xMzw5/D9S2JFOMEssjvlw7q9agKW2fJ600OR?=
 =?us-ascii?Q?WLww4DdXuRFouCmw8Id6sx9fS+bIH4nYmI8U03b7qhmSTIPXkQYG89Mrj48+?=
 =?us-ascii?Q?kNfE1YtcXlgf4GfgQvFunlWF9yL2OIaU68GKElW22VES0hw1fMqn6Os61Tw/?=
 =?us-ascii?Q?94aW7XHT89EQt0JflErWMJj9ztP15hufTRUrt7sWooGsVxLPn63URc3uF5qP?=
 =?us-ascii?Q?gIUHlq9rD9y5cwbHn7YiG+aHU1QDkA51Vv2tYnHTcuuQr8E+deY0x64EfNfV?=
 =?us-ascii?Q?6pwJ3QimFNyAUSnygTdSzMJP9jfIReCaC2/PzUCTJ8vYIe4sQOqWfxNDX8ls?=
 =?us-ascii?Q?YfUzn+VUyMVf8ozcxsgvtjJTaR4pGNkKIeTEYfENYAnSmZ3q64rgX7UyjiD7?=
 =?us-ascii?Q?ZeaGlEGcSBfEZgGx7eYfSsCIws+tq3VJZTsiVD+oMkxQPyExrtDEIW5Dwy8M?=
 =?us-ascii?Q?Xu3OQ36qrwWz46z72rjdHyVXHQyEUjlusiJOXeMnj+EBlEJUK0FY9dO8Jt+G?=
 =?us-ascii?Q?+rGRF+YFXMi+XQzVH2bTxxfyg3nbnLvqcwtg7Z8mNx0bq6VQEYWLejdeTT6p?=
 =?us-ascii?Q?vGE6ktxl3CbzELdgi2OQhpFIceGWNcmj/iSc6zAdWLE9ZaJhqB6fgywbhf69?=
 =?us-ascii?Q?7BGbk0eqsDBpJNdqwMtRf0mFAK7T4E0idAX7DAD/gaP6AvzPQoNFsRIop0p7?=
 =?us-ascii?Q?XGY7O7DE6QB6xzTtWietC+cxWwQAc21ShJ/9Sh5ZIwfNQPgPGCqCUdEL/hoo?=
 =?us-ascii?Q?U+6yFm1dgvMSKh98hDzZfmYogJjkzwGcLCRzOe7fmJCHMiuI9WWpVwogYSP/?=
 =?us-ascii?Q?+pQw9RTx/fVbiH/bwP+Fw9JFnsi4cAOMUDTZ7UXeAxnIKdyhgGUN5sXHm8s3?=
 =?us-ascii?Q?HCghVdnOmPFlxkZ0PzKL4ajUe6g42jQnUmL+g1aJ757rCyKLRCNjll/Z9df0?=
 =?us-ascii?Q?PA=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bcb13a57-164a-4634-309e-08da79da620c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2022 07:40:08.2706
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zMnS4f5CmR1PsfVuxWeAFqFCYS8zCRjfBwjGN4Lf3hY2JtSso1sehr9weV5LJP22jEVz9FClSs/5uO7yLd9ujqHW512PQ+pWN0zXrQgCA0c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3070
X-Proofpoint-GUID: q4miP_vzQPv2Cilqw1h8KiGfmnUJebdg
X-Proofpoint-ORIG-GUID: q4miP_vzQPv2Cilqw1h8KiGfmnUJebdg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-09_03,2022-08-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 clxscore=1015 mlxscore=0 spamscore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 bulkscore=0 suspectscore=0
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
[OP: adjust for 4.19 selftests]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 tools/testing/selftests/bpf/test_align.c | 41 ++++++++++++------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_align.c b/tools/testing/selftests/bpf/test_align.c
index 3c789d03b629..7e057b47b27a 100644
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
-			{7, "R5=inv(id=0,var_off=(0x2; 0xfffffffffffffffc))"},
+			{7, "R5=inv(id=0,smin_value=-9223372036854775806,smax_value=9223372036854775806,umin_value=2,umax_value=18446744073709551614,var_off=(0x2; 0xfffffffffffffffc)"},
 			/* Checked s>=0 */
-			{9, "R5=inv(id=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc))"},
+			{9, "R5=inv(id=0,umin_value=2,umax_value=9223372034707292158,var_off=(0x2; 0x7fffffff7ffffffc)"},
 			/* packet pointer + nonnegative (4n+2) */
-			{11, "R6_w=pkt(id=1,off=0,r=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc))"},
-			{13, "R4=pkt(id=1,off=4,r=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc))"},
+			{11, "R6_w=pkt(id=1,off=0,r=0,umin_value=2,umax_value=9223372034707292158,var_off=(0x2; 0x7fffffff7ffffffc)"},
+			{13, "R4=pkt(id=1,off=4,r=0,umin_value=2,umax_value=9223372034707292158,var_off=(0x2; 0x7fffffff7ffffffc)"},
 			/* NET_IP_ALIGN + (4n+2) == (4n), alignment is fine.
 			 * We checked the bounds, but it might have been able
 			 * to overflow if the packet pointer started in the
@@ -486,7 +486,7 @@ static struct bpf_align_test tests[] = {
 			 * So we did not get a 'range' on R6, and the access
 			 * attempt will fail.
 			 */
-			{15, "R6=pkt(id=1,off=0,r=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc))"},
+			{15, "R6=pkt(id=1,off=0,r=0,umin_value=2,umax_value=9223372034707292158,var_off=(0x2; 0x7fffffff7ffffffc)"},
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
2.37.1

