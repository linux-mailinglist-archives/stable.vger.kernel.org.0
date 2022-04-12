Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66E864FCED7
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 07:18:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235842AbiDLFUF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 01:20:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347876AbiDLFUC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 01:20:02 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35DBE34659;
        Mon, 11 Apr 2022 22:17:45 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23BMg76S001710;
        Tue, 12 Apr 2022 05:17:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=i5na+iiepRR7J2nHb//fiHfdQUlvPFKc3XueqaxAQbM=;
 b=cu0jsRmG66ug4G+cY6hcKI8aqFgtMRZLg4Rf1dqkqZbQ/6PJlBhBAQOrtzgaeC0Dr0rh
 qmoXGKZ5Ztx49I1qA6uLVlv+odlc/bhpGSgwl1EFQCmiEw5xFjoWIRJuysm941yhPYF1
 16GU9RL86O7GgeTtSyPUbWXbUBcL52PNy0OTNvLewapnA8qCBiCB+x3V1jyflxNz195E
 1YzlKdxDriEeCLBbBoWn3452LxwzJnY7An62CyA/nyvB40fRomVuF6cGl/auiXw8aBha
 kVdt4ITCp6vHpKSxEUbcumbSJ1zbh0/MRl4UOUNQ5R1rPxxoKSRZ2eaBuBauOIA8OnO5 vg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb0x2dmcv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 05:17:41 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23C5GKZW034397;
        Tue, 12 Apr 2022 05:17:33 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fcg9h025q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 05:17:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QwF1Qh+y3r0dgCtj+M3oRzMt12Nn2TbGF267EYmFu+F72nv9Xlc+DkUI0qVJ7/uSlESkNapE/AyIABXGII3wQfz9q/MP8QCN4VZj0Zzp0/B1G0E66L0Y6+471lMxZdQeenvaQ4+xRQAga4u/0Ar16v+YWyv4kSA+2z38TG+eZ+wcyysPhbsh+pE+U0vynNVeYnTE3yVsVQigVbgC6q1k+eDFj8W4CbGXDqrSlTi1YpVU5L4QSIKMY4viqUWpUo4TysKylULFTtvg2lko7GMCpTpdPoQZp370v7fNCwdfA0uJU8aKcVEhOMgtcdYAQz+IwbqJ0sf2oybnKIgiN3gKsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i5na+iiepRR7J2nHb//fiHfdQUlvPFKc3XueqaxAQbM=;
 b=XkaalKRH508YnAcX9uWrCLRdb1IsmJ0Y4Bf4snY5mwNrpL2811yiEiNewiFghOrBuKxTpwzgxrlX+oI2nKxypgQHqNbxkyGdcGaViQUAGIaoiAsxwLBi364R+wOSpPUF0AW3q/bROA7GNqvEIGOWIK9UTWlgHZnnTIFXsHengIdSCAXlNhoUh2hAuPxkTYYjzWfCynfZ3n7K8u/QGKgtxoZa2cXcm1GhgNs4K4pMtxodegw4wpfGzpH+e+YvJSpYV90U9B/OirSlb5D6KU/ipZsVvlNNZDwqgXZsepRQ3x+om5weVIIFDfGkR8Wf3NpfSD8FS8oS+1e6ygk96LGjLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i5na+iiepRR7J2nHb//fiHfdQUlvPFKc3XueqaxAQbM=;
 b=qJtVEar/sHcS+Rm8b8TPxVZdBcmwbfa59lsux8a/b/uCYCddwRV9275HCSEPlYguXJ0oeYohI7oLYMRUmO4qI2IFu7wPjrz5BaZQ0k24HmC9Qw0qgXMJG8AWNR4u3YPpXNL2bmOF0m2yZchejNTJswL6k8aPtLw13Ow1N6EZCDQ=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by BYAPR10MB3256.namprd10.prod.outlook.com (2603:10b6:a03:152::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 05:17:31 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306%7]) with mapi id 15.20.5144.029; Tue, 12 Apr 2022
 05:17:31 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH v2 17/18 stable-5.15.y] btrfs: fallback to blocking mode when doing async dio over multiple extents
