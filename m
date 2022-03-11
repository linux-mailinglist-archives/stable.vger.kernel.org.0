Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72FB94D60AA
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 12:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348301AbiCKLdJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Mar 2022 06:33:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348270AbiCKLcr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Mar 2022 06:32:47 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B637D1BA92B;
        Fri, 11 Mar 2022 03:31:44 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22BAUBfF024112;
        Fri, 11 Mar 2022 11:31:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=PdeRqTN9bEB8sUwFM4WlvpqoMF2l9jn/jBUtww5Cw3A=;
 b=vcIZNs2rXSTf8tA8db21aT3L7FUh28qx5Go+JGHMx1ew2iIBryssBrWhSNa53It7BC63
 7NHe24tznSVRZ07j6DpxvXOVCKtUpmMgnhORq+XDI3CsPCuJhqxzvx4NB6CkTowy+m63
 Wk5EAXyCvUxLvppBcDIklJQXQFQjl3quRzk+Nfwq4hmkr8Azcs3jtuuBXkC3LBZc6aHm
 RnNGDEjTz9WbJ/zgEjclpZgieaig13CBs0QYJKXH/OpP86fYukb3UGGcbaFUlI90xHhI
 7RIoagwxlJmFhXhou9TIHPnbcQxCmwImciSjh2J0te/893DENDQ1+Rf4NPqQzOxwjxm3 Cg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekx9crbg3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Mar 2022 11:31:19 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22BBFjPm137782;
        Fri, 11 Mar 2022 11:30:18 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by aserp3030.oracle.com with ESMTP id 3ekwwe27u5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Mar 2022 11:30:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E1aQoNv5h/s8C5kZ68v/eLQmM0/ScKji4OxC18J1+4MDTCnHr0SCZmZri8PDd3VUFXcz9Gzy6PbjYt2E7CPKJDyV0mbQmnzdnBciWbK72VFFP1ASKikVuzI8ozwYhotY636pVdys4RVjV2bw4V9GIfWvF6N3vBysyO4U6mI8xADKRLAwb9ZXabhY0rhqB/VhDOFVXAgiwHYbDlxM+8ZP7HVgBZfW4E+Ml1/ay/bNJErY45AO3/WZEBatM5o1FtjCFLkJDISdLz2NuAD0B/Yi84PkaEFXBIV0tWu6gf3bcSeaABS2T7eRZqP/ra+FjyIor0tL1aKsfFD9l84v+yXCSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PdeRqTN9bEB8sUwFM4WlvpqoMF2l9jn/jBUtww5Cw3A=;
 b=ST8hzK0f27IlejGSvt3WcCKB9S7R94Iqqh1noRWs1vG2mFRTSbtxfuOEfs5G4aHheEOmDoP1lTe4MTo1+PGV0VqNnz/kB2Rde34EzVh7iA+yUB6+FbYIc9f7iK9BPiwgKWQoy1OXRM5+Khqsv9LoxSzPrB7b6jIiGe1+gaAbd0+tIU+lhOAbbOR83GaT8Js3ApXXkLWRlgLMK1kXRQSI6G8J+YunmQw5koNsNnrC1WCDAmjuLK/yv/cqDndFBdCjUt6h7TSfVJUyJvCqipsfHFbOu/XVytS856D6+2DtdhU7pNrTEmeeZ9tqj9XliajyjXHmvdQGe2EdNNrc8j9soA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PdeRqTN9bEB8sUwFM4WlvpqoMF2l9jn/jBUtww5Cw3A=;
 b=MLYhetOCZeXsOyVoi1sgHVJQN73S6pK1tRChPs30Mdcx71jHCjk3WfrmRC9cPifIrpiHluOAT2SBff+raQTlzmroDvhq+SWaMNZGsZ1HS/0y57AuZ/cIUMn0jG2Wgy9oJfMh6EwLjGcyUt72YtBCK0V4G5sOBp55soeWAOXUxjU=
