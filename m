Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 231DC5AF00B
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 18:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234950AbiIFQNR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 12:13:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234859AbiIFQMv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 12:12:51 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F5243C8DC
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 08:39:36 -0700 (PDT)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 286CWrgk004050;
        Tue, 6 Sep 2022 15:39:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=ebIt9gJ8Or6vtSD+kdtSzNBdShfJxfDTaUBseYXp+0o=;
 b=ptbCJrOoivu8akBnPJLdyiclGH3GHOxjOIE2hYS6j8LUOHuVByRI+Ifvf5rkPEBqih/Q
 UL5ntL56xM0Xg8XEaIJAyMXgkbwH3sVdGJ0mp1qi+Pr0g2EOimbr1MdioRF9MVBfTeYt
 HfosyOx3nU37ZvI3V7Z4vh8oNM5DPR7yK1eI/VaGAUHC9B+Rv1eF0ElEnDz9WEdRejOE
 kdy2Ug10KzOtJgXHZEENpGyMR6Qd7LEuDjq2CMcwPlD8VpsxCyaCr4908SXdGbKnNWmZ
 Crcjlhcpa0V10iBBuH5jXi1IcmObuQcN4Lkr1oKc4RdciA18vt+jCTOXfkSj451/9WAt Qg== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2108.outbound.protection.outlook.com [104.47.55.108])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3jbvxdtr4k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Sep 2022 15:39:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wh2/khmy5h31t9qbDScTCj0c/L7a6Nm66kiPhZlr68I6fL3eiYYixHrjdmU+MwuxNAW8oiCmxT5yjt2ojeGYPkRBQRmGFdvAGNUSNrPW4emaD50ypFUKW1s1TUVLNbZJihTlKhbwOD/KatYx+RV8rF0mf3UmH/B87QcxhEdKZ0aobHEOzkQqhwYyFA83rRcndOpg+U+5lvDwIi1+wxHCLALUxJ/+ypcUv3t/zhkOUnceWTO+kCe0wfb2UY51xXZSByZp37hcNooQ5FV3tssBD+hPQVPA1fSR9JV1S4KUBBRzC0ITLwC/7a8kt7QuN16vvc9+n1jY7FCUKybgQqHuSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ebIt9gJ8Or6vtSD+kdtSzNBdShfJxfDTaUBseYXp+0o=;
 b=OxnRqmFhY7EDiV0nBTInJKqO7+/aEqTwhDeeE5rOySACXktsLC4XTlZ5nYPTB6KrKijLn8CjBwW2P25AB2xKL62qOIajm1dVa0dlF6V/YLpOJ2s5GoyhRSjlWEQCZTarWaWk9SUqikdtmrcUrsDmMAWXzO3WHqBPl12jFCJGMWlrMLa+xTwm+2E7/O/QfWpJG5Q1siNjrNLV1G2GfSYMggykxFR8Eunip1hMppXq9yxt23tLjHHmY7l+QMcT+kYhtBjIghWg2wSvcA+st0nwl+p2tHSyDqGX48EZ4ntYyGpnQidixr8g4RQp7GA22BZBYD6G5mr8XRWnaf9jp8zDwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by MWHPR1101MB2095.namprd11.prod.outlook.com (2603:10b6:301:5b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.15; Tue, 6 Sep
 2022 15:39:17 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::b4a9:c48a:51c2:d3fd]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::b4a9:c48a:51c2:d3fd%4]) with mapi id 15.20.5588.018; Tue, 6 Sep 2022
 15:39:16 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Maxim Mikityanskiy <maximmi@nvidia.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.14 3/3] bpf: Fix the off-by-two error in range markings
