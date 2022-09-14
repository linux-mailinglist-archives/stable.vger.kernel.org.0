Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5575A5B8797
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 13:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbiINLxl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 07:53:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbiINLxc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 07:53:32 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B43077D782
        for <stable@vger.kernel.org>; Wed, 14 Sep 2022 04:53:29 -0700 (PDT)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28EBgllX000941;
        Wed, 14 Sep 2022 04:52:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=bEsmi7ltllmK9WrkBZ/nO4AaWcFeqWHPQftXSj5lXdQ=;
 b=jESG4xfAI1mbzDUz+XksvAWXSI4Cqpwlo4b94g4ULWiRbgKEaqBQbk62aBQc1CWyQ7MY
 rNIYpwQfwA8C/BAzanUUjnwOzHWHNiCIvfREzMaDVM/N34/2r7l6wrqUzH7JihXeAu8T
 w+AHrmX3jyEIHZLo9aGDJGyQzsR88xtUYS7lZ7mZKfeYgwcl/fqg9GRp/VtnDuqjux2+
 xkIEvf2AUoH95t/V2IdxRuLKqEplnO3sS9tE3NeglMU7hoWruun1zK1nTLk6L0kKHfua
 fLYDLx4q8imXR8Sk+zRG/wBESa4lSw6rI6dmC5/Zanet0a27rN6KKDpkyOgFKlDGdX2C Lw== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3jk4sh0ery-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Sep 2022 04:52:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JCUnxnkpLmTgj5vHDei3lq9QkWu/r5+edG1H99Ruybpy7N8FifDVROfsAb/wVsvmYfOiIX7N1m3VkMrBOf0Lg3r5X7erNcR3d6/8mc0bDIxTayihpj+vOP/MlBmr2Wqepg03TCUxuBma0duftK5ryjxbrYOcjUBfZXsplQLl/rquYajJJDxGcISlz2Aa1EGfNdB8asbh6bSkflZYIZ2fLqgrLuUqxjAsoRkhMR/p/SUw4saYLCk32SzAfKeqbI86i2oGkpqOxrrMLYxcqazW/DugK6CL/oj+smE659XJX2vaLLvfV1U1aG7THTf6nbvLHe9Ly3qt1K79AOgOLwdNXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bEsmi7ltllmK9WrkBZ/nO4AaWcFeqWHPQftXSj5lXdQ=;
 b=iiY0GZcMsD655cBkc/STKALyQ/rOogypINjRtpOFcpJ+YFxOzd+RQNLKAQvDOgEqdVJ4ThdHms2rf2of6/Z4F/a+OpOW3vhSrgCPHUgiTRttW4aKazJfcNetnd7kfPglejy73xy6VRaYmpLA8cbytYmotP2gV5o6JPoA1RQkwqQcy6NE2oJQqIEOo2ySxmP0sJYKbbrcdtoKFLqmV3s8BwO4qTz0U23rPsewJeQzk/6slg3xAT3PQEzKtJGNlmEDTRJyCeG7dvsq2wEcwrnCc4j6V5vNiTkwtHxjhtNLkiXa1+faNqSn8uFeOkzd9NIEcJRLOsdhQnjcrYuv+EGq/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by MN2PR11MB4711.namprd11.prod.outlook.com (2603:10b6:208:24e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.20; Wed, 14 Sep
 2022 11:52:57 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::b4a9:c48a:51c2:d3fd]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::b4a9:c48a:51c2:d3fd%5]) with mapi id 15.20.5612.022; Wed, 14 Sep 2022
 11:52:57 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     paul.gortmaker@windriver.com, gregkh@linuxfoundation.org,
        peterz@infradead.org, bp@suse.de, jpoimboe@kernel.org,
        cascardo@canonical.com, Josh Poimboeuf <jpoimboe@redhat.com>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 5.10 2/3] x86/ibt,ftrace: Make function-graph play nice
Date:   Wed, 14 Sep 2022 14:52:37 +0300
Message-Id: <20220914115238.882630-2-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220914115238.882630-1-ovidiu.panait@windriver.com>
References: <20220914115238.882630-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0801CA0083.eurprd08.prod.outlook.com
 (2603:10a6:800:7d::27) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5327:EE_|MN2PR11MB4711:EE_
