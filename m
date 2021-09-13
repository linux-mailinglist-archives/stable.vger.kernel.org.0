Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56EEC40978D
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 17:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245097AbhIMPht (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 11:37:49 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:47132 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243429AbhIMPhn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 11:37:43 -0400
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18DFXNT4020098;
        Mon, 13 Sep 2021 15:36:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=xcHYzsc9Nn8OrRnv+7C53Turqnm6DqOG8nJIQTKrxus=;
 b=W9oEz85Xq52CL88LmcTzyzKUdpfKive69mRhigi6gw/FgS5iQ3dHpqtaI/IUx9H1vZc1
 b0FQNkZdykhB58oQ7d60b3KHTqlMdSi2JXdif0hPBBk9wWLBhEmop6Tx3himWBe4ZYd/
 yxyO9WeIZW3M9rALCeLRl1s7XN+HzZnxHKE2xmDLhPVRtn83aGwOEfcVBPbfs77IvERy
 a/Hg215b4gbdA0+xlbjYh57BWr+BaqgZwoncSU1VicBcXun9REto14PmCtwjA+qJ7ezh
 34TPebS4zljI/UdEvkoStULq5KxLudWMToSjdvi5ZNk5q2iCOkfNstvJKb2NSKyltRtT eg== 
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2048.outbound.protection.outlook.com [104.47.56.48])
        by mx0a-0064b401.pphosted.com with ESMTP id 3b28v1g11n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Sep 2021 15:36:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SJnJYba3GHX0imvb0wpmaaUuYBQkjziwiraWiNYt+NwD1FmCjJJZehiMSU5SR7NmpRRPTdOkdr8sYCi7ZW4aQ3zlTF2iteGnVee5x6BIw7nYHBQqmurXrv+hKYdwk6wEh98LsqKi2aEo380k6U9F0IOvYrEqsZaFR41GdWtXHlP/LLhvyOq3A5RfammUsreQRwkrv6L5RydDmSp0RRbRWv1uiRKhRn9npjgH6hEpYwF4L6hDpem4vOEc43l5qYE+MGZJjSyjrpO+IDHEWmANOXmgkQ2ditshwh/3mbnqphWgAsHeqKiYEJy1Z6jkisCjg3E+LU17+3UEG8F57DWMQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=xcHYzsc9Nn8OrRnv+7C53Turqnm6DqOG8nJIQTKrxus=;
 b=fvPlPTrkIKGG6WoZBVYmD3Ryzns4q5EGWbIVXwgCsEI5O8PJaI+eNVcojNMLj8d270N+VvmtkKucFP4dbVCk5Mu4O7F8D4k1qlc6li6F4JvZNUh9n1WRnFoQ4twwsWQPMciI/lL5LvLO5F2JBXY4C48MJvZHho8xEhjqRYsh5BVRqFQVD/tMm3fSww4CIhtH4dtFgBnsXAD4BKcV5MArpuL2fnXpT3jnAb7JgnYQ6tbvWaeafnnCnZoo2Q+FBfaFaLNiiAUZvmrwi3HKabRRvfmIzsHtaLtqvA7a/8IrNUbftz4pkdIcClAl0hESY96QcD3gONjA6kUwI2x65aD4SQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM5PR1101MB2201.namprd11.prod.outlook.com (2603:10b6:4:51::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.15; Mon, 13 Sep
 2021 15:36:11 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::952a:bdc6:20c3:94cb]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::952a:bdc6:20c3:94cb%7]) with mapi id 15.20.4500.019; Mon, 13 Sep 2021
 15:36:11 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     bpf@vger.kernel.org, daniel@iogearbox.net
