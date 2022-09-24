Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D7DF5E8CC0
	for <lists+stable@lfdr.de>; Sat, 24 Sep 2022 14:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbiIXM5N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Sep 2022 08:57:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbiIXM5M (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Sep 2022 08:57:12 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38D1B10977E;
        Sat, 24 Sep 2022 05:57:11 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28O3HRT7003824;
        Sat, 24 Sep 2022 12:57:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=xsJTGTjdhV7i0j9q1Aj30VF5vHNBW1dN5XHw4FWrIS0=;
 b=TiDeAjyIrSYBxEG78QUdbtgv9UCk8kxczml8bLAzWtcwBaopsjpK/E4fJj27a+NwCbOx
 6aOrO2vjGE/4jKzNwKWlJlZBOrFAxJsZV7VMqS/4z3/0EoFyZ+TFvXz3tUJ5pKkURezZ
 fdLJEzlD+iwzPoNaUxdKSX7ml7gkxim6GPDPKprBAMVVhniNyQ3B0qNb4KKq8wqul7DP
 Nca60C4fq5NklFrQd4xS+29KcldEhVMdn67/jjC6vLWydBvkA0fSIjIkSpC3rCM8L6Z/
 rGVRuL1RVQ/WflYrF52NLUcN/xSjFWJN0pVckEvxaKahsPSTwHIpHzop4cAduz8mEmzU 2A== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jssub8ggs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Sep 2022 12:57:06 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28O4d4eZ036755;
        Sat, 24 Sep 2022 12:57:05 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jsrb1s0hf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Sep 2022 12:57:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gvOchgRd163N+69u/y96gq9RgBAnl9K+mmaFogwtbxRtic+Ubh4Fr8JMPMg/ca5QyCa2s2yI9M/4VA9NqwMws8xEgsxpadCCrDnYoale7d5dc67KIAj9tp4jFxQitmgMw7RzwZ52mYaYyGLVA2WiI9DF5gA+sW27yVWFZDvCGHcFnYDKP33vRQLZ643iTw4LCQkd2LwEd6oe76ahE/Py4/GVkw5djRkATcke55oomZExi8X8LHTeSWZXnlo4RVIzh0Mhyej47zJFO1dUgZf6FpUqsVYwEltkiUJw7RZ32NV4LRJS/MTZk+jNo7IT1jDILIRqBuDUlpDTwW1GSt0eQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xsJTGTjdhV7i0j9q1Aj30VF5vHNBW1dN5XHw4FWrIS0=;
 b=GPc0GQ5o2TVrOjMzR7lTG4VEPcieckbrqcfCqpHKZQPyJ8z8G3TGEW4MnL7qQYQv/gtuMfL4yp6qx72iYAUCctiCtt0n/GYP7y0bPqkj0npPAJwhM8Dzvafr/2lMPIgby3ms9+/kB0fIxhX5TEr4qzcLtxABsnV3FahMry7VhnR05POFHpH0du/BqC0eczA1aKzUBVuAdKab8bCa42YE0aqCFHhzKQlAQWQ7/5V64eMYysknOE6IKIBR+adDHb5nVJNcqDiJ+/pu2wDpv+IgznKeq78pBqXojkgTYUht+h/E4RVQ0AC9v635nPhymKfL07vIhKVOAXJFMxno84KaHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xsJTGTjdhV7i0j9q1Aj30VF5vHNBW1dN5XHw4FWrIS0=;
 b=LyUy+D8NwswBw5hQCdIXYg0ndR2Po4MPxUUyFuue/HdYy3sB1bsswmQFJg4K2pC3t4Xqlu2iKYhMeAGdLigmvMWsado6UCM1CMNHrYMX5ZU1bg/rXMibHBhNct1Tye4vNpVBaNErc6Wi6JK/q7eP3bn2krOWAbkLHUwTpeY8aa0=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by PH7PR10MB6249.namprd10.prod.outlook.com (2603:10b6:510:213::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.20; Sat, 24 Sep
 2022 12:57:03 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%7]) with mapi id 15.20.5654.022; Sat, 24 Sep 2022
 12:57:03 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 V2 00/19] xfs stable patches for 5.4.y (from v5.5)
