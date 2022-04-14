Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B10E6501E6C
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 00:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347164AbiDNWdg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 18:33:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240406AbiDNWdf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 18:33:35 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2215CC55AA;
        Thu, 14 Apr 2022 15:31:09 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23EKFdKT031973;
        Thu, 14 Apr 2022 22:31:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=i5na+iiepRR7J2nHb//fiHfdQUlvPFKc3XueqaxAQbM=;
 b=tcCkxkwdFIOdVBcpJ4A5d264fWgX2imgwQw3wQcNYDwMZZ5tlOIbHZ41nwCntKHt5hD1
 PWVJRwUynFI3tDuSh9x3BNZPdCexOmToWdya65CqHmFG3nYx8aDwnL4zxQve88IsADTf
 UHwmDee0LsZtw6eOLA1QSpMxT6eASoJ0c8H/z44W6C2GVGMGPvROg8zyE2AODRb889Je
 bx23sbDIT+Y24yQY3t/Hx5J9jkI7zbufFgADOk9x8lHGhXM7MZwbwWqcyWVFsPQ6ey0t
 oHRlnV02rD4Ng0WOyBdeNNl/gBaKhomi6+uMdrYy6OZ330Lw1LuOsgSclyzrabf3ES6T IA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb0jddp3s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Apr 2022 22:31:05 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23EMGOBr008408;
        Thu, 14 Apr 2022 22:31:04 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2046.outbound.protection.outlook.com [104.47.56.46])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fcg9m6m0h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Apr 2022 22:31:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I1BAwHzfshobXVpDeLSbFew6Kl4FYVFpmaPTqJT9/GX5/bOJr80EPCyYDPdydkmxy/l+6DShFnemUZSIkVkoXt3utO7/YwQYuKmc4H/QVXmzCMB3pMBZwq2prd3rmxNiSO3v7k2FfbjrZMxQ3rcpIw5KcVG6sovBMNvH8A5xU4ru+xAThDsjkS0S3UOV4C8K1WjvrjLNkj1rPbcg1KpCq/bNsesqkIVnx4pSFexeNc784p37iVP+MaIU5bunyEuUzcZ+Nx/do4zsmWTno3tRkTXERl1f3K1B8MakFJ5o0LH02LkRYMZT1moLQsZr2iL4bfDXoBfX0aAYyMMlQqnCnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i5na+iiepRR7J2nHb//fiHfdQUlvPFKc3XueqaxAQbM=;
 b=TXV/hS1v86042XdOG4xulsxIxNnnVWvb0DPnhAZEwT4WY6XjHnGshl5VeEzzxMNasPSwsQACJhqRPU66U4kS4Rt3w/T4MT0MlM/6BLNNKYMY9iSanzTruGd/j/5onqqP/QJj7XgwA+c8REVE2NJaza6ly8yhrJBfsQ3UyNGTcRkMMXjIlPx725NmiC8J5ucMRBXzU1MkGrmzf8hBJaBuR7jkFJ8/MnHcPCtFnec0C/thFY9a5FZxpNWkgXuo1F7v/XXGWKFJdbyF30jsRRaG5qRNFT5t/sJmp1q7PN01ehZifjTDRz/wtkf//gcKyqHBl9tAIPVXZVeP9ffz1bLxSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i5na+iiepRR7J2nHb//fiHfdQUlvPFKc3XueqaxAQbM=;
 b=E6Qe+8+TnTyhcPOzA+rtSvI81FbnGHWKYjjMhVxsJqjmgUS/PxyS30SUyxPiaM4YCeAhoMUArVttCuRh7gHdf+qgJF9XjFHIPuNay7ttPgHzraaVwhIWRS9RLmMfYfGXTixZ7SuU1sd28f7bv/njhB0Jy2ua5L508eTyrrYfMnM=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by CO6PR10MB5572.namprd10.prod.outlook.com (2603:10b6:303:147::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Thu, 14 Apr
 2022 22:31:01 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306%7]) with mapi id 15.20.5144.029; Thu, 14 Apr 2022
 22:31:01 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH v3 17/18 stable-5.15.y] btrfs: fallback to blocking mode when doing async dio over multiple extents
