Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF94F698C2F
	for <lists+stable@lfdr.de>; Thu, 16 Feb 2023 06:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbjBPFkT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Feb 2023 00:40:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjBPFkS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Feb 2023 00:40:18 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F6778684;
        Wed, 15 Feb 2023 21:40:17 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31G2KAcq025733;
        Thu, 16 Feb 2023 05:21:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=ZOAxZ5eH6Daehm4oSDwcoZ/AqeFnLC7elBxshkAzujA=;
 b=yaF4YdiR2zPFijT9qkuq55Af7Nn+/inxiCBmdzlXCpRuCpzGF0B1Y52e61KgBiiqBOEG
 K3c2tFFhLUlX2TLAcK/aI6xW/YI0u9LKYX2U1PE0LHBw1GY/UgdfxfjZCB6X/ge3pea0
 ZqDYlSlJRTHrqFz8z7PqYoH0YV1Me6Drwh62uDFAzlJwe2jTII98sbNeILCTLApch2db
 +ePl/dQ0CVefMdiDJxzzBNMcHnvShVa2xrQ1UoNSWoSD7Bpk45obd0yQbVOL1dh0U6Eb
 qqsCDZmPIWvzMvVaOOGTaJ44M7ttACmswTuafyZhwanj0qp/H8XKk83GgugS1at5rTx/ 0Q== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np1m12an5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 05:21:56 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31G2Qfbn024264;
        Thu, 16 Feb 2023 05:21:54 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f8mxvw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 05:21:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oJD41/6kpYp9x4/lBCMVqY76HtghWAw6TXmYKQdBCAbG+D3yWXjsHTrKzDvJd4EqQO/IHo1Cyc4u6eCq0f7MUONdthidDHnGWOqHipCypDPwLwdabpKs/mKnDG0K78T7k3NK9BMgGr49dyoe9nafQf7qq8nvhSggFl2h98kBbiPs8qSdEKqkgt1XLv+nu5CDHLY8vlE4XMF6fSdTcdM0TCIRRT1eg+JMZp3+AvUynePY9eZRy1pNyVwpKm9jWMfoW6nDEQpmolAYT8PBn14eaz+ZZ1Q8P19HoW467bvxS6Pt4sRx+GaoNdkx1t7Mt9bNz/lDp5ONCo9ToH4CVq4vWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZOAxZ5eH6Daehm4oSDwcoZ/AqeFnLC7elBxshkAzujA=;
 b=G/PGJtQrLLy+RX3HUbi8QyDGa8y8YKgHwIw8txkgVJ4NHy7WmgQNP1YnQBltKC6G1NR0pMh5EP33GyX8ao6zmo9Mk+7QXmgwm+WdY3rglHqsjnyX9mvCzfceH4UlLnReiSi/HR42ygYfjhyHXzeolfp8+ZlC0KIbjqf8n9ZpWfi7cmAvy2PwdCT4jUVp5kdqxYopYz39D83hHCi3oInps5XIZaHxXaT2dpVmH6ZRysxhg9cdfZxRDmJf+xSA8DzT+gFgFcR1XlTJE7wKUJdjwi0io3rUdWerqOvOAKQ6QrCxJVycBSpAAJoGEVlRAAJAxsoWptc1JF7oVsmS6uYSFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZOAxZ5eH6Daehm4oSDwcoZ/AqeFnLC7elBxshkAzujA=;
 b=aLXqaG9MROe5u8Bqqqi30IMLjnHnxIHy5FPodK0KVikVE7r9bjNpr+CMeeFkRsxl3CoZLze2vXP9IRisYa5H3Hsn+5RpUum8cO4f0wJsDM4ZxI7GOxZmCBeiT7uWHniloCk57Fdo49f5e9/DA4/XAujfPN5CHqkn8l1AnwVzOLk=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DM4PR10MB6789.namprd10.prod.outlook.com (2603:10b6:8:10b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.12; Thu, 16 Feb
 2023 05:21:52 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c%3]) with mapi id 15.20.6111.012; Thu, 16 Feb 2023
 05:21:52 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 12/25] xfs: xfs_defer_capture should absorb remaining block reservations
Date:   Thu, 16 Feb 2023 10:50:06 +0530
Message-Id: <20230216052019.368896-13-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230216052019.368896-1-chandan.babu@oracle.com>
References: <20230216052019.368896-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0183.apcprd04.prod.outlook.com
 (2603:1096:4:14::21) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DM4PR10MB6789:EE_
