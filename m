Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2AAB3E0651
	for <lists+stable@lfdr.de>; Wed,  4 Aug 2021 19:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239785AbhHDRKD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Aug 2021 13:10:03 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:44036 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229765AbhHDRKD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Aug 2021 13:10:03 -0400
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 174GjQ7g019523;
        Wed, 4 Aug 2021 17:09:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=t5Mm1KvCMCvR4hRAUzCCwJ4xmpl6WsXP3nsYvb7dslo=;
 b=EAL1mIK4N7CRdBEJEQxD0HB081cW71MVHPyQpNxi4ntw9Kmyxs73hzSEvA6B0O+uxjp2
 4wKoq+rGLXukEGlbSKXWYfNV2ERzGq+tZZKFOUqBuzfSv5BXeVWDl8tPL9g9Km5qpf+x
 Ll2/RYbdSJlZir2oGSrRCpXczxg7rIvmNL6pJI3BnWxrynvS+13bdPnQHiwExjSaoNO0
 eheKjNRYy0k9k3vBxFGxbYelWGeslz7SCLsBj+ZfIeeAaOXvuujInfykjgpjrYlWp9nN
 Z52q8nlOYt15ecxAZnVge3UV+56LwRfeygACfnUttlae4MS87zcrdhSFcUDltaL99nTo 5Q== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by mx0a-0064b401.pphosted.com with ESMTP id 3a7w71834x-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Aug 2021 17:09:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T1OZfSm7nL4XnlT8aHyOWP649AqWiKSAyTOl1m/0QdD1k0b11vlyS+Inj0UYZy22sWVkJSE2INsL8m2jJL7n63nP4rPFzy3xfWnj/MNFsNYBzUEiwb3+BNLxZ11UxUate+8FXf7UXmZ2QusFjHFC3X8JSB6gJ0XYpOZg0ScOthFhc2kxJ0G/d7ob5HZcLtj50CQULWCh36ptRhQdIV6D535Hbyoyd4KSqz0cQjI5bF7E/bfEQj1LM+QDV48bkaMAFLRhwIVGqmnSYL3U0k73X18hd1chmpvBC+mo+1Y1lvGco1o7xdg5yEg8nSYfMGMML3GeEceGNNBlT0UlPflctg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t5Mm1KvCMCvR4hRAUzCCwJ4xmpl6WsXP3nsYvb7dslo=;
 b=T7hzPcIcyeqUajfuh4Kr4fIbkh0wH9QFvgXr+0pc/50mpxKp2rUM3ftcdBr2vhFaIcWStH6CYGd0+K3YXynx9wn4xl5ath4epzAknrFZBKbDj56Wz0VA0wsp0LTFTseO2100jpA+jzJkZOS6OInEzxiu+5CgSEr12SGzlvpJiyX0ltL7Sj535dHlDRmdMB+Slr8aozhbQd3xMqiI5FhPt78nLf8bEsgPa5Bc6kLxp6m8ufWbkFtbvZ5kjSeRb1PDtNKHyatmOXUlixlgjxcTT8/UzgXZ2MU2suPBQ57idZNzroPQAD5PtMGgqiC/Os8eI+X63vYVp+qsjribHC6jQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM5PR11MB1834.namprd11.prod.outlook.com (2603:10b6:3:113::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.25; Wed, 4 Aug
 2021 17:09:37 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::ccb:2bce:6896:a0c3]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::ccb:2bce:6896:a0c3%7]) with mapi id 15.20.4394.017; Wed, 4 Aug 2021
 17:09:37 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     bpf@vger.kernel.org, daniel@iogearbox.net
