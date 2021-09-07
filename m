Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE020402988
	for <lists+stable@lfdr.de>; Tue,  7 Sep 2021 15:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344624AbhIGNUD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Sep 2021 09:20:03 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:4562 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344309AbhIGNUA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Sep 2021 09:20:00 -0400
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 187Bn3Fa002074;
        Tue, 7 Sep 2021 13:18:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=jNYWWnJ9wnoALQ8FQb6eFsu85yvUs7HLqs2EKmzgW44=;
 b=WQJ5FfQYIR9/Egd4uubqsrOqXU3XHeVSDWaUKYDopgMJGPPjht4KGDkMIE2wvY/dXH+p
 F6F82UA0jLVClPllsjf6lwyhv4C14G06m4QhWdN4F0BdFvbaNq60L4tjAMNGW9S0mhjj
 xrthgFdzRimqBltGz8J+FfPi81jZRj9vRx+tH2JEloq385DtCpmoXsHfgTune6Dm3qBV
 HJC55lVA4ZLlC6AWJY1NfaY+PhB7DqGyMpRIZCUldYuIS10LZ8MF6usiLiDrgS2kykUs
 RflyENsVr3VuEEzXzwjxfXN1o/LW0SCTKD2jZxU12NKaKRfhvUElHpwv9J0TegzTj60Y xg== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by mx0a-0064b401.pphosted.com with ESMTP id 3awjhygq69-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Sep 2021 13:18:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a/HpKgsMPvnAz/pETMVL85/LnTYh6u2KMeYuq83VCVajRUlUX4pH2gzL0CIiVdqjAj466jlwfl2kXsxxFSvlZTUgyt8AluxrQtxxG7KGvhx9If4XdAZ7WEMCLRaOVm67ZgQMcPH2J2kamX1CYf0TAFrnzp4r2xoKLi/ez3yJDwk4b0lDvZLKfLbs7krRQ6dUYXY2PGfkqA/HcMwVKds8l6whc4k5kS39rArKtE+xi8I9VIjp1ZYlh5zmIQ23vX6bYEmmqD2lf3/jCokYkySrfTgKPkEuaUWnq3fB590FdNSke/nvYDtClHroAt904urIyQvwVN1orUPcy2JofH4rcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=jNYWWnJ9wnoALQ8FQb6eFsu85yvUs7HLqs2EKmzgW44=;
 b=XBf19zyLtFZNuC5ImWU0z7LHIRHA6GfT/qPbsvcKWxgQnxso3swfjN/wRkkglJArvVJZsUQ5vTgBiyOf/g8rMO7eGy8fbBgaGXJzo92tUcuKvSYFFMyEvzCSPCkKgRfpfg6/EkyhjCGCfSPzcfhdKafQbpL4/W8RbZs6Q6+4DpyNC0TdmBvPS0Zsi0GxgT4agltK4lZq0iZnakolHyvQJx/+ES6KAaamTUwLN+FsGLvigHEHMi1GgjNF4sYKryUhr31sCWIKbCnXUTS5UVFqU/dxZrJZ4wNsBb8+nW6YCUf2mkwUf27a5yvsGoDAG1asl/G/Y2TQwl1Lmu7OmJ2O1A==
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
 2021 13:18:40 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::952a:bdc6:20c3:94cb]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::952a:bdc6:20c3:94cb%6]) with mapi id 15.20.4478.025; Tue, 7 Sep 2021
 13:18:40 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     bpf@vger.kernel.org, daniel@iogearbox.net
