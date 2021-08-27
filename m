Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83B243FA190
	for <lists+stable@lfdr.de>; Sat, 28 Aug 2021 00:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232354AbhH0WkN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Aug 2021 18:40:13 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:1470 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232330AbhH0WkL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Aug 2021 18:40:11 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17RKcr5n002221;
        Fri, 27 Aug 2021 22:39:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=veuEXJg9l9whTgz+BUIczd5Wikxv/oq8AUbBElUNq5A=;
 b=eKKoYQKqoKydEHpNLRuIV1vmkwj4t0yl8hD+dEuErhH/0oaAiRuvwEPLgtgWqhltuvzu
 gY+CXbkNsWuHOhMvraab6/nTYteRLQC6TCSVjLkdDT1PUTIm6LYsli3A5bsrPxNzWddn
 1FAGW8PJur74YY/QQZHUH6rwu/u3O5MBrQ7pI6sTVeOL/L1D2Gml8bR9TZO0bhHKn9qh
 9c3dowQM6XxLPatazTz2+EkkmmGpVUB9kJpY8iv7Ortc3SF4KYPDKIPqSUGV2vlUQvQr
 t7mEWKXYsLhGsO+v9qceQX+hqsyyStPBPDxym+3yWTGAH0hl7c/Mf7Am+bsdZ0hi0RLw yw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=veuEXJg9l9whTgz+BUIczd5Wikxv/oq8AUbBElUNq5A=;
 b=j9Wt7j85ihw81cavY/iRTkHvmfwGAsNVxNoYvhFEhNg6KJaLpQeOx0V88Tu1i6VXXALD
 BCEaWLCxKEbcHmBo09tWXU6clsGWZwEenz3ij9WD7hY5QmjM581NfYviK4V8MqNuPJVb
 teQ8Fi7V3WYUaSIpqiDKQik79M8FbTrC+awKNfjbjb6GKK5iRlOObCyJ4TYuJk05vMPA
 t01Gq6KJNcVta3DqUgITh6+q9hiAjL429POSGsvP3Covf/CI0uuiN9WiVHZQuL1UOhjQ
 HC2d1eWD+zJURXNWiBVyx46pVGOJOKoJ/LbVGGcOjuACJvnJ+tLDb3k4ZaZdQ7ZyD0vW Hw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3apvjr1qym-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Aug 2021 22:39:15 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17RMZdO7025659;
        Fri, 27 Aug 2021 22:39:14 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2041.outbound.protection.outlook.com [104.47.73.41])
        by userp3020.oracle.com with ESMTP id 3akb92war8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Aug 2021 22:39:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AFYptlYr+YKM63kvOV4/y/pJXxDiRN2weUSSBXvVMDATGqhdycWfEf/jClxw9nugU6O5M276wUfFqKZkhMHb4zh/6P913xjVyN3cmoEBUM2PWu1MB5sAv9XNflVBdGYUHPmEBeqBsY9d4lSfqavhTWQktp8vPlTbtyQeov9lSU9dvrGhRDhI/AOQdYVcCvyESQmw4EGjI8zm74mQNYjCM5fr9bW8vsvlUMatTIVSY58J4TPAxPIRC+u2iy2RVDBc3Gre1YImx49KZzicfv09PDTJ22FQ7WEuq1h6hNLC5/kjJJNZN78UraTEXkBkdIFWTFWa43jFYJSV7ZPPtNJhzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=veuEXJg9l9whTgz+BUIczd5Wikxv/oq8AUbBElUNq5A=;
 b=LgB9pw4U6LBhWjyVEoEZGKVBL3ku36B/L3n2hInNk2iVeMD45cwGGu6ZkG00/vd+D3Oep/fH/N5T5keyIJCcorEOhC5+HUa2tiAX7vtD2GD2GySvLLagryuoc6F1RycmU8ljZKSbIRr6imWlsyrMlUm0L3W7049OmPG4RzodRzvgibX8qrmcCoXRbrNO5MKyfomJu2kSTKJ1MobvH6YUKAvmDqluRAb4UgGUR8e+bF4zusWka1nfpmEQEjiTGmVeUG3DyYPtem1IbL6w9yYSc0jX3KoFwqlQ3SdhvE5zY9MHa08UXkHm38qiPesPvw/XO5hHI0rnlSvr8BdkTrZWsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=veuEXJg9l9whTgz+BUIczd5Wikxv/oq8AUbBElUNq5A=;
 b=UAAzRZzSWd84Xe8UWgIugGCvD8uUXjbqzsW7LyLVchhlKPgKRTuioOuM4y/Xw7bCZgd4jKqDG1xMLrYhX9ghtAPLx26wHlYfWSbr46Trf0aFbwL/U4rKXaxNjwc8LiQ5jcXkgyqKuvhQ3X9DG9F0c+21aNSzqiLQNbPkryLGOSo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from MN2PR10MB4128.namprd10.prod.outlook.com (2603:10b6:208:1d2::24)
 by BL0PR10MB3426.namprd10.prod.outlook.com (2603:10b6:208:31::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.24; Fri, 27 Aug
 2021 22:39:12 +0000
Received: from MN2PR10MB4128.namprd10.prod.outlook.com
 ([fe80::b813:4805:31e:d36a]) by MN2PR10MB4128.namprd10.prod.outlook.com
 ([fe80::b813:4805:31e:d36a%5]) with mapi id 15.20.4436.024; Fri, 27 Aug 2021
 22:39:12 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH stable-5.4.y] btrfs: fix race between marking inode needs to be logged and log syncing
