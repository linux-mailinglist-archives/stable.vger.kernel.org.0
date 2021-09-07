Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D490F40298F
	for <lists+stable@lfdr.de>; Tue,  7 Sep 2021 15:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344691AbhIGNU1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Sep 2021 09:20:27 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:4624 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344600AbhIGNUD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Sep 2021 09:20:03 -0400
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 187CwixK009946;
        Tue, 7 Sep 2021 06:18:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=PktO9w0nxKKES3p2webYAane285B8fZmgK9l+7T459M=;
 b=dD/a2k1Z3umc/bAVT9//7sCx9+X17DEPdKIE26A395766Con0qEKbA2uynfnZy/t316C
 pyPBAlu80qPiVrWH6OJpc9xxDLKA9njROC+zs3w1sIAP+3Q0UkFWkS9ucDY3VB6x2z0n
 RBE19h7yssSgXBv/oCCXYnU+yJDzdN+F6egoSwGPlGNlLqryLSHSCMUM9sbLq8Gv8D5y
 YvUWPmwG+k15+Io/li094enQ/sacG0Ll/mWefgA6PB5MWmnwnkcxi9g5r5j/H4mcHafE
 iSLG5eK7solXwWDS9jJvd9/BOgyJm8HjvuCs9MZl3S69tcrwvntXCyyFdTJpFGm4jPBT Lw== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by mx0a-0064b401.pphosted.com with ESMTP id 3ax4nj856n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Sep 2021 06:18:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VVbGFCCul4rBlH9YY68+zh9vzk1yFCBPR61pSar5rfhqtBZ/V4GmWdL9HDzqew67Ii2geJ/CRJWW3cms4ZSVwMrRIaQts0wauR/6N4dHWWfALO1wAZ4470pHKaRQQO73Kdk8dN++QGW7XH2cTRr6Lxg9xMnIYAXHMOio4msyVU8jpBqpOfeQ8xPG+h4j/uhi5a9uu42KjNOf2NgntUAXfnih3YDTiWkw8jalwZ2hxonEZejZd7OwivU4TFkTSzXrK8z27n+yV3VVen/grzfmUEDJIwg/nXsK+k4WwqnigJhqsiAyYSHuLdK/NMCzrEMok/fWA1qDXKFOaNQUiT3TnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=PktO9w0nxKKES3p2webYAane285B8fZmgK9l+7T459M=;
 b=k+uAbLu2ufJPxTPr6JjqrbTcM6r4FPM1VkHjihOLUV6JpXn3Xz7cDXINstz/j7WDqJUF5Mc+ipKeaDBF2FYNDrQuGDZQPpn/9S95yV37+H0GMjW2Rr91rm2WRvOMBsaUOldyfOt5L7KzMaw6r3k57tLhWWvUqXFkxQuE1+UoEoTOsociLzkbS4cjt+s3JSgospmuWPgKf8EnzQYDe478qDYUMw/CWbbeLSYYQEBgrM9je0MIRKnb+G/AmpXbj5/dn6BdXjRtKLS3S9a+he/vko1mzzix2crOtrKV8WqUH2Zz4SEZb5gTrapLkeGNI2dm4ZQqrj0r/etH/PjYk1E48w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB3114.namprd11.prod.outlook.com (2603:10b6:5:6d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19; Tue, 7 Sep
 2021 13:18:41 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::952a:bdc6:20c3:94cb]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::952a:bdc6:20c3:94cb%6]) with mapi id 15.20.4478.025; Tue, 7 Sep 2021
 13:18:41 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     bpf@vger.kernel.org, daniel@iogearbox.net
