Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA60B3E18CE
	for <lists+stable@lfdr.de>; Thu,  5 Aug 2021 17:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242509AbhHEPyq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Aug 2021 11:54:46 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:50352 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242533AbhHEPyp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Aug 2021 11:54:45 -0400
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 175E33f2000974;
        Thu, 5 Aug 2021 15:54:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=/b0L+hGDTaliuoDYr2kRcuOqiUxRCZXrx4bYDdTMhdc=;
 b=EcRZYRwUlT9KZUmr6+lvxy5G/8bUzq2XtjqpYsm6Ehh8JHRgwSg8EDbxKwK206a2KU/n
 eXtfBBEKFimAfmwTexSw2fwkYbDa3+TRQOxw6MOqvjY54ssi6z/PVUCvTMVMal50+bvM
 MJkvTPhR0afyWz8OEokO9jsay+O3gxVyR6lVgSV9RQpIcnxxQieiFl/6JVZACt/fdFgN
 Ve3zmOpSUDRr3Q6zgZZYmpRJSHa2lMPSF0anZVdqpKpQMtIyekni8w4CGz79mh+w1Yfu
 2lAX1cttEmYxReSf67cS8rFRDBx2YAmY4dFBNJ0/BBfprpXCNheKkBJoHyxSicIhcLYK iw== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by mx0a-0064b401.pphosted.com with ESMTP id 3a8gny05bn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Aug 2021 15:54:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tw7JOm3LMe7OouQLra19yoWlJ0Xn44ShWh66XXj81viCwcBJ/lQUUlPfoxRX80xXACOTfj4fTEtXSbIBwBYBI9E9s6rib+A4VdgJUL1LOdcuxRfEqEbOeejs1c4pbPocv4FTBUme6Gv45gELx+K+loQifLPDRW5gDD5m6ZyFM3/RMOVexgOdRtjU+gmeDvyLqOzeS7N2gF6pSUFnDp6+lBwHUFvfF2pV+YDZrFGFrL7rfiOcLDt4wfQkVsNHiR0sHJFLBXtS23xErBpVTDJgz6AFG1SaOL1mn0OOEIPDAAHl2tJ0aHKeIzhGsn7DqFoV9Mkiph9T/YtJpf/+hR7nzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/b0L+hGDTaliuoDYr2kRcuOqiUxRCZXrx4bYDdTMhdc=;
 b=JXyoObc5PPHkFKhHCXFHsfepfO6y+mHelHqeHteMxgH6+1WsbH9IzMM5Ixcr4gcCzsYEsKN+7RQba0CVJ0qojqSF95mz1dxTyfljUC7PhN9Syslg+FDS3vmOb8+oC3llpVhqydqQFBCs8nJ6e3/rrgsmJcssNgDh4R7JR2UIUmfnkzX7IzOuUC9QKCnMa672R5JCjaoHJeUvR+eyxqHu2Qtk3hXSUkwantKfkAbuuisBgg+dCATLDS/PWp2ZaIcQC4MkBwj7z4YVIuxSW1zIl5zQHRG1521DzgVVAkNkpZog8Py9bUFVRKxJ1VZwPbH/3terNKDAEwp1/MIal3U1jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM5PR11MB1722.namprd11.prod.outlook.com (2603:10b6:3:f::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4394.15; Thu, 5 Aug 2021 15:54:05 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::ccb:2bce:6896:a0c3]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::ccb:2bce:6896:a0c3%7]) with mapi id 15.20.4394.017; Thu, 5 Aug 2021
 15:54:05 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     bpf@vger.kernel.org, daniel@iogearbox.net, ast@kernel.org,
        john.fastabend@gmail.com, benedict.schlueter@rub.de,
        piotras@gmail.com
