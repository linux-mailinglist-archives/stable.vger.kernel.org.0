Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6DD63EB3B3
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 11:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240089AbhHMJ4m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 05:56:42 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:56100 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240061AbhHMJ4k (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Aug 2021 05:56:40 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17D9qvSq013389;
        Fri, 13 Aug 2021 09:56:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=czxB8gmLOTxjIeD+mEPHcnFs6FDQqDWxJv5LIKkkq4A=;
 b=Dh3CfDWmPGy2iUT9/5hwWaHBstW6y5g2DVyEYuFT6/JSW47quP5lNYBRCQcbB/r1b323
 UletyqMETti6oaUjmYErT9KE2zBcBP3EoE3WjcCROdfeDFkKyGciBAKEJ0SMED4TqiS9
 shkN9b72QShANX5GL4rlnD4lskEYOtF5iRUlPzw50mUeeZggyWlBtCVbOWgTUyCVWAI8
 7pA6q8zjxCBLdzITYN2WYBYPretyS29fEERcIefKfU7UoOnFyOwRG+8EHwFZbqzvkkse
 pVEt//Paew+L2vdZprwY9EcUnEUxqV1pxSvYXrVvjUl5dMvhWISAoUAu1i9ytypGv3Z6 Bw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=czxB8gmLOTxjIeD+mEPHcnFs6FDQqDWxJv5LIKkkq4A=;
 b=kkD6voTVcODp8CBwMrf9i/yN94IXDgpifnlEKaAuVH4zPlz9NbzmRzjJgI4Z5Nkliftn
 gz8he4WjuO22b8DtRz3f+fiGjAz16hkKLzyH2nwXWSgrp9iAWK6XuZwu1LOXMiXbck9F
 ldDFOnoioSzf6yysqFK7Aq2URQ2su8UzG+4EHcx8Q56XqnEZJinTfyLdbDkMPWT3OMBC
 nA3JIC5GJiqiln1kUbF4Xa2I/ufOCUdm4fzOTMA67/G9xFbsV7SSEEMelS/C6Elm+dfd
 QqMtX4CW5isdVkXwY5VEI0Sg4ehz1nvdLyCP98s3mDR0TIDg/tUBC7T3t5lL11+5NUcg Mw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3acw9p30sv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 09:56:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17D9oVCQ047331;
        Fri, 13 Aug 2021 09:56:08 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by userp3020.oracle.com with ESMTP id 3aa3y033j8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 09:56:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QDOOSfnx6GqWUz8A7sXw6vnSn0+4FpNBmDT+7xhQ7v0B4qf3F+oA/T9CI/ImOVp11THgsiQKepgb1VVGh6SRGnkzJieMErgYAMMDWf6bgxGGoQd4okw7PKa+qC7cVPAvxVuMN/x818bxzPFNqBPTk88IEhbF7mMTnCqgtX+UXE1+kK94qEmh1ulJS0Zjt9/yIBzWfLlwFMwDcUYH3Z0adcG/fVRJm9ygz0FTyQbRE354vYZ4RbgAD1ZZr7y8MV+PiBQNGE6ozW2ZiTkRadsctDh9JznvG+gsZORFilskmK4MnjkSBWSUSgKwrZXV8aNl/c/t/CcAUCkyDsgZ7m7GVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=czxB8gmLOTxjIeD+mEPHcnFs6FDQqDWxJv5LIKkkq4A=;
 b=L7KmrvpQF/Uex8uwUHg9L2lms+X/+ySPl7VtlGZ/jV85b+FqL21b+MhqXV4+F36ydOE2Q35v/geAJj3Mf1GALT+a8YW+loe/dXr/GjubKrzXbc7DUE56EKwMz4+ker34a6/A5WViT5yNhZ+j/d5FjtKLW+9hAYFwxyyJLa9GUUrj2ACFon3HMW7/AXqRD4qUNT+YKXl3opOV7OTK/g6uT0ASIq5LCT2uF8e3G+GPX2F+3FAtyddXJimgu5DFo7nt11SIP8FE1HDq6loHMq1NzKXpxWHRhvlnjuXY/XFfkte+1xVEdPEEHcGogStnXFOXNNHwr+UXjGCQ17yOsymuQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=czxB8gmLOTxjIeD+mEPHcnFs6FDQqDWxJv5LIKkkq4A=;
 b=IcCtXSO6h81N0eW09Kcv7a5438rbfHWAg1vdW9svSg1HnxzYq9REG+jsc4vW5vKYkGulMTRcNB7y2lUA/LNMhIQgPElGVgOmU1Ef5Ck3AA0gnHkAkNZ/bTYcAJzqiwU2JKdOjPEwdeEmDMVLJxn2SQABGPNo/Bs+QP/trsFImr4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from MN2PR10MB4128.namprd10.prod.outlook.com (2603:10b6:208:1d2::24)
 by BL0PR10MB2963.namprd10.prod.outlook.com (2603:10b6:208:78::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.13; Fri, 13 Aug
 2021 09:56:06 +0000
Received: from MN2PR10MB4128.namprd10.prod.outlook.com
 ([fe80::b813:4805:31e:d36a]) by MN2PR10MB4128.namprd10.prod.outlook.com
 ([fe80::b813:4805:31e:d36a%5]) with mapi id 15.20.4415.019; Fri, 13 Aug 2021
 09:56:06 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 7/7] btrfs: fix lockdep splat when enabling and disabling qgroups
Date:   Fri, 13 Aug 2021 17:55:30 +0800
Message-Id: <60ff32a043f5315ee559d4d9e1222e0f40a93917.1628845854.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1628845854.git.anand.jain@oracle.com>
References: <cover.1628845854.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR03CA0124.apcprd03.prod.outlook.com
 (2603:1096:4:91::28) To MN2PR10MB4128.namprd10.prod.outlook.com
 (2603:10b6:208:1d2::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (39.109.186.25) by SG2PR03CA0124.apcprd03.prod.outlook.com (2603:1096:4:91::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.9 via Frontend Transport; Fri, 13 Aug 2021 09:56:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7b5897ab-fb15-42c1-0368-08d95e409144
X-MS-TrafficTypeDiagnostic: BL0PR10MB2963:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR10MB29638DDD35BCF452310FEEB7E5FA9@BL0PR10MB2963.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bYBvUntqPxXabLR9BxBEGWE22DE9eJ2lOCFgGT6Z+9ngnNLx2FgYt7+Mr1NqA0ShZBStPYpjt8ms3oPz+zhfxRjjn5ZiKi3PGLVS4XVdU0QZ7KaqrU6KmsS4peRdHLy1BDp3hcEE5aE99kt1Qh/UvoAzETI+ACW2/c4AMp0hIAxFhnLoO/uocFj0sOSUGfiGHZfMe6C7vwbWY8TislBwvRMb28PN73YTIw5h8xiG4nn0PaZwjivy1rMnnyX+pOZaPiR2FiMInFq4yK2b+kz6mAjIaJJqU77B5JJhneZ+YgdNi7dC8PO5G7hn5RZfBA18uAA2KHWlGybOx5u4/Cqw5MV+ValgIfC7Hp1kZDYTvWlaLot5AxbOSclz/LIwwGDRKpl0YQy+01XV+5jsoZJ+A3C6fBR/OQm9InUDcimUM3kHR+RH36gfszz9QALs24TaciOSacJil+hNpYf/NNzdSJXrm4CtuyZJhPnskNNv5RKYFg+sY5eQRKRgCUHlVYcKoD1kLMamtWraMp/Z2ATfvyj+XBcziPX8DM4NFKknyfHcMi/p0X5pmxOq/Z8eJA7h+WBZk/I/MDDkpS+Z45J6Ebfr4gzaKQXtkm2VX0iW5m2kI2MTIYXn+cM6+g7T6Oq0xLuOvOXH6TQSiq9jlFDwUVGKtHCz0zr5DT68mloM1Vez7EbVdK4gAv3gftAx0Kcrro1Y1HT/s4cEP0oe+2XTuQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(39860400002)(376002)(366004)(346002)(6506007)(478600001)(52116002)(83380400001)(86362001)(2616005)(54906003)(5660300002)(956004)(316002)(107886003)(44832011)(2906002)(4326008)(38100700002)(38350700002)(6512007)(26005)(36756003)(66476007)(8936002)(66556008)(66946007)(8676002)(186003)(6486002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YmdUIhhU6UAtf7Dzd0TLLE4iY5LkYkqMR5P1xxM6s3kmu59qchBZcu7ypoCQ?=
 =?us-ascii?Q?yGPPgF5N5ZRivo0MGR/5EYhCJ2XwzloasKzmVQeB0O54+aft6C3lY1lprTaH?=
 =?us-ascii?Q?zTXKfzj1TRgT332X53Z8m8ZHA5k/oEr6XS/wyxC2zy1ONacyFrUcEEzPWEXx?=
 =?us-ascii?Q?cuP+lq/m+WD/oqJY40RvJ2pQ+Z7NbEsnD8Z9QRmpsE4okjhtmbhZrW2tJ3Mw?=
 =?us-ascii?Q?1JIkIEox0CATatQJ4r9LK/H1d0g1p+69RCEtdyUWEjS2SgV1dMK4ohXkBiGq?=
 =?us-ascii?Q?DGL4pkqt8G8zFfRyNIn+ISFOX5WmKmm2M7VhH13+S7dZn1lzOpl/+9sqRXze?=
 =?us-ascii?Q?CxQqu83p9BqwX/UAk+4bJ1DedOTQSBBwnhIscjwAAHNrvdHwhxy/pR9scz0/?=
 =?us-ascii?Q?ZAr1h961/oqRGCVS2rQHjtfkq1InDzA31uERvsvjaErxnG0pCffzlgI8pcmx?=
 =?us-ascii?Q?W1zIVATvdjVwkteKheAHA15OS06+KxQF8b0wio4V5PNqyD0Roh9lmsL8Rxme?=
 =?us-ascii?Q?0uzqrH5lD+mynGArWItsiVvKdnR/Yu3HxB527koOG0oGuFRVmdd6DQMvPp5G?=
 =?us-ascii?Q?fE15CF5D7PcMcexFWrod3z0P4lvnWsNRjLb79d7oCSTQoxogfYCRpsE7t45n?=
 =?us-ascii?Q?1BV0mvs7gG/sGzgQODvy0XYuYfM977GroAd8pJZuIZR++m+jL2kDQG3cCeq3?=
 =?us-ascii?Q?RBt1NfTjyJA+6puAx1l1uOP2MlyT2Mrf4yWJUKrl9oo7RtmZdCAFWzrSFzoE?=
 =?us-ascii?Q?ev4dSL21/WID9F7IStNC0TDr+a1IA/cIE9BjpKJBfrgoGeKfpxKcdkFOVOtp?=
 =?us-ascii?Q?8fe2fEw+nYNeDDabjK19nfAlJZKlR+KMDCqK3XvED9DqAi05+r7/s1Nij3GH?=
 =?us-ascii?Q?vwU1i5mwGomUE1azeYaNrfjFnfoPK01u+0QkNoVjY0b8TcfJyVOfcH0hXxpc?=
 =?us-ascii?Q?9sjRFxJpDXH0XNwIqx+48OclmNZkvrh1kcJ5g8IacVtgHFCnS+W9dBj2+XWJ?=
 =?us-ascii?Q?8+z53u54DCxL2oNNtapZDsfZD5hAuEESA/z6fH5adiuYqPRWBZs/hUYkIXk1?=
 =?us-ascii?Q?wNBRPLhUHWGB42rkEtwUgLjqtO4scOA7GnRuBTcDuMwVfcoxVIXD9CoHWYcD?=
 =?us-ascii?Q?vG/HEG/5H+s2RSgfXCqbyzAPS4GQYQAE0UPnQWS8wZeZL+WSw0FXZR2ddt9h?=
 =?us-ascii?Q?k0qkcEU5Rx/4jkjqVFSwYfZz+ZuuMPunTB5IAB9x2ImpJL+ViwqXef70k1rM?=
 =?us-ascii?Q?l+cPUaBsdKJZMIqcRiZdrgDLn7VmwRaYkFfIBf/z8ezeUemG40Hg7TeQ1RU5?=
 =?us-ascii?Q?O7H6QzM+lTUqBraXFdKFbuMf?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b5897ab-fb15-42c1-0368-08d95e409144
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2021 09:56:06.0783
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C4rxgsnC3oY+SRA5J7yXp0sarXEDcvC7bi/wv6fZLUqFf3VhZ+F6X3J5hxGP+oB8TZa7lNn4zMB0BKm9mCd9Ag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2963
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10074 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 malwarescore=0 phishscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108130059
X-Proofpoint-GUID: liT3-TV32y08xH16WzduwFw9wteUFnqF
X-Proofpoint-ORIG-GUID: liT3-TV32y08xH16WzduwFw9wteUFnqF
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit a855fbe69229078cd8aecd8974fb996a5ca651e6 upstream

When running test case btrfs/017 from fstests, lockdep reported the
following splat:

  [ 1297.067385] ======================================================
  [ 1297.067708] WARNING: possible circular locking dependency detected
  [ 1297.068022] 5.10.0-rc4-btrfs-next-73 #1 Not tainted
  [ 1297.068322] ------------------------------------------------------
  [ 1297.068629] btrfs/189080 is trying to acquire lock:
  [ 1297.068929] ffff9f2725731690 (sb_internal#2){.+.+}-{0:0}, at: btrfs_quota_enable+0xaf/0xa70 [btrfs]
  [ 1297.069274]
		 but task is already holding lock:
  [ 1297.069868] ffff9f2702b61a08 (&fs_info->qgroup_ioctl_lock){+.+.}-{3:3}, at: btrfs_quota_enable+0x3b/0xa70 [btrfs]
  [ 1297.070219]
		 which lock already depends on the new lock.

  [ 1297.071131]
		 the existing dependency chain (in reverse order) is:
  [ 1297.071721]
		 -> #1 (&fs_info->qgroup_ioctl_lock){+.+.}-{3:3}:
  [ 1297.072375]        lock_acquire+0xd8/0x490
  [ 1297.072710]        __mutex_lock+0xa3/0xb30
  [ 1297.073061]        btrfs_qgroup_inherit+0x59/0x6a0 [btrfs]
  [ 1297.073421]        create_subvol+0x194/0x990 [btrfs]
  [ 1297.073780]        btrfs_mksubvol+0x3fb/0x4a0 [btrfs]
  [ 1297.074133]        __btrfs_ioctl_snap_create+0x119/0x1a0 [btrfs]
  [ 1297.074498]        btrfs_ioctl_snap_create+0x58/0x80 [btrfs]
  [ 1297.074872]        btrfs_ioctl+0x1a90/0x36f0 [btrfs]
  [ 1297.075245]        __x64_sys_ioctl+0x83/0xb0
  [ 1297.075617]        do_syscall_64+0x33/0x80
  [ 1297.075993]        entry_SYSCALL_64_after_hwframe+0x44/0xa9
  [ 1297.076380]
		 -> #0 (sb_internal#2){.+.+}-{0:0}:
  [ 1297.077166]        check_prev_add+0x91/0xc60
  [ 1297.077572]        __lock_acquire+0x1740/0x3110
  [ 1297.077984]        lock_acquire+0xd8/0x490
  [ 1297.078411]        start_transaction+0x3c5/0x760 [btrfs]
  [ 1297.078853]        btrfs_quota_enable+0xaf/0xa70 [btrfs]
  [ 1297.079323]        btrfs_ioctl+0x2c60/0x36f0 [btrfs]
  [ 1297.079789]        __x64_sys_ioctl+0x83/0xb0
  [ 1297.080232]        do_syscall_64+0x33/0x80
  [ 1297.080680]        entry_SYSCALL_64_after_hwframe+0x44/0xa9
  [ 1297.081139]
		 other info that might help us debug this:

  [ 1297.082536]  Possible unsafe locking scenario:

  [ 1297.083510]        CPU0                    CPU1
  [ 1297.084005]        ----                    ----
  [ 1297.084500]   lock(&fs_info->qgroup_ioctl_lock);
  [ 1297.084994]                                lock(sb_internal#2);
  [ 1297.085485]                                lock(&fs_info->qgroup_ioctl_lock);
  [ 1297.085974]   lock(sb_internal#2);
  [ 1297.086454]
		  *** DEADLOCK ***
  [ 1297.087880] 3 locks held by btrfs/189080:
  [ 1297.088324]  #0: ffff9f2725731470 (sb_writers#14){.+.+}-{0:0}, at: btrfs_ioctl+0xa73/0x36f0 [btrfs]
  [ 1297.088799]  #1: ffff9f2702b60cc0 (&fs_info->subvol_sem){++++}-{3:3}, at: btrfs_ioctl+0x1f4d/0x36f0 [btrfs]
  [ 1297.089284]  #2: ffff9f2702b61a08 (&fs_info->qgroup_ioctl_lock){+.+.}-{3:3}, at: btrfs_quota_enable+0x3b/0xa70 [btrfs]
  [ 1297.089771]
		 stack backtrace:
  [ 1297.090662] CPU: 5 PID: 189080 Comm: btrfs Not tainted 5.10.0-rc4-btrfs-next-73 #1
  [ 1297.091132] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
  [ 1297.092123] Call Trace:
  [ 1297.092629]  dump_stack+0x8d/0xb5
  [ 1297.093115]  check_noncircular+0xff/0x110
  [ 1297.093596]  check_prev_add+0x91/0xc60
  [ 1297.094076]  ? kvm_clock_read+0x14/0x30
  [ 1297.094553]  ? kvm_sched_clock_read+0x5/0x10
  [ 1297.095029]  __lock_acquire+0x1740/0x3110
  [ 1297.095510]  lock_acquire+0xd8/0x490
  [ 1297.095993]  ? btrfs_quota_enable+0xaf/0xa70 [btrfs]
  [ 1297.096476]  start_transaction+0x3c5/0x760 [btrfs]
  [ 1297.096962]  ? btrfs_quota_enable+0xaf/0xa70 [btrfs]
  [ 1297.097451]  btrfs_quota_enable+0xaf/0xa70 [btrfs]
  [ 1297.097941]  ? btrfs_ioctl+0x1f4d/0x36f0 [btrfs]
  [ 1297.098429]  btrfs_ioctl+0x2c60/0x36f0 [btrfs]
  [ 1297.098904]  ? do_user_addr_fault+0x20c/0x430
  [ 1297.099382]  ? kvm_clock_read+0x14/0x30
  [ 1297.099854]  ? kvm_sched_clock_read+0x5/0x10
  [ 1297.100328]  ? sched_clock+0x5/0x10
  [ 1297.100801]  ? sched_clock_cpu+0x12/0x180
  [ 1297.101272]  ? __x64_sys_ioctl+0x83/0xb0
  [ 1297.101739]  __x64_sys_ioctl+0x83/0xb0
  [ 1297.102207]  do_syscall_64+0x33/0x80
  [ 1297.102673]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
  [ 1297.103148] RIP: 0033:0x7f773ff65d87

This is because during the quota enable ioctl we lock first the mutex
qgroup_ioctl_lock and then start a transaction, and starting a transaction
acquires a fs freeze semaphore (at the VFS level). However, every other
code path, except for the quota disable ioctl path, we do the opposite:
we start a transaction and then lock the mutex.

So fix this by making the quota enable and disable paths to start the
transaction without having the mutex locked, and then, after starting the
transaction, lock the mutex and check if some other task already enabled
or disabled the quotas, bailing with success if that was the case.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>

 Conflicts:
	fs/btrfs/qgroup.c
---
 fs/btrfs/ctree.h  |  5 ++++-
 fs/btrfs/qgroup.c | 56 ++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 52 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 1dd36965cd08..cd77c0621a55 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -827,7 +827,10 @@ struct btrfs_fs_info {
 	 */
 	struct ulist *qgroup_ulist;
 
-	/* protect user change for quota operations */
+	/*
+	 * Protect user change for quota operations. If a transaction is needed,
+	 * it must be started before locking this lock.
+	 */
 	struct mutex qgroup_ioctl_lock;
 
 	/* list of dirty qgroups to be written at next commit */
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 4720e477c482..2f119adbc808 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -886,6 +886,7 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info)
 	struct btrfs_key found_key;
 	struct btrfs_qgroup *qgroup = NULL;
 	struct btrfs_trans_handle *trans = NULL;
+	struct ulist *ulist = NULL;
 	int ret = 0;
 	int slot;
 
@@ -893,12 +894,27 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info)
 	if (fs_info->quota_root)
 		goto out;
 
-	fs_info->qgroup_ulist = ulist_alloc(GFP_KERNEL);
-	if (!fs_info->qgroup_ulist) {
+	ulist = ulist_alloc(GFP_KERNEL);
+	if (!ulist) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
+	/*
+	 * Unlock qgroup_ioctl_lock before starting the transaction. This is to
+	 * avoid lock acquisition inversion problems (reported by lockdep) between
+	 * qgroup_ioctl_lock and the vfs freeze semaphores, acquired when we
+	 * start a transaction.
+	 * After we started the transaction lock qgroup_ioctl_lock again and
+	 * check if someone else created the quota root in the meanwhile. If so,
+	 * just return success and release the transaction handle.
+	 *
+	 * Also we don't need to worry about someone else calling
+	 * btrfs_sysfs_add_qgroups() after we unlock and getting an error because
+	 * that function returns 0 (success) when the sysfs entries already exist.
+	 */
+	mutex_unlock(&fs_info->qgroup_ioctl_lock);
+
 	/*
 	 * 1 for quota root item
 	 * 1 for BTRFS_QGROUP_STATUS item
@@ -908,12 +924,20 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info)
 	 * would be a lot of overkill.
 	 */
 	trans = btrfs_start_transaction(tree_root, 2);
+
+	mutex_lock(&fs_info->qgroup_ioctl_lock);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
 		trans = NULL;
 		goto out;
 	}
 
+	if (fs_info->quota_root)
+		goto out;
+
+	fs_info->qgroup_ulist = ulist;
+	ulist = NULL;
+
 	/*
 	 * initially create the quota tree
 	 */
@@ -1046,10 +1070,13 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info)
 	if (ret) {
 		ulist_free(fs_info->qgroup_ulist);
 		fs_info->qgroup_ulist = NULL;
-		if (trans)
-			btrfs_end_transaction(trans);
 	}
 	mutex_unlock(&fs_info->qgroup_ioctl_lock);
+	if (ret && trans)
+		btrfs_end_transaction(trans);
+	else if (trans)
+		ret = btrfs_end_transaction(trans);
+	ulist_free(ulist);
 	return ret;
 }
 
@@ -1062,19 +1089,29 @@ int btrfs_quota_disable(struct btrfs_fs_info *fs_info)
 	mutex_lock(&fs_info->qgroup_ioctl_lock);
 	if (!fs_info->quota_root)
 		goto out;
+	mutex_unlock(&fs_info->qgroup_ioctl_lock);
 
 	/*
 	 * 1 For the root item
 	 *
 	 * We should also reserve enough items for the quota tree deletion in
 	 * btrfs_clean_quota_tree but this is not done.
+	 *
+	 * Also, we must always start a transaction without holding the mutex
+	 * qgroup_ioctl_lock, see btrfs_quota_enable().
 	 */
 	trans = btrfs_start_transaction(fs_info->tree_root, 1);
+
+	mutex_lock(&fs_info->qgroup_ioctl_lock);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
+		trans = NULL;
 		goto out;
 	}
 
+	if (!fs_info->quota_root)
+		goto out;
+
 	clear_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags);
 	btrfs_qgroup_wait_for_completion(fs_info, false);
 	spin_lock(&fs_info->qgroup_lock);
@@ -1088,13 +1125,13 @@ int btrfs_quota_disable(struct btrfs_fs_info *fs_info)
 	ret = btrfs_clean_quota_tree(trans, quota_root);
 	if (ret) {
 		btrfs_abort_transaction(trans, ret);
-		goto end_trans;
+		goto out;
 	}
 
 	ret = btrfs_del_root(trans, &quota_root->root_key);
 	if (ret) {
 		btrfs_abort_transaction(trans, ret);
-		goto end_trans;
+		goto out;
 	}
 
 	list_del(&quota_root->dirty_list);
@@ -1108,10 +1145,13 @@ int btrfs_quota_disable(struct btrfs_fs_info *fs_info)
 	free_extent_buffer(quota_root->commit_root);
 	kfree(quota_root);
 
-end_trans:
-	ret = btrfs_end_transaction(trans);
 out:
 	mutex_unlock(&fs_info->qgroup_ioctl_lock);
+	if (ret && trans)
+		btrfs_end_transaction(trans);
+	else if (trans)
+		ret = btrfs_end_transaction(trans);
+
 	return ret;
 }
 
-- 
2.31.1

