Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A9CD501E48
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 00:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244010AbiDNWbn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 18:31:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233860AbiDNWbm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 18:31:42 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B91C7C337A;
        Thu, 14 Apr 2022 15:29:16 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23EJT059028178;
        Thu, 14 Apr 2022 22:29:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=F2/nMPEBYlQoCXL9pb6AwI74UocTssXdwMvsCPtefuY=;
 b=HOYb67auKxdike0nQXyc41W0XnkCLcl2pKEU/QJtOONfNUJ+s5MGzvpRjnahMb5ga72j
 ORkZoJKSuetIWHa7Jrk6nsnzQjZsWt8dLcLYHhZnpmUwK+mLAcQaWXh628mhRB5McXes
 SYe3zgbAydnBQ6OlzHwxR07I7URh25Gan0iBVxz5S6etxrpqPfK8wchiqwwccQUqJzbZ
 oFF9NO4IiJNpqk0Mi4fRvY5MhdbE1+ubhtx06OK3yn2yeCyXOcGFpmap4L90bZCm4YxL
 fNKsY9FEfpuoiqYI3qMG20waaBDTge74v3NsSBmenexIgiHotC4GzukRlVTwX8vdN7YQ Ng== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb21a5kxm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Apr 2022 22:29:16 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23EMFolN007650;
        Thu, 14 Apr 2022 22:29:07 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2045.outbound.protection.outlook.com [104.47.56.45])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fb0k5erm6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Apr 2022 22:29:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ny3o9U/wfgGUnB71w+vY74bLUt2KRKYUMf2mYaOKAF54bfl8IUjWinHy6L80FTCPKX8x1OPjbV5TiTud6Tn6Qly0FkObfm4xtxh1faVCQ8qn4vMHmnOEPK6eLvVeYoC4ffnQJzScQOTIt0NPjHLx0ydY/Xo9adht30LhdjEtRZIXyzIN96yExDG8qs4Nnjp4rNVWxa/yBnz5THXgPTwVJYoF0R14S0wB+WmuxktfV+IxlWSbMSAamiEYChb2txrG7wtkz4am6e2afSoswmBfPedDKOydaQXVbGdaYqubVffryV6vzISGtVpkA3+9kxSwrRt2lZ5HfcNfD4WPx07m/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F2/nMPEBYlQoCXL9pb6AwI74UocTssXdwMvsCPtefuY=;
 b=V8f2yTx7GQy5iPBHRtOcaE50bgDsFn2NYidjaJF9GhKb1t+VQBAIasbpELAVQQNYUUSM/eKXUOFh/FLyuvyW5X0cHPDEsTvCpVGbCjlSImlPqKQKfeUTbL5aonNUvWNmYZ0zlIWhX8WOZ00k67neVUw6lIoxp6vQvy3DMYl2knkW4GNLMdJqMEnXOatfxJn0Gz+S6Cr1p39nkJcwcf3HSb+Ae+bB4Zw5/kvu7pQuiRUTA/oJd+MdD/SS6d5lSZB8xFwaGaYHfXzvbAlJUdmY2i4wiBa3xdB+8y0QZxhgygmWs7D9RMam++eJZDXBysVTAmv3213XhsnA+Ty/DjaLEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F2/nMPEBYlQoCXL9pb6AwI74UocTssXdwMvsCPtefuY=;
 b=SZ/Ckd+H/8tuOiAXxIsOWmr9XotgU2/CDwOi/+o/MQCzyIHUeIsiK4cDdy0Qx54UPpNqH1cr/EsPJBMVSQmDPCUev4bL8sfcD/LI0YNd+1m5FPf0B4XqEHlDxlYWCpV/O58QWAPw9ZbANOWHRSKFYYg99ZxEz3loMTZA9D3ndbc=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by CO6PR10MB5572.namprd10.prod.outlook.com (2603:10b6:303:147::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Thu, 14 Apr
 2022 22:29:05 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306%7]) with mapi id 15.20.5144.029; Thu, 14 Apr 2022
 22:29:04 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Anand Jain <anand.jain@oracle.com>
Subject: [PATCH v3 00/18 stable-5.15.y] Fix mmap + page fault deadlocks
Date:   Fri, 15 Apr 2022 06:28:38 +0800
Message-Id: <cover.1649951733.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR0101CA0035.apcprd01.prod.exchangelabs.com
 (2603:1096:404:8000::21) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5e688b06-a6ae-4d8d-3399-08da1e662eb5
