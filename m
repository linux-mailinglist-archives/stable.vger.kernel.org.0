Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7876A409778
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 17:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240248AbhIMPhf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 11:37:35 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:63558 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241248AbhIMPh3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 11:37:29 -0400
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18DFWNGq029946;
        Mon, 13 Sep 2021 08:36:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=pYq5XJTZ5D1GBlV6IBuU+RsY/RsIx1sNmmNhrNRXN+k=;
 b=bIiJp5CUnXWM1ZDTKdyI10DbKDCY639QKV4KYNmEVpDa9hFHVHJR/Ff787FNUB2xiML4
 +lId8rZyVR6Y0ktJ4S8gT2vm+7BgolIhKS9XcBT0/FTaBhukhAtKGn3g5VJVm+FDPsPY
 0n5r8/k7FMxX5ECyXy0wQQBPSWCAc9PlDaFnN5nFVNdmQxTKAg23zBCOfJvLxEboZv8p
 VRmXC78wLkOBQKaLwQ1hjiNnM2gTfiXcwKlaYke9Tu9POYg3+QfMs/sXkV2urYJjtFzN
 SyTb8MM1dClgFcZ/JoFX1W9M5M8z01js/8yCCDs/kw/nc9MNDAI+5PQqFugbkGjc/QLu nQ== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by mx0a-0064b401.pphosted.com with ESMTP id 3b1qjw8jr9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Sep 2021 08:36:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JXCmRCUfkDHq9TiqXNyxsEA8Cuq8qzMAMF64pI+dMFj8QFeFSUpfBnjbjdoGUcyPtp+6o4wOhZkmJXauDidIvH+2N3urvlhESat5ylVtBpGNBKDY5ODWpBn0EwmG0qtdywR0cPZHG2BKnnMpyw17K0Qjr2RHOjwjZjXAGdn0xACe2BXBblEMANVyHMgKfjCttvRhhTWipwwXNkO63EkKuR+L6sdQY/+Y4ced0aJDEXDpjKaWH0XhClFDNhOP5EmbjRAVdw47ULdsavgmJaMl2mcaukUzvBCWn4RivVOmrAda3nh33lXIpE5e4gVkn9GTJqD1BVHd9NZXRgw6U6P/aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=pYq5XJTZ5D1GBlV6IBuU+RsY/RsIx1sNmmNhrNRXN+k=;
 b=ezB36PuU138d35V8sFtYrvWb0yB+LDxYX4+bW73pFXAMh9NDD1tCDXWeZA9mx72v55pN5YJj19PQo1fJ1/41pxiZlTKHHIPu3iC/0rNZt76sE/pakuXXG2761EMtCttBmlLXGrb7Qg6CJmt0bbCUEt7gcF9ilTw++cYGWKgaPKaXq37GMnN/PopbZxYHk8G0CsMx68NxU7lUwO8XnHZGrgNXbHsgEm5OGbDxue7M8Ayi8XSE7LXMaRQrVfDZNbv3ezS4yz1HC7B1SLfKLtWaoeI9KudJ12zCxx317zjwauwC8PCmBgJ1+sO9sx5l7DkmXk0HBDLV+82ncRiJbNq/kA==
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
 2021 15:35:59 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::952a:bdc6:20c3:94cb]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::952a:bdc6:20c3:94cb%7]) with mapi id 15.20.4500.019; Mon, 13 Sep 2021
 15:35:59 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     bpf@vger.kernel.org, daniel@iogearbox.net
