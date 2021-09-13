Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05CD3409777
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 17:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241746AbhIMPhe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 11:37:34 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:63540 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237922AbhIMPh3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 11:37:29 -0400
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18DFWk6t015226;
        Mon, 13 Sep 2021 08:35:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=2oS4sXCnNcE5fScztHpWKr74xhb7xDYhheuArylBdPI=;
 b=UBeXI3KbRRPgCzvpS9nKn9IIP+qQXKbdE7Tk/wfsmZwpf0Cp3wTlOclYxdbhwXQxAwR7
 AeGigcem82xqRDAsheEBmlM2onAHA1ti7afP5NFWggUJ4BV1dAgSsTiElkCvAOTkxTzU
 oP1J09Cqw7uAHLfKUY3me+nPVgmdZQun6oimlviOShPvLMQzEBJLkZjcHPK5n1nQBc64
 ph8taROmB4lwsug93xLzxc+DKh1GQEHrBdXPqGD9MLjZsCDu4UpgjybsU2wrWmtJttql
 gcZNtQuIiWQ/McYca0iKjqbuZ2EzESKx8wxvVhw8CaCVNQTXf49bTazuB20KSlun5M6e cw== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by mx0a-0064b401.pphosted.com with ESMTP id 3b1kfn0pky-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Sep 2021 08:35:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HA5AHzfDQaSAx2MLGhfdClbLywOD/COFYKgaxzobvK0M/BntIULvD8dwbX6qBgVXHCXUCA0fsH6YYPWF4II17agGyXh5s8q1oM2bhpmvLkZ6Gi8zmYgY8v51xxvinM81rYWZAST9S5OB9UciP8ur99prT0FUiAqqjAYo6zBHLKmQ2ULizayg6Zeoy8ZXbQCIxpyN+E8ChmVFyviDiI4LF5jZ+wlJ7eYNHUkrNVmR/rW2ou3Rlrww/48yD9KuoEbUEnZ6Vf68o8L3z681l9VP1e5ffsZxNZFl2YuaPoWTYWOkt3/u7GHLXSdondX8C82Dq8gNmmYpcoJWgY9SZ9jBgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=2oS4sXCnNcE5fScztHpWKr74xhb7xDYhheuArylBdPI=;
 b=B+GkJbSg2G3IqFnkvV+EypApRN0CNhIzpiabKweTeSZCmHd/y657QAJ0b2Akzz3FmqudJLEmP5lo+uhiwRHs40y0NOPUtEA9TOI2Q62IbWUeQzwGzJ/ZmqI9E0DooEiDFdxvDhhy1IOBrGFDkZJQl94F1G+huZZtz5zUY2eg3dnrVLo3CD5qotAjISJQN4Lj33CPh4maCuiawMbsMZXC5u38AIHgqyRQhOqPA8f70T7iekkVxUGru373Gj16wmKhVY+aiBu5VHsAiMITpQgvrnsAsF3f8Q7BrxAb5H9Pqp9cZM39k8szHkD/hTfiGsRQ02vH/r/VRnxP5TPr43yUIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM4PR11MB5549.namprd11.prod.outlook.com (2603:10b6:5:388::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.17; Mon, 13 Sep
 2021 15:35:57 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::952a:bdc6:20c3:94cb]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::952a:bdc6:20c3:94cb%7]) with mapi id 15.20.4500.019; Mon, 13 Sep 2021
 15:35:57 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     bpf@vger.kernel.org, daniel@iogearbox.net