X-MS-Office365-Filtering-Correlation-Id: 00d7676d-7fb8-4ccd-ecf4-08db0fddb64b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GPyJB+HBpRfjphNH+9gSok3iF71Qlfuz9pPDysNKWA2dN6gCLUk0DQrgT4VWyHx8uaycYQtS/C/6vDiPq78jpyVH4c3vIJ3b6uhORYcNnWYLWGWI7dgJlx7i8JJXvjRKEkCMsu/DUhcMn4+K7394Ru3RJiTuU9QwHPR8UoZ0/X6JG7U+6ETgOgnc+Vl4DMLQ2XPbuKeE8qTptj//wVUvrgdSQcWPTkFDWGCujxIAhpE1/dmF8tYiiT2hU2AB3qvTL7sXPnmLgVD5+Ld8HM9hlK6uTRUwYv5AzXAcrMvPD7mRZPqBBXzrbE0p6GEY3uc2tIxfzZxWz2s6r53MMxB94L1GyFxa/Mo7Z5LE9RlQ3gTJul0+4ddqFnyW/n6bIrX0BCnGk0g+TH+xW4VEI9B+UMlx4njv9sZekAy24hIqMsmSioFdkggU8Z5x4hGI4x/nNbsa6qpAD8E0vqAaoVu54U3M1Gh4SQ0xTbuO+SOp5GTxF3TCgK+MxZn/ZyAPmT6mubg3RmFEdPmmjWAMQAJjOafplZKWdKD9Sph4KX1rVp65Va4QZefnFje+1wnUMsAsp+RKAz4bnP4InN8W9yo87zr5aZTMBUxUyTAjUIRvk3ISL9yan0pTUf0PWB0qkQ+Ch6llMwU+gtg0W1skysggOg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(39860400002)(366004)(396003)(376002)(136003)(451199018)(2616005)(5660300002)(38100700002)(316002)(6512007)(6486002)(2906002)(1076003)(6506007)(36756003)(26005)(478600001)(4326008)(66556008)(66476007)(8936002)(66946007)(86362001)(41300700001)(8676002)(83380400001)(6666004)(186003)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?snm0XWmurUOutUyAzrvA6upCh2d34ggifkR1tSSpykRpeCwIFUXihXy7LYON?=
 =?us-ascii?Q?lNOu0IcYpRtWjg3ebduxdPyniYqqNRkyPj3QXZAXrpW/jeCBD1zFSHJ4tJHa?=
 =?us-ascii?Q?s6ofkwnC9rtcOtyvhGhEH6WaSqGqijtqVzvwH3TcCg7O18tPk8d5dNkklj4l?=
 =?us-ascii?Q?geLB450P7q45cwEaeqeHN5w6wRoN+mSHjmfFzNLpqpQHkI3q6wHQDJgNLjFB?=
 =?us-ascii?Q?5HPR1FmDpfyAIUpY6D4qVJD5dwaXKVjkd9tg4GGP0C1qyM3e/ZUzmSHiw6x+?=
 =?us-ascii?Q?LorR2bsCocjBvCht5x8/5UocDbPAQ4mMkaqsD2KQnlbir17GzLRbzSBi+bUv?=
 =?us-ascii?Q?lUMBnQju4mCnVAK3Gtl6xPaLEEjD65IOXbRdLLsg2cyqFFOPwv3HyK4Vl6yk?=
 =?us-ascii?Q?bTFaOB4hCXLKkkpeNgtW+DNhB7zhD+buX+H24x2Y0qWJo1QG3xl/zdM839+T?=
 =?us-ascii?Q?z0LQDpKFjN8LaVIpfG1o/y8Ek4Fu2SfU8c0z2LMENtFUKXFMgyk4GuOfkdGg?=
 =?us-ascii?Q?Tp6mysqOeMuv6nWThufgzeG5XVfqR0zBaVwpx3Dxtcv6fXp/1sWFtXELhpDg?=
 =?us-ascii?Q?Lrhzy7QdUCjuSEtw4yz2u+UiMfTdRvPWDVdL2Yvd43jRwG52BYdxbeZrRvhE?=
 =?us-ascii?Q?DwvlpqWYYB14AwRBdp6gZX7xk+75Lv9cAVfLon3ZSjcez3P6C/QX981nK+Fg?=
 =?us-ascii?Q?4TMQwxsQkb02Vp3x2ytBaRis1BtiiW17uJtzcT545o7HLgGvNY7Zzgj8pk9V?=
 =?us-ascii?Q?Ru+UH6sKgw9vBniCVn6VN20e+m5E690Sr6+bw2SfOB05wi0kdxfn5E0b6v7T?=
 =?us-ascii?Q?gVGlKbaIn3GC4nmE8Fc0QFHweyOMn9xbzOAAAJmYuR/c/5Os4hjO5XTUk6sG?=
 =?us-ascii?Q?ahlMwnANTpX5lopgoAHz+gMZdYC9U0vLYUw8I66G9/01M/n1X0zLlVzh6vqm?=
 =?us-ascii?Q?Dl38Ytw4dT+9/hrA+ZlVjgmwoAF7a9yPfwmDAd8pGbzk9yVdrkZ2vLPCsOyi?=
 =?us-ascii?Q?BTQWusVDxOXlAxCyDgdKBVP5ss4Eri06WLeJmn76H7zyCwSkFZjKja9fQ5Cj?=
 =?us-ascii?Q?AobcuDvxLc/PSyQ9mITXoiGxyoET6K4q/aDVIugTK1qAgWHNfsYZWlTMQm/F?=
 =?us-ascii?Q?78ctVgF8LsUxaOksPh5QRnxq6TFeF+t4N3mZAS2pSLbHKv6gQm2lXDzZGDlz?=
 =?us-ascii?Q?a5AdKZWrrx6+juXzddS5lFsBkhSG0ZeQmKEp2aaR8S5tCZI3OEdLijea2cfZ?=
 =?us-ascii?Q?7m3MYmNNFVuku1k4pgzGUwqZ4Or2oouYYP5Gu8AmIvMj/ZXrPNFFD+/s4j2R?=
 =?us-ascii?Q?Jyr/cz6Jkktb0gk+VgXPAh2TEPV92iIg3PqVPD/6qV44eYZfSLWzcYM/RAdF?=
 =?us-ascii?Q?MgKUEEAQbxbmsICY8eXI0mEPhkMCtjCiURah6JPxtyqZtFLGOIZcKyKU6iGj?=
 =?us-ascii?Q?fPqunVvP6lihsg2N4EcB2vSD/5niPk3wcw63Cl6Y5KZTAVRIwzuzrvNUYS2o?=
 =?us-ascii?Q?nLu+c5R+Tp4/gu8kiE3QgYGBQTtFEoCCLrURUNzqrdyBNOMPu1llztAHzE0g?=
 =?us-ascii?Q?nlGSkOeeRHfSJkPoiDw1sqRFNhqRD1H8YVT9HnQ1sNp4zbYkJUSOO+o3S2Sz?=
 =?us-ascii?Q?Gw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: PUMLLoJs4ZgQAatnkBVw0yB0UmyLkIIsSn5OmHJ8kkrr1oHmmmmPkNwVx/IA4TbvYtXU5P5s9LSswgftUsPvR5E+i/O7SqDb6DgpdlkxTqI8AFzQkiqLLqo6bOFRiXHkTIRY57ool2cuQ4UpRR1MYGzo+mq5y1FMIOA8GzK4ZuFVhx6J/A81U5chmS9x3fAanFGtX7uetLLqbU0bpXefUPDS74Vz17v6xCqT1TIspquTjaTgkvsaqADJJU7zfnfttQ6Qx6eUU7bWT6FABZAsRJFbMYwAeBtI7UIA+Gm0dsgNm6QWl78+jLQX4l62l4z7Q/Kl8947Dx3vhvJm2d/GDl3CK+u4uphx42CxR10sWpbXNYmVfGUMpJi0FLX7XsWex5lEg5UHjVY0ujVHaR/8AiOgUluaBP2rk8kYkvMJKYX98PeiPPiI3A4AaHI9bhrMyemKp34Mp8QORkCErBbcd1TsMtf8yMBFTjK7BNfdpBP08RHR51K5ph+Us0l6MpNu8vO/UW/QQe8qOejkqimImR1tzZWPRfeq91oU63xAbnUEOw+LyWyvuDBQ0cG1ScJm2avzYmLAwQys1kNnEqe+1AiSaSShhUGDySyvQ+nFfRVRIIu0vK7tJh4Z4r3C6bCDb1Ofz6ry61Hdos8YTSbuaVyLKEqnrgzSN1z1mBwLXMOyaQ4rREAaA0uHPygyyt2qKnssqCMVYUOqyTsdK8sp9Uq3+ESHh1YhUbtb9IpHHYbsrQYQwf689dO4kohAJQc7pGTSheF2l/UejWvSQm8TBIUtA4OXKypsyJMG7BulEZFeU83pywga9A+VNn0TylXdazFxryu48l+gqVRAxmYTfXzzMZ1aVOWhFOtPXJ8m5eYAbudxAk7XgOzpFCcYsCm9
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00d7676d-7fb8-4ccd-ecf4-08db0fddb64b
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 05:21:52.6643
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ALydCRXYwNeG8brfL6MXPt//Y7mluuHa3jayAp3vGaYMtwqKTgdj3Azxs0wofXCaqSmwJ4TIfjFa+BuNlvfgNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6789
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-16_03,2023-02-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302160043
X-Proofpoint-GUID: 6VpsBfkit9xRLT7K8irb4S9y53VJ0lLT
X-Proofpoint-ORIG-GUID: 6VpsBfkit9xRLT7K8irb4S9y53VJ0lLT
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

