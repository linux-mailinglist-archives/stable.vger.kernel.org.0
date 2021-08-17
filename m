Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD473EF4B4
	for <lists+stable@lfdr.de>; Tue, 17 Aug 2021 23:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234835AbhHQVMf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Aug 2021 17:12:35 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:4786 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229531AbhHQVMe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Aug 2021 17:12:34 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17HL2PeV011146;
        Tue, 17 Aug 2021 21:11:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=OaSEWtpzxnN9Ga8GV7lTA07ppSWykmEyF7T1zmBpxIs=;
 b=sW6kNlrigSnaZpne1xgF38Cc1F1+w5WjTE75gVmEBGhgQrwf1nOWA+TpgXZMaF1pcj/g
 JKqm05JtrDfco8V5vruO314WVqin9i6Nt4e6B+TpltySLijsPZF2aDH8cfbdOTa7qkVV
 Wvida3gcW50gYJ0gLLTNTtwQBkQH64gnkQuGaQtREbBYb/e99GbV9hWYJf8tZ6wMJ/k7
 ACALqaAZ0/kIdm4LvgZsWOBycNMbR/VVChuCFDEmuWvBflIVGSE/dQYSScRDxPnq/l71
 UjkQAUXEEEkv9xUuRyC7JF56VsqrFzfY2Z+qBprdKpYkj45Wir5ok/A/yGJ7aS/IOU0T vw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2020-01-29; bh=OaSEWtpzxnN9Ga8GV7lTA07ppSWykmEyF7T1zmBpxIs=;
 b=SU3SVcmCbDQ5vVCyDEsV0n05GN4z5IbUTlg/m+M5jhjDDaXS0Z3f+Tz5QWe2Xp9BLnmb
 gVW42vy29FAVHKgLPVFTqIpsTsUrbEK8MYcVk0jmgYyfSJxny2sN8MotXEVdwbovTVwt
 g7QnGtvOYU5cfVcj7/MXUTuXaB+lKga+XOjsOlYooCBSTWdYuNCRDvxqzL0e6yuT8/kZ
 8m7Xw0D8u4Tgq91PQ5re3awp6sieJrDUZt7r9XU9WKor5HYI4GFVsmOvw+MKyue8WXUz
 /bJu5TGKgOD+R9hq8cKFHyvGAj8nDBNIk7AgL8lTITtP6b+ZjP42X5WH42HvgKk3ABTC lw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3age7ms401-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Aug 2021 21:11:57 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17HLAlK2047986;
        Tue, 17 Aug 2021 21:11:56 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2041.outbound.protection.outlook.com [104.47.74.41])
        by aserp3020.oracle.com with ESMTP id 3ae5n89900-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Aug 2021 21:11:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kgtgHRKqkFjdbBtN2vZa3GeGDAIO7czdrbKa9eJqmB3q5blCYWYV3fup7HQSOvYLbHYgVRnyn0/y+R7NA7f5GARFYbvMn+QO8JqhZSGzyO50klVWtaOQSfVEvI/u/H8sOY4enmBu23kUNKt9aHQXLJ9VQR/k/MM37g5HbMpqwNE5q5nXnZnIZBEdXIt+dfY8cpHOVRXJrxi3s/6fs4z8vglL6TC/VIi9Sx9e0btn5wI6BCJY1gyqgQBQKsV02vhSCDgdyX2EXOn7mA8LVTzbiSmF79nCS7vIjZoeeE7G61ibEr+LMTvHuKramFGuU0puVPxmpXyyTth1gHa/gAS6Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OaSEWtpzxnN9Ga8GV7lTA07ppSWykmEyF7T1zmBpxIs=;
 b=d6TBawuaXJuAX5lvO1whiHABJF8VHwOFcMgFPLttWgZckqfaex54C7cILMWDi6WWwyqGNYhY5dAI5hCLrmhQgjUjnwrjI9AGuUdqCnqUy2bJUtjJvxshsIbVZY/1lui+V9kvmh9xeyTnGb+gWdrzyIhTvlTJ8JXAB592JS8IMIycY+JMSaZTjMaNlC7n1JI5DuYP2S3ubPYz9F9SYDV+jyISU8dEe/J2o1Pc6yPtiAaJxPXEuOLgkGXWjooOffK/zDerxYQQ+F3TZppAj6qazsGS3yN/B8mJRQ/X3IBfEGYeEd4lvxpAgiMicObceUqHw2gwkN+6Pc0QCdrILv5QWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OaSEWtpzxnN9Ga8GV7lTA07ppSWykmEyF7T1zmBpxIs=;
 b=hljQQFlD0YnUhAIPtWZsfXBXWOKeezf1o3wZgrHHuXRoY1zopbB1S6u6nG5vjBagDlVEN54urgQBDALL4ZW+0DV6CKPpHqSrsaGRSUvA0YEqCTyV3L3I/vcyqI6eKbdLblVn5liF1x1YQI4o4VTZfg/aV9GoFk2ea73qVI+i1KY=
