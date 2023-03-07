Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2B06AEE10
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:09:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbjCGSJY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:09:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231629AbjCGSJJ (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 7 Mar 2023 13:09:09 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B663E83881;
        Tue,  7 Mar 2023 10:03:24 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 327Hwjvt021850;
        Tue, 7 Mar 2023 18:02:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=BxMZ9odPIQhVf5xzpt5XNpyZJrFIB4lMGaIp3HmhMkg=;
 b=jSGAW2DAHOxdiFKD1HR5Th9VKAOVW3MM00FbOYa8Tee1u/vwThZgehY/xgk7t8rC0XnT
 npGOSR9fSpn8mVtu99tQsJ/DWY8eViEgXZDwwOACgx+Ca6zTaRmMeT/lu+T50Jc9vW3k
 +1I9jAiTLBPje/UA8JtsdZ5fKvPAIR0AXqw2fiDNIdSuVHHvC99hSoY5UaQn22Slk+UB
 yxjwccf46fllObHd5MloE2am56SrNPvVEdTjQTFoRNQhfRKAK0gxVFpyk6p46apFyEoH
 8m93zHau/Bk9vCEDkWgRfX8ExFFw9SRU7EKcpTTEZsDBsnc4v5L7NrVd0S1fakIwpOWM rA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p4168p719-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Mar 2023 18:02:58 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 327HT0kn036987;
        Tue, 7 Mar 2023 18:02:57 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2172.outbound.protection.outlook.com [104.47.73.172])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p4txeuxf9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Mar 2023 18:02:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lfw6WcJzUafw0C+GbPJHzjcmsFo7tIwQR/sS9kNVjpKlkXf8+72hPn95HYqRHI6dTLnRG0selGARu/ZQbQF/9WmhAic6MPRyS83zO19p7KdeYMXukIriYgeTiWH2fCDbkv0Uky6U9qzrFs/szVunRrLecs/hCNoJCBcjDsM24SKsHWnLLv2Rujyxec356iqf0xmEIfxY9+NImbS8h+2yGyxKEL06XDrR9T1y3XS5KrdQS7141GtxMoM62IuF4la9HUIKc0d1gvvjgZ489Yf3IdDsSTkFEY6xEd05I8yojWX0CwiUfd8aKx4SnRzjdgTr+SDu4718/NK5JLH3eiAKWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BxMZ9odPIQhVf5xzpt5XNpyZJrFIB4lMGaIp3HmhMkg=;
 b=J0kXKg4QPNxZ7XXN3QhDf5V31jeqc4CjG5QtqGuyUHxh1a/nxOBdVNaypEVmHYD0oPQjwtRKUv/Gahmj3qeaFl1Y1o/XMbIAS2U92Mxba5iLbfN6897rT3joGLLTSsAwAkoFe/1dAIdsaHiLASF+u1i2Bh2SVnS0vZIDtwjvEY1bmEHY3BAj7DrX+jLx7Uv++kMIgLNpWze+5gXkN3nSorHTCb+N6NDQuXMH9DT+aqtdGXKNIVAZ7frRP3cYxmOjJ5gB+WiqRHo8m8UaBKdz+4UziPKCGDOhbcnaWaLn03uSPjNYhmvYhFwNKVNwttdaftVnSmSZFpHTHSw9kgrAdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BxMZ9odPIQhVf5xzpt5XNpyZJrFIB4lMGaIp3HmhMkg=;
 b=n47/oOOqeyVetFKTglncC8tn3N+hdkHjIx4GR4ThDOBAKxZRSp2StxAYX5yoVf6UgxRM3BiCVXSB6vmuiIACFhYS4SGYLKUHHR/d2XXOpD36L1kEpTqKxpibP4PEqE7pHVyodCsKljgT0cLjSnl6YW9KoMoB3OAwS+wzKydD64M=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by SA2PR10MB4650.namprd10.prod.outlook.com (2603:10b6:806:f9::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Tue, 7 Mar
 2023 18:02:55 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::93c9:c99e:5ab:4319]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::93c9:c99e:5ab:4319%7]) with mapi id 15.20.6156.028; Tue, 7 Mar 2023
 18:02:55 +0000
