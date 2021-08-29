Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 355DC3FAEC4
	for <lists+stable@lfdr.de>; Sun, 29 Aug 2021 23:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236080AbhH2Vnc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Aug 2021 17:43:32 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:57656 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232450AbhH2Vnb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Aug 2021 17:43:31 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17TEN1LP008050;
        Sun, 29 Aug 2021 21:42:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=aNh356srCatNTJiAZz4WImfguPFczGLd7fXLl/m2nlA=;
 b=Yao7Ed06DNUwDlLBxIEEmJseNNjKGSXz3ps7H0LofFUxF0j5Lr1KS+2/2vrUsnQXUmoG
 D2nY2hKoHLzCsTenLD/KsdYl9ai6GIpNQ9RVjXBjo7JGSo8VP3CDuxh7khDRTMBajhW5
 s6Bp0q9mH7nD4BucPDUqyCDzaNV9WSMCC5+m9cYHvT0Un0DOdZUsprN/1Y0fk18B+Q2B
 p6PNmdxLGTHpnmNbD7dYHqdiudCrNu6auGAxzGGKrKghDs1KEsbdUOZAnVH7G6R9kZAr
 3/BxN2rzSYMV5SZRd7Ldi1vAQ0q05rL9KFtE84PEdXYyBJdeWmZzql33jcyqRsisiHvD DQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=aNh356srCatNTJiAZz4WImfguPFczGLd7fXLl/m2nlA=;
 b=wMuNPIkpDPIR/7h7uD9O8XbAACoYShfnACJ+rVIqVK35Lqa6JK1s60m4mAYayjkhblC8
 AtKHTAmF0CobBR2WozyQDylFpaz3jE1KnlSBtDttlOaKuhctnDEMC4L20++fBh9vykXT
 jxfQVbRX/QB1dpBzVobGIbEX0i+5Gip8DXXSPzQhmNbb5awdbRIMJbjGXM5iyiNjnAlH
 kC1NFeiZ8mwhXAjNS3IvV6XDgoTifynRE0vlxXerMMbM0rmj5I9UKmYcQUyzO9bGsgdK
 DLE+4ZW93xvOnlMm/q6hBxvI/zhnaf4FUKwFnDwYbu595mXW0PRTfO3MXCbXIo6on4Gu JA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3arbxwg7n6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 29 Aug 2021 21:42:36 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17TLfenh189871;
        Sun, 29 Aug 2021 21:42:35 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by aserp3030.oracle.com with ESMTP id 3aqb6axajq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 29 Aug 2021 21:42:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PkID7zppmVU5sL5wgT96pqd83sj5h/wWvGEqNBIFnIu1h9Lgswb7k6hGFb9XcvnpIAiDc+X+zANQy4XnTgyJcjbXIxlQ+vSIPJCLUGISV+bs2t4aydibV0b3ILlE27jogZ7W75lPrB3H9EqgTgvtqfoTxDMMxfclBhOkIUiR3UovLgICKnIYSfenXHFs/kDLg/xjDMfEVPRzRbcokfFCfy8QZALCTPbjQVn76kD6K+r+zkxxycYOswrMZE/zrNX98Jf3y8vu6AZEZ2+NUDYPKstsrqYZwjRY3g4X8QsxCsuMxB/7aBlQnSqk4h6zIMtY84Z7t/U0X7aCWXQb3dPupQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aNh356srCatNTJiAZz4WImfguPFczGLd7fXLl/m2nlA=;
 b=TI7pqLrTCy/oWwTM4dSLA53Phpeuy/CeHDGuSC4gG4kXWKEzA7Ezx7raYqIdxXdrlfmwCS/Wd3zhaJM5rL/vM4myNwp2CZWqxZXo57W7qrnbfFNI9g1BNTY4WzfjlsPyjZuJ+LOf0Pb/jYSpuK23DcF0hpIyU6ekSbGHT7qGZn3Pdq4QaNLXEzoS8Ccd0rdcZ9ryQkTrrIkRRha1GMFdovliyGFo9AQqJRhgW4vKUlGL7AOlMz7MBPbugioKyKc+xtyZfB66Si/Q8UsbmonL17zTFnQ682xhdLYttFpjpZ2cwJIYZie7ORlSCl+vFtWlq45CEK+Qc//ddP0eiCuPqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aNh356srCatNTJiAZz4WImfguPFczGLd7fXLl/m2nlA=;
 b=EnE4O89lirxyCQyciHfZnIBp1UMoNw31TWeTFUWaM3XdW6xEyX6iQBjJZMjlYEHnBpB3rrCqbk9++X1SIX0tu5RFb+T84lnbHGxdKNTLa/zgja6z2G6q4rS1G+dtcPdH/htEuBBvV6ciszyDwjQF5LfD2BM/2mTg3W5N9+a7vnE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from MN2PR10MB4128.namprd10.prod.outlook.com (2603:10b6:208:1d2::24)
 by BLAPR10MB5139.namprd10.prod.outlook.com (2603:10b6:208:307::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Sun, 29 Aug
 2021 21:42:33 +0000
Received: from MN2PR10MB4128.namprd10.prod.outlook.com
 ([fe80::b813:4805:31e:d36a]) by MN2PR10MB4128.namprd10.prod.outlook.com
 ([fe80::b813:4805:31e:d36a%5]) with mapi id 15.20.4436.024; Sun, 29 Aug 2021
 21:42:33 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH stable-5.9.y, stable-5.10.y] btrfs: fix race between marking inode needs to be logged and log syncing