commit 4f9a60c48078c0efa3459678fa8d6e050e8ada5d upstream.

When xfs_defer_capture extracts the deferred ops and transaction state
from a transaction, it should record the remaining block reservations so
that when we continue the dfops chain, we can reserve the same number of
blocks to use.  We capture the reservations for both data and realtime
volumes.

This adds the requirement that every log intent item recovery function
must be careful to reserve enough blocks to handle both itself and all
defer ops that it can queue.  On the other hand, this enables us to do
away with the handwaving block estimation nonsense that was going on in
xlog_finish_defer_ops.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_defer.c |  4 ++++
 fs/xfs/libxfs/xfs_defer.h |  4 ++++
 fs/xfs/xfs_log_recover.c  | 21 +++------------------
 3 files changed, 11 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 0448197d3b71..4c36ab9dd33e 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -589,6 +589,10 @@ xfs_defer_ops_capture(
 	dfc->dfc_tpflags = tp->t_flags & XFS_TRANS_LOWMODE;
 	tp->t_flags &= ~XFS_TRANS_LOWMODE;
 
+	/* Capture the remaining block reservations along with the dfops. */
+	dfc->dfc_blkres = tp->t_blk_res - tp->t_blk_res_used;
+	dfc->dfc_rtxres = tp->t_rtx_res - tp->t_rtx_res_used;
+
 	return dfc;
 }
 
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 2c27f439298d..7b0794ad58ca 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -73,6 +73,10 @@ struct xfs_defer_capture {
 	/* Deferred ops state saved from the transaction. */
 	struct list_head	dfc_dfops;
 	unsigned int		dfc_tpflags;
+
+	/* Block reservations for the data and rt devices. */
+	unsigned int		dfc_blkres;
+	unsigned int		dfc_rtxres;
 };
 
 /*
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 388a2ec2d879..a591420a2c89 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -4766,27 +4766,12 @@ xlog_finish_defer_ops(
 {
 	struct xfs_defer_capture *dfc, *next;
 	struct xfs_trans	*tp;
-	int64_t			freeblks;
-	uint64_t		resblks;
 	int			error = 0;
 
 	list_for_each_entry_safe(dfc, next, capture_list, dfc_list) {
-		/*
-		 * We're finishing the defer_ops that accumulated as a result
-		 * of recovering unfinished intent items during log recovery.
-		 * We reserve an itruncate transaction because it is the
-		 * largest permanent transaction type.  Since we're the only
-		 * user of the fs right now, take 93% (15/16) of the available
-		 * free blocks.  Use weird math to avoid a 64-bit division.
-		 */
-		freeblks = percpu_counter_sum(&mp->m_fdblocks);
-		if (freeblks <= 0)
-			return -ENOSPC;
-
-		resblks = min_t(uint64_t, UINT_MAX, freeblks);
-		resblks = (resblks * 15) >> 4;
-		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, resblks,
-				0, XFS_TRANS_RESERVE, &tp);
+		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
+				dfc->dfc_blkres, dfc->dfc_rtxres,
+				XFS_TRANS_RESERVE, &tp);
 		if (error)
 			return error;
 
-- 
2.35.1