Date:   Fri, 15 Apr 2022 06:28:55 +0800
Message-Id: <9127cbbcd2bf2f8efd46298d8799e36282e1a311.1649951733.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1649951733.git.anand.jain@oracle.com>
References: <cover.1649951733.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYBP286CA0016.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:404:ce::28) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9621f74f-cce8-4835-6d74-08da1e667445
X-MS-TrafficTypeDiagnostic: CO6PR10MB5572:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB5572C99004D9756AAE8095B0E5EF9@CO6PR10MB5572.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ckCWRK//sp2FQRmy78Xc3TtDwjXPgUVJGQ61v0rl03Pv+r3psX2rwE8THJoWOXSovd7qbyOxI9X0qsU0j8ssM3b2lT+z6HgitJ3Rwp3FNCscnl8Sd/J7ZZjsVkdrurgBHtJonKLqEACOy23Q1KVUr7mewRTnXYl8ASbXE1CtFJX2sbj9mpwnbzPuEMKOPsc0C24KIisSDLE26MUaCXYnlNAsP9rVdlw287tnhz4+Y2R2TCTCjYjfHB6A2vT6aJ3+5RYNb99trjydvD8A1beTQyz+5AVzJ0AlOyVxCf3POEEZSWrvtxHBWjnlAzESEAdYXBNSGvlvYGNQHZGbgWRPxBlw3NitBW0q3ArHQQfq9qyxW7WB+ejx2Exe9C3pSSl4P36wlfRSIb2GMgsfYnUO5kgx5C0yrgFq0g/Kn5PC15/jJRS/6ly9fqpWQbpWIAnD+jh+boJuYHY9ifd58iKKyBqzqqwDkAkcaTRN5SHwdVTrxrXknYSnjFuvjNkOTsKQ+zoMAQVeeij7kM6QZ2LDjX53vjrqT+UMn7xY48S42+GmiXaSkiu6NVOOeM1JahNSpKhN1li3H/BqsoojmF9YGuFs/G9JpFUvbQYEItpl8J8TsNxQ84MnG7fzDauY4YmVgxy7t3uMu3E77TS0twt/BcNOZGVzPKl046Ae0J3HLd7xnCxYngXEsjDL9T2yFr94u8Zu92jzzkz5hRPg+rO4uLN+1X0UOi21MeU0oNCmEAza68oz6vZiF3LPLeinVj6B7wVZuxfdOR+IY3yA2m5tzw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6666004)(38100700002)(86362001)(6512007)(6506007)(2906002)(4326008)(36756003)(66556008)(66476007)(66946007)(508600001)(8676002)(6486002)(966005)(44832011)(83380400001)(107886003)(8936002)(6916009)(5660300002)(316002)(2616005)(54906003)(30864003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HuW+sQWOCDCXZANwx9utjrtNHQEjNhQd+aCfZDnAANNjWzreWKyGSlp26+3u?=
 =?us-ascii?Q?NClCNUT4DFFil+2cy0rbL0M80X26Gb+AQWiPF2rOOllEufz8Rr8n3WvOFb7k?=
 =?us-ascii?Q?oZ9qF197oMJ1a4ZMX02DVOoipK0+ezomd0khBdhXYu9Xmg9CfXvZSOKdZfG1?=
 =?us-ascii?Q?rPtX4qSmJmtjmV/J6bHt76nDNh4KPvYqcqFMVZK02D2PaHY0iqZPUApUvYlk?=
 =?us-ascii?Q?UWr5WtPV1hbVeM30I1GaR/NSAU9sGTcGm5VPe3HmIxNpr59fOTLx9iYHGc+x?=
 =?us-ascii?Q?IwLNKn/SLSWR/jag8DW6zC/MLgpcvdzgcRUwrYeL1wGoeJ4qCD99JqwDC0wM?=
 =?us-ascii?Q?JjDzy1Fe33hY1+w1qEjq984IA6qwlIuko0C0HkdB+pGk65cs7VUPN2r/B9sR?=
 =?us-ascii?Q?ZSPgF6/bq/cyTvoF5ytIwHTizoV2To3wmwHb6XzqrVGTpdW9aZHGo9EXVtQ7?=
 =?us-ascii?Q?zkbvzp63zexKiu6bJ/gCQDEmct+96nX9iqy+4xLPlM491uxUkcRWU4lz9WZF?=
 =?us-ascii?Q?gJe8ulOR2siQUa2jy8b/XvXHeztOPEi+ZAGZHcN5SOoitTTNKC4xqouO2NUr?=
 =?us-ascii?Q?xWSiCPdGJgVKCDkgLnwFhkUp9nAGjF4IBFvBgbFyBz1jD2m6Ecobb4PCfWpq?=
 =?us-ascii?Q?uys16EQkFn8LvNAELa2Best+C+zRL8hdIpkw7taVobVVhEerI4atniHtx+9I?=
 =?us-ascii?Q?Js2+6ln3UUfW7RbvjE6CQ+w1rQozOGG6WSQZVZ40GgtCUczMEI6aicaINuEb?=
 =?us-ascii?Q?7PW0GxZQFWC3HS399MY/ZFD5wBUgxr6XSLmlWG+0MQj4ylWphCJeclPWFlqI?=
 =?us-ascii?Q?aw7iG05AvajD9x28TWOxNLEaECBC7XUX5Uy4ZMfvg3ZCX8Z+DvmBpfeVyjtj?=
 =?us-ascii?Q?joVmGPyIo9seTvPu/gpaxaoXmKWMqz1qvjk0O+b6ngCb6RUpAhBvP2FwpdDw?=
 =?us-ascii?Q?wiHyDRd1BxIu7U03W8m27FenxE4CQJdYyjbrsSnkQplw2v7oB/ESm5ZkIMKk?=
 =?us-ascii?Q?ITDuTKR+rf0gOWFnJVeZzvkmharg00ZkuZla9xKbz3xuwM6CDCUNq1IjaVZt?=
 =?us-ascii?Q?QUz3q2c971xoFsa7tfmelzLHuA8i1c3QxGUKJXs25TMd0pfPGaXyS9slud8d?=
 =?us-ascii?Q?Xb4acIBopnoJUSIuqwyA1O0S25OKnCzY91/RNK0rMQQHg6XBqSlyvSWS0V1W?=
 =?us-ascii?Q?j4gOcGbVvdprFVGB20LfpPqJ0qQyl+c7pvZKTKOLtge+YdacAMZnrPd7GAH5?=
 =?us-ascii?Q?3UCV0+AD/cOnd2nLj4KZGdzM9IvFrXvcByxfnYcxK+DQiMPG6vN2T2YqOhsu?=
 =?us-ascii?Q?d6BG0/DybYodiCugovjKfp9/C1FrvLFFVss554/aXGvgj7ztPhOlAxt8WJAc?=
 =?us-ascii?Q?LdI1+VSIsHQe6UbQrKsY5wwe1Gzuaf13Ho50iUOht33hHD9RltZ2WlxfZdKo?=
 =?us-ascii?Q?sceg+VHm602ODG3mi+8lqZV8EwjMNuC1GL0bdD+AYEM263thDq3y5Der2/46?=
 =?us-ascii?Q?G9zWuEPrqmXml9Ft1tdwDzTfcT7xo4mHSgXy1jRMk6TKFYWHnmxJICWYpwcj?=
 =?us-ascii?Q?MTDd7872rJgm5zcQkcw2HzNAh4Ke0aeeTHV4Jn2sRkUhjp2MwaLcAIPOnv48?=
 =?us-ascii?Q?x6lau9kuXpM0SxxkIEwpls1XSvQ53a9WEPXg6mfUuWqj+cP3ePV1EnGvlvUT?=
 =?us-ascii?Q?3+AKTq8037IHMpUykn79OUCkbIBkfjcx1yqfmOv9vPmFgOJQLYgK/pUOYrK7?=
 =?us-ascii?Q?/BvRLf/keDUOCAMGrQ+EUYQqJ3OMR15GoSDM6brCsuEKVr0fsv4B?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9621f74f-cce8-4835-6d74-08da1e667445
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 22:31:01.3957
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4bE0Gq89KbMrnxErUJdOZ5WEvtolqhps2+3mU0UMsOPH8LZbmh6xAUWEt17bubFssDb64S6PNen2NmnUaEhECw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5572
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-14_07:2022-04-14,2022-04-14 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 spamscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204140116
X-Proofpoint-ORIG-GUID: _kB-nOiXFBzAYPXOkNW-TarH2vzJzK_5
X-Proofpoint-GUID: _kB-nOiXFBzAYPXOkNW-TarH2vzJzK_5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit ca93e44bfb5fd7996b76f0f544999171f647f93b upstream

