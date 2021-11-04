Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 094204455AE
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 15:50:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbhKDOwu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 10:52:50 -0400
Received: from mail-mw2nam12on2120.outbound.protection.outlook.com ([40.107.244.120]:26784
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229920AbhKDOwt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Nov 2021 10:52:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X566hvE+hJT0B8Ssss1Xo2SRz4Ctysy/CU1KtWVBb7tXx4sh2vqY3qtDLbCAIHnLLY8BXCJkrssv9AXDATQ8SZSsVYTWqKQIbMDfNIQ8mCfbySQZ4uUVQudtdRgMBbuCSAqLa7w8FlK0F5+Vj6VwgL7w6n3gMcNEQNTxPYEAzmCI8GOAtXIORz24QZCvfXVpRQEk8CbLd3wUMtELAjhceAMkeTYi0YUwwEqnRbs16tmQxL3Yb7E5mIMQT089iKA8w2Hm6cJNUAk+FR2X3l/oiAF+osXIe3rG70llrWmksQSeKv4FHYoTD7KRHlY2tKgAgjJOE/sk5o9/YmfzMefq4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ht6f4KyyhqrR2pGZ23VM31G/jZZjm0i3+CuPke8JXLM=;
 b=Dq7mTtUqaWI6lX5AsXO2QS0ztXi4EcIZJZyS1ETFncG0LAJMUlCPGaddlIS3In/G8oNhq4/oT+zJRDx/3f5jPnKhU4WfLdlJ12+8sF0rOcUrpOZq1lvrnRbxfWYfp7FqM76vI4S6+Ha8soX6U/mzPdAdd9ZLbtDvqu2nUsUoqmI0BIfXEMKxAoaZMvvxie6Y7bXqLPAwSPbzZM9jAe/5PcwqOdCdd07wKLPN0MEiMr9gsYzJPVEk/uxWyOD0UBJd1LgYkKKC5Bd0XtHe0JH888YiB8khfpzN/sHRbpIcuZSWRY3YR6JC0VIvEfVnJPdQmmWuxSzWaDqZPVj2Pilt0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cornelisnetworks.com; dmarc=pass action=none
 header.from=cornelisnetworks.com; dkim=pass header.d=cornelisnetworks.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ht6f4KyyhqrR2pGZ23VM31G/jZZjm0i3+CuPke8JXLM=;
 b=c1Q63SPMASAUQLKzRKczRuvcQVw+iyf7X210MGLlCzsD69GOSfZDB1x6zObZ8K8e6z2x5viWrPLjIMMdGODAdh+ffqGsiODOTHiYsJ0uHOVLcxQvG/xjfY/988y2sHpF97+Jt56z2LZap8dkrhjx5ZTvltmG0B8Lkx3dFetsgC1MZwag5v2OfSzv9xFIXBQNIE4ONnvFlpWPOvy/vIVCqWiY9y06POKm9+Sgd0jniLEXLf4udHfktHCfthgp1jRrvqm30IS/hmUgqSJzRg5TqT4eFBt8BS9AZaWQvI2GiDn8s6vsRMtQ4AbqG96abNKs2RZsQQAJZ6Iw/mCa/+I/jg==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=cornelisnetworks.com;
Received: from CH0PR01MB7153.prod.exchangelabs.com (2603:10b6:610:ea::7) by
 CH0PR01MB6892.prod.exchangelabs.com (2603:10b6:610:105::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4669.10; Thu, 4 Nov 2021 14:50:06 +0000
Received: from CH0PR01MB7153.prod.exchangelabs.com
 ([fe80::bdea:4e22:1b89:24e0]) by CH0PR01MB7153.prod.exchangelabs.com
 ([fe80::bdea:4e22:1b89:24e0%7]) with mapi id 15.20.4649.019; Thu, 4 Nov 2021
 14:50:06 +0000
From:   mike.marciniszyn@cornelisnetworks.com
To:     stable@vger.kernel.org
Cc:     linux-rdma@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
Subject: [PATCH 4.9-stable 0/2] Port upstream patch to 4.9.x
Date:   Thu,  4 Nov 2021 10:49:59 -0400
Message-Id: <1636037401-89082-1-git-send-email-mike.marciniszyn@cornelisnetworks.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: MN2PR10CA0007.namprd10.prod.outlook.com
 (2603:10b6:208:120::20) To CH0PR01MB7153.prod.exchangelabs.com
 (2603:10b6:610:ea::7)
MIME-Version: 1.0
Received: from awfm-01.cornelisnetworks.com (208.255.156.42) by MN2PR10CA0007.namprd10.prod.outlook.com (2603:10b6:208:120::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend Transport; Thu, 4 Nov 2021 14:50:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 298168a4-07cd-491d-f3b0-08d99fa2641e
X-MS-TrafficTypeDiagnostic: CH0PR01MB6892:
X-Microsoft-Antispam-PRVS: <CH0PR01MB6892381DDF59A0CB862E20C9F28D9@CH0PR01MB6892.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:165;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YatRd+p2Ab+NZPHaX3Xy63KMXy2lps0P+pQiS6pBlU54eylmQxGNqL51gegoEatd9aGwkv+HjYP9omaSrp59aIJT153qTE1ucAXhXwvJ+RzEsJvFHL8A81JBY34rOzgC0rm4HIf7AtEZZP2/ytIrpJS0lZhj8sPUhVqMf16sTMcWzY3AiKIOX3ku/r6J0Wq79Q5lEoXdm/akc4/R0CxWflrfVfTr9P8ygD1Ug8UXNEOCdXDZwY2dSojQRbH2CrLKPU58MD7fz+yuvhdLBFHPlrUjDKd1EJ3bIiLgF7g05H4yMGvhNP9BbJM6oJrbJFkk/ZfHDuLADI4muIjx3D4vnI+PvOrQSMckmfvxJmcpUxLgvj2D+1JtD4Br1mEeNJ7D822lrzAcsiTINycXSpl3OYIaXvJrYqaSemuPmZi4O59OLM75ztn3PndcZxoxKZBczKS3mtZezG25Gcggu0qpd3PaZTc0lOEbwymirX4iFLLzxpCHuCEKol24Rp+mLJZaoMgPRf8zvipovcgx1SvvyEF+cHxdJloJP6aKrFWkG3MZBCxD1CyiwXhO7Bbc4rZiOOQa4hDPi71eahVW4neg5SU5FhBhMTTOx6Ot6d0GKFCok8lU8cGtL3/mR7QQe0jSy+EBT/7iF2ZbqD9fgb1IzBvGj6M5Ea5SRTdUTs8dK639S6pusxZWfn2iRamZzukX0KagnM7iSSqxeTsPJXtT6g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB7153.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(396003)(39840400004)(366004)(5660300002)(8936002)(316002)(508600001)(38350700002)(38100700002)(7696005)(52116002)(26005)(107886003)(86362001)(66946007)(2616005)(6666004)(4326008)(6916009)(956004)(83380400001)(186003)(2906002)(6486002)(450100002)(8676002)(66476007)(4744005)(66556008)(36756003)(9686003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?s3+7ZHUAf343kkOD6WIZCGEQ0MQzHtakA3FaBK4mKBN9getaPgxTg+gOwVnh?=
 =?us-ascii?Q?T6WCIF/7XL8ZMoaGTSnT9ZDDiferoNdujPSnraoiI3ahgEJjXfZEA6ra54t8?=
 =?us-ascii?Q?CtuIH23wq8VXMXZ5tIRq7XtiHNDTVljehDbdZKNdhwplyT0fiZazsH8VX98J?=
 =?us-ascii?Q?IfuqjmwjeSMByQTN2xjYZvMmDQ9xfFVWrDZDs4NTexBwYbZ5kE8yp2WY4XDI?=
 =?us-ascii?Q?I7V3WPfQGtfXXV6S5hwj9JPhiHOIkVM80/NYiaRgLPHnVk1cT1GI4/1ACVW6?=
 =?us-ascii?Q?lE9Nz2fcO6gzsLfX/PHXsnf8a+jhpmNhNJLoCe/7ss5sHgRUu/asyyl+rkFX?=
 =?us-ascii?Q?udIG0b1VrAIp6OX1/fC19if6RPibOCq2ksfAYy/CvDYpiiuxGCB6LT8cHm9o?=
 =?us-ascii?Q?XSMAfIMG1rvkQlNKYKW2MkHU/0aOwVVE66kPxyt7roVEu7vnBljk8qP29mrX?=
 =?us-ascii?Q?9pG+XAdNBsiRTwolK4fhvfdR+5Yk0asUYldpcPdxoIA1r5yyEL8DUOMavR7U?=
 =?us-ascii?Q?IvBwwxC7hA08ZhrZE6LhHUZ8hL84l5Nk4KWZvePd4Hul37Mz9BrOUAtxD2Ga?=
 =?us-ascii?Q?sllmFMUnzI5EUW9gty2WsmGHnZEScahlCKRVUiFc5VJ0dRn0DE1r4tVxKzEh?=
 =?us-ascii?Q?SIF6ilY2Ykxp3ZuDHoJXt0mhKCRNONOvINz8dpnQhJvcMGFlt2daze1UZpBw?=
 =?us-ascii?Q?bWgwvNjLR1gY5I2AUpwYDmGtyzHEJkAxj7N3dmCivoAfh/ov2put+jh7erY8?=
 =?us-ascii?Q?6/PbDjIS9VbSvZf0oMs2u/d/7zI7rHvFFRurdmgKPLY5EVQBNmdHrqenWlO3?=
 =?us-ascii?Q?MxLJ1rw3NF6G5su2ruNx0R/HklR+0J5ZkT0+INx1C/nkFEQdKKcT/RoYoi+F?=
 =?us-ascii?Q?ayykw7Lv+R2EnoAn8/8F4T7wFCombZfQp0JO+Y/76EN4B5miRuUkX/UD58qe?=
 =?us-ascii?Q?YYqr4XgowZwZmqZCTjI1se0n4TZR9yaRkw9D8flWCfEqXkfYzuXHoJwrgEqd?=
 =?us-ascii?Q?T+QN6eqZHM4SHkaPreG4MzFscdgpj/FDnR8DPytd8CPcoqQlTaHoaLpR+l+w?=
 =?us-ascii?Q?TGAyOhzVzlMormwza8PPqvd+tnUM36enQT/WsgKrdMSKUNdK4eUu7aMbyR+m?=
 =?us-ascii?Q?Q9dD4cP5tzo8ymgAFURwVJEXM4jowz/xriopziWrX7q/6l9YIuj1t3SpBWB8?=
 =?us-ascii?Q?QGP4zGVaqbrxYxQg7vZHsF91e1TAszjd8PCIt5hIsGbiXD+2RvfyRyeQH21T?=
 =?us-ascii?Q?SHtE6aeHhDLriUbyiZO8cfsDuYNTM0dSLuEF9fXRU4CW6D/wksriChAVwnnR?=
 =?us-ascii?Q?PBjQnuPJ60G+O5HkM/yPXfjQF+/OjiEckCneEnM8hB4DbV5VrgHH1otFx871?=
 =?us-ascii?Q?9t1yquAv0KSpB8V22xZX1VT679wR4nKY8EaCB8KY8DT8P7fUmybjBgcr5FMG?=
 =?us-ascii?Q?pH5XwqkLNmj+9QXZcCMnPu+D9gVlZ8+NmaOgYqgFdTcJhGHc/WU19UagcQSj?=
 =?us-ascii?Q?s+Vd00bwZH00FBRbNV6hRIBf55VHPMaGBufYPQLzPlTQjFuM5H+UccPt5i3N?=
 =?us-ascii?Q?PX5pf8Hv014aKZ+Iieu3Zyc9bUe8a3ooM2drr4L8F8p2vF4Ue/p8tpc4Gdc+?=
 =?us-ascii?Q?DLQJP5A5g3iEFMSSBYESG1PU6rZOiIlo/SEmqQFuZb8qEXP2O3yMSlh5FTki?=
 =?us-ascii?Q?f9aj6wcsS/TuXx+8MRQ5DI5wsOXi8G8ggPNhsUuJDtpLWs04xMbEb7YspO52?=
 =?us-ascii?Q?wH6vymqRCg=3D=3D?=
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 298168a4-07cd-491d-f3b0-08d99fa2641e
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB7153.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2021 14:50:06.4686
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7LTMq7Do52pafkLzTn5c/gWuYfxpU8SVH1TLgwK76Az74gd8YliYnyduNlj7D6eTmsQ95zoXLlsnxffE4ufOHsFzDVOc7Fj08X897D3ngyAcknJGf+efdwD5eYsBfZPK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR01MB6892
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>

This series ports upstream commit:

d39bf40e55e6 ("IB/qib: Protect from buffer overflow in struct qib_user_sdma_pkt fields")

Gustavo A. R. Silva (1):
  IB/qib: Use struct_size() helper

Mike Marciniszyn (1):
  IB/qib: Protect from buffer overflow in struct qib_user_sdma_pkt
    fields

 drivers/infiniband/hw/qib/qib_user_sdma.c | 35 ++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 10 deletions(-)

-- 
1.8.3.1

