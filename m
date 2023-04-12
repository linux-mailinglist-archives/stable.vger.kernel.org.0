Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E61D6DEA5E
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 06:26:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbjDLE0u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 00:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjDLE0t (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 00:26:49 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0F3649F1;
        Tue, 11 Apr 2023 21:26:47 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33BLC3RX005398;
        Wed, 12 Apr 2023 04:26:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=2wPZ9kwG5d61+GK2WZ4S/nt116p1Hmrv+k12B9UHkME=;
 b=qZ1ag7Y+ua8MubUueabVq2fpn6MPnxVRgbhFPeGlMv9uAdVKDP2Fg1R8FUTswm+NaGec
 gK35BzbNuAafpyYQpz9IxKDl9e0rwRZOUL6wOJNjrSzTMnx9duraxhBasl6zbXTeVyEL
 Grq5YEWpip4omqFi1838NPMohzqN7V+gu+CtclMAeXaDfu4quZEu2dgmrGpcH/tOiFld
 IbNuLQv+qixvSeCNi+sMENPgarRhX3nfduviem758uRglaHstSiPL3dhwCzVPDDyeEnJ
 jr1cTi9YEFapYAbmC5eWKm/KhF4lSrb08EQIE5vMv7W2/izIDdhhpOEFZC0p2Y7UmoLo QA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0e7f0hy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Apr 2023 04:26:43 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33C2VRZe031027;
        Wed, 12 Apr 2023 04:26:42 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2045.outbound.protection.outlook.com [104.47.73.45])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3puwbp819t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Apr 2023 04:26:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nMKl78zuUJJmCMBGZPizcAYYAUVbfAhFGsHrsPmr/kCW2CfZc/KRA0zVD4KKMkz9CStnj6xU/2nO9Z0rvqHXt50WGXJkTPnJLnvZuLv3KVjkELUPOuWGeQpLN6pl2dUEGfc5iI1awhXOWuuAGsL+aaH68GE8oG9qx67ybm1JcBuhYkS4Hz/MzIowDDnTUuFqWum+oRXf6vCEhgAbfgoYViNWRVPAHKNckxcd7g9BvYA0W7XE3d7YDwlt4CJAAubg4DCmSFoowF7tK6HzMNkowrVT88BDJubVTzie+7TrwvmZ7EHw9Gk1UeT5OCxaOxrUhPdG+HskMf8ggrDV6NlhMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2wPZ9kwG5d61+GK2WZ4S/nt116p1Hmrv+k12B9UHkME=;
 b=fBA4Ac+oQh+LpjKk4PER9/Z4K8p263V504maXfKOICcDVrSyFmq22lJQ4y+KWUnh8T4+kVfW+8IbcOhPFniKbVz/SAFQHYFxBbSJEbkeKu4XXnoB0Vbeh8/7Gj8VdcR3yfJvepOXNrK1u8LsKnXf74QiveDjc6/DVOoM+MSDzsbZoiWOvLgV61EYLLTGtg/2Z+Sd4gYiIsv0sny7La3KG/eIRfakiz2yUNfAU5IwFAFHZeQQYYPlWsMTQfII8dJnMVKN7s7+my1Z0Xsrgsi9KY65oMVGuXvkb+tI1Q74VHTqtvMi6vAs8DtfKCM/1tjK5a+ZUdJ3zhyU8QER5wwFKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2wPZ9kwG5d61+GK2WZ4S/nt116p1Hmrv+k12B9UHkME=;
 b=yuWMD5wuw5MaUlr1Rtx7Yaaxacwtl3s3Kq/Srosa/+bnPf6ONZl3DAHJ1Cd4iESdLO4/bZBuY7OBsCIgDMK+wE38FIixnnGW/MsmXgmbW/ah0BkKBzfY6JRZz6NddUjtyCRkGgVr7YYkT6pfJez+r7/MUp38yWsd0wKJYS1uvk4=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by SJ0PR10MB4559.namprd10.prod.outlook.com (2603:10b6:a03:2d0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Wed, 12 Apr
 2023 04:26:40 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7%3]) with mapi id 15.20.6298.030; Wed, 12 Apr 2023
 04:26:40 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 01/17] xfs: show the proper user quota options
Date:   Wed, 12 Apr 2023 09:56:08 +0530
Message-Id: <20230412042624.600511-2-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230412042624.600511-1-chandan.babu@oracle.com>
References: <20230412042624.600511-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0028.apcprd02.prod.outlook.com
 (2603:1096:3:18::16) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|SJ0PR10MB4559:EE_