X-MS-TrafficTypeDiagnostic: CO6PR10MB5572:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB557205827B4D323E6F098590E5EF9@CO6PR10MB5572.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u9t6kCxwiDmepK8fwAuUMiyKbmKAO1A6LI/x7Ybi8S5ThYFAu6olQ4AunZSYpst/4gXIfq0iAhFLukWgFqhUfcVT751JlgVF3VWi6bg1K6tcRBZzttB9ugLrGAvGByqyYpagAMfCCyWJocmd/qymGzBN2jYW8AbU1okjtxBnwh+q1ruPiBQddwQUAz+qZnbaNnPeq0GttE/tH0D7WXNL/euCBKxzbNBwj5vuZG5lN7MFUV6MU9Qu5j5eEfHwMKMnVzq3ceMyunB51zwv7qN2AfTXd9MJ+G+pYYc/qXFer7AuwLXefE0K8YXOLKECBOu/vg/oToGMYDCqb3bEiT6j9icGowUBXoB1y6FfDYZM3DwcZVNgA8k1KYKZUO95SsyjVGwTUJUzDiLDwrxgj9px2kh1DW08/Rf3auSvYNcKz5aiaA/16459JaRvhIXf218tQLkgr6dM2QHBP5gdp4Y82OTTAg6N6lRGy68HFU8hmU8Ie3yeV1MJINorwpq4Y9HpzYKT9czenTFeTmhgprs3zuurM9HbZysiFN6+Ey7PVE4Lanfg5iPRXojuEabUnQI9GZX5luXLu8OD6kIKhzeNWv1t2ye5Fd8K9jGdswnOXKM+fhWsfTwNqpSSpfKupm/ACL6kggMqv3cMbMNCrPsZfA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(450100002)(107886003)(83380400001)(44832011)(2616005)(186003)(6916009)(5660300002)(8936002)(316002)(4326008)(2906002)(36756003)(6666004)(6506007)(38100700002)(86362001)(6512007)(66946007)(508600001)(66476007)(6486002)(8676002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OUhpIKOQTj9T4ugK1c5v0B4X36O6wX3v+dC4u65ORG8mFnxwoA3Bng8npEcg?=
 =?us-ascii?Q?tZLe6FyAwWmxpZo5PHs6TJnzlI8gjtVK5OaWcx6CVCwHaOH7ltAD4EOinCfO?=
 =?us-ascii?Q?jy9DXs53IoPWNnIOdzKWItQYGe0gVRU60pJN4DyrwCZUzJKlrHBpmbuTPd6s?=
 =?us-ascii?Q?M5JivKMPhqu3SERDHDCcd2S/ez0c9YC6V900Sf+sy7/C1swIxykQp5gBKxAa?=
 =?us-ascii?Q?zk07r7wmmuxlIPT4T5v/tuBfLAW52ar/m+1haHT9/TFZk4+2WuBUkzIto9E7?=
 =?us-ascii?Q?plT/n2F8PAgUfkZoQNDGq/1X8ig/V9KnkQhwSpbqpi5bZnL4KOcjiaqAaKGM?=
 =?us-ascii?Q?j883wj13Ir7gmR7UkroTKVbKD9JD4d70BPbjjh3TrIKyX1XOVr6S5YXS2NTF?=
 =?us-ascii?Q?23Keulq1TpbOITUNxt7rTv221j4WabjUnDMo3GJqU/+nO7oMc++VztatwDtJ?=
 =?us-ascii?Q?Yzn2TmRdD1LaUwqROGnqMpKbvZDYUzmYHJ9MiY+3deA+bIAl4vY896/ji++m?=
 =?us-ascii?Q?oqGuo/i/pDXQfRuP5tVyzht2BezZjd6aylcJz2QVfGLzfQ/yPztB05fkt05H?=
 =?us-ascii?Q?NRIZ8jZ2sqfE+bVTz+BKBQ5XiWq7lrQlC0ZY6Xns8H+2oSR9CMTtYplC+HDT?=
 =?us-ascii?Q?n2NsLorHqThJju9p/dE6mrGku63lTvmLOA/ER7sgeWW+abC0fTBynO2Ieeio?=
 =?us-ascii?Q?6yO+LpP5Oe5WjpLbfxoEi+6UXDtuKrNnsXQw/cXSzYs2+SyNJgNPBjZ5+D2Y?=
 =?us-ascii?Q?IVL/4xIKKusCYAe7CzJJF+VT3XETzJD6im61Rjnr3Z+PiRD/ckol2AA4Oks/?=
 =?us-ascii?Q?MzYU7AJTxUJ0VvIxjAeJgUBnwk+on7xUS+mKiFuLWVBBSnPTRJ3ScLZcdf8E?=
 =?us-ascii?Q?l4yFmUo+AqNaYv87W4k2sBHzODqomV2NGQjIlAdqCqrHoQLx+XglB8+xyy8j?=
 =?us-ascii?Q?XFCZYCAZVYYprBPYsgvRBBB5zF/gtpW2akFHvn5mjAo6sM35fPmGcggwxT8V?=
 =?us-ascii?Q?qaGs16m3utc1OhUXks7IVy0VMr/Wy6lfGhWwDC7NbODd8XBK/P/wo0K1YDzW?=
 =?us-ascii?Q?L6BjzncHSdfc/nhm7NBWXwq0eh7hP3JKVKayGMG6I9tUXc6jBPBRyEKGBX7W?=
 =?us-ascii?Q?JJUnC09vEBH3axSC7m48MbLkVtbajHDT55o7OI7aAGWtoSb4TRlyM3aR+wXR?=
 =?us-ascii?Q?/pxYtyOdjNdqvfu/C+wQti/g4eiW7Ctl9XixSWUpZb0xVsjGSNpkCW2lo1ey?=
 =?us-ascii?Q?il+NJlAmiZ73rSiiBFudIUYyD4ViRQl8XVoh/t6Rhy96jgSgXJZt7L6Senvp?=
 =?us-ascii?Q?CBZnyc42mWw+ZpWwcX2KifcbUru9JF5y62LVF2Zs1iDyDOahqZNgOl+eISiw?=
 =?us-ascii?Q?HUROa3PIFaAD6hLYWlp6KjWYY28lVbvE4lN86JbeCN3skpqAW3qaceUJ23Nl?=
 =?us-ascii?Q?0klg4F/MKlApYedSzlZr7HxSESRUj0p/RfKvh57EPgN8V1fDo0kjpWWq/EDK?=
 =?us-ascii?Q?IfTOB9+ej6Ati6Km3FNjgilPJ6GsYoOfEjtflhPx+kkEi3zo1kk2pDtWQ2/f?=
 =?us-ascii?Q?okWxeGZOZr/LwmXsc0VmXZFeL+IcwYxKZdSrgyJLboarqIGV8kEhGC4qktUc?=
 =?us-ascii?Q?iJWxrCH+hc6W7VWvl3BQlcuBvvqO7SbJRAS1RryknYtHQD+mgp4AF9cMah62?=
 =?us-ascii?Q?nD+mfHc849p1IHb3PzSox6eCSYHsjj/NJ9lKO7whHyZtcApGIE2wEfTtSRjT?=
 =?us-ascii?Q?hdfFOkpRrwXbZh4Mu9u6edU98DmjvgdDHG2fpP7LrJGwdarZqStH?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e688b06-a6ae-4d8d-3399-08da1e662eb5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 22:29:04.7202
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o5YnH5+7hHj25bnaLDwpYWJ1adHsgwW2Z7EDi9V/Wc4+WpNQfDvD/P5xluZm8c5Hv1r5k96PE4mMJJQUQlEEVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5572
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-14_07:2022-04-14,2022-04-14 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 mlxlogscore=638 mlxscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204140116
X-Proofpoint-GUID: 3kPea3atwlpbIIhXZrMOOsELCVbn5TKJ
X-Proofpoint-ORIG-GUID: 3kPea3atwlpbIIhXZrMOOsELCVbn5TKJ
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

v3:
Fix the patch order and fix the missing symbol compile error when compiled
after each patch is applied.

v2:
Rebase on the latest stable-5.15.33.
Adds the following commits to the v1 patchset as they fix issues in the
merged commit.

  ca93e44bfb5f btrfs: fallback to blocking mode when doing async dio over multiple extents
  fe673d3f5bf1 mm: gup: make fault_in_safe_writeable() use fixup_user_fault()

And this set drops the following patch as it is already in the
stable-5.15.y.

  [PATCH 01/17 stable-5.15.y] powerpc/kvm: Fix kvm_use_magic_page

------- original cover letter --------
This set fixes a process hang issue in btrfs and gf2 filesystems. When we
do a direct IO read or write when the buffer given by the user is
memory-mapped to the file range we are going to do IO, we end up ending
in a deadlock. This is triggered by the test case generic/647 from
fstests.

This fix depends on the iov_iter and iomap changes introduced in the
commit c03098d4b9ad ("Merge tag 'gfs2-v5.15-rc5-mmap-fault' of
git://git.kernel.org/pub/scm/linux/kernel/git/gfs2/linux-gfs2") and they
are part of this set for stable-5.15.y.

Please note that patch 2/18 (in v2) (was 3/17 in v1) in the patchset
changes the prototype and renames an exported symbol as below. All its
references are updated as well.

-EXPORT_SYMBOL(iov_iter_fault_in_readable);
+EXPORT_SYMBOL(fault_in_iov_iter_readable);

Andreas Gruenbacher (14):
  gup: Turn fault_in_pages_{readable,writeable} into
    fault_in_{readable,writeable}
  iov_iter: Turn iov_iter_fault_in_readable into
    fault_in_iov_iter_readable
  iov_iter: Introduce fault_in_iov_iter_writeable
  gfs2: Add wrapper for iomap_file_buffered_write
  gfs2: Clean up function may_grant
  gfs2: Move the inode glock locking to gfs2_file_buffered_write
  gfs2: Eliminate ip->i_gh
  gfs2: Fix mmap + page fault deadlocks for buffered I/O
  iomap: Fix iomap_dio_rw return value for user copies
  iomap: Support partial direct I/O on user copy failures
  iomap: Add done_before argument to iomap_dio_rw
  gup: Introduce FOLL_NOFAULT flag to disable page faults
  iov_iter: Introduce nofault flag to disable page faults
  gfs2: Fix mmap + page fault deadlocks for direct I/O

Bob Peterson (1):
  gfs2: Introduce flag for glock holder auto-demotion

Filipe Manana (2):
  btrfs: fix deadlock due to page faults during direct IO reads and
    writes
  btrfs: fallback to blocking mode when doing async dio over multiple
    extents

Linus Torvalds (1):
  mm: gup: make fault_in_safe_writeable() use fixup_user_fault()

 arch/powerpc/kernel/kvm.c           |   3 +-
 arch/powerpc/kernel/signal_32.c     |   4 +-
 arch/powerpc/kernel/signal_64.c     |   2 +-
 arch/x86/kernel/fpu/signal.c        |   7 +-
 drivers/gpu/drm/armada/armada_gem.c |   7 +-
 fs/btrfs/file.c                     | 142 ++++++++++--
 fs/btrfs/inode.c                    |  28 +++
 fs/btrfs/ioctl.c                    |   5 +-
 fs/erofs/data.c                     |   2 +-
 fs/ext4/file.c                      |   5 +-
 fs/f2fs/file.c                      |   2 +-
 fs/fuse/file.c                      |   2 +-
 fs/gfs2/bmap.c                      |  60 +----
 fs/gfs2/file.c                      | 252 +++++++++++++++++++--
 fs/gfs2/glock.c                     | 330 +++++++++++++++++++++-------
 fs/gfs2/glock.h                     |  20 ++
 fs/gfs2/incore.h                    |   4 +-
 fs/iomap/buffered-io.c              |   2 +-
 fs/iomap/direct-io.c                |  29 ++-
 fs/ntfs/file.c                      |   2 +-
 fs/ntfs3/file.c                     |   2 +-
 fs/xfs/xfs_file.c                   |   6 +-
 fs/zonefs/super.c                   |   4 +-
 include/linux/iomap.h               |  11 +-
 include/linux/mm.h                  |   3 +-
 include/linux/pagemap.h             |  58 +----
 include/linux/uio.h                 |   4 +-
 lib/iov_iter.c                      |  98 +++++++--
 mm/filemap.c                        |   4 +-
 mm/gup.c                            | 120 +++++++++-
 30 files changed, 920 insertions(+), 298 deletions(-)

-- 
2.33.1