Subject: [PATCH 5.4 2/6] bpf: Do not mark insn as seen under speculative path verification
Date:   Thu,  5 Aug 2021 18:53:39 +0300
Message-Id: <20210805155343.3618696-3-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210805155343.3618696-1-ovidiu.panait@windriver.com>
References: <20210805155343.3618696-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0002.eurprd05.prod.outlook.com
 (2603:10a6:800:92::12) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR0501CA0002.eurprd05.prod.outlook.com (2603:10a6:800:92::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Thu, 5 Aug 2021 15:54:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 09af3296-878f-458e-b911-08d9582940ac
X-MS-TrafficTypeDiagnostic: DM5PR11MB1722:
X-Microsoft-Antispam-PRVS: <DM5PR11MB17226F3EB0B98EB08E2C732DFEF29@DM5PR11MB1722.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RJ3RLJOYWck1qvfoRHqobH5m5ao771pFdFNAO6pardIxyG8OKtKwrKtbAJo53A7w24f901p1xZJrQrHPVobS03y2WPHamAKV+S3miXgaxj3WHkv9sQwL3MswpfcYceAHccPvE8lM06AAKfOHI3DBwuepzl+IBDfcBlgeVshYCOqcD2SrsRTWaNRF/Z7vy5o1gBds+AvSdqPFe9wemWvu9wfj8S4Ex2x9lgsqmtzpwzQDQJ3FgiUsffW+vQZor1jRixsUDo7nX7ARhP8Ps48PRzCrQVnB2qFjf9tSZgLpKBeW7TIHFVM/HfYjh/babvmlpuSSaTxiCgqw5aVoByLKkxSWxtVHY/X/36NUHP/mo92O6O3q4Fq8sJtmztNVf+IQ+By93Nnfh/oHWvu5OvLVo8IJbcEEhA3XKShGOJG5U+BMA6sYfb53osNURqjxQfJSdPGSZQZJ79WfglWmh9GV97lgnznZOFdUzTaO1DiAYlGA5ia8FyMDjNXQT1xnSBx7LptXeSw5CsYnTg5CsoIDLRhflKoNg3KLZlhGfExK52RJn2cIOQts4ato4e0wx06woqjLx4wE+bFNCeMOW3Fwb4OcxSBUtzPRwmvkLgEXwA2UVrHAQ1eFzmbPXFoFokl/lR/4HzoMMZ8n4wd/fpk/Rbx6onSAM2rLF7G8Gu/uh4o95QtWrKxIphtAv/1OlwpMMy9yqAE4HKXUexuUVtMOBA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(396003)(376002)(366004)(346002)(136003)(478600001)(6506007)(6486002)(956004)(36756003)(2616005)(15650500001)(186003)(38100700002)(1076003)(8676002)(5660300002)(38350700002)(316002)(6512007)(8936002)(6666004)(2906002)(52116002)(83380400001)(66946007)(44832011)(26005)(4326008)(6916009)(66476007)(66556008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jwSYCW46ar7rq91LHDN2jidEoUZk7MLDy5wdAkyArB+8n6lyns6hBE8xHKZD?=
 =?us-ascii?Q?aqzS2i0M3AT2R3WVnpxqYkoiOJ9YvZkFlE4df1u0oHGGvVwIv4psjTmuPZI4?=
 =?us-ascii?Q?AahgxKquWwL4+eeQGOdIvDI4iG5UMWJYuFeZ/hLSInaDzT8X0guW9/rAonxC?=
 =?us-ascii?Q?p73t/I175y0snsGruZShfo2mV4JMf7hJz28+sa9GzvHyMqMUOW6XIZssFjUL?=
 =?us-ascii?Q?XY7SwtPbJbs2BrKUGklwhC8987AJc9ibveury0bWGrvXqQpXjsc1yC/y8Nsd?=
 =?us-ascii?Q?oG6PMKGySJ2RCeCIUx+TCRQD+wZV6ex5EE/4cs3YcazhsECgNt26DC/27uRW?=
 =?us-ascii?Q?4G7SJLCN1b9ep1ahaUierHednE1MjbwFOIh+yifiWG6PQ/vqgqdTPxIxvLtT?=
 =?us-ascii?Q?gOwCWIn2rd2TS9fstFMovhCdMjKLyXhk2Uci2Q2Bhtr994TJJk2pqmgxtqzj?=
 =?us-ascii?Q?4c1rRwhIz4EDo9q2S8FhbSDSZRYFrjkOr13biMyUkG6ZBqWpU1peQvQACVDi?=
 =?us-ascii?Q?MGquYN16swD3oQe3MGkKKl1W27MI0fJTcac/yReZndRfnEJZA8VfNh/bTyrz?=
 =?us-ascii?Q?EGBJnmgUZGUGVLFVDbwMsjKaCSHoDJC7H1tBdKvGOngOhiP/P3CZDa9b1Iw4?=
 =?us-ascii?Q?lUSnAjb3nSlUmTCAF2tsnHwYJx2+SCgmuf6AFQ7VdhYn12s+Sz4l1nHH4Neo?=
 =?us-ascii?Q?CHAnrtAEEAwl4zjCXD0UexIM1dGhKGfGlzfr/lAweM+BP8DKaw1vltrhHTSv?=
 =?us-ascii?Q?HOG9ziGm4I2UAQ1aIjvoz09Dq7+m7QVbw0vdsmcstPstOL5B8D0A/KHtm5sY?=
 =?us-ascii?Q?r9qF/i/djulfQM3ImDSZAdu8MnyKAjb6iXCfKx3xWAHbMja99wRqM+d/r28o?=
 =?us-ascii?Q?lHY62tn+51wvAGh+wpdnBpbzU0N8d7RibxRAt4Sy7HaLyqd9K8eF/5GjI+hV?=
 =?us-ascii?Q?JYbIMj7fI9Blj8UJUS/9R3cvUYnbilN8QyiRFyrAsN4G/U5pFfo87AJ+zi7W?=
 =?us-ascii?Q?BNnqTptVnqHIZ6CarBWYrtCPyMUrxomqlTSuuh+4KmHFLPFzc3ER74E8DBnM?=
 =?us-ascii?Q?AtlX6RBzULPDNiciDtVdA/JPp//tG4MbMDeMKdjBdn+LY9lFCOHmpl6XNMyG?=
 =?us-ascii?Q?Wx3sSCw4zDM20MBwKrQAFElU7uwVWxy5/VxExyM6Vevs4K3MenfCLeh4xnbM?=
 =?us-ascii?Q?R8PeKmGWkSMTl70sS9UK2pSayit7mOAvg4Np1HiGLzYjtUB7uk/WRbLCzsgv?=
 =?us-ascii?Q?CfzriwY+69Vkn78xAN9sIS2YCGdtfX7YxIT1wbYZDHREnPHzddblsOsgPapG?=
 =?us-ascii?Q?v/kSuPtmdKzxMIamB5w3MEXR?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09af3296-878f-458e-b911-08d9582940ac
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2021 15:54:05.3432
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CratkG7cbEov3v5RbigsR78CjHOrgWtlBwOgTkhQhxzX1hQZuq79wqqqOlT25ruIfzJyuVrYdG0w4XqNdK0xWQv5NQzPqQIigknXQM6A6/I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1722
X-Proofpoint-GUID: PCfwaX2CaRrD5hLUp-R523TreYuOvYt5
X-Proofpoint-ORIG-GUID: PCfwaX2CaRrD5hLUp-R523TreYuOvYt5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-05_05,2021-08-05_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 phishscore=0 adultscore=0 priorityscore=1501 suspectscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 spamscore=0 mlxlogscore=598 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108050097
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit fe9a5ca7e370e613a9a75a13008a3845ea759d6e upstream

... in such circumstances, we do not want to mark the instruction as seen given
the goal is still to jmp-1 rewrite/sanitize dead code, if it is not reachable
from the non-speculative path verification. We do however want to verify it for
safety regardless.

With the patch as-is all the insns that have been marked as seen before the
patch will also be marked as seen after the patch (just with a potentially
different non-zero count). An upcoming patch will also verify paths that are
unreachable in the non-speculative domain, hence this extension is needed.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Reviewed-by: Benedict Schlueter <benedict.schlueter@rub.de>
Reviewed-by: Piotr Krysiuk <piotras@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
[OP: - env->pass_cnt is not used in 5.4, so adjust sanitize_mark_insn_seen()
       to assign "true" instead
     - drop sanitize_insn_aux_data() comment changes, as the function is not
       present in 5.4]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 kernel/bpf/verifier.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 526e52f45ab3..02a04a30070b 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4435,6 +4435,19 @@ static int sanitize_ptr_alu(struct bpf_verifier_env *env,
 	return !ret ? REASON_STACK : 0;
 }
 
+static void sanitize_mark_insn_seen(struct bpf_verifier_env *env)
+{
+	struct bpf_verifier_state *vstate = env->cur_state;
+
+	/* If we simulate paths under speculation, we don't update the
+	 * insn as 'seen' such that when we verify unreachable paths in
+	 * the non-speculative domain, sanitize_dead_code() can still
+	 * rewrite/sanitize them.
+	 */
+	if (!vstate->speculative)
+		env->insn_aux_data[env->insn_idx].seen = true;
+}
+
 static int sanitize_err(struct bpf_verifier_env *env,
 			const struct bpf_insn *insn, int reason,
 			const struct bpf_reg_state *off_reg,
@@ -7790,7 +7803,7 @@ static int do_check(struct bpf_verifier_env *env)
 		}
 
 		regs = cur_regs(env);
-		env->insn_aux_data[env->insn_idx].seen = true;
+		sanitize_mark_insn_seen(env);
 		prev_insn_idx = env->insn_idx;
 
 		if (class == BPF_ALU || class == BPF_ALU64) {
@@ -8025,7 +8038,7 @@ static int do_check(struct bpf_verifier_env *env)
 					return err;
 
 				env->insn_idx++;
-				env->insn_aux_data[env->insn_idx].seen = true;
+				sanitize_mark_insn_seen(env);
 			} else {
 				verbose(env, "invalid BPF_LD mode\n");
 				return -EINVAL;
-- 
2.25.1

