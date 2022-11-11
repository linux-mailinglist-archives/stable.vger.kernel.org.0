Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60448625245
	for <lists+stable@lfdr.de>; Fri, 11 Nov 2022 05:14:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231895AbiKKEOM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 23:14:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232130AbiKKEOB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 23:14:01 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9832F26E;
        Thu, 10 Nov 2022 20:14:00 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AB46hC2017033;
        Fri, 11 Nov 2022 04:13:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=n3khebjvuhCfzo+qs3rczek4d9IBIEdvKHX168s2lwc=;
 b=r/V2BD8NQhwjBMaaatO6E3J3XHVIIww4H2O+x1A0ZdwP6jJwsUWMlf82olHGLteorIyu
 G3jjg9nBbEb69Gpv5d4xpTg79M5DyNlDGGGvIEchJxaJmH/hOXErrzKURTK+qPduLnKS
 9z6ry4hLTO6+i09Z7zcVwdDqzXdArMG4KsVVbx1zRCMSTVPEc1I3MKJGBU1zn2avaR+3
 hKxRAktvG400L1G6DQAWne8DsKSIYR0leDd4+/tntm7+is+bBTUq7pObCYpB3Fg5oJHL
 3Fpyf4tH7ytdp4BSIOZ0OxAalxa8WvK2NHVVYcuw8KmzQMVXbXRnWJDp7BOdecXJemq+ mw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ksea2r23g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Nov 2022 04:13:53 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AB3NI9Q015034;
        Fri, 11 Nov 2022 04:11:04 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kpctg4cqw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Nov 2022 04:11:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N+RZkawFqMrJUiNMyGNNQqu0OS3y7M+qYCnfsXLd4ntbkImtDuOsy123BN36gF4nuZx1BkdotwKvvfLIelHYiXNVHIVRP/ItUz2XtSlBIra3hEQ0sGZWxQpJLxNP0r2fxa3uG9T/i5MzHewQJWGj30EAJvJmcropi4vHVVp6LkH6qmDjgrwncKU0A/JmNHVfz9UsDHwQK/9gL4cYMGmk1Js1YmV2hroGqDO2LMsK8Ej9fxYG3IUXW2pDPFMN8fF1sYbnZZmsxFRR/jJIu493z2qM9RjVAx+wVbvIx7nhVvklnZzYFYwnFlJIgZKMaEmnW1VNskpbZHsHRfUkLcbBow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n3khebjvuhCfzo+qs3rczek4d9IBIEdvKHX168s2lwc=;
 b=ehgNCQQjnQe/AYQe/FmynHAD8PfqpdWaGSVna8HMbJqux8VuOVMhWVcGvCtmLeqgTtIfBUbl7vPlheNtUHI28hTrkNDwByhAbPdEAkuDXp5e0lY3gsYwieCZvakUCDok5me6gp9fOuDkkZV9rR3nS0E2jWc7f+U6SvYbm4l4enHZ1vnjbl6mvg6oiBTNg8BkucVjMpfK0cpYNRHqoz50iXyEd7HnhwVkgAb77EfWeEGWtvzVmJNxFsFztnCEIYy2flctYgwGcMgaxlZzeHu4k1NbFA5WLFQ08b5mpbvULJNBHup35gtQwQ+bKeO83S01CxSM0R9VBMpVKCPX1Vfpsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n3khebjvuhCfzo+qs3rczek4d9IBIEdvKHX168s2lwc=;
 b=HZSdmqIIzUEJrZ9fl2F6VGdaDcHxbMwRHhs09In9vdpaaexfvA4qB91aDXaN+87QeUIgO0tk9HDZGKYxL9h3Rx0Ffrix3NW/wP/3vBoFRaUvtFtQu2JHH/ZpwZm91/dZ+ROr/+AQ2FRDIH/Ai80tP/sxlerG1LAOtYHXIYmzLN4=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by SA2PR10MB4730.namprd10.prod.outlook.com (2603:10b6:806:117::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25; Fri, 11 Nov
 2022 04:11:03 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::a671:8bae:5830:6fd]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::a671:8bae:5830:6fd%3]) with mapi id 15.20.5813.013; Fri, 11 Nov 2022
 04:11:03 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 5/6] xfs: preserve inode versioning across remounts
Date:   Fri, 11 Nov 2022 09:40:24 +0530
Message-Id: <20221111041025.87704-6-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221111041025.87704-1-chandan.babu@oracle.com>
References: <20221111041025.87704-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR0101CA0039.apcprd01.prod.exchangelabs.com
 (2603:1096:404:8000::25) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|SA2PR10MB4730:EE_
