Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC204FCEAE
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 07:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347691AbiDLFR7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 01:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347997AbiDLFRs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 01:17:48 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 097362AC67;
        Mon, 11 Apr 2022 22:15:31 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23BMDCuP003034;
        Tue, 12 Apr 2022 05:15:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=+yX14ZFtStujCAT0AP0oxmNyhYY3psGgm9it3ZQTjwY=;
 b=ZofldQ/chlDWbUeo7d5QqutvCz7SDntz93KK6NyhUJt3elTCO+g02Ucwr+jw7/UM9EQp
 keyruQ61ULyiDKYWYNEaIGfrmxM348r1OWkSn08+qrTJrQIMXuS6XsLMBZlPbCyjRJEK
 vMjZuquOrEhB2eJknMUSdFtvdxevKZnOZmEmG/SOKkDW44fc+ryg/97d2JMHhWIJy0iP
 AWn4qZLF9ghf2kbnESGr36VPB71VfVnQ36nTnRLhrtphurZuK04wRsqmWIcS/reapqkK
 esXHMtjOxB0cmCi9HVn2e2Rr78o2T9H+QfM2Y24Mo+9pl3eEmWEAhSp3vm7ArgzaAOEs Bw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb0x2dm9s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 05:15:31 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23C5BKU3023540;
        Tue, 12 Apr 2022 05:15:30 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fb0k2sn6j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 05:15:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RxeA8x4/4Zkk8fLvJQUenW94v4VUGdkkaYnfQ3/IdOSJ1QyvlremzNmluYmw5oimZohAtNOfq4avoVf6s2Dmb6Jpi4pzhyrE+xaVtuPyWjxr5y6pp4jiBBG/DD98DNy+r6c2IH29Z1HegnR36N+zR8lMzIx3BBeLOj/Q80CMZXGT7WioWWDjE9DA75AeY1L3565gD7GmzePeT6q/94xNW81W0llinSoEQDIXCrRvLTxdd2BBnBOA60wxqBX26jqJFf+0hIaUeD4a/7pHjRzix41iDlx+DSS1XHFjS/a4khifOa2qdKKk5KLoAP5gUaSb9oKmWLmn94Prfu1+sfr82A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+yX14ZFtStujCAT0AP0oxmNyhYY3psGgm9it3ZQTjwY=;
 b=lsFOaIqJaHDIP/ZvAQaX5r7xDKwlwRuAdmY8n1Rk55b7fBkGbIA5d9jqXLcpT39pMRgEIeZimWkwQ+Sq2laYU7np/z9+zHj6yn/JkKVArbvZxx2jYBPTUN30gDahaLft3cASvbfe6o61+7Qige8FrJKF9Vr0rfc1/cRPQlLR7RKLSPOF2AfVOHKu+Bt5KyKunbhWfHcOQKd4KV4/WMatJzlFKN8xpXNYn4yVzPDBDs/6C4dreoeNF6I7A+sDg8a7EvpCC3FhDTuriXnL0/w4IhEWSGZRgL9RZqj5nevrfGkwBFiB6lMJEhn13rccvrjiiVQgzCxwSMpana4ZcH+TkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+yX14ZFtStujCAT0AP0oxmNyhYY3psGgm9it3ZQTjwY=;
 b=NmCq2c0czxRHtO6rXR6syCybe+fKiimkcSgV4Hw+aMvN894QovU85cnbjkcOW3mcDypYaAYPF4JfmaBKmohE2fBV0DDK5pUg4kySoPZ+xbGn2vlhx1HWha5BkUURhDs1vIeQtDGv15KZctN1DaQuBj1z5ySRRj7Qy4B5MpcfvNY=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by BYAPR10MB3256.namprd10.prod.outlook.com (2603:10b6:a03:152::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 05:15:28 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306%7]) with mapi id 15.20.5144.029; Tue, 12 Apr 2022
 05:15:28 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Anand Jain <anand.jain@oracle.com>
Subject: [PATCH v2 00/18 stable-5.15.y] Fix mmap + page fault deadlocks
Date:   Tue, 12 Apr 2022 13:14:57 +0800
Message-Id: <cover.1649733186.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0054.apcprd02.prod.outlook.com
 (2603:1096:4:196::13) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 361a31f1-194a-4644-3929-08da1c4374f5
