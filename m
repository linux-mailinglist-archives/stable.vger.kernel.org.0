Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB92D4D609F
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 12:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348276AbiCKLdJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Mar 2022 06:33:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348325AbiCKLdD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Mar 2022 06:33:03 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 116B81BA92B;
        Fri, 11 Mar 2022 03:32:01 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22BBMdpI021579;
        Fri, 11 Mar 2022 11:31:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=jGh3T08BL2GYr2Jq3f90LU8od4bn89nJ7x5uOee7WYU=;
 b=Tamt5GH6NK+nJVsLPY6AZqwC98M/ukwUOPDck7MJOiYQnNzEZCFZeW8DY616GjSLXkki
 lZnpKY+IuhzrPo49Jd5loTTu+K7n1oB53+FS2z6QEHTXt64FfxcnOov16gfsoZkp1tRj
 hOa1s5XKnpuM4jXW8iqr80cl3fQMbNFYX4+ONhyWekA4KJ2tRUpDrV0CpEfAhaM29y+R
 0iz90XdiFA1eENYK36XObb7E0Eb3H1L1cq6/LtKImMOruhUdqz52IG+OBuyibD1CvBi8
 tPoi0MV51Zpa73LzP2U4egjE0zCQGGxRQFhGTk64csSzvaQIFoFzTxkeV6RiASHpNzfn DQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekyfsrveq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Mar 2022 11:31:39 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22BBFjPk137782;
        Fri, 11 Mar 2022 11:30:17 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by aserp3030.oracle.com with ESMTP id 3ekwwe27u5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Mar 2022 11:30:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GnGtS+5OHIeXMpK0hQ1gyOkMer+WDseWE3XawpzjBWew7HN9p3tdmNBhrJ2MxAjslAh5XI3o0P90Qp7RZJPFmJbt+VzoZAr4LtnyeA9CqwXKBCXtfA4l2QUyYHiI3iFVowRJiMjl7d7U5ODrmyPC06AXUDAfzKzHWmOXXQ+ldURrP/IaTorLjodMRxv3boLcNedbX5Bs0STtTmScNTnTevEn1w9kjup6nn39k0OUXJ5w72An2HqPB4RCDOz0H8/GpW6LAv01W0WF6LT7trWI54aX/+d83MG+5hs69XvLXbCwxVTbHjACqhvDnWAIqan6uFkIW8C//+IuHLf4SOqLSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jGh3T08BL2GYr2Jq3f90LU8od4bn89nJ7x5uOee7WYU=;
 b=MbyEFycf54++Vp2q9y4TceVKBYS2kNZPob8JE1L/YPKXa17NvUShFVuDkKJ4DqJSN3BOFsqMsCvW7V36hy6aOKzB+Mv5VhM4I1GMDE7Y+22PKzTTfTYXNSZPRLr0+Mofs3R8X9iNsEQPESGPFoKpVhftdSWwZCk/7sbgWabjBDV5PwYBklDlbwuDQ3RPSML5KakXzrzncEVFX1ZJqVRCAOIBPTt5txwHuzkLIR0kjhAEC+5qChfiqhNIUPndnEczdNYSH+552kC/uXSsxBFPpXU0T15cch+1vD3TmAtPajz0DlFYFfAP6a7V/9FON8Ll5Fs7DzXzM7cUdwWXAj4uyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jGh3T08BL2GYr2Jq3f90LU8od4bn89nJ7x5uOee7WYU=;
 b=pxanBjmyQGvq3wfADuYTbl3SKcM3NlmuvstTAeCRA95xcCk6Rrqz9589+SzhE1R+qefzpq0wVrHO2ehX9QsUnKSaBN0lWpKixEHnVPmX2/BuKhuPUS0X8wsRZZ1sbOn4c5yXg17y3eUaMQZYgCwta2G8VBOwWJbkcuPVNRckteU=
Received: from BN0PR10MB5030.namprd10.prod.outlook.com (2603:10b6:408:12a::18)
 by CY4PR10MB1430.namprd10.prod.outlook.com (2603:10b6:903:26::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.17; Fri, 11 Mar
 2022 11:30:14 +0000
Received: from BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::b9d4:8912:7bf8:14fb]) by BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::b9d4:8912:7bf8:14fb%9]) with mapi id 15.20.5061.022; Fri, 11 Mar 2022
 11:30:14 +0000
From:   Liam Merwick <liam.merwick@oracle.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, x86@kernel.org
Cc:     pbonzini@redhat.com, bp@alien8.de, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, krish.sadhukhan@oracle.com,
        liam.merwick@oracle.com