Subject: [PATCH 4.19 03/13] bpf: Support variable offset stack access from helpers
Date:   Mon, 13 Sep 2021 18:35:27 +0300
Message-Id: <20210913153537.2162465-4-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210913153537.2162465-1-ovidiu.panait@windriver.com>
References: <20210913153537.2162465-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR10CA0095.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:28::24) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR10CA0095.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:803:28::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 15:35:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c11f8873-a435-4587-ddee-08d976cc2fc1
X-MS-TrafficTypeDiagnostic: DM4PR11MB5549:
X-Microsoft-Antispam-PRVS: <DM4PR11MB5549097F1FBB9827B1A2C65EFED99@DM4PR11MB5549.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:356;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GGGKpIo4GepxLuanBXo2e1UChn+oCYyopWeg5E8BRAfTsN5A90NooWR/75Llg+wzxRPsQBZaPjwxtWNCN9p6veu8hQNqWu9i71MkuKYtUkXw+zYYqOI4FBYZB7YRlwllb/XBNUpmsSVgVz1jnNlwKQ40NNeRrPMsnsHC4wGCoqeE64Zb5P8PFiIOD3QkLRMRnawWgDOPwjaFMLweJJ+X1I/HTHffxRQmRLuln0CKHa7RKNPixVMVjzIW5PF+cm4RJSBOq5h1nbx09OFjOcqEhTv84ALMkB+R0BrPIX2116W7FfMSfTMfXmtbjCqQZeJbJe1Y7LHHA8UYNy7u8tSCIGFlhaE5vVf+k3oDLF1q0ztY82oBjRpwW64elwjvZHZ5YrpB6c29OqbjYdkIUCu53kW5vkAbAtztZNate3/cHOAYOWe4rW2ykBxZ76iQeyojAmFK/Tjpjlp9Q5f2oEiFyP6CdKLWBOjOGdYhjoCIvuAtcbjf4me64MoHVW7ZH1m0hTCW/fHedlU6qAZbyLhQ3r9dWbVfgLrYLTs9SRKDdJ3sx/4ok8bdK6BdaLPReLj6BJnThJ+2RaoiqNUfIifCIf9O8ntVTQGvqd2uPYDtEIn4Un27eSzrLGKW3hH7SwYB1eU6D8yW9OwO0BJMWBhMFZoFR5wkSi+ERCtx8Qc23Ms19tDGg0tJsJRFfKE7CovX1pg+6FlR3jrqBegqSs7bTg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(366004)(39850400004)(136003)(376002)(478600001)(26005)(83380400001)(186003)(38350700002)(2616005)(8936002)(38100700002)(44832011)(52116002)(8676002)(6916009)(5660300002)(6506007)(956004)(86362001)(316002)(36756003)(2906002)(4326008)(1076003)(66946007)(6666004)(66476007)(66556008)(6512007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/xhAop0SselzIfnSYBjSfxPgAWIZcpnuPGKdH9j4DzDimy5tLTsb3YZCalek?=
 =?us-ascii?Q?CB1d8S6oUtffDSrUNWzfs0m45DGXP+Mz1m+enKomWMycQJy/OKJ0oIdnr1Pj?=
 =?us-ascii?Q?bv5u5yWLDvkn3qRrv7T24Scu0BjRK6thG79c1v87LiXBTOXY/bldpAf4DtUS?=
 =?us-ascii?Q?OuS/EIQcPkLfyAT0ogUpQaVBRWa2YXUAEfqS2FdNAqqhD0Q8HNusaWGexke8?=
 =?us-ascii?Q?rIGOUXdDNFt1xZ7yRtLujSpgf5ip5tHCdeJFkqe15hZ6z4stE+v+FxB/Xu0C?=
 =?us-ascii?Q?5HJGvUWA7L8Euw6iFUTihQA9B3Fh9Fvm63IRpg0l51s7JTyVc2X7/UUFxpek?=
 =?us-ascii?Q?t0ajyZ5ovqEGO9EZCDMIHIJuxj2UjzKvHJTZ3LZomqEaqfZhvbTcqzJfVj2S?=
 =?us-ascii?Q?Kz2/K/seV8zsoA1vkam90gAqt9FQgPK1gfahdm7H8BIw+pExH+oezX2Q5+7F?=
 =?us-ascii?Q?60nic/++jCTLUubn6k5Tk8NyMbPkrwt75HE02CQt1tSOsSqTVIohTYCU44NP?=
 =?us-ascii?Q?I/NRjgOSGc9GL52NdNfml71GIEpJe73q2/txxLMkdOtbz9ElLdw2z3igSddC?=
 =?us-ascii?Q?MjR/mw4BSEPUGsP3g+hj9MljBQMpr+Zo4kMWDbgQ2jdXrGUAcbQKiUtIoDXz?=
 =?us-ascii?Q?cmoJtfL0ugDJcIl5c8xlMZPk5XYFLM5ojg7x4LAv8ktFC2A/mKYLSx43+Pbo?=
 =?us-ascii?Q?XGF/0cN75jsB5lWPBNUdvxay7IwJ1hjWNRVPbywEIhzbeRxLjrGGKxmjI28d?=
 =?us-ascii?Q?4QsAzeB1k9d89v8lFv7eOmQZlWLF4khFOj8EHIIeDcDvOS+2NTID/3YT7WNj?=
 =?us-ascii?Q?7GSqFr2fOiUh6Ojn7+wlKkG47HeA9gF7lBEdGjwt7EOeHrsZmuVghz1Wqvbf?=
 =?us-ascii?Q?ZMc+9foEaH9/98Cnx+AQm7Xzuk+jyzM3BGs4ZBoBVc93s/toBCSU8GF2VohV?=
 =?us-ascii?Q?Mn9tIBijLmybwJBaXkmfjP77zBXirqSevVS9uld5KXxgTM5a2TCuJItelkcO?=
 =?us-ascii?Q?QKaf5pG8z2ZZt/o531GnwTBx6W4QX6++R6OmndXcbF+ai0snODbhxAv7obaJ?=
 =?us-ascii?Q?x0fTI6Wi2Nj+dCPNdLLiNUux4KZyAvboxxNXXNEwY0nlEJSppFLem4uujNzv?=
 =?us-ascii?Q?Tc/EBPzc48dIioNA676w0dAh8E7SeVn++r6nTqlpfFUzEUACt7wZ5O/I/fCf?=
 =?us-ascii?Q?cSkoe06VpFVK/MOKkFpgyARg9RyDcDz06lmL3/j7ZUlnrHSEM3MdOaeyIjJg?=
 =?us-ascii?Q?HAefN+DDYQZ9/DYr6A6CvhYFux6be9Qn9x4Z5ZBDD4PknX8nV1TnuZjzl67W?=
 =?us-ascii?Q?bQRJg9o9nnRtVNSkZMmV+Jav?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c11f8873-a435-4587-ddee-08d976cc2fc1
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 15:35:59.7640
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pew1pdjoa0cSOD2gQsAus6WIKX+Xz9BPtbSXPlRirpNHT2vWTTLORjfZPMI2f4zNa26GUJ/yPxZlKZz5NLRwc4r1TK5doUtXCcE9vU93txs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5549
X-Proofpoint-ORIG-GUID: 5oQ760nT1wypYaimEyYrq3aGXwpFrIBX
X-Proofpoint-GUID: 5oQ760nT1wypYaimEyYrq3aGXwpFrIBX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-13_07,2021-09-09_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 mlxlogscore=654 clxscore=1015 adultscore=0 bulkscore=0
 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109130103
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Ignatov <rdna@fb.com>

commit 2011fccfb61bbd1d7c8864b2b3ed7012342e9ba3 upstream.

Currently there is a difference in how verifier checks memory access for
helper arguments for PTR_TO_MAP_VALUE and PTR_TO_STACK with regard to
variable part of offset.

check_map_access, that is used for PTR_TO_MAP_VALUE, can handle variable
offsets just fine, so that BPF program can call a helper like this:

  some_helper(map_value_ptr + off, size);

, where offset is unknown at load time, but is checked by program to be
in a safe rage (off >= 0 && off + size < map_value_size).

But it's not the case for check_stack_boundary, that is used for
PTR_TO_STACK, and same code with pointer to stack is rejected by
verifier:

  some_helper(stack_value_ptr + off, size);

For example:
  0: (7a) *(u64 *)(r10 -16) = 0
  1: (7a) *(u64 *)(r10 -8) = 0
  2: (61) r2 = *(u32 *)(r1 +0)
  3: (57) r2 &= 4
  4: (17) r2 -= 16
  5: (0f) r2 += r10
  6: (18) r1 = 0xffff888111343a80
  8: (85) call bpf_map_lookup_elem#1
  invalid variable stack read R2 var_off=(0xfffffffffffffff0; 0x4)

Add support for variable offset access to check_stack_boundary so that
if offset is checked by program to be in a safe range it's accepted by
verifier.

Signed-off-by: Andrey Ignatov <rdna@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
[OP: replace reg_state(env, regno) helper with "cur_regs(env) + regno"]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 kernel/bpf/verifier.c | 75 +++++++++++++++++++++++++++++++------------
 1 file changed, 54 insertions(+), 21 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index b6f008dcb30c..47395fa40219 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1755,6 +1755,29 @@ static int check_xadd(struct bpf_verifier_env *env, int insn_idx, struct bpf_ins
 				BPF_SIZE(insn->code), BPF_WRITE, -1, true);
 }
 
