Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD986DEA83
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 06:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbjDLE3o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 00:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbjDLE3f (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 00:29:35 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76FDE4EDC;
        Tue, 11 Apr 2023 21:29:33 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33BLO3kO018057;
        Wed, 12 Apr 2023 04:29:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=3Lxvd/d3Xdv4BUNys7uGNKRBFbqm9f9n4Xfh3aeDGis=;
 b=QIf9NcBypDtYPSnMdKWr6Bpe1k1nx/TqNq2MAwqJesTFwNxGk8sYFeib2YOMFfDXx/4X
 7H8nQq1Bsrp5dhu7Q1OVlq/YtaPCgdM75scJA8jv+I1UCCn3FhTLQ4AHpJfUqjZ2QNFQ
 Roaq4LMvJgFqerUgOTRKgivxXYYyqS8xk67hJotc0pXNagbs++1gbZERS0qkgAhaaygA
 jgoqGAcZT7E6VpS2BNdTB7YEgUZm6RNetD8jDVV7dcoKgWhr6gAcbK1EAtbAs//d8s3F
 54UooLu4slVDjsslWu06cpzUhUkiwe7K9U1Yy0gquODjgv40h7BYlxEl+avDOUgggRO3 6g== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0etq0x0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Apr 2023 04:29:29 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33C2CBdX024980;
        Wed, 12 Apr 2023 04:29:28 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3puwe88pk3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Apr 2023 04:29:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DT4eyByMdyNnKRzxydfPWslyFLCVRVaxDfNwnS54qFp15Mg6fCasB8TctRM9m2zSjT8RSuOJMlunhEXWzfy8mJRPoTuy+NpP/EP+3QeNSYTE1zeohkjdcRjiaTP67JQ0kiTFiu54Q74sY2ukUvyAQGTN64EdvJ2AnWyrHlbZr91CqWROTODyxBLnZTPE2KnsIjwhSU37H8Gl3vLBwCMm4Uc/fRVEdhk0IMH1KDO2T9NZasrVoQ5HNSHS/T7YTyD+QCKuPyXOZNRPERiiFACOOWZzBYIVWh5nP4kJf1m0W2rLbKRz1ibWzCG7N+y673mMv6tO0ifjS4BamLl3qXiG1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3Lxvd/d3Xdv4BUNys7uGNKRBFbqm9f9n4Xfh3aeDGis=;
 b=DC0J5xwm6Bcq4gvBcOD/uE9KYkPG7oK7bhnBJYtZpiKlwC+A22T/stEVgdx7Yu2w7WDnwE6hPF8wj6P1ssRjK2Fzrp8sP/2vJCUh0tHH0liZB5NIouluO6XJZz/t8iAtjTzAGkcxi45hMGijDr6VloO7LtqPN9xHWQaoU//VxPwmgU4yc5LFjEpnyJvPE8uEsfD4eiu/FBh+D61Je1MoCnvWWJ5DkshQzTLxuF2248b4PcBIpTCt2gy3KW2UymyI2/zo4ohIH7DORb00/plNFn30BtBBJrXq7gwX3f1G5cuk5ZKVwJ8ammdYUQMSifQ9/xfZlsV8YmN/IeCLY65/Qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Lxvd/d3Xdv4BUNys7uGNKRBFbqm9f9n4Xfh3aeDGis=;
 b=tAO9r7nvdD6YKDWJ7tfk8zo+BhkqCzqnaElDno8ONGv+SZKbIt7g4DXAnpqaSZnQ/uV+Ht2rzdoAQ1ZMML1nO6tCfwHSrpgvYZ0WFk9nkHyWlKmMkJ7Qrsu5T7jaP9TzqXhf0xEpAPJA+82GiHfPqod5dFeTrcr7IKMZ6hPOxHw=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by SJ0PR10MB4559.namprd10.prod.outlook.com (2603:10b6:a03:2d0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Wed, 12 Apr
 2023 04:29:25 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7%3]) with mapi id 15.20.6298.030; Wed, 12 Apr 2023
 04:29:25 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 17/17] xfs: force log and push AIL to clear pinned inodes when aborting mount