Subject: [PATCH 5.4 1/4] x86/cpufeatures: Mark two free bits in word 3
Date:   Fri, 11 Mar 2022 11:29:24 +0000
Message-Id: <20220311112927.8400-2-liam.merwick@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 94f1bed4-cd29-4751-6b14-08da0352828a
X-MS-TrafficTypeDiagnostic: CY4PR10MB1430:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB1430928F850C7002ADDB0D65E80C9@CY4PR10MB1430.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ay9HzOLa70v1LjU6UE6AdAhlfnkOtLmxtK4eOkPQUF/XCjfSLi7NcS/OmqaqCvq0o8gvlZ4zX3I34mLgDshbnS8icXW9c0OcJOeOyfc0lFfEUOjdTymKB+ufUi2rCYx58+njIFFXrs8szuNKAcoTCR2WJCe2eCEhb08VoyHyh/g1byGUxgrNP0+5t26pCTBcNN8yeLwqLR7qM4eyX6ha8v7vpo8gMYuaNhGWONg1xKhmUnUPyD5CmqWdeV7MDAInrlzv+sqh0gxB5F+HRycSAfhSyMNfF+fKzfQ5tQ+iVzguyLm8Dj12e3e5BYPAyMhnPpBpRvDZyBx/SH14GkXMqdFAM3PaGn4J6NpEx/tmCdPW+xCAQC1aTJTA0JOHy3++GT4dPEi7dPLA+kd7jQxEgauamDL07yAVi4qQ3qb5pYSblubS6+p3t8a0Pa75LsTI1M5WNv7a75wuWhXP/2BzkLVQ37NyNlz+IOaxPwZjqeKUth8UnSiiufF0nWKQt6fB4DHS7nBtNAEDCid5+pNIsvDyHg/dh22gq8hLXFRo62JOvmaF1akhVI4Pevs1o4+a51WU6Wfou4r0qLeVXYgNbfbFqxIOos5c7iPKOa160kMVimH9juZaYEpM3Ye5Qm4Gs3paA6DRjwqmWb58wFpHQ5u//TwmjVxxj7S9GLltPVUyiOmV6QXdIlIO9R4ppZWzHS8y6BvIb1a2ky++lxTMC8Oq62xmevzTpUMm0CEocYOHjaiKx0O69gdH4tTQTaRMmFPJQBmYGHMTMu7B49oYJoQou2oyXsAkGEk5TPD2YpE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5030.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(8936002)(4326008)(6666004)(5660300002)(8676002)(66556008)(66476007)(66946007)(508600001)(44832011)(316002)(52116002)(6512007)(6506007)(38350700002)(966005)(6486002)(107886003)(86362001)(1076003)(186003)(26005)(2616005)(36756003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iTATJ+Xbo7QxsvCf7AdPyfOFzTDY0cqosiHaoOBybsKug/do8mRlvSDOJBej?=
 =?us-ascii?Q?v4q4nAGXXZayvqFyZoROqFAiJPTweA4bF37/O1mJbazwPJWcuTiNR0AER48d?=
 =?us-ascii?Q?4Aty2WJ59Us0/OwxBj1TpXI1GFnW57ls5ZK7bdMGNGi4wmLSYYXF7eBtaRkr?=
 =?us-ascii?Q?ke5xzgvQosBdkiXzYgT4hKgeRLBT6xkP3mNQrR+XhKLqkoIFJiDeBq8sPxVb?=
 =?us-ascii?Q?9Tbz3q56R7D6OAVH6p5HFyV4w9mBoEV0K48Fv+sh+MtQKr/Z9n4ltP+FK34B?=
 =?us-ascii?Q?WSj7HSR/AVGw0u3lwkSZ1FSDu4YcI38MINJy4KjtlFL3d1Vtm6O58ldXg7kd?=
 =?us-ascii?Q?XDVcJLjizVfjy5EsTUC854AkewY8up+OyQdit9CBjCpDorsAnBSneaQbGOAY?=
 =?us-ascii?Q?qaG0/qHLN9tfyGSz3N5IwVRaDT4bRm94PB4b5L1H2ahuZpFrL1NqHBi8qNq7?=
 =?us-ascii?Q?bN8bHrrdOPIeXYO/VR0Ze2+2wIlriOkzw1zZZkDn3vGAzXQyr3FKtIRhMkwi?=
 =?us-ascii?Q?Aj+f+8GaxkKkaRYw0fUoWPjeaWllGrj34a0+FQOrFomUYD6m5lHCcaF9HWs8?=
 =?us-ascii?Q?flgq3sCZ2ym4MUlvtxPiZARX7D2dH0CxbBvXv8k12BA1dpA/bpcYuu3xPVNQ?=
 =?us-ascii?Q?70E5BPe9VeT/15kKw/492/5U9SDTyBtjetqXOpp1atem5YP4umi+JPPPP4ma?=
 =?us-ascii?Q?Y5GPwF9PmuGuJZbwpa7DolTCjbxoq5ZIWbVcPbv0lMzU8lt56RtikDjgWz6E?=
 =?us-ascii?Q?keNOvdZus7NRXjM6IHULmlp1I+s20HNxHSNgQTdWlFQs29hgBQ8+TKhNOWI/?=
 =?us-ascii?Q?3zFkDqwD21bRefox0fJZEsVMugQ5YX4ohU4CCjZLmUtL/VgHH7kthysoT8k+?=
 =?us-ascii?Q?X7QcusTEJqXj23dIYG9jUol3ib2mYucZtiuAYJv79Tcdx8B4p/X/pSAU33Ek?=
 =?us-ascii?Q?1AH845cWjeJygjqzyr6Hy+ycsGUcCek1R8+ibaUUPv+OiKFsgIeyzvzWaPe9?=
 =?us-ascii?Q?aYEV++fehhtR00HmYMJ13aHvSwmcK/GdEMXfiSyId0gdtnJnfikFEl4p4iNx?=
 =?us-ascii?Q?YQqWS60D4ihTl7UegNldMzRUqAa77ZrI3eCDMCE8KpQxaUEaH09BhBGUED8j?=
 =?us-ascii?Q?izvpWb3siUEnR9DhlW6G5kmMy5dAWNSr+Ov2W2zlec8pmjE02QBJaVsscRLE?=
 =?us-ascii?Q?PsUiT/UKr8a92JXj3z2d+P9w1iltOYmsA3cFkqmEcydLjUX6HmBmSTkR7qKB?=
 =?us-ascii?Q?hvAExwflWglCZkglGxAWMPAE6CyTun38Qy5cBKk+FQHTQdl9tqVrrlTPw2mM?=
 =?us-ascii?Q?N6K7rpLw7apxiaKWP/5aRu56TMXeyhBjpj3+WWq/4vWLjAVTWz1d7ojecDDF?=
 =?us-ascii?Q?HZveOuC2KettzqDT7LOyMtQhubeJwsrmIz3QsMZewtBDoBZhBV3AhUxvJdr2?=
 =?us-ascii?Q?wnniBdL9gb6bT/+PmfwCD4+KXUkVhYczyh/1rqEnPY12HoeKhQ8FPOSuoJp+?=
 =?us-ascii?Q?66iKeu5BINguqxuTu/Fr+GoWWbbsS/7s9D8CIvCkaCYv9aKVyLcw9DNVKfwu?=
 =?us-ascii?Q?fLPYw+UU2HYsnx3a2e3xw8iHWp+Jw09l4oSSgXCF8jE8kyXtVmpiKrnUNf1z?=
 =?us-ascii?Q?PgRPDP56aLMQ0zEsp+bzptc=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94f1bed4-cd29-4751-6b14-08da0352828a
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5030.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 11:30:14.0533
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D+J3qDvK1v8SEJiHXtH7eoqvK8dj9j9ntTB9K+OAKzXPyeSHw1eoK4fYZF5qHnyp1cvSgq+bIghW2U4d7gW8PQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1430
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10282 signatures=692556
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 phishscore=0 bulkscore=0 adultscore=0 malwarescore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203110055
X-Proofpoint-GUID: szE5niXkZZ3y3LaEGNjWf7zyVr1iH3k-
X-Proofpoint-ORIG-GUID: szE5niXkZZ3y3LaEGNjWf7zyVr1iH3k-
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