X-MS-TrafficTypeDiagnostic: BYAPR10MB3256:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB325670EA720945F17355BDEEE5ED9@BYAPR10MB3256.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 32zbsjQvE2VIA8ed0pYgdDq6+Q2Sh1N0KFRZruvTSA/Ye20V6vkhemWOMJ7jMnctxeH+H3I2+Z1Vuk//nZRRE/nShPlgVn3wR1kaO9Gytft09EV4N1gHRbyEapWNhq5AJ5NI7K/Bh7S2kLGmpXWvB0wZzk71bcRG4XUtoTh/tgp6TSQquZs6ySrzO0zT48uc00sg5eBk2kIn+xb7EF+o6FDXjbmKVX2lqqjr7vqSMeK7h0sI32hIb5sEWiDMtZRmzrz4TpoMSxbzdcnmCnGLoVLpeCNRkXvaGNHaoStb+U5GeOeDn7ET++u0BfStnHLckp739w3ldaEdTrEz1kzHQrxPnvoSRVzXspuJCVA+8iDw5lgw6xQvwQ8hkMJVMj9OE1BLt0ysYPL9M4BIMozcEPbZp5IRKC01ZPftsiF+OlaUm6ubs7NjePmYb29UdbVABxWgA3ZyoHzdh/MtRCtxCooNRN2441VnD8zcI8/fnQd7/nmjKCQ07J6vBwd35NKPR+kkv8nbuF610KU0Lk7g7iepESOcHZsKFsCHLRH8Jqj5lILKDc/lIpk9XuDBDwFlhWwsNaznPNmfRtwXjdQGlQwsakPkfA+P0pjaUetIZhmeMFkosP0LkOC2r24ZHL3oqSok4FyuwMyXo7RAdFNMzw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(450100002)(8936002)(5660300002)(2906002)(83380400001)(6512007)(2616005)(66476007)(44832011)(107886003)(186003)(6506007)(6666004)(508600001)(66556008)(66946007)(6486002)(86362001)(36756003)(8676002)(4326008)(6916009)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LOgoPSCqsc7ta5qBIwGCdY9VRDVnhe7XDff/QgnQZZEH38JFHn0v0LZR9jb3?=
 =?us-ascii?Q?SULSevwLbWvvEcaLpRenYClp/6n4Kquf/M6h/3AXUS5O3zkaOkCSPtxp5M3e?=
 =?us-ascii?Q?l/6AmOAHf3awoQRHGWHGxdVP9YkONAtLtF7XpzHUhUgQeylf8k/nHtq3YqO6?=
 =?us-ascii?Q?HjHKwWefo+85aDfzkkCNCMU5vtfhcEsgC0chteMyadpBurGOcWc8Coct0sww?=
 =?us-ascii?Q?eWDaV6Lz8d/ieQCUvN/1RTsLkV8i5VZ9YJ0q01rLmpq1ShXrzXmYxoPTGXmo?=
 =?us-ascii?Q?yKBjFtF+JhkL4QkITYkRrIwGPloKB98Jkl/wC/1at3hUdbUEF+tUFdRazk4x?=
 =?us-ascii?Q?rVLpHtSvohOWgA98F8UFPigzNPmEfrjMVN0qFDctWFkoqhoHEmp0cj+5Z4y9?=
 =?us-ascii?Q?0FTQfluAtta6Kls3sstVtF5XIHsdQc3MQcb3STN0niAEkepliRXSGcfm8unG?=
 =?us-ascii?Q?dPhrzBbN1ckEt8rQUs/j6tyGV5ZbSXawNpoSqQ9hpLWh6Bq4BB8G22mD2CES?=
 =?us-ascii?Q?M/XG2U8cYPufxHZSx+cde1TfBfxdvc46Ju+zfGYFtMHilK6KNCQBx4tcsBdl?=
 =?us-ascii?Q?tDZi/qeooumIP5fUbIgtChUK/V27upiAxm72dIHfJWqdlU3HITMj9NPypcQ+?=
 =?us-ascii?Q?cQNSp5rPCY+VRhcHg7aCI0JANGc+qjfUUGS/r7L/4rNdFJZxgbI4yybcF6Zs?=
 =?us-ascii?Q?jvo5uozdxLET848xVSfmvByHpUHYCb8KanBvd5BQVx7CzxVSDZAI7zZ/memd?=
 =?us-ascii?Q?RD75PUaDShXCsA+QS0Kgi0lPFvrXNdh4Q5q60hZ8L5u250KfZCkp7HKdBDVf?=
 =?us-ascii?Q?+gGrU5Z19HpKdGCcODfzOW3Fuwp5bN+ZWeIj0UD2p0QYuqoICVE/JkhdqKrv?=
 =?us-ascii?Q?C/rRx7BrIAYwUJks8mXtAxaCWuRYlPl3q568gim1HVGRxkZ8IAIeTa+TufdU?=
 =?us-ascii?Q?BcxHlzCAtlHBy4uPbxzdmCBYNNwqhdIPzlw996yRGrNX6XSJiFHXGNkR4DqS?=
 =?us-ascii?Q?42yf9XfDJ4pu5EUeG3My8s3Z4NqBu0KDIVrwbesmMj3oNwn5DhRD+sR+B841?=
 =?us-ascii?Q?t7Wqhow1nR0WGqbR/Tj74Wpm+5P0qFidWfBxEUm6WLyqHhkslJ4nRQV08ti4?=
 =?us-ascii?Q?jZDH1ik3jKWTvnnoaMQJga+LPF9EXISNY7tyqtv2WEHMbY8m38HkNNltPb6S?=
 =?us-ascii?Q?+rxhGHMfZTpbPHehlLYqoOSQUcdniAHPskOj+6UJxdjB7BqZ5A3ikzvzLAog?=
 =?us-ascii?Q?Ui41VS4NcPBrjYJutScxs6pDrvxzJrgVB07D/pDxKWUHnDwcRPGYE2SwSkEU?=
 =?us-ascii?Q?FuEOAjf3JinUuUHuAFZm4jxUI9ZkGwTeuKMimHBnopZ6bNcAQrU103icWdgt?=
 =?us-ascii?Q?6j1SEQLk1hwD7tt3cUHd59dRlVg4eQ9wqh8PMhLe1Ll5TdPzHaqjdTEFC6+c?=
 =?us-ascii?Q?Hc+AR+4WoALfY4t7skfbf3cUTopHZig84+nzN6loYNA0nCiMIwaZiQi1BhBK?=
 =?us-ascii?Q?NljjBECDS+rylHTdjLwf/mjXQFdrPwCPin13h+aEwR3LGQnqJXMKHAxUWDTn?=
 =?us-ascii?Q?zt1boI5W/rjW/Ygu5aXJaI+nIMplQnMcF/2hF3njIdArDrbfHqRQ/mReAbiO?=
 =?us-ascii?Q?qm8+EUdr5/d+ItQC5pJHS/ODlbaFvYEIx9eaWbPPnQk01Lj5isfVq8MBtZEY?=
 =?us-ascii?Q?R2qSxjFl3ai0q2e4NkMnFqE1lLaKaG/G7bWz7th9ZrriKWBgkftbuUsYehXT?=
 =?us-ascii?Q?DcfWDJjSgbG0sPK9xaCUToMpH9YcJ7tUBBj2VC35RFytPEHn8uEU?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 361a31f1-194a-4644-3929-08da1c4374f5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 05:15:27.9772
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uWDz44Ir8tWIDLI+khaAbRbNHNcJge1T/aOVNW3lo50ty9gKhSVBdjvKhwuGdcjseQuA9xk7vaLC9WVDQNvZXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3256
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.858
 definitions=2022-04-12_01:2022-04-11,2022-04-12 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=609 spamscore=0 adultscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204120023
X-Proofpoint-ORIG-GUID: 40dkR_GfR5S7jaKVvBnk5Q44dclOweOJ
X-Proofpoint-GUID: 40dkR_GfR5S7jaKVvBnk5Q44dclOweOJ
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

