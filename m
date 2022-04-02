Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B72B4F007B
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 12:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238093AbiDBK2K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 06:28:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235885AbiDBK2J (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 06:28:09 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F5B5541A4;
        Sat,  2 Apr 2022 03:26:18 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2322rwHS018854;
        Sat, 2 Apr 2022 10:26:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=wfcmTsdZhhtnKBdbuGCK01uqUkxZiLAcX1OmoGlHkqo=;
 b=SakPki/mvNd913d1RFVsb97xgjtCTLo4EvfOKt7hfYRVrU8Ax8ujpXHug/NMIKXFnN2x
 LKQyMkv1uItDdjOOlLfmOScn7fWo2rZlBb3z2i7GpzeaXfeZxNW/nN0SYjfmDN8yVsdv
 emgMO7A1MF4ZCgodAJyXHdIkuUklk7GPKf8zazEiN3pRq6SlHYgyqxT9wmsNh3vb5GTG
 g21KoW67F/CKYu4zMeinEQrdajNNuL8+1Y6rZCKnfd/jqvcL3kf0fYGmx9Ggsc0B0GKX
 +z8e6PWHTQQRFwBvlLQnrhwYuWlAtq5mOagMGnbpvPIHEDKDhAwbn155N4IwdjnxyQ+G Bg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6e3sgay5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 02 Apr 2022 10:26:14 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 232AMC9M024636;
        Sat, 2 Apr 2022 10:26:13 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2041.outbound.protection.outlook.com [104.47.51.41])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f6cx0xc86-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 02 Apr 2022 10:26:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=elczaA8mXWJ9/D2LFr6VEz6kFsL5aqU41TOBQOpszCnEhZvpLcNT/dW6S4MNUouelU8hbv1ZQf5IdSWzC7zSBZlSCRCDZSQoISCypJjDzlmvaJrBDfM/f0D/cRqNF6MeMx5sGmclevNwVcL8URq2LjOl2DCw3WcD1VOpZzKUhD668R5NlNL6uL2KIlEDRY1aK+0Rs8KndRfDzGmavhPl1UJmcZ+aQHSlnPdY5h6Ww/t9O3dtWLrnYWHUtqQc3cPOZi6Rw8Vq0EEIDp/4+m57fi2gTvC0Lt1LQqW3bhBsN01AvYs0WZyIyUB+hWOvJ/k1wkG+kw5l6pbMvsDgElSdmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wfcmTsdZhhtnKBdbuGCK01uqUkxZiLAcX1OmoGlHkqo=;
 b=eece0IapB95fxQk3khPSH8r0ELMltbSPovPUkn7l58w6K3f9gjAY4Ut7G6cmCMFi9F4TyTpjXQk529Nm0A3KXcju1JPsXxa6Ou6wBqWR7mMRLPZC7V3Q+38S32ioLut/m33FvFSUhhgCu8vhTDe0p9LCxZdih4dqRMJx8LKgnzMvVgKSK26BlxEbTel/NhDzgmCyI2O+P6sCWNNKeRzgqbM1gnYk1tbgDYdLZboJht1GcKbHu5L1ROSPGq/73jGJuf0G4OVRoS54JOozIjlHzD+j10z6eH2Ac2W3YTt1R5Wzdcpq3yXd8vUGzuKksVVd25lUKsYjLVC/wGatfVstXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wfcmTsdZhhtnKBdbuGCK01uqUkxZiLAcX1OmoGlHkqo=;
 b=LNs7O5qCxylsdu4KHxsxoQ3KScPYws3pZBHXXx+iE68ScPCLMOl7mWjcN5pG057qck36qGTKYf/qKw+ko596KK4T0jDdo7o+mFCWrdfX52YPkydpdSsDQY936UW4vSFf4ey71ZdP/ZJ4P+mhrOY47uUAALALS/1p32LUxpXZzhI=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by DM6PR10MB3049.namprd10.prod.outlook.com (2603:10b6:5:6f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.19; Sat, 2 Apr
 2022 10:26:11 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::54da:72:aa08:9a8e]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::54da:72:aa08:9a8e%6]) with mapi id 15.20.5123.016; Sat, 2 Apr 2022
 10:26:11 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 01/17 stable-5.15.y] powerpc/kvm: Fix kvm_use_magic_page
