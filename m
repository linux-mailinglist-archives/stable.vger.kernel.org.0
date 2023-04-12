Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73FC76DEA71
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 06:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbjDLE2p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 00:28:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbjDLE2o (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 00:28:44 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 046331704;
        Tue, 11 Apr 2023 21:28:43 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33BLXQM5016838;
        Wed, 12 Apr 2023 04:28:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=9jHtuVvk3vih9xipVG5uABxuhs5CnkTFb2aOm6kWnOw=;
 b=BknnyPjUdKuBbef7syp+gz3dlvwcyDEIPVeiy08/8h77h228KnWm8Y1FFh3/5IdYf0UH
 E4sPIm6g3Obgfjw3oGIlvZVswljlRwpiMk1H5Y7IO0EkGuj56dds9jygvZU546jGSfus
 vDu4OE/PNcIRcQuIN8WKMa4mDZfkb05LPjFBsGhfeADM75XvHwOyT+UOdd1D0Nh4i6sT
 UBEbf5J5GoF/qIekE/Y0oxzJ8ZV/yWxx/QZniFFded4HEF4fMLZGaQBuj7z9NFbGWIDs
 nQrHxBFBR2sw/s5ivZ4oKPEAZy8UylhDfPr59dwC7H2poDzgRjVlvNhs2mROBwlz12/W zA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0hc72rx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Apr 2023 04:28:38 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33C2IMQa008150;
        Wed, 12 Apr 2023 04:28:37 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3puwc591cj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Apr 2023 04:28:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mqLrgcO3FRx/mxDjZxkh7H6Beq224RS+3rs1GfISyPr1AG+cd2kbOHLZpkKWVPOk0dNqni3UJnE+qRT8f6U/n+ofyCKo635j8hZFU6WImVR5mmZHGSj5+3cBx7kj/Jn9N6wj0EOUdA8PJOTMdf2VSHCpxqIbq0L2OgbIKfajig51i5VctsgHV2UkApDxAzbqptmXKHUgCOiJgB9BA/EKfiuD/nBwww0+yOSnC7mzm/M2S9wWsn92cuh/OnI0/8qOWFOJw31Qfu4zCviU8eVK2qKRtgmlnfAp2kzDmy99z1DrKydoC34Hx4alufA+Hsrna9d4LhN44gTwoST3t7HC7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9jHtuVvk3vih9xipVG5uABxuhs5CnkTFb2aOm6kWnOw=;
 b=X88OpdVkoT5dV6FtOGEajTOqDOjA5d/P0qjwVqlai8HK2pZxHfpMiMOrelmvGeXVuWXW3DEcMqSyDDQOnYvMq22Z9Ovott/F0eHYydbewwC6d8LGzP1rBTRg1fxrWr3afh7NLfM1jf2DHTI7QPThXi4NENoHQhmjY9S2NPDUNIa1lSCKjVTj3PJN8ZP/7sN6MZ1lutowdswcqltmJXNfzAYVZBL9eoo4+EZ38yJjYogXAFSk9yBfehrC7UbliFjDk45tXOTAJseIxVQRBw9hv5jvQNtX/sfCrPxHXc4XtafRtPBcrYRpcvnNIS9achqbpo/vBHn0vJR9kylJ1CfRiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9jHtuVvk3vih9xipVG5uABxuhs5CnkTFb2aOm6kWnOw=;
 b=aYCxPC/7PI2oC+KcKQetdVcHasG+h7oBfM3rQUfpiKkdnQ44xbeG1aok/FJrYiASFC3pSuQKkOL0LtvtC07qSaUxHIy0WPIw2L1cFxZDz2jYmFu1m/i9LwifN9vhPXsj0obSiYSkZYCencq2znvF3KxHmFh268Joq0lZYnazcbI=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS0PR10MB7363.namprd10.prod.outlook.com (2603:10b6:8:fd::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.35; Wed, 12 Apr
 2023 04:28:35 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7%3]) with mapi id 15.20.6298.030; Wed, 12 Apr 2023
 04:28:35 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 10/17] xfs: remove the di_version field from struct icdinode
