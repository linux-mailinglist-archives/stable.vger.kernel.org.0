Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3F313EB513
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 14:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240354AbhHMMNZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 08:13:25 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:24646 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240330AbhHMMNX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Aug 2021 08:13:23 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17DC6C8h020307;
        Fri, 13 Aug 2021 12:12:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=lvXMEPj2paTkuoqhJOSwBXNwDz5KZgoiTCyk1Wr1xLg=;
 b=wYVOTcE0SONJ89nPW+MYCf7TtujGOIhYzmZJsfOePfCZTKNjVjsXVaoIZVEYGxWB2WuS
 l0PP4hZ9U+FAJ61Dx0etZElizQFcTwrJ1p6BPiJLiZJ1622oSeRZivyZZBtzTiHrj7nf
 O7b626Du7cMCIms+btyhQfZsaNQlyJFKmt+fg83nJ1U5ROdb76L56XcqmwFwev2y7Ezk
 zE4yNYNPLyrR/fI1/mAoseOtuTdLgYNzj6QM9f0gThYxBCUBCPscKTPC5UFLKzhGxLPt
 zw/yj0LhMe5DamaC90NUc6A+jMWIZCI49fl+PoPK7eLiNj4UB1syBjkpAqq4/g/tNCY2 7Q== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=lvXMEPj2paTkuoqhJOSwBXNwDz5KZgoiTCyk1Wr1xLg=;
 b=N1RKhXRPAkTC+Cq3FtrZWFeMWaWhvKXjs8aFSKMTml8e8I6wltmqMur4WqTQMACBbgjv
 yGjyRItFKI1vajU54DjcZQIIJtAMdUeIpgBMj3O2vdYhwadCsyWlk3xHntiXCLkiwDyb
 SAeAoeTwe6n6rIxcNg0WrBJSIGVg9F+vnyP0w87FxHSpAn4Quwnp5ZWtEJoz4vASeV7G
 enjX3pVpMg1G64i7k0rGCrYfPCDPTJ8XneHn3Fsy0rHhcALfS58rBE8LmORu26I22fCV
 N1G3r3aXasQdZSWU1+CtTAwuMtuUZh+zj+LcxVQvNB2z6pSikBV+ZZHieTS71OgtdIVk bg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ad2ajjpra-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 12:12:52 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17DCAKjt066661;
        Fri, 13 Aug 2021 12:12:51 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by userp3030.oracle.com with ESMTP id 3abjwagpqx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 12:12:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kUdoLyZbScFAYrx1do3N5PhseLu7g0TeU42Q5hqVcDzdV5qNqk40kprHrNS9tBDIQoKx42DiDw/Tx6WjXl6FmGHvapzDXfS6VzhXSQ9RseOAeM6f2ZE5JQC0Obc/AMjDxoOVQyneiHpYdvMzxzRQGF9IHePqXjmHAfJpLRcbF98UL2lSpsLt5E87y6D3Bdv1m6zrtp0hit3vbGL8sERPNwVLXXWf48oVU6HA7hglHT7pVOITt1A1YAlpqPLWCW+O911pf1tCFN81yEGvN9ZVdyvy4DaevWakkiU0OnJFx9uhC5LXfu3vebddWHTZWwtz+M8xno9eQYUciQTpWVyldw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lvXMEPj2paTkuoqhJOSwBXNwDz5KZgoiTCyk1Wr1xLg=;
 b=Hpjoj/CvSKWj76N0me404/a4MSHCGscEpEU8ch4ou5HzX7XePbnZb3x6h/6HhZIxMQ0HYnRhXpP2f0mje9HpFErUeHVCCgg4T+04pRuUnT8ss5SnzY5Mim8x6FGpd9pCAilK6eZmCT5vbypnC2Mi3x0Xz4kqOcBoduzL6uLz3Q7aVlDxyx2DWbJbfHZiYvv9EPkeZzF7xLh27Magt62S4+dTTbdcVFFXWJ1mJJv6XxsVrO2xUuZZyE4HQnWzHGThL8W5QGw0Od7ZDQKLe35aYrLt5SIFZ1ateKZMmIFsXs0E3zkLoSOWWod8U/jtRu0tk7cuzCQo3BiKjQT8jPhXUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lvXMEPj2paTkuoqhJOSwBXNwDz5KZgoiTCyk1Wr1xLg=;
 b=pUfAKUVtVGPsN+zWaFauPTw4qzlE74xmuA0nLRPgTwEj3qR0KRiXPmg6GUuWi/j/2lOVFuj1AQzOA0VpGk2qlGyhYG3beptx8OQt6Wr+fiaH174Pt/mTDYcoA3IJwRW+rJjrHJRlMaAhhTBmxPERwGtRReTTg92GNmn2gM4uvdM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from MN2PR10MB4128.namprd10.prod.outlook.com (2603:10b6:208:1d2::24)
 by MN2PR10MB3837.namprd10.prod.outlook.com (2603:10b6:208:183::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16; Fri, 13 Aug
 2021 12:12:48 +0000
Received: from MN2PR10MB4128.namprd10.prod.outlook.com
 ([fe80::b813:4805:31e:d36a]) by MN2PR10MB4128.namprd10.prod.outlook.com
 ([fe80::b813:4805:31e:d36a%5]) with mapi id 15.20.4415.019; Fri, 13 Aug 2021
 12:12:48 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, fdmanana@suse.com,
        Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 3/3] btrfs: don't flush from btrfs_delayed_inode_reserve_metadata