Received: from BN0PR10MB5030.namprd10.prod.outlook.com (2603:10b6:408:12a::18)
 by CY4PR10MB1430.namprd10.prod.outlook.com (2603:10b6:903:26::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.17; Fri, 11 Mar
 2022 11:30:16 +0000
Received: from BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::b9d4:8912:7bf8:14fb]) by BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::b9d4:8912:7bf8:14fb%9]) with mapi id 15.20.5061.022; Fri, 11 Mar 2022
 11:30:15 +0000
From:   Liam Merwick <liam.merwick@oracle.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, x86@kernel.org
Cc:     pbonzini@redhat.com, bp@alien8.de, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, krish.sadhukhan@oracle.com,
        liam.merwick@oracle.com
Subject: [PATCH 5.4 2/4] x86/cpu: Add hardware-enforced cache coherency as a CPUID feature
Date:   Fri, 11 Mar 2022 11:29:25 +0000
Message-Id: <20220311112927.8400-3-liam.merwick@oracle.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220311112927.8400-1-liam.merwick@oracle.com>
References: <20220311112927.8400-1-liam.merwick@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0088.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bc::7) To BN0PR10MB5030.namprd10.prod.outlook.com
 (2603:10b6:408:12a::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9ed07ef7-0584-488e-ece3-08da0352839e
X-MS-TrafficTypeDiagnostic: CY4PR10MB1430:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB1430737E7E8FEA2806D850F5E80C9@CY4PR10MB1430.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +Px9Mp8SBH7NRztaSZ6YllpP7ao24CGqZu4vtZHScwsmGmWwDZrsHSr0/99J7KqegAr0erO9oLY2eZT/ak/h75vx+jr+TzoQW/RrirThA6pw1Tv5UH7c0q+5eujI2FtM0Pf7T/sMkbj9u5nYDQTmUuzOGsB5/SjdJup8aUDBNDswOMrcPrD+YV9vg/ZhDz5jK/eX29Kj7wUIEWFpe9hv6S2rRFfGVpAXH5k/0/iurX1dGyup2Vv7f20PKdNtg5noPHW4bow45FhGQYxzQDQ7ISgv3pWW5g0QbRcXXCXbwc+qWq5Tra5rNAgm6bmgau05878vNkNLZV+y9D0tOLW7ghcXUTqn4qUU6QL70CRNiIn+lKArqANV0xH7Zy4VDP9BGWSMHFLpT7Mhd+H7dGp3q8tD1hPSqnmi9CFq7l5CoL2cwtMTjXFhdLRsjjMGfDyk51zL5OmDjVcbaval7MdIUwR/v58VeRFE565HUv5jRw5PWy8TvsdQj/FGxgLSts2psVVbsYst419KaTLLBNCuFEEsV3+ARrnOWa65t1igrhPC56GhFj6UsS98KYl1jifSiGafvpyyvqoFaOTHTYJnHo+PPBSU9P0wJJepQvfISFjzFHpzwhcD8WJZhE/hOVSxkXzryt9cbFYj3IctFNGs2cuS9tptP6bCNH0PzRuBSOKf0rtKFsj6rXQZp1YYjSHt858bRnKOUU8rVUw/0iFqwVSJEJGhlsYpCmjIOFbcG4qch5uZgg1qhujJmdLC0ovCk/hV3XKRtOBIfarRtfc1fk4fOzJZDT/Vxl/Mlwhg+Gg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5030.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(8936002)(4326008)(6666004)(5660300002)(8676002)(66556008)(66476007)(66946007)(508600001)(44832011)(316002)(52116002)(6512007)(6506007)(38350700002)(966005)(6486002)(107886003)(86362001)(1076003)(186003)(26005)(2616005)(36756003)(83380400001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Za7NjJxkq7fsGwmBaK8wH3cmpzkQOohIBbuNHFcpQMoOcHRCSHeupskEoKeN?=
 =?us-ascii?Q?8Ib7YS98dxCWkcKOveVQE5JAsShPtryZHMJd2avL1m2SxoNdNkjjeTXXy14k?=
 =?us-ascii?Q?Shcyh+Ka+ycL/HfyLfAod5WA6BSPvc1D2z87pooWcIFkJJoWYKeJ9fZc+YvZ?=
 =?us-ascii?Q?T1sJI7I8f0cz/eW3/ziQzJHzD0DdJLufi8ZFXhjQ3e43kw+dVE/Tc1F82v81?=
 =?us-ascii?Q?05xUlpQR+fNxRAaz3noOqDgayaVunUiYgeBvwwwlR3mI84woiGd52hmDOAbg?=
 =?us-ascii?Q?EDPmFVgMEh2d+9EEeeDhTQ8F7eBubmFp4eX/sHbD1fH90OzsdYj72lQ1UILp?=
 =?us-ascii?Q?11N7l2zVYs+4YTwSC9ORQRj8RE999jDzRXnBWWj5x5HcO7891iOplGF96bzk?=
 =?us-ascii?Q?cHKddUjKFw7NSLlL5c60y3jnulrN1czBF55auHElayKERSp7Lr8A9LXgnqMP?=
 =?us-ascii?Q?uOZaqkNcE9YkHwOge8VRniWWkwcUwbYkwCOPN2/Z9eka/4x78E1rxeKRU4RD?=
 =?us-ascii?Q?RWKWSkApfCBoCJ/uU0vEaRSjH/4Z8Nx7WY+wynuSeuI26fLpZnjUDaj6wKbW?=
 =?us-ascii?Q?GrZSsIT0GJV/X4Jd8QnWxZtNxoafSa5iy7m8Uo6sNgDo13dPlMOoxmtfwfOg?=
 =?us-ascii?Q?rU8o6FuP/nzCFe7wDd1J+TCq1A3SJNRNoj28RDR6zSmSvsxrL8X09dfJsqYn?=
 =?us-ascii?Q?OcIwyMiUokN/8g3yNgmKyAaKtp9MUSEZxW2YqhGk4ODKbsijkAwo/ToX70R9?=
 =?us-ascii?Q?fKoGjdmOOiS+viWPOyn4cjQ5wvXkZXLv3divOBHqnE0uwCjGKjqyE1CouOQg?=
 =?us-ascii?Q?FDsp0uCHaW2lKFWONFhiAF+rxtQUkLvGR+UVzIj+63tY1m8p0Z0zlLA6VX27?=
 =?us-ascii?Q?gnoA3qSu7FPTiQ/oxYioNTOaumklgzw2km4dv98+w9yMJq14legWbY66uaxH?=
 =?us-ascii?Q?3a0eDW3LgeudJ8Y5xPOfQqLQWIlYdBjEe7KlzEQkNcR0Id2sYONIQLpevB+3?=
 =?us-ascii?Q?XWTAC4S4DAJtyoEj0diUvgkgtSGcguIYDAdU1VStUbPZe1xAW65XT0+bqC+y?=
 =?us-ascii?Q?dxBflMe58fBCbFhFOZQyKV0Srh49EF+QJMyHpA5Q6JIiD350Idz2UfJX8aH9?=
 =?us-ascii?Q?ZcqQVZE+ekyxHSw/BcW/tEx9vGsJoja/ap+BDlMrS5CeOxM7G6Ut5xv5ukXl?=
 =?us-ascii?Q?JRqKVbzLbxvCtXq6iBPP8J4+zibBcDUPKm82pvnzpHQF8mb9Yz0EI+BZ+dVU?=
 =?us-ascii?Q?Rp5Zp36PyirNd6+C/xsRMAw7d/Up/GYJ9p3WmvC5T2WComAA+Bnm6mgEfnBK?=
 =?us-ascii?Q?oRHukLcs8e8dk1ZEwUPlBCCr2Uaf6dLWHUR5H68pMFBLl0PMnT2EJW/3s2FY?=
 =?us-ascii?Q?/wwXwnVNxcu1kVO6FhHNe0bePpFWzvcjUn2CD+OxksVk2qwFN7QFnryMiUrw?=
 =?us-ascii?Q?PBQFqRVZRPFSmLpw/3GE2M/tbWUtjHDWWn3itG3TphDYBbqHYgC5Rr3oQZ1O?=
 =?us-ascii?Q?K9zN7B9Tpzo7XLIh6L1e/CXLuM7pLkOLz4v5SYBKARp6rWkIFiG1VR13fUvK?=
 =?us-ascii?Q?iBvm5wMZhGYKlxivsR0J0STvH6FmS20WJUOhVQeMArFjCb7NES+iYZppangb?=
 =?us-ascii?Q?jpy66wKiabdG+pNs6JhOynI=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ed07ef7-0584-488e-ece3-08da0352839e
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5030.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 11:30:15.8653
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HcX7IYCNzZ8wCdSzZYPzz+hBitj3ZKi1UX4B5e8RSzrKL+IZnu+oSYqCRzTcjkaMTo8d6ype1Srid1ghVQD51A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1430
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10282 signatures=692556
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 phishscore=0 bulkscore=0 adultscore=0 malwarescore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203110055
X-Proofpoint-ORIG-GUID: ROEi2xeJUoUrtr4KeeHf51EPsjjHzUuJ
X-Proofpoint-GUID: ROEi2xeJUoUrtr4KeeHf51EPsjjHzUuJ
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krish Sadhukhan <krish.sadhukhan@oracle.com>

commit 5866e9205b47a983a77ebc8654949f696342f2ab upstream.

In some hardware implementations, coherency between the encrypted and
unencrypted mappings of the same physical page is enforced. In such a system,
it is not required for software to flush the page from all CPU caches in the
system prior to changing the value of the C-bit for a page. This hardware-
enforced cache coherency is indicated by EAX[10] in CPUID leaf 0x8000001f.

 [ bp: Use one of the free slots in word 3. ]

Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/20200917212038.5090-2-krish.sadhukhan@oracle.com
Signed-off-by: Liam Merwick <liam.merwick@oracle.com>
---
 arch/x86/include/asm/cpufeatures.h | 2 +-
 arch/x86/kernel/cpu/scattered.c    | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index c934eb807f23..4705533eb88d 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -96,7 +96,7 @@
 #define X86_FEATURE_SYSCALL32		( 3*32+14) /* "" syscall in IA32 userspace */
 #define X86_FEATURE_SYSENTER32		( 3*32+15) /* "" sysenter in IA32 userspace */
 #define X86_FEATURE_REP_GOOD		( 3*32+16) /* REP microcode works well */
-/* free					( 3*32+17) */
+#define X86_FEATURE_SME_COHERENT	( 3*32+17) /* "" AMD hardware-enforced cache coherency */
 #define X86_FEATURE_LFENCE_RDTSC	( 3*32+18) /* "" LFENCE synchronizes RDTSC */
 #define X86_FEATURE_ACC_POWER		( 3*32+19) /* AMD Accumulated Power Mechanism */
 #define X86_FEATURE_NOPL		( 3*32+20) /* The NOPL (0F 1F) instructions */
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index adf9b71386ef..53004dbd55c4 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -41,6 +41,7 @@ static const struct cpuid_bit cpuid_bits[] = {
 	{ X86_FEATURE_MBA,		CPUID_EBX,  6, 0x80000008, 0 },
 	{ X86_FEATURE_SME,		CPUID_EAX,  0, 0x8000001f, 0 },
 	{ X86_FEATURE_SEV,		CPUID_EAX,  1, 0x8000001f, 0 },
+	{ X86_FEATURE_SME_COHERENT,	CPUID_EAX, 10, 0x8000001f, 0 },
 	{ 0, 0, 0, 0, 0 }
 };
 
-- 
2.27.0

