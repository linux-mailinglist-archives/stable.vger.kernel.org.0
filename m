Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3149A6EC433
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 05:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbjDXD5p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Apr 2023 23:57:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbjDXD5o (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Apr 2023 23:57:44 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 073592688;
        Sun, 23 Apr 2023 20:57:41 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33NMVV4c022579;
        Mon, 24 Apr 2023 03:57:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2023-03-30;
 bh=50MmdoQiT0kOFkYqjAFYSaniAocbREXR0F9wqWyQq6M=;
 b=rn8fe8qiMZbCRXM9CrBafLAS2ywwKpSd6pIxVNaJ5sW1BpC3S99g7yArw1bhUGvHU+og
 rEQ0t0ojpgD9H7Tp24gx8p5iEPp3fPmGrKw/tQ0boQW69CY1zXwhhPZneattfGApUaUQ
 zjUU/JUg58d339MoB/0jYRwWt/3I7vxs2icwfXa6osUw6KlFZJ9dUNatcbCA3mrLSqhF
 +3Q3wG3jC6sGimga509oahipPtw39lBUvfGbfi0jv5MhWYg3ItqtKUS2Amrd6H5HF/eZ
 6bJOO+wE/o6llI7ZPSfD7+sn6FBGCETOdd4Jx9015cb9YyNQtU41z/DsqDlgDk+0CO8S bA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3q47fahw2c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Apr 2023 03:57:31 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33O00ZcA025321;
        Mon, 24 Apr 2023 03:57:30 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2046.outbound.protection.outlook.com [104.47.51.46])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3q461arjae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Apr 2023 03:57:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PCt/2kzMpillGM/xd58609h93dgZoeEqxEEkWNZDcZj87NiV0E6Y07H7iGyY5XSigAB9CBE6Ov+WnIHkC1L/iDpcvbGY4aNtK9pSzYPdK2zGa6EyOYDJ2RY9+FhhVWrZGAWadnTdQNuGbMS3mOWCO6osfhkpsjxEumC+fPL5EAOZatiBbVH8wqtnMvMZWWEYD4mNo5H84RtIddG4MSYCqGEUhTq1sLht7U8E4XO9ZYt/ZeCOmGukx0/ceoRXu8YCwSaRFW7r8wS89KehRwtkBz9LSmHAdg8HW0svak6VTNnMPFHmnm9TZ2NSLUi3PI1iQ7BF4IHiKTPFdG0XgG3bWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=50MmdoQiT0kOFkYqjAFYSaniAocbREXR0F9wqWyQq6M=;
 b=QM9Ci6PNnrmrGLwcodCMvUPxX+VV+1C3jgxjrGdUosGl4LQVTu7fu3r16mDSaGVRQoG/b1vqb+1FIoOKd6y1VwF6L2EqDBHL1kkP9p4akMq8yxvl9qP0e2fViKO4m5RdvJsLp8Wn9ZV++sRlxzPjICIXZ40OOfDyjxCbTuOozcWG6FoA3sY1vOlOMW74gYmCz7i3hOajhB/Ni9xNZvoSTLyut2AIMAn6Gi6Fb+hoJhmmmmw9Ez44Q48RxeDoIv9prRGO89nKDkZaJN9DXwKfgj/70g95iq+TsCEi+JhEqNmYrwQ+ot2QfnnA2biMy4DY1GLI9ehT+09HiKZlIYDqng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=50MmdoQiT0kOFkYqjAFYSaniAocbREXR0F9wqWyQq6M=;
 b=evqOh7X7D97ZA+x5KHTslBf6uGWbvstteYCi2zma8RYXG5cJFYYLC3+XTsRsGTYB6oMaX6H4WN0VGwns2oZpFqzpuIe2Uy+DFxK5YijZLBZmHq6W56O8MfQd9LtoD7fQsBTQ59S00wJj7LbQTXC342EAGtICf9PJqxKIM2YMbjI=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CH0PR10MB5068.namprd10.prod.outlook.com (2603:10b6:610:c7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Mon, 24 Apr
 2023 03:57:28 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1%3]) with mapi id 15.20.6319.032; Mon, 24 Apr 2023
 03:57:28 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4] xfs: fix forkoff miscalculation related to XFS_LITINO(mp)