Date:   Wed, 12 Apr 2023 09:56:24 +0530
Message-Id: <20230412042624.600511-18-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230412042624.600511-1-chandan.babu@oracle.com>
References: <20230412042624.600511-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR0101CA0040.apcprd01.prod.exchangelabs.com
 (2603:1096:404:8000::26) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|SJ0PR10MB4559:EE_
X-MS-Office365-Filtering-Correlation-Id: 30c84f79-a748-4970-4ae8-08db3b0e7f4b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PMhOJ7yg3VBssubBgmjr8oZ8ax/apCrSrSXUzciaT9vPwH+1qVXFFo/R/ow4uwvD9ie5forT8ypRNff+NTU3CUD+62h8ZOltMTPh2eHCyaQQy2A9H5wD2Fkj/9THUm+f8gUotQA78/hbl/RfRKzASrMD/62RuTsmn7cpfm3hYrE5lu2aJEa3JPDrcMUlxnUUqkIRa5kicZRAf6HiFEjUT87QXwrQ8QgGn6LCnLdSarXcB066JSQXhXBqc2Nh3/yBShNxA9u2S7YDONkHANF/v2RvbJUhHVWLou716nWV1EPsPJDA3gPrTh/Uu3v5NS8HI6S+ECWfc+hr5OnIKMenkvJkunty1YSmScot0AxbDowfJV8Ncm1zUjxMaoDUBYjWXtOpQKn0Zmg9rIYwDq68urCioxi3eSkEMfDLE3dZ3q9SBLLYh+xzzh3wYq9NF/Q+5KUnj4sW+qZyXcVnBtShA2rteJICaDKeSR3G/R9oUhoHT+l+tT4hJ7GM1L2/+BenCvUypJfGZgqwaR6BV3iogH8yYuHnos1QDNUFW4PSUkJaRsMPjpHOR8y75VCNJo1/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(396003)(346002)(366004)(39860400002)(451199021)(8936002)(66899021)(6486002)(5660300002)(86362001)(6916009)(66476007)(66946007)(8676002)(4326008)(66556008)(478600001)(38100700002)(2906002)(83380400001)(1076003)(6506007)(6512007)(186003)(2616005)(41300700001)(316002)(36756003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?R0ot9eeamlOH5wGXxcjzb/vKHYjFm564m9edlCEepTBkF0hFK8/i56TuFi5g?=
 =?us-ascii?Q?RrCKlWdDyl7W/5kcTi2dEd8rUE8XU7ek1xE69cUijP+knMRPTD+OzT7CDa6N?=
 =?us-ascii?Q?zaRY+1+X1jFUAt28UWQXGDMSLA7R/lVKScxNds87PHFNyFFmqrUa/MQfLL2n?=
 =?us-ascii?Q?grPNYy1irwQ9auJpjMntC//RTLf5oowt2yRPvCWcBZXwIAPKGhxXWJDXZpFu?=
 =?us-ascii?Q?boTN2+q0lJhskOSqI1AGDJ7e/eGyKb2M0H9Cgm2Ub7Xe9XDestL/mJ9iI9hV?=
 =?us-ascii?Q?dKj1SsiJS/CAm4gl4a16Q17Zs9HTVhtI5xM6I3oncc9Ao76vOHDRMt+2nIKv?=
 =?us-ascii?Q?sxp8EcB540NihAHFLyi0diqrrpQz//0LO7koU70ymQklTqmhJDLW/+ErSd4E?=
 =?us-ascii?Q?wRto5TIxAcJq60Dg3+FSLoq3Ks/YrRzuKcBZQjWGUCQz+3a7jvU0aw2cInX2?=
 =?us-ascii?Q?LAOQCKMp2ZvhVxRmez4GVN3617EK2yKKWqyNOMqKpBRb5CkmRZygj/6eNdCm?=
 =?us-ascii?Q?u8MjpCpb9T6QB8K2+yBJSNAzkXHqHQwntfFZbsZqe+7OvLQQZ5s4Lsc3HtQn?=
 =?us-ascii?Q?BCA4saQ/zFp+Jr70KAyi5qwTbyC5w9m1AcUoqCRyFjZSzxryoQaUgCn6MSQt?=
 =?us-ascii?Q?EKyvK9U6imYkK33H5BZjc9iGg92y9Bq5c+7D/9qqhsr+KoSvamLcYRxW5XjD?=
 =?us-ascii?Q?4BB6ga/GSLkngUv7IrzZyEGnjpyIHg/nGxjpnzvLJLGVI2lBES/FxUhRwG1P?=
 =?us-ascii?Q?UCtOoflNbMIS5XK5p2n0F9dJtCn7dBPeVlhMK8BJcLazK+hIdiP2ZsimRREk?=
 =?us-ascii?Q?OlW9RrKs7bivIUH8azEYD7c7pzwVSm0lrZLZfhyqPz/bIAmzgsmBATFY+kIA?=
 =?us-ascii?Q?yFpE5LOC/MicSdipI9EAoN2mIKnGcuXbiD3yhERyO2kc0jGhDqcT1fGbzZz1?=
 =?us-ascii?Q?gCLI3AaMnes+vAaA8oHjq5NBxHjTwH3+8z2Vf2w+UqezIKi6RpH7BVDZHr3T?=
 =?us-ascii?Q?j1uhORcyMYQU+Rzee8cJrAvViu0sPBzOzDndZReW7MELiAvwJ3I7+1MBWRon?=
 =?us-ascii?Q?5W/0SvrCYlf8OSwGs+2T5UBsbuNEx833z+gYMxhtpV/Aj9dXBKLJQscxpcnH?=
 =?us-ascii?Q?cMHpOWwUArJI+onXGDQVYvVjXvm141eu/fbKTF75WVF3NoZe9FaoBzm31SnU?=
 =?us-ascii?Q?CA5klJnq9H9zyrwi4gOxnmFWOLhby08zl443DvR5ifcGs00dGEfvSKPZeAFj?=
 =?us-ascii?Q?JeZq7EtFdnAD6Qnu1Q13Vtdgc+o7rbc5V2wwyA79ZrpWDYM/plzDYqkgubGd?=
 =?us-ascii?Q?mOyImIgFex58U3sgSEq99YQ9YGtzR+bnCR0ecw3jN8FFWrzz6L4VNmlsKuBQ?=
 =?us-ascii?Q?LbhwOUFZB2A+DS6JuUy4CD/wzZh8JbpB0Otriyguar2f2eI9eA/b6l7Wewgc?=
 =?us-ascii?Q?55RgdYPhVAsrUUZ1n1xe6R9WoXMOgXJlCyvPMTfMgbBQ5EEEcsOUIvVHF2TI?=
 =?us-ascii?Q?9ldnr56hjUZl2zJj+8X9ssJN2w4ZhOWLGJLgwHuibSO8euzV1JovCPAfACbJ?=
 =?us-ascii?Q?Yu7hMnotXLplfHB3Yp9TC/q3jJCcCkiiLGjpaGBBDOOjNHjTc5Y02XsLrdmJ?=
 =?us-ascii?Q?eQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: nPMk3+3P1VqDiZJrAsOB0dWKu+DucB9Dgo2mYHHMNvkEwDPf4cMM55KYtRtchG/nD1T4h+NVmoq2qSB6uL3OKa84rsy5BTIEBlVs6fXZKFuT6scdtBcmVfz74fumaJSgLClc4dqIpTA9Ht068ql9f+06iAPbheSGYS2L5LLrXS95OTWRPgUXDc+6YVZE0hcMGm9BfLf63Qa9s2XTYKRrS6OGt0Pw6Vfu5ZoUjnAUPrSKybovnDuB2oCtb+1bStiuhv0nfheJJY4zb03rh75zlCSZSjTQOgUcWFA5sfEhPe8/xACockYsT9idBWHChtbjsv820MUTuHjkcptiMsBJyPGWkuYHkGkSdq6rHq2PvJkq5xKDxxNs8VJ4BYjMS+0NzzfLU3CA6C3YG010D1Anbnh2lUw+GNZixfyPC/IUFg8YxFaHT8JAHj6Qk6//8BvDXINjI+TGhjI7AXeSXQckz5ziyVNo2S9lFMNLfwGaIzS/VyxTCgB9Mv2hjWBjSsHp+6OzSHVk/NmZvk5x1V07Yq/hG2KbHOSVj+tgeoQ3vBdZOTfgNBoiDOhAVHtGvJP9t5ko2emsSEicMvV6juLEBESTrsjIZmIujLpTXH7RiTR3G68Garlo0Sr4QVclz9fKWJxJUUm9j5bQgTpwIMsVlYroSWQrUZs9RubhS4sK2h9lrs8pghlVuIDUooEvq1alF2nnb3GAyfdGrcLgvIszi4n1ggsUVpfCqPMozEOd2YCZVZ5exJ/HVDnkA3kHVGztf0Qxbb39HNB23w4TGfztut1TSa57Vzw/8DEHWb76j2frnX3xcDiS5gZyo34NK808KzIOPBPetLQNCSsCgyVqJTRMoCjjdf/vWUjok2JN7PXgZd3AY9Frs6GdmDkHqpkk
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30c84f79-a748-4970-4ae8-08db3b0e7f4b
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 04:29:25.6342
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 26y1FBKwqJBdS78vEskl8chtqEfPY4oFXQkYr6JCI81XFQw3sM4iHvKCBLNphQfbxRP7Dob+0GiIaYX129o3Zw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4559
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-11_16,2023-04-11_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 adultscore=0 spamscore=0 suspectscore=0 bulkscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304120038
X-Proofpoint-GUID: xiO__lEY_HTOFwWmtrKOtJPpeMEvHXxA
X-Proofpoint-ORIG-GUID: xiO__lEY_HTOFwWmtrKOtJPpeMEvHXxA
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

commit d336f7ebc65007f5831e2297e6f3383ae8dbf8ed upstream.

[ Slightly modify fs/xfs/xfs_mount.c to resolve merge conflicts ]

If we allocate quota inodes in the process of mounting a filesystem but
then decide to abort the mount, it's possible that the quota inodes are
sitting around pinned by the log.  Now that inode reclaim relies on the
AIL to flush inodes, we have to force the log and push the AIL in
between releasing the quota inodes and kicking off reclaim to tear down
all the incore inodes.  Do this by extracting the bits we need from the
unmount path and reusing them.  As an added bonus, failed writes during
a failed mount will not retry forever now.

This was originally found during a fuzz test of metadata directories
(xfs/1546), but the actual symptom was that reclaim hung up on the quota
inodes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_mount.c | 90 +++++++++++++++++++++++-----------------------
 1 file changed, 44 insertions(+), 46 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 2860966af6c2..2277f21c4f14 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -674,6 +674,47 @@ xfs_check_summary_counts(
 	return xfs_initialize_perag_data(mp, mp->m_sb.sb_agcount);
 }
 
+/*
+ * Flush and reclaim dirty inodes in preparation for unmount. Inodes and
+ * internal inode structures can be sitting in the CIL and AIL at this point,
+ * so we need to unpin them, write them back and/or reclaim them before unmount
+ * can proceed.
+ *
+ * An inode cluster that has been freed can have its buffer still pinned in
+ * memory because the transaction is still sitting in a iclog. The stale inodes
+ * on that buffer will be pinned to the buffer until the transaction hits the
+ * disk and the callbacks run. Pushing the AIL will skip the stale inodes and
+ * may never see the pinned buffer, so nothing will push out the iclog and
+ * unpin the buffer.
+ *
+ * Hence we need to force the log to unpin everything first. However, log
+ * forces don't wait for the discards they issue to complete, so we have to
+ * explicitly wait for them to complete here as well.
+ *
+ * Then we can tell the world we are unmounting so that error handling knows
+ * that the filesystem is going away and we should error out anything that we
+ * have been retrying in the background.  This will prevent never-ending
+ * retries in AIL pushing from hanging the unmount.
+ *
+ * Finally, we can push the AIL to clean all the remaining dirty objects, then
+ * reclaim the remaining inodes that are still in memory at this point in time.
+ */
+static void
+xfs_unmount_flush_inodes(
+	struct xfs_mount	*mp)
+{
+	xfs_log_force(mp, XFS_LOG_SYNC);
+	xfs_extent_busy_wait_all(mp);
+	flush_workqueue(xfs_discard_wq);
+
+	mp->m_flags |= XFS_MOUNT_UNMOUNTING;
+
+	xfs_ail_push_all_sync(mp->m_ail);
+	cancel_delayed_work_sync(&mp->m_reclaim_work);
+	xfs_reclaim_inodes(mp, SYNC_WAIT);
+	xfs_health_unmount(mp);
+}
+
 /*
  * This function does the following on an initial mount of a file system:
  *	- reads the superblock from disk and init the mount struct
@@ -1047,7 +1088,7 @@ xfs_mountfs(
 	/* Clean out dquots that might be in memory after quotacheck. */
 	xfs_qm_unmount(mp);
 	/*
-	 * Cancel all delayed reclaim work and reclaim the inodes directly.
+	 * Flush all inode reclamation work and flush the log.
 	 * We have to do this /after/ rtunmount and qm_unmount because those
 	 * two will have scheduled delayed reclaim for the rt/quota inodes.
 	 *
@@ -1057,11 +1098,8 @@ xfs_mountfs(
 	 * qm_unmount_quotas and therefore rely on qm_unmount to release the
 	 * quota inodes.
 	 */
-	cancel_delayed_work_sync(&mp->m_reclaim_work);
-	xfs_reclaim_inodes(mp, SYNC_WAIT);
-	xfs_health_unmount(mp);
+	xfs_unmount_flush_inodes(mp);
  out_log_dealloc:
-	mp->m_flags |= XFS_MOUNT_UNMOUNTING;
 	xfs_log_mount_cancel(mp);
  out_fail_wait:
 	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp)
