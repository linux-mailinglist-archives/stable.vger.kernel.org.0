Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF26C67EFBE
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 21:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232516AbjA0UkS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 15:40:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232127AbjA0UkN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 15:40:13 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 497571DB82;
        Fri, 27 Jan 2023 12:40:11 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30RESXj8004170;
        Fri, 27 Jan 2023 20:39:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=yln7lMtptT9qb7+g1/+yOwK11oyVjmlAZQLx9R3Mbbg=;
 b=XCbwqMoG/xqZa3MwMlk9gzYwoelighuLfcGGrv2Zgonj2fAKMzjCRENhSJvrV+xKG+lg
 /do/VouGR/Fplw5ITs2JEcLWruWV1zJZdbLpEGF+y24ZP/jvOSshN01HwCmuGL1feVcY
 ITMozPZWHFN1xUEZ5bMJGZfGOxmcE+df68pDwxo1D37fnFnbyilTQGW/YXygwLv/hhHn
 bhYAzAMGHvhi6yo6ZnAGy2uMbKFXdvehY9YCL8aUj1LwMg3AwhYNKcm4lntygqLTRDXw
 KjoeERhzcmexPXOH8yXs6vh2Wgifa2dps1UKOP5V8d37DAGaPsUj7khfaKIzY+9Fc4sw UA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ncfd190ua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Jan 2023 20:39:44 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30RKEm2P005020;
        Fri, 27 Jan 2023 20:39:44 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n86ggjdt2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Jan 2023 20:39:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cN21wuUQFtdwUcZAmpoGZm3bRKJB00t3VRVSlk03RzanYXK9wYAkhqwGgvJ3N3sDJmM4OpObzVn0eOeRZM+Bt9qMpdS0S26pplDfzWDTDPuEsMQdFwv7QdfjxfWKuATcPWORowW/roQC4spwKSDwqLYuaiWY/3oNjLD1QlNjs2zlteI2MYHvP+8sNvZKSClusQYdDh7KfY3xim8CwoPatraG1IF/h/PHO8cZ4MCtBqTmv78NFMRIIyk2KeVyiSxGWC3eIi5kYxqUwvcCs5TrBARfzTstLTQjtKuI4pY2VtzIKMyEC6USTDK/PfCGUV4NfG4DQrwfPK0fHIvvrj7ZIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yln7lMtptT9qb7+g1/+yOwK11oyVjmlAZQLx9R3Mbbg=;
 b=MZN877hlv442oI5LyqCYkGzP8XEYDQFQhHNduMFkduwm6Qs7OqU8zk86IFMo+MgQBYSv4aXzg7zOW+z3IfyN3geIE9RTfCEDx4VB4agnrJyyCE2uvPF9i9W1nvTztRlddqsmS5FekhBw62lYNPW0RjEz2BXgqHp9c2lWNVBaDjWiwTs90o47AihkVP7jyQkAbZLXDQU589y3pK7WZEOwrA4KGo80Ni83NW+0MXcnq2T7d/EbPF2/q66sntgZjL8TIxhMgPAXiXdjLlYwSJ/u4gXwY3ot2pJQ5CjPT2H4FzfLnpZFf7ut7SF0zFWZ2M46yiCdfeJNe8qsKqQMhUw8Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yln7lMtptT9qb7+g1/+yOwK11oyVjmlAZQLx9R3Mbbg=;
 b=Q87VyJ63mzOsI5/MCEpUmAtKgSj7vgX72IDJ1chjvafur5pOlT4AczQbn2zat+5Ju78A5aCBPO4P4Z7krjDXzKJvLNcVvA1J7j0KMjnw8YCOi04yOXdaI+Dow8yJRcVOhwdqdwn2ur1SoMk+K3foQdtLhQUKHgftwFUfolCjbps=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by SJ0PR10MB4605.namprd10.prod.outlook.com (2603:10b6:a03:2d9::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Fri, 27 Jan
 2023 20:39:42 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d%6]) with mapi id 15.20.6043.022; Fri, 27 Jan 2023
 20:39:42 +0000
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Rich Felker <dalias@libc.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Dennis Gilmore <dennis@ausil.us>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tom Saeger <tom.saeger@oracle.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
Subject: [PATCH 5.10 fix build id for arm64 3/5] powerpc/vmlinux.lds: Don't discard .rela* for relocatable builds
Date:   Fri, 27 Jan 2023 13:39:25 -0700
Message-Id: <660d4d976be94bbbb022bac659ca7b5fb89ab5c9.1674850666.git.tom.saeger@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1674850666.git.tom.saeger@oracle.com>
References: <cover.1674850666.git.tom.saeger@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0268.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::33) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|SJ0PR10MB4605:EE_
X-MS-Office365-Filtering-Correlation-Id: ca18f853-7347-4ad0-2477-08db00a69e67
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NALd0fwugR9N+so3NzjkwrhkM5z8HalgaREDKN5bvvCq24UQrO5L/dxUs+HdvLdK3iePNjpdnc0qmUq12C1lnQGf9ux6Eik32GcPuWH559f5jFCQH7AZifexrzYRJ2Nmpe79Nh3gWJDhjDjK2F1YDj2w926mNu6JsduAliauv/ujHITtyATFYn8dGQ1WEITi9VJBYUomqFuFgJHRg0zI2xlbKnSNbqP/77vmjXqryQXmdTOxZ/J+Rk3YZ9gJ8SATxPkOZMunpsoR7eiE2Klk70C1ABh5TL4VLzEAJS7r9R24SuuMh89HfWfNwUCR1BSTwYfLOV0FpDy3loR5wXvXwafIgS1NjYO53pwy9no+PrMRjYZjsco8jOrFrmtx8j1qQDujNttcbnFzrAo5zzJwkahO3QbTB0fSnAerHD8DKCF+4NoX5/TgwBHfAcjv4OxZq+whzYLoaQyeS2ksAByrxq++0ZOeOnCzNT8EJ8R1OLQyKApq8PMbsTWSfDjlH56Ur19wEt617ml+4//mijlUPtugQbQ3vDrf7Bb3WrRzoDXTsdtOj+yMtVN1Iyyl0Fxn5CpPUkJNfbFTCw1HbokTME1an/O53V2LplryFQnArmFrujYKpgytbul0xGV4vZcM+kdRGEgIgE67leowyfoPo9g8OHPP664QJ112J4cydCjAH2W3R6IK78U66CU7QS8EZhmvZnuhOI+6VC7xGzJVgqKA7Nh1RXaBkahWyZ2kCy8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(376002)(366004)(39860400002)(396003)(346002)(451199018)(2906002)(8936002)(7416002)(5660300002)(44832011)(41300700001)(6916009)(4326008)(8676002)(316002)(6666004)(54906003)(6506007)(6486002)(966005)(478600001)(83380400001)(6512007)(2616005)(186003)(66946007)(66476007)(66556008)(86362001)(38100700002)(36756003)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+0VxapSJIPIFh4c9IyJeIULnfp2KsF77hdqlv3kxP8Oga/asNiVMDiML1kLL?=
 =?us-ascii?Q?iXiChEeDuRp4QfFOoPpBReAWY0aRCze94+47O3ROyPZmZrJRdy6RRlnA7cU0?=
 =?us-ascii?Q?UWfNygI16bb/eFs/k5blMHJpBKDqwpqe/Tb1DPTjAcJWcgMkxmPZlNj9uMAH?=
 =?us-ascii?Q?rUObx9LgHgcOb2bVFazi8bGavs55Xaff/iQ7yebxeSGghtdqsUT85T7wXdZM?=
 =?us-ascii?Q?Fz/qERK+Yeq4V3ByBOaT/nGYsOzGKDAT4R3UeIel+ccLWqxK8DTRqEQJ9KxQ?=
 =?us-ascii?Q?LUf7W9NnhpmE6tQY5aYwnGxEIRS5dDHx9/bxflc0/kJhP3lncfDQWeWfyvB/?=
 =?us-ascii?Q?hWxx8oofgBOwA3LqGBmmK9zUyuuZ1nbXEU/kG+WhIYixua5ADx0B7TXtWlQU?=
 =?us-ascii?Q?iFFdJ9dMzV6PwVRdmWB22gkcvYhhoskNWOQMVlCKyAG+Ba8YaXqKIRMnO/LK?=
 =?us-ascii?Q?V8Mopq9goN1hhYq9ncQvOW434j2s6hgZ7s3KeiFlquYmO5aCPHT0HGcAIWCC?=
 =?us-ascii?Q?2ap6Ox3I8zupiop/yFrqoixxzkNxMFXCqzf/Y2qfy+9i+xHAaax3ypDzNeZv?=
 =?us-ascii?Q?eOO4xJ//jeiSpCpI0b28eeXnHfFqtRK4O7O0dXZG6/CEzDmhhULrTIRtz1/N?=
 =?us-ascii?Q?Cxke9Sgv9sJ4M7bIIephE67HTn7mZGIFAtpif2Ttdz4Iu5CKYOacdDOlC0P4?=
 =?us-ascii?Q?J4/GRJXI1224wnT+uUGn6XeJfOet3ShlFkWWTXj1SyFwpHW3yQQabv/KQm4Q?=
 =?us-ascii?Q?DxuB3d3vsSnP79eZcqVahCVJ1hhMXmHKIjOtXXeRgn0xuh0A8SIo705I8Zrw?=
 =?us-ascii?Q?JPUmG7zm8AfMmLdRXsUxVpERzo6bZgjHfFv6OS5EgvXcsKgsO7X+MocJ8c8W?=
 =?us-ascii?Q?CLMoeqF5GeHBAPCrWzY6KRbEXP+1Tpm3Y4pR/DF4UxFT/sbJoJoo+6ah+afN?=
 =?us-ascii?Q?apLZJBeBplzRZL0GB4a1UBAXAgJcf4rVfTK85h9QCAvQXO81seV+cmHrayR3?=
 =?us-ascii?Q?DQQZkm6GKkU/et6snX0uGQQQQtVqXnvwUlbMWb7cQD27Ab4j8m8AFNDYoba3?=
 =?us-ascii?Q?phzc420IfQGxrE1gdLs9ZiSmRSd2gsQLapaqv+Lc8Akq56alGOEgYObje9Qo?=
 =?us-ascii?Q?JCT4B4zEL8kDeh/OseyCqT+sR71ybSt4BQUi70BA7KlnisiuVVkQi5C3oUXi?=
 =?us-ascii?Q?pN0tdGEYn9LmC5YJck4wLij46VJSPnIHORsNVHuHqnZH+E1hOb7r+j+FOl03?=
 =?us-ascii?Q?uiZhe1xlSKctbrTvIb1t7JYeVxv3HfSYs5DczB1tL3Kgn05fTEClIiovq5JO?=
 =?us-ascii?Q?TkFDcbEBz2MjLN2NRVajW/or/2/BSQZRSmlZc+K8ZO9SThIIFxyj2GDfYRkw?=
 =?us-ascii?Q?KkoqDxC1oXUpYL9d+wD3277lmTU1Fzcb+pAe3zVvXGqtJkGN7NwXhXXg8gfD?=
 =?us-ascii?Q?Ue4McNveg363RWFfIzJqmqkd5gIIctXcYqPruWXQxLN06VZuDMmS2djvBA7W?=
 =?us-ascii?Q?j8P5cUgMVK5wDqloawe3wcu4T7i7K0PO+hNoQ0VMRAODy/Mh8LU9iIujqdTf?=
 =?us-ascii?Q?JPbq9cSoZCiVamZTrwhsdq9mFZm1/prcz83j2+b1FSMkCsfad3R58R2F+Gkj?=
 =?us-ascii?Q?Vqy2M8LxIAeSJ2vCG6lJQTw=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?miOxZ1IRzvWIHTybW5vLTs2PPSrZNSnPMd9oxZDqpWw3ovqJC7YL74VBNvdK?=
 =?us-ascii?Q?pgzUocODQdRdHaq8pPFtRg8HlZzsdpR5VqazJFqitLO/lQFdmimcysqnGv4M?=
 =?us-ascii?Q?UuCVNuthVJ93tqijBRAIBmLk2zxpZALNpz4KMCcJgEZrSkSbAoL56ZhLPc6P?=
 =?us-ascii?Q?7JIr6dgDEr+r6kN5VObnALCANDGe/DjDkFh1eyYHxZTuJ7MDP4MA2wIkg6T6?=
 =?us-ascii?Q?FthOpLoj0caDyT3n/QgGC1RR4hypkM8ZqeIkafRM7ZPjDi4NS5yM0/jnykZj?=
 =?us-ascii?Q?3ia54iiHiFxsanJeI5CpHu8Jy7573FCvTd+Dn2FegzbEznlVA/EymtUKWPOL?=
 =?us-ascii?Q?wSyh8df4E1reULqr0qImeE6VAho1MTcR7HWKUVovIGvdLoLzeFEmpKnRcHLt?=
 =?us-ascii?Q?Niq4VjWerWrML4Y0o3ZXKCdEn3C3fBV7sbfUC/wx/l7EUaxTSDFCpUD6Kisw?=
 =?us-ascii?Q?kLmv7OM93jWHv/uWs8BveBE0j5+IB1zTyi3jrIUk9LSSsUz/7AFYcvC63mPE?=
 =?us-ascii?Q?/xkcsBD+JbJeEyYEjgwqbjMEuxhgx9PLzAU2TQFU8loDjGkRP3UDHWMJEiQX?=
 =?us-ascii?Q?av0xzRScnOA94/fzne2fC+cIGiHCJtmhdkVmSppx8EnzT7aPZ/S2lnC5INdP?=
 =?us-ascii?Q?q1BHYNSjuCKRJmtIfYAkd6tMnjdTe8BpCHUnrHlE0JsxULR4uXhkLUYw2qCv?=
 =?us-ascii?Q?1LBKR9nIrkUA/y9c0kWhk3FMu83mdfY/5I7hN1fMtAs4mrOkliGo1C2gGQ9H?=
 =?us-ascii?Q?+OLPFXFuPVS6eJmd334FQclQQNU7gFLHT/Ra9vcPuJaXp5y/PFG0Plq9KipN?=
 =?us-ascii?Q?rFg8lzsAMGdm4xxrkYRoPqwxbwgRWuyHX4+J8c8v6k9CcEdd5xGhiwdbsCvd?=
 =?us-ascii?Q?vFjQ5K4MiVw987A5B2jRhQUsNPi1L+hi7MGyKvcWG4rJ0Rudz5YMmHnZMaVI?=
 =?us-ascii?Q?9s+/1gdn+lqtOidPzOv6kTeKGJ6OR9mkHYCZ8Xz0yGHFTj2LCvy/MY3Giq4/?=
 =?us-ascii?Q?KDfeb/COEnGdQJJRtQd05MCdzA6Ls4wo/TdNt8KRhS9ij+OnXh08CnZ0pL8T?=
 =?us-ascii?Q?Vxjjp/cSXappdCbeU+h5C6uhklY3Fw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca18f853-7347-4ad0-2477-08db00a69e67
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 20:39:42.7531
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cs3RFjNvXAxqIwAkW//TvpsRaJdS3l4ToNvGuQrfH5htKkg+nkk/vv3IYnPVduyuzvScXviANkfaTe2WXL82+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4605
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-27_13,2023-01-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301270190
X-Proofpoint-ORIG-GUID: de1f8OExtlM3CVitqot1tHNhPyoypEwu
X-Proofpoint-GUID: de1f8OExtlM3CVitqot1tHNhPyoypEwu
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