X-MS-Office365-Filtering-Correlation-Id: 252713bc-3466-4d62-caf7-08db3b0e1cd0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dg3Wa9EUSVQII8dES8u9ydR0Are6PolfO/jIt/BjDHLNwKybXE8ARqLUbmaHVPTLRmFgRQoGGQ12FoLY+iqjpIfCCcYn7TmLDRaqjCUVGg7aMH6f/IyNv15kAu0vAe/asG+CDhQLeMQ/MQ2Biik60s3TEgkKWWVV4+1w4cRezr+hzfwDfKEwQSdD4D1pVADdKHmGuPY24F8vZUcwmwZ/v6UGRn2AgD5FGuoZHY0kOAFTx2Fc3FBguLSYNOUFQfNiiF6wZ5q1YFkIISnU9XefaJ+1+YdrbKfCgNVOIt+3pFkDgIOyublmenOihjHESA5LNnyhpwzGMLuwDx3aX/mgreMiJ6DcFPmMBwfG0QWCixk4CbRifO1PjKauA3BNggnejonZR+UtJ+t2xBv0XNEcM3vLwOAeEnzSjicdcZqxhFsHkarv2qA0C4oWKcgzCcsE15PuYMHXjXbJlpjmkJWdXuPQRxTC0rjYrEZa8/3jgkmSzNzltceDvB8va9CU3E/1kuDbhNuo+0UUrX9u9SitBrpggglIrbzbxNW3NnaJTgUXPoESy/O5sNjfjs0HsB5f
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(346002)(376002)(396003)(136003)(451199021)(38100700002)(66476007)(66946007)(8676002)(6916009)(86362001)(66556008)(478600001)(4326008)(186003)(2616005)(26005)(316002)(41300700001)(36756003)(2906002)(6512007)(1076003)(6506007)(83380400001)(15650500001)(6666004)(8936002)(5660300002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?H3QTVp/h0+x6PH3kVIugmIOhnpkNdI9cckRoEiip9hHU28KnBFed8s0ZirAf?=
 =?us-ascii?Q?zfo4B825L8dmQ9Ao0N6hrgS0WssvIdPrlGEn+RXUCxih2RnzJAjiocRldrhb?=
 =?us-ascii?Q?Jh+yCUVVoIJXxmzaxk2vGchkgIQCxq0H01DWievBP1H55e4SviITuwNko6CL?=
 =?us-ascii?Q?Cet3jSJncwsfThscZZwhgmnYhqw6u2oAkO5/L0Xq+UNgvCiRQAMTcRSZsm29?=
 =?us-ascii?Q?EQ3lQwQej5IofXd/kzERCABocFqO1ZPcAlWQj0z4YgcaOE2/n9cDfsdPTtL9?=
 =?us-ascii?Q?soHiavqM/VcSNCbPhD/ztCLzg9GX2dEGmZTvP7dflJhWrwBNjnpNQWm1MZpj?=
 =?us-ascii?Q?KNdzEp4SVnxLX0ilQpXHmhuAvhhZ1dvOT2ca2vUjhsXCaRDEwMHh7zbCi4mE?=
 =?us-ascii?Q?gkTtY8IaPRWpyNl6GyBc7Usm6yqpIlFjYk7OnBHFzZtOUIijcuUTijevoiqO?=
 =?us-ascii?Q?XAQbtbvpEXZTAhyhehQiUGgX8Js1eTmriWcQDe04NISxJm7xOprAi7SIs3VJ?=
 =?us-ascii?Q?2lzynerZWyE+78QwL5VpyitBAuJ4Wd8PjM5s+000QK7RSrfBvsXPZWENMzpN?=
 =?us-ascii?Q?kZwSo6d3rx5Q3Z1m2h3orTPCSrRGG5AwSYDpdeTjHvyDZPycMlX5mzqsbeSc?=
 =?us-ascii?Q?dIRMebd7RhITuVJI7XYvKrkT+d7mfQaRAJqGsni6sDcgxC68jw9ekoVqaopd?=
 =?us-ascii?Q?7HrCrJHpUCb4KOuzP3XdwOK1HrT7tDUmG0FJkXd5D0GzFyiEUXkOXwNMTMSr?=
 =?us-ascii?Q?KfycyLeU/rabMoTJQBQkptmi0pZZUjSLBlwKk0Tmvaf1HvmX4LyfzlIatDRc?=
 =?us-ascii?Q?kIpV8broUcxY1yQKoimtDuj+KHX44Pylese+KxW4+sakIZDvnbXp+GVum9kQ?=
 =?us-ascii?Q?CIJyxoseHiVLbsd7OjkTzFZZ29+g6Qkkn0eg9KySbpGVaYI1QIMO8gPnqV3M?=
 =?us-ascii?Q?Evx9L58VaHZ1f1BoaBqz+Kcqg/tAQEYCdy4GUPbvQbHnwRq1ehyeYLYYQcNT?=
 =?us-ascii?Q?FfxjIp73R42/g/TFQp4reqZG0DFReowzpZ2i54YKeXUG860XwUegmksNljfl?=
 =?us-ascii?Q?PSKNZkzgWg6JBKf+5cN4lTuoY4BsVC0WwVg2wERLRZYbqT2yO3m+pB0CqjXn?=
 =?us-ascii?Q?UxfVNulv2TdyJmx8EAJdmvfi30wK+xVU9QRl15ZD55g2Dtwa4GUG3oOPerYE?=
 =?us-ascii?Q?8eMbVF4nKiI+PiI8heE8yuEDsIQ6jQtMUoKJh2CO6VVCIqNuZJLD49KV8FqF?=
 =?us-ascii?Q?tGJrgcpMZGmyFiiEd2CoJ1SJywzRJyDvSVWW0LgFi+kHycOj0W5rM+iQ1/HE?=
 =?us-ascii?Q?ghF/JcbvPukFu4R8qvjCN5iAEiGP90tU00NW86ec+j08OMSyDsfjnFbCEQ9a?=
 =?us-ascii?Q?UN/donT4bVTgAN9iXOBuOq1PrnXELH+KjJ8LpXe4qD2r5vPZS1XKkyWRflou?=
 =?us-ascii?Q?7Dp/yKITkTc7hMY2Kibjk4hR6e8CoTYYjVQz7LTt1cYtWLHIl5b5zQnPSztC?=
 =?us-ascii?Q?3xqRFrNFVi1mhPOhKi3L+kcPdpMH26A5QU2u+0UHAVpie99bWKmoh44tRpX7?=
 =?us-ascii?Q?eGJz9EhRwqQSxUxKNRl+2awk8bLFf3Sn5JncXsh5?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: o4VF08OhXoZ7op8vLMoqGTH7FUxIAKMrTgUHHfbgV71zzmiAQj0H9aiu6OVaihuF50Kr+PW9QNhhsqdBeVJlsaCKGoJ2UGzx1v+TtRmTVKoGB6qGm10t9o6cO9eAxuFPEkuEcA6oV6HZo3AQVGwlgmkm1jRXZdfygbgRY28Vvg/qhC7gV+WD2vbkG8UR0Q6gI+zVzSMPFBzMEvyHE4aiJ0LgShp3Q42LhijsWPxP8bEi2x2sm1L+FTOLR8SXeFE3kpkC7yFolFrrSLTYIBoNAddqoOxakoKZISl0kzLZExhM2XUfgWDRly8o3SCdRBGU0AOGbKHZMDBxL67/SYnzhvczwzLsV8m8UCaaV+a/1JzFp7tP3iPRPPd9HBYqWaooNhw99t4W+7Ccf4b9EWo6e+9+pSqx7gxtIEUvQb8KWkVw0qdSHKyRBfm7SASgvFHIMl4ze1XrJOVDQoXocnfyxf4pFo3RZcBDU7ReXOEMhmKptjkwjx4/tnyJ9gxj6oHySklN/kOJcKv1fgs5HGRjBz6y3wPvM+M+csP91kbpSXxRvPCD8q3hfsaxJpKvyFzL+WsNMGt1avx8HCTdzHLjkS9RwD0EC4am6xW8IrG53FNZhG14xxtaQyJ0ouMK8wkplXkfKjwtOUdDLjpyJOnftd6jfRD2w82ZJDMPH4szpZuE3CvU6+bBXOQ1WiLstFV+nf3mwZE/tirJYjK0jZRvpsWK/XFyiSs87owsSjVCu2vosbCxURPPijGFShWLit6Q3rGCOeezx+dYZOy0FFwNCrvdGSkLiTdTj8OMr/H7j+NTQ27gOYaUHkidaMStU8DlJE8U6bsIfPBVGhrnN9O357IoVxYWuDw6broaMeP5MGJOu72guJnZlRAuJgP6SFWM
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 252713bc-3466-4d62-caf7-08db3b0e1cd0
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 04:26:40.4946
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4ISBgndfxJ556aelU6qTQI4Ga4HNCF9t0npC7nJCRcXomzZce8Oe0nKGduwMPjeHKI/i1nK4+VgtE8qlmLWODA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4559
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-11_16,2023-04-11_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304120038
X-Proofpoint-ORIG-GUID: aAPfUlm4d6rBnxNT8ATYPN3yA2UUTUMt
X-Proofpoint-GUID: aAPfUlm4d6rBnxNT8ATYPN3yA2UUTUMt
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

commit 237d7887ae723af7d978e8b9a385fdff416f357b upstream.

The quota option 'usrquota' should be shown if both the XFS_UQUOTA_ACCT
and XFS_UQUOTA_ENFD flags are set. The option 'uqnoenforce' should be
shown when only the XFS_UQUOTA_ACCT flag is set. The current code logic
seems wrong, Fix it and show proper options.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_super.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 9e73d2b29911..e802cbc9daad 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -490,10 +490,12 @@ xfs_showargs(
 		seq_printf(m, ",swidth=%d",
 				(int)XFS_FSB_TO_BB(mp, mp->m_swidth));
 
-	if (mp->m_qflags & (XFS_UQUOTA_ACCT|XFS_UQUOTA_ENFD))
-		seq_puts(m, ",usrquota");
-	else if (mp->m_qflags & XFS_UQUOTA_ACCT)
-		seq_puts(m, ",uqnoenforce");
+	if (mp->m_qflags & XFS_UQUOTA_ACCT) {
+		if (mp->m_qflags & XFS_UQUOTA_ENFD)
+			seq_puts(m, ",usrquota");
+		else
+			seq_puts(m, ",uqnoenforce");
+	}
 
 	if (mp->m_qflags & XFS_PQUOTA_ACCT) {
 		if (mp->m_qflags & XFS_PQUOTA_ENFD)
-- 
2.39.1