Subject: [PATCH 4.19 01/13] bpf/verifier: per-register parent pointers
Date:   Mon, 13 Sep 2021 18:35:25 +0300
Message-Id: <20210913153537.2162465-2-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210913153537.2162465-1-ovidiu.panait@windriver.com>
References: <20210913153537.2162465-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR10CA0095.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:28::24) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR10CA0095.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:803:28::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 15:35:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fe20d772-8114-40fd-2a8e-08d976cc2e3e
X-MS-TrafficTypeDiagnostic: DM4PR11MB5549:
X-Microsoft-Antispam-PRVS: <DM4PR11MB554903577396322C62ED18E9FED99@DM4PR11MB5549.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: In4HZtiXmZ9ihPedsrxzKEE76fQh8RSyQpdEx2dQhBW8/Gj3LK/Gy9S1mCw5al5jf4EdwHL9gWFxMgt6HCE/Q/tNA5cHQfx5OyOn9D6HbIe4kc2hNkwoum4TsFrHxYSWNfV/WqNXKpvm1boNO78AeVFvOepJ4GtnNRdkAhdbBSJwELLo+sr/ow05lPMiqYsF8uayJCKbyJdiy2Jk99dBPAKhOA0X3Nu1gYyqGD5PZkvwfcY9NgqTOydNpBlAAEwGzDCjE2hVkEXfj2sv69MEj/lhpFz7UZTnbbukYPhJI0z4NliygbVj8SJlepBG/I5jkJ2sxGrEr5wQ+op0KJjFJQP8hOcMGO5e/55hUD2n3j+5dyvyYOxGh/GqFaQHGoyj6NrZn3gEBvaZ852t4X3xcSS3j/WkHdVYkaEpxk+JpqZJh2zRs2EQcodeSwM4qEh1Zajj8dfIrrPeFqpbRUNPMfMymd0sktqnldTCq2LPI2+tDyKaBa0l0vkGOkJbaseVmeb9ZfpcCUOlhyvfsc9CIlPCFbq93Afou0AaxJm3DHKfCTvgI5s80RlFp7XF5MTLzpGxwZ3EsOEe1HV5tFXCDYxYJEyGU8PvDdlbxaRY2sPXqwSlZtITKQfvretxyXKA54QH/ODUUbqYTsM04IcMX+M9MlTKI62wlxQWqwroASzOCIzCoCZ05agZxaAwxiPXfUI4a46tvASLhY9OspOgRg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(366004)(39850400004)(136003)(376002)(478600001)(26005)(83380400001)(186003)(38350700002)(2616005)(8936002)(30864003)(38100700002)(44832011)(52116002)(8676002)(6916009)(5660300002)(6506007)(956004)(86362001)(316002)(36756003)(2906002)(4326008)(1076003)(66946007)(6666004)(66476007)(66556008)(6512007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?h67sswmJetOp/mZatXJIoW30XDncvJaJm19XxlIOS/Q7xLHe9lyr5vu/7NO0?=
 =?us-ascii?Q?yW4/3nZOVzxwjOf5pGb/AhJfYOdPui0hyGxW1VK4JIDGuVWdT9dTHtzSfBVI?=
 =?us-ascii?Q?atxYKMBoH8N9sxkSvahK9K+PVWHZizIk5qqCLKxgA1h4Yzxpf8BkOaXr7ZYx?=
 =?us-ascii?Q?wjZi+KB97mX7rWF5wlSpjnXpoLOnj9uItJFWDUvJUeZpmAKGDwwz3pU4U+l2?=
 =?us-ascii?Q?/snalJ08IE9M6Liud8cZCarnpqiFfEThGag7SqUMX67f81ywLsLt5SWlMI71?=
 =?us-ascii?Q?7Q5rXXDdtR4PhznLrFdRUBkn2jvKoR6MnOp0nkDyhJTGOaelV0eBlwL5QewV?=
 =?us-ascii?Q?2ICfWURXKRAhpDAwtInxNm/6fXP3ur7C+LFZWMClw/GKQ5e0JXlGu2F/Y+5R?=
 =?us-ascii?Q?rNBNZlEP7ySJ/xJ3scpkmtLYTqMojCYD482kvM7j5NNv9rKYpNwqWJwrXR2v?=
 =?us-ascii?Q?SBDc1eBxPUxTm8ncObELi10XxtGD09bVW89jMJ3cgjlkLvz4U/E2Ol0lsRfF?=
 =?us-ascii?Q?hJBu8FWa9y268gflZhxiLLprGPCQhtMrycvo5c50ZZ1OX8w/fBKgeT1otJwW?=
 =?us-ascii?Q?EcuZj+fuVnO8HlpFqu4Pu4Tv0K/ZZFTBXg98xqfwHV4Vs3iAj0uf20610qRL?=
 =?us-ascii?Q?fVEoBfyX1hvQmTrlTqHVK0KXw/DiC+cbkadEx1tfufA7KVJ1/ij7YG574FfO?=
 =?us-ascii?Q?//Ly+VaHTnsqqrb66rl7zgKs1mKzfCSVyDxMzeZKkNkTy9xURjTSzHtjms1v?=
 =?us-ascii?Q?WzF8+L9QjBdBxAIe3GmZBC0o3w8riweElxVfiMbKJ/T5nLFffMkXTnzvp2vw?=
 =?us-ascii?Q?S5/9eLZi9KAt1KJwqFxdzTQQtFnR5fs2dh+vc0T7tvp7rasStJ/feh0QVpF/?=
 =?us-ascii?Q?aFZLxjgFVDVOE4lUuC9E0WtA7+CE4CXR07MP5HuhSbbSHVTckA0GIEn3YVx7?=
 =?us-ascii?Q?ZVkAcNh+mkK061cLf7All66QjBxBW7WJpG9u1wvfxzCopqRIXqJ9/72V0ZTF?=
 =?us-ascii?Q?1tLtHDmp1PgLVPyye7rJDtPA+YF8LSOrKpSpKmAnOwozYb6aFTPwsgzQg/3p?=
 =?us-ascii?Q?yRbS8C0fJwAVImIqsfkrJWLS9WOr68tjmsPiKiJESzv+GMKBTjF1L0FGGUPl?=
 =?us-ascii?Q?1W0Vc0EJIpw40Z9dDO19V2dQVbnAGsZHFq+03CH47KDgU/xWbB+fS52TC1vh?=
 =?us-ascii?Q?K6xDeaHAqrQurajSeO99fM0EHzldJKEibGKznBVzGGt67EUis4+Fh9Fw/n+e?=
 =?us-ascii?Q?Pn4Dnc1rPGAGJSulMsnzdybiIhXy58i3u7rYkc7aVVm+Q1iMf62BYDBMJq16?=
 =?us-ascii?Q?WGgZ/7FJ4IUQKNXI2FhNtFY+?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe20d772-8114-40fd-2a8e-08d976cc2e3e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 15:35:57.3496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kPR2h/HRC4w3RVn0SLDLMmTczRlzdKPcQ66MiBS8uoC4GIlSQyS3K8Tq+lnm4jrT8JdGmVlOfNSbTEIwmPZtB9tifr73DJWyD0j92X+6Ri0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5549
X-Proofpoint-ORIG-GUID: XQZVm5yc8540GhlDSfzD43hSL9YWgUuj
X-Proofpoint-GUID: XQZVm5yc8540GhlDSfzD43hSL9YWgUuj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-13_07,2021-09-09_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 impostorscore=0 clxscore=1015 phishscore=0 suspectscore=0
 adultscore=0 bulkscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109130103
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Edward Cree <ecree@solarflare.com>

commit 679c782de14bd48c19dd74cd1af20a2bc05dd936 upstream.

By giving each register its own liveness chain, we elide the skip_callee()
 logic.  Instead, each register's parent is the state it inherits from;
 both check_func_call() and prepare_func_exit() automatically connect
 reg states to the correct chain since when they copy the reg state across
 (r1-r5 into the callee as args, and r0 out as the return value) they also
 copy the parent pointer.

Signed-off-by: Edward Cree <ecree@solarflare.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
[OP: adjusted context for 4.19]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 include/linux/bpf_verifier.h |   8 +-
 kernel/bpf/verifier.c        | 183 +++++++++--------------------------
 2 files changed, 47 insertions(+), 144 deletions(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 1c8517320ea6..daab0960c054 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -41,6 +41,7 @@ enum bpf_reg_liveness {
 };
 
 struct bpf_reg_state {
+	/* Ordering of fields matters.  See states_equal() */
 	enum bpf_reg_type type;
 	union {
 		/* valid when type == PTR_TO_PACKET */
@@ -62,7 +63,6 @@ struct bpf_reg_state {
 	 * came from, when one is tested for != NULL.
 	 */
 	u32 id;
-	/* Ordering of fields matters.  See states_equal() */
 	/* For scalar types (SCALAR_VALUE), this represents our knowledge of
 	 * the actual value.
 	 * For pointer types, this represents the variable part of the offset
@@ -79,15 +79,15 @@ struct bpf_reg_state {
 	s64 smax_value; /* maximum possible (s64)value */
 	u64 umin_value; /* minimum possible (u64)value */
 	u64 umax_value; /* maximum possible (u64)value */
+	/* parentage chain for liveness checking */
+	struct bpf_reg_state *parent;
 	/* Inside the callee two registers can be both PTR_TO_STACK like
 	 * R1=fp-8 and R2=fp-8, but one of them points to this function stack
 	 * while another to the caller's stack. To differentiate them 'frameno'
 	 * is used which is an index in bpf_verifier_state->frame[] array
 	 * pointing to bpf_func_state.
-	 * This field must be second to last, for states_equal() reasons.
 	 */
 	u32 frameno;
-	/* This field must be last, for states_equal() reasons. */
 	enum bpf_reg_liveness live;
 };
 
@@ -110,7 +110,6 @@ struct bpf_stack_state {
  */
 struct bpf_func_state {
 	struct bpf_reg_state regs[MAX_BPF_REG];
-	struct bpf_verifier_state *parent;
 	/* index of call instruction that called into this func */
 	int callsite;
 	/* stack frame number of this function state from pov of
@@ -132,7 +131,6 @@ struct bpf_func_state {
 struct bpf_verifier_state {
 	/* call stack tracking */
 	struct bpf_func_state *frame[MAX_CALL_FRAMES];
-	struct bpf_verifier_state *parent;
 	u32 curframe;
 	bool speculative;
 };
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index abdc9eca463c..a5259ff30073 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -380,9 +380,9 @@ static int copy_stack_state(struct bpf_func_state *dst,
 /* do_check() starts with zero-sized stack in struct bpf_verifier_state to
  * make it consume minimal amount of memory. check_stack_write() access from
  * the program calls into realloc_func_state() to grow the stack size.
- * Note there is a non-zero 'parent' pointer inside bpf_verifier_state
- * which this function copies over. It points to previous bpf_verifier_state
- * which is never reallocated
+ * Note there is a non-zero parent pointer inside each reg of bpf_verifier_state
+ * which this function copies over. It points to corresponding reg in previous
+ * bpf_verifier_state which is never reallocated
  */
 static int realloc_func_state(struct bpf_func_state *state, int size,
 			      bool copy_old)
@@ -467,7 +467,6 @@ static int copy_verifier_state(struct bpf_verifier_state *dst_state,
 	}
 	dst_state->speculative = src->speculative;
 	dst_state->curframe = src->curframe;
-	dst_state->parent = src->parent;
 	for (i = 0; i <= src->curframe; i++) {
 		dst = dst_state->frame[i];
 		if (!dst) {
@@ -739,6 +738,7 @@ static void init_reg_state(struct bpf_verifier_env *env,
 	for (i = 0; i < MAX_BPF_REG; i++) {
 		mark_reg_not_init(env, regs, i);
 		regs[i].live = REG_LIVE_NONE;
+		regs[i].parent = NULL;
 	}
 
 	/* frame pointer */
@@ -883,74 +883,21 @@ static int check_subprogs(struct bpf_verifier_env *env)
 	return 0;
 }
 
-static
-struct bpf_verifier_state *skip_callee(struct bpf_verifier_env *env,
-				       const struct bpf_verifier_state *state,
-				       struct bpf_verifier_state *parent,
-				       u32 regno)
-{
-	struct bpf_verifier_state *tmp = NULL;
-
-	/* 'parent' could be a state of caller and
-	 * 'state' could be a state of callee. In such case
-	 * parent->curframe < state->curframe
-	 * and it's ok for r1 - r5 registers
-	 *
-	 * 'parent' could be a callee's state after it bpf_exit-ed.
-	 * In such case parent->curframe > state->curframe
-	 * and it's ok for r0 only
-	 */
-	if (parent->curframe == state->curframe ||
-	    (parent->curframe < state->curframe &&
-	     regno >= BPF_REG_1 && regno <= BPF_REG_5) ||
-	    (parent->curframe > state->curframe &&
-	       regno == BPF_REG_0))
-		return parent;
-
-	if (parent->curframe > state->curframe &&
-	    regno >= BPF_REG_6) {
-		/* for callee saved regs we have to skip the whole chain
-		 * of states that belong to callee and mark as LIVE_READ
-		 * the registers before the call
-		 */
-		tmp = parent;
-		while (tmp && tmp->curframe != state->curframe) {
-			tmp = tmp->parent;
-		}
-		if (!tmp)
-			goto bug;
-		parent = tmp;
-	} else {
-		goto bug;
-	}
-	return parent;
-bug:
-	verbose(env, "verifier bug regno %d tmp %p\n", regno, tmp);
-	verbose(env, "regno %d parent frame %d current frame %d\n",
-		regno, parent->curframe, state->curframe);
-	return NULL;
-}
-
+/* Parentage chain of this register (or stack slot) should take care of all
+ * issues like callee-saved registers, stack slot allocation time, etc.
+ */
 static int mark_reg_read(struct bpf_verifier_env *env,
-			 const struct bpf_verifier_state *state,
-			 struct bpf_verifier_state *parent,
-			 u32 regno)
+			 const struct bpf_reg_state *state,
+			 struct bpf_reg_state *parent)
 {
 	bool writes = parent == state->parent; /* Observe write marks */
 
-	if (regno == BPF_REG_FP)
-		/* We don't need to worry about FP liveness because it's read-only */
-		return 0;
-
 	while (parent) {
 		/* if read wasn't screened by an earlier write ... */
-		if (writes && state->frame[state->curframe]->regs[regno].live & REG_LIVE_WRITTEN)
+		if (writes && state->live & REG_LIVE_WRITTEN)
 			break;
-		parent = skip_callee(env, state, parent, regno);
-		if (!parent)
-			return -EFAULT;
 		/* ... then we depend on parent's value */
-		parent->frame[parent->curframe]->regs[regno].live |= REG_LIVE_READ;
+		parent->live |= REG_LIVE_READ;
 		state = parent;
 		parent = state->parent;
 		writes = true;
@@ -976,7 +923,10 @@ static int check_reg_arg(struct bpf_verifier_env *env, u32 regno,
 			verbose(env, "R%d !read_ok\n", regno);
 			return -EACCES;
 		}
-		return mark_reg_read(env, vstate, vstate->parent, regno);
+		/* We don't need to worry about FP liveness because it's read-only */
+		if (regno != BPF_REG_FP)
+			return mark_reg_read(env, &regs[regno],
+					     regs[regno].parent);
 	} else {
 		/* check whether register used as dest operand can be written to */
 		if (regno == BPF_REG_FP) {
@@ -1087,8 +1037,8 @@ static int check_stack_write(struct bpf_verifier_env *env,
 	} else {
 		u8 type = STACK_MISC;
 
-		/* regular write of data into stack */
-		state->stack[spi].spilled_ptr = (struct bpf_reg_state) {};
+		/* regular write of data into stack destroys any spilled ptr */
+		state->stack[spi].spilled_ptr.type = NOT_INIT;
 
 		/* only mark the slot as written if all 8 bytes were written
 		 * otherwise read propagation may incorrectly stop too soon
@@ -1113,61 +1063,6 @@ static int check_stack_write(struct bpf_verifier_env *env,
 	return 0;
 }
 
-/* registers of every function are unique and mark_reg_read() propagates
- * the liveness in the following cases:
- * - from callee into caller for R1 - R5 that were used as arguments
- * - from caller into callee for R0 that used as result of the call
- * - from caller to the same caller skipping states of the callee for R6 - R9,
- *   since R6 - R9 are callee saved by implicit function prologue and
- *   caller's R6 != callee's R6, so when we propagate liveness up to
- *   parent states we need to skip callee states for R6 - R9.
- *
- * stack slot marking is different, since stacks of caller and callee are
- * accessible in both (since caller can pass a pointer to caller's stack to
- * callee which can pass it to another function), hence mark_stack_slot_read()
- * has to propagate the stack liveness to all parent states at given frame number.
- * Consider code:
- * f1() {
- *   ptr = fp - 8;
- *   *ptr = ctx;
- *   call f2 {
- *      .. = *ptr;
- *   }
- *   .. = *ptr;
- * }
- * First *ptr is reading from f1's stack and mark_stack_slot_read() has
- * to mark liveness at the f1's frame and not f2's frame.
- * Second *ptr is also reading from f1's stack and mark_stack_slot_read() has
- * to propagate liveness to f2 states at f1's frame level and further into
- * f1 states at f1's frame level until write into that stack slot
- */
-static void mark_stack_slot_read(struct bpf_verifier_env *env,
-				 const struct bpf_verifier_state *state,
-				 struct bpf_verifier_state *parent,
-				 int slot, int frameno)
-{
-	bool writes = parent == state->parent; /* Observe write marks */
-
-	while (parent) {
-		if (parent->frame[frameno]->allocated_stack <= slot * BPF_REG_SIZE)
-			/* since LIVE_WRITTEN mark is only done for full 8-byte
-			 * write the read marks are conservative and parent
-			 * state may not even have the stack allocated. In such case
-			 * end the propagation, since the loop reached beginning
-			 * of the function
-			 */
-			break;
-		/* if read wasn't screened by an earlier write ... */
-		if (writes && state->frame[frameno]->stack[slot].spilled_ptr.live & REG_LIVE_WRITTEN)
-			break;
-		/* ... then we depend on parent's value */
-		parent->frame[frameno]->stack[slot].spilled_ptr.live |= REG_LIVE_READ;
-		state = parent;
-		parent = state->parent;
-		writes = true;
-	}
-}
-
 static int check_stack_read(struct bpf_verifier_env *env,
 			    struct bpf_func_state *reg_state /* func where register points to */,
 			    int off, int size, int value_regno)
@@ -1205,8 +1100,8 @@ static int check_stack_read(struct bpf_verifier_env *env,
 			 */
 			state->regs[value_regno].live |= REG_LIVE_WRITTEN;
 		}
-		mark_stack_slot_read(env, vstate, vstate->parent, spi,
-				     reg_state->frameno);
+		mark_reg_read(env, &reg_state->stack[spi].spilled_ptr,
+			      reg_state->stack[spi].spilled_ptr.parent);
 		return 0;
 	} else {
 		int zeros = 0;
@@ -1222,8 +1117,8 @@ static int check_stack_read(struct bpf_verifier_env *env,
 				off, i, size);
 			return -EACCES;
 		}
-		mark_stack_slot_read(env, vstate, vstate->parent, spi,
-				     reg_state->frameno);
+		mark_reg_read(env, &reg_state->stack[spi].spilled_ptr,
+			      reg_state->stack[spi].spilled_ptr.parent);
 		if (value_regno >= 0) {
 			if (zeros == size) {
 				/* any size read into register is zero extended,
@@ -1927,8 +1822,8 @@ static int check_stack_boundary(struct bpf_verifier_env *env, int regno,
 		/* reading any byte out of 8-byte 'spill_slot' will cause
 		 * the whole slot to be marked as 'read'
 		 */
-		mark_stack_slot_read(env, env->cur_state, env->cur_state->parent,
-				     spi, state->frameno);
+		mark_reg_read(env, &state->stack[spi].spilled_ptr,
+			      state->stack[spi].spilled_ptr.parent);
 	}
 	return update_stack_depth(env, state, off);
 }
@@ -2384,11 +2279,13 @@ static int check_func_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
 			state->curframe + 1 /* frameno within this callchain */,
 			subprog /* subprog number within this prog */);
 
-	/* copy r1 - r5 args that callee can access */
+	/* copy r1 - r5 args that callee can access.  The copy includes parent
+	 * pointers, which connects us up to the liveness chain
+	 */
 	for (i = BPF_REG_1; i <= BPF_REG_5; i++)
 		callee->regs[i] = caller->regs[i];
 
-	/* after the call regsiters r0 - r5 were scratched */
+	/* after the call registers r0 - r5 were scratched */
 	for (i = 0; i < CALLER_SAVED_REGS; i++) {
 		mark_reg_not_init(env, caller->regs, caller_saved[i]);
 		check_reg_arg(env, caller_saved[i], DST_OP_NO_MARK);
@@ -4844,7 +4741,7 @@ static bool regsafe(struct bpf_reg_state *rold, struct bpf_reg_state *rcur,
 		/* explored state didn't use this */
 		return true;
 
-	equal = memcmp(rold, rcur, offsetof(struct bpf_reg_state, frameno)) == 0;
+	equal = memcmp(rold, rcur, offsetof(struct bpf_reg_state, parent)) == 0;
 
 	if (rold->type == PTR_TO_STACK)
 		/* two stack pointers are equal only if they're pointing to
@@ -5083,7 +4980,7 @@ static bool states_equal(struct bpf_verifier_env *env,
  * equivalent state (jump target or such) we didn't arrive by the straight-line
  * code, so read marks in the state must propagate to the parent regardless
  * of the state's write marks. That's what 'parent == state->parent' comparison
- * in mark_reg_read() and mark_stack_slot_read() is for.
+ * in mark_reg_read() is for.
  */
 static int propagate_liveness(struct bpf_verifier_env *env,
 			      const struct bpf_verifier_state *vstate,
@@ -5104,7 +5001,8 @@ static int propagate_liveness(struct bpf_verifier_env *env,
 		if (vparent->frame[vparent->curframe]->regs[i].live & REG_LIVE_READ)
 			continue;
 		if (vstate->frame[vstate->curframe]->regs[i].live & REG_LIVE_READ) {
-			err = mark_reg_read(env, vstate, vparent, i);
+			err = mark_reg_read(env, &vstate->frame[vstate->curframe]->regs[i],
+					    &vparent->frame[vstate->curframe]->regs[i]);
 			if (err)
 				return err;
 		}
@@ -5119,7 +5017,8 @@ static int propagate_liveness(struct bpf_verifier_env *env,
 			if (parent->stack[i].spilled_ptr.live & REG_LIVE_READ)
 				continue;
 			if (state->stack[i].spilled_ptr.live & REG_LIVE_READ)
-				mark_stack_slot_read(env, vstate, vparent, i, frame);
+				mark_reg_read(env, &state->stack[i].spilled_ptr,
+					      &parent->stack[i].spilled_ptr);
 		}
 	}
 	return err;
@@ -5129,7 +5028,7 @@ static int is_state_visited(struct bpf_verifier_env *env, int insn_idx)
 {
 	struct bpf_verifier_state_list *new_sl;
 	struct bpf_verifier_state_list *sl;
-	struct bpf_verifier_state *cur = env->cur_state;
+	struct bpf_verifier_state *cur = env->cur_state, *new;
 	int i, j, err, states_cnt = 0;
 
 	sl = env->explored_states[insn_idx];
@@ -5175,16 +5074,18 @@ static int is_state_visited(struct bpf_verifier_env *env, int insn_idx)
 		return -ENOMEM;
 
 	/* add new state to the head of linked list */
-	err = copy_verifier_state(&new_sl->state, cur);
+	new = &new_sl->state;
+	err = copy_verifier_state(new, cur);
 	if (err) {
-		free_verifier_state(&new_sl->state, false);
+		free_verifier_state(new, false);
 		kfree(new_sl);
 		return err;
 	}
 	new_sl->next = env->explored_states[insn_idx];
 	env->explored_states[insn_idx] = new_sl;
 	/* connect new state to parentage chain */
-	cur->parent = &new_sl->state;
+	for (i = 0; i < BPF_REG_FP; i++)
+		cur_regs(env)[i].parent = &new->frame[new->curframe]->regs[i];
 	/* clear write marks in current state: the writes we did are not writes
 	 * our child did, so they don't screen off its reads from us.
 	 * (There are no read marks in current state, because reads always mark
@@ -5197,9 +5098,13 @@ static int is_state_visited(struct bpf_verifier_env *env, int insn_idx)
 	/* all stack frames are accessible from callee, clear them all */
 	for (j = 0; j <= cur->curframe; j++) {
 		struct bpf_func_state *frame = cur->frame[j];
+		struct bpf_func_state *newframe = new->frame[j];
 
-		for (i = 0; i < frame->allocated_stack / BPF_REG_SIZE; i++)
+		for (i = 0; i < frame->allocated_stack / BPF_REG_SIZE; i++) {
 			frame->stack[i].spilled_ptr.live = REG_LIVE_NONE;
+			frame->stack[i].spilled_ptr.parent =
+						&newframe->stack[i].spilled_ptr;
+		}
 	}
 	return 0;
 }
-- 
2.25.1

