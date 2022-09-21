Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39F0A5BF44D
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 05:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbiIUDYy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 23:24:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230326AbiIUDYw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 23:24:52 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0120111A18;
        Tue, 20 Sep 2022 20:24:44 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28KLOc9L002100;
        Wed, 21 Sep 2022 03:24:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=t6zN8lVUcgIC1obRfKqOihaMOpQBdbP5l0hIdOAn7D0=;
 b=xJPWHmT8qpzZSe9MuCRoBE51YwxhUCGxaEHdUbKcdSmvqTuWKb8GoGOQcAcrymTE+ux1
 83Qp/AfsNG/GVMjJpxD3DPBPQlaYBNBSqTj+gZC/68gBUzsSmMbRX8HrwbgIGY41EE7f
 CUk1GGLrd7+S2aFRm0rQ6y56cEAS76vD728hbBCJJ0X7lwhlFc2CMjnWpn3SJQxwyMPO
 1Fx/N/PMYaLbB31zZTL75SQLDDSnMv6QDzhUazgc1VZ3Sm/YQllZUVbzjsfNE9kzTMQL
 Ujt+Uns02tn8ey+FkS2n9lWIUudRtrEFmQc3/qSKBgbsSQoxVF7smxWpn10WCpl5QYuQ EQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn6f0gpsw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Sep 2022 03:24:40 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28L1ADoe035681;
        Wed, 21 Sep 2022 03:24:35 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jp3d2yuj4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Sep 2022 03:24:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dOKkdxbuNQfpebshvn3fgNZMRP0pFyB2ngPmOeVRVzurVRc28vAXNqbG8vN4xDkU3rckS7nsg9ONXXD8hhwIv5ovJ6/Hj2x4cBhn0VWOZG5nIh+JvKExQqRbudgIwbtr/3QgYl/x2eDApk+FN3VwVmtHo/qPyLZoxM4pz2GNyweBtH19/wxOzW7S2MDErClprFGcY3UfHo0lIUL3P/VJFt3i9EgUn4Tw6EWPz9rJ45t828QOL6kQfZC4eVd3xjnWaq0reUDVupxQF7S0eNcKC+tsvBbac+1rxQ6nNYmCR2wHlBWRvCzcvADml3xBcFUvdBownz5QUyBuPCGuo0zkaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t6zN8lVUcgIC1obRfKqOihaMOpQBdbP5l0hIdOAn7D0=;
 b=b+LNODM7/fIdGQN0H1YhN8m6B3qqXwuYDMS0U1i+chKhXsKXi5VC3Z+wi0QzPI1uDQVxARVC8PG3g8Lp5+csRuJA/4uBhkj13/KnepxPuKnrdsg1PtbgvogeKXVNRTgZcai20vQwf+Fqmnp5jFjh5UjaXfPQpEavKqhni4lO2ihR16WIR7GxQFC62oD7i+GYCR6bVIpDxPTPTkvBBCvRJXI9HeoxsQ7cyo8slkQMcYfbnHmcxx2Xq5lCgu1vl5fJdMu9L+/O6QUAiTG5qlpkYSIU97xuXqPy02r8onrKvBJeF7Y8qGJRcdeNZ9TNwwgDhGWWKLLUNv5rlTDvPrJQpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t6zN8lVUcgIC1obRfKqOihaMOpQBdbP5l0hIdOAn7D0=;
 b=m1sbppe5P/PdD06n0VFxNZ86y/cFCvPYHCHsNLPI2PbWL/7hNRK7K3u3r8BVs7qEQvl9HTHKTG6XpEK5c1qAuABJ1o5K3dOST7w8tq94m0jbWk+Na9KCJ1pNCvtvTE9OkbMN8o4VX+MGMHtdLsF4uccr6jO52ySmiuTNiTrj7es=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by PH0PR10MB5579.namprd10.prod.outlook.com (2603:10b6:510:f2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Wed, 21 Sep
 2022 03:24:34 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%7]) with mapi id 15.20.5654.014; Wed, 21 Sep 2022
 03:24:34 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 05/17] xfs: add missing assert in xfs_fsmap_owner_from_rmap
