Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD19B4F4292
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 23:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235459AbiDEMdt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:33:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383720AbiDEM0V (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 08:26:21 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 204CC91345;
        Tue,  5 Apr 2022 04:33:39 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 235Ad4ba012451;
        Tue, 5 Apr 2022 11:33:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=i5na+iiepRR7J2nHb//fiHfdQUlvPFKc3XueqaxAQbM=;
 b=wN/mF89wHABP+oPvvg3PoIeB8rP0VlhTKAE0sx51iXliiFdGZU6OFbXKLCOcd5+ZkKOX
 vbdkcXXEzS2jfR9vxGm2xzvbY5JZLnk43WxOMhzLkEJ5xSkoFCQJap7Tzt3cAFD4BmBC
 S7n4oHZJ0wMYDA8UmO9L/WQCkvdGBpSjzrlN33EBx8N0Z5X4j8Vk0dgw4AgCIR8wCkQ3
 QkBZ9pUoQs5oO7Xbg6QXnvCrGJi8fYGXK2hPenUYuL4OveUaIbJ+Azun5lZI1C+xWvyP
 Qkx37Ovqee+p1y3B87Igz+nxUr+uEUeNSNCuTM0XhU5nGvFLfUqKyFbsG0ARBYzpcJXv dg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6cwcdpkf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Apr 2022 11:33:34 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 235BVnPL026618;
        Tue, 5 Apr 2022 11:33:34 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f6cx3bmgr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Apr 2022 11:33:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xq0x5hZMJ0/5HhnUz2xJ4doELFOi6QOywhFxT3/auxknjajtht/GXg6g4zziAnkMVtvO4qemsubTTtZbPlDkbuDNG1UsazEKGfESzIlP8Wil+cK3QZ1LwW2q+TfM0Wf6zK5PN/6h1snXZtOAkN1AXrG9S4oFXLReIXGRTa+JA+FPEfC/qN1fgR2V7KAYDGyuOMKnDDlDzaHEqWMxqUEL7itrEUE05o8xw7N3cUeB85+siUjHD1gamKRmPud8bMsphfxQhZPDWO9D/qpvr2If1m463LzeFR79d+KhDF7RgKBrPwlx90Fp+6BEw8gNqN5MUJBcxG6rJF8f5qMshTngxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i5na+iiepRR7J2nHb//fiHfdQUlvPFKc3XueqaxAQbM=;
 b=WXf3wEVNk9fHQ0o7pHsIVYcE9vRJx/MC1rZVOy+Ua95yDYeMG8IrjKhSTJM4aPPxixv0B2id6O9t5GGx1/MPjM8xSKiCeUsMXk0CeGOygIkpbXFNuR+pQURavGKL0ahL4cZNegmq3dEHkyGZpGkAEsp+0qNG55lkdk9cU6f9JHAmTxwfb2vFjUWBmnW/U4BEL1dkJ0HwEkfG5EC4K1yyZEG/erE1e2spFF4Uu4vBmUI7MLCL03U8cu3oneRfDSNU9TNcappHIpGIuRziA+fjwM8mSg2DaYmvEs8NJL28a8qyOOeP8VwV6tmbyQRWnHdmzwexzW53MVVasNbUlcI/Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i5na+iiepRR7J2nHb//fiHfdQUlvPFKc3XueqaxAQbM=;
 b=avbZ4XeGcVeqY0BWU5S8cIDssr0dAi6yK9JyKtCEPQpNgVldlbhq0B5v/fDtXJd5NMotRfvnZmzRn5aLpa0O30fcQPCXdBz6/EpctlgsApxhFEZSybG8HfVgaosqUCUJIHPvLfNRr5Tfn8uDaepkwpvT/+kFb7vlCL4bKx8pkdc=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by MN2PR10MB3952.namprd10.prod.outlook.com (2603:10b6:208:1b5::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Tue, 5 Apr
 2022 11:33:31 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::54da:72:aa08:9a8e]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::54da:72:aa08:9a8e%9]) with mapi id 15.20.5123.031; Tue, 5 Apr 2022
 11:33:31 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 1/2 stable-5.15.y] btrfs: fallback to blocking mode when doing async dio over multiple extents