Some users recently reported that MariaDB was getting a read corruption
when using io_uring on top of btrfs. This started to happen in 5.16,
after commit 51bd9563b6783d ("btrfs: fix deadlock due to page faults
during direct IO reads and writes"). That changed btrfs to use the new
iomap flag IOMAP_DIO_PARTIAL and to disable page faults before calling
iomap_dio_rw(). This was necessary to fix deadlocks when the iovector
corresponds to a memory mapped file region. That type of scenario is
exercised by test case generic/647 from fstests.

For this MariaDB scenario, we attempt to read 16K from file offset X
using IOCB_NOWAIT and io_uring. In that range we have 4 extents, each
with a size of 4K, and what happens is the following:

1) btrfs_direct_read() disables page faults and calls iomap_dio_rw();

2) iomap creates a struct iomap_dio object, its reference count is
   initialized to 1 and its ->size field is initialized to 0;

3) iomap calls btrfs_dio_iomap_begin() with file offset X, which finds
   the first 4K extent, and setups an iomap for this extent consisting
   of a single page;

4) At iomap_dio_bio_iter(), we are able to access the first page of the
   buffer (struct iov_iter) with bio_iov_iter_get_pages() without
   triggering a page fault;

5) iomap submits a bio for this 4K extent
   (iomap_dio_submit_bio() -> btrfs_submit_direct()) and increments
   the refcount on the struct iomap_dio object to 2; The ->size field
   of the struct iomap_dio object is incremented to 4K;

