Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26D026DEA6F
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 06:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbjDLE2h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 00:28:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbjDLE2g (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 00:28:36 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 833171989;
        Tue, 11 Apr 2023 21:28:35 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33BLBBoB022984;
        Wed, 12 Apr 2023 04:28:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=a/Ra1XC8jBIEh4SDEZue+otPFGbkpHNS+0Ds/tHROjg=;
 b=I5mVMpiUPi3ZT3FBVfUX1tSX0+VEEyvLY2KS+pcUqRSczn/AZXygtiwioaLElBDkKnMj
 SlPtNv4e9py3jgTKOTEeL9se2IF+LujjsLGc7+1LwYBDMHCw+B0Ez93pWArjp+eUEPd9
 kmdp5ZzkwbySD3IVSutmCvVTfgxn0FDTv5ealoHpeyb+JzHoWUs8E0jzLnW4Znn0Y0QQ
 3mjPq6rmUAsuKIYSoTpWEI36gNAj3MdkETpmJa1y6SQ9dtWTu+69tibOhp/bN2Lk3IFF
 WRexNA47C5EcCtJFrAAcQ1HwKCueN7UnbuCaGObDZpiNDp8mEnvEbLq1g1ROEMcamO6u lg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0bwf4gy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Apr 2023 04:28:28 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33C2OIiP025052;
        Wed, 12 Apr 2023 04:28:28 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3puwe88ne3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Apr 2023 04:28:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ag5Go/cGsqYFMvoxFxyY5mRGH8VomVOcCM3ehZpuMK4KIqGkBdDNVlP1WbQDg3i4bWRlMyOCFPAjXDrv1LIVq4ZKQUywEdMAZz4FoCXRYBFvTc+6PLbK9DhjWa2DgS5u6xvkEU/kO+pVbGSN6EOTouTwEvCYcLwv2Maoum7266Rcr7ySbfFdKN/9VjthfDlMw/bWps2JsPX3zJKN5mepVfimN1dVdCHYFaNeoTouZ4ntDnYIZpBnXTzIrHx20H/QVujZsRhoA83E5jeQ1MY6heHcvvrD3IczAkxA4MsLnsOVmZ9EdXpivy1WJ0zod6WvEx5liyLwT+hHJu0oD0MizA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a/Ra1XC8jBIEh4SDEZue+otPFGbkpHNS+0Ds/tHROjg=;
 b=jyG/ficw4kuZ5Gx/YVsJF7gLDyq88zto5rHwCJ25N4bfYuvbBG4pojwxEVog4X2LFEL3yYKlP5EsjUBNt5+0au4DCT1gBg54Npx/So7kQgbhpOY+t/FQcygRfKsIH09VFyGPm/Vr5TiDXwDMkLtX4xtG197yE5+xmrSxMZzLNi2LUDIt4G5MBw0PJTVcpNemasa1xcaoIQq5X4zi9N6xJNOpScUWlthcUvSuNZq4n/U7ex6Aal5XEvfk5NdN8fIcnlG0izO9mjLE/M9SjcBAhc0tEVlfGkrLDPOE/cmwsdZyRPA8uW2O4hQt1vi4zPZ+F5bLB8xXUJdRWrBM0tW8BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a/Ra1XC8jBIEh4SDEZue+otPFGbkpHNS+0Ds/tHROjg=;
 b=Ntpoag4k9Dxl3xaKAAwdW71+PAcBwesfSkoePSREaDIff20mgqxRjXk1hiSma2E9ygoPonSd3gPz18uOwJRPNEjIAAIVlJQg8VQdbWF0uwfiDo8XOiPePNYYCymLjrJtkWjZEA5cmyGqjZIhH8PMXOj2+BXq/fAqOnnICpNmD2g=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS0PR10MB7363.namprd10.prod.outlook.com (2603:10b6:8:fd::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.35; Wed, 12 Apr
 2023 04:28:26 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7%3]) with mapi id 15.20.6298.030; Wed, 12 Apr 2023
 04:28:26 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 09/17] xfs: simplify a check in xfs_ioctl_setattr_check_cowextsize