Date:   Wed, 12 Apr 2023 09:56:17 +0530
Message-Id: <20230412042624.600511-11-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230412042624.600511-1-chandan.babu@oracle.com>
References: <20230412042624.600511-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR06CA0047.apcprd06.prod.outlook.com
 (2603:1096:404:2e::35) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS0PR10MB7363:EE_
X-MS-Office365-Filtering-Correlation-Id: aca6ccbe-dddd-45a6-e1ab-08db3b0e6134
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rNE3d7MqZuB0CXhCZTo+OzxjjXE/UyHvVcm7j2xBBisqCrtfTxO6I+K+KxJh5tv9g7BWq8fc+Dlt40Iw0lBxdB73sEIE9C+cgy4msNED7fsCMMuWWxrvSbpqm7oyessX1UZJe+F8Tyk4LJky3AgcgYoFi5STbL9O1rihbZ58SGUjYz6qg/0VEhoRGlxDmrD1XXhOmVtCyZPSiU2j2MCfxda67T2gxWaHJfW8Sor5c1ehrp7k8hHGUywQ3x29wB/Rox4YhYIXS+xOsy7ZP7I4xrbV43uSnwbvdQfQQRaxhhZpxzsezaKEgNcBOoLakX5GsEEh7bRHb7K3q+ovTk+Ct5PLhBDywCJbONA4VeheZgWeaWOwW8NsBFwOOX0C8+LU1oJRQOe/CkD5zc15wlOcUa8FJ/qW86jwB4Lwrs7lrfnDne1fBVrwXC9CPv2I5v/TGHxVPD8UnfYwr2Ku099XwvhktoSvQ6UIoRlYGFVb+OELH00jKcHmP+7tqQTPBbdnu4vkvwlI97jg459k/8Xl/0T+eji5hiNzf3AxgLoLWYb9bqOZmZJRdsNNvdqP7itc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(366004)(396003)(376002)(346002)(451199021)(66899021)(6486002)(4326008)(41300700001)(6916009)(8676002)(66946007)(66476007)(66556008)(478600001)(316002)(86362001)(36756003)(2616005)(6512007)(26005)(1076003)(6506007)(6666004)(83380400001)(8936002)(2906002)(5660300002)(30864003)(38100700002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OaV9ns/pU5j10RP2giqUSfL3p4R2LWypQ6uYEyUHFpsrTP1S9XntBhUWr1dy?=
 =?us-ascii?Q?FQz/uRCSXse1xtkjkM/+oAD2CMoD6UZKtSDNUzoOYER7S7ldfOiQNPMtSqV0?=
 =?us-ascii?Q?7RRidD/vyoCmxFKU51nnkxOq7sVXOoWvEX0kUAfOY8vBZSdtoRtm0ifSZNEt?=
 =?us-ascii?Q?Bnkqcvla2APjnHywBMOtDjfNRO+sh6nqc+MLhvkOZavSz5rw3heQBcpqeGkZ?=
 =?us-ascii?Q?jzOzOC/QP3/bg0rQJ7vBpnSNfCeB5yMhSZG18w+qhA9NfDIDqu4Z/pX0A3eK?=
 =?us-ascii?Q?Otv7wQZsKFEX0h4Gh4byYj1iCcqrcOhJ72d/LhmsN5dSV1xQD0s12KduC7VH?=
 =?us-ascii?Q?rrR2Datj6q/kZHQP+A9aQpuIUQGS6/e6ZlXqaI4M/+cYK0PRi6uaBLXxgCiW?=
 =?us-ascii?Q?Ft/6n/BbBeuXMgA/GfEeWzeTXSkeRPe4p5d4pSv8zw6GCqZprsPUgVhuggQp?=
 =?us-ascii?Q?lLLfRN7RCzhUuJGD6FFALBk+mw/1AMnPQV4JsZ0gkPzpom088lb2IPUib2ab?=
 =?us-ascii?Q?3zd53axYn+8SSVbero2ZUqtMON/Yt7ng3qTmw642kFuMutjkLUZdhNWf3swE?=
 =?us-ascii?Q?PBsEYas9O5iFYcwhLr4wtuPMT9K9AAtoKD2ixyeokLPXPJ5jdEUm8S5BfmJe?=
 =?us-ascii?Q?rbsawoWPZHJDqMnG58T/NqbJJZniISqXq+Fj/T7VPZSrEwnzYWHekYbMj+pF?=
 =?us-ascii?Q?jAFEmlDYnbH07bdTkxc177otoN6DTBJGTFxrXbt5h9FHsIPCp1jeHzNcrrsx?=
 =?us-ascii?Q?dcqPdr9o0qxC7rWk80PtnJfAN09OBsQlgJYSQmxQit4z6tROK3eUFGtV8l1b?=
 =?us-ascii?Q?Bouj22V4docaTO35F+8a5ZuU6PraJowwEYFWUqnW6zv6yhUoBw8SgKVdbWtQ?=
 =?us-ascii?Q?RQcPyXfRin8Ty0EahwT/Q7VZUO4NUNEPjLOjdmNlaKXxpSkB7liXTUdXNeUf?=
 =?us-ascii?Q?wuvKUvAGnwkKmmoak/0BN32vG0Jce6pcc/AU6za7u4ozK034y/nodvYSgOKf?=
 =?us-ascii?Q?YeJsRa2Gu9XsNfVLnQ1glY8n02eFzydn2a00937Jhg7jp6IctQBPjsT4a3B/?=
 =?us-ascii?Q?Tz5AdpjfHp/dKHc6GIpy1Dk/ekwPHO7yYn3FFPjv+A3+e9XAMTupMgN0XKf5?=
 =?us-ascii?Q?JxscASjbpRzQ/lw1ycKEQs8TfFnsiqynQ7dqSFfWu4TFUXtqBw3fpuyNB1or?=
 =?us-ascii?Q?xMDwnta2gKWhiqmFdAY1AWPit7Fx/ca305FRSOB/A8uhDjiGrxi3hgXP30z1?=
 =?us-ascii?Q?gK2opXhN9UOwvVnu45Bf3r16BvkY5sle3vtllswk26PURlUw2HlL52uomgeC?=
 =?us-ascii?Q?GdNqbqAIdtxOC6NQe+U+/KyyTiAzh7vwPvV+/22jDS0ZC7smXILjDWAarhZ5?=
 =?us-ascii?Q?/Nv7O77X2UpqfM3oH+lX83sOFKYUrAzhxfi9iZNFdWIijDiEhTIJFzt85ZdL?=
 =?us-ascii?Q?X+D7UcrWc/UxEiJtSutq1vpUduUEAJVkjtEWKVmWH+6meLTC5Sc/HwZ3xdAC?=
 =?us-ascii?Q?H4x0eSUT2PvZVup4C9peg3uDzMRbxI9v3y6KEOxOFC+cnvuOJLFELdmMJhPC?=
 =?us-ascii?Q?VnzBGDTtCp4A3sgAzmrrHWG7jHHGnHtR0QeG38E6phvCBXViUz4wWSWT+6LM?=
 =?us-ascii?Q?zw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: yZ2FMyzYSHtq2mf/FybxXZwg2vB1Et4+PUDG8ee/4AMgzgxtyIso+Vv6pVk0t/QuwhDpyIQVz2iYB8tWVSI0iQgODhSCGwRQF9HxVMcmDjoUiuFZOp74FPZQldZ2dA0wlmYFCOYqTw3gXyW92pii4Sq7KT3Vs84wTb5JunraUX1+4/XbPQ7DV5frkqwpQpbxalVyLWI2vjp7TvamvQbqdp/K3hFgAlQdoQwMFB0+Di68xDgjbAQ+065hIWLRQLtwvRG/St0v/xTXzRvQ155cbFXSk9foh13iRw02IDh5bY+6GK8IVHaR3RN0sdPGwl5DdIIv6gJaT6nseDgCXePbPRXJuK11HA0/hGfFUyLv92sBVbBw2wgKsAzM/50+eP27y/sODGxPw+JzC7edsu90pcw9O8pMN2RxKyocDtC3w8+x5EeJBxh0DEDI+aDB+dExJCzeBhJ4WHXBgHQ/oHyuRqQoPZt0Cw0RJBam5YoUqvVKRzueSUVmSlzM/NcfNQyWh49Nee1egj10BfnKkj6BMU441YgZcWR+418HEwdT0dl4pbRpnjh5O/2CDC3OsyHK+9EOYwQXnzEQL869nLq3O9jWDhuP8J8aI+eX/ixtSjJX8+4xK7kWvN9F+BSXvvXQYl7jNYQjzhGA5ig8NHcDahXOVHMd4808Z/F/bOK6eZyxyeIwORTetcp+jRN3Jaf99VVr0jQIWanWREucHbMnN+DSfaJorpo6yCFC5Oj6Rb3CUJYiRgiC/sA5GQoQH8GTKWd2KCFbVzUrQ/Vn/5Msn0seK07MoxtXrhX91qr/CPukpTWzkss+JeBYS0fRwKwRtPSDO5JaaMx1Ylm0pJpw6lZF32FOjroKahIvp93S95dixXDpjJKYBnhUhR2xQ4F3
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aca6ccbe-dddd-45a6-e1ab-08db3b0e6134
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 04:28:35.3682
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hgxxb4L4n/oInhFHRRQN/TxedkyX0RK6MLdPoAOR5NnFPRhr7o2QxWkCXcV+O8RGJPhdHN97KrAJZLZx9g4ZTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7363
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-11_16,2023-04-11_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304120038
X-Proofpoint-GUID: L_Flae4yuoMBcKeYrmncTn-BTQPYo8kw
X-Proofpoint-ORIG-GUID: L_Flae4yuoMBcKeYrmncTn-BTQPYo8kw
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

commit 6471e9c5e7a109a952be8e3e80b8d9e262af239d upstream.

We know the version is 3 if on a v5 file system.   For earlier file
systems formats we always upgrade the remaining v1 inodes to v2 and
thus only use v2 inodes.  Use the xfs_sb_version_has_large_dinode
helper to check if we deal with small or large dinodes, and thus
remove the need for the di_version field in struct icdinode.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_inode_buf.c | 16 ++++++----------
 fs/xfs/libxfs/xfs_inode_buf.h |  1 -
 fs/xfs/xfs_bmap_util.c        | 16 ++++++++--------
 fs/xfs/xfs_inode.c            | 16 ++--------------
 fs/xfs/xfs_inode_item.c       |  8 +++-----
 fs/xfs/xfs_ioctl.c            |  5 ++---
 fs/xfs/xfs_iops.c             |  2 +-
 fs/xfs/xfs_itable.c           |  2 +-
 fs/xfs/xfs_log_recover.c      |  2 +-
 9 files changed, 24 insertions(+), 44 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 3505691a17e2..962e95dcdbff 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -194,16 +194,14 @@ xfs_inode_from_disk(
 	struct xfs_icdinode	*to = &ip->i_d;
 	struct inode		*inode = VFS_I(ip);
 
-
 	/*
 	 * Convert v1 inodes immediately to v2 inode format as this is the
 	 * minimum inode version format we support in the rest of the code.
+	 * They will also be unconditionally written back to disk as v2 inodes.
 	 */
-	to->di_version = from->di_version;
-	if (to->di_version == 1) {
+	if (unlikely(from->di_version == 1)) {
 		set_nlink(inode, be16_to_cpu(from->di_onlink));
 		to->di_projid = 0;
-		to->di_version = 2;
 	} else {
 		set_nlink(inode, be32_to_cpu(from->di_nlink));
 		to->di_projid = (prid_t)be16_to_cpu(from->di_projid_hi) << 16 |
@@ -241,7 +239,7 @@ xfs_inode_from_disk(
 	to->di_dmstate	= be16_to_cpu(from->di_dmstate);
 	to->di_flags	= be16_to_cpu(from->di_flags);
 
-	if (to->di_version == 3) {
+	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
 		inode_set_iversion_queried(inode,
 					   be64_to_cpu(from->di_changecount));
 		to->di_crtime.t_sec = be32_to_cpu(from->di_crtime.t_sec);
@@ -263,7 +261,6 @@ xfs_inode_to_disk(
 	to->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
 	to->di_onlink = 0;
 
-	to->di_version = from->di_version;
 	to->di_format = from->di_format;
 	to->di_uid = cpu_to_be32(i_uid_read(inode));
 	to->di_gid = cpu_to_be32(i_gid_read(inode));
@@ -292,7 +289,8 @@ xfs_inode_to_disk(
 	to->di_dmstate = cpu_to_be16(from->di_dmstate);
 	to->di_flags = cpu_to_be16(from->di_flags);
 
-	if (from->di_version == 3) {
+	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
+		to->di_version = 3;
 		to->di_changecount = cpu_to_be64(inode_peek_iversion(inode));
 		to->di_crtime.t_sec = cpu_to_be32(from->di_crtime.t_sec);
 		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.t_nsec);
@@ -304,6 +302,7 @@ xfs_inode_to_disk(
 		uuid_copy(&to->di_uuid, &ip->i_mount->m_sb.sb_meta_uuid);
 		to->di_flushiter = 0;
 	} else {
+		to->di_version = 2;
 		to->di_flushiter = cpu_to_be16(from->di_flushiter);
 	}
 }
@@ -623,7 +622,6 @@ xfs_iread(
 		/* initialise the on-disk inode core */
 		memset(&ip->i_d, 0, sizeof(ip->i_d));
 		VFS_I(ip)->i_generation = prandom_u32();
-		ip->i_d.di_version = 3;
 		return 0;
 	}
 
@@ -665,7 +663,6 @@ xfs_iread(
 		 * Partial initialisation of the in-core inode. Just the bits
 		 * that xfs_ialloc won't overwrite or relies on being correct.
 		 */
-		ip->i_d.di_version = dip->di_version;
 		VFS_I(ip)->i_generation = be32_to_cpu(dip->di_gen);
 		ip->i_d.di_flushiter = be16_to_cpu(dip->di_flushiter);
 
@@ -679,7 +676,6 @@ xfs_iread(
 		VFS_I(ip)->i_mode = 0;
 	}
 
-	ASSERT(ip->i_d.di_version >= 2);
 	ip->i_delayed_blks = 0;
 
 	/*
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index f1b73ecb1d82..80b574579a21 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -16,7 +16,6 @@ struct xfs_dinode;
  * format specific structures at the appropriate time.
  */
 struct xfs_icdinode {
-	int8_t		di_version;	/* inode version */
 	int8_t		di_format;	/* format of di_c data */
 	uint16_t	di_flushiter;	/* incremented on flush */
 	uint32_t	di_projid;	/* owner's project id */
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 5eab15dde4e6..2462dabb5ab8 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1624,12 +1624,12 @@ xfs_swap_extent_forks(
 	 * event of a crash. Set the owner change log flags now and leave the
 	 * bmbt scan as the last step.
 	 */
-	if (ip->i_d.di_version == 3 &&
-	    ip->i_d.di_format == XFS_DINODE_FMT_BTREE)
-		(*target_log_flags) |= XFS_ILOG_DOWNER;
-	if (tip->i_d.di_version == 3 &&
-	    tip->i_d.di_format == XFS_DINODE_FMT_BTREE)
-		(*src_log_flags) |= XFS_ILOG_DOWNER;
+	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
+		if (ip->i_d.di_format == XFS_DINODE_FMT_BTREE)
+			(*target_log_flags) |= XFS_ILOG_DOWNER;
+		if (tip->i_d.di_format == XFS_DINODE_FMT_BTREE)
+			(*src_log_flags) |= XFS_ILOG_DOWNER;
+	}
 
 	/*
 	 * Swap the data forks of the inodes
@@ -1664,7 +1664,7 @@ xfs_swap_extent_forks(
 		(*src_log_flags) |= XFS_ILOG_DEXT;
 		break;
 	case XFS_DINODE_FMT_BTREE:
-		ASSERT(ip->i_d.di_version < 3 ||
+		ASSERT(!xfs_sb_version_has_v3inode(&ip->i_mount->m_sb) ||
 		       (*src_log_flags & XFS_ILOG_DOWNER));
 		(*src_log_flags) |= XFS_ILOG_DBROOT;
 		break;
@@ -1676,7 +1676,7 @@ xfs_swap_extent_forks(
 		break;
 	case XFS_DINODE_FMT_BTREE:
 		(*target_log_flags) |= XFS_ILOG_DBROOT;
-		ASSERT(tip->i_d.di_version < 3 ||
+		ASSERT(!xfs_sb_version_has_v3inode(&ip->i_mount->m_sb) ||
 		       (*target_log_flags & XFS_ILOG_DOWNER));
 		break;
 	}
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index cb44bdf1c22e..6bc565c186ca 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -795,15 +795,6 @@ xfs_ialloc(
 		return error;
 	ASSERT(ip != NULL);
 	inode = VFS_I(ip);
-
-	/*
-	 * We always convert v1 inodes to v2 now - we only support filesystems
-	 * with >= v2 inode capability, so there is no reason for ever leaving
-	 * an inode in v1 format.
-	 */
-	if (ip->i_d.di_version == 1)
-		ip->i_d.di_version = 2;
-
 	inode->i_mode = mode;
 	set_nlink(inode, nlink);
 	inode->i_uid = current_fsuid();
@@ -841,7 +832,7 @@ xfs_ialloc(
 	ip->i_d.di_dmstate = 0;
 	ip->i_d.di_flags = 0;
 
-	if (ip->i_d.di_version == 3) {
+	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
 		inode_set_iversion(inode, 1);
 		ip->i_d.di_flags2 = 0;
 		ip->i_d.di_cowextsize = 0;
@@ -849,7 +840,6 @@ xfs_ialloc(
 		ip->i_d.di_crtime.t_nsec = (int32_t)tv.tv_nsec;
 	}
 
-
 	flags = XFS_ILOG_CORE;
 	switch (mode & S_IFMT) {
 	case S_IFIFO:
@@ -1110,7 +1100,6 @@ xfs_bumplink(
 {
 	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
 
-	ASSERT(ip->i_d.di_version > 1);
 	inc_nlink(VFS_I(ip));
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 }
@@ -3822,7 +3811,6 @@ xfs_iflush_int(
 	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
 	       ip->i_d.di_nextents > XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK));
 	ASSERT(iip != NULL && iip->ili_fields != 0);
-	ASSERT(ip->i_d.di_version > 1);
 
 	/* set *dip = inode's place in the buffer */
 	dip = xfs_buf_offset(bp, ip->i_imap.im_boffset);
@@ -3883,7 +3871,7 @@ xfs_iflush_int(
 	 * backwards compatibility with old kernels that predate logging all
 	 * inode changes.
 	 */
-	if (ip->i_d.di_version < 3)
+	if (!xfs_sb_version_has_v3inode(&mp->m_sb))
 		ip->i_d.di_flushiter++;
 
 	/* Check the inline fork data before we write out. */
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 2f9954555597..83bf96b6cf5d 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -305,8 +305,6 @@ xfs_inode_to_log_dinode(
 	struct inode		*inode = VFS_I(ip);
 
 	to->di_magic = XFS_DINODE_MAGIC;
-
-	to->di_version = from->di_version;
 	to->di_format = from->di_format;
 	to->di_uid = i_uid_read(inode);
 	to->di_gid = i_gid_read(inode);
@@ -339,7 +337,8 @@ xfs_inode_to_log_dinode(
 	/* log a dummy value to ensure log structure is fully initialised */
 	to->di_next_unlinked = NULLAGINO;
 
-	if (from->di_version == 3) {
+	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
+		to->di_version = 3;
 		to->di_changecount = inode_peek_iversion(inode);
 		to->di_crtime.t_sec = from->di_crtime.t_sec;
 		to->di_crtime.t_nsec = from->di_crtime.t_nsec;
@@ -351,6 +350,7 @@ xfs_inode_to_log_dinode(
 		uuid_copy(&to->di_uuid, &ip->i_mount->m_sb.sb_meta_uuid);
 		to->di_flushiter = 0;
 	} else {
+		to->di_version = 2;
 		to->di_flushiter = from->di_flushiter;
 	}
 }
@@ -395,8 +395,6 @@ xfs_inode_item_format(
 	struct xfs_log_iovec	*vecp = NULL;
 	struct xfs_inode_log_format *ilf;
 
-	ASSERT(ip->i_d.di_version > 1);
-
 	ilf = xlog_prepare_iovec(lv, &vecp, XLOG_REG_TYPE_IFORMAT);
 	ilf->ilf_type = XFS_LI_INODE;
 	ilf->ilf_ino = ip->i_ino;
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 597190134aba..e7356e527260 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1299,7 +1299,7 @@ xfs_ioctl_setattr_xflags(
 
 	/* diflags2 only valid for v3 inodes. */
 	di_flags2 = xfs_flags2diflags2(ip, fa->fsx_xflags);
-	if (di_flags2 && ip->i_d.di_version < 3)
+	if (di_flags2 && !xfs_sb_version_has_v3inode(&mp->m_sb))
 		return -EINVAL;
 
 	ip->i_d.di_flags = xfs_flags2diflags(ip, fa->fsx_xflags);
@@ -1638,7 +1638,6 @@ xfs_ioctl_setattr(
 			olddquot = xfs_qm_vop_chown(tp, ip,
 						&ip->i_pdquot, pdqp);
 		}
-		ASSERT(ip->i_d.di_version > 1);
 		ip->i_d.di_projid = fa->fsx_projid;
 	}
 
@@ -1651,7 +1650,7 @@ xfs_ioctl_setattr(
 		ip->i_d.di_extsize = fa->fsx_extsize >> mp->m_sb.sb_blocklog;
 	else
 		ip->i_d.di_extsize = 0;
-	if (ip->i_d.di_version == 3 &&
+	if (xfs_sb_version_has_v3inode(&mp->m_sb) &&
 	    (ip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE))
 		ip->i_d.di_cowextsize = fa->fsx_cowextsize >>
 				mp->m_sb.sb_blocklog;
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 757f6f898e85..a7efc8896e5e 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -517,7 +517,7 @@ xfs_vn_getattr(
 	stat->blocks =
 		XFS_FSB_TO_BB(mp, ip->i_d.di_nblocks + ip->i_delayed_blks);
 
-	if (ip->i_d.di_version == 3) {
+	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
 		if (request_mask & STATX_BTIME) {
 			stat->result_mask |= STATX_BTIME;
 			stat->btime.tv_sec = ip->i_d.di_crtime.t_sec;
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 1c683a01e465..42e93779374c 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -110,7 +110,7 @@ xfs_bulkstat_one_int(
 	buf->bs_forkoff = XFS_IFORK_BOFF(ip);
 	buf->bs_version = XFS_BULKSTAT_VERSION_V5;
 
-	if (dic->di_version == 3) {
+	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
 		if (dic->di_flags2 & XFS_DIFLAG2_COWEXTSIZE)
 			buf->bs_cowextsize_blks = dic->di_cowextsize;
 	}
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 884e0c6689bf..84f6c8628db5 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2879,8 +2879,8 @@ xfs_recover_inode_owner_change(
 		return -ENOMEM;
 
 	/* instantiate the inode */
+	ASSERT(dip->di_version >= 3);
 	xfs_inode_from_disk(ip, dip);
-	ASSERT(ip->i_d.di_version >= 3);
 
 	error = xfs_iformat_fork(ip, dip);
 	if (error)
-- 
2.39.1