6) iomap calls btrfs_iomap_begin() again, this time with a file
   offset of X + 4K. There we setup an iomap for the next extent
   that also has a size of 4K;

7) Then at iomap_dio_bio_iter() we call bio_iov_iter_get_pages(),
   which tries to access the next page (2nd page) of the buffer.
   This triggers a page fault and returns -EFAULT;

8) At __iomap_dio_rw() we see the -EFAULT, but we reset the error
   to 0 because we passed the flag IOMAP_DIO_PARTIAL to iomap and
   the struct iomap_dio object has a ->size value of 4K (we submitted
   a bio for an extent already). The 'wait_for_completion' variable
   is not set to true, because our iocb has IOCB_NOWAIT set;

9) At the bottom of __iomap_dio_rw(), we decrement the reference count
   of the struct iomap_dio object from 2 to 1. Because we were not
   the only ones holding a reference on it and 'wait_for_completion' is
   set to false, -EIOCBQUEUED is returned to btrfs_direct_read(), which
   just returns it up the callchain, up to io_uring;

10) The bio submitted for the first extent (step 5) completes and its
    bio endio function, iomap_dio_bio_end_io(), decrements the last
    reference on the struct iomap_dio object, resulting in calling
    iomap_dio_complete_work() -> iomap_dio_complete().

11) At iomap_dio_complete() we adjust the iocb->ki_pos from X to X + 4K
    and return 4K (the amount of io done) to iomap_dio_complete_work();

12) iomap_dio_complete_work() calls the iocb completion callback,
    iocb->ki_complete() with a second argument value of 4K (total io
    done) and the iocb with the adjust ki_pos of X + 4K. This results
    in completing the read request for io_uring, leaving it with a
    result of 4K bytes read, and only the first page of the buffer
    filled in, while the remaining 3 pages, corresponding to the other
    3 extents, were not filled;

13) For the application, the result is unexpected because if we ask
    to read N bytes, it expects to get N bytes read as long as those
    N bytes don't cross the EOF (i_size).

MariaDB reports this as an error, as it's not expecting a short read,
since it knows it's asking for read operations fully within the i_size
boundary. This is typical in many applications, but it may also be
questionable if they should react to such short reads by issuing more
read calls to get the remaining data. Nevertheless, the short read
happened due to a change in btrfs regarding how it deals with page
faults while in the middle of a read operation, and there's no reason
why btrfs can't have the previous behaviour of returning the whole data
that was requested by the application.