X-MS-Office365-Filtering-Correlation-Id: 71ec07aa-9e0e-43ab-310c-08dac39abf4c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yzt7M2ly182sNc2qKZbEzQXh7MBDzaIz3RuQ+Oni3cl4CN0B2ZDwIsVEsf6/1cbViVEHKHbRpBK6cQqMsOpBjVoji/BAK1X5HlAlZ25pQxrqDJVX6ctU+RW4DwWA450YrLKkoX7a5l6D0Y8l2vl7lrGR7Ogdjh3DiXxahggIUdnEga6oP2HmCzvw7ANZ9bsPeKVSFZiZvnf5hu4NomMCsjD4HTG1RYe+LO9AMxY/S9QCSG7CAnye9BC0QojvEbXaHELykD3stGE9hz/TPQjqv5Ar0RupvMDV2R89FthtwdDSgX+rRlknGSkaK4YMDp4WHt1cqkFMZrCCs5j/JPpz7s/c2fhgSS4oZXhGl1HXooOP8y0JOk46KJJpsRHwdKXAE47TEpJlQFGSrJrD8xJTeVEQWTO0EGev9VnxXVlRAthMgXXDGWcWW1BLbZqiQ+SD5ZcEkaNyK1Tu9+zpYJSvT4sOyP2iutd8d2mJ8gXUefGPrgxdRs5OGEPNm9iXpM9DQZ1ZvPBsLvgCApSPmD02Gne3AypMtYslBRQvpNZfCZWkS/v2dChS2pm6GIhPJaGq6+lQQnLM+sS8o00LpCHdTPQ5xMyCMdPGWd3k91OztO72r6FueVKxYuhpEK79KQMPjPbetygrxWNgwhpynrsRV2V1FgGWpupGx7WPe4Cdk+B+tFMjekF6b/azvlVnr2g5oZEXcjbZMCJkoISlZ/ELoA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(396003)(346002)(376002)(136003)(451199015)(36756003)(66556008)(6916009)(38100700002)(8936002)(66476007)(5660300002)(6506007)(66946007)(8676002)(316002)(2906002)(41300700001)(4326008)(6486002)(6666004)(86362001)(2616005)(186003)(6512007)(83380400001)(478600001)(26005)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XpNW1M2fXY/OXSnD9RXVWSkeQa38e1eajm9PJZ/8pDVamgd1quGyg8lZU1Ul?=
 =?us-ascii?Q?GI4ZvXoDljXVKeG9otrmPXaUCDSia7HmQ8eSDtMkGPg8DyVrTOP+zL/k8Uuz?=
 =?us-ascii?Q?KRfTpB4mpYZwGhjt5NOcvXgb2Ot0qr9LpD5zIKB9wMTUyYpt1KVdq2nebQSs?=
 =?us-ascii?Q?MlIwJqC/U5rGEcRPxP5jOZogIHtlRtyNF5ZGVxUcm7Rwh7w90IEjBIXZLMc6?=
 =?us-ascii?Q?1Z+RprTJvY+Ha6wxNJKNjBHMRRIVmwLGCx2usnuSgpqm5Et8TL16Vk8bfgVD?=
 =?us-ascii?Q?C85aC0afnf+axG7IEjkOY5Qfqxaw8Y4aedisukg1LoJoHQosbpMrvBGy+CEm?=
 =?us-ascii?Q?LhWYu6PBzqGkD/VhM8ZI8x34dxJs1kLCQrOvBGYSndRKeUpXEhajmhRJ1wZq?=
 =?us-ascii?Q?RavrKM/mqDDeX9VIX8ge2xd2jBoTZyFfGOMvmVh+Hj9mzs0LpPtKQYIS3mCD?=
 =?us-ascii?Q?nbOThlhUIwgnGMK6guZht8gTF104x/CZlc4qBIztaXijez9vtXcju4kOGLwd?=
 =?us-ascii?Q?mNFu6IBDE7co2bN4dlh9kzBmt/41aoB12So+kHRXwpOCc+dCdwr3Lydd4/QV?=
 =?us-ascii?Q?83h+IIYqwEVAkiKDWpxxl9J8OsDZ16JCS05/vEf4PjfMeWQNA19uupWI0aQU?=
 =?us-ascii?Q?TwFxQNKKIqb9o4PGV1p4POnc29hG63svVPJEJem4XlzFNQNYJLnRCup8e8iH?=
 =?us-ascii?Q?VxrfYk3zdipVcJgmLfMbPFpz7auRq8+lpyyAyfjVy//tNgTxz8yKu6Hm45qI?=
 =?us-ascii?Q?sMdmipAiNjnD3XFTM/I2hdV3auLeCWaDnJIbb4D6XDtAQ3bj88yiUShvKKBI?=
 =?us-ascii?Q?AWeaaof1boJ75eqKnNAPi6uVqvB2L+FQb5kRoZ5TOQh/NfMbEwSlAsST+/E6?=
 =?us-ascii?Q?+SsUuEvyMYWBpnrHxHpO/FnBMSqBpond6csEvT10qYzOX6/PMUUKkEjPQ2Zr?=
 =?us-ascii?Q?UKremQV4eOIg4kykNI5l9bIYGXVSxs9bZ5YOA0OyrEdjCiUVtmBYARNce3Uu?=
 =?us-ascii?Q?VjXyKZYQIIlknWfBx0EZwLXTU/nWl0SNj2tENH568BwOjl8PH/P6jgYYltzD?=
 =?us-ascii?Q?PGkOiYu68BxoR5n9Ldn5hiV1FeAL/vscgUdG/xIQlOnIISrNiQkp67R0EFMv?=
 =?us-ascii?Q?n1T+1q3bm1ydjMHSpj7mxYp/WX4vsuzK7kYZnnixM5giftOIigUxh4r/LgBe?=
 =?us-ascii?Q?wD3uIGFKw+tsAr51N4OA5hV9udcJIgaQAwfjLHXjsxzzunM4sHGz5ote8iLh?=
 =?us-ascii?Q?h0FAFuvNp2BF3b53CL6cdsCZW9PGoLVK+a6rs0/dEKnLiEl+gq0UlFJihNnJ?=
 =?us-ascii?Q?zwZpNDJS+lJ4H/bYa+8Y195vL/TT6sr5PpnwYte9JNlO6Zyhi8faSj4e6tSq?=
 =?us-ascii?Q?kE1trWcNV1KuTQTwF7AGd+J5WaOZJBBUfV9rtkG5Bjadn8H0eS617Fyw1LBa?=
 =?us-ascii?Q?rFSbq9WobVtn0Sc/j1jvTTuYX03a/9OKwUC/uNPph6SRWQ4VXsfDFfpQLRf4?=
 =?us-ascii?Q?1tdHMGStuIC3bgRORkdqail5Sxw93vCeV8rDZCisUW50hS42/PbqZ68x0ES6?=
 =?us-ascii?Q?rqYta4FqMYcW1TN0TFaigq4AxVFzysZ8ti/RBI6ikZYLP0XwqOy2+tflT3Os?=
 =?us-ascii?Q?yg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71ec07aa-9e0e-43ab-310c-08dac39abf4c
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2022 04:11:03.0356
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s7V2AY55wl+e5dQ7UyXQP+d6XxN/g6/grGm40/LgTUf+6HRl5T2z6hgKzRPE3U+a2PXFHFWxSB1t1hk8M6C+yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4730
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-11_01,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 bulkscore=0 suspectscore=0 adultscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211110026
X-Proofpoint-GUID: JHNSRbB3WB2AK0YblvbNaduQgX-edG2t
X-Proofpoint-ORIG-GUID: JHNSRbB3WB2AK0YblvbNaduQgX-edG2t
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