commit fbd5969d1ff2598143d6a6fbc9491a9e40ab9b82 upstream.

... so that they get reused when needed.

No functional changes.

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/20200604104150.2056-1-bp@alien8.de
Signed-off-by: Liam Merwick <liam.merwick@oracle.com>
---
 arch/x86/include/asm/cpufeatures.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index d912457f56a7..c934eb807f23 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -96,6 +96,7 @@
 #define X86_FEATURE_SYSCALL32		( 3*32+14) /* "" syscall in IA32 userspace */
 #define X86_FEATURE_SYSENTER32		( 3*32+15) /* "" sysenter in IA32 userspace */
 #define X86_FEATURE_REP_GOOD		( 3*32+16) /* REP microcode works well */
+/* free					( 3*32+17) */
 #define X86_FEATURE_LFENCE_RDTSC	( 3*32+18) /* "" LFENCE synchronizes RDTSC */
 #define X86_FEATURE_ACC_POWER		( 3*32+19) /* AMD Accumulated Power Mechanism */
 #define X86_FEATURE_NOPL		( 3*32+20) /* The NOPL (0F 1F) instructions */
@@ -107,6 +108,7 @@
 #define X86_FEATURE_EXTD_APICID		( 3*32+26) /* Extended APICID (8 bits) */
 #define X86_FEATURE_AMD_DCM		( 3*32+27) /* AMD multi-node processor */
 #define X86_FEATURE_APERFMPERF		( 3*32+28) /* P-State hardware coordination feedback capability (APERF/MPERF MSRs) */
+/* free					( 3*32+29) */
 #define X86_FEATURE_NONSTOP_TSC_S3	( 3*32+30) /* TSC doesn't stop in S3 state */
 #define X86_FEATURE_TSC_KNOWN_FREQ	( 3*32+31) /* TSC has known frequency */
 
-- 
2.27.0