Subject: [PATCH 5.10 3/6] bpf, selftests: Adjust few selftest result_unpriv outcomes
Date:   Wed,  4 Aug 2021 20:09:14 +0300
Message-Id: <20210804170917.3842969-4-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210804170917.3842969-1-ovidiu.panait@windriver.com>
References: <20210804170917.3842969-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P190CA0033.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:2b::46) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1P190CA0033.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:2b::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Wed, 4 Aug 2021 17:09:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6c252d16-d8a6-43e9-5fcd-08d9576aa381
X-MS-TrafficTypeDiagnostic: DM5PR11MB1834:
X-Microsoft-Antispam-PRVS: <DM5PR11MB18340DAC2FA3423C9D6B9008FEF19@DM5PR11MB1834.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:626;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dgkIyjfEEqzwo2dcs/D0dm91F7vM3Sceeu1Pzfn30fPPYcQkq0H2ligaJfKiaklIUvmQiPA4AWDJoS8XBs9ScYKrRpI+d4KPiddbrLjQhly8O1SM16se3VeiaafiODf2QnBxHi5ABCDJCy+vOJzWqgsTY3gmFJCH6zFrl/22CcyAFeBUSynoWKf7ozPGDBlTMGIby5Rt8aAH4ftbxi23og2E3v3i0Ebwk5xQH3BmxOPvAQl/4h4jYOgqgpxIMDxCH/cq4i01Sw8QG2NBBmndPx3WgPR4HiilXI0Hsxg/U0DapIXkYolTFptVHSxKwCMTMC0D9mbJq4m+fW+fmzah2e8RDiaZv30R9YDSRsXeZuAZFE85W/Oy5sGoifJ7GY+8tTExzPcl+1xZ9noNQCkWqlangLKNZ7QZnyyIRbeGVC9aip7WuGZpux1M1Y7mNUqTDDe3JuGAodbj/dtyiJzURP/wofIUMOElbXrYwBvuwgFp5r7j1qzQJ+/PPrLy1LYCUBMe6tVBykwMJrNufVqyQVPt9EGt5/CEa0cfHpDVMiGIzTO50to50enfS1Zy6F8FWCag93C+byaT3phHUzzAXIltBo3a2DEK/jIh1qL6L+9ZOHCEvhCgf9oncXATh6B8iGB7bPpkUePT/MNvb2tiZa53LuBZe1zPXbyK+L4W9ar25HhJ6l/xyzNfHTjjqEtLqFAmLhfA2FwjNdMtkKhwmQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(136003)(366004)(396003)(346002)(376002)(6666004)(38100700002)(316002)(6506007)(1076003)(86362001)(38350700002)(52116002)(83380400001)(478600001)(44832011)(2906002)(5660300002)(8936002)(956004)(6486002)(2616005)(4326008)(6916009)(186003)(36756003)(66556008)(66476007)(8676002)(6512007)(66946007)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9Kin1ZMNtso/E5ndiG+ndk+axuuwxXcjiUVPKK5dS/0rOX1F8K/DQUtaSpzo?=
 =?us-ascii?Q?jhvwY+VhrzS2qzq+BhDi6aJ60WLRZpVjNA/7uHkQwa55BmuHXW1O4DfvobGE?=
 =?us-ascii?Q?EbZynJYrq9GKS/zsIdqJ3cj8qR00VW0FSAn2wkTRZ+I4X4mF0HmQY0DkA8OR?=
 =?us-ascii?Q?enviCLOGxXj3izuCDrKFm3N4DZ058FVQiXykkJxj0u035jAiG0S1ZB4sqVM9?=
 =?us-ascii?Q?R36MjBicZUW07gAbQSwlCzukylcA6cBds44sUeytYJPCJ6E+g3VJnOHdMUlX?=
 =?us-ascii?Q?kUhfwv7uizrGTbugWfaRgqcX2TlamYoRPxKd8ikCUq71A8BktUv5el+ja+nR?=
 =?us-ascii?Q?0GBpbRgmnIbq80sxstn829KoazTiqBxIDkBZzQu2baGePmZDqgu9kNUQwzAZ?=
 =?us-ascii?Q?v9kV8lX3a9fapqdn38qeVMgwbatISGfqtBejRQFgTDK4Zi+E6tTLN+XWoG3Y?=
 =?us-ascii?Q?gVY5pPorXySD6QhhrVET0RQ4ALdA2/J6nwDvumYlMG/Ff0uMoOtCcF3t2INz?=
 =?us-ascii?Q?nGi9V3AZDoqe0xhZnt5wUJJgC4bn3Lyibeh0KbM/vldF2gPPmavmhY8HLeYG?=
 =?us-ascii?Q?qW3GRt8kjxUmpxSbvtS0PUQtivpLfyjT2DnfkxrEEoIGaAfpGCg7CIC8H3qm?=
 =?us-ascii?Q?W7UFTqpgTMSwV3QNN/3NJQXXS+lNCl0//+WcsCuVHRnfOE8BtfyVQ8SVxPna?=
 =?us-ascii?Q?fmiOiXGJS9Hd3P4xtL/Fz5S/BEk1O4JPfQ8tSUpDEvLp0qPecbUCZdL0X6Ol?=
 =?us-ascii?Q?iMlltsLkR72EvZ3JM7BDlyHvLgKWanyhf0BEJqLbYhiu4abMrZywbPac9TAd?=
 =?us-ascii?Q?WMOFrGNpylpP0VuHJbZJC2GxrjFpPr9r3BAWy3TypjQtl0P1ZnbW4qImQb2/?=
 =?us-ascii?Q?fpBzM/2CLo9I3gcQ2InX01eMyqzG0c+zWnJYN1ZWFtcmSx4YEK46Jqk6+DkD?=
 =?us-ascii?Q?0spUevzElrjmzs90qfxgG0D/WJ7x5lOqLwhCdyhZu+2z/IvxGvYdEhGOdUyH?=
 =?us-ascii?Q?F1Bgp7BVwa18wajzrsRjwU4ZzhNIOh5K0lqU2XcQo1KtajCsR0Pq11Jh81Zo?=
 =?us-ascii?Q?TREjmbj3DX3LgWmqNKlD9O+3SrFWPIAm0fmbNQEaUA0aJgjSyxIz26+C0yr/?=
 =?us-ascii?Q?kYuyJ3TkCprNaGxbWcjkgcuf3AF5RkoT0L8zbEByQUm3yQaAr0/MaLzMoweo?=
 =?us-ascii?Q?ofao1ablM0srMlvABnvm2MNp2vlLpuhcdfOyyosxlFkjp46q15Lo2RMpw0li?=
 =?us-ascii?Q?7DIWl1OIiGpef4ePvzdvi+X9cDzB/Hi3JtY1cDKsbOA7QTxLSSBAyZoC0jeD?=
 =?us-ascii?Q?hdqMj8d9wqQVeMtoeqPE21CO?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c252d16-d8a6-43e9-5fcd-08d9576aa381
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2021 17:09:37.2105
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PbRnbJW9J4QbrvV1FEBWKTDGxu/BK0P/EyF7zIqnS+8zuTpgOU0QS78WTsaQFYX9IiLOrSlj5E0iBR/uRWlJlV5Xsjekgf1c5bUEeqKAe4I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1834
X-Proofpoint-ORIG-GUID: dOikvbRkQPF0YBVYgx3UjU9GyBX6LYfx
X-Proofpoint-GUID: dOikvbRkQPF0YBVYgx3UjU9GyBX6LYfx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-04_05,2021-08-04_03,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 impostorscore=0 spamscore=0 mlxlogscore=914 suspectscore=0 clxscore=1015
 mlxscore=0 malwarescore=0 adultscore=0 priorityscore=1501 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108040098
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit 1bad6fd52be4ce12d207e2820ceb0f29ab31fc53 upstream