@@ -1102,47 +1140,7 @@ xfs_unmountfs(
 	xfs_rtunmount_inodes(mp);
 	xfs_irele(mp->m_rootip);
 
-	/*
-	 * We can potentially deadlock here if we have an inode cluster
-	 * that has been freed has its buffer still pinned in memory because
-	 * the transaction is still sitting in a iclog. The stale inodes
-	 * on that buffer will have their flush locks held until the
-	 * transaction hits the disk and the callbacks run. the inode
-	 * flush takes the flush lock unconditionally and with nothing to
-	 * push out the iclog we will never get that unlocked. hence we
-	 * need to force the log first.
-	 */
-	xfs_log_force(mp, XFS_LOG_SYNC);
-
-	/*
-	 * Wait for all busy extents to be freed, including completion of
-	 * any discard operation.
-	 */
-	xfs_extent_busy_wait_all(mp);
-	flush_workqueue(xfs_discard_wq);
-
-	/*
-	 * We now need to tell the world we are unmounting. This will allow
-	 * us to detect that the filesystem is going away and we should error
-	 * out anything that we have been retrying in the background. This will
-	 * prevent neverending retries in AIL pushing from hanging the unmount.
-	 */
-	mp->m_flags |= XFS_MOUNT_UNMOUNTING;
-
-	/*
-	 * Flush all pending changes from the AIL.
-	 */
-	xfs_ail_push_all_sync(mp->m_ail);
-
-	/*
-	 * And reclaim all inodes.  At this point there should be no dirty
-	 * inodes and none should be pinned or locked, but use synchronous
-	 * reclaim just to be sure. We can stop background inode reclaim
-	 * here as well if it is still running.
-	 */
-	cancel_delayed_work_sync(&mp->m_reclaim_work);
-	xfs_reclaim_inodes(mp, SYNC_WAIT);
-	xfs_health_unmount(mp);
+	xfs_unmount_flush_inodes(mp);
 
 	xfs_qm_unmount(mp);
 
-- 
2.39.1