Date:   Sat,  2 Apr 2022 18:25:38 +0800
Message-Id: <77e3826f2e76b80da366e64395af36813d85ec36.1648636044.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1648636044.git.anand.jain@oracle.com>
References: <cover.1648636044.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0174.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::30) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 59abeab6-30d0-4b2e-7caf-08da1493356d
X-MS-TrafficTypeDiagnostic: DM6PR10MB3049:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3049F4F8E2EA4DDF55676DB7E5E39@DM6PR10MB3049.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6NWx/OlVOH7NNddh/YMgAeOCUKbNmZTwEjC4FH8ktY7yxNTu2Rfsl5Xj5a+AqHjROMSd1vz2iRCRSMiTdtTPlI1sIk0UDtpSs9nymMUzfdCo6Q7ew+k9bYgkyZ5l0+MJpi/db48RfqZSHJV1hcm0JdkKur4XKiTBGLQYytrXzz2o4MEDBcPSmn8N8O1ekrJaAR6Ie8jpPTUWUJU2He6MPmXID1fpmkCa/CLwafKxotO5HiSOtR+6d9ZSCga4imz3L9IRGH9V50ctla0Nimzmsd3UToAv4DVPyZg5Rv67zJNqymergD9tFLJl6YGKie7STWyt8b58/311eDPCH3SsMPee7gxa51evT4yBJ6oKft+lrVrGtA7X1WXpH8LlF0hEkgZBDRC7g5DmmZX7MhHlI7CLQtXwZpXerdULQXhw1cRkTMfHDLrQighJ2UMfahdcmeKYu/4pRQx7XgrqBqKO30JsTr2M3F3X95qrUrcjtr7+tNHEZuwkQOMbKrb8eFy6LJdPGdkQ15wiEtyQ/VD/6bhUUoFhkfkjKxYQuF5DVaKXjH0s51i566rVSUbEXP7GzcPw+LFlhttVpyVEqI6LJZxU8J3lkHPlFXQvG3tvpsrBbrRy4xRKRx+ofVnWOsQ3wZRpexJ6JbbB4WCiYo5/IQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(44832011)(26005)(6486002)(66476007)(54906003)(6506007)(36756003)(6512007)(86362001)(5660300002)(66946007)(107886003)(66556008)(8676002)(2906002)(6916009)(2616005)(186003)(6666004)(4326008)(38100700002)(8936002)(316002)(508600001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eFr+oc3xCosu9NEMN5UqBsvTmAkn70psUQVQ0q4t8X7gSh1cpsE9kSjM2IQ/?=
 =?us-ascii?Q?s8y13h6OsbuEQtNVonrGA8F3RnB08Jxd8PvOr4dvkGQWoMhY2j0y5GN1QZeU?=
 =?us-ascii?Q?2JlzRiq22tXU/dOEMQ91ysqjyyY6vgBJVeX2GX+q7oM7CNEpdmp76fY0JItx?=
 =?us-ascii?Q?EoXdJIT5Coz9aYRDvJnGR/n/jFvxKmC3ibq4UChojXqhFbr2ENTQmLdhqxUl?=
 =?us-ascii?Q?kOTmZ33IcbBB3R5jihNlfUIAY5nlenobSjFTJZmF8HE+PcxcitKdp1ct0a8S?=
 =?us-ascii?Q?DD3z/dOE+N8qjhIgmW6N9ZmymV3/QtgD9c1ueyYsqp1G7s3+W9kXm0JCtBJx?=
 =?us-ascii?Q?Bn0EW3LrtUZ/cEL10N7pmaUUL2//o3x6UA2AK4seUfIf/IaUQQyL6bu1aqUy?=
 =?us-ascii?Q?XLdSIjlwnF3uSyF/aEn1O1QLmpBilSLWzfa2uodCVH1f/mynrhKAdVzCjmtn?=
 =?us-ascii?Q?SZ2NbwpjO1oo1bP0tZf54AmM0WyekXt8446+ZXsznK+OaUjPLv5+a/O3qs7f?=
 =?us-ascii?Q?vh0hcVT9/tA9UaRpniN7MTzHBqLcbWxtnv6CQxs2vHeAAu6VhPTG44lgrnWi?=
 =?us-ascii?Q?MX4q44IaBJX9t7RVmpPK/Xy2yQ4rKCFaG+jk5sMSucmW1k2WYTdDaKNmFHqj?=
 =?us-ascii?Q?Prp3DKsCVvvVWqmZ+PqqVpzV4zjP+0C0qT0LQl8euRFvLB6vFdn142g7/MKV?=
 =?us-ascii?Q?4o9nCCgHlORlrCkIR0P3AsePBV8CK7FGkFJNtSEYuQ7a+UBsO0GGPfTuNo28?=
 =?us-ascii?Q?0j5Ay/LgVNevcoJAblAMXFby48pd0t3yvtg7aNNf5UJG6pyfXZ9BDR2zKF7d?=
 =?us-ascii?Q?MzFx98+m2fxZuNEWDnTo29GVL1q0Fpaw4i32M3VEooTMWo7GwQf+LItqltK8?=
 =?us-ascii?Q?ELhZpygethsg2aoYfOGeRZll7FrIvDkoWPCXy6PKlJ2/ptnE+PmsnSMmeIYt?=
 =?us-ascii?Q?CaHleRDMnupzmKhhQ5/0XDOeAd5vBQdSlAa/JdhRYvb6O+U6Y+hCMV8rJwcd?=
 =?us-ascii?Q?Zhbge7YrYwMQpn0bR3iV+4JAFftQLs0wAOQnCuyDAo4nN+cX2pyyKtczBxD0?=
 =?us-ascii?Q?ZUjDmKoLwlyWJzN9ZkU3Aap5vznx+UtBTsSx9+vN/LNgXlLAkeXuAf2sjajT?=
 =?us-ascii?Q?At53+6nC7kC1iGc04kXQyb/4S2FGUOexlDs50tp2Z0vqKO17eU0+vLp/oLvo?=
 =?us-ascii?Q?3b6PzTb8oAr+aM+ROq4X6uzUcaBUbygvD1o83BC6vtQqqURHV2WR7afJ8x6T?=
 =?us-ascii?Q?t3hcGCXiCDo6g4SgQHzitVzjxm+eqrohohrIx8f17xprCP2nH7piuktZveI4?=
 =?us-ascii?Q?V1BKiiY2Cdi+Y/dspCCG1Hdlq+RB0gmy5AhsgzrBXTYVw8Km3Vu2aJUlaBCu?=
 =?us-ascii?Q?WILA3u0jxhqHZoAmJHwUyvS04w3R9mpknV9CdYKfy5GNPQxNp4YLw+BnH2/p?=
 =?us-ascii?Q?R8iOuNY9ajJxVK23HCBHRKk5Ksdze9B5/nzLbkimOArg8z1i8KRuD3TnTdsq?=
 =?us-ascii?Q?1YyxgFivdz4jwcyLqWnMj+rUA1XR3j5LxpS67yp7uVO5yRm8qBgzkIijlrO4?=
 =?us-ascii?Q?9vc+ivY21OVi/2YxX5woRg/ZiwCiI+GB0A/G1OMYobI7imqKen00Bznk1tJj?=
 =?us-ascii?Q?M2sQMtp8mihlNlWiGGSdwHqynEFFvAxsUAV2cGXzqZePvojcMTZjwFd8UTTm?=
 =?us-ascii?Q?jk8duFIjKY6DaJfvmFWBaKUC1SZJ62qxLSqDCk03OC8wtJLn4L14lcPHQII/?=
 =?us-ascii?Q?UuC8k79Q/A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59abeab6-30d0-4b2e-7caf-08da1493356d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2022 10:26:11.6399
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nfqHE+oGq1LdWPPP7zFgRg+o3GeGLoxm5k4Qr1XTlTncCqnqe9ixl+R+5qEaaq8xZSms45XoR/wfTbBcj8AKKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3049
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-02_03:2022-03-30,2022-04-02 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 mlxscore=0
 bulkscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204020064
X-Proofpoint-ORIG-GUID: ButkwtZEGU9eqB5WuVspdL0cUzw5AEvF
X-Proofpoint-GUID: ButkwtZEGU9eqB5WuVspdL0cUzw5AEvF
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

commit 0c8eb2884a42d992c7726539328b7d3568f22143 upstream

When switching from __get_user to fault_in_pages_readable, commit
9f9eae5ce717 broke kvm_use_magic_page: like __get_user,
fault_in_pages_readable returns 0 on success.

Fixes: 9f9eae5ce717 ("powerpc/kvm: Prefer fault_in_pages_readable function")
Cc: stable@vger.kernel.org # v4.18+
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 arch/powerpc/kernel/kvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/kvm.c b/arch/powerpc/kernel/kvm.c
index 617eba82531c..d89cf802d9aa 100644
--- a/arch/powerpc/kernel/kvm.c
+++ b/arch/powerpc/kernel/kvm.c
@@ -669,7 +669,7 @@ static void __init kvm_use_magic_page(void)
 	on_each_cpu(kvm_map_magic_page, &features, 1);
 
 	/* Quick self-test to see if the mapping works */
-	if (!fault_in_pages_readable((const char *)KVM_MAGIC_PAGE, sizeof(u32))) {
+	if (fault_in_pages_readable((const char *)KVM_MAGIC_PAGE, sizeof(u32))) {
 		kvm_patching_worked = false;
 		return;
 	}
-- 
2.33.1