Given we don't need to simulate the speculative domain for registers with
immediates anymore since the verifier uses direct imm-based rewrites instead
of having to mask, we can also lift a few cases that were previously rejected.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 tools/testing/selftests/bpf/verifier/stack_ptr.c       | 2 --
 tools/testing/selftests/bpf/verifier/value_ptr_arith.c | 8 --------
 2 files changed, 10 deletions(-)

diff --git a/tools/testing/selftests/bpf/verifier/stack_ptr.c b/tools/testing/selftests/bpf/verifier/stack_ptr.c
index 07eaa04412ae..8ab94d65f3d5 100644
--- a/tools/testing/selftests/bpf/verifier/stack_ptr.c
+++ b/tools/testing/selftests/bpf/verifier/stack_ptr.c
@@ -295,8 +295,6 @@
 	BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1, 0),
 	BPF_EXIT_INSN(),
 	},
-	.result_unpriv = REJECT,
-	.errstr_unpriv = "invalid write to stack R1 off=0 size=1",
 	.result = ACCEPT,
 	.retval = 42,
 },
diff --git a/tools/testing/selftests/bpf/verifier/value_ptr_arith.c b/tools/testing/selftests/bpf/verifier/value_ptr_arith.c
index feb91266db39..3868fbea316f 100644
--- a/tools/testing/selftests/bpf/verifier/value_ptr_arith.c
+++ b/tools/testing/selftests/bpf/verifier/value_ptr_arith.c
@@ -302,8 +302,6 @@
 	},
 	.fixup_map_array_48b = { 3 },
 	.result = ACCEPT,
-	.result_unpriv = REJECT,
-	.errstr_unpriv = "R0 pointer arithmetic of map value goes out of range",
 	.retval = 1,
 },
 {
@@ -373,8 +371,6 @@
 	},
 	.fixup_map_array_48b = { 3 },
 	.result = ACCEPT,
-	.result_unpriv = REJECT,
-	.errstr_unpriv = "R0 pointer arithmetic of map value goes out of range",
 	.retval = 1,
 },
 {
@@ -474,8 +470,6 @@
 	},
 	.fixup_map_array_48b = { 3 },
 	.result = ACCEPT,
-	.result_unpriv = REJECT,
-	.errstr_unpriv = "R0 pointer arithmetic of map value goes out of range",
 	.retval = 1,
 },
 {
@@ -768,8 +762,6 @@
 	},
 	.fixup_map_array_48b = { 3 },
 	.result = ACCEPT,
-	.result_unpriv = REJECT,
-	.errstr_unpriv = "R0 pointer arithmetic of map value goes out of range",
 	.retval = 1,
 },
 {
-- 
2.25.1