Date:   Sat, 28 Aug 2021 06:37:28 +0800
Message-Id: <2f474ee209a89b42c2471aab71a0df038f7e8d4c.1629969541.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0132.apcprd04.prod.outlook.com
 (2603:1096:3:16::16) To MN2PR10MB4128.namprd10.prod.outlook.com
 (2603:10b6:208:1d2::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (39.109.186.25) by SG2PR04CA0132.apcprd04.prod.outlook.com (2603:1096:3:16::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Fri, 27 Aug 2021 22:39:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 999484f7-b87e-4b49-7939-08d969ab7d65
X-MS-TrafficTypeDiagnostic: BL0PR10MB3426:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR10MB34261D98F4CA23A6A9DC082EE5C89@BL0PR10MB3426.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1443;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ywOujlHh01WKo7JGMufLMXQsfOe8biT4aZ6ygizqv+NDsB5jPZeCQoVj85AwITy+XS4bwEKBgH28qU2LiJwQJvm0xssGByMU8JA7WbMV/n4sXUShbrV7GtDuDukjC3Kmr/COXkHhd+t/p4smNP9VjwDgUodPjQQbqsMcvtCT2pehbsVUz8r1GoDlWsQr032iv4/LjRu0WJQNMMChhbHyQgR0/OrZDaLO2o+TLeP6GhNoCAyQMfMgNN0BoAlbIcBngyAOqKpUEGVzQCmcOVgf1bWKihw2le53neB5lphtTexqO5awhQBGDEx5bn5mK0fPHbb9NJmlyX6gA65CzVuFFP39Y+8JVOOdcMa5H1JxDddDyaroUXe2g7YtQltbOsrorF1jUmRfF3DUEJe8F/gEk1qKO67K6ia+de3r8qII/T7Q86oVIH7EikG9pidsZ7TVwJQ15v9hn8HlV1GsWqW6grMYMt5plxeF1ymS6aMqJs9u9YAkJ4g74zD5Cn29fFEkXgcrqg6W3xLI8UMWa4SRXaS7dfe4RkYvd1oDWulrGmu9ga0ZhXhuv48Q4EPdcIP4OV+4D+ZYc+CEeoOiCALFHK1jCN9nBdT0GKGNqcI7H7j/Vsx8pAnH537/86c+LSw1kLj/0nRPWw0e5Ei73BhlylSYPcs8DHqgp9NkesEHVQYWTDCOoG1zNpg9zO73oc82
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(136003)(396003)(376002)(39860400002)(6506007)(5660300002)(6486002)(107886003)(956004)(44832011)(8936002)(6512007)(2906002)(26005)(54906003)(4326008)(36756003)(316002)(66946007)(86362001)(6666004)(8676002)(38100700002)(52116002)(2616005)(186003)(83380400001)(478600001)(66476007)(66556008)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dR1yrh19tJXuiSdRzyqgHElQ8VU2abgok5GEmco+1JfjcNHVcoay3R/UKNmX?=
 =?us-ascii?Q?KyOQwXRN/lyKrBsytQeuCjDjEMS8OdGf4HOkHHSfhUh9TLXLOdCrDLY9wOjO?=
 =?us-ascii?Q?dgPZyFJkvKynaewqSU3u9qd6B/sC1sdBu8AR2mpFB4Zej/URC4ta4EI7VxUC?=
 =?us-ascii?Q?BMSgtNMM6HEF+2cMQWcvnFz63qCiuoAhrbnMfWOaooHyzzp974M2JulO2Y7p?=
 =?us-ascii?Q?p3DoP2QBxqRNRar2cyj/HA3e64nSW+0IQ+B07LDcQ/QaIMrSQzhAxMJ4jsfC?=
 =?us-ascii?Q?amkwWUIZ0vcUtR8D9Lun9J1jyfRux5zMWL1S7YzCiPlPGDbOf2sPlmpU6TE6?=
 =?us-ascii?Q?c3X9H8AvOvaA54dgqADas/YduIiyrdQ2/b9GLBuFFh9O/Q1CCM+HscvY48U3?=
 =?us-ascii?Q?tVMlfXeiNobtEzHhUBA/nP1ct1ayV9mNRtm0pB45XpHN5K+5Fg3ubgfej/M4?=
 =?us-ascii?Q?F9Xr1sIq0pPE5qCdvh6q5sIQ37Z8R1iszhfKRIkNIpd27FnpTdFTFAbMrwRE?=
 =?us-ascii?Q?/GmmJ5cULEih0ckUFhbBi5YfqEqesQkFNcRjhZADx6ToiM/y2mQHPCXnYheV?=
 =?us-ascii?Q?hGMrKkJhfB7wzv8SDeVl5bIjNEU1+TW4TweC5oO9JqqENIem/ja/ROR/1sJQ?=
 =?us-ascii?Q?nUGwsIQTr7SDY++PIzGug8QbMtHChVNStIz5K79zFQ39MhRSMeiMO1wRg0lM?=
 =?us-ascii?Q?rlwFl2xXRfRmFzObscGEInDSGvs0Oaks/iJkY4KC+aqm788aKP5qoUhxx1O0?=
 =?us-ascii?Q?q6f0Cx4d6iJA95fJUYxYnq88vjgIFGAa2QoWFf/G/LHrg/aJGzYXvT9EgN0f?=
 =?us-ascii?Q?1aFlEJ1adx9AAtBib/Xir/5ssVB1qp/idnmjX2UdHwa7iQt9AjpM8Kvz53EC?=
 =?us-ascii?Q?G6MyMW7teE7XI8MJDeyMhK2qpMauxwnq8+/+OrV3jDGbFvVP4gluq46JRuUZ?=
 =?us-ascii?Q?ooomluGibWOMChkYc1AVKC5+PrR6d3MygxBjlYN73EtM4VuTrjzmhYiPIrbp?=
 =?us-ascii?Q?CwkP1uGm5ktAzmVzgCcjVxTeLugdwfgglgw042C2nZw55xtPX1cKGJvEo3I0?=
 =?us-ascii?Q?6iCeo73VPrwqmkFVdsG7kHLj6XXENmfNQ29AjnPsk1W0ZGUS/LQepcg6/M4O?=
 =?us-ascii?Q?Wv7X7QGBu8YKrow5xyABBaMvy1dTer0CY5L1KMJlpdzFdpc00hsQAN2QWJ4Z?=
 =?us-ascii?Q?c5FwoPm4v+cYqIyqArAPg1iCgNwfZsmwyfX2rG1rFD2JdLSDI1Du0PtobzQX?=
 =?us-ascii?Q?gDTyNZZtDcWg1uGmAdynRm1fG0GpkdmJy/9MLJAx6fojBlWo8/6zAeiyJvlj?=
 =?us-ascii?Q?JthWnhhmGpCh8Mge422m1nt7?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 999484f7-b87e-4b49-7939-08d969ab7d65
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2021 22:39:11.9088
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YoJtkbPHDSZ2xQl8hrKKv7w4dmtdZM49Vps7RF0a7dMFXNeDHZVPBX1muHQgR2EDqCIrSrHK/5GBiRoyE0phlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB3426
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108270133
X-Proofpoint-GUID: Sh-iBYHtGM-IkHRTeCAdjeOJXG_s_KhA
X-Proofpoint-ORIG-GUID: Sh-iBYHtGM-IkHRTeCAdjeOJXG_s_KhA
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit bc0939fcfab0d7efb2ed12896b1af3d819954a14 upstream.

We have a race between marking that an inode needs to be logged, either
at btrfs_set_inode_last_trans() or at btrfs_page_mkwrite(), and between
btrfs_sync_log(). The following steps describe how the race happens.

1) We are at transaction N;

2) Inode I was previously fsynced in the current transaction so it has:

    inode->logged_trans set to N;