Date:   Tue,  5 Apr 2022 19:33:11 +0800
Message-Id: <44a4ae58ba50bdc32cf78854369208b95ebf336b.1649154880.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1649154880.git.anand.jain@oracle.com>
References: <cover.1649154880.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0011.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::6) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5374b896-025e-40ec-1836-08da16f81c7b
X-MS-TrafficTypeDiagnostic: MN2PR10MB3952:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB3952451962D9B348E85C51D5E5E49@MN2PR10MB3952.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zVMUUYmIXcqslCxt9FXUUhGFHtb0D/y/DDXsL28OwRfDThNOzW+8vmiLDMysb05BLsZXDNbdD/rQ3fQ9rCgPDKZ93tF0fWuOoX99tnRa6XokET04FbMXQzRCgWsvys1qb0RcVncbCoq+2UTHqJvuF4rfn4GcwEghfIX6KIX8tgNmTgXedewYXVznZOSSu2fiW+JSwRKjLyE+B1SlvutQdM30pipjulzz/S5csPWhmEBQn//2djNbXJRiB0QMd4N8gJTry0Mwmcn/lClQ9YZwvXZ3lewsPt8BITdIxs0xNV9mMal4trYHmSy7QMWXbmQbyl0jqpWG8cQuPitJuw9a1T+2vh76u+OqtjAYXLCvytNCSa+ARcOz1/MOtzq+tGW2HKIeZugdKO7l1cKVHHvK+L1X0NHtZ9wUS5v1vy3NuCIeJ6OReQxOMhaU7AhwFGdmHfEOrNFuxe3CdseRQvMwn4Vs5rjO/qD9Xi+KNWEACkcXrGT8SkL86afLsaXOUX2sy9Zdc9V8Zc8awi0MwIfBeNcRVxCHEPjkrfuT8xUbMdUO5/22L2GcoCIGG6cDq+NeL06Folfq5zsYiVesF/tvDjfPZlZadHv8gDXoOjaatSdCVR1IKhZhxHMYoTXWDa2r+9lst44YTUyNl9lnWFb2fn74FSBOYM+VFwEy8VTL+6zGNDvRbMZX5nVLLV/qIl4q2MKRlB0zQac2VsYiBdMURbhZ5yYaAymr3EIwpmqIdYsgqnA7lEmrCpye4RWK8KzMe7sw76Jqeq7tdyExDc7LiQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(54906003)(83380400001)(66476007)(508600001)(4326008)(316002)(6486002)(6506007)(86362001)(66946007)(66556008)(6512007)(6666004)(8676002)(966005)(6916009)(2616005)(107886003)(186003)(44832011)(36756003)(30864003)(26005)(2906002)(8936002)(5660300002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Z9Ctr5kdJL+jf+AWHh3cR+tAKNyh7+k9WQ9NBcqSqkpNKf+4+V5DIXPZwx08?=
 =?us-ascii?Q?M2A1ONhoWYJHdwWzr8WJDgK9lZNbG9FbNkDgAh2rrsfNT+cubqD/ecAcj2qN?=
 =?us-ascii?Q?XQZbGmZbofnQxPC1Sw1i2EwV+i/wN7atD9JbcguU9SkCLhaH5rMImsJEst+u?=
 =?us-ascii?Q?8pkB4tZN0qfzNBpiT0mj0urn2vT9pJUbBHMiQymwYvufoRFKdTglmGEc3ZR1?=
 =?us-ascii?Q?Q1XgoVFNibTJJ6UdviT9G7TYAelRfjnb3tcgSkpCsbtcc9waShS2zVj/n6rc?=
 =?us-ascii?Q?79g5AWd18Jik/dBrk5hGbHWlwmUEh8K9hM6s4otZzVkQr5QYoLccSw+ctrnP?=
 =?us-ascii?Q?8r/vSipdRvLmjU7z7U6sJEHFCQ9QSLoB5QJSbVZAqFQc/k9o97Wz33xJuRQd?=
 =?us-ascii?Q?qUkL/EwFAlgurom3HIbZyxQwfrB+Jj6MuWLgw4xNDQ3AV74yI8dOhFCg4nbE?=
 =?us-ascii?Q?S642ceNyMCAzC4x8y7VIFU4Vf1Rd+OG/vrd2F8PCfpT+utjoC9mTqIGgOl0p?=
 =?us-ascii?Q?r7x/8G+IgtmI38PzAGWLk7OUrHT3y+WaBc7AqyElDQOwwBqn+mzaBfxI9SUP?=
 =?us-ascii?Q?2TAdk602ixXwCqKKKf7i+2eIZ0b85k8RkKBnbzQA6ulgMdJCPxZdQ/nk2M9S?=
 =?us-ascii?Q?609Rp1Bx4e78+KSWaqYp1tIJbcr1V2NsB7UVGac0PyfpmRdr7f7S10hTFpV9?=
 =?us-ascii?Q?H4XVNLrkBEsUTq+IDIVFIgw1dB+6uXtm+YiswmMveae7DpTk6OpVd/Q3izSL?=
 =?us-ascii?Q?9IwYiXU4RHyXWh3vXiEtx5J63OW/N7yiW+o/enD6M7Y9i+swSw7V0opaIpUJ?=
 =?us-ascii?Q?tyAf2Apzxaf6mWu438hHXEZj6oyHQ3jfvW7PS1NSI5RUtCZyRbT0NhuAYG0D?=
 =?us-ascii?Q?nl10im7QKo6+KrPeJ3oqtZjeOtDlwPZVV0y9+CvaykGXh9SkA1bcbWMUUNTB?=
 =?us-ascii?Q?Zdk0pLIeeQ37Ax0AgLj1XMLsoW30VH+I5yBK2BeAKDIcoE190dloTvFJn2pY?=
 =?us-ascii?Q?FDsy9UoRMOjlGIlKG/fVlc5AQGH8y68HmWD9UloD+6j3EtQNr0+VyFTowuUj?=
 =?us-ascii?Q?lwH8CTiQMMHA4BwkYJSpVaG3RBiEsMndFfU0PTdtyK97cUC7LdWTfMHa6gq0?=
 =?us-ascii?Q?5yRNtpsC5QiKewGauXx/Y1j1dDt0F1rTJfd/SqV+0gd1bIWJsDxwkkUxsNVE?=
 =?us-ascii?Q?jk9/Zm82zxHvxE4Xs1YTfWxzqnkgSmZC8e2Air81ZvrLGkDn4wuqe/XqiTrx?=
 =?us-ascii?Q?Noy38pq9hxkMq9Ju22e9v4ncsTUcq9N+8ht5ebgvXlzgL9Vez8InxH5nxE3U?=
 =?us-ascii?Q?ujXqI0t2a4TEtxIqrXne8tGtntJqp4M7dynlsDBORnukbNUxxjJB/6ZlvmND?=
 =?us-ascii?Q?X8k8G7h/YhHHr8ky4KN85RNzVj0nmTPiROEL8VL5S5XOoWdrzDpH2bgH0oBR?=
 =?us-ascii?Q?H8uZBm29sXm9QfPpwswwZeYza9/hGMofxdzVUyFbyr2BjlEtW1hRGynfPAaD?=
 =?us-ascii?Q?HlpNBGVBRkB0Bh0SXUzu889oJcI1619iqXxM3dYsk332cxmzquTlhg4FLcid?=
 =?us-ascii?Q?B7fU1h9Y6l760syXj/VpKjPPqVSkRzLwNOvifmtiPtbhXvKqPM2OyUm8rZvi?=
 =?us-ascii?Q?1atJyEQ+CP0Y4S1nY+Wg1O4BSeU1BV/2hSZjlXVtkFBJ/0/J+CuJ0kZJnOQP?=
 =?us-ascii?Q?QIuNRrzafQqIpTKzpouzMGuBI5tKM81fqGTuByePz/iRwRRhfJzoD2lbgrS+?=
 =?us-ascii?Q?51vr0c96bw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5374b896-025e-40ec-1836-08da16f81c7b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2022 11:33:31.4376
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pwL1Drb2x+vHhoB+BOUpSDhLQN4zBQE5tSnuOZzZ4zJvSkoK5q8B2icSjTcu2aFK8jkCBja373CG43oklBRCVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3952
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-05_02:2022-04-04,2022-04-05 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 mlxscore=0
 bulkscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204050068
X-Proofpoint-ORIG-GUID: ROixx69giXOTaPz2eDWRgC0ZcNyb3nVP
X-Proofpoint-GUID: ROixx69giXOTaPz2eDWRgC0ZcNyb3nVP
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

