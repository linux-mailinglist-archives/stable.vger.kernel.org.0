Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3A5757A4CA
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 19:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236287AbiGSRRh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 13:17:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbiGSRRg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 13:17:36 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2CE945F7A;
        Tue, 19 Jul 2022 10:17:35 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26JH9epj030726;
        Tue, 19 Jul 2022 17:17:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=QmGkqqBt3uQYRmCNrXJRFT/xrFUl/HCUPEteEfFnsOg=;
 b=Y5Scp6XrYVrS2U5FkeeKd4NNq6xvFsXFN46bUtEC8qZRx4I2Y+DJvJIhQEusBrNz3U0D
 2C0KBzfXAZuCDnl0QiQ3Q8BwDX5St+bDGFWq/3gBFwE5EfC3mjx9jSCwI+jAq1yg/uE5
 FSZyZtGQD/10c1E9DX6KSiRSECoYQwlUnHlq/ilhw4RjJrhUR5BgizQbe+gpVp+Z+SPC
 1pHNSdEN3E1azzk7FJKeJvOjJ8Sw6NJOfLMEKDq1KU0lOIYQ2DzSc4fnYwDmPrTJGHQj
 MbnoyR6koiepgE+bbRNEcyc2IlFzlgittFrE+U26K1ak2WZtLIhDEFAa/7dkqwSWypd2 Lg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hbkrc73aa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jul 2022 17:17:23 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26JGVk5H016400;
        Tue, 19 Jul 2022 17:17:22 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hc1emrmsr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jul 2022 17:17:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L2Qjc94VvBSP4fsTwaEBYzgrTeLcrGClrdL4vXgUBOX+4Gqx1uAckBMCv6+k54eUQA10KyU0B7oJCHWGX8OuhfEhTNHqPWJEBxGjf0ZeoUSk4ofFnyUMQi5mPesD3pGvmCInye/Hi7wgkYn/+lwzX3RXM3i3AOryB4qW8nHPnih8W+CdyfXbEA4Ks+Is+8+ce5oaZYIQRMUccuyR9yxzmEJ4caATMpEK9yXMvGt63lSK2s47If9LjMueL2QF1L7PL5ye2JICPSWrffSTmYGw2XRJeiQhckdJyh4zMKrACpiLY0/JwnFx4CCKz+gZnGuwXi2lUNgifAlo5cRRTCLGng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QmGkqqBt3uQYRmCNrXJRFT/xrFUl/HCUPEteEfFnsOg=;
 b=SwjhmcbB85+MWl6qkR0+Cp1Eh0FSgDGO7M9mLN98GEfh1MWthxHLc6+vvpo9AFpyOlafdiqS792Tn+r48hztnTfIqPBKxkSinRLTgIAeDCeD+PkQCEARa4k9wWTnOSyzGvBMpNYGu3W/4TNPAvrJ5ns2sYTpb4Ywula0bdaAUJhf7ZtoIeM2nFvueEF4MHKSb1EgddfKbCPZBkr8yWY0ykUvL63tsvslO0cKb0LWbD0bNuoVYRTBRSkY33m5TcUaQGleY960+UBioEPA4nL0vTe85M/zj+FRqeZy4DhBYIb9yOkqGJQsuf2+dAAZebA5BIlPlVKk1GVU74J9594mIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QmGkqqBt3uQYRmCNrXJRFT/xrFUl/HCUPEteEfFnsOg=;
 b=xQoFrL+LO9VYqSuV86beurXGy2KYaYH0Ly3YROAcNyQiNt6oQnRapOyzz0CrLy1Qsp5rvAopY3Dk8gAFGr+Lj/Bfszb0sHhMrX1jHABmfcTu/ljxRGNC/I7ZbXgbPq1znh1T7eRp7391KJ2FX8nc75UKNMd4GuEN76hUyihf44E=