+static int __check_stack_boundary(struct bpf_verifier_env *env, u32 regno,
+				  int off, int access_size,
+				  bool zero_size_allowed)
+{
+	struct bpf_reg_state *reg = cur_regs(env) + regno;
+
+	if (off >= 0 || off < -MAX_BPF_STACK || off + access_size > 0 ||
+	    access_size < 0 || (access_size == 0 && !zero_size_allowed)) {
+		if (tnum_is_const(reg->var_off)) {
+			verbose(env, "invalid stack type R%d off=%d access_size=%d\n",
+				regno, off, access_size);
+		} else {
+			char tn_buf[48];
+
+			tnum_strn(tn_buf, sizeof(tn_buf), reg->var_off);
+			verbose(env, "invalid stack type R%d var_off=%s access_size=%d\n",
+				regno, tn_buf, access_size);
+		}
+		return -EACCES;
+	}
+	return 0;
+}
+
 /* when register 'regno' is passed into function that will read 'access_size'
  * bytes from that pointer, make sure that it's within stack boundary
  * and all elements of stack are initialized.
@@ -1767,7 +1790,7 @@ static int check_stack_boundary(struct bpf_verifier_env *env, int regno,
 {
 	struct bpf_reg_state *reg = cur_regs(env) + regno;
 	struct bpf_func_state *state = func(env, reg);
-	int off, i, slot, spi;
+	int err, min_off, max_off, i, slot, spi;
 
 	if (reg->type != PTR_TO_STACK) {
 		/* Allow zero-byte read from NULL, regardless of pointer type */
