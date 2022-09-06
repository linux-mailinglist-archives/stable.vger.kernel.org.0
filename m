Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEFF45AF00E
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 18:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231487AbiIFQOM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 12:14:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233691AbiIFQMn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 12:12:43 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B46E2600
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 08:39:26 -0700 (PDT)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 286CJAVj032133;
        Tue, 6 Sep 2022 08:39:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=Zxq95zvqA3DS8vEZrDjhlf57GVJeaT9ROB/ITj1qrvo=;
 b=pg9suQ63GozFqavXM291su1v0pZeHoSIw6NEIHJeA+URvsODDIRmsVhcIj1nnLPcmA6R
 ahtbqail+K4bjykwcFRLEDjhBZ6gVBPJlmNrNT/Rzk6lL+qrro+jrubclW78MNmNz34I
 KF2wshvvwp1bUyaQNJxgoBKe8yWc/ogEQhvUALc9nt7Q94G31S8RBkRE5QQCnLpvgNp8
 I0niQsf4yoKYyFo5Gm0pn8MlhxZQBjyc9NBk94jdpOdMoKYMYumrPItW71gYKgi1MxMD
 3ZvpFSZxn71nrNE/eZ88l4CsfhoY6vEhUrrMz3tZduN5UADgv3pdNEqUe6oHzd98496f eg== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3jc272tkrm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Sep 2022 08:39:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MIMZ1E0aewtl0yEfvDVmj3qbPFW1z4fL4Khy5c/rCOvTSIzabAvS7wtAPaD6DpKyXt0oO3uyzYgAGj4XeKs06BmLSRc5tacV1zAE0PNsjESdoNIWKdIFt5jB0VGCt2XbPvCguSB7X99Vypw7Rpj96qwJhFKAWBpdJoCJTz6OCgmWyzklAvp4LCcud1viOt4KqSjM+oOi4piwkjmHGQ4kQh9V4UjP1ksrXUXQ0fsk22CmZ3peA+7kLN6dCv7O9v4SJL59/n2llI5qKU46MH3PM98oJY5vXYuB9Fhxnq6TjuNRhe+wl9QlZ9ToaqnPtOs/clq4vgx3yxQ1s1q6PFOZSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zxq95zvqA3DS8vEZrDjhlf57GVJeaT9ROB/ITj1qrvo=;
 b=gbzHj+lipTdF7Sv5RY2OopCcQCNhMjh1xmBSr8nOx01pcKW2dPmPCwxovHzWYh5j9jF6fif0map3TeRwN7pNo7A8/jOOnylL8O6aE1ivkZv+Y6uAmk48b1fmNYjfKaJ73n5Z1s3yYTEKdWrBe3K8tuqZ2Hl4eB35JruGmaqVeZ/kzNBgvqQk5DhyRcaM1X2M9Ndfr4leE1UgC8LKwx0RFm8axkrDemIiIZwlXBy94L393XxQgAbc0DiLL3WA9Il7961ZmI859E6qW8qmluRCvEPBq+3xWtQ7uTuSWLHfcXZNj8SJnaXjG07YzOFIDKPHyavClkC0+O9iarWf6uKgjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB2714.namprd11.prod.outlook.com (2603:10b6:5:ce::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.17; Tue, 6 Sep
 2022 15:39:14 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::b4a9:c48a:51c2:d3fd]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::b4a9:c48a:51c2:d3fd%4]) with mapi id 15.20.5588.018; Tue, 6 Sep 2022
 15:39:14 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.14 1/3] bpf: Verifer, adjust_scalar_min_max_vals to always call update_reg_bounds()