Date:   Wed, 12 Apr 2023 09:56:16 +0530
Message-Id: <20230412042624.600511-10-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230412042624.600511-1-chandan.babu@oracle.com>
References: <20230412042624.600511-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYBP286CA0016.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:404:ce::28) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS0PR10MB7363:EE_
X-MS-Office365-Filtering-Correlation-Id: d0985bc1-6263-41e4-d002-08db3b0e5c23
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xM4X4V8ATeBu7UZQNlAQhVJLPdhvnqO6jSnbpffPLtstC8BiM5NL0QF+ri9dnFoPenWph8GnpC/IAUlu5LeXnmkvM8lfsyvap+TsvJ6PSBI6gOBmRP+XLnz9UcrWFOd0u4S6G0FiXOHnEoOCBR4sb1NLyJJEG157UcffaJih2FecBu6E4AeSFrs3Fo7ZCiC9/Kkbuw9tTF53fS3AGgzHYceXLOWveXx4NJxlXB2XAWbm6VyZJm03Aw+vJ2qUXwnRTaLlZNM/gZWykJK/r1RxWuXTdUw8A9LgB/K63ZCbBbj+gxOk0BaT1qVFJ9xw348kaPwou95YjevmW3OTlXK78zy65jB/kjJOiY4MgrxBbRWTLN20ZnqaTSTn6fKpc3J/DTYOCfBkITB+1T7Ad7O7NZXtrXTkDUp7vVrxd29DUW0dowIiJwAd4E66dTm+uXNXvDWyGNT78ZwB6fAw0h5MPElxYUO0xuG9qn7O+B8a+9M57uqr+4ggl5B+xYltOfLDGmEGbEgkEJsRgtV40qAHjJOYkdDEiXE3HPQBoRdr6QMEnkaM9OymX0gSRfKHrSZD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(366004)(396003)(376002)(346002)(451199021)(6486002)(4326008)(41300700001)(6916009)(8676002)(66946007)(66476007)(66556008)(478600001)(316002)(86362001)(36756003)(2616005)(6512007)(26005)(1076003)(6506007)(6666004)(83380400001)(8936002)(2906002)(5660300002)(38100700002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?A+657/noftIWfy/ENEuL5HxR000jbZ2s0nG+C9TnckzLJxOS3YFk/skKckx3?=
 =?us-ascii?Q?GgJvU5Wtn61LWX2nUtn77xdRmSBULB6N6WLAwCfyGT2pnWcOehf8B3REZ5BA?=
 =?us-ascii?Q?i6tO65C2nBl5cWVCbMr4bCdpuvoYmE1nxC9VAZH4r5SDAPBI8CtSVjLRgUZ7?=
 =?us-ascii?Q?VqWjSuETXWK9aEUxAFHMJsWOgLmQXATARsyRW3u0VmGCZQHqPhwFYJwkgeyP?=
 =?us-ascii?Q?Xql8MqZTWq0MXNUXMV5hjS9Gn+0RNxoVr+s7a7MfRsdqNZn8dGFOeRaUoebm?=
 =?us-ascii?Q?+6KfSWlM7AqaGVJF5VdtWd/SCbmOTozOTLzl9by5CrzVzK/Q+DYB1z6T/7qC?=
 =?us-ascii?Q?eVN00YZaF/N4ayjvN5xbK449msP13J0WLz/ZXrPKumuET+Vzexp3JcAz1LaO?=
 =?us-ascii?Q?m9jMgX+XzxFcre1chmfWdpAa+6TPKmLa+eFFZu5iuVeaLHpkK9H4evn3ndgd?=
 =?us-ascii?Q?W5cfzCHUfSIMSbqmXIcufP6j09wcS06bTRINsPF+9qpRKY2OjPQsaZDXX5dk?=
 =?us-ascii?Q?HCDMzVZdbmTb9MqRGxEpqWdM0/uWzENULWumB1rmyMVAFmpd+2ILgCv5L31n?=
 =?us-ascii?Q?l6WXHCCkqFtFXAlRSLpnapbF2BvJuTSdM/oSYlB1vYSRtkkias98lVC1GyVA?=
 =?us-ascii?Q?KkIB2u8yAvkM6eg4XBav9zJuJCGUGaBBTOy2HLdXWdN4IEoQy+n4j55cH0Az?=
 =?us-ascii?Q?fL1PpPczP4wRdcNYM+6ngnsRq80Z3WUwNrWqJdxx5FH4DSi7FziClGmqR4uI?=
 =?us-ascii?Q?L0PW5ehl5tLJ8grsr4WVnVdQc9HQX4b/Ofh8cHUkFr5hTDAMUFDWJjM/w0sZ?=
 =?us-ascii?Q?mfOX1NH5WTngl2Zv16m82wP5vZYbA/egwt5Gb4OfOsj+U8RP3aY9983jQ/my?=
 =?us-ascii?Q?flPHV7gJ8FyepVWnZFovwTNB3LoqUyFUwig4OLW/B1RpPl5bI57dEJ3WUOoJ?=
 =?us-ascii?Q?UKTr3kveZtW1CRq8r+DElgMAieDrXWWA8ahgqNTyrsD9q4uHkmUM4iMOtKQ/?=
 =?us-ascii?Q?Jf/lwWmd7Ad58LfQN65Fy0TgQyHEUQdX61RqIQaTucIVF9nHHpk/sjbsMa91?=
 =?us-ascii?Q?o05pkugIIfq4tTuWSd3tkJTHpLz6rsIyyMDU/p2xqeRrJL6puZi5nfXA2/MZ?=
 =?us-ascii?Q?1dhizQ8ZLY9dqsVkbs39mOyJ890ZWEq+cbEJ1sOdt+NJY0If1A7Sf4PyBncI?=
 =?us-ascii?Q?gZpIVeatPycNXK0VuQfwqVbKmMpn6W1rkdOIa9+atDxb5OoSZNFdlHgT7Q/N?=
 =?us-ascii?Q?MFI/h4xqkSrvVQPj6mf62lC5WEWdBFcWHHnsRDdtkvP3NYAqWuins7+bSRRw?=
 =?us-ascii?Q?hy811BwxgQoqMKWKj3NYBEIiKvcnPH9KCYADX3FREWVZuTftVqb2RlJBXq3s?=
 =?us-ascii?Q?iN6jDa/xI/kvPBHxoip/5j9krzF5/SYKEUAJLqsBwwypxYCpe+Pa9u0T3FRI?=
 =?us-ascii?Q?VU+kEOFJODusGAFZ7l9hKyaNlj11RUBfwgOXm9a6DyqbCFK7v5bMVdjA9yT7?=
 =?us-ascii?Q?3P8unBymFzyxWGMe365kZ191/ctwODX8VjWDrypKhWXeMbCjuXayVDakeemX?=
 =?us-ascii?Q?iRXzfRFYeuMH0EzO/FztMAaEY4UoeoZVT24J90vO?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: V0HJpCbNk4pa0RaZvRSNDWl+zyGc9bA8NHxX0qKb9pFLhVcrSCPh08bsGQg/GSIOl6zmeQyyjv8kilEHB6brMuazAhPYooIoFOH/SY5JsqFhU9dOpfPtx6gBSJDUMb/pNqJppmLeeKr+Twln1SPr9qR1QZhqCuh0R8c9CmGfPn4d4mnIPrzoFWR3h2B0B1845MmOtx+6a8zcqWi3qAAx6d/qqxoN8azyh0ZefbriFA96g9pLV0NWchVP52bTL69nWrzwyIVjVcBlpR8Ne5lhhJ0bHeceYs8QGb1xqhvwOV/zuSIUAH6SwrTfkedOE2sidOPAeTA2Ou/xEeffUuskT/2POsehyZBhJ31FLM/ZcPlLmROyrFww3NZnDvxuzSbjOOX2OriumQamN4vVcaMssFMfFifZ4mUi7rS+l7F+2Rr2+vk5C5CXNcZe+BWVnStEkeTX5efwmhiy2O+tXW2U3jBuhXw1nOLJA/GBT9qkYw5s95w0es6DbjtzA4CDzkFZiTzwdQpQXIHKP40eWob4Xy4pofsn1WSmcjf0l7rBgi60uX2VqP+8bDP/33G+xOx7nf6rbl+SpEDauXqga/pGxQjY8wPaJPP6rWPBGL2X6hNZqtjl/ICQp67krqdex1gl/RRsnvnoU7DLp1Mg0Y1uxHnd5u+XF7qT3SNWpXxe3tEtIcGG2mddOCQbxFdksccQsf9R4dl/8Cs44umxkexqWCP9MrMAz+5oYeX7cRLgtT8L6ZfaZa3gi0UfBJ62H6VFup5Ylg7Qw0+Lm6fkz+9t5Cv7xQDqrnvCS8CQ2hRW9lF12Oa8fhfRsW1LcAxYI5gLzrtOc1/SrsJHpQjDMmIjcHY2BXGXYT3f31aI4OJeH+EaNRHR2BJdb4d4SLCv4NYj
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0985bc1-6263-41e4-d002-08db3b0e5c23
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 04:28:26.6967
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HI9cRCIYlFpujiOvuOSURTtGAkLvQ7uZ8fq3T17DENYLJUuEwWRvStMbAjQ86OJeA8rEpdISB23aMdruYyOqWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7363
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-11_16,2023-04-11_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 adultscore=0 spamscore=0 suspectscore=0 bulkscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304120038
X-Proofpoint-ORIG-GUID: xOtQoyNhoYkAvCgQ3EDR6dZW7bl9jMwr
X-Proofpoint-GUID: xOtQoyNhoYkAvCgQ3EDR6dZW7bl9jMwr
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 5e28aafe708ba3e388f92a7148093319d3521c2f uptream.

Only v5 file systems can have the reflink feature, and those will
always use the large dinode format.  Remove the extra check for the
inode version.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_ioctl.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 6d3abb84451c..597190134aba 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1510,8 +1510,7 @@ xfs_ioctl_setattr_check_cowextsize(
 	if (!(fa->fsx_xflags & FS_XFLAG_COWEXTSIZE))
 		return 0;
 
-	if (!xfs_sb_version_hasreflink(&ip->i_mount->m_sb) ||
-	    ip->i_d.di_version != 3)
+	if (!xfs_sb_version_hasreflink(&ip->i_mount->m_sb))
 		return -EINVAL;
 
 	if (fa->fsx_cowextsize == 0)
-- 
2.39.1