3) The inode's root currently has:

   root->log_transid set to 1
   root->last_log_commit set to 0

   Which means only one log transaction was committed to far, log
   transaction 0. When a log tree is created we set ->log_transid and
   ->last_log_commit of its parent root to 0 (at btrfs_add_log_tree());

4) One more range of pages is dirtied in inode I;

5) Some task A starts an fsync against some other inode J (same root), and
   so it joins log transaction 1.

   Before task A calls btrfs_sync_log()...

6) Task B starts an fsync against inode I, which currently has the full
   sync flag set, so it starts delalloc and waits for the ordered extent
   to complete before calling btrfs_inode_in_log() at btrfs_sync_file();

7) During ordered extent completion we have btrfs_update_inode() called
   against inode I, which in turn calls btrfs_set_inode_last_trans(),
   which does the following:

     spin_lock(&inode->lock);
     inode->last_trans = trans->transaction->transid;
     inode->last_sub_trans = inode->root->log_transid;
     inode->last_log_commit = inode->root->last_log_commit;
     spin_unlock(&inode->lock);

   So ->last_trans is set to N and ->last_sub_trans set to 1.
   But before setting ->last_log_commit...

8) Task A is at btrfs_sync_log():

   - it increments root->log_transid to 2
   - starts writeback for all log tree extent buffers
   - waits for the writeback to complete
   - writes the super blocks
   - updates root->last_log_commit to 1

   It's a lot of slow steps between updating root->log_transid and
   root->last_log_commit;