Subject: [PATCH 5.4 4/4] bpf: Fix pointer arithmetic mask tightening under state pruning
Date:   Tue,  7 Sep 2021 16:17:01 +0300
Message-Id: <20210907131701.1910024-5-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210907131701.1910024-1-ovidiu.panait@windriver.com>
References: <20210907131701.1910024-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0181.eurprd07.prod.outlook.com
 (2603:10a6:802:3e::29) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR07CA0181.eurprd07.prod.outlook.com (2603:10a6:802:3e::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.6 via Frontend Transport; Tue, 7 Sep 2021 13:18:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3764d177-65b6-4498-02aa-08d9720202b7
X-MS-TrafficTypeDiagnostic: DM6PR11MB3114:
X-Microsoft-Antispam-PRVS: <DM6PR11MB3114D8519BFB43A0F089E87AFED39@DM6PR11MB3114.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7rOBrr3e4iWLIbvfutvW68FDfZSZ1OJ3HM/rpJqcTvv20hFSFUn6/3FYxtbgI4504d0+bN5/3iAbZ6t/kwdVJ1Zome2vYRPjyt4St//HQtv8aptcYC7MFeEPgxDh7uQ/mHbwqxChr/qZqPng3FyFuHevID2A6KTH4hJ4FL6rcUr1oi1onyraRIoVCGUUaY2euLOPDjkPop8ghqVheeASxam+p37n8QL9U3jYFqmJpJU+K++57an8zHuVygVVyRp/gAIe2Qc92yDtiIHubxB3Ovf99Dv6kKaTawVezkrYL/UMBQjVUw+EeJfMC6kaoC6DNqELwqHiO6uIJno7cnrPzt95BTzDGHgsLRCn0rtEplc2RaR8T0cZn9xurCOtFy40u/UtdK0yn0sT/KjYLzc9UNgC1J3JwdXzIqVLY7Z3KZbcqcy0o/pKO37YVOrXBv6CFg0pQjue568vCs5LxS6Rb6auZM+ieWMRezqLt4lPueJmXnW7i4ZnRGK5u2EUWh56yqzIvoIbUq7LiVWx2k4qwUhgNqwRXWpzoQzGBL86oEcndb8TGo045cMFTnfU3QH4GLWZyJM5+wC2pGJiaCMxcrg0OG/60Xj3DFfik6wD1QB7eer9boZBntkXApjuEzfRiWMsAKXlkrLw9xKllD8AFvKGU1KBgPN819mVn7rJI5Cxus9TK9O4nloGADc9Fs0O
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(366004)(136003)(376002)(39850400004)(8936002)(83380400001)(38100700002)(6916009)(186003)(4326008)(36756003)(38350700002)(86362001)(2906002)(956004)(26005)(6666004)(2616005)(8676002)(66476007)(1076003)(66556008)(44832011)(6506007)(6512007)(52116002)(6486002)(478600001)(66946007)(316002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DIWO9WdCzsmYxupXjBWKaMNSLaYZ9Be5zPN0uiDI3I7aCbEAzwqHvuF1gtU5?=
 =?us-ascii?Q?4z+GrxBbmHtoNuLRhFzANMlbdBz2SIQXnP3/wuhuFS1zIIVLWgBYWDcvTIHf?=
 =?us-ascii?Q?eOaorFr7B/oDjC0I4elS3ioft8ZOj4APr78vztYn27Ofw/7IUNG407rvvBxy?=
 =?us-ascii?Q?O/bFBhxdXfDym3VrhAt7ctT2mzQMF5BAkoJpZULkNE0Vcmn3JyWO78JiPX+Y?=
 =?us-ascii?Q?g5UutfjDLXOP3vBInwTY6GU40TnhbvZl5ZHmws14FEyQcDVb4vGkT7cPx6r3?=
 =?us-ascii?Q?VpoaULj3VcRo4gjgYEn3JZcFiNa6rLag/6oY8NFgSypXWib27tGBRKAidPTi?=
 =?us-ascii?Q?3cccst2Dh1eIdaxuDoPjIdCkGhaTUpIFHGg9JydxFIQdn5ljDg+fz1e1yI0R?=
 =?us-ascii?Q?JE+K4rihr1pX4qz8Df/X3WxEbUwhp3RqnjdKpB0J7ngD/ExwtQF2u7BUYow7?=
 =?us-ascii?Q?X22QCm4OIeS7WvfABXu7ADIhTf8Jz64GMBEqMhUjqGsybsBeMKXXPSbzQC6f?=
 =?us-ascii?Q?QWk0CIU5UPM8/Zvv+spneVpJhLfU2g1a011pL70K8B6V9QMu//Pwe9sYgFaU?=
 =?us-ascii?Q?sxmX/ZU/ZL/jOQw25rjqlm+UnJRD2ewXGCB8W6+lYq81oM7G9beONe0SrTp5?=
 =?us-ascii?Q?SktUGaHbCuEoMWDSwV8bhEAfZNPwxRIGFiRSWdu7+crRC6qAOIC0rHaMvsaU?=
 =?us-ascii?Q?k9Ir7ITKzb+mDqPONwIgoTxwhq9kh56Swg+zqBuz3KIOUP8Brpb86aalxbYw?=
 =?us-ascii?Q?j0K3wKo1WGdOyOzkMPlROWX5hwycW2fA2YEiUU+JGsb484ecRGzPFDItbfN0?=
 =?us-ascii?Q?Gals2hlf0mi0pj08PrhdKSq6z1fbbMoU+FzIMmTH3oi9vlUMT4Rv55q0dKZS?=
 =?us-ascii?Q?tcbUG/Bbr6T8sHr5tmZDSsVIUSTlfSGsS1pmkRMX2Qn68dZZRvL2njTcQGn8?=
 =?us-ascii?Q?6klTPJ93FX7suC588Lbtv0X9ww9hn+AnRDdW9ShULlNZOeltS9NnYuf9gVLF?=
 =?us-ascii?Q?+Z/TCr12gjisfDaiYGKJlL95Hdtsy8QCWbVgz5WtTI7Q/zjODQ2bEH9ncE7P?=
 =?us-ascii?Q?l2v4Ro6eXQKWAh/eOQMhP3gpx6c+zZ2wafdghdxTScuZf1j2rW/GIwXJvBVr?=
 =?us-ascii?Q?abwbCSKN8aBJgRsqsK8Za5Jcue0ou9y7vQItdVH07nCZYvVTVKcCpq2tscyn?=
 =?us-ascii?Q?+n3HC6OlZpVa1GkQkypsnwi6zNbrCwtYcXkeYgrMSU/AmROnPA03qX69J13/?=
 =?us-ascii?Q?etEa/efQgR3EIdsznEce4WnzkjuvjnYdOwCY2nkE+67pqqZ2icH814oaPRNW?=
 =?us-ascii?Q?zyGAUElIYV4imTJ/OZKHy94e?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3764d177-65b6-4498-02aa-08d9720202b7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2021 13:18:41.2059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hx8OWv6oe+2gYEV7qiohwZ+ZEQy0cZz/h6l0AsJfZGpqsaCJQ7U9A/t9fWyifNpqaTF8MWC95hVVpe9DR+EgKgLDEyvU6Gx+8Z0fTLNgUxc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3114
X-Proofpoint-GUID: UJQGwKvlKlcirG8UBc_KC1jAW8xQ3rzS
X-Proofpoint-ORIG-GUID: UJQGwKvlKlcirG8UBc_KC1jAW8xQ3rzS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-07_04,2021-09-07_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 adultscore=0 mlxlogscore=797 phishscore=0
 suspectscore=0 impostorscore=0 bulkscore=0 spamscore=0 lowpriorityscore=0
 mlxscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2108310000 definitions=main-2109070088
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit e042aa532c84d18ff13291d00620502ce7a38dda upstream.

In 7fedb63a8307 ("bpf: Tighten speculative pointer arithmetic mask") we
narrowed the offset mask for unprivileged pointer arithmetic in order to
mitigate a corner case where in the speculative domain it is possible to
advance, for example, the map value pointer by up to value_size-1 out-of-
bounds in order to leak kernel memory via side-channel to user space.

The verifier's state pruning for scalars leaves one corner case open
where in the first verification path R_x holds an unknown scalar with an
aux->alu_limit of e.g. 7, and in a second verification path that same
register R_x, here denoted as R_x', holds an unknown scalar which has
tighter bounds and would thus satisfy range_within(R_x, R_x') as well as
tnum_in(R_x, R_x') for state pruning, yielding an aux->alu_limit of 3:
Given the second path fits the register constraints for pruning, the final
generated mask from aux->alu_limit will remain at 7. While technically
not wrong for the non-speculative domain, it would however be possible
to craft similar cases where the mask would be too wide as in 7fedb63a8307.

One way to fix it is to detect the presence of unknown scalar map pointer
arithmetic and force a deeper search on unknown scalars to ensure that
we do not run into a masking mismatch.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[OP: adjusted context in include/linux/bpf_verifier.h for 5.4]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 include/linux/bpf_verifier.h |  1 +
 kernel/bpf/verifier.c        | 27 +++++++++++++++++----------
 2 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index d5a7798a4cbf..ee10a9f06b97 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -371,6 +371,7 @@ struct bpf_verifier_env {
 	struct bpf_map *used_maps[MAX_USED_MAPS]; /* array of map's used by eBPF program */
 	u32 used_map_cnt;		/* number of used maps */
 	u32 id_gen;			/* used to generate unique reg IDs */
+	bool explore_alu_limits;
 	bool allow_ptr_leaks;
 	bool seen_direct_write;
 	struct bpf_insn_aux_data *insn_aux_data; /* array of per-insn state */
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 1ec44872c8e4..66b27d9f2569 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4449,6 +4449,12 @@ static int sanitize_ptr_alu(struct bpf_verifier_env *env,
 		alu_state |= off_is_imm ? BPF_ALU_IMMEDIATE : 0;
 		alu_state |= ptr_is_dst_reg ?
 			     BPF_ALU_SANITIZE_SRC : BPF_ALU_SANITIZE_DST;
+
+		/* Limit pruning on unknown scalars to enable deep search for
+		 * potential masking differences from other program paths.
+		 */
+		if (!off_is_imm)
+			env->explore_alu_limits = true;
 	}
 
 	err = update_alu_sanitation_state(aux, alu_state, alu_limit);
@@ -7102,8 +7108,8 @@ static void clean_live_states(struct bpf_verifier_env *env, int insn,
 }
 
 /* Returns true if (rold safe implies rcur safe) */
-static bool regsafe(struct bpf_reg_state *rold, struct bpf_reg_state *rcur,
-		    struct bpf_id_pair *idmap)
+static bool regsafe(struct bpf_verifier_env *env, struct bpf_reg_state *rold,
+		    struct bpf_reg_state *rcur, struct bpf_id_pair *idmap)
 {
 	bool equal;
 
@@ -7129,6 +7135,8 @@ static bool regsafe(struct bpf_reg_state *rold, struct bpf_reg_state *rcur,
 		return false;
 	switch (rold->type) {
 	case SCALAR_VALUE:
+		if (env->explore_alu_limits)
+			return false;
 		if (rcur->type == SCALAR_VALUE) {
 			if (!rold->precise && !rcur->precise)
 				return true;
@@ -7218,9 +7226,8 @@ static bool regsafe(struct bpf_reg_state *rold, struct bpf_reg_state *rcur,
 	return false;
 }
 
-static bool stacksafe(struct bpf_func_state *old,
-		      struct bpf_func_state *cur,
-		      struct bpf_id_pair *idmap)
+static bool stacksafe(struct bpf_verifier_env *env, struct bpf_func_state *old,
+		      struct bpf_func_state *cur, struct bpf_id_pair *idmap)
 {
 	int i, spi;
 
@@ -7265,9 +7272,8 @@ static bool stacksafe(struct bpf_func_state *old,
 			continue;
 		if (old->stack[spi].slot_type[0] != STACK_SPILL)
 			continue;
-		if (!regsafe(&old->stack[spi].spilled_ptr,
-			     &cur->stack[spi].spilled_ptr,
-			     idmap))
+		if (!regsafe(env, &old->stack[spi].spilled_ptr,
+			     &cur->stack[spi].spilled_ptr, idmap))
 			/* when explored and current stack slot are both storing
 			 * spilled registers, check that stored pointers types
 			 * are the same as well.
@@ -7324,10 +7330,11 @@ static bool func_states_equal(struct bpf_verifier_env *env, struct bpf_func_stat
 
 	memset(env->idmap_scratch, 0, sizeof(env->idmap_scratch));
 	for (i = 0; i < MAX_BPF_REG; i++)
-		if (!regsafe(&old->regs[i], &cur->regs[i], env->idmap_scratch))
+		if (!regsafe(env, &old->regs[i], &cur->regs[i],
+			     env->idmap_scratch))
 			return false;
 
-	if (!stacksafe(old, cur, env->idmap_scratch))
+	if (!stacksafe(env, old, cur, env->idmap_scratch))
 		return false;
 
 	if (!refsafe(old, cur))
-- 
2.25.1