The problem can also be triggered with the following simple program:

  /* Get O_DIRECT */
  #ifndef _GNU_SOURCE
  #define _GNU_SOURCE
  #endif

  #include <stdio.h>
  #include <stdlib.h>
  #include <unistd.h>
  #include <fcntl.h>
  #include <errno.h>
  #include <string.h>
  #include <liburing.h>

  int main(int argc, char *argv[])
  {
      char *foo_path;
      struct io_uring ring;
      struct io_uring_sqe *sqe;
      struct io_uring_cqe *cqe;
      struct iovec iovec;
      int fd;
      long pagesize;
      void *write_buf;
      void *read_buf;
      ssize_t ret;
      int i;

      if (argc != 2) {
          fprintf(stderr, "Use: %s <directory>\n", argv[0]);
          return 1;
      }

      foo_path = malloc(strlen(argv[1]) + 5);
      if (!foo_path) {
          fprintf(stderr, "Failed to allocate memory for file path\n");
          return 1;
      }
      strcpy(foo_path, argv[1]);
      strcat(foo_path, "/foo");

      /*
       * Create file foo with 2 extents, each with a size matching
       * the page size. Then allocate a buffer to read both extents
       * with io_uring, using O_DIRECT and IOCB_NOWAIT. Before doing
       * the read with io_uring, access the first page of the buffer
       * to fault it in, so that during the read we only trigger a
       * page fault when accessing the second page of the buffer.
       */
       fd = open(foo_path, O_CREAT | O_TRUNC | O_WRONLY |
                O_DIRECT, 0666);
       if (fd == -1) {
           fprintf(stderr,
                   "Failed to create file 'foo': %s (errno %d)",
                   strerror(errno), errno);
           return 1;
       }

       pagesize = sysconf(_SC_PAGE_SIZE);
       ret = posix_memalign(&write_buf, pagesize, 2 * pagesize);
       if (ret) {
           fprintf(stderr, "Failed to allocate write buffer\n");
           return 1;
       }

       memset(write_buf, 0xab, pagesize);
       memset(write_buf + pagesize, 0xcd, pagesize);

       /* Create 2 extents, each with a size matching page size. */
       for (i = 0; i < 2; i++) {
           ret = pwrite(fd, write_buf + i * pagesize, pagesize,
                        i * pagesize);
           if (ret != pagesize) {
               fprintf(stderr,
                     "Failed to write to file, ret = %ld errno %d (%s)\n",
                      ret, errno, strerror(errno));
               return 1;
           }
           ret = fsync(fd);
           if (ret != 0) {
               fprintf(stderr, "Failed to fsync file\n");
               return 1;
           }
       }

       close(fd);
       fd = open(foo_path, O_RDONLY | O_DIRECT);
       if (fd == -1) {
           fprintf(stderr,
                   "Failed to open file 'foo': %s (errno %d)",
                   strerror(errno), errno);
           return 1;
       }

       ret = posix_memalign(&read_buf, pagesize, 2 * pagesize);
       if (ret) {
           fprintf(stderr, "Failed to allocate read buffer\n");
           return 1;
       }

       /*
        * Fault in only the first page of the read buffer.
        * We want to trigger a page fault for the 2nd page of the
        * read buffer during the read operation with io_uring
        * (O_DIRECT and IOCB_NOWAIT).
        */
       memset(read_buf, 0, 1);

       ret = io_uring_queue_init(1, &ring, 0);
       if (ret != 0) {
           fprintf(stderr, "Failed to create io_uring queue\n");
           return 1;
       }

       sqe = io_uring_get_sqe(&ring);
       if (!sqe) {
           fprintf(stderr, "Failed to get io_uring sqe\n");
           return 1;
       }

       iovec.iov_base = read_buf;
       iovec.iov_len = 2 * pagesize;
       io_uring_prep_readv(sqe, fd, &iovec, 1, 0);

       ret = io_uring_submit_and_wait(&ring, 1);
       if (ret != 1) {
           fprintf(stderr,
                   "Failed at io_uring_submit_and_wait()\n");
           return 1;
       }

       ret = io_uring_wait_cqe(&ring, &cqe);
       if (ret < 0) {
           fprintf(stderr, "Failed at io_uring_wait_cqe()\n");
           return 1;
       }

       printf("io_uring read result for file foo:\n\n");
       printf("  cqe->res == %d (expected %d)\n", cqe->res, 2 * pagesize);
       printf("  memcmp(read_buf, write_buf) == %d (expected 0)\n",
              memcmp(read_buf, write_buf, 2 * pagesize));

       io_uring_cqe_seen(&ring, cqe);
       io_uring_queue_exit(&ring);

       return 0;
  }