9) The task doing the ordered extent completion, currently at
   btrfs_set_inode_last_trans(), then finally runs:

     inode->last_log_commit = inode->root->last_log_commit;
     spin_unlock(&inode->lock);

   Which results in inode->last_log_commit being set to 1.
   The ordered extent completes;

10) Task B is resumed, and it calls btrfs_inode_in_log() which returns
    true because we have all the following conditions met:

    inode->logged_trans == N which matches fs_info->generation &&
    inode->last_subtrans (1) <= inode->last_log_commit (1) &&
    inode->last_subtrans (1) <= root->last_log_commit (1) &&
    list inode->extent_tree.modified_extents is empty

    And as a consequence we return without logging the inode, so the
    existing logged version of the inode does not point to the extent
    that was written after the previous fsync.

It should be impossible in practice for one task be able to do so much
progress in btrfs_sync_log() while another task is at
btrfs_set_inode_last_trans() right after it reads root->log_transid and
before it reads root->last_log_commit. Even if kernel preemption is enabled
we know the task at btrfs_set_inode_last_trans() can not be preempted
because it is holding the inode's spinlock.

However there is another place where we do the same without holding the
spinlock, which is in the memory mapped write path at:

  vm_fault_t btrfs_page_mkwrite(struct vm_fault *vmf)
  {
     (...)
     BTRFS_I(inode)->last_trans = fs_info->generation;
     BTRFS_I(inode)->last_sub_trans = BTRFS_I(inode)->root->log_transid;
     BTRFS_I(inode)->last_log_commit = BTRFS_I(inode)->root->last_log_commit;
     (...)

So with preemption happening after setting ->last_sub_trans and before
setting ->last_log_commit, it is less of a stretch to have another task
do enough progress at btrfs_sync_log() such that the task doing the memory
mapped write ends up with ->last_sub_trans and ->last_log_commit set to
the same value. It is still a big stretch to get there, as the task doing
btrfs_sync_log() has to start writeback, wait for its completion and write
the super blocks.

So fix this in two different ways:

1) For btrfs_set_inode_last_trans(), simply set ->last_log_commit to the
   value of ->last_sub_trans minus 1;