Authentication-Results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=oracle.com;
Received: from BN0PR10MB5192.namprd10.prod.outlook.com (2603:10b6:408:115::8)
 by BN0PR10MB5320.namprd10.prod.outlook.com (2603:10b6:408:12a::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Tue, 17 Aug
 2021 21:11:54 +0000
Received: from BN0PR10MB5192.namprd10.prod.outlook.com
 ([fe80::4551:a5b4:f2ec:daf]) by BN0PR10MB5192.namprd10.prod.outlook.com
 ([fe80::4551:a5b4:f2ec:daf%7]) with mapi id 15.20.4415.024; Tue, 17 Aug 2021
 21:11:54 +0000
From:   George Kennedy <george.kennedy@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     george.kennedy@oracle.com, tytso@mit.edu, adilger.kernel@dilger.ca,
        stable@vger.kernel.org, dhaval.giani@oracle.com,
        dan.carpenter@oracle.com, linux-ext4@vger.kernel.org,
        riteshh@linux.ibm.com
Subject: [PATCH 5.4.y 0/0] missing upstream commit 175efa8 causing: WARNING in iomap_apply
Date:   Tue, 17 Aug 2021 16:12:10 -0500
Message-Id: <1629234731-20065-1-git-send-email-george.kennedy@oracle.com>
X-Mailer: git-send-email 1.9.4
Content-Type: text/plain
X-ClientProxiedBy: BY5PR20CA0021.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::34) To BN0PR10MB5192.namprd10.prod.outlook.com
 (2603:10b6:408:115::8)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dhcp-10-152-13-169.usdhcp.oraclecorp.com.com (209.17.40.42) by BY5PR20CA0021.namprd20.prod.outlook.com (2603:10b6:a03:1f4::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend Transport; Tue, 17 Aug 2021 21:11:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 39d584bb-6df1-4ec7-0e1d-08d961c3a3b3
X-MS-TrafficTypeDiagnostic: BN0PR10MB5320:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN0PR10MB53205EF15DA349B626910D71E6FE9@BN0PR10MB5320.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:546;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eVLQoE4gcpyPBSpp+bmIXBXg8Y4pzCtN8oSXwamDSxihq/n+anyksyyAKWewb1JMLZv/Su/9UwWOaH4pNM9L4WAu3XrQCbI1Excwat3jyf73pY2HsEIt6a6+uXfWo4iBNpKeok9SaYwS9V+LCMXfw6eOaj/1eZYYmg0LA4ty9Y9JtCN05iZ5EPL1KGxrS7Dn8pRDfCZbtkcOAVsqoCidQW3opWcj1KsimKtIpmbXFFvxzRbKS7SCsMpWokw+Ym8zcC5ldX6AdqmDOB7aTIhD62Byyi6QlJc7STG9o5nGwSIe7vFozKeG2C218AKY+FRuPOQx0v9G+zy551n63VIedCEsC9LPPsSbynLIYcTpF6umlNID7vHQxvp2DPAhMrz5Epnn6jvpoemFGcjf43RDpV03YaJxxvdjHyPRkeVueb1KNpyFMEcxCkv9XYD6cdRQ8jdvIjqz1VZYEFB3WnPmeX72IdRT7E+B3vMUeMNJHrnQQxqlmBsaXJfULoklWCu35AzPZtyQhtVMLRCC8lXFLVdTiKw/3w+RGUgA39OphPd9QEBI4VJV+u4NB6pp9KEiDFfvjreAYRJBJAXohvFyW++Z3ZvVUWo7Er+FxmOK9+NZQi7Z8sjh+XCVhDRIXrkqIyZbStEYZnwX30BXuMCPX4ZGf0pDE2TYa7kILXLeE4Y8acnZuoRNS3MyD4KpcidNYneN5GlC6WF7TSUxKuCGgQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5192.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(366004)(376002)(346002)(396003)(66476007)(36756003)(38100700002)(38350700002)(2616005)(316002)(66946007)(8676002)(956004)(26005)(6512007)(83380400001)(478600001)(6486002)(6506007)(66556008)(5660300002)(4326008)(2906002)(6666004)(86362001)(44832011)(186003)(6916009)(8936002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dQj3kLlmOTQH8QTdJfZIbm9qBhFUesBC+VdT4bxMU7Rm0DRU6z484pvSTvXg?=
 =?us-ascii?Q?+7bmpNWgGj6+f6mMXBRRmWNwFLtmBWieiknKb0wL1EPOMiJcyOYb2xp42hpu?=
 =?us-ascii?Q?XxmTZ+nHwWSCKPKEfXTOTCektSxKmnBIrP+WDIQJnP7LtB2tKuQsYRVbUrNl?=
 =?us-ascii?Q?+HGMofUFvvUZlzAPQVOr597DliBu1YDeZSvJecc8mC6ZbesJM6FKZOGM6a9a?=
 =?us-ascii?Q?k9NWj2Ag28kt7YQzepRLxIcn8HjBAlV4NTjjY0KjOmudw/wMnj/IMjuwTjT2?=
 =?us-ascii?Q?GQXH8tEB9FacWah9WUNLyoDZGd0tLKn+z/gqU3idnqmOnYBFvc3mLKDLNVMv?=
 =?us-ascii?Q?1SyEs9K4ApEFoQV6SZ/rNUqcyzAXtcYqMFIFHipSdsLZT6aZHwmF5KoA1teD?=
 =?us-ascii?Q?sLT6cOnhqW8FOJasyBppw+Et2/T3Jfrc066t7rKcm1fR9h8FqAVN6l0bgSJi?=
 =?us-ascii?Q?PI3ueCaerIvsY2YreIO90x+/D1R56jXWwiZndwaS68BSLBSD27JEFpi7lVev?=
 =?us-ascii?Q?VW/0fDV4S0HkuvJywnPEaRZfy4AzwitdBFY8lhKg2W90AyXhSq5zMVaIAXKQ?=
 =?us-ascii?Q?zgacD4tWIWUCUsy9LYLmH9fm8oVGeRG/nYx7F8ZYfUcRbjqvIAP3Siz4tU0y?=
 =?us-ascii?Q?zhX8Uz9/Oq2I+gBnskP5M7pd4XuYeU2oL81cIFNLTvYakHuQqUMFxpJsRFde?=
 =?us-ascii?Q?6m+rd+jIXenXS5YuYZj4YAJxEFmSCkbQQfWA178g3BG4mwCzswfF5TP958Pn?=
 =?us-ascii?Q?uRxbsy9UB6dOiUtN+Zb/+AFLYzrAJkzUCiUmtckT6ZrYtTTvb4ovMryOVdqm?=
 =?us-ascii?Q?VW7A5SU21U8AS1kBOS92e6eeS60FNrfkxK2X0EvUnnmLa57Ml2NjS1C+qqlb?=
 =?us-ascii?Q?2x5arTutbypfQu2o7s8l/kp34WvtlEUFl1581JuKFxa6e1glJSSMIrGAx9N4?=
 =?us-ascii?Q?5Ptbt6I3EWon/voecEz9/Umwr5ckTvtwJwdfyQ7FqgppbnS8X10gEyen5ofS?=
 =?us-ascii?Q?xAvZ3+5ZpAg8KwgSjPUWo1sqKnNZq2GJA1xySRlxfHxzWUZTB+IplrOkBVpM?=
 =?us-ascii?Q?MPkazF6e1wG4dRx5m1cr+clrh+L8snJzsl9CxdoD57F71pOaXt9hnyxTyIWR?=
 =?us-ascii?Q?KQ7ubHgL4CxAauwcuIv7CAGN6U/oE75M+Td2687K9+WSMxj1F5P880nqeDXz?=
 =?us-ascii?Q?7h3mDvVbVhdoKLrPgkQrPA8JPz0adko4d/kGsS1MmquTa+RbIQ5spq2rUj3u?=
 =?us-ascii?Q?0/e4085qccVAEMKFQuhJRXKF9n89gk3LnSQ5bnBYkxPtwpoFzMtRX08eAZxw?=
 =?us-ascii?Q?x5LFP+JdbcnR0mJYcIaOFQy5?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39d584bb-6df1-4ec7-0e1d-08d961c3a3b3
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5192.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2021 21:11:54.4126
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fxRo6ttuNaL8X6Nk2BDtxBWYlbC7FKgMh4vR6alITYBD61km/B8JeA4xFkpgk5jmPoCUBiikwSsmggadOnxIIht5HStMJfFrOBX5agyByJg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5320
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10079 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108170133
X-Proofpoint-ORIG-GUID: 3O5F81H0HvMDcwn9nIt3PkygsHKq9e3X
X-Proofpoint-GUID: 3O5F81H0HvMDcwn9nIt3PkygsHKq9e3X
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Upstream commit 175efa8 is missing from 5.4.y causing
"WARNING in iomap_apply" during 5.4.140-rc1 Syzkaller reproducer testing.

175efa8 2020-05-05 Ritesh Harjani ext4: fix EXT4_MAX_LOGICAL_BLOCK macro

------------[ cut here ]------------
WARNING: CPU: 2 PID: 9155 at fs/iomap/apply.c:44 iomap_apply+0x278/0x2b0 fs/iomap/apply.c:44
Kernel panic - not syncing: panic_on_warn set ...
CPU: 2 PID: 9155 Comm: syz-executor.7 Not tainted 5.4.140-rc1-syzk #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.11.0-2.el7 04/01/2014
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0xd4/0x119 lib/dump_stack.c:118
 panic+0x28f/0x6ad kernel/panic.c:221
team0: Port device veth4741 added
 __warn.cold.12+0x2f/0x2f kernel/panic.c:582
 report_bug+0x279/0x300 lib/bug.c:192
 fixup_bug arch/x86/kernel/traps.c:179 [inline]
 fixup_bug arch/x86/kernel/traps.c:174 [inline]
 do_error_trap+0x105/0x170 arch/x86/kernel/traps.c:272
 do_invalid_op+0x3b/0x50 arch/x86/kernel/traps.c:291
 invalid_op+0x28/0x30 arch/x86/entry/entry_64.S:1029
RIP: 0010:iomap_apply+0x278/0x2b0 fs/iomap/apply.c:44
Code: 81 c4 d8 00 00 00 5b 41 5c 41 5d 41 5e 41 5f 5d c3 e8 3c 85 99 ff 4d 29 e5 4c 89 ad 30 ff ff ff e9 fc fe ff ff e8 28 85 99 ff <0f> 0b 48 c7 c3 fb ff ff ff eb 95 e8 18 85 99 ff 0f 0b 48 c7 c3 fb
RSP: 0018:ffff88801dfb7af8 EFLAGS: 00010216
RAX: 0000000000040000 RBX: 0000000000000000 RCX: ffffc90013f11000
RDX: 000000000000218f RSI: ffffffff81dbc858 RDI: 0000000000000006
RBP: ffff88801dfb7bf8 R08: ffff88801ddb5d00 R09: ffffed1002e9249b
R10: ffffed1002e9249a R11: ffff8880174924d3 R12: fffffffffffff000
R13: 0000000000000000 R14: ffffffff8e3f76a0 R15: ffff88801dfb7bd0
 iomap_bmap+0x13f/0x1a0 fs/iomap/fiemap.c:141
 xfs_vm_bmap+0x32b/0x420 fs/xfs/xfs_aops.c:1155
 ioctl_fibmap fs/ioctl.c:68 [inline]
 file_ioctl fs/ioctl.c:502 [inline]
 do_vfs_ioctl+0xf50/0x1250 fs/ioctl.c:697
 ksys_ioctl+0xae/0xd0 fs/ioctl.c:714
 __do_sys_ioctl fs/ioctl.c:721 [inline]
 __se_sys_ioctl fs/ioctl.c:719 [inline]
 __x64_sys_ioctl+0x78/0xb0 fs/ioctl.c:719
 do_syscall_64+0xe6/0x4d0 arch/x86/entry/common.c:290
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x4595f9
Code: fc ff 48 81 c4 80 00 00 00 e9 f1 fe ff ff 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 0b 42 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f8ed3550c48 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000014a40 RCX: 00000000004595f9
RDX: 00000000200000c0 RSI: 0000000000000001 RDI: 0000000000000004
RBP: 000000000077bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000077bf0c
R13: 0000000000021000 R14: 000000000077bf00 R15: 00007f8ed3551700

Ritesh Harjani (1):
  ext4: fix EXT4_MAX_LOGICAL_BLOCK macro

 fs/ext4/ext4.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
1.8.3.1