@@ -1781,21 +1804,23 @@ static int check_stack_boundary(struct bpf_verifier_env *env, int regno,
 		return -EACCES;
 	}
 
-	/* Only allow fixed-offset stack reads */
-	if (!tnum_is_const(reg->var_off)) {
-		char tn_buf[48];
-
-		tnum_strn(tn_buf, sizeof(tn_buf), reg->var_off);
-		verbose(env, "invalid variable stack read R%d var_off=%s\n",
-			regno, tn_buf);
-		return -EACCES;
-	}
-	off = reg->off + reg->var_off.value;
-	if (off >= 0 || off < -MAX_BPF_STACK || off + access_size > 0 ||
-	    access_size < 0 || (access_size == 0 && !zero_size_allowed)) {
-		verbose(env, "invalid stack type R%d off=%d access_size=%d\n",
-			regno, off, access_size);
-		return -EACCES;
+	if (tnum_is_const(reg->var_off)) {
+		min_off = max_off = reg->var_off.value + reg->off;
+		err = __check_stack_boundary(env, regno, min_off, access_size,
+					     zero_size_allowed);
+		if (err)
+			return err;
+	} else {
+		min_off = reg->smin_value + reg->off;
+		max_off = reg->umax_value + reg->off;
+		err = __check_stack_boundary(env, regno, min_off, access_size,
+					     zero_size_allowed);
+		if (err)
+			return err;
+		err = __check_stack_boundary(env, regno, max_off, access_size,
+					     zero_size_allowed);
+		if (err)
+			return err;
 	}
 
 	if (meta && meta->raw_mode) {
@@ -1804,10 +1829,10 @@ static int check_stack_boundary(struct bpf_verifier_env *env, int regno,
 		return 0;
 	}
 
-	for (i = 0; i < access_size; i++) {
+	for (i = min_off; i < max_off + access_size; i++) {
 		u8 *stype;
 
-		slot = -(off + i) - 1;
+		slot = -i - 1;
 		spi = slot / BPF_REG_SIZE;
 		if (state->allocated_stack <= slot)
 			goto err;
@@ -1820,8 +1845,16 @@ static int check_stack_boundary(struct bpf_verifier_env *env, int regno,
 			goto mark;
 		}
 err:
-		verbose(env, "invalid indirect read from stack off %d+%d size %d\n",
-			off, i, access_size);
+		if (tnum_is_const(reg->var_off)) {
+			verbose(env, "invalid indirect read from stack off %d+%d size %d\n",
+				min_off, i - min_off, access_size);
+		} else {
+			char tn_buf[48];
+
+			tnum_strn(tn_buf, sizeof(tn_buf), reg->var_off);
+			verbose(env, "invalid indirect read from stack var_off %s+%d size %d\n",
+				tn_buf, i - min_off, access_size);
+		}
 		return -EACCES;
 mark:
 		/* reading any byte out of 8-byte 'spill_slot' will cause
@@ -1830,7 +1863,7 @@ static int check_stack_boundary(struct bpf_verifier_env *env, int regno,
 		mark_reg_read(env, &state->stack[spi].spilled_ptr,
 			      state->stack[spi].spilled_ptr.parent);
 	}
-	return update_stack_depth(env, state, off);
+	return update_stack_depth(env, state, min_off);
 }
 
 static int check_helper_mem_access(struct bpf_verifier_env *env, int regno,
-- 
2.25.1