Date:   Sat, 24 Sep 2022 18:26:37 +0530
Message-Id: <20220924125656.101069-1-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR04CA0012.apcprd04.prod.outlook.com
 (2603:1096:4:197::14) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH7PR10MB6249:EE_
X-MS-Office365-Filtering-Correlation-Id: b9a5c5cb-134d-44ea-a772-08da9e2c46cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PzKa5GeaYoRkSHT3mv2Xa3ZxIfMi04orAkS3Q6aiocZ86MsHXsEQlb3Ga7LvPwox0EOLnvhwYIjo4aAzCZX8V8sGvs6joO6tDsawoozudAHUgJCrKmOdruMgt45YTdj2TIN9bcehJAVinngLt/qzrhlwwPh6DSFfMoQZkiNy9KIZVNJ+pPgwSFwS2lbfYTFOfkrJSRB7tVsJi+B34Z8ZF1VQgdpJOE+0Ywmc/M9S9ClPBHPLYWZFqY85QLFVPfaE3eaM8IDWshtm23w+Dytio00f8WM/8T8vaM0xIw/ukgCQI3DPkEJfSCMhuMVvY5ZAEJBkIltmgS/IRrrYrIAl5pPdrBW/VbC9fLJ65s58SshJQrRoQ4xpFjW5V3mJ6/ZBmNzQijALFZDDAAe3DwiOZGUJmyFCM380lXUHjYpvH7iGcdFBXFwYI6F3tDdrZI7HuGgI5h0Cxgy4aII6DbPznn9hsxhQL7GuX2fqO2gh53mDY38BBWdjDYpZskq+O4yJB3cz8phk+4OJebXISK/yclLfORYExxWhXFC0vcAlZvjJTmWG7/1LPWhQ7NVwrVs9y1zVa1u5v5YI7hJIYfKxggO7xO9tRdvGd74Fi6XzFdzRj5IBlvxDUMntOEq0pYWzmri5UJg1pT2y76rNpOYAxD9UT/btlBqAK9Hr+qsUXzAtCi+Q8pjYaLvwG29Ffj7jTswh5ZgJlhItVpFpdLqGAg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(376002)(366004)(39860400002)(346002)(451199015)(66556008)(66946007)(66476007)(83380400001)(36756003)(6506007)(2906002)(86362001)(26005)(38100700002)(8676002)(4326008)(478600001)(6486002)(5660300002)(41300700001)(186003)(8936002)(1076003)(2616005)(6916009)(6666004)(316002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TssfBy+43d36wU1Yp+gcZUK15p8oViXl8y96lHbMReEEf1PIANtQ4CLQe36y?=
 =?us-ascii?Q?Q3mNrs7Q9pl5wrzbocS4lJfgkBgoh+x3sxiSZl2sNfp7GuGmjyDiaiM58M1B?=
 =?us-ascii?Q?IUlSn0DrceKBeUuHhv8PuJpBDNvtsZfR1VI+HCQgJ64AdNSoQ6/ZhCDREOZ8?=
 =?us-ascii?Q?6aSgb8xvKNzRGQs1OSuySYawIMTQmo8O71a0VthQJqBZ6ai8OBnRHgkVw7Rn?=
 =?us-ascii?Q?UgwIkmGJIL7odZoPeS3QNWjiFXq4c4Ds4RQ1APFKEIb9b+oBMIOjv8Fxr4Dj?=
 =?us-ascii?Q?8D/sDNwPlvwOz6GCT3xJlC2A1f3rH3jdiLDLoGv0IDDySuHhhqBVHDrI+Nr2?=
 =?us-ascii?Q?zbNqAiVHVQYROuKf84YNqWgxAhL4/QYYn3v+wTNW417slEHs3dvnbC1ysByY?=
 =?us-ascii?Q?qUuR2HMXTwaHx211cqZ1WsCXOw+3t0Wl2L2SXbiFgBnuKezlXeT/w8AwCpzl?=
 =?us-ascii?Q?ipWglClxpGmaXUfVE8+/8DwyOJFAZ7bf8wra7FiV4jQY6R8PE9/XdcOoEYVc?=
 =?us-ascii?Q?54v2WYdRYKqUJbBXwKh6OZrHuQU23FtqMvJfZgpgEU47TyHt3ZHTDwRne59S?=
 =?us-ascii?Q?OSur0f+RW3DIvp9rQWitzY1DkstU0dpmJ0OhUC1wjFb63DGr3/pE7AxIPkFI?=
 =?us-ascii?Q?JWls5L7uiYEPA+PPtsqxz5OFFYGuFCZXQoEob3DbjuPMb1hcwG+i/adB70VX?=
 =?us-ascii?Q?gZ9fjwudYNPlrqOyqXy2WvXhiEnmd5aL+nPm7Lx0O9K4/pUTpmuPFHyA+yPb?=
 =?us-ascii?Q?0x55X6EnJZL/wynBX3/E2q8NXWnFSYkiJXIzAL7o52Z+MB81orMP4N7sB0fr?=
 =?us-ascii?Q?PjSvVBx21PCc1rvxswd0ja+ljz/LXOcJBrZxwMaj6sTkZLJFOIngtDPYugcu?=
 =?us-ascii?Q?PBD05GbANc82818JjFTZj7OsbHg2WPmec28mdM3MAFRDjB/EL1bCqZ0ctB8i?=
 =?us-ascii?Q?1z3awTX/cUoaNGEfELdXnOE2Dr3ZNeWNH+vIzgDQ/RoZnN17OVnYevmr3n6H?=
 =?us-ascii?Q?4vg4+4I5p6y8T/emsEiZ7vgCsET21sXjTZctJ6k0q6g+Tsx8UZutAGLAUlzS?=
 =?us-ascii?Q?E7ciO4fH+AZ8fpBaYGMu+QCWWqHvi0KMbuLa2STti27akYq4PqQlVY1hzAyb?=
 =?us-ascii?Q?TCk+Z6D0g1o4kVzKpmlv0y6g/M6tBIH0orZBJ8gAg+FeixkusHa62HWV0bAv?=
 =?us-ascii?Q?P1VzjH1rB9N+Ky5kuG+dN0N3c9JI28Cf+w4+bEce8Mnv3SxYDUnFB4T1zYfs?=
 =?us-ascii?Q?AslJLo2GKGPhrWSgJojuidOWK1mHv8y0qPO+2Xbne37MLpCCnzaKzxDakj/F?=
 =?us-ascii?Q?A85dWCpaLEaYmcIB39AnY4YY3cZ1Qvz3Bougm5YgmbQBr3AHxqk2RX+jxKho?=
 =?us-ascii?Q?keDH3lbfuqamoss9RO8tJ2Fgos+lD69ifO4TS4HGuDBONO3BPLJj3z9pMQvn?=
 =?us-ascii?Q?H9GqqEPiC5+E1hKqhkDBIGi72KM9HtvFAwS1PDzUrDjOMWwLFwBQPqcMSoB3?=
 =?us-ascii?Q?RbB3nWxOyyHxHgrVyqPvldWGOqBFZON/pUQ0DNlNNw7LJUqbeKgMThMwubtB?=
 =?us-ascii?Q?Ni+tshd+m1rEoSu6x7DJvHY1V8AybvoT5dVH2aTG?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9a5c5cb-134d-44ea-a772-08da9e2c46cf
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2022 12:57:03.2922
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3jTTAu/9p8zEQ4uBQcRCiyA+pi3LllblX8XzV3FYlH0OvFNdRfHVnS6oqFlWcjxNF7cLENy0/r8FHcvgMRMJmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6249
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-24_06,2022-09-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 mlxscore=0
 phishscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209240097
X-Proofpoint-GUID: xzAJSFS3ZZhPWSRmplAL7IVp3TyySlQB
X-Proofpoint-ORIG-GUID: xzAJSFS3ZZhPWSRmplAL7IVp3TyySlQB
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

This 5.4.y backport series contains fixes from v5.5. The patchset has
been acked by Darrick.

Changelog:
 V1 -> V2:
  1. Added two patches which fix regressions that were introduced by
     two patches present in the V1 patchset.

Brian Foster (2):
  xfs: stabilize insert range start boundary to avoid COW writeback race
  xfs: use bitops interface for buf log item AIL flag check

Chandan Babu R (1):
  MAINTAINERS: add Chandan as xfs maintainer for 5.4.y

Christoph Hellwig (1):
  xfs: slightly tweak an assert in xfs_fs_map_blocks

Darrick J. Wong (13):
  xfs: replace -EIO with -EFSCORRUPTED for corrupt metadata
  xfs: add missing assert in xfs_fsmap_owner_from_rmap
  xfs: range check ri_cnt when recovering log items
  xfs: attach dquots and reserve quota blocks during unwritten
    conversion
  xfs: convert EIO to EFSCORRUPTED when log contents are invalid
  xfs: constify the buffer pointer arguments to error functions
  xfs: always log corruption errors
  xfs: fix some memory leaks in log recovery
  xfs: refactor agfl length computation function
  xfs: split the sunit parameter update into two parts
  xfs: don't commit sunit/swidth updates to disk if that would cause
    repair failures
  xfs: fix an ABBA deadlock in xfs_rename
  xfs: fix use-after-free when aborting corrupt attr inactivation

Dave Chinner (1):
  iomap: iomap that extends beyond EOF should be marked dirty

kaixuxia (1):
  xfs: Fix deadlock between AGI and AGF when target_ip exists in
    xfs_rename()

 MAINTAINERS                    |   3 +-
 fs/xfs/libxfs/xfs_alloc.c      |  27 ++++--
 fs/xfs/libxfs/xfs_attr_leaf.c  |  12 ++-
 fs/xfs/libxfs/xfs_bmap.c       |  16 +++-
 fs/xfs/libxfs/xfs_btree.c      |   5 +-
 fs/xfs/libxfs/xfs_da_btree.c   |  24 +++--
 fs/xfs/libxfs/xfs_dir2.c       |   4 +-
 fs/xfs/libxfs/xfs_dir2_leaf.c  |   4 +-
 fs/xfs/libxfs/xfs_dir2_node.c  |  12 ++-
 fs/xfs/libxfs/xfs_dir2_sf.c    |  28 +++++-
 fs/xfs/libxfs/xfs_ialloc.c     |  64 +++++++++++++
 fs/xfs/libxfs/xfs_ialloc.h     |   1 +
 fs/xfs/libxfs/xfs_inode_fork.c |   6 ++
 fs/xfs/libxfs/xfs_refcount.c   |   4 +-
 fs/xfs/libxfs/xfs_rtbitmap.c   |   6 +-
 fs/xfs/xfs_acl.c               |  15 ++-
 fs/xfs/xfs_attr_inactive.c     |  10 +-
 fs/xfs/xfs_attr_list.c         |   5 +-
 fs/xfs/xfs_bmap_item.c         |   7 +-
 fs/xfs/xfs_bmap_util.c         |  12 +++
 fs/xfs/xfs_buf_item.c          |   2 +-
 fs/xfs/xfs_dquot.c             |   2 +-
 fs/xfs/xfs_error.c             |  27 +++++-
 fs/xfs/xfs_error.h             |   7 +-
 fs/xfs/xfs_extfree_item.c      |   5 +-
 fs/xfs/xfs_fsmap.c             |   1 +
 fs/xfs/xfs_inode.c             |  40 +++++++-
 fs/xfs/xfs_inode_item.c        |   5 +-
 fs/xfs/xfs_iomap.c             |  17 ++++
 fs/xfs/xfs_iops.c              |  10 +-
 fs/xfs/xfs_log_recover.c       |  72 +++++++++-----
 fs/xfs/xfs_message.c           |   2 +-
 fs/xfs/xfs_message.h           |   2 +-
 fs/xfs/xfs_mount.c             | 168 +++++++++++++++++++++++----------
 fs/xfs/xfs_pnfs.c              |   4 +-
 fs/xfs/xfs_qm.c                |  13 ++-
 fs/xfs/xfs_refcount_item.c     |   5 +-
 fs/xfs/xfs_rmap_item.c         |   9 +-
 fs/xfs/xfs_trace.h             |  21 +++++
 include/linux/iomap.h          |   2 +
 40 files changed, 529 insertions(+), 150 deletions(-)

-- 
2.35.1