Received: from CH2PR10MB4150.namprd10.prod.outlook.com (2603:10b6:610:ac::13)
 by BY5PR10MB3746.namprd10.prod.outlook.com (2603:10b6:a03:1b5::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Tue, 19 Jul
 2022 17:17:20 +0000
Received: from CH2PR10MB4150.namprd10.prod.outlook.com
 ([fe80::21ce:9dc9:abc2:dd08]) by CH2PR10MB4150.namprd10.prod.outlook.com
 ([fe80::21ce:9dc9:abc2:dd08%5]) with mapi id 15.20.5438.023; Tue, 19 Jul 2022
 17:17:20 +0000
From:   Eric Snowberg <eric.snowberg@oracle.com>
To:     linux-integrity@vger.kernel.org
Cc:     zohar@linux.ibm.com, dmitry.kasatkin@gmail.com, jmorris@namei.org,
        serge@hallyn.com, matthewgarrett@google.com,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        eric.snowberg@oracle.com
Subject: [PATCH] lockdown: Fix kexec lockdown bypass with ima policy
Date:   Tue, 19 Jul 2022 13:16:47 -0400
Message-Id: <20220719171647.3574253-1-eric.snowberg@oracle.com>
X-Mailer: git-send-email 2.27.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA0PR13CA0013.namprd13.prod.outlook.com
 (2603:10b6:806:130::18) To CH2PR10MB4150.namprd10.prod.outlook.com
 (2603:10b6:610:ac::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8381c0bf-9e34-4668-5680-08da69aa89a0
X-MS-TrafficTypeDiagnostic: BY5PR10MB3746:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +CC9lvqs2SzcidkwB08QMHgYj4eGLIfUxXi6mCqiiD5IiLszFPCWKlafTZL9iX0nYxW9nFIwGhUMRqyH/z6T0D9A8yW3+XRK0oWyjBnp/YEgFpX3Z98YYx+b050PVXBRw8ocuBErudCe6AunFffcOrh9oW60OIBWVI7IenEqhxLpDWUGLmNJyT0X7RtyKXLJm+zeqshg2dXxY9VT8SbLGVz+tVbso+8baHWR19lXNF1x1R7mAzQVBu+D2CCAvkN5GN57RNPmCos/rs0VYNCOhg/779UwqF6YNOxcQTBFG6XCurFFs4HUS5YVMeLo3T26qLESDKQVXNpUj1sZqHdk34ACHac0qIVTlp6JYJ8htlMoSbcUvcjp9snt/GBo+3+/epBXllwYdK4r6o8Fu6G4d7/CiHsOo2isSTX/lz1IoM0lXIQVUlNW+TLMjk7bY2NNmwqryF1Y6+awFEQUZN5WACBdAJTF7btf2HsXosgDc4vCLDxjnmWAKjR/yQFjTaELh1hnee85oS8mKpCbW8AnXx14SsIH2DJVtap0zD2OBKgtuUxVvJdp/wY/WIZEJ8R2NgR0dx/9L4P9vCz3Kk0K9V8fvyMx74jTCeodmxUfYr2pJvtbpM3ONl9J60gBMzT5L/kQGUATrsSnHFBnxJYfPKZ7MHbrzVrxYCN0IzPC9962Q4xq57t44L7VJQYb3ArMQDtLKnkG+untkQheuLhXwcj9pp+0i3u4sxGgqfw3Fh744i1IKF5R+Eq2xJ1NfjHba8v5Tr/49VylYMGwc7/dUC9MxC6lvCIShhEk2Jk3d40=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4150.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(376002)(366004)(396003)(39860400002)(346002)(44832011)(8676002)(4326008)(66946007)(83380400001)(38350700002)(5660300002)(1076003)(186003)(8936002)(38100700002)(107886003)(36756003)(2906002)(66476007)(2616005)(66556008)(52116002)(6916009)(6666004)(478600001)(316002)(6506007)(26005)(6512007)(41300700001)(6486002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hX6M6Nqr0NgZHJvuK68hPnVe8lpHlFUPJ6WBhwSSuuvkzk5S6kSSoe4j3Lrb?=
 =?us-ascii?Q?m/v5P5T3skmjP9eKh/3OO9oFtA8sJL6QP8Mk99ljLW6dXGD2A8Ru5bQ2LQdU?=
 =?us-ascii?Q?Yl4uShhiU9H5bbuvVw4F721vZny3wWAhN5MOlhX6m5ukxQLVYhwkGJkuOUob?=
 =?us-ascii?Q?nudU3lu4D78PsKL4yE1n5YGohzAx1Gst9JQk/ru+AUTlvQJ6+SBNRUlyx1ml?=
 =?us-ascii?Q?VHGJKk8iQ2tXki/KQSE3pbxOKlmrFuKDxWx6D+SWAZxHOulFTUyclAbUmGHI?=
 =?us-ascii?Q?chPUfv/Lgxqk/gq9G0iR7JBoADxmRQn18H/QTV9mICZpPKTTDvlNQHrPKosa?=
 =?us-ascii?Q?ffqtjYk0lGKIgXnQNXR8RQlb5jTAG8fEDdCzgrGVrmMqnFiqigQx+XS5t75t?=
 =?us-ascii?Q?wAYP92xngPV/bPfsj3rULuxIKnW7L+ZFryaGwtUSkss1WwB7Yx4izG/XognG?=
 =?us-ascii?Q?wfQ6GcG2ok1Yc71lQA0Z5Mom5ymaKTT84zYGzcVkEkCMoWncXs4l1WPbLb8Y?=
 =?us-ascii?Q?Ri+cne2IEjCfX3ilO81zCZm/HQUVz3PhuQ1A9KuTH2S5ETn6VwbQ4hhOZ8EG?=
 =?us-ascii?Q?SHtLJIQEV0CRX9dkXbL6I8GUiHVAucpFDus9VvECUWBFyBdnzcxFRapHO40M?=
 =?us-ascii?Q?yzuoyfvxlb+aufUflzyI7Z/lBSI/A7Dc7ggfRSh7oYdJUm5+iTYbnkXkBnml?=
 =?us-ascii?Q?l7HKWhGzOIqFG5opXAN68PHNpzojWZF+NKK01zTolYAAPl2w5qMuPyTHcj/R?=
 =?us-ascii?Q?diepn+YplXurrlyb3jRrqJfaU467XG//L/rQVYPCZWE4jIsfHPQZqCSrhyWG?=
 =?us-ascii?Q?U5wKf4Ndy2g//+fezApxQTiaerSHBGAH3Mo5lmITzDcSgksyNp1AxuXnNo0w?=
 =?us-ascii?Q?ldjFHBsxjQK7khtJGMIA7fmEG9IJx/r5WCKjJBuvb7qBQCjBrMTQCPSapZIx?=
 =?us-ascii?Q?EXD0i+btsilDXwy73KcevWjYlLxfYLd0hUo4K+2UvZ17KGgEqR+tlRhqt/6d?=
 =?us-ascii?Q?sRBChrOTBNJJvpHL/mZnhi1rgbpr8Zj5XT17qx+SqBRuy+FZBv5i7YDPDQgO?=
 =?us-ascii?Q?rwK/fLztxCGbt2uu8DajmF3Ek2ODzbS9itW76rujIm1hPZii94vD9rnC1Lin?=
 =?us-ascii?Q?TP/adExxexSyBkwmola+TEcO0cql9RLVO2L3LawdNZEwPuLqYPN/1+z933Xz?=
 =?us-ascii?Q?1Cjh+lEvIAL1g2LXAoZ5iA+N3KBkvZk4wLMj5+Qek37W6iH9lKbq3KMAceXa?=
 =?us-ascii?Q?seLNRgaGNiDe0MJtl/Jn+SkTQcqHzhJbouooHRFEU0NDaRbJXfsg6R5b3GV8?=
 =?us-ascii?Q?lTVVUFnwgnO1sMZDN9Fx3x+tlsvupI8C1R18CUwah173omhp70VdfHQDGGo8?=
 =?us-ascii?Q?IAEZ/w+DXr7fy//Q5BXubv6Ql5f+6WZyY3QnoLWNWKXzGcCSti3HksKXyVs0?=
 =?us-ascii?Q?wrtE8xdS30MWeBJzRVXBIdaMbjD8DXipqBVJVUINXpVPouucHYhTW/Zka+pq?=
 =?us-ascii?Q?Dp9Rg9Ji7y8SipJgmmaLtfwPY1ZFOSowppS5OBxRCAfQIpWIJ60d/933eVG7?=
 =?us-ascii?Q?lVn8Wpdwg1avS6R1srBXedp3cOpssxpFj7b0RCHu?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8381c0bf-9e34-4668-5680-08da69aa89a0
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4150.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2022 17:17:20.1939
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bc+3Zxq6ldwhtnHxeA7gUQF2U/v0tYpwcnzjK1s4ZYLqkGQ8IlaP8IcvFg78wrlA82b+G12z+wWpsUUvXy23vyiClH0wtXvUqm2w1sr1BhA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3746
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-19_05,2022-07-19_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 adultscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207190073
X-Proofpoint-GUID: vSSKzuxGqXPGkv_Wl-g7wpPnlOwXsu_j
X-Proofpoint-ORIG-GUID: vSSKzuxGqXPGkv_Wl-g7wpPnlOwXsu_j
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The lockdown LSM is primarily used in conjunction with UEFI Secure Boot.
This LSM may also be used on machines without UEFI.  It can also be enabled
when UEFI Secure Boot is disabled. One of lockdown's features is to prevent
kexec from loading untrusted kernels. Lockdown can be enabled through a
bootparam or after the kernel has booted through securityfs.

If IMA appraisal is used with the "ima_appraise=log" boot param,
lockdown can be defeated with kexec on any machine when Secure Boot is
disabled or unavailable. IMA prevents setting "ima_appraise=log"
from the boot param when Secure Boot is enabled, but this does not cover
cases where lockdown is used without Secure Boot.

To defeat lockdown, boot without Secure Boot and add ima_appraise=log
to the kernel command line; then:

$ echo "integrity" > /sys/kernel/security/lockdown
$ echo "appraise func=KEXEC_KERNEL_CHECK appraise_type=imasig" > \
  /sys/kernel/security/ima/policy
$ kexec -ls unsigned-kernel

Add a call to verify ima appraisal is set to "enforce" whenever lockdown
is enabled. This fixes CVE-2022-21505.

Fixes: 29d3c1c8dfe7 ("kexec: Allow kexec_file() with appropriate IMA policy when locked down")
Signed-off-by: Eric Snowberg <eric.snowberg@oracle.com>
Acked-by: Mimi Zohar <zohar@linux.ibm.com>
---
 security/integrity/ima/ima_policy.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 73917413365b..a8802b8da946 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -2247,6 +2247,10 @@ bool ima_appraise_signature(enum kernel_read_file_id id)
 	if (id >= READING_MAX_ID)
 		return false;
 
+	if (id == READING_KEXEC_IMAGE && !(ima_appraise & IMA_APPRAISE_ENFORCE)
+	    && security_locked_down(LOCKDOWN_KEXEC))
+		return false;
+
 	func = read_idmap[id] ?: FILE_CHECK;
 
 	rcu_read_lock();
-- 
2.27.0

