Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B79C3636A43
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 20:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239145AbiKWTz5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 14:55:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239177AbiKWTzY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 14:55:24 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDC422713
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 11:54:36 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ANJiX3m009796;
        Wed, 23 Nov 2022 19:54:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=8ItNy649FN2cS/hBlkmzbF78ZBWdLK5y/XeURfLXDKY=;
 b=jUQhfJWQ+yFypKOa+eXlDi17bpm7UDaLM+4c7QNcKAN6b5y+DeZjV+s7bDybJ5eNafgx
 fDfv3yO3CHtz8fzp7973wTkxNAbou0kL5EZjnlv0i3Lg2o3LlrqyJUgJmnQjoCbswG4x
 7k7g1Z0b10Vr1aIOItW2ChfgyKLipN+BsahzzTu5pvr14M4SZ4T7SVmQDukPSsVjF1ZW
 KypUq+lwOaTIsorqVKQE/0Pgyoq1/jM+o09DmjARTce11AMO6L8xMM9YNMby2Z6RpjCt
 tBceHbpJXhvp0m48CjzfwUNkMD3EZhWYeD0Px5ShHxWbUVxtkuQHqqiPt6C+8bcn2kjR RQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m169535wq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Nov 2022 19:54:17 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2ANJKOFf009739;
        Wed, 23 Nov 2022 19:54:16 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnk7gws6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Nov 2022 19:54:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OjvIt40pSfnE23WraRfnx76YLSOZiTbyw8s14eN19g2jzU3qhylOB9fBPk4rAlgxEDhRW1cC1jO4YUjwTYMoF51gUs8fp9YYlGRQXpwRpJDX6khVcQ4KCQrrhlyniYmCXx6nYUDGXFgCgYnDRQ84Gl41+lmmFReXxYFsCcqd8EcrNy6SqPOZVGlMLJ9Mns/bPU/CiJvsHYkzkv4w2DYZwb+a/jfeWxxbfea8fAh4JtMJZfJMHlA7xwYSTNf+ImIxKI+Qnz9l8hNgDOD/UC7dy6z9lFyJs5hqULAQIZE5RHFyYDFpH44k8coGw5YrJR90Az6BOipyKc/6ArD3RKH2Ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8ItNy649FN2cS/hBlkmzbF78ZBWdLK5y/XeURfLXDKY=;
 b=C5rL6mSRWwIr3a4yBxxLZp+2ZNTmRsuSDKsEOA4e5OvNjo8FOEHLzOj9n84NAe6X6jlzhLUHQAIjxfRDcE5t151KULPxI4Yb4WIA1BUEfIeD3wI2CuEtrOMgjLjUhPxJ5m3gijsyrKACiAw59/X59Whqw6nUlfRl4WPKb2oZV5oQ0HDy2aJ0YVwOsqS4lPs61AhSUoHRgGyMZTW1WAanQL4/SCIp3j+kcsQrzcKt2fHVE7sFuZ8RBKfAq6GlyQXWyBmRLb8JOyiRCmdB3UxNKQdS16R2ZHWaC8Jii9nY9X3kAhu8rwkv5ktVPORHE3077W9m+I/tOCH39OnmpheTzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8ItNy649FN2cS/hBlkmzbF78ZBWdLK5y/XeURfLXDKY=;
 b=fpIJb0uKhf6t6SSD5mmE6zAQ3oeh2h+vMLsvUhk9rrvtQOMJ0EqykyQg5MGmdGNrMJ8V2WFKX5WgBhCHFdFsKFTpuh76R3UM1kdh/6htFu8H1Ir5Hkn5zfq8R5hyosqTtWSmJkVwNRPxt/Th888g+bYcDcpjiO2TZobgqsMu2VM=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by MW4PR10MB6300.namprd10.prod.outlook.com (2603:10b6:303:1ee::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Wed, 23 Nov
 2022 19:54:13 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::8d67:8c42:d124:3721]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::8d67:8c42:d124:3721%4]) with mapi id 15.20.5834.015; Wed, 23 Nov 2022
 19:54:13 +0000
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     stable@vger.kernel.org, linux-mm@kvack.org
Cc:     Yang Shi <shy828301@gmail.com>,
        Naoya Horiguchi <naoya.horiguchi@linux.dev>,
        James Houghton <jthoughton@google.com>,
        Oscar Salvador <osalvador@suse.de>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/6] mm: filemap: check if THP has hwpoisoned subpage for PMD page fault