commit 07b050f9290ee012a407a0f64151db902a1520f5 upstream.

Relocatable kernels must not discard relocations, they need to be
processed at runtime. As such they are included for CONFIG_RELOCATABLE
builds in the powerpc linker script (line 340).

However they are also unconditionally discarded later in the
script (line 414). Previously that worked because the earlier inclusion
superseded the discard.

However commit 99cb0d917ffa ("arch: fix broken BuildID for arm64 and
riscv") introduced an earlier use of DISCARD as part of the RO_DATA
macro (line 137). With binutils < 2.36 that causes the DISCARD
directives later in the script to be applied earlier, causing .rela* to
actually be discarded at link time, leading to build warnings and a
kernel that doesn't boot:

  ld: warning: discarding dynamic section .rela.init.rodata

Fix it by conditionally discarding .rela* only when CONFIG_RELOCATABLE
is disabled.

Fixes: 99cb0d917ffa ("arch: fix broken BuildID for arm64 and riscv")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>

Link: https://lore.kernel.org/r/20230105132349.384666-2-mpe@ellerman.id.au
Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
---
 arch/powerpc/kernel/vmlinux.lds.S | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index e3984389f8ef..fabe6cf10bd2 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -379,9 +379,12 @@ SECTIONS
 	DISCARDS
 	/DISCARD/ : {
 		*(*.EMB.apuinfo)
-		*(.glink .iplt .plt .rela* .comment)
+		*(.glink .iplt .plt .comment)
 		*(.gnu.version*)
 		*(.gnu.attributes)
 		*(.eh_frame)
+#ifndef CONFIG_RELOCATABLE
+		*(.rela*)
+#endif
 	}
 }
-- 
2.39.1

