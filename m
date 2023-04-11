Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EFA56DDF42
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 17:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230498AbjDKPNs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 11:13:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231133AbjDKPNO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 11:13:14 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 753415FDE;
        Tue, 11 Apr 2023 08:12:18 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33BF1VMh017728;
        Tue, 11 Apr 2023 15:11:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=KwTRZvfmXg8ueSr2QlXbeN2FLpmUcJMtKSU/NB0envU=;
 b=m5m3eAl2Ck308B4f/Q0O6r/4wFLWBW22P5NE5jswH8sqRv4qDmmdhkkmahFqAfbRekPn
 fPsaNKo37SJiXCFW+u8merWcn5ps8C/m8hXm0M43XGQZVhX3FntI/RfmWzoGlFznluh+
 TnMSMYuPVfHazZRF/PzV86JXQgEF3K0OMZdAYm2LvbNSXZtNH1YHX5s4FPOw8OIMolEr
 4EjOADa9eyDuFC3xMjdXjzSQcOQzzGs6lcBDB6DKX6JQSyEcucz4ZJA5d+tkYDEVq6QB
 j3MpUbpcnMy7KufUOaLNvM2Ys1accOkH3wJo89zZafkxqIp/BQWnBLkftZ9zgHHt8VFN DA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0bvwr6v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 15:11:59 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33BETset025052;
        Tue, 11 Apr 2023 15:11:58 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3puwe78w90-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 15:11:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FG2MxUwNfere9JKzUKKZaqmTbN2YTfNlT13RwMDbHVjBDaDIMsOIvb1IB3pHxUvc/R7uk9+UED9NOwlsRSKofI2/M1dN00A+U45raOkfrVA80P7DzVZvEDOiJdwtbx48D+uo5GuwGOPwCqXlbtcd/LoKs4TEngqx8AUSr+RIAnZXZE2uswJwtXijAtS5kIk/+ar/0zGCseEELbjEz4Vt4yem5Si4ShC0udeEp4OPyDcu8pe13wb8J1yGBfVHhdvcMUcxNYp/xu3OZI9Ho2Al/X69bEIrZFi5wDZ/X1YEuDTT6SLpoxpwrWAUIeBEX/0P048ltOzIDGiwoukGJvCw3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KwTRZvfmXg8ueSr2QlXbeN2FLpmUcJMtKSU/NB0envU=;
 b=enilCYkoZdJ23RkETTB5yo2Rm8Nzogjh2+EGbnPsG17C1+Ok+4jO8pdxWdlzsAiPxj4MfX3U3LRiXW6TjQLLqY2g+9LCZK0s5NzDUELJo9fL5YpLZ6YuSsOPfl529hTCJ7XzHUlSfT5Y6rWYuqLFIIg97gc7HIRFsRQqWX8v+GZZydKkrjaUhYVrkzSKDk6OaxZMLH2AiW+a4PoW8BGoP2zIwiocbbffBWc7Pv3fwyTiqqmUwV+/JMteCMuChfW7GeA3sBZvCyNh/gv1zd7clPo8QWuPmZu1cfOStzp240g1VDtxQvKSJZUrrmYO70OZHqQsRUGOYFMPvXkOgV45Ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KwTRZvfmXg8ueSr2QlXbeN2FLpmUcJMtKSU/NB0envU=;
 b=B5O5oSSPGNpvlB7KuGCHOrtzo2dsnySDGfT0aEjqGA/F7RA2flJQe2PjjqJWlnyiJoe6P9q/SrQYanG0NFm75JMJQlDDN4AV2Cc2687j5Y1wwfsAh5aCwzYNSFbEMPdVEPPboyFENPtWqyH5MZzEz4+IVbQCY95XbyDsnyInoSs=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by PH0PR10MB4807.namprd10.prod.outlook.com (2603:10b6:510:3f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.35; Tue, 11 Apr
 2023 15:11:55 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::8bb9:2bb7:3930:b5da]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::8bb9:2bb7:3930:b5da%7]) with mapi id 15.20.6277.035; Tue, 11 Apr 2023
 15:11:55 +0000