Date:   Mon, 30 Aug 2021 05:42:17 +0800
Message-Id: <7701f6238b7a6905164fa85d343d6328554414ea.1630270929.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <2f474ee209a89b42c2471aab71a0df038f7e8d4c.1629969541.git.anand.jain@oracle.com>
References: <2f474ee209a89b42c2471aab71a0df038f7e8d4c.1629969541.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR0302CA0021.apcprd03.prod.outlook.com
 (2603:1096:3:2::31) To MN2PR10MB4128.namprd10.prod.outlook.com
 (2603:10b6:208:1d2::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (39.109.186.25) by SG2PR0302CA0021.apcprd03.prod.outlook.com (2603:1096:3:2::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.6 via Frontend Transport; Sun, 29 Aug 2021 21:42:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e2bbb4d5-a2c2-4068-71cb-08d96b35e877
X-MS-TrafficTypeDiagnostic: BLAPR10MB5139:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BLAPR10MB5139050F9ABE56940544BB50E5CA9@BLAPR10MB5139.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CW/74YgbTWwGXeoofWT4jPTYJB2LRUOdhzNv0Nbdpx42wnxm07hpHSO4VK/L2H9cgLbBmqEfUqNw03gH7Y9aAKjt8zDsMlhyRGWgp369lGqMlR64Jym8X6hx9e25ZAm4OTW3q4NVYC819PKf6rXj9KjxG/cx666DlCBrfdz0ZHHPYNKPPHV+NUk+MGvBn08Op+dogA8E0uuajIZTsd7wPzkMOn3oGQeB1uafiy/Ftto3tzPyBKDvT9nqDn1i4Pdlu3Chifb0wlcV6frpjHXepEf9DV1QHjAxrkv32RtL1J7aEdemO2njpBexRv28C4Mv0Hc/D0pVTe8dwthTKxrASzxwFdcVOlnmJDxkO6k3Mmo/hP1IprTzBsu71NJRsxbxf88oLWRg5Y4QU4vpoHy+aHKC9qP4jYMK7mNLuGDNaLyFxhNNmaPZqJsMMo8Eiri/ASq+eqAvffcuSdwmhZnI3nsVANqXkpXK3+NH4aFuBgvzYggXPZ1m9+nyAyFArDdkOTfUTKzahmE2emUrP5ZVh14Rx8F0wR8wiTnbJc7xAmHhzEaE+fTqxVc/POUyP0XrKwK/AfwLzudDPH1fxtbNM11t611akuvW6Y7QuBSAalmvgoeLrI2pvQmu0mv/Q2g/8Cau9ONOrW/b9VPv4A1qAbA8ylznRwxoCuICNM7Kee0pRhAsae/wKXuD2AIjFkYPMSssrtVL81AbVUdpgmwW8Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(136003)(39860400002)(376002)(346002)(86362001)(2906002)(54906003)(107886003)(478600001)(6486002)(83380400001)(316002)(36756003)(8676002)(4326008)(66556008)(66476007)(6512007)(2616005)(956004)(5660300002)(26005)(8936002)(38100700002)(6506007)(6666004)(66946007)(38350700002)(52116002)(186003)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PCpHkb9HhzpA2u0rsmA9BQWsiKDhi+C+Wk0TwsiidIY4JwjaUuwJejCCg015?=
 =?us-ascii?Q?TaTvSrfgGQdHxtGFNjaCWpbOG9fHcywnxR0Bj7/Fl5aFzJydnZW6L3whxp9B?=
 =?us-ascii?Q?Ckg7KGAYl2oUpMzUvkAkXeYhaxkPsHcTIAuuG8N0mV1FZvA5kBPbMA2U0Vb9?=
 =?us-ascii?Q?isesutLi/AbOtWsbTuyaDbM3FLgw7GKHj53CppORmgyx/LNlsHtRWCjV0rwG?=
 =?us-ascii?Q?EeHOsIIFsY3IYq72MpIaw04X7Xq2AHhwbkaIl+7txhkL1rGZAB8NdhEtqpqY?=
 =?us-ascii?Q?UykB8g5qbY83pNqULjqIzuRcpWwKKzylUT8HRNnr21wd1abrbGSFGqVZiMjJ?=
 =?us-ascii?Q?xUKKlt2DDMvPHEhqHoZQ2UGP+8WP7MwjqjB38HbSc4g8yec3zMUtLFOypurD?=
 =?us-ascii?Q?rTzof990FNjTXJ8WEHlCXwIk3PBkkbkLl3nkg6eDkewB/CSrAprHUlmVlu17?=
 =?us-ascii?Q?XBUljJGZKlw7HKGr7OpYetZUrn9lH4oTyhEubtUdrp/bKoVKzyVxlYxHuMee?=
 =?us-ascii?Q?L0Gxk8MyATuRgHgBWLZev0eaqBPESsEgjEKdrBtUO2dCK45/HWF7acj6LGTH?=
 =?us-ascii?Q?SafPI5NyD8dK8CmbRGlz1fC5IMPzqyHtjCrwf8eCxE0PvlSZxl6XpY80sXYS?=
 =?us-ascii?Q?hcm5MsGJjesLoaobO9F73o4hoSWsxapsN0lJjORb8j1rQgFWt6Pz/aHbIy0i?=
 =?us-ascii?Q?m9fnnoQ+wftGPp4O99WkWFdRfGrUTOFkDoTFk+DZ3WGVcG5ZQQRnQvwWIggC?=
 =?us-ascii?Q?6CjxPYmjjPFM5Lc2jXtoMhbnNwpXb3leudtBavLNqyJXjg0jHiZEISLtspe8?=
 =?us-ascii?Q?P0pdhv3ZP9V5PetnD4f1EHPRUfjoAeTVl7pRc8S8C058WHFP6g+bJVsQrOmM?=
 =?us-ascii?Q?joLnk60oIkwn2Q5askvzlPWTjBZ/26AmrniOCGqX3qlsmv0f4x3i8CaUUAU0?=
 =?us-ascii?Q?VdyCGQolmSCIpCrr+RaUnqpgRRDMHPC12MKTrnUSQIf3OWUr+OTIk/C097ZF?=
 =?us-ascii?Q?1y7Us7FcOzjGZwClafgsDCsXYtPd+AEC1dmcpOPc8XLR5DVdFJYDm6OFXjCX?=
 =?us-ascii?Q?+aAgSxoqspwF+t76pPflKs0nTeNXud9YIA8sUCE/Zr4bftsSUNmoue2Zqc8T?=
 =?us-ascii?Q?qBsDPywQR1Elhi6ckmbBoO/ynR1nPg+bTbsKt0Isd+e0y1wPLZGXthOqBdJX?=
 =?us-ascii?Q?HkQxRVlp8m5/fS+QfsWPcL1agojRgdfk+matqsfcp/QZzj9uXzRUgU6OPOYu?=
 =?us-ascii?Q?oMe2Tg+AFX9u9CDCAdSf5iAcBmqhjcFBwDjl/+b7QQtAErPWOLqkpNvfoXJI?=
 =?us-ascii?Q?FSWysZ0GXxizmaYizv58MXWD?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2bbb4d5-a2c2-4068-71cb-08d96b35e877
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2021 21:42:33.0382
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EkTcjxjhNsn3X4Dfa/zn2D8yQqvacUzSI5K59tNqOBwmkJ0GHkZZB9jhxYusYQ5qpMI7lj+RZp+CF6knymP8TQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5139
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10091 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108290139
X-Proofpoint-ORIG-GUID: PXiBxnDBTnWOXO40-E6-5jfub8CQY2Ew
X-Proofpoint-GUID: PXiBxnDBTnWOXO40-E6-5jfub8CQY2Ew
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
 fs/btrfs/file.c        | 11 ++---------
 fs/btrfs/inode.c       |  4 +---
 fs/btrfs/transaction.h |  2 +-
 4 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 8de4bf8edb9c..5a43f8e07122 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -308,6 +308,21 @@ static inline void btrfs_mod_outstanding_extents(struct btrfs_inode *inode,
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
index ffa48ac98d1e..6ab91661cd26 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1862,7 +1862,6 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file_inode(file);
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
-	struct btrfs_root *root = BTRFS_I(inode)->root;
 	u64 start_pos;
 	u64 end_pos;
 	ssize_t num_written = 0;
@@ -2006,14 +2005,8 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
 
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
index fc4311415fc6..987afe4f7bb6 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8449,9 +8449,7 @@ vm_fault_t btrfs_page_mkwrite(struct vm_fault *vmf)
 	set_page_dirty(page);
 	SetPageUptodate(page);
 
-	BTRFS_I(inode)->last_trans = fs_info->generation;
-	BTRFS_I(inode)->last_sub_trans = BTRFS_I(inode)->root->log_transid;
-	BTRFS_I(inode)->last_log_commit = BTRFS_I(inode)->root->last_log_commit;
+	btrfs_set_inode_last_sub_trans(BTRFS_I(inode));
 
 	unlock_extent_cached(io_tree, page_start, page_end, &cached_state);
 
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 858d9153a1cd..f73654d93fa0 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -171,7 +171,7 @@ static inline void btrfs_set_inode_last_trans(struct btrfs_trans_handle *trans,
 	spin_lock(&inode->lock);
 	inode->last_trans = trans->transaction->transid;
 	inode->last_sub_trans = inode->root->log_transid;
-	inode->last_log_commit = inode->root->last_log_commit;
+	inode->last_log_commit = inode->last_sub_trans - 1;
 	spin_unlock(&inode->lock);
 }
 
-- 
2.31.1