commit 4750a171c3290f9bbebca16c6372db723a4cfa3b upstream.

[ For 5.4.y, SB_I_VERSION should be set in xfs_fs_remount() ]

The MS_I_VERSION mount flag is exposed via the VFS, as documented
in the mount manpages etc; see the iversion and noiversion mount
options in mount(8).

As a result, mount -o remount looks for this option in /proc/mounts
and will only send the I_VERSION flag back in during remount it it
is present.  Since it's not there, a remount will /remove/ the
I_VERSION flag at the vfs level, and iversion functionality is lost.

xfs v5 superblocks intend to always have i_version enabled; it is
set as a default at mount time, but is lost during remount for the
reasons above.

The generic fix would be to expose this documented option in
/proc/mounts, but since that was rejected, fix it up again in the
xfs remount path instead, so that at least xfs won't suffer from
this misbehavior.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_super.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 2429acbfb132..f1407900aeef 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1228,6 +1228,10 @@ xfs_fs_remount(
 	char			*p;
 	int			error;
 
+	/* version 5 superblocks always support version counters. */
+	if (XFS_SB_VERSION_NUM(&mp->m_sb) == XFS_SB_VERSION_5)
+		*flags |= SB_I_VERSION;
+
 	/* First, check for complete junk; i.e. invalid options */
 	error = xfs_test_remount_options(sb, options);
 	if (error)
-- 
2.35.1