From:   "Liam R. Howlett" <Liam.Howlett@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Liam R. Howlett" <Liam.Howlett@Oracle.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        syzbot+8d95422d3537159ca390@syzkaller.appspotmail.com
Subject: [PATCH 6.1 14/14] mm: enable maple tree RCU mode by default.
Date:   Tue, 11 Apr 2023 11:10:55 -0400
Message-Id: <20230411151055.2910579-15-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230411151055.2910579-1-Liam.Howlett@oracle.com>
References: <20230411151055.2910579-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0062.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:111::23) To SN6PR10MB3022.namprd10.prod.outlook.com
 (2603:10b6:805:d8::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB3022:EE_|PH0PR10MB4807:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a26aef0-c898-413c-368c-08db3a9f1647
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wQCHhqd2yiOW15ifxXZqka0drYtLzTqLOSYQlYtPSVzbf9Jt0oWui7QMARyYzVAB1bIpaDdSOKcNVBnbcm9Dv3IBPMS5aEon5+0Y/1xYM++RalN2+gl5Rv7KKmMqrWMC+NfiOyV+FYX0iwNUdGtlCht9LyGH8ajEQq5jE4K8GrzWMAbTPuHq+JYWdvsRaViAAk7mJMZwK/5a3/lvmUBESAJDbOpRLjtZjWNazv76FRaQxNb1mjodfqpdQt2dZpDunYVztwdnxFCG8r7JLpMOryhm6dVFbxOmoHtRYC+kqezuzkJ9ep0vC8z47c3EobCFRsaiQGehBLA+mB37OAJH+Aj4J0ivgC2ydLimSBvyPkR1XEjWWyQsRhyfBhQFhUSI/46bvGMo7sQ0YnXwjeZzu522ZeehNsHE2bKADrLcfamKd38lh1GfOapgOrphI87oJY3Z3oYIgA3i5iVTV0/U3WtyOVxiy7Xb8gnHO8SOfXwAZS1ZqwBRvEQFBER00kOYv1DwFcGQJpwbXGJpNTQudG9kBOdB9LEuqS/L0o9Pccw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(366004)(346002)(376002)(39860400002)(451199021)(478600001)(1076003)(6506007)(316002)(6512007)(26005)(186003)(54906003)(966005)(6486002)(2906002)(66476007)(66946007)(4326008)(8936002)(66556008)(8676002)(5660300002)(41300700001)(38100700002)(83380400001)(86362001)(36756003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EA3AGAnh94CTLQzCTUqeV70TWjxUYnnj+aCz1V3gA7o0/5xLeTwoyrDc+kUD?=
 =?us-ascii?Q?wP0DaQwbZxuU4z8oIpA3Dm0u+pO9Q9mN3ZURz0J/VAKXR7dPGrqg4syHE/ut?=
 =?us-ascii?Q?otL1ZSE5mDgRfhij+xPwK+BguvNWSg/WKQBXTLgtJa77yos7KRv6tB9vznmZ?=
 =?us-ascii?Q?fixd7Up2wJHuMlZ4XknyfXTy7D74uWDybW2BpMUYex4zZGPq8v46sio8UVTB?=
 =?us-ascii?Q?QEHqDFDeuCavYhIPx+8fA1gjORoNmw8D+612UqDt3kJHVx+DaNdsgmwFLJvT?=
 =?us-ascii?Q?6zD17q0A7NEsxg0qvyFMhGqNdMD9SG2DeOxIdt6dZX3dHr2Pp5iA70J816WY?=
 =?us-ascii?Q?lrBUa4iOimvMA4aefuzLNG2l5xHe+zGs6UNmD6PD9FEhZ+3PkroYhBxQYAdo?=
 =?us-ascii?Q?SqCrn3TMRUz8gc1Qx/71A9Cy6YJ9tFHeoFG7V5L2Ke32KlXw36TkmZCpibl7?=
 =?us-ascii?Q?uxfoh1KN7Bccr9nkAgGa0k9DQ3H/GqFLizeaD31OYRiEhTrhphHNlrvd4qHf?=
 =?us-ascii?Q?YKSYATKm8n/4+g8P44nBdTkxz9PrLrG+mw4cte4K658g8zG8JyuAHq6HfjHT?=
 =?us-ascii?Q?QBRxEgC5O1T6YUMm6RRx5GanIxtrU+TazRj+DbvHj37IZZAMZHAuADBZ+8X/?=
 =?us-ascii?Q?rKh1n/aFZsXU8KSaRATDFNBYva7XsxaT81PY80bP6EUrpWqUcCqrB9F/D9+u?=
 =?us-ascii?Q?RZoNPrtJCXRTJNu5cI4CzsyYeD/stQO/p3mgpQ6w/8Ub913K4GCeyUEo5Lm6?=
 =?us-ascii?Q?iAs9sEQxZwzv7THCZXtFZ7wFsPf2Z6I7cj24U7NkmBliBhY7bEEJDXr9YIzG?=
 =?us-ascii?Q?c40aTbcGY0YYnVVZATluKkj0g/8EcvMxVwbc/SI9E7dtDlYhoBlp5v/+H+Up?=
 =?us-ascii?Q?Kw4TtM3x7NhAlfIKhKYLSkWIBg9POVppKMvLpkoKCtfpyHZVf20CS+W0RXcg?=
 =?us-ascii?Q?y5vix4B7CFu2evhu/8cjliP8J8uwzRZQU27uWFGjyc/tbPXmM5YTF3AYwEK2?=
 =?us-ascii?Q?f80ZaGdXwKFFMU5zbLv1QeBUuPChmGCbgs3nMOgBvy+wfLHANMroR4yZw10N?=
 =?us-ascii?Q?S4kl+lsxuoADGe29lLYVZ50AfTjzUVSUmONevbaPkITCOsMsMyim7GoKUcss?=
 =?us-ascii?Q?J02AfM+kY9qWUmzVWnBajfHzteAeTj/ZmS3wc1+VukKwtm8lxcHhG6OQEtrK?=
 =?us-ascii?Q?YU+XHYO6HLMm+Cp4/KS9n4f5CwCtW4BI9tYyWWJuMq0b4zpUQf8W3wP0n7EP?=
 =?us-ascii?Q?LOUqRxDSFKZvYl0NazqOxvJNeUfv7gbUoZrTapWiS3km7e5QPnz30N6FvJW+?=
 =?us-ascii?Q?E06WCJXdfqkVs5kbZ0uMB8RkK2hyD9PFvVL61yHiovCvRGEghII+HOWmJOCf?=
 =?us-ascii?Q?iOQTR8slFIef+kKhrvE42/NXqpWlpamVk5++gzv+26o9TQ9t0XTFENSw2zAs?=
 =?us-ascii?Q?VQshellfAkSd/y6Ou8lyu0V6WapZUgy15/Lux1aP+E6+MTKR9tCIFYRUtLN1?=
 =?us-ascii?Q?tNnSe8oUiT9OizxfvV4Wzc50Bue9IW8LfgWwL+jpyApMUMAOkqVtJ80qTTYO?=
 =?us-ascii?Q?6WP3zIo5SXpI4kzXoa9H+t7f9iuD1qXJ0NIP30zvmrFBlc2zHyRQcsJrSUaV?=
 =?us-ascii?Q?9Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?oZFFVcvED3/sy04GtX76RA3x+tZ8igdSetfWQayRREdK29TLI1ffHMFgps8T?=
 =?us-ascii?Q?8tRVd/ySFNn7Rt3CjCxHVuS6JSDPXiNqo8ZGBE/Hox68SHfSx1fGkKLmZB0J?=
 =?us-ascii?Q?7gb4sp+ewssO8kUv5N50OBBJsV+NkK0o9xw1BUqWDaV4bWo2/ySpjX1zRyjm?=
 =?us-ascii?Q?lWDyR91us7qb1X3qQU3zekfu0UqFrOECQ7nZO6/zmb57TJzHNSl2Nn00ETw+?=
 =?us-ascii?Q?TULmXJu5Nds2b13dHz+ejaqex2dPHJM3msVddeOoOJoZtyQomqUbH432/bDm?=
 =?us-ascii?Q?kkmci9WRXt5EciQpKhux/U/ZzyggxVWsC3iGnbYbubdkfsfN3gN7tt9RrQsG?=
 =?us-ascii?Q?4WbcejYPz4BCvboijLTuW6BvevtAxH3mB3aGPf59q7JX1jEKkyaw2Obtafg9?=
 =?us-ascii?Q?3t7EWrTFYvWiEWRgicCezbZBERP0M+Da3QcY6bOt6363lfXIJw2wf6KxHJGj?=
 =?us-ascii?Q?L672Uzwb5qmBeb1aLdMUQV/WTjq58AcUKJO1sgRnOqzGSJP138Y1AHKQivHr?=
 =?us-ascii?Q?QzY1daciFp5vK/O4mr9etBFI2MHXsbw8kdHn9VErAL1r7lZupRygteO2phhY?=
 =?us-ascii?Q?IjTMPJgX1dxRwbGjZuFFtooZRIFvPgrbLjCCvApNvSTIUdgaaxPJFEJRelkX?=
 =?us-ascii?Q?fFfzcLdrUHeIAWbt3vEhn27ndovYj+Crhf9bvo6b7fe7WfjMXBS5Y578lkKF?=
 =?us-ascii?Q?cKmY2eF97bs4Z4046ZcNozgQUhKN6PBM9Adf+xuJFuOq2Z6vT8azQ2ipSvMA?=
 =?us-ascii?Q?rzNYYgS+xoCLVEy8ul23vrAhJYChl4ITOKDQAdYEWJiylwge31opDQNzGrE/?=
 =?us-ascii?Q?ufH1obVUw4z03EwRhIM7roIH53BuuyeZPmi6iCpfijLxJ5Odo4g5L9vrShXo?=
 =?us-ascii?Q?Jj7Xn5Fy2wLWlIDTjmQTfi4e+dBm9RNlBtL4EmiQYU2FTwZsw5E3UJavFIJD?=
 =?us-ascii?Q?4oMnOUSbThycpZ9S+YFtTA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a26aef0-c898-413c-368c-08db3a9f1647
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 15:11:55.2052
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1F6ajSxra640PPO//3v/yjr1gwQ9oQ2ThwtjUBbq8V3XsdhfSCiUsnufWJYE8rOn8vrmFnCWh7UYBRMQnu8Mqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4807
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-11_10,2023-04-11_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 adultscore=0 spamscore=0 suspectscore=0 bulkscore=0 mlxlogscore=501
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304110138
X-Proofpoint-GUID: Wq1DbiT2f0YinvcTIZlN3kicYqXofriS
X-Proofpoint-ORIG-GUID: Wq1DbiT2f0YinvcTIZlN3kicYqXofriS
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>

commit 3dd4432549415f3c65dd52d5c687629efbf4ece1 upstream.

Use the maple tree in RCU mode for VMA tracking.

The maple tree tracks the stack and is able to update the pivot
(lower/upper boundary) in-place to allow the page fault handler to write
to the tree while holding just the mmap read lock.  This is safe as the
writes to the stack have a guard VMA which ensures there will always be
a NULL in the direction of the growth and thus will only update a pivot.

It is possible, but not recommended, to have VMAs that grow up/down
without guard VMAs.  syzbot has constructed a testcase which sets up a
VMA to grow and consume the empty space.  Overwriting the entire NULL
entry causes the tree to be altered in a way that is not safe for
concurrent readers; the readers may see a node being rewritten or one
that does not match the maple state they are using.

Enabling RCU mode allows the concurrent readers to see a stable node and
will return the expected result.

Link: https://lkml.kernel.org/r/20230227173632.3292573-9-surenb@google.com
Cc: stable@vger.kernel.org
Fixes: d4af56c5c7c6 ("mm: start tracking VMAs with maple tree")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: syzbot+8d95422d3537159ca390@syzkaller.appspotmail.com
---
 include/linux/mm_types.h | 3 ++-
 kernel/fork.c            | 3 +++
 mm/mmap.c                | 3 ++-
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 500e536796ca..247aedb18d5c 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -725,7 +725,8 @@ struct mm_struct {
 	unsigned long cpu_bitmap[];
 };
 
-#define MM_MT_FLAGS	(MT_FLAGS_ALLOC_RANGE | MT_FLAGS_LOCK_EXTERN)
+#define MM_MT_FLAGS	(MT_FLAGS_ALLOC_RANGE | MT_FLAGS_LOCK_EXTERN | \
+			 MT_FLAGS_USE_RCU)
 extern struct mm_struct init_mm;
 
 /* Pointer magic because the dynamic array size confuses some compilers. */
diff --git a/kernel/fork.c b/kernel/fork.c
index a6d243a50be3..ec913b13c5ed 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -617,6 +617,7 @@ static __latent_entropy int dup_mmap(struct mm_struct *mm,
 	if (retval)
 		goto out;
 
+	mt_clear_in_rcu(mas.tree);
 	mas_for_each(&old_mas, mpnt, ULONG_MAX) {
 		struct file *file;
 
@@ -703,6 +704,8 @@ static __latent_entropy int dup_mmap(struct mm_struct *mm,
 	retval = arch_dup_mmap(oldmm, mm);
 loop_out:
 	mas_destroy(&mas);
+	if (!retval)
+		mt_set_in_rcu(mas.tree);
 out:
 	mmap_write_unlock(mm);
 	flush_tlb_mm(oldmm);
diff --git a/mm/mmap.c b/mm/mmap.c
index 177714886849..fe1db604dc49 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2308,7 +2308,7 @@ do_mas_align_munmap(struct ma_state *mas, struct vm_area_struct *vma,
 	int count = 0;
 	int error = -ENOMEM;
 	MA_STATE(mas_detach, &mt_detach, 0, 0);
-	mt_init_flags(&mt_detach, MT_FLAGS_LOCK_EXTERN);
+	mt_init_flags(&mt_detach, mas->tree->ma_flags & MT_FLAGS_LOCK_MASK);
 	mt_set_external_lock(&mt_detach, &mm->mmap_lock);
 
 	if (mas_preallocate(mas, vma, GFP_KERNEL))
@@ -3095,6 +3095,7 @@ void exit_mmap(struct mm_struct *mm)
 	 */
 	set_bit(MMF_OOM_SKIP, &mm->flags);
 	mmap_write_lock(mm);
+	mt_clear_in_rcu(&mm->mm_mt);
 	free_pgtables(&tlb, &mm->mm_mt, vma, FIRST_USER_ADDRESS,
 		      USER_PGTABLES_CEILING);
 	tlb_finish_mmu(&tlb);
-- 
2.39.2