2) For btrfs_page_mkwrite() only set the inode's ->last_sub_trans, just
   like we do for buffered and direct writes at btrfs_file_write_iter(),
   which is all we need to make sure multiple writes and fsyncs to an
   inode in the same transaction never result in an fsync missing that
   the inode changed and needs to be logged. Turn this into a helper
   function and use it both at btrfs_page_mkwrite() and at
   btrfs_file_write_iter() - this also fixes the problem that at
   btrfs_page_mkwrite() we were setting those fields without the
   protection of the inode's spinlock.

This is an extremely unlikely race to happen in practice.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/btrfs_inode.h | 15 +++++++++++++++
 fs/btrfs/file.c        | 10 ++--------
 fs/btrfs/inode.c       |  4 +---
 fs/btrfs/transaction.h |  2 +-
 4 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index f853835c409c..f3ff57b93158 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -268,6 +268,21 @@ static inline void btrfs_mod_outstanding_extents(struct btrfs_inode *inode,
 						  mod);
 }
 
+/*
+ * Called every time after doing a buffered, direct IO or memory mapped write.
+ *
+ * This is to ensure that if we write to a file that was previously fsynced in
+ * the current transaction, then try to fsync it again in the same transaction,
+ * we will know that there were changes in the file and that it needs to be
+ * logged.
+ */
+static inline void btrfs_set_inode_last_sub_trans(struct btrfs_inode *inode)
+{
+	spin_lock(&inode->lock);
+	inode->last_sub_trans = inode->root->log_transid;
+	spin_unlock(&inode->lock);
+}
+
 static inline int btrfs_inode_in_log(struct btrfs_inode *inode, u64 generation)
 {
 	int ret = 0;
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 400b0717b9d4..1279359ed172 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2004,14 +2004,8 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
 
 	inode_unlock(inode);
 
-	/*
-	 * We also have to set last_sub_trans to the current log transid,
-	 * otherwise subsequent syncs to a file that's been synced in this
-	 * transaction will appear to have already occurred.
-	 */
-	spin_lock(&BTRFS_I(inode)->lock);
-	BTRFS_I(inode)->last_sub_trans = root->log_transid;
-	spin_unlock(&BTRFS_I(inode)->lock);
+	btrfs_set_inode_last_sub_trans(BTRFS_I(inode));
+
 	if (num_written > 0)
 		num_written = generic_write_sync(iocb, num_written);
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b044b1d910de..1117335374ff 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9250,9 +9250,7 @@ vm_fault_t btrfs_page_mkwrite(struct vm_fault *vmf)
 	set_page_dirty(page);
 	SetPageUptodate(page);
 
-	BTRFS_I(inode)->last_trans = fs_info->generation;
-	BTRFS_I(inode)->last_sub_trans = BTRFS_I(inode)->root->log_transid;
-	BTRFS_I(inode)->last_log_commit = BTRFS_I(inode)->root->last_log_commit;
+	btrfs_set_inode_last_sub_trans(BTRFS_I(inode));
 
 	unlock_extent_cached(io_tree, page_start, page_end, &cached_state);
 
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index d8a7d460e436..cbede328bda5 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -160,7 +160,7 @@ static inline void btrfs_set_inode_last_trans(struct btrfs_trans_handle *trans,
 	spin_lock(&BTRFS_I(inode)->lock);
 	BTRFS_I(inode)->last_trans = trans->transaction->transid;
 	BTRFS_I(inode)->last_sub_trans = BTRFS_I(inode)->root->log_transid;
-	BTRFS_I(inode)->last_log_commit = BTRFS_I(inode)->root->last_log_commit;
+	BTRFS_I(inode)->last_log_commit = BTRFS_I(inode)->last_sub_trans - 1;
 	spin_unlock(&BTRFS_I(inode)->lock);
 }
 
-- 
2.31.1