X-MS-Office365-Filtering-Correlation-Id: c4dc551d-c781-49a6-7534-08da9647aa8e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W/yw733F3eQTKoUguo30A3tXsEeEN8JMiCvE7Kg/h5YnnSXXT7h2sUXqEWBhdnC0U4GLwYVSauIjvtb0TPmS0Lo96vG2hHKfKF/gnsjyPY+/5CozNe/yzr/kokdB9hkf+U2xu9TWyRHRZmBB+RMZ4DOGpvdDxXYV4ihJCE4I61tJCk3Kdy7FmwxMFx3d+peQLULkfaLzhuWiv3RF7SFsYiAnhvlXJJ1nJFQLqo8Ky3yyaJKKjF1h5KR28wP8XWJPEB4id4x8Dxg+4vENJptlA4Iam9rAVxumnXVz2IhEanvon2wF1hqAzRBGpP0Tci77CeyU6rnz2XWzLMcH2jHiO/1qIHWH2QlLCejcTPaYBgRWQajhRN/kc5TJXGAItSUKID3doCJtsqRPvfLEybYXG0vfXYtYRqzf4wbetzXJNnatz/SavSHWw4tMnWYqpM8QjyEjhoAm9xyR413uTr3MCwzZpLf/R8Btl5QGXyhaJvYc5jR3oYVf3RLd5sZ35Aa66VW3p7fPtXeWLQQv7mSdqawmD8A6b8m5vl8DjBXIuFwBOqnYbnkhKgHtpPB44KDB8iDNLPHxzISbAX14qHkOwfx0ly2ZDFdMf/Hk21gSIZQSLqcjdK7R/twLxAFD56yC0Kt4nko9vhVwmhpzrXgZ4o9ycZS93DO1wAxPHCNKlMtMfiBGAH24W/QdlNgwFdy1SZMSvVBS7wTAxDBnbSGIkB8pAA+Vp4ZGWXr+Xwzrpt1CIXACSa3F1h0pNlaOIDwzvXonTTkhkYqCR3ayZakKDyLqsQMMyG3dFQZgHQDwEbw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(136003)(39850400004)(376002)(366004)(451199015)(66476007)(86362001)(38100700002)(2906002)(54906003)(8676002)(2616005)(83380400001)(4326008)(966005)(6916009)(26005)(478600001)(6506007)(186003)(8936002)(6512007)(107886003)(52116002)(36756003)(44832011)(38350700002)(66556008)(316002)(6486002)(6666004)(41300700001)(66946007)(5660300002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OgpDKjU2L9RcUv3T+karS3VzqUa6Dqml3xol99gXQ+pIZlB97j6Hfz3Od8Oq?=
 =?us-ascii?Q?t1LxthKQW1ZKleuMn9IEwH77fbQFafIcOJmhBdRTPbgTK7OqmzBlzZpRxSjm?=
 =?us-ascii?Q?K9GDGmD++8SRfIHbea/gDBHrQKjdgeVZWild3bUtT57CqcHQS8pOppwZ9b52?=
 =?us-ascii?Q?UDYxei+I9F6u1KQCiqlKGnMlsCQCdNK+VHOXAaHbI2fSYQv44rfavwq24qJM?=
 =?us-ascii?Q?nuInrGotviaGLl5ODwqQnKhoKkeFBbsdX/mcxaLigrnmFtu3tMucWjtoj7Eo?=
 =?us-ascii?Q?EPehRdPRtKAORc6GRAZ3yI9aojCpgiKX0AzfI4mhF57Hb3ziMXkRkqdA+Uxf?=
 =?us-ascii?Q?Oohs3mxvezJy170zgPItrYYv/nKfry/QqUD3mwHRaXcb/CEAMztgo4pi66XU?=
 =?us-ascii?Q?VB15N+7U53KdbdmPdPMNFZezs5ORdG/Sqz2kf8E3B1LRMpOk85ychKtJc7lD?=
 =?us-ascii?Q?0LuG88ba6tDrf5sk4lca3c8XRYMk1BjeohuqIRLQOnEz/KxastYAfYMpVomr?=
 =?us-ascii?Q?yceArO9sS0Jkwj8z6yIGnvNmS/0qyJ1IM+OS4Vf5jEfA8p7Sbg6YfsBn4qYC?=
 =?us-ascii?Q?R4OFPQvu5xTvOnRUpe7ga9aGLg1cBrjvc/Me5JjTcCdxjUf6CdUU/G4yqdJd?=
 =?us-ascii?Q?98FHSbpeTo3YpyGuYwzIzmzeH00jKdaDs2LCdHn3VEG3IaF4MRCPhtbAxeJ7?=
 =?us-ascii?Q?ThteRtRgbaMUzaDWVrczrrPIKUs7Vdz/VhzCfSOZIofxOL8xfbctV+GrP+ZC?=
 =?us-ascii?Q?nFDhzZ/ocloU195evFT4WfX8oaG2GJ0sumbovjE9voHp1rVIvx/V7STL1oOX?=
 =?us-ascii?Q?AxIB+887E5WT72Jy+0TBplqS+Sn12MYxheTank8Ie4Rt5h4Wnm+AZ3eVhZDH?=
 =?us-ascii?Q?IBXdRfFnuEy21INFd/iOiKFXOBdDWaddOPcr1mS7o4OFfwwpA0eyefeU85Wl?=
 =?us-ascii?Q?3bLhu1hIIS02oncVYO8bKP4VNp8UdyK7iBG3lwffEVgtKtIwEFbgglknYZz8?=
 =?us-ascii?Q?Ielwrx5gEfFNAb5YH2tBiVmnysUzaaMCfX/wgrP1W0SuG0Y37X7xjOYg2OW6?=
 =?us-ascii?Q?+9ftiVQ9QFxVQVxqHPFevFjVuI2nRbnm+3IKfj4q0eS+Fl727s8UX3E0CRQg?=
 =?us-ascii?Q?6LG+BNWzBWtTOuaXrB9zp1SZ/2YcVrYeO6RD2bXRtjo41sgI/A99CAZJ+LjF?=
 =?us-ascii?Q?tRu+eiibsc6wX84NtWGkin+Ff7FWqOWFiqMVcR9IJvBWSQjmB6zJi+WqbDKO?=
 =?us-ascii?Q?gfXQe7vbLSOsRYV8VY9jO6Yv+Eap7K8pirIhxOWu6zzkt2YVgNvMLpo4JasU?=
 =?us-ascii?Q?LCzlKVoEcPij5zF+7VMYM2AUcLo9ePLl0Td05OuLFFX9O17gDdcDoktF/KsK?=
 =?us-ascii?Q?rA/Of2MToc3qsneCIpVPm0105I9IImNKECtaBdgaiKbh9i3xHfBSit/73TUp?=
 =?us-ascii?Q?sKdNNTVSu4uDDZXmqdsfCr9bs31t5Dk1f4IUromXsJFeJmvsFyZ8L8XHQmqE?=
 =?us-ascii?Q?TMISv87JaCa2eo7vuoPspSANUOPyD85qqHEUVhLErTK5Ymc15Bn/h9/PJYcZ?=
 =?us-ascii?Q?fNtY1hFo+r6Cm/3C/FWNCLe/A++AvedjJXkn0ud7O6hIxz4gsousB6vcbHCp?=
 =?us-ascii?Q?Jw=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4dc551d-c781-49a6-7534-08da9647aa8e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2022 11:52:57.6059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fl4O+a/GWJHRKx4OkcR6kfK21DXTVhT2hwBUS59q7xZ1ILxO18ZCNAhkVGBmIGcMYnHPpFtFFjg9ZxAt37mccmGrQQosHq7ecJPlHNUBH0k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4711
X-Proofpoint-ORIG-GUID: Q4NK7pHLVL5hL9g5S_9CnUQzRYtnv9JG
X-Proofpoint-GUID: Q4NK7pHLVL5hL9g5S_9CnUQzRYtnv9JG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-14_05,2022-09-14_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=719 suspectscore=0 priorityscore=1501 bulkscore=0 phishscore=0
 adultscore=0 mlxscore=0 spamscore=0 malwarescore=0 impostorscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2208220000 definitions=main-2209140058
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit e52fc2cf3f662828cc0d51c4b73bed73ad275fce upstream.

Return trampoline must not use indirect branch to return; while this
preserves the RSB, it is fundamentally incompatible with IBT. Instead
use a retpoline like ROP gadget that defeats IBT while not unbalancing
the RSB.

And since ftrace_stub is no longer a plain RET, don't use it to copy
from. Since RET is a trivial instruction, poke it directly.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>
Link: https://lore.kernel.org/r/20220308154318.347296408@infradead.org
[cascardo: remove ENDBR]
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
[OP: adjusted context for 5.10-stable]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 arch/x86/kernel/ftrace.c    |  9 ++-------
 arch/x86/kernel/ftrace_64.S | 19 +++++++++++++++----
 2 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 449e31a2f124..b80e38cbd49e 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -322,12 +322,12 @@ create_trampoline(struct ftrace_ops *ops, unsigned int *tramp_size)
 	unsigned long offset;
 	unsigned long npages;
 	unsigned long size;
-	unsigned long retq;
 	unsigned long *ptr;
 	void *trampoline;
 	void *ip;
 	/* 48 8b 15 <offset> is movq <offset>(%rip), %rdx */
 	unsigned const char op_ref[] = { 0x48, 0x8b, 0x15 };
+	unsigned const char retq[] = { RET_INSN_OPCODE, INT3_INSN_OPCODE };
 	union ftrace_op_code_union op_ptr;
 	int ret;
 
@@ -365,12 +365,7 @@ create_trampoline(struct ftrace_ops *ops, unsigned int *tramp_size)
 		goto fail;
 
 	ip = trampoline + size;
-
-	/* The trampoline ends with ret(q) */
-	retq = (unsigned long)ftrace_stub;
-	ret = copy_from_kernel_nofault(ip, (void *)retq, RET_SIZE);
-	if (WARN_ON(ret < 0))
-		goto fail;
+	memcpy(ip, retq, RET_SIZE);
 
 	/* No need to test direct calls on created trampolines */
 	if (ops->flags & FTRACE_OPS_FL_SAVE_REGS) {
diff --git a/arch/x86/kernel/ftrace_64.S b/arch/x86/kernel/ftrace_64.S
index e3a375185a1b..5b2dabedcf66 100644
--- a/arch/x86/kernel/ftrace_64.S
+++ b/arch/x86/kernel/ftrace_64.S
@@ -170,7 +170,6 @@ SYM_INNER_LABEL(ftrace_graph_call, SYM_L_GLOBAL)
 
 /*
  * This is weak to keep gas from relaxing the jumps.
- * It is also used to copy the RET for trampolines.
  */
 SYM_INNER_LABEL_ALIGN(ftrace_stub, SYM_L_WEAK)
 	UNWIND_HINT_FUNC
@@ -325,7 +324,7 @@ SYM_FUNC_END(ftrace_graph_caller)
 
 SYM_CODE_START(return_to_handler)
 	UNWIND_HINT_EMPTY
-	subq  $24, %rsp
+	subq  $16, %rsp
 
 	/* Save the return values */
 	movq %rax, (%rsp)
@@ -337,7 +336,19 @@ SYM_CODE_START(return_to_handler)
 	movq %rax, %rdi
 	movq 8(%rsp), %rdx
 	movq (%rsp), %rax
-	addq $24, %rsp
-	JMP_NOSPEC rdi
+
+	addq $16, %rsp
+	/*
+	 * Jump back to the old return address. This cannot be JMP_NOSPEC rdi
+	 * since IBT would demand that contain ENDBR, which simply isn't so for
+	 * return addresses. Use a retpoline here to keep the RSB balanced.
+	 */
+	ANNOTATE_INTRA_FUNCTION_CALL
+	call .Ldo_rop
+	int3
+.Ldo_rop:
+	mov %rdi, (%rsp)
+	UNWIND_HINT_FUNC
+	RET
 SYM_CODE_END(return_to_handler)
 #endif
-- 
2.37.3