Subject: [PATCH 5.4 3/4] bpf: verifier: Allocate idmap scratch in verifier env
Date:   Tue,  7 Sep 2021 16:17:00 +0300
Message-Id: <20210907131701.1910024-4-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210907131701.1910024-1-ovidiu.panait@windriver.com>
References: <20210907131701.1910024-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0181.eurprd07.prod.outlook.com
 (2603:10a6:802:3e::29) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR07CA0181.eurprd07.prod.outlook.com (2603:10a6:802:3e::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.6 via Frontend Transport; Tue, 7 Sep 2021 13:18:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 94a45f4c-f1db-498c-1f30-08d9720201f2
X-MS-TrafficTypeDiagnostic: DM6PR11MB3114:
X-Microsoft-Antispam-PRVS: <DM6PR11MB3114048322007CA225CF6234FED39@DM6PR11MB3114.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0DG34BEKHkgUEZGii/9B2dvsYAe/vAFPf5HVOhFxfRVVHizIoeuuTV0B2XuXMt/M3UwMNysgZAqPIkTlj6STlVCxmIYVJY/xsmURSUhaMVIdZlbmyObQJECB9eCIociNDYbFQ5C/+vC6kKRHhFWgtDOdT5nWaxRysO50F1UlFzfELCBHn0Lvb/0oihjnjPUPSLN64gcTjmd6nBCppsYVfh3rtAypCZ59htzDxmaB6nM+xUWIIac7rtD6zxQxqTf/fKR/YjcFNsmcWZJTWLOiytwCOOGk6klITQsT3sw6TTMkJEnGSWXB67LIhe29dJ5jg908db5HJyyS1e+oejp/kJz1OocCU2SAJQ6aNpsMHWZTFW68LfbLsVhk7g0Lhy6j/6mO+tvEu8//N0ESEWho0iVXCGpsw7+tvhg2sz8osXcytYLFRZYIgelBy1OMkAN4E7Vg+XrWRSJe1uwVUoJruAZv3vu0R6Ts0ypaOz+/YvafAgTKN1jyQ5pFrcFvpv8gvupqfFbQNd/fwz9Ex/UVCw1XiHVnjte8VE49lN6pWePq4ikQR8KOWJeGw1vmE12D76TSb4294NO3fzg1jbCtVnJgwOWhUO34KpaaqP85cWCKbRUvhGW6b7QHUilAuBHdHoFqPSn+Klt/noYTkEEx1gF8EkYzOPZ+fps0xSU4CwLlv5KdnrbTRnsRTOduTRodmcYTSHCDdbEuaPKzEArrtJeXZOhUo1BYFrGGuF8yCnFKqGcbeAjmGi9WVFx4GDUj9pfxisTkUbfDxxCtvo8R7lNpstEKtX01rEkuyIriAnA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(366004)(136003)(376002)(39850400004)(8936002)(83380400001)(38100700002)(6916009)(186003)(4326008)(36756003)(38350700002)(86362001)(2906002)(956004)(26005)(6666004)(2616005)(8676002)(66476007)(1076003)(66556008)(44832011)(6506007)(6512007)(52116002)(966005)(6486002)(478600001)(66946007)(316002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ui76tonfjPcbtMTm71YmUn3MKSBEKiekqxQ2tdBFW0QC0r4d4BZH7hDCwm8I?=
 =?us-ascii?Q?vp46yfuhLq4dIxHy79oVQh0SW4ceVqPFw5JvETqO1KEchEHMMQQuMaLBDuPp?=
 =?us-ascii?Q?T2Ni4s6rhHgwjEUxIwNvX0jmvnFqtYN//9rvkWd5pvV/9rvQHO7wpSQF3Wbp?=
 =?us-ascii?Q?LJlHWyssKW1YS6tsoM54+M0aO6DtprbQsxPeDH/ji2lp10gWkIXx89HvD/aE?=
 =?us-ascii?Q?rV0svaDnj3CKVCqGaRV8smb7O0XQ6WsUQWSDN+WViXHgdgevo6ef0HFrxump?=
 =?us-ascii?Q?XBuXqCUI8YZna35n3lpjG4q16hxR2NtIQP7EkxzOglw14y/bDOOVGuCB+sRc?=
 =?us-ascii?Q?G5wVqaEyB6fOy6/p+ZFJPg09cb7JJH8LNa/vsd0xiPqlzqH3sjgzbiDGl+u+?=
 =?us-ascii?Q?m59Dq4D4FCGh+3oph0ouejTxVrBJeMeVkmNrQLx6KWH+aNCiM+b1xWDxbjjd?=
 =?us-ascii?Q?cMkYrKZMexRRPtCrZDyUI4k7ck93zOyZ+SeHGl1whIDi6v1iwkjDQzOm5Y3K?=
 =?us-ascii?Q?fmA+Tx2HQsObV6XDFUuIXXiXgF+PHPyyMBAbGDhYq3Ul7u4KIPAtihlH7ZLF?=
 =?us-ascii?Q?XWz8RQ2ixOuc+OrwDi4N8oVrfQVB/shsQbdcfhARuACmcYilbCdPo1F5D62h?=
 =?us-ascii?Q?lCLALxIVTJOYrNp+n1jnciEhyKzBjz4liNEznWwAKkxVBY9hHQpcnsSS42B3?=
 =?us-ascii?Q?DAv2ccWY8j/4HY/AomdEszGB85/hp7/1RMSiDGHGBIs6s+Etctv9gFn/B7IQ?=
 =?us-ascii?Q?eQZvfyfaH14iSW68Tn1WfSU5UD3bbbdCMKVMie85CWP4oplGwU63YvpDd3uc?=
 =?us-ascii?Q?4/4Oeymsi0mdWRtozgMtenWROUIxaiCSF9cteQ1OxkCiSiueSx0H0H4ZxkGE?=
 =?us-ascii?Q?TlteSXzwFFvVO5bC5Ox45TF/fl21yWWToKltMWzgzSYKsxPJ+ZZaARKKNFxP?=
 =?us-ascii?Q?jMwvtlBfEjjtQCE/50+uqol97EXJvYyhltWg7vuawUd3mSsy3/8MFlEGEX9w?=
 =?us-ascii?Q?7lt2m0TSzCjkw4kn0ILhlu7cXPZMMjGeDXvj+aiWdlGu/21kq9KieTt6Rn2D?=
 =?us-ascii?Q?OSARvb0CeqOBKkJXuNrFS9otsS4aRiIxN/xlxpYgY10tqav6BjRBH+IlRg3O?=
 =?us-ascii?Q?rZMu33k+dlcn/0fK7S5oDlBZEXGU8DswNwjdYC2HQ35PmXv+qovcQxOnmDm2?=
 =?us-ascii?Q?hksJrcMDzcT39EBIDY1iwupzjbidfC32HnCxpOpotNNBopjNKHwuTbIFnabh?=
 =?us-ascii?Q?MIw9XgwdMAjTUbDuGLkJAnY8W20+0iJHlnihBoKu84SI2kEKg00yK3JjcEu3?=
 =?us-ascii?Q?81ANFSjgR1qQxZh2+m6f01Yn?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94a45f4c-f1db-498c-1f30-08d9720201f2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2021 13:18:39.9315
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KB0PbABujV8SX8NJ6ew/YJBEokTqvk5tnfbjF0ZARIeXMqa3f+iEKjDooZrbom+ucHU7VdYKRDtcqBT040rIHs3CVnsYUwaCw+iypi3UtYo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3114
X-Proofpoint-GUID: hOnyf-4YR8z0dR_NoCm9eD4-3SeDVDYM
X-Proofpoint-ORIG-GUID: hOnyf-4YR8z0dR_NoCm9eD4-3SeDVDYM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-07_04,2021-09-07_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 lowpriorityscore=0 bulkscore=0 suspectscore=0 mlxscore=0 adultscore=0
 impostorscore=0 priorityscore=1501 phishscore=0 mlxlogscore=825
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2108310000 definitions=main-2109070088
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[OP: adjusted context for 5.4]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 include/linux/bpf_verifier.h |  8 +++++++
 kernel/bpf/verifier.c        | 46 ++++++++++++------------------------
 2 files changed, 23 insertions(+), 31 deletions(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 4292e8e42c12..d5a7798a4cbf 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -194,6 +194,13 @@ struct bpf_idx_pair {
 	u32 idx;
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
@@ -370,6 +377,7 @@ struct bpf_verifier_env {
 	const struct bpf_line_info *prev_linfo;
 	struct bpf_verifier_log log;
 	struct bpf_subprog_info subprog_info[BPF_MAX_SUBPROGS + 1];
+	struct bpf_id_pair idmap_scratch[BPF_ID_MAP_SIZE];
 	struct {
 		int *insn_state;
 		int *insn_stack;
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index ec06c4f0402e..1ec44872c8e4 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6976,13 +6976,6 @@ static bool range_within(struct bpf_reg_state *old,
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
@@ -6993,11 +6986,11 @@ struct idpair {
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
@@ -7110,7 +7103,7 @@ static void clean_live_states(struct bpf_verifier_env *env, int insn,
 
 /* Returns true if (rold safe implies rcur safe) */
 static bool regsafe(struct bpf_reg_state *rold, struct bpf_reg_state *rcur,
-		    struct idpair *idmap)
+		    struct bpf_id_pair *idmap)
 {
 	bool equal;
 
@@ -7227,7 +7220,7 @@ static bool regsafe(struct bpf_reg_state *rold, struct bpf_reg_state *rcur,
 
 static bool stacksafe(struct bpf_func_state *old,
 		      struct bpf_func_state *cur,
-		      struct idpair *idmap)
+		      struct bpf_id_pair *idmap)
 {
 	int i, spi;
 
@@ -7324,32 +7317,23 @@ static bool refsafe(struct bpf_func_state *old, struct bpf_func_state *cur)
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
-
-	for (i = 0; i < MAX_BPF_REG; i++) {
-		if (!regsafe(&old->regs[i], &cur->regs[i], idmap))
-			goto out_free;
-	}
+	memset(env->idmap_scratch, 0, sizeof(env->idmap_scratch));
+	for (i = 0; i < MAX_BPF_REG; i++)
+		if (!regsafe(&old->regs[i], &cur->regs[i], env->idmap_scratch))
+			return false;
 
-	if (!stacksafe(old, cur, idmap))
-		goto out_free;
+	if (!stacksafe(old, cur, env->idmap_scratch))
+		return false;
 
 	if (!refsafe(old, cur))
-		goto out_free;
-	ret = true;
-out_free:
-	kfree(idmap);
-	return ret;
+		return false;
+
+	return true;
 }
 
 static bool states_equal(struct bpf_verifier_env *env,
@@ -7376,7 +7360,7 @@ static bool states_equal(struct bpf_verifier_env *env,
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