Date:   Mon, 24 Apr 2023 09:27:22 +0530
Message-Id: <20230424035722.113772-1-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0014.apcprd02.prod.outlook.com
 (2603:1096:4:194::19) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CH0PR10MB5068:EE_
X-MS-Office365-Filtering-Correlation-Id: d5d7b2ba-57f2-4f94-7258-08db44780582
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z00cql6FBII13P4koJ6rlWfLxUYVJtRiJdAxuqb4xPD7ZXHbSEBjza5UOzxmbxSGHvewRnHoyRagUYMhsMdKhNpUTh/lP787z2OA2hTBwPdCqOfX58Buj6DWqllnO1FVJqxXML635ZznHt9tABJWLZjvkyWoGypPbrfYWWL4USdsqrl83fMGs8dG6d6atacw135RSNBgMINTqBO0Cv0PtVNIu7GFffLWrXagJPJGYHZk17lej3zMDA4SLFt/KHTKtHTWJGmZzDYGtvjxR4sA0vuwBfTgOlO9XlcEeEn/OUcSSNuQBFriJgxh0IktDTZwbLS1Wq+o4541oMcd+mU36Z5y4aocHMs1b8Frhd4yZrJw/InBRiqWZlhclbQJG2xAOIDF8LpXzZNeiTzK0CwRKfqP820gfp9Z59FzzR71QZEbtM0sptvtLpH3F0eZwphdNgdH9iOV0JbCJ21e10zsCHaNnKRbH0qz3PtS/MaFYz8g+5Z8pNRqruJsu/7sFcRoRxfPZqAgkjOmWmHkuskpFg+Ri0n0jRmj5VAd7v0j86Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(376002)(346002)(39860400002)(366004)(451199021)(38100700002)(966005)(6506007)(6512007)(1076003)(26005)(2616005)(186003)(83380400001)(2906002)(8676002)(8936002)(5660300002)(36756003)(478600001)(6486002)(6666004)(316002)(4326008)(6916009)(41300700001)(66556008)(66946007)(86362001)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FleZN7++8/IHpH34LWAk3Vnj3D2SlBOlNLjeZ+uPQlpfjdgnXnEk9htBPcOW?=
 =?us-ascii?Q?tzCffx2x7AqEw8pxjE24cTZb9SvSYTwj8SeR5tK6iNJnzupyy83GnPIgSDz2?=
 =?us-ascii?Q?HXL2BN9/Scy1g/rnY0XnfWTuio0PncC1m9qcawLyM/f1c9KSozllQfQgEML8?=
 =?us-ascii?Q?21pTK5ft9Qgy/cTyc6jt9uZ/+ZfQa09mtdq/5RBZBVGHpbIZgRCA90KDC2ih?=
 =?us-ascii?Q?W3V09JNIf6kzhv2a/E/rH2kLxy5QOZgc/YPVYwC2EAdo+Kf4u4UVRyj1ws0W?=
 =?us-ascii?Q?whl1PQrAMJy91I7jTfr1SynLuxgR3ri+jZCY+Mj2uw3V1lxn8Px0Kk6e+eZX?=
 =?us-ascii?Q?y2w2mL97jfrI+BoAF9rdR98s308wx9dt9Ndj8Dls5CF9e0EkRLL4UWq6Al21?=
 =?us-ascii?Q?tNwuszwVrtyFMom2ffXXt9nJC6J7ij3x/chw0j1XDKr6nMiU+iSVlAlNigXI?=
 =?us-ascii?Q?YT25h5/wLfZsOTQqT16r7ctMyU4Mjk5jtE53z20um2E+9YjW7LSgWwbZx7Hn?=
 =?us-ascii?Q?p1fYXlZc0yyTaDcCUf9Lku/Rqkl2c00TBPVRwefA2pfIEjcaceLg5DOgXoEt?=
 =?us-ascii?Q?pPUl/PpB3UJiE+gvFNwIf92ISuqHQll2keilpYUII4SarmQEiw2gVcrBJ0yC?=
 =?us-ascii?Q?k71hWYKtZK7hGkZZh2X9Lh79c4uy6uJtLCdu4Fx3CZOXKxo24pS+VhnaC49j?=
 =?us-ascii?Q?2R9IyDM+63II9sr5beZ6AaHfYjwvpCoOQn0smR6m5IhAq5S64N6nL2bLcn2l?=
 =?us-ascii?Q?QwTno48LF20QXvgl1vHH1GFSgHfocT606xtpjjy1+z2dIwlfXtJV7OtWC5QI?=
 =?us-ascii?Q?bKv9INRp8eTYmqVtliyCmz5g/7kE04t27sxaBkx9FMWVvyUqnlAsgWX+83hm?=
 =?us-ascii?Q?PDuKvosYy1oHlmwRo9DSWgYp0WLYVoSVTa/2Pu8G6eQVFxwZr+FQyk/rwNU+?=
 =?us-ascii?Q?+EEHprU8DfNY9YbSdsNfOw7t8vz0stURjr+wQ4N3bq/nChdEelLJwZM7K20+?=
 =?us-ascii?Q?VRbCeAzgHwmlFjvGTR3alEaRcTE6rBW9usmJkb17RB/Eqggc+9Xy0YL7+OC6?=
 =?us-ascii?Q?Yi+FCFfpmv+AA20+MaNxmsOkwAq5k5y29hZk8gbnE7LcpCjXv94vgXQHPm+V?=
 =?us-ascii?Q?8jnWU8RJHUjft7+fVHLNwAEZuQlu0F/q1dzqnL3dJsjFN9da0EDDBwYhSYKN?=
 =?us-ascii?Q?pQACkxHACYu+/6mcjMdYfI7sd8XWptdrKEZnmuZr9F0Ld0NxjtJvvW6JV+ox?=
 =?us-ascii?Q?OyhAhowE35jZCGH5T3utH822FpnDjLkkFCOVTFK6St1yP1d6p2HnRmQrZHfW?=
 =?us-ascii?Q?0cJE6U2vRY3PyEaLhRAFFdPLeXCPM93O/kGoKMg56qRaF3NHZrgI3Rc5ulFM?=
 =?us-ascii?Q?z0R03lPR/p5wJsP1YnBqO4CgDP03S4mZrztKYFBpAVQCHRyFqOKEzA4M9Oj5?=
 =?us-ascii?Q?RfKpOx8ror8oaeI7eFBCBxDAOc7mjWgF+7YUbr73KG+ZPsLDGWMO6+t3sEZP?=
 =?us-ascii?Q?JYjhMJ0xuhm0ihvxrY2YXhZvDDhGjcwTY87MfbbvyIs9GuTEIukJpyRWxi70?=
 =?us-ascii?Q?iNy6Vl+JGSLDDqq+dbfkmk09d33hCxjyfimVBfk3?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 3TQTBwKeqeWtTslMhM25BT3QPm1fISIQQA4t7rqUBY81epX2oPh36az3rczOkXfti/nDWdE0yfCFjBCx/k5hxgHKeLI+rpUzBfBGBsr3pIyoMvHY34MbOafp93KRX6RgQDdDZ4TqtzuLxn55srDkEj2/+urdKGaoghIIBaDmTZpSsTX07VjznOW3vak4viQNl+QiXdF7jttAYs+TxNXfxd1KJkCBVyjwlqLo6mSAaPiBlyX2nwh3/BHR3OGzpNSFgFcANxazhwknJqQyIi6OvdHpesVfszG+X3xP6CUc78bVzmXKVfiTtaYJJGM6KXYUA8Sth9bf/QDz7rDMk7LsbCoclfttMh8NyHv+MDB3Qp40oVXBhOsSs8GxPYRDnDsI1i/73x7ybBWMXTTzRv2Xb58Z7eNxNpDCdPKgg6Xz9hAsqJBRKlSKbZ3TEsOSG+9sIOcKBAcLga0TLH5RL3zdOzavTmaqP4bbNh/T/zifk3eZQhcoGMwqDTnpGRBedFNPb3Uos1j30L/CgPHweroY5PV/z0EJgu0Kc8skyiZzItmS6CzvZPdU2d6XF8qTh9g+d2R8l40PUqTNrr/LVnNiQn78h8ixUeho3F7UG1I+jn1oQse8qaG1IdFru9RrBSPH8n+GHhdof9ZZtg55PVC9eghyQ5+2tk20rD2HqBLUny3uX3oUuhA3SEpwo3x7+Dq5AcF4z7B5qlZXyWp55Ko2pec9tZSR+fQv35n57g6E8d6tytrQdiIKDKZTu5FIqhtposMgXp0y/xuKKdZLQHbhQCiH4b76WxhOo1B4vsnO0yUPM1i+m3BqOymnckwAXZf23S0CSCElOJj2QC0DtPn76aF1vP1LrnwG2qS60xeo0iwEK2uxBMQAzeyDdDah0oRS
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5d7b2ba-57f2-4f94-7258-08db44780582
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2023 03:57:28.5387
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h8/NWL/7VwcGDZro9QxN0c+/3+Hhl85lgfki7wV1mbLwcXnXBedz3OrVvCkuCgiIbajvtVlt0TpUB2DQQczPFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5068
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-24_01,2023-04-21_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 mlxscore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304240036
X-Proofpoint-ORIG-GUID: S-N1K6vPouQGVZqOE0R1CF_44pswF8wh
X-Proofpoint-GUID: S-N1K6vPouQGVZqOE0R1CF_44pswF8wh
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gao Xiang <hsiangkao@redhat.com>