Date:   Tue,  6 Sep 2022 18:38:53 +0300
Message-Id: <20220906153855.2515437-2-ovidiu.panait@windriver.com>
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
X-MS-Office365-Filtering-Correlation-Id: dd126fab-1bdf-482a-521c-08da901df369
X-MS-TrafficTypeDiagnostic: DM6PR11MB2714:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cTFZSjmwoFb+/TAYQ6BgFqLMp7a0ZgA1X+3YBL9Cx4o0IdCPr5ukJkUekjnIY0TLi6U85NPV+kxgzVrf/uv1pOWBz5sR9Jv7g8qusckUZ2xR0jFMQmm5QtXtR9PjLkUEQwL4HeyFBKYKvhO9iketion3vIKpIOrJB1WyWlDYEBKnlEs46n6x5WpXXwCZPDRtn4sXlDd6/0JmZI36UjkJB0vtd7+5BjWjWGNvnXIH5Sov7AjiAk/nDmklXGPsDbejknCSR4WG0tRn2DZcLjNyoF0FX/780Sc1RFhpeb7fHwCSXa4SKMWiwNeM7eK+qbSpOG5SAlG+jnkcW4ll9ML3aL1yKhdKMXgwPMXvOrGT20NoItbfcnU1lLt48LUcCde0GDbRkh9YMv/C4rHls29vouKVSdllYiwZq+D0L76m2oE7kKTnNOFZWL0Z2Lk8gl+pb/2++9TCnRovo4TE47bVKzUb8CIpez9umQ4K5dP7DjjLx3yQ9+IWTxiyLBk1oKzPcK7vjJajO2B5wchYY6VjlWbJGtLlwMFbdfcuK43ccxtEiPhjfALpU6nHheBJw9z3FfOczspmKO4h/TOEjheMkBPkf1kUasA4o5AZHIMi2TSCzj4PNoQCxcVEr4qPwvc08uc3BW1NMeEmLtvhOHQbm21RX6+jyJrTnsw5PE/fK9TujDoNKBF4KidTQqnSjczlVQKLRrVUwhDLyNSI4lR9rbmBUGA2Aqq3ZhRIfRPsmHpAqmg+UU0a8YZzIVdEEKNSCUIVWylaO93dPS2TGbW09goibTLkeqrobyHxIJ5wrNM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(366004)(39850400004)(136003)(376002)(346002)(6666004)(478600001)(6506007)(41300700001)(8676002)(2906002)(26005)(107886003)(6512007)(4326008)(66476007)(66946007)(15650500001)(6916009)(66556008)(36756003)(86362001)(52116002)(6486002)(54906003)(316002)(966005)(38100700002)(38350700002)(186003)(1076003)(5660300002)(2616005)(8936002)(44832011)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ShIhgy6Q9CDN8vnT2KqGwKSSKUxEjbVKVwfK25YT4wrozSt9/wxHq5a70IPL?=
 =?us-ascii?Q?0Bje1LtS61PSdKZsLZcv3F3mKO4/0Sv/jRVbHQq/G/Kk6kQv9fuV9MU7KmQu?=
 =?us-ascii?Q?ibRsgFws+RRzqOZPFGehFu4bVZL6nCf+w7bdPLiGjyhlWpuMSUuhvduBWNT6?=
 =?us-ascii?Q?fMic069csDDWWVtQqyw1KhUEdtExFEYkMZfgYewK8Epgp9DWTzOFqnFGySka?=
 =?us-ascii?Q?3TPTp6huttl0QgJieX2amB0o7ai1YeksXYuFfqlohXQr+eu88E9CbzF6poOZ?=
 =?us-ascii?Q?RstLcFQSZlGl4EZzCzqMJozfMQjBGCjVBoWhxCrvmWxPTD0fe46byWiczzzG?=
 =?us-ascii?Q?MOS5FsHY/totXR3dvQFd881sKV3BJ1HwZAu232B/uPuQti8RUHho33g7cnsb?=
 =?us-ascii?Q?+xaKblb8yLAm/VXbuPwlK9BIOq2VjVAsSSBTFnT5Q+NfdYLo/Lc4tun8XF/h?=
 =?us-ascii?Q?hcww4/g2ol662Dwn0KCptMYS6OD3kqRYj1OOc3L1XkchlvgMfxP2wwZmUlqe?=
 =?us-ascii?Q?IOOH0Mq3JS+sqRgHZeVoMHJkOMwsF5QntSzbLM+VARseK+CggATivgg8sMNe?=
 =?us-ascii?Q?mY7Xu+rvEGZwMMrAxcMttUOwB+FNLQFdVl0Qs2VT1TunHFDRAQE8aUXimBEv?=
 =?us-ascii?Q?sLGI2EL8n/VgO6/Uk4M6UAkINNrOyukHdH7aKhIx6dGCckyV+p/2d5tZpatI?=
 =?us-ascii?Q?heS/sKMMMAMgRWJ0CeDbqANv+Kt3lkYFR5DBqRs96YDBibAHLk4LqtQ6ZFL4?=
 =?us-ascii?Q?SB9opAezU97yecUbp3Ih2ahIKOjf/zsr0IxmlzQ4v2vgA0JRAuO65H35aLDb?=
 =?us-ascii?Q?vK+AWyWqrUVKsqj3XmonpjqiNTm6lUiglvO19eIFLCg7dajZGq09iB5nvCR9?=
 =?us-ascii?Q?rdKOovst29RT74mQqPaPNP5d9nMgyOna8prdhx9qoTitSHgfajiJPgSAFQ8l?=
 =?us-ascii?Q?MAko3npTX9mo+752jujvYU0ycx5zRV6uopynX3l3Qy/s0evLK5QfigREjBTY?=
 =?us-ascii?Q?o88iGFeg8P3vc68Rf9TwgaOIiKUfy9mT7SaeEBkEof5uqUUDBrAeT8u6QXjI?=
 =?us-ascii?Q?t97lvprxCBp0sQPwVXCcEEoldlHkGRkF30A1xztwfWrdyIkvFOgcnmezpLCF?=
 =?us-ascii?Q?jVZwA/JaIG+MfcSmgaFXu9fXrz12jRVdaXEVxKaR1bDwTAv0RDXyWDV3xg+X?=
 =?us-ascii?Q?zPpwoY+hFNu7MayCuZSq/U97FkXAiyhOmJ8ftlc6Gqai+5+Xf2XXf49ZVHlV?=
 =?us-ascii?Q?bRuwme7fNyfjRhOx2KCdnOu1SdRUBiT3SrR7FYnvsY/eK+mIYf1PD7ASfgcI?=
 =?us-ascii?Q?608Ihc23g/Hx9d5/hVJJDLB1du0SrAiQ0p8WY76AgGxywrXXSzW2DB6fl+71?=
 =?us-ascii?Q?4VD9wo0WAt5S/h43r5iqouIpD61tInhJmZDhWysI+5MS1CsrKlUzUaRnEc8g?=
 =?us-ascii?Q?fOxeB+JFIiuctCf/hHRa5K8iX8auDuGCVrWFA20Wh7yzQur2OSE82x9PTU5K?=
 =?us-ascii?Q?GQnhAWIouIMh8p5tK+0svjlMKC3P51sa5kpsCHNpXQKBUJMpV4wLRvyAgWLe?=
 =?us-ascii?Q?lqxPIHuwafAvz9+SG1wwSxIWgSb8RwBID3RhaCFWXwCNGFmk2xbqjiXZ1cQV?=
 =?us-ascii?Q?GA=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd126fab-1bdf-482a-521c-08da901df369
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2022 15:39:14.0438
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pWr70xa53ztKfIauwGVO8+qpN7tzyAq/sEiOI5YDWgOCsEJdJWc7RHzFN8RXtc1pUcy7q/A2W0/KAQe7p5i1k6pG1VN9KYG8O1N/EiR3Vxw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2714
X-Proofpoint-GUID: FU1nQp5cInX8iOTP8frxjeBhDT3GsDMA
X-Proofpoint-ORIG-GUID: FU1nQp5cInX8iOTP8frxjeBhDT3GsDMA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-06_09,2022-09-06_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 adultscore=0 spamscore=0 clxscore=1015 impostorscore=0
 mlxscore=0 lowpriorityscore=0 bulkscore=0 mlxlogscore=931 phishscore=0
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
index 08f0588fa832..e8d9ddd5cb18 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2739,6 +2739,7 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
 		coerce_reg_to_size(dst_reg, 4);
 	}
 
+	__update_reg_bounds(dst_reg);
 	__reg_deduce_bounds(dst_reg);
 	__reg_bound_offset(dst_reg);
 	return 0;
-- 
2.37.2