Date:   Wed, 21 Sep 2022 08:53:40 +0530
Message-Id: <20220921032352.307699-6-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220921032352.307699-1-chandan.babu@oracle.com>
References: <20220921032352.307699-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0004.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::23) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH0PR10MB5579:EE_
X-MS-Office365-Filtering-Correlation-Id: 6625551e-b7d1-4e59-1b10-08da9b80cdf1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1fPcI1qS6LlMmpT1oeGPlgZTlq+ze65rxySUhTId+kDNy0Uq/GEFjtcTaz9DmmUYErc2TI++1RyPhO/DJqHopVvVHr7bGzVa4hK175lG2mBYcw10k4Jq3bgTKqA+w4ImGsKbsgSfnpYN1QZVoXbJUvKC0cFoGwvX2qRiPAevo2KkpG9pif0r/X7tJkseMaCXyt/Rd5G7wZoBQzaSD8LOs4oKh25NqcDyd3MXRGL+1Big9QaQe12/nTYTv1CednTuoVgq4BGgkTTRVXuNnQpw+4TLetltIu4+msxa5qeaaamnr6CiO0OZydkbgLmzr3VQSFXCdaIWdWezLhgFYTBcEiW8Pki7kHiTNsBPQKAawj6Sx9nwxoDluHTy1rT7IRs6i4+9gsF7RQmyOpdBV+lGcAYgnjkrbKzRHdrRuoxqE8LaaGqSWWniE53eatoZsRg2x4aLRmdymzjpKryzSnVDGEvgf9qvzohmlR6Insi60SfUkNdHC1ObgaxhhlZv1vrZi7uGxexY7wk06FtmcY2ydP0WT0TVCWPynQabeTSc49zUrhtMtJ+ZC1eK+PtvA2u12f33Dlcx7Q/KU0vBn/v8LeoNpuYXD1MHl5XttLS445wxzy0dbp/thEpOQsZeCC0y39BeefRB2r4RiG6rq8HZEMKZFBC0xV9H9FdJEe5UUwX10qL0gb1y78Gv89Rjuuv5PLTLsRpMflMJGSDVQBtSJA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(346002)(366004)(136003)(39860400002)(451199015)(2616005)(41300700001)(186003)(1076003)(2906002)(4326008)(478600001)(66556008)(66476007)(8676002)(4744005)(5660300002)(86362001)(38100700002)(316002)(6506007)(8936002)(66946007)(6916009)(6666004)(6486002)(6512007)(26005)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?geUhCjgE1jO2kXC6vawWQEBrxIuMwvZRAmw0wSEfXsDy/6tU55X6kHYwpO0p?=
 =?us-ascii?Q?4ds2HDsbCOcazlPjsFPj+2l7/Pfvt9RAe5Skdj38Ht2L4tgHMGKoZoIw1AkC?=
 =?us-ascii?Q?CeRMTRa5okLray0KzR0WlLPLvn4x9IXTpo+u5+F7Z0U05yxoqxRqPooy58XV?=
 =?us-ascii?Q?LZupKUqEqXPg/KD107fdR8jUBEzFnotZQiOk7/q6452biBBRhZrOUgWK0zUF?=
 =?us-ascii?Q?1K8E++nE3sKb7EcX2c2Cot1YzznG+fyp7d2TY9rFgdf81h02zo/a/8H1DSsO?=
 =?us-ascii?Q?TF+hsjPlT84vEqwqR2Ev30TUgYLNOOXGZFvMVDNqiMuwULMgoIax9GQK+P/J?=
 =?us-ascii?Q?9wGeKAjV9PqaEEHaKGFJYNwCF0+qKgdn6JIZHajHXmOaN7SWbdXLpx0EwXfP?=
 =?us-ascii?Q?KZLDPWOJ6kUsV554aZrmlDP08pbcWJIOEQ/PnBNV1vpNanzZlX/FEHghEydv?=
 =?us-ascii?Q?J5+qvNLgIB0DU2Wqm7NiDwCpFLpO8+4I3k4fplT6b3Fd4Epew4iM7cewbr95?=
 =?us-ascii?Q?8kPkLLRbSqPIVuto6PpmklwSlx66VHEAY92hA4Hqw2a/TwRNEoPgusf9koct?=
 =?us-ascii?Q?tnnM2eeP5y5E6UF3o593f6Of+sSqCWxhhbAuohsrzeovcbXqBnTkgONrmAZc?=
 =?us-ascii?Q?+mOxpDtqWONC9F0nJAOogYririfoluRJOYX/c0kzoUIx+2uaoEsnDUcA5Oyd?=
 =?us-ascii?Q?3ehV3/DnBv53DJ2YsXG6Z+CjbdiA3TMMmwbCsIG6PvUK4iTTnjZuxtC7ooBI?=
 =?us-ascii?Q?Y9jk0pS6KeQdoKhaJ4gOqFCSAe+/eIaYzNBZSHKaAJycmdXl0SeXXuKvZz4S?=
 =?us-ascii?Q?fm46ewXNMGBapsD5atIB9zZJ6Tb13r8pbDg80qxT2Y+al6SxeoEAq1zQus1r?=
 =?us-ascii?Q?RqqUx9kbMY1TinoYRikIJqcQkaRZTc8ewyWnzfi0CAV0BlBWeM3sZYKOU2D+?=
 =?us-ascii?Q?OmzH7xM46WhMdHJtrRfJIIggdiowW1vvkobHMI2u+HI1DUdbBkdoXSis2Exk?=
 =?us-ascii?Q?aVhGFaJkXgSLmPxtl6AV+1C0VLyq34Pvon/nbAoqql1xckMk/+vMIY6Hh93S?=
 =?us-ascii?Q?SNBkR5wmIl1S+6fMLsqDkEC694bD9idVvncRien5+nI65XU9G8XDRsZFSTRu?=
 =?us-ascii?Q?y/WaTtd0L8xAoEtKz0XH8n2k4OVReuJ2rK2xtXjbCB9ddP1pWQCfV9Iz+tBM?=
 =?us-ascii?Q?jUjOLlZ8lnJHPW5FsaiorcqzLVGqZ3k9ytRNAL/cEgxVm9RU9TDAt/hbL9Po?=
 =?us-ascii?Q?k/Qpfic/+imVxGb+6jBru1Y053pp5QGKzMBWcTI6TwbE6eRs63cVQkRf+Kfn?=
 =?us-ascii?Q?fFr5pVRoVQH76hay4rFvKCi1yhGE/7i3pU2kMbkgrlH3YDTpzBmejY5LdGHO?=
 =?us-ascii?Q?RP0Lc7f5FlTr5khLR3kcf1yxtIBK2z77g8ArlY3Zj3cZJJNejHXJ9wvs8erU?=
 =?us-ascii?Q?OeopHNCnBtmv3Hav3/RRXjj61QYdNMJVS3XFdnkaC/H0lyq55UVo8Kr8OOkZ?=
 =?us-ascii?Q?dpsydZB3ADTDsJI2N1fY+5pviY8ujRk7zAqm3WHWWV6bbQWCR2zRDxLi5ucy?=
 =?us-ascii?Q?P9gLoTxk4Z5+0duO1SNodGLYLUFWgHS98MrK79DsKGT7D8TEsTAseS7n1ndo?=
 =?us-ascii?Q?/A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6625551e-b7d1-4e59-1b10-08da9b80cdf1
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2022 03:24:34.0533
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bENgcgNdQLwG1Xd+JcE76juivwUOqjucMLpqwaeTWAm8WVNMNy8d4bKCTIpiNh6AZKuvQK9DA39gDp6nnxvbnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5579
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-21_02,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 bulkscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209210020
X-Proofpoint-GUID: ZfLTBmtJ9dn4aYnkYXbOV1kth9AgmYCU
X-Proofpoint-ORIG-GUID: ZfLTBmtJ9dn4aYnkYXbOV1kth9AgmYCU
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 110f09cb705af8c53f2a457baf771d2935ed62d4 upstream.

The fsmap handler shouldn't fail silently if the rmap code ever feeds it
a special owner number that isn't known to the fsmap handler.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_fsmap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 01c0933a4d10..79e8af8f4669 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -146,6 +146,7 @@ xfs_fsmap_owner_from_rmap(
 		dest->fmr_owner = XFS_FMR_OWN_FREE;
 		break;
 	default:
+		ASSERT(0);
 		return -EFSCORRUPTED;
 	}
 	return 0;
-- 
2.35.1