Date:   Tue, 12 Apr 2022 13:15:14 +0800
Message-Id: <b779adc10b39fe504415954087ff0bb0ed877af4.1649733186.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1649733186.git.anand.jain@oracle.com>
References: <cover.1649733186.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR0101CA0036.apcprd01.prod.exchangelabs.com
 (2603:1096:404:8000::22) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: df325ca0-3f24-4d4c-0fee-08da1c43be87
X-MS-TrafficTypeDiagnostic: BYAPR10MB3256:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB3256BDC7207D85A3FC450B73E5ED9@BYAPR10MB3256.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LWcBE2ZaGFaIkEznbDtsfYuaxUmyeGc+6FdRxg2w66mUtN7usd7vHMP5PBno3nsKqr0b2mVzbTG2qpKpjjzWDheuqCYhd53FERSSTCX3HZc6p55pwU/NWZkdko6UqdMZ5LeVipa7cSf12sfJ1CWlQLe29TEKlXmWrePMk0RV2B96eiYPqbjl63/KHwz77U+LZ4iBTBM2J2j1S+u360DoVaFG2wCelO0ZONv0qQ0w0XeFtYqB0biFQZ4lASfM1QXL6rf4kBH6rTUemfwD2GbsdzbWtULD1vwGc8Z1L2rlz3/es/NXLSn/Ys/W5vgJpdyUn2py2gnBlGmlvHx5Ii1RjaPTemWh/jm6WGzmPBl26SAYFPWLoIcUEiQUndKKJjZNiKWZhvxAaivD7r1vEOcaadlTKO3DUxFlTYArBwBqn70jl3OqJFKAVvEAegIU3VI2JBor21c3FibyyBIeeoi2OJLyVBmHLZ7h7GdElorAsPMoi0peF5BlQ+S8XtudUjT/wRDKy4nVrUIm3nCQPTlV6xl48WCZvU+E11piMU02EE9LbVrykgrkCKKEPW01D2QCD0HlnnFZmmiutnZewnfwUOwHyQvmcKeIra7rpDmrLrxnCEM4D0EefwY2rGden00Sj00JlWPJSZHMQ5XP4t4A1BbPOHe8avOZTyweFeUtvEDqzn37l+JpeEOfaaty968iD6AHc7joc/v96i8vbfxvxKIDPN6sQLzKToFlQHdDSuwcPVkS8fRAC5lQqElAHXpW9jE3KU6disreYPqujJf3Ow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(8936002)(5660300002)(30864003)(2906002)(83380400001)(6512007)(2616005)(66476007)(44832011)(107886003)(186003)(6506007)(6666004)(966005)(508600001)(66556008)(66946007)(6486002)(86362001)(54906003)(36756003)(8676002)(4326008)(6916009)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BPf0y92sDZFJMZJTyLSqCyqG1HwI1rMueqah0MpbkaSPVbwlj7cLPg3aDq1M?=
 =?us-ascii?Q?seoMG348QrQGpPRslg+UQCwGWGS1qG5fd4f0yH2zkxsLfdbx9yH6vNJoae9d?=
 =?us-ascii?Q?WB2T32eBCJfdm2h7OM29H6oKLukVFJ6jwBQQ3jjxlp4pn10L8z3u1Ytkn+ij?=
 =?us-ascii?Q?gUh9BfyPE8RjxwUHRuhkTfRgNf47uDRTBPP1xcp9PoAkzamI7+LAWyZzd4re?=
 =?us-ascii?Q?ZjwTE8UPEbMhXGJtja3CAkKAXi+1SKePmlurfSDRnDUFH7lwODOeKT+EsB6Q?=
 =?us-ascii?Q?3pbLKJgMH3H9qlvRDiOf7jPf3tEEJifdqPEz12E1VH1SRHO+4zBLTe4UrFd+?=
 =?us-ascii?Q?TP7gAEHHxlTpB1gfowjLfQa7/d6WeGP8pOgIn8g+uljRtTkUFtONa7NUWdyc?=
 =?us-ascii?Q?NFEtRmEAasyhIUup/wrO380JfWNSo72iIFq29YRO34vZj2uuRF5JwUWLzkpF?=
 =?us-ascii?Q?SecELDDv6zvF+xPhrtHvWGc3cTf42/Xghpef8fAalCTDp90oZaSlvJYQST8N?=
 =?us-ascii?Q?6fj1mku4x+AF375i7Zt4/d1/d/7hQZJlCeTJOg/eHsXQ39k82M2GWpaR85on?=
 =?us-ascii?Q?wHm5d5ek5vXccZtOmuWXKQMzJthoMEeMmgIWV5kuBcSFoDTcdpp7zV1xpU/j?=
 =?us-ascii?Q?UD7vinwdRI6sNxpwpITI1qIgfkOCC/dh1Nni30CemxUwZpkdUezSMg0oVf9f?=
 =?us-ascii?Q?mEnZ4IS71JEEpff5CaspN7FOzfxLu+DRQLYgWBTr/dtQNTK/735bMRyoOyCW?=
 =?us-ascii?Q?vjf0NAeJtTCUe1ArutaD9+tzvjxczEaTFezCxmjAxqowieSpmI7KoqFwi6uo?=
 =?us-ascii?Q?6ny33SS9bN9IaLCvEnoKxn8+mhZ5MwBx4dNGzqM/f6Y8sQOT16hVN1Nk5p7K?=
 =?us-ascii?Q?Sm9zcuMQ2DP3otni7lJywxRnVaLI6rco3AWo8OcW/DN7QPdw+TLr/UQ3MBk+?=
 =?us-ascii?Q?dCAP1Xe96Wtr2HL3Ai2zw0oCcQs7QUH5tPTBZa0ezMV+kfOvPK+9DbsjM7UQ?=
 =?us-ascii?Q?hTybVKOtTxv73PhZx+dZjIGotLiQo+atUr7iD0vA24Rn3l0hvLFDQUCBTzkq?=
 =?us-ascii?Q?hQL0QwjduBDulLFc0IaZVImhgeaxP/bMD2S0VBM+1vEDa+OsoI1tqLEcg2f9?=
 =?us-ascii?Q?e18J4l/UUiRp3KGQs2CDnFm0kismL9j/wS4fsXBEd0T0jLcDcyOYI1BUOwM+?=
 =?us-ascii?Q?PBqP1eyx7szjKPjS2WuJGjqIyGZn/v+BzLlspV+EKz6JzO+vXtx0BEA1cVo4?=
 =?us-ascii?Q?JeizgL416Q6rXYfmmVEUhccPwq1ZcYpSkSrpg1kxH9xXW85g8tU87BPt8+MZ?=
 =?us-ascii?Q?GClsosgxL5PdL7GvasKcqlvLIwKfXBFoiV0LUswlnKVIkeGPzVVUoRv3BdsX?=
 =?us-ascii?Q?Ns4lIx2zRsTvELCAtmss4xAFfxrOua2WUOVv63w5cdfd1dm1J3//FLwOIq2w?=
 =?us-ascii?Q?AU6GC8iL4pTY92PgHjznHIdtF4rm9FK3lbMB9ZEtjR6GFyLpBZBNCmbotVZ8?=
 =?us-ascii?Q?CC7hp55oY/sHGP1wHpGoiQKq4cZBRHQH/mVxaqDLPdjgklAnXNDtBuGPIfGK?=
 =?us-ascii?Q?V9/i4pwgX7RqNCstN1kVckljdkNkCBaMxapiDjKc9+2SjV8QNEGxFcLWb2or?=
 =?us-ascii?Q?CiFRsk7y0lOJUUJShw1RYr01kIgJNKwtbI8+tcBo5uyxgQSXzWUrLDkviJzI?=
 =?us-ascii?Q?+Ekh9Sbyscx7yX1Y7SIpe5TRokcuVonWgBdpB5lttUQemJpzNz1PnI4AroJC?=
 =?us-ascii?Q?5+kX9LLIviYreP9o+pX268QDnCL17bQqJ8QLiIF6yKmjyIVYTsIL?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df325ca0-3f24-4d4c-0fee-08da1c43be87
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 05:17:31.2973
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PQPXTOVEOoDFod7mwFwpA7qp+fm+K7OGvavHR7stKL+3sVRAk7OwwXZepAmnprdWXmZGtXP1YOGaSQkX4yqJuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3256
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.858
 definitions=2022-04-12_01:2022-04-11,2022-04-12 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 spamscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204120024
X-Proofpoint-ORIG-GUID: emywsIrXiB0wY5KGqwFzJ2uRTeiVKNoF
X-Proofpoint-GUID: emywsIrXiB0wY5KGqwFzJ2uRTeiVKNoF
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