commit ada49d64fb3538144192181db05de17e2ffc3551 upstream.

Currently, commit e9e2eae89ddb dropped a (int) decoration from
XFS_LITINO(mp), and since sizeof() expression is also involved,
the result of XFS_LITINO(mp) is simply as the size_t type
(commonly unsigned long).

Considering the expression in xfs_attr_shortform_bytesfit():
  offset = (XFS_LITINO(mp) - bytes) >> 3;
let "bytes" be (int)340, and
    "XFS_LITINO(mp)" be (unsigned long)336.

on 64-bit platform, the expression is
  offset = ((unsigned long)336 - (int)340) >> 3 =
           (int)(0xfffffffffffffffcUL >> 3) = -1

but on 32-bit platform, the expression is
  offset = ((unsigned long)336 - (int)340) >> 3 =
           (int)(0xfffffffcUL >> 3) = 0x1fffffff
instead.

so offset becomes a large positive number on 32-bit platform, and
cause xfs_attr_shortform_bytesfit() returns maxforkoff rather than 0.

Therefore, one result is
  "ASSERT(new_size <= XFS_IFORK_SIZE(ip, whichfork));"

assertion failure in xfs_idata_realloc(), which was also the root
cause of the original bugreport from Dennis, see:
   https://bugzilla.redhat.com/show_bug.cgi?id=1894177