Subject: [PATCH 4.19 12/13] bpf: verifier: Allocate idmap scratch in verifier env
Date:   Mon, 13 Sep 2021 18:35:36 +0300
Message-Id: <20210913153537.2162465-13-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210913153537.2162465-1-ovidiu.panait@windriver.com>
References: <20210913153537.2162465-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR10CA0095.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:28::24) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR10CA0095.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:803:28::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 15:36:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 243d65a0-20a4-4de0-e138-08d976cc3663
X-MS-TrafficTypeDiagnostic: DM5PR1101MB2201:
X-Microsoft-Antispam-PRVS: <DM5PR1101MB2201A678035F145D8DEFB1F4FED99@DM5PR1101MB2201.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D36vtYvrgkbQ0A1oUrpYXoh0A3pEjIJGdQ1DhxFqJsTNwrlsZsHPT4RgZ9KDvHTwwHHnSiQEKXcVn4h3y6KeEWI11vA1UvzhGIDHqeBzIl/JSKu5Oxq3ZjM34IjbqM5lTjetkmRiUWJOPcZg89HCl7MN1ya7aWGYT7n2DMXwfwyEudQ+VSi/1f+SbyFonWqEuEdWYsYNF7++7lisaxpAL79wnVbmnAv/U8GgzXF27NEciJ5h5kJccDYRqKGKCBY0wLtoOpN2JIYCvUur3HU9gDyn3/9+vsShlkXDAgvwmhROvDD2gNsrBZ2IvpOoY9LwYvpnFX4Xk5+65sSpteHSC2HHiC5o+bU4rFIbR5szQ9ipbd+dHUJrnHdr99lCuRK7qByfZE7hF3QV53AtQfY/JkFfpMkc1wb6oQnE4I7rBoIQTfYX5CjM+CY9vCRo5UgxZjs2walieePE08TpOZeg2tihuwLXnQaep/FJb3th6HGLhFh7VIcd6bDVMrxQPegVsAMsMx8sVMMMadtcjRELDUpJfQr78z7Vf403Q4IKtm+lHSbxA7T5PA/3B3MeOCo6nEiKfMFfj+IGs8v8y8Ks6poiurSUai4ucn+aX6XZTnobfguXrEwBy6vXF+evUwmyrv7toZ+Dn1fODxc87eakBZm/lrwcG+SsBa9clauyQ82zrr3ab2uFh+85wUDxveeSiVo/52XOLLHEf5OIEVi19suvMj8sbLxPO+HKpxwB/LEVeKIlWNHB/H/XptRd9cXUQC8Y0uMlZAN9xo9x3PG/e4uLuXEurCNVEE4LE8n40Lw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(366004)(39850400004)(376002)(346002)(52116002)(6916009)(316002)(6486002)(38350700002)(6666004)(86362001)(5660300002)(2616005)(4326008)(8936002)(26005)(38100700002)(6512007)(6506007)(956004)(83380400001)(478600001)(1076003)(36756003)(186003)(44832011)(966005)(66476007)(2906002)(8676002)(66946007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oBZLfTyz66wkn31RJPtQXA/sCM7kWLtSmdBnriHVfzi9f1vPr5cYNeR+8KNv?=
 =?us-ascii?Q?3UTBwUwrl1PsY4kp9Q7gt4aIhKSaguBItM0MudDiPscTa7MmpDmbP1JO2Msp?=
 =?us-ascii?Q?4sZWqzC89V212J9BRnAjmLCgXidUvZSjuf+Ks2zEhBuhb248fvJOYEDZ6oNM?=
 =?us-ascii?Q?AzGIPoYlFrseLyedU1+sUmypowGi9LpZ6pPeuAkr4Trll328Pv02BfS9ta2h?=
 =?us-ascii?Q?ctaGk8pSX0BdjRHb9EivJ/RkIblG0gKNetInQAb9FRWQ5w3i2tK3R9mc3y7t?=
 =?us-ascii?Q?5nj/9QVGmX+VXFNJyzt5sU0GaxI4Zsne59rH5zh0vI8u5gCYcYjhrG+Kq2yZ?=
 =?us-ascii?Q?fXKbTwkdjomhGpzCwvqKSejW5efkfW2RznJB0RzvP0bd3YBdq0MZUFim9FoM?=
 =?us-ascii?Q?BqF98tU2yB9P9uYOBr+n+a2bbMVuhwHEJ7HlrMTlF4quKaJI1harlvEIDqkM?=
 =?us-ascii?Q?AMrj/EVrKRhv4b3t1JYuyQpaCpjKoQnm+QvcnU6irWAdVV75am4/qzpWBUZq?=
 =?us-ascii?Q?vSz+j+67J4w8N4hAsxDFzS2x2s2qV6TLRBe/FWpDhqUA5M25zan3e/yvnDWL?=
 =?us-ascii?Q?3aHBGbJc4gkXgqZYqut+GuXiZD5Fe1ok+lq8muUl1wofbUwcNLiZUwN5wboa?=
 =?us-ascii?Q?WG1k6+dLhQGbu2MO8n6tbyM3kKTm7TdPgiOh/Z9nM5YQAb20MMzPB7bVw0K1?=
 =?us-ascii?Q?fpMEvqmLfdiwkjBxURIMWPnOX0oeg3mcrUL+QIMLXBwd2ar7YqlUw93rf65b?=
 =?us-ascii?Q?GuBLpuj4k5LZQQFBsNifG21kSVoHcHa38cj9jCc3BB4+picQ5Lre4ZAaE/Vr?=
 =?us-ascii?Q?/yI9hyvTFCrtrapuqAYjpS89q4G2Lgog9xMW/2I0dLfO0tGeJ3HJrJR67sNF?=
 =?us-ascii?Q?nhCdENMOlU8R5ScJbFw6uaMkdo6SaO22VUKzx25hfY32nZMiIGLpSWfdj70P?=
 =?us-ascii?Q?CW9Xt/PkVeF4FI9aFgjlfUZJRTXVLxG+Upimnfi+b1xb/cChBEv7JYVd+Cz2?=
 =?us-ascii?Q?u4lRIbhRtno+T0kiDBoHu4Nfb5hpgPODKrFgUFrPdsso/9eYenVtFhiaOqVr?=
 =?us-ascii?Q?SzfBrxi3gfAFkhHspCS5J8tIGcGWut8d3wvIogS+uAhJPqBNKDNV5smQxUMy?=
 =?us-ascii?Q?Q+b9mukBAQ7Cs23lOWEYB4ugQKqPjxYRhbcJYIM7cBP5OXPvIUzu9b5HMoIn?=
 =?us-ascii?Q?5UAZJN3pnIqJpLRd4ZueobS/6+zAtPM2djTfKrqrdzAgWPZBT1yFrySvJtJo?=
 =?us-ascii?Q?5zWSU7VO7YIlohyHBBftckD+Cm+8SDzI9m7nZHLNwETKhnDLb0Qh4AwI238G?=
 =?us-ascii?Q?IkiFBFu471o01B+vdXNK9NPu?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 243d65a0-20a4-4de0-e138-08d976cc3663
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 15:36:11.3062
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cM1yMNBUpgygKwbBDBLartG3Wh0sytXZrrgfSj1Oaww49sklkeh9qoLr94cvnXwSp4lk/AMq+hz2Te8HvyGGg3B1Uoe0bCWtaki7afUZNQo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1101MB2201
X-Proofpoint-ORIG-GUID: 7Q7OH4iqfggoNFBo2neDieSKyD23VV2M
X-Proofpoint-GUID: 7Q7OH4iqfggoNFBo2neDieSKyD23VV2M
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-13_07,2021-09-09_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 spamscore=0
 priorityscore=1501 malwarescore=0 adultscore=0 mlxlogscore=819
 impostorscore=0 lowpriorityscore=0 bulkscore=0 phishscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109130103
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenz Bauer <lmb@cloudflare.com>

commit c9e73e3d2b1eb1ea7ff068e05007eec3bd8ef1c9 upstream.

func_states_equal makes a very short lived allocation for idmap,
probably because it's too large to fit on the stack. However the
function is called quite often, leading to a lot of alloc / free
churn. Replace the temporary allocation with dedicated scratch
space in struct bpf_verifier_env.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Edward Cree <ecree.xilinx@gmail.com>
Link: https://lore.kernel.org/bpf/20210429134656.122225-4-lmb@cloudflare.com
[OP: adjusted context for 4.19]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 include/linux/bpf_verifier.h |  8 +++++++
 kernel/bpf/verifier.c        | 42 +++++++++++-------------------------
 2 files changed, 21 insertions(+), 29 deletions(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index e64ac93f7f4c..729c65b320d4 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -127,6 +127,13 @@ struct bpf_func_state {
 	struct bpf_stack_state *stack;
 };
 
+struct bpf_id_pair {
+	u32 old;
+	u32 cur;
+};
+
+/* Maximum number of register states that can exist at once */
+#define BPF_ID_MAP_SIZE (MAX_BPF_REG + MAX_BPF_STACK / BPF_REG_SIZE)
 #define MAX_CALL_FRAMES 8
 struct bpf_verifier_state {
 	/* call stack tracking */
@@ -213,6 +220,7 @@ struct bpf_verifier_env {
 	struct bpf_insn_aux_data *insn_aux_data; /* array of per-insn state */
 	struct bpf_verifier_log log;
 	struct bpf_subprog_info subprog_info[BPF_MAX_SUBPROGS + 1];
+	struct bpf_id_pair idmap_scratch[BPF_ID_MAP_SIZE];
 	u32 subprog_cnt;
 };
 
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index d38ec3266a84..883fb762d93c 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4783,13 +4783,6 @@ static bool range_within(struct bpf_reg_state *old,
 	       old->smax_value >= cur->smax_value;
 }
 
-/* Maximum number of register states that can exist at once */
-#define ID_MAP_SIZE	(MAX_BPF_REG + MAX_BPF_STACK / BPF_REG_SIZE)
-struct idpair {
-	u32 old;
-	u32 cur;
-};
-
 /* If in the old state two registers had the same id, then they need to have
  * the same id in the new state as well.  But that id could be different from
  * the old state, so we need to track the mapping from old to new ids.
@@ -4800,11 +4793,11 @@ struct idpair {
  * So we look through our idmap to see if this old id has been seen before.  If
  * so, we require the new id to match; otherwise, we add the id pair to the map.
  */
-static bool check_ids(u32 old_id, u32 cur_id, struct idpair *idmap)
+static bool check_ids(u32 old_id, u32 cur_id, struct bpf_id_pair *idmap)
 {
 	unsigned int i;
 
-	for (i = 0; i < ID_MAP_SIZE; i++) {
+	for (i = 0; i < BPF_ID_MAP_SIZE; i++) {
 		if (!idmap[i].old) {
 			/* Reached an empty slot; haven't seen this id before */
 			idmap[i].old = old_id;
@@ -4821,7 +4814,7 @@ static bool check_ids(u32 old_id, u32 cur_id, struct idpair *idmap)
 
 /* Returns true if (rold safe implies rcur safe) */
 static bool regsafe(struct bpf_reg_state *rold, struct bpf_reg_state *rcur,
-		    struct idpair *idmap)
+		    struct bpf_id_pair *idmap)
 {
 	bool equal;
 
@@ -4925,7 +4918,7 @@ static bool regsafe(struct bpf_reg_state *rold, struct bpf_reg_state *rcur,
 
 static bool stacksafe(struct bpf_func_state *old,
 		      struct bpf_func_state *cur,
-		      struct idpair *idmap)
+		      struct bpf_id_pair *idmap)
 {
 	int i, spi;
 
@@ -5011,29 +5004,20 @@ static bool stacksafe(struct bpf_func_state *old,
  * whereas register type in current state is meaningful, it means that
  * the current state will reach 'bpf_exit' instruction safely
  */
-static bool func_states_equal(struct bpf_func_state *old,
+static bool func_states_equal(struct bpf_verifier_env *env, struct bpf_func_state *old,
 			      struct bpf_func_state *cur)
 {
-	struct idpair *idmap;
-	bool ret = false;
 	int i;
 
-	idmap = kcalloc(ID_MAP_SIZE, sizeof(struct idpair), GFP_KERNEL);
-	/* If we failed to allocate the idmap, just say it's not safe */
-	if (!idmap)
-		return false;
+	memset(env->idmap_scratch, 0, sizeof(env->idmap_scratch));
+	for (i = 0; i < MAX_BPF_REG; i++)
+		if (!regsafe(&old->regs[i], &cur->regs[i], env->idmap_scratch))
+			return false;
 
-	for (i = 0; i < MAX_BPF_REG; i++) {
-		if (!regsafe(&old->regs[i], &cur->regs[i], idmap))
-			goto out_free;
-	}
+	if (!stacksafe(old, cur, env->idmap_scratch))
+		return false;
 
-	if (!stacksafe(old, cur, idmap))
-		goto out_free;
-	ret = true;
-out_free:
-	kfree(idmap);
-	return ret;
+	return true;
 }
 
 static bool states_equal(struct bpf_verifier_env *env,
@@ -5057,7 +5041,7 @@ static bool states_equal(struct bpf_verifier_env *env,
 	for (i = 0; i <= old->curframe; i++) {
 		if (old->frame[i]->callsite != cur->frame[i]->callsite)
 			return false;
-		if (!func_states_equal(old->frame[i], cur->frame[i]))
+		if (!func_states_equal(env, old->frame[i], cur->frame[i]))
 			return false;
 	}
 	return true;
-- 
2.25.1