Date:   Tue,  6 Sep 2022 18:38:55 +0300
Message-Id: <20220906153855.2515437-4-ovidiu.panait@windriver.com>
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
X-MS-Office365-Filtering-Correlation-Id: 6786f064-24d5-4b62-bc73-08da901df52e
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2095:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZnoXO3pkN6mn125MhaFBKLNtNaM/OK72O3TnVPBpNczOZndueM2jLvblfA6U0DJbB1EZ6eAWTvpbYCA3F4+W0pqk28m296T4wbl2rlVj3eWyRJzL/5SEHbsDk4ho9MbN8kRZVLhdalTk8FqFB5Kxx3f19vFu8FvMv6hXAfqw5w3BBsB01SiDd8qGd8Vk6n21tVXhzoCySYLXrMcVJL6Pm44V9rYthckVo08qyOuGePaoohVxZ3j5Cd0Q9aKxMs8ZHMNZjyQluZvs7h/ZY1iIlJauNIr41x1o2Z3+f0/GB0XUS+z8avNPQMP4ue2NA3xvkJFr+PnlkzJ/ZfP/iQ3Pu6V8TluITURQ3cSxMdRyuRu01rxRRXiikQZjubJphNf5QlUpYbe+T7fiqQOVcVGbMj4tLW3jNXjGStsAUcqSnKG9sO+bVyOF+8aCgvghkfLvmuUp+H8B0aygASA64/q979TPL/4FaLI8crE0xokoGXswtaSGdAOAfcZ+GIEpZ2fcNqxJvNEA2OGhacY4d/556Yi6RwrJoEaeCMsyoqz7EhxkzEK15WdhZu2L6K0PHCYtpo4G0uIhAYi6deFV4dGIukA9j2EyZGGQHPPDZ/LuZcFLWiBmEDLrTQgrJEqzEGD6YRiZW9N0pxgrFxnVNSHo1mvWPsZOOEQBenVNCJ2+ibifAZG1JtrwGm5qmC+KioZ0j19vPXqgfDPJXu4z/j/Spaht+Y67RuTd98kkQm4Sty6dhQ0TqYqZUMPlDjKeXl+YQmFPWOsKbVIdDAsbVFx7pEmUBS8I25wJWQ9Zqv2XcIw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39850400004)(366004)(346002)(136003)(396003)(6666004)(38100700002)(107886003)(5660300002)(41300700001)(6512007)(52116002)(38350700002)(6486002)(83380400001)(966005)(26005)(186003)(6506007)(2616005)(478600001)(1076003)(316002)(66476007)(66946007)(86362001)(44832011)(36756003)(8936002)(8676002)(2906002)(4326008)(54906003)(66556008)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HeMcQGtCfjLL9QRH6LcCiueOx/AAw1GshaJntOFirBoaSLUZtaMD+rCew1p1?=
 =?us-ascii?Q?oaJdElYRMSh7QJzS2YbApmgpIG4gjoEVUrilnGVcePSMSdeIxuBtpTS049hI?=
 =?us-ascii?Q?YXVSnnwXtxRr7WswaWAwu8uFRQjNM0JoLqK9RiOzVzfJHzcCFuUoS72ht4Gm?=
 =?us-ascii?Q?PyPzSrfvQkriHbDSlF7zZhSGExXkuxiuG5HLTR6RCXahvIDSexbeCSFB0AyW?=
 =?us-ascii?Q?Av/l/D+TEfc77voNYBNAdlYL42lzW4x5xoZ+JB3j69aNd35BGHiA1CQ3cC/Q?=
 =?us-ascii?Q?x1/dTP9nv7E/j7y/Hu3GFHCt9HUvruRfGZGxudseto3+Z5gZNqcmqVlbBgco?=
 =?us-ascii?Q?PL0H7JTf8avyoJrqcyul23GcinurzaxzPdXWv6QcSVgRuP4pHyGBO/PkNDak?=
 =?us-ascii?Q?vzqNaryKIY19X+0ISENJ2F53emcHPnn8lDi1bddMbY9BCaxci5oF6kptL3Qy?=
 =?us-ascii?Q?M5QIWw5XYR4a/kiDa01Wf2R6xPBa5+0fJzcDvq04nhwuq69ofnhOM7yNEFXD?=
 =?us-ascii?Q?odaWBPxBlgZO6Ni+9BonvD/Ye1KbxSCg4n4ey+W02HF39NCkp9SF2yiU8rvW?=
 =?us-ascii?Q?Mt1lT56DaD3dKGbLe+aWc9ks/80eGdTqfUHL5OdLmTy4TMsZ25slIEx0n4p5?=
 =?us-ascii?Q?mfFBNOioTlyy9pvC2dCj84Kiv/rUnszg18nHbHUZGyOCwKe9cQlY+NVjEOzx?=
 =?us-ascii?Q?qoaNiydjdfiHfN7OCFh2oLjOCR0n8Wx7aYLeP72PPV1I/jgT5LU2wf/VVWil?=
 =?us-ascii?Q?8S9JrcOtcfH755lsGRgzRME12S69po2k5u3rFj8GxFcE7B2EXneyq0hNYa4d?=
 =?us-ascii?Q?AqEqsNn0mJ8aKSpFwunAuuz1GbO5BDVO/jN4wS2d7US81SIcWj1crRWBPkIs?=
 =?us-ascii?Q?dCt5P1t5f9u37bSu+Vm9PINK8pZFag+1QZhctFvIUApEDQGXjFppTEVypImr?=
 =?us-ascii?Q?v5/O/RxtHtolaOlKqG1G0x7dZB86cbBStmarpgu78hU+6sfugauopC7eM+6e?=
 =?us-ascii?Q?lXRVC+Nv2PQbr5e2sXhxDcdFf3nIcXz521X4OV9OSbFl9NddqhwM84eNaC7l?=
 =?us-ascii?Q?4+Vca3eCDBUHu2C8JJ3vf/DUa1M0yleU7Zz9ybZDGfl7zN+qx29XoCQhmkrM?=
 =?us-ascii?Q?dNRUzu2PldVBsz1Hh1H+X8xWKR1DKhbgOqKPaVtBOq4470PwTM4KxyXGYQVp?=
 =?us-ascii?Q?q2svAL8vpxNiNjdsuvi7orwIalL/oDtBQYjvMnyJEQxz9+14Xs7MhNRonaVm?=
 =?us-ascii?Q?T+87Y40ybhZwfXWOoAs/SZhbYZVZER88K41uKsK9ZNHt9ljkniu/WbAkBJoy?=
 =?us-ascii?Q?iWU9IRHixNBwam0UVhMlJ3TJ4BliW6NOvxMQHZKxAD/zBEa1Xlr19CCcxRQ8?=
 =?us-ascii?Q?wGXizEViBDRf0TPDvWCjrLSBtZ54ZdRRRvtppdxlbjS45kwPGG3uvHgdZyTH?=
 =?us-ascii?Q?ex0lpDmHXebMA/i/WtiQE4E0Vhne85ZFDbUB9piJZPL4J4AXo27+q/pqJ96e?=
 =?us-ascii?Q?zFLKh5d7WaS0MjTMgt7q40K33M+luzk2MQqwczdxc/T1dQ/W5A+511aKRVD4?=
 =?us-ascii?Q?C8gSt7KJIjGU99wXF4f+2o0ES2NV5sDzWbQhL8z3S4XnUEVeN2DWQdahXRpe?=
 =?us-ascii?Q?Ig=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6786f064-24d5-4b62-bc73-08da901df52e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2022 15:39:16.9528
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bbZexxcwCiGk5yCt30fg85dHqTlsd1WnZVzULpAb3HF6fioc1REm2vgTwbJNba6onpbkXwhoJykBMIuhqVQbcU1eOYlLbsfgRwTPvJbrtCA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2095
X-Proofpoint-GUID: 5PwWarRuwQGCcWb7e_1ohVx7kxP__tBH
X-Proofpoint-ORIG-GUID: 5PwWarRuwQGCcWb7e_1ohVx7kxP__tBH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-06_08,2022-09-06_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 bulkscore=0 malwarescore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 phishscore=0 suspectscore=0 clxscore=1015 adultscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209060073
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
[OP: only cherry-pick selftest changes applicable to 4.14]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 tools/testing/selftests/bpf/test_verifier.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index 0846345fe1e5..f7757f7f6d2b 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -7438,10 +7438,10 @@ static struct bpf_test tests[] = {
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
@@ -7494,10 +7494,10 @@ static struct bpf_test tests[] = {
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
@@ -7603,9 +7603,9 @@ static struct bpf_test tests[] = {
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
@@ -7770,9 +7770,9 @@ static struct bpf_test tests[] = {
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
-- 
2.37.2