And it can also be manually triggered with the following commands:
  $ touch a;
  $ setfattr -n user.0 -v "`seq 0 80`" a;
  $ setfattr -n user.1 -v "`seq 0 80`" a

on 32-bit platform.

Fix the case in xfs_attr_shortform_bytesfit() by bailing out
"XFS_LITINO(mp) < bytes" in advance suggested by Eric and a misleading
comment together with this bugfix suggested by Darrick. It seems the
other users of XFS_LITINO(mp) are not impacted.

Fixes: e9e2eae89ddb ("xfs: only check the superblock version for dinode size calculation")
Cc: <stable@vger.kernel.org> # 5.7+
Reported-and-tested-by: Dennis Gilmore <dgilmore@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
Hi Greg,

I had missed this commit when backporting fixes for 5.4.y from v5.11 &
v5.12. The commit has been acked by Darrick.

 fs/xfs/libxfs/xfs_attr_leaf.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index f5b16120c64d..2b74b6e9a354 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -435,7 +435,7 @@ xfs_attr_copy_value(
  *========================================================================*/
 
 /*
- * Query whether the requested number of additional bytes of extended
+ * Query whether the total requested number of attr fork bytes of extended
  * attribute space will be able to fit inline.
  *
  * Returns zero if not, else the di_forkoff fork offset to be used in the
@@ -455,6 +455,12 @@ xfs_attr_shortform_bytesfit(
 	int			maxforkoff;
 	int			offset;
 
+	/*
+	 * Check if the new size could fit at all first:
+	 */
+	if (bytes > XFS_LITINO(mp))
+		return 0;
+
 	/* rounded down */
 	offset = (XFS_LITINO(mp) - bytes) >> 3;
 
-- 
2.39.1