From:   "Liam R. Howlett" <Liam.Howlett@oracle.com>
To:     maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Stable@vger.kernel.org, zhangpeng.00@bytedance.com, snild@sony.com
Cc:     "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v2 2/2] test_maple_tree: Add more testing for mas_empty_area()
Date:   Tue,  7 Mar 2023 13:02:47 -0500
Message-Id: <20230307180247.2220303-3-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307180247.2220303-1-Liam.Howlett@oracle.com>
References: <20230307180247.2220303-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0227.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:eb::20) To SN6PR10MB3022.namprd10.prod.outlook.com
 (2603:10b6:805:d8::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB3022:EE_|SA2PR10MB4650:EE_
X-MS-Office365-Filtering-Correlation-Id: 9dd9989a-881d-48e4-4085-08db1f362d3b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T/4+NMPMyL8NWnrAuwXqLj9zvoMHWCYLSDu5yKl4D13WW+FvFwFjg0HaTzu2/NkmPQob9bEtxSa5ePHh+ZHypeyiSIRcNDKxTTR11uf/EZqiMDkOkImRPe9HvaDuiitrPN0vlgieSooRt59sXwUpMoWtthMVbs8Qlp9G3C9QsvGO/XmnJnPIPgM1IT+Gq3elhj2BVhlU6DD4saUdeTijX+VO3yQ/XBkmB8gH2xessyBFDK56vSLn+tQoiJhJwWAW5Ac03dp1K5svI6CwxMNAeQ2SqJB88GTDF/hO5fLguMR6GMBQ0OVzQtreGYfREgKjAsRJgwc2GmCH62tb81tHq8bKU7NCotsb6NMmoBDkzj83zn8TEns1humqCihYZXKjmAUQb4Z78DPQWwBMexYSUxeghkLO1Cw8s7IZCJtfjffETD9AMBE3zkAFlYs8dqanu/K1zIK68GbU8MW1h9N55VkNEAHmote/5uDxLH5UO0c83zFN1FJV0Trxwf8acFpONlAedNIfN1OIf9J9zS8mvl2Euyzab2EZav1bH1BGvYEdqCxJB13xQnQNgQrFhJQ8MnzXTfhkOcZYKA6MxBu6xC1Ar4K0DpUnFGNxOP9luzZJ+yb0rm3nIKtqv7P/axsK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(376002)(39860400002)(396003)(366004)(136003)(451199018)(86362001)(36756003)(2616005)(4326008)(66946007)(8676002)(66556008)(66476007)(316002)(26005)(107886003)(6666004)(6506007)(1076003)(6512007)(6486002)(478600001)(966005)(83380400001)(186003)(38100700002)(5660300002)(41300700001)(8936002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9xGtlpEO6EH5TGw9DwFAceBcRFUy8y9m/R2+0muF/S3oLNITnl7bRAgP0u9l?=
 =?us-ascii?Q?wNAGInzkmcKqmYNb0ZMFCiQ/gc4qxgGKEUkc9F5XyVm7P0j1lSnhkwuFJR4U?=
 =?us-ascii?Q?9BsEQwZBrlO8yMHwd/PvbEqiIynjyC3kqK1XPapORoWUs6DmT9jsnNQ7IzXr?=
 =?us-ascii?Q?U4/6hkUNqzeADPzA5EX2ThtPq3ekdHM5b+5AeBqq67bLkdMP04xwQSSLYcRO?=
 =?us-ascii?Q?vGUF+/KKm7JnvzETcTv92H7bCeTDm2tWQBUJ0bFR2xGw3w1X+VaxW4d18BGA?=
 =?us-ascii?Q?Q323CvMKu75St6z2/O4fP/cQQoyzqAZgTDtkf1H6Lgh2RnMsJFnIZY9m1lBB?=
 =?us-ascii?Q?BgJrUfXBQ9xTI+iTTc9x0RDBoicvU0Qy/DWNuTkF2gvaFDUaP0MfL+hwtWt4?=
 =?us-ascii?Q?hapow77gqTpUk3kc5qZvx8sEvOf7pKRC4jmvToKnMfpqB7Zf55TpwShaYX7C?=
 =?us-ascii?Q?LNg8MoaItziZslco337QgSV1cay3dYe+c9h1fqC6Qck0DD1LORPVPxcGcNtY?=
 =?us-ascii?Q?hazjoN/qYkat0ThuvIFsk16sMNY76ZjLiYjT00qH41J3mFz1h59CWp8F+jPO?=
 =?us-ascii?Q?fWEpNpH+gMoO+de8HDLtIApY5tDsv3WHJTkpjB6zLDCsefdO8uQ5Dib9aGtT?=
 =?us-ascii?Q?aS41B7N1Cc3fqWdb+ai2erWOK+uEMdJ2lL9HNhrCgBvE5u+hfUs28+zmJ7uN?=
 =?us-ascii?Q?gVgqGcsZdE+z1skR53UgWSXUsWfOiP/CxTIihpp7dU8m24dwC/fE7ozabp9h?=
 =?us-ascii?Q?w2Flof0joOQzeSMFdcnF/aqftiHPlXBRSX+K4rUsIRofRlWQLJHlzhf+Ial8?=
 =?us-ascii?Q?f/OcGe6uUiOM6mjUmm5V/efQvO0dmR/jLznN+5giFr6gPGv0gMZDzex7/LPZ?=
 =?us-ascii?Q?ce4+qjy/toFMLsIemFEgmyGCB2szrXSx/WoH7L1HkrQA92+7HuJ56hJZEe+n?=
 =?us-ascii?Q?EKVEk/KabTfaaca/K8SGY/1UarrtN/ksfCAEJY2eWwlRIm5SSnFq8LMgHpkw?=
 =?us-ascii?Q?IzIxqmFq4BGvtMSCjCD/b+b5LE87uIdjSmZ8dUnGaNcIup/ROE3HUwro40ha?=
 =?us-ascii?Q?Yu+rq4dgWFe/BpQPGbOYccRLU52Xb3v0fAi2BPbuSx0ogaYn8U/i0bkv5y4t?=
 =?us-ascii?Q?y4e/GRPk550/2reXx/xuQ+vl8HXISJhgpoYEEnQmGblT31x7VDmhV9WfBjFd?=
 =?us-ascii?Q?TdBJHsUgePuCdSUJnWOn90lw29LFGewhnjvizZbhvH9y5ykBZ08x08nlN7S5?=
 =?us-ascii?Q?okjj71eCU7cuOnR6pteOuDTfVl6lP8RRgptWp2Qb+M7YyTsM2lkVib1DWa5q?=
 =?us-ascii?Q?J2zHu07D0PrR1Ckv/i8+PYj9k3nQzkh/EgOeuZujf6VK2DXRsL9IUd1geh0s?=
 =?us-ascii?Q?NVgusffYhgUI7uQZgCF0tgOdBh8XNC1YRG6jKv2I3ruzk3RSozoCaiFV9I+E?=
 =?us-ascii?Q?k/f8Y+JVX3Q/N1XgglINZMHjNXMdDPBJB9oBEx5Sxx7owff6R+uIZHTTeZi1?=
 =?us-ascii?Q?AT9eeJqvcjUjjk+JgKP7r+oVmvnVmYdo0SgA87Mud1XOjJOxOVeI35VMTmM1?=
 =?us-ascii?Q?iF0j8vb9BBvZ13SBUfkTKmH6BmmnTLSHWr4LAWY7U5viBt6OnrOewq48geVr?=
 =?us-ascii?Q?5g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?uI+L74xZ6CANO8hrYK1ze1RHMmvEyBkTnMMHwt7YFK1Z2Wgk1VsbU5CXCMNI?=
 =?us-ascii?Q?2ej5eq25j1+bRbzM8kp1z71rIlMj7seQCIGh05fs5+VO4zf0dg+k3+2koP/z?=
 =?us-ascii?Q?M4e4ToTZjmQM4tVIO9EI2mRscFA5/JGDybTpg6V9crJrMHEnzEHW7tCwJOF/?=
 =?us-ascii?Q?wqNyLfh9GpFg6wfRpeQFmQrlwkX8QkCdpS4ztZGq0M+orVrMVYaRW6DnpuC9?=
 =?us-ascii?Q?/eCCoNahxuxU7oW0sMGTLxDNYXFoZV8veO+yQmOdDm3DOcHw2iNuNmRb1Oin?=
 =?us-ascii?Q?EHTtbrMyTEOhl5oRGfTIRmb+443bqI5kOY59qywiCajs2MJjdINstICnAUw9?=
 =?us-ascii?Q?gvjj7IO/HI16vLvY1LTnen+Q5Vf0tZR89qOmR0Tq0E49a77aJ5E0OcQMe9cq?=
 =?us-ascii?Q?kSLoccE0pAhXJIvTQYIGvTbRDYuHvPjlHK4vIPQXa4nVi3EeeHH9YMWNPaVr?=
 =?us-ascii?Q?ZEwV4eirkWqPqvhW3N/6R4C+7k1ZErbMZw400rgLyUMDsjMIU+bM6arxuhT6?=
 =?us-ascii?Q?e1hgZYLtApewwDZxIin33FLKi9kPoYbEpAsxXM2sjIlGE/tJ/RnKtA4jDYJM?=
 =?us-ascii?Q?W1y4W5ylVUCN0IAEPSmUHrmntGyta0Yu109Z2AVYrKPFrSiNTyQH8WFkrolt?=
 =?us-ascii?Q?1Iyc1Ug+jF5NQHeCWo7vX7s0W40ShBztL0gIaooZ3aMAWYCiXdSMFOOQvL1J?=
 =?us-ascii?Q?LCtBVH9ezduks8dNDEwpJuJ/U5Pz5iwUzWGYcSAXLLbt0d80Xj8m7MAuQo7j?=
 =?us-ascii?Q?XxiXlEOYSCAHRoUxu6MyrhY+VG7HlieHUGbdYBZz0QVYkGtnwpikwJ1Jx5jl?=
 =?us-ascii?Q?Y9s5XzN5c4akvOHsGrZp5+PjlulzPROHE+n9Es/elwS+yinfAy4VtAC+XEs2?=
 =?us-ascii?Q?/URPgpg0WaFyHpxHOVTz/lCRM7akmylI0FJiBqrOYduHuuNcqR3mKgWqQ1Jj?=
 =?us-ascii?Q?7gW39LBhl1pny2RleFRErA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dd9989a-881d-48e4-4085-08db1f362d3b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 18:02:55.1391
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DbLxOSgyuQxyWm5YXNveTcUEw3HymCL0NRwR3vHQSApKoglPDzmGsZw0H8ILSqu6OHT9jauiir0aS+ZLOSJpKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4650
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-07_13,2023-03-07_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 spamscore=0 suspectscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303070161
X-Proofpoint-GUID: NZZKSe-tmt5NgSO9xHYHGoDO9Sf-9uO7
X-Proofpoint-ORIG-GUID: NZZKSe-tmt5NgSO9xHYHGoDO9Sf-9uO7
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Test robust filling of an entire area of the tree, then test one beyond.
This is to test the walking back up the tree at the end of nodes and
error condition.  Test inspired by the reproducer code provided by Snild
Dolkow.

The last test in the function tests for the case of a corrupted maple
state caused by the incorrect limits set during mas_skip_node().  There
needs to be a gap in the second last child and last child, but the
search must rule out the second last child's gap.  This would avoid
correcting the maple state to the correct max limit and return an error.

Cc: Snild Dolkow <snild@sony.com>
Link: https://lore.kernel.org/linux-mm/cb8dc31a-fef2-1d09-f133-e9f7b9f9e77a@sony.com/
Cc: <Stable@vger.kernel.org>
Cc: Peng Zhang <zhangpeng.00@bytedance.com>
Fixes: e15e06a83923 ("lib/test_maple_tree: add testing for maple tree")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/test_maple_tree.c | 48 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/lib/test_maple_tree.c b/lib/test_maple_tree.c
index 3d19b1f78d71..f1db333270e9 100644
--- a/lib/test_maple_tree.c
+++ b/lib/test_maple_tree.c
@@ -2670,6 +2670,49 @@ static noinline void check_empty_area_window(struct maple_tree *mt)
 	rcu_read_unlock();
 }
 
+static noinline void check_empty_area_fill(struct maple_tree *mt)
+{
+	const unsigned long max = 0x25D78000;
+	unsigned long size;
+	int loop, shift;
+	MA_STATE(mas, mt, 0, 0);
+
+	mt_set_non_kernel(99999);
+	for (shift = 12; shift <= 16; shift++) {
+		loop = 5000;
+		size = 1 << shift;
+		while (loop--) {
+			mas_set(&mas, 0);
+			mas_lock(&mas);
+			MT_BUG_ON(mt, mas_empty_area(&mas, 0, max, size) != 0);
+			MT_BUG_ON(mt, mas.last != mas.index + size - 1);
+			mas_store_gfp(&mas, (void *)size, GFP_KERNEL);
+			mas_unlock(&mas);
+			mas_reset(&mas);
+		}
+	}
+
+	/* No space left. */
+	size = 0x1000;
+	rcu_read_lock();
+	MT_BUG_ON(mt, mas_empty_area(&mas, 0, max, size) != -EBUSY);
+	rcu_read_unlock();
+
+	/* Fill a depth 3 node to the maximum */
+	for (unsigned long i = 629440511; i <= 629440800; i += 6)
+		mtree_store_range(mt, i, i + 5, (void *)i, GFP_KERNEL);
+	/* Make space in the second-last depth 4 node */
+	mtree_erase(mt, 631668735);
+	/* Make space in the last depth 4 node */
+	mtree_erase(mt, 629506047);
+	mas_reset(&mas);
+	/* Search from just after the gap in the second-last depth 4 */
+	rcu_read_lock();
+	MT_BUG_ON(mt, mas_empty_area(&mas, 629506048, 690000000, 0x5000) != 0);
+	rcu_read_unlock();
+	mt_set_non_kernel(0);
+}
+
 static DEFINE_MTREE(tree);
 static int maple_tree_seed(void)
 {
@@ -2926,6 +2969,11 @@ static int maple_tree_seed(void)
 	check_empty_area_window(&tree);
 	mtree_destroy(&tree);
 
+	mt_init_flags(&tree, MT_FLAGS_ALLOC_RANGE);
+	check_empty_area_fill(&tree);
+	mtree_destroy(&tree);
+
+
 #if defined(BENCH)
 skip:
 #endif
-- 
2.39.2