When running it on an unpatched kernel:

  $ gcc io_uring_test.c -luring
  $ mkfs.btrfs -f /dev/sda
  $ mount /dev/sda /mnt/sda
  $ ./a.out /mnt/sda
  io_uring read result for file foo:

    cqe->res == 4096 (expected 8192)
    memcmp(read_buf, write_buf) == -205 (expected 0)

After this patch, the read always returns 8192 bytes, with the buffer
filled with the correct data. Although that reproducer always triggers
the bug in my test vms, it's possible that it will not be so reliable
on other environments, as that can happen if the bio for the first
extent completes and decrements the reference on the struct iomap_dio
object before we do the atomic_dec_and_test() on the reference at
__iomap_dio_rw().

Fix this in btrfs by having btrfs_dio_iomap_begin() return -EAGAIN
whenever we try to satisfy a non blocking IO request (IOMAP_NOWAIT flag
set) over a range that spans multiple extents (or a mix of extents and
holes). This avoids returning success to the caller when we only did
partial IO, which is not optimal for writes and for reads it's actually
incorrect, as the caller doesn't expect to get less bytes read than it has
requested (unless EOF is crossed), as previously mentioned. This is also
the type of behaviour that xfs follows (xfs_direct_write_iomap_begin()),
even though it doesn't use IOMAP_DIO_PARTIAL.

A test case for fstests will follow soon.

Link: https://lore.kernel.org/linux-btrfs/CABVffEM0eEWho+206m470rtM0d9J8ue85TtR-A_oVTuGLWFicA@mail.gmail.com/
Link: https://lore.kernel.org/linux-btrfs/CAHF2GV6U32gmqSjLe=XKgfcZAmLCiH26cJ2OnHGp5x=VAH4OHQ@mail.gmail.com/
CC: stable@vger.kernel.org # 5.16+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/inode.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 58053b5f0ce1..af1819bdb609 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7955,6 +7955,34 @@ static int btrfs_dio_iomap_begin(struct inode *inode, loff_t start,
 	}
 
 	len = min(len, em->len - (start - em->start));
+
+	/*
+	 * If we have a NOWAIT request and the range contains multiple extents
+	 * (or a mix of extents and holes), then we return -EAGAIN to make the
+	 * caller fallback to a context where it can do a blocking (without
+	 * NOWAIT) request. This way we avoid doing partial IO and returning
+	 * success to the caller, which is not optimal for writes and for reads
+	 * it can result in unexpected behaviour for an application.
+	 *
+	 * When doing a read, because we use IOMAP_DIO_PARTIAL when calling
+	 * iomap_dio_rw(), we can end up returning less data then what the caller
+	 * asked for, resulting in an unexpected, and incorrect, short read.
+	 * That is, the caller asked to read N bytes and we return less than that,
+	 * which is wrong unless we are crossing EOF. This happens if we get a
+	 * page fault error when trying to fault in pages for the buffer that is
+	 * associated to the struct iov_iter passed to iomap_dio_rw(), and we
+	 * have previously submitted bios for other extents in the range, in
+	 * which case iomap_dio_rw() may return us EIOCBQUEUED if not all of
+	 * those bios have completed by the time we get the page fault error,
+	 * which we return back to our caller - we should only return EIOCBQUEUED
+	 * after we have submitted bios for all the extents in the range.
+	 */
+	if ((flags & IOMAP_NOWAIT) && len < length) {
+		free_extent_map(em);
+		ret = -EAGAIN;
+		goto unlock_err;
+	}
+
 	if (write) {
 		ret = btrfs_get_blocks_direct_write(&em, inode, dio_data,
 						    start, len);
-- 
2.33.1