Date:   Fri, 13 Aug 2021 20:12:25 +0800
Message-Id: <67b189dab7575f9edbc41caa4118ee68856a56a2.1628854236.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1628854236.git.anand.jain@oracle.com>
References: <cover.1628854236.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0155.apcprd04.prod.outlook.com (2603:1096:4::17)
 To MN2PR10MB4128.namprd10.prod.outlook.com (2603:10b6:208:1d2::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (39.109.186.25) by SG2PR04CA0155.apcprd04.prod.outlook.com (2603:1096:4::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17 via Frontend Transport; Fri, 13 Aug 2021 12:12:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fb33a27a-2d30-4e4a-e619-08d95e53aa5a
X-MS-TrafficTypeDiagnostic: MN2PR10MB3837:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR10MB3837E8061FAE8766231BCFFAE5FA9@MN2PR10MB3837.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ceUe5a7VU+hURZ8jBo2U33+8n4eP0CeGAtmh6l1HfcondWg2yajAMRO1OlOK2OOZdqPTmsX7BmuKEkVeUvqPmb7WzMTDEM9PedeAjZia1pOrrvuAl+k0uRIbnQd3HW3T4QSCIs+IamCNOiHQxygmtTM8RJmH/5W4g5WGpStnF8UHVFYIQT2dGiBqoOszC84+RXvlk6DkO6Qte5+xFbRD0HQwXLXhLl/BZBOP03FjIrSm+aMqK9fcDofEVJ83nnFEXJn21Anh4G3OvVwpLBpcHATaB+wKPaJTNKGVSqrwm+7RqGuKsX9vvbfgx6uH2fRA0QnpdctJEV4O5buFdRPC23CV7IN6P+i0zQLJd21ja+iyXgvELSabHaF1PEoOVFDRwGfKjXJUL0p2m7FnueRRUNm/Tgt9AebY6iRmoOxQSNnXbm9g4IvIWQeibJ46IhEXlWpHHw083gxoyqgSo0ZfmyoHZqc5OBbWC+nq9nATdiLXB1CIHeeRlyWTH7isHAwbrVndP6fPx0dUY1h5Z2t9Q6uR9g5+6YToKQzsohiBjlP6mvedrk7JBIDfSmLXfCdrZY2/KsKA3vlseCSCNDImYuP8h1C6irOPth2z3PU9QAoQbID6tadUj661xMtBXvDtcN9rScbJ+U/9bxvVIm2MUfbfvO+d2lwYFBgSrIUqL17j6OCCAW8VT7xbdqGfTK7D5h/Mb/Z5Epmxb0LWvKdyOQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(346002)(136003)(366004)(39860400002)(54906003)(8936002)(478600001)(38100700002)(2616005)(956004)(38350700002)(107886003)(44832011)(52116002)(2906002)(316002)(5660300002)(8676002)(6666004)(26005)(6506007)(186003)(36756003)(83380400001)(66476007)(66556008)(6512007)(6486002)(66946007)(86362001)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rX3fPKdXU1EaJ6yGvau+JB2a+AkKCyiNB7kHxpV3kZI3Ze0DB4pUfQiYAnlD?=
 =?us-ascii?Q?BIQTC7B3qROuHjIUQN9SSlGEZaCr1bVtte/WrSnzTzR9fz8yO8E0zsMeG13b?=
 =?us-ascii?Q?jHylQrdCzSNhHUq+xw8CfJBbGMULWLAyXWotbJG5dk+K1nTPrcrbzJ4brZWs?=
 =?us-ascii?Q?agC4RPlwvojIuyF4AzPv8SibSQulX8kWMKE9xKiUOA2QNcSHOZlRju8xB5AS?=
 =?us-ascii?Q?Ov4oRfWRZoGFEp+Q4xILATMz4lWMKxESp8dz0t0J5sWGhzYsPnvZWQ1ZQzsj?=
 =?us-ascii?Q?glsxU3SBXwZBDs3ccD900V+hP2ToN142DmL22kHnifKr8GTystZTZ9aFGo3I?=
 =?us-ascii?Q?yHY0H5AbO/Tj0AdSN7zY4zYxF0peJozUPDbh16cE0w35Vai2i9NTO+lHpF5N?=
 =?us-ascii?Q?3BOqZ0gqJgDYob3qgLFNppBGddSoTtfT2W+J1S12+ZKPwarmpbFIV8HwopQm?=
 =?us-ascii?Q?x9G+q7e5CHbgH2dGZskk3atNLQCDXMPHB+eDH+kgJ7wDXQNC9oLOFGjkzf0j?=
 =?us-ascii?Q?HRDWgwW+XNTXED1Rddx8fnp01Zo4EG2MFgUuNJq9jX3QTF1+rYLwqJMwrLKj?=
 =?us-ascii?Q?fIktAlY6P51xcWXHkiZL5KkJsbvz42WYJfVu8jW/ltdt5L/mHwotpiMQKN25?=
 =?us-ascii?Q?vigj2xvc9B3gE6hc9KAvI5Hf8+z0sfJGKH4krNCyj8vfKqcZSdLLHP3/mOp0?=
 =?us-ascii?Q?i5jUlP0u3+0YKo04JNHnxTkxZdHk5m4U/9a0AqfTrgRMAgiSL2H4bJd2oDHa?=
 =?us-ascii?Q?EJKAjGD+9bQjEj8h88jYkLlShpvpytyu5dh1yRc4hTYSAiwvIOJvz0MQMTT5?=
 =?us-ascii?Q?SXJOPucwGjjJ8wo/vf0NncXXoQou1m8QHFlVjzem/QL0WWNDzbUbbB+Py76Z?=
 =?us-ascii?Q?CuxjYd4bKYvZEVbern/wZOU/FNi5cPJv4FfVgz0GY1H1kOjZP6W9mg+k5QRh?=
 =?us-ascii?Q?o5Izn+zfmsSHrVj1NsWfHXXymklAFuTkUUSS3+5a7a/vOLjlCnvMQKQxrRNK?=
 =?us-ascii?Q?ovbib+3rkqHyxv64m3Ysb5O8TTd9hqYAVWMfgJClRLPIc3h9RUHd2XMMat6B?=
 =?us-ascii?Q?8LpJhib2pKaDIX2vvgNKexMqLLNqRaCv/+fLdrDS51uOdVyXcXwgZVCEyWsM?=
 =?us-ascii?Q?YKDIAVn5jXKH2lxUsYtM+16dtAc55KkETDVYXRJZCl8pOkFkFT3+iGjX7Xao?=
 =?us-ascii?Q?EUa+36Vf9ed7NNxydXnfL9m9diMNr4HoKq5QS4tXo0DS9sdcO0VkIdM2HpIi?=
 =?us-ascii?Q?X0/UZI9Xy9050tBxexvPHW16oB4NgdrGMUdJircrVSdBPUO+V2pr+Sq/k/FG?=
 =?us-ascii?Q?bvQts++WU77ZzTdV8PuR8TRB?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb33a27a-2d30-4e4a-e619-08d95e53aa5a
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2021 12:12:48.6471
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kyNrSvfWa8hBuYzHZ+Q3nUobfgQP9RcjoX4aF6KAvhfEMlC5XMLp/QYskp5Cj5i8EdRg2Z3Ppw8PRJD6SO4HsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3837
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10074 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 bulkscore=0 suspectscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108130074
X-Proofpoint-ORIG-GUID: TrUWmagXoKfUdQdxMLk2uwUlaRrC0de0
X-Proofpoint-GUID: TrUWmagXoKfUdQdxMLk2uwUlaRrC0de0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikolay Borisov <nborisov@suse.com>

commit 4d14c5cde5c268a2bc26addecf09489cb953ef64 upstream

Calling btrfs_qgroup_reserve_meta_prealloc from
btrfs_delayed_inode_reserve_metadata can result in flushing delalloc
while holding a transaction and delayed node locks. This is deadlock
prone. In the past multiple commits:

 * ae5e070eaca9 ("btrfs: qgroup: don't try to wait flushing if we're
already holding a transaction")

 * 6f23277a49e6 ("btrfs: qgroup: don't commit transaction when we already
 hold the handle")

Tried to solve various aspects of this but this was always a
whack-a-mole game. Unfortunately those 2 fixes don't solve a deadlock
scenario involving btrfs_delayed_node::mutex. Namely, one thread
can call btrfs_dirty_inode as a result of reading a file and modifying
its atime:

  PID: 6963   TASK: ffff8c7f3f94c000  CPU: 2   COMMAND: "test"
  #0  __schedule at ffffffffa529e07d
  #1  schedule at ffffffffa529e4ff
  #2  schedule_timeout at ffffffffa52a1bdd
  #3  wait_for_completion at ffffffffa529eeea             <-- sleeps with delayed node mutex held
  #4  start_delalloc_inodes at ffffffffc0380db5
  #5  btrfs_start_delalloc_snapshot at ffffffffc0393836
  #6  try_flush_qgroup at ffffffffc03f04b2
  #7  __btrfs_qgroup_reserve_meta at ffffffffc03f5bb6     <-- tries to reserve space and starts delalloc inodes.
  #8  btrfs_delayed_update_inode at ffffffffc03e31aa      <-- acquires delayed node mutex
  #9  btrfs_update_inode at ffffffffc0385ba8
 #10  btrfs_dirty_inode at ffffffffc038627b               <-- TRANSACTIION OPENED
 #11  touch_atime at ffffffffa4cf0000
 #12  generic_file_read_iter at ffffffffa4c1f123
 #13  new_sync_read at ffffffffa4ccdc8a
 #14  vfs_read at ffffffffa4cd0849
 #15  ksys_read at ffffffffa4cd0bd1
 #16  do_syscall_64 at ffffffffa4a052eb
 #17  entry_SYSCALL_64_after_hwframe at ffffffffa540008c

This will cause an asynchronous work to flush the delalloc inodes to
happen which can try to acquire the same delayed_node mutex:

  PID: 455    TASK: ffff8c8085fa4000  CPU: 5   COMMAND: "kworker/u16:30"
  #0  __schedule at ffffffffa529e07d
  #1  schedule at ffffffffa529e4ff
  #2  schedule_preempt_disabled at ffffffffa529e80a
  #3  __mutex_lock at ffffffffa529fdcb                    <-- goes to sleep, never wakes up.
  #4  btrfs_delayed_update_inode at ffffffffc03e3143      <-- tries to acquire the mutex
  #5  btrfs_update_inode at ffffffffc0385ba8              <-- this is the same inode that pid 6963 is holding
  #6  cow_file_range_inline.constprop.78 at ffffffffc0386be7
  #7  cow_file_range at ffffffffc03879c1
  #8  btrfs_run_delalloc_range at ffffffffc038894c
  #9  writepage_delalloc at ffffffffc03a3c8f
 #10  __extent_writepage at ffffffffc03a4c01
 #11  extent_write_cache_pages at ffffffffc03a500b
 #12  extent_writepages at ffffffffc03a6de2
 #13  do_writepages at ffffffffa4c277eb
 #14  __filemap_fdatawrite_range at ffffffffa4c1e5bb
 #15  btrfs_run_delalloc_work at ffffffffc0380987         <-- starts running delayed nodes
 #16  normal_work_helper at ffffffffc03b706c
 #17  process_one_work at ffffffffa4aba4e4
 #18  worker_thread at ffffffffa4aba6fd
 #19  kthread at ffffffffa4ac0a3d
 #20  ret_from_fork at ffffffffa54001ff

To fully address those cases the complete fix is to never issue any
flushing while holding the transaction or the delayed node lock. This
patch achieves it by calling qgroup_reserve_meta directly which will
either succeed without flushing or will fail and return -EDQUOT. In the
latter case that return value is going to be propagated to
btrfs_dirty_inode which will fallback to start a new transaction. That's
fine as the majority of time we expect the inode will have
BTRFS_DELAYED_NODE_INODE_DIRTY flag set which will result in directly
copying the in-memory state.

Fixes: c53e9653605d ("btrfs: qgroup: try to flush qgroup space when we get -EDQUOT")
CC: stable@vger.kernel.org # 5.10+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>

 Conflicts:
	fs/btrfs/inode.c
---
 fs/btrfs/delayed-inode.c | 3 ++-
 fs/btrfs/inode.c         | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 7dad8794ee38..e7f8cf1531bc 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -627,7 +627,8 @@ static int btrfs_delayed_inode_reserve_metadata(
 	 */
 	if (!src_rsv || (!trans->bytes_reserved &&
 			 src_rsv->type != BTRFS_BLOCK_RSV_DELALLOC)) {
-		ret = btrfs_qgroup_reserve_meta_prealloc(root, num_bytes, true);
+		ret = btrfs_qgroup_reserve_meta(root, num_bytes,
+					  BTRFS_QGROUP_RSV_META_PREALLOC, true);
 		if (ret < 0)
 			return ret;
 		ret = btrfs_block_rsv_add(root, dst_rsv, num_bytes,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 64dd702a5448..a38dcf6ae4f9 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6375,7 +6375,7 @@ static int btrfs_dirty_inode(struct inode *inode)
 		return PTR_ERR(trans);
 
 	ret = btrfs_update_inode(trans, root, inode);
-	if (ret && ret == -ENOSPC) {
+	if (ret && (ret == -ENOSPC || ret == -EDQUOT)) {
 		/* whoops, lets try again with the full transaction */
 		btrfs_end_transaction(trans);
 		trans = btrfs_start_transaction(root, 1);
-- 
2.31.1