Date:   Wed, 23 Nov 2022 11:54:04 -0800
Message-Id: <20221123195408.135161-3-mike.kravetz@oracle.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123195408.135161-1-mike.kravetz@oracle.com>
References: <20221123195408.135161-1-mike.kravetz@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0192.namprd04.prod.outlook.com
 (2603:10b6:303:86::17) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|MW4PR10MB6300:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e301b64-4302-41eb-7cf7-08dacd8c7eb6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tBI4JtbNiNYlFenuFd+dGNhsGd8JuOOO624ezUCtQOnAw8IiZu2bgl62Xf6PKmBdkuSyM8vPDyxah7iTTK3733JCXAz8a4fZkMOHFXVs58hotHT83/+N4S4IwGy1CO9O0ufbvTFU6KfX7kTPBD35t/ARbIUzgBj+i+rWbyaUKgbcPz+519zVJLpkfjZ7UAmEDxdUTtuHTSP+HRkaKLs7S6TqHoBJG8+CHKbw39t61agld3JyRYOMCg/0PZU/jZJ9y23EtvbYYccLRw2D670ZDq+SkWkUbdq3ks5LFePNwYEAmfTxqZsa59wRiBMPm7AYzB6RjgGLYW5OCF9aK+BzNKmBkqAhiWujHa5xdz7Y1RQOugv+ybSLiasosIQKP1jrdEEkNYQQ3KNJOfOnRLBj6GdeSlh5gQAbNQOpZw0K3KEoSyS0kErp6VmMaSTc8cIDqAbqm6WSAXyvaxr2lpRA9gE0Bvi1ynleljycvu17zxbrs/BzMWqlUR3V1QAtJ6u/lWXUT9X0DPxwxWG7aZmmNPC6AiAUU3vB2eLwxow+afb25Gp/igMfwkMpmrg/VqoBEMwfZRYUpNH9Skubuyy2x4G8nFoezRgxyJzQ2k/N76nwTpG7cL1ydLDpQssRbCxmdCfl7yUepdiPXSAOItxHtevLb41+wvruoDPai4FPOF4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(39860400002)(376002)(346002)(136003)(451199015)(36756003)(316002)(54906003)(6506007)(186003)(1076003)(83380400001)(2616005)(966005)(6666004)(6486002)(26005)(478600001)(6512007)(41300700001)(44832011)(8936002)(5660300002)(86362001)(38100700002)(2906002)(4326008)(66476007)(66946007)(8676002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vcsFRKEqROvBI/FGrI3TwlTPw0FievWuSDbtzJBiskXZI0A3MBd8N56qkzrn?=
 =?us-ascii?Q?72SCZc1oEIVpll/4QwT1s3DDD1AjlV20cLNr7+JW5WjuSVRXQ9242a9GTcJw?=
 =?us-ascii?Q?0i+ABACH4sjt71eLCNqKJvuUZt1YbmnJj0vr+9sgafUlSP8zFH2Jnvh5PQ9X?=
 =?us-ascii?Q?ElSTzIf+kh0aDnpGf+OCxVqWqO+uyWus6kEbxYn5BmBt5R4DKd6htzFayVXw?=
 =?us-ascii?Q?h5euN2txs8IMJ+pLIVoHqYglLC4yihDko6PGooeQN6TH9ZBtjIQLSdT/fWvU?=
 =?us-ascii?Q?2tXJNp2eeElqnp/xB11y+Fc4rW9pUPkTlxAEPKS5N8UdalfeRECxN/asfDlU?=
 =?us-ascii?Q?V42ig81MjePIfxfMtRfMS313vDFmb50weRV0+AJovTSpVuTynCofojZY/xAl?=
 =?us-ascii?Q?oT5qxt4naiTNBbyLnVxN16cHYG/yhHAfLCAIadoUnOL++r2MsCC7bJ5k44Tp?=
 =?us-ascii?Q?NMasQe9jZlNOS5+gEXPMgBcZx2DmKrm+dEx1HB/8nJ2TahvSUR7l44oE/pBy?=
 =?us-ascii?Q?mfH/UNjEeIEPDWd0epB8PiR3rh05vh24/DrACgs3yfNyu3+5+XfHUuY/Y/Tu?=
 =?us-ascii?Q?n86BdSTYM2+Z5FiZ8RGvHEKC83lYQuNDxHv5COBID3AXK0+la/W3+ggSVJdi?=
 =?us-ascii?Q?WIZSZ+Z8izqt4f5Ej4KwHP/Kvwotz8vGmJS3MAfzNUhiyWPPta9WxSbmKauD?=
 =?us-ascii?Q?7xQP1QgFfowtE8CkTOKTDrZm7uWzb0ffezi4uBg91f5QSgYYHOYCJ85u4O13?=
 =?us-ascii?Q?Oz8NrADDyY/02fovJ1ve+YrsWwWQhSaSXPPuaX++7O1RhErN1RVNSmdflhOF?=
 =?us-ascii?Q?e4inyPYN8vz44hFmS4Beaaq9IouGxIgcjviY6XXUPm0L9NlTOQ3Otgqa/Cal?=
 =?us-ascii?Q?bmNd3OMs/+vaO+NXiEoGaVAUHoIEHG/mN2Gwv2f0XnIGXCAJDY3szbL+mvJ+?=
 =?us-ascii?Q?z8xeREsFAJH+QwO03CgX/KX9K3r7b0Hp+KaezruxhJ/IhuyNOJEsI+L7YePN?=
 =?us-ascii?Q?v9xLyMuRDJbFyyDh9xszlpYe7mLFUUIJ9Nr4NyIAoZCugRD7uaEAdADR6Xiw?=
 =?us-ascii?Q?VJlnUQOqzGv3xgD/HjIUKtpPgmSbTXdgxN1JaU1uWhSa7idIjW1oPsHhrwlT?=
 =?us-ascii?Q?LEHryfydF8sW5atZ0Ld/i4Ck582WwOY60go71HFpuipo+fb5wO5CtvZmy6Cw?=
 =?us-ascii?Q?6rFIGfLG7v83OK8V0EA3ztiE9lkbYakGgxFxLHIfTEV27woWu7tb8dm8ZuYP?=
 =?us-ascii?Q?gGW9Bh3XbEcozvNborY/X0pFrPsKgKdB4KkMO9curL81Z1MWw9a26kbMWZAh?=
 =?us-ascii?Q?sWqRfDz1PGhn2OpA/kqHAZ7wGcrByOLQXVnLnttpa++76jlU1bdubgZ2pcQL?=
 =?us-ascii?Q?KNlRT1V//ClCZ0ZMFPn5o4WNymJsX6hLi1Al+P79irecNWw+KxbzE21FTGSp?=
 =?us-ascii?Q?dB+PYK/cnLvtkZp4qa9B7rdKRp3F20btgS2hEVMdpn/Hy3fc1NL4m4PNJdZv?=
 =?us-ascii?Q?Gzv7MlJ8N+8rvxBOayGffqGPRyAdozxD98TLkIam891tITF4t3ZSslxaJ8Hw?=
 =?us-ascii?Q?1h9r89kChaWnea6dVjZ7BICZz/Ni7VTDuHHBAtMcF7b0JxXEfeKkdkT5/2oM?=
 =?us-ascii?Q?SQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?4bmhcq8L5iU7zsSkTC7iZaUYKzkX15Q97hrK1Z9eIqlhF+XL1mlb2PkU43KA?=
 =?us-ascii?Q?DEncWHvfvuNYODezWDC0hFvhzHAdNMsQSqN8r5C9xoYXJtNqnVVa6DoyCL2o?=
 =?us-ascii?Q?jJXHRi4yH1pPONOCx0LPkcqQxhetnjVepoqCBw9GKOwfIHq0AhSlr6s76kxb?=
 =?us-ascii?Q?DCGZI0ArlEcdWKd9UoUQ6n5oHPWeRXiVwbgskYB6Ewz+IPg+08zwjmAN41Vk?=
 =?us-ascii?Q?8JwQGCUeOj2sByBDus99TC0kiRh6NNp+GWJ9DePTo4IcZ7xIHxydtc2VfaBw?=
 =?us-ascii?Q?D+DIygtqGgL/iPN2uT1r4L6Jxu7DUOP2ZogXvKu/2KOj36RRW5bA3WkjQC1F?=
 =?us-ascii?Q?VOW6u4INm/xwus6jJniKZ+nUfY6ghdzt/dh9iZWBgoOCKVMdOPvCih0x0viy?=
 =?us-ascii?Q?WHGBMXtgMcah6EFkvyacKxApmT5SNWjp+VsenLoKEF6WcTUYbSgma0KazzqV?=
 =?us-ascii?Q?GK4Lsw+karh9z29w9MWABK1qkAYVIbrAHvd2/FepDdKl5Rah1qKNJX+MbPWo?=
 =?us-ascii?Q?HJ5/g0ndReB4xPIR2nmGM7HSL3JaHMZm2m9Cp4Jva65S5pbqiW5wFIfcDd+M?=
 =?us-ascii?Q?3bqVrOKOabxIggeGQOXYZt1TCgUDuc7Xtu6eCdKP219Dtc/i/Hoz4BfQllKi?=
 =?us-ascii?Q?9QApCdDcPyRg8Dh4qa4K4zo0sQdK1R7r8Dg0finl0xWzgxoYfivSs93+2yV1?=
 =?us-ascii?Q?B4s3t1iJ+vRY9ZWo9S7ozsB5zY3L+hfywmn+YLN20ffgmkAfjkFDH4dv7xRh?=
 =?us-ascii?Q?1Sv68nkAqXBc+ymkAkOTTmbfZecLYBZfD91uc3KiWXQn03rabycbXi3lU4S5?=
 =?us-ascii?Q?y8uELeow7jHM8Z44cZ4x8ioFLdFc0BJoyuxWDyDxQKRHgxGx8G1NxUO+zRMM?=
 =?us-ascii?Q?w4tQ2zn3GzL7s9r94VroShVO+KM0pIMnBdTqcfkQJVnJHwAo5OfehAOziNP2?=
 =?us-ascii?Q?U/xKMV+iX5iLFKKupYfdyu5XA5X6XlD9H7iei3h23iZLQmG+WbqNLLZ+3sd+?=
 =?us-ascii?Q?1xp0ZnMwMhSYdckWtn9uzsdliw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e301b64-4302-41eb-7cf7-08dacd8c7eb6
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2022 19:54:13.2288
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dn1H1ZY2Xs9qaoY8PIH+BjrsHXOC1ICv18DqtfvvDeVvdPySlFrs7yDnooKHnmUaA4xsN9kQDZ0t+Vqubd8mvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6300
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-23_11,2022-11-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 malwarescore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211230147
X-Proofpoint-GUID: D_C3uVakfdRBOsPs5x5heFCBojso_s8G
X-Proofpoint-ORIG-GUID: D_C3uVakfdRBOsPs5x5heFCBojso_s8G
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Shi <shy828301@gmail.com>

commit eac96c3efdb593df1a57bb5b95dbe037bfa9a522 upstream

When handling shmem page fault the THP with corrupted subpage could be
PMD mapped if certain conditions are satisfied.  But kernel is supposed
to send SIGBUS when trying to map hwpoisoned page.

There are two paths which may do PMD map: fault around and regular
fault.

Before commit f9ce0be71d1f ("mm: Cleanup faultaround and finish_fault()
codepaths") the thing was even worse in fault around path.  The THP
could be PMD mapped as long as the VMA fits regardless what subpage is
accessed and corrupted.  After this commit as long as head page is not
corrupted the THP could be PMD mapped.

In the regular fault path the THP could be PMD mapped as long as the
corrupted page is not accessed and the VMA fits.

This loophole could be fixed by iterating every subpage to check if any
of them is hwpoisoned or not, but it is somewhat costly in page fault
path.

So introduce a new page flag called HasHWPoisoned on the first tail
page.  It indicates the THP has hwpoisoned subpage(s).  It is set if any
subpage of THP is found hwpoisoned by memory failure and after the
refcount is bumped successfully, then cleared when the THP is freed or
split.

The soft offline path doesn't need this since soft offline handler just
marks a subpage hwpoisoned when the subpage is migrated successfully.
But shmem THP didn't get split then migrated at all.

Link: https://lkml.kernel.org/r/20211020210755.23964-3-shy828301@gmail.com
Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
Signed-off-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Suggested-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
---
 include/linux/page-flags.h | 23 +++++++++++++++++++++++
 mm/huge_memory.c           |  2 ++
 mm/memory-failure.c        | 14 ++++++++++++++
 mm/memory.c                |  9 +++++++++
 mm/page_alloc.c            |  4 +++-
 5 files changed, 51 insertions(+), 1 deletion(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 4f6ba9379112..3f431736cfc0 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -169,6 +169,15 @@ enum pageflags {
 	/* Compound pages. Stored in first tail page's flags */
 	PG_double_map = PG_workingset,
 
+#ifdef CONFIG_MEMORY_FAILURE
+	/*
+	 * Compound pages. Stored in first tail page's flags.
+	 * Indicates that at least one subpage is hwpoisoned in the
+	 * THP.
+	 */
+	PG_has_hwpoisoned = PG_mappedtodisk,
+#endif
+
 	/* non-lru isolated movable page */
 	PG_isolated = PG_reclaim,
 
@@ -588,6 +597,20 @@ static inline void ClearPageCompound(struct page *page)
 }
 #endif
 
+#if defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_TRANSPARENT_HUGEPAGE)
+/*
+ * PageHasHWPoisoned indicates that at least one subpage is hwpoisoned in the
+ * compound page.
+ *
+ * This flag is set by hwpoison handler.  Cleared by THP split or free page.
+ */
+PAGEFLAG(HasHWPoisoned, has_hwpoisoned, PF_SECOND)
+	TESTSCFLAG(HasHWPoisoned, has_hwpoisoned, PF_SECOND)
+#else
+PAGEFLAG_FALSE(HasHWPoisoned)
+	TESTSCFLAG_FALSE(HasHWPoisoned)
+#endif
+
 #define PG_head_mask ((1UL << PG_head))
 
 #ifdef CONFIG_HUGETLB_PAGE
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index cb7b0aead709..cda0ea6c8623 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2464,6 +2464,8 @@ static void __split_huge_page(struct page *page, struct list_head *list,
 		xa_lock(&swap_cache->i_pages);
 	}
 
+	ClearPageHasHWPoisoned(head);
+
 	for (i = nr - 1; i >= 1; i--) {
 		__split_huge_page_tail(head, i, lruvec, list);
 		/* Some pages can be beyond i_size: drop them from page cache */
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index ae8b60e5f939..b6ab841d1db7 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1367,6 +1367,20 @@ int memory_failure(unsigned long pfn, int flags)
 	}
 
 	if (PageTransHuge(hpage)) {
+		/*
+		 * The flag must be set after the refcount is bumped
+		 * otherwise it may race with THP split.
+		 * And the flag can't be set in get_hwpoison_page() since
+		 * it is called by soft offline too and it is just called
+		 * for !MF_COUNT_INCREASE.  So here seems to be the best
+		 * place.
+		 *
+		 * Don't need care about the above error handling paths for
+		 * get_hwpoison_page() since they handle either free page
+		 * or unhandlable page.  The refcount is bumped iff the
+		 * page is a valid handlable page.
+		 */
+		SetPageHasHWPoisoned(hpage);
 		if (try_to_split_thp_page(p, "Memory Failure") < 0) {
 			action_result(pfn, MF_MSG_UNSPLIT_THP, MF_IGNORED);
 			return -EBUSY;
diff --git a/mm/memory.c b/mm/memory.c
index cbc0a163d705..1e9f96caabbe 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3814,6 +3814,15 @@ static vm_fault_t do_set_pmd(struct vm_fault *vmf, struct page *page)
 	if (compound_order(page) != HPAGE_PMD_ORDER)
 		return ret;
 
+	/*
+	 * Just backoff if any subpage of a THP is corrupted otherwise
+	 * the corrupted page may mapped by PMD silently to escape the
+	 * check.  This kind of THP just can be PTE mapped.  Access to
+	 * the corrupted subpage should trigger SIGBUS as expected.
+	 */
+	if (unlikely(PageHasHWPoisoned(page)))
+		return ret;
+
 	/*
 	 * Archs like ppc64 need additonal space to store information
 	 * related to pte entry. Use the preallocated table for that.
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a56f2b9df5a0..8eb745920cac 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1232,8 +1232,10 @@ static __always_inline bool free_pages_prepare(struct page *page,
 
 		VM_BUG_ON_PAGE(compound && compound_order(page) != order, page);
 
-		if (compound)
+		if (compound) {
 			ClearPageDoubleMap(page);
+			ClearPageHasHWPoisoned(page);
+		}
 		for (i = 1; i < (1 << order); i++) {
 			if (compound)
 				bad += free_tail_pages_check(page, page + i);
-- 
2.38.1

