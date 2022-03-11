Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 985174D60A4
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 12:32:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348259AbiCKLcX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Mar 2022 06:32:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231838AbiCKLcW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Mar 2022 06:32:22 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 423211BB71A;
        Fri, 11 Mar 2022 03:31:19 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22BBRkAl023462;
        Fri, 11 Mar 2022 11:31:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=Nu7VeUVs7Prq6cCbL51kPbNWgiaAYoc+TCFuqBY27jo=;
 b=dnxfhjsU5B8Uo4rKnjIM690j9aN18LaDZ/evgB9rAy8niQguNdei3LmygA6t+ZV+nkIG
 XAnD0Wk7i0EffFjrkVLX9UsPDU3Z0g9yoR/mlO5JTc73vGEhPo/MQn+JqY/xF6VCkgnv
 D4zyxzDdeyYVmff11bl2pTKCY31n5McJZxp3C8E41FFlbTPp1hZqvtsgIMLThWiAaCar
 mulIWIMd9RU2/EcCyJGCsWUK+y6qKVtaW4jXHou01wNCSnptvRZcmcpJQDiezr9s6PzH
 zfGqGHCdLHPEavfKwq/APIra28DD6fFIu1EtOfDaOoFzWWNhWLzTe9BJJ12dv++ajxxM Fg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekxn2rxk0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Mar 2022 11:31:00 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22BBHL3O192676;
        Fri, 11 Mar 2022 11:30:14 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by userp3020.oracle.com with ESMTP id 3envvp36rt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Mar 2022 11:30:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X6ShEY/lTNfDAjDmhX3v19oTDFqXhwBWH7nxu4c63o8Gq4qaXxQC6fWsvBuoZCG+idFmpN3B5QEojP11gdlddt3khYBfXjKlw+m6EmqL3651YF0YHRA8CFqA8axsn+3KfrjNlgAVd+MJblP+niqv+L2gP8OjSWIPPMkSnFrAK2g/OJTuwGNhQqCZaGpFKT/esa0Znogv8eumflYnsi0Pw0BOEZmCtnVNBhYEzHiwSEBSoleK/+IKqKJa/LeixY5f+tRanUyIlAvxjCBWLG5sUNjk33Eb82jE6vIWoiwm+pP3pEg3vq3c1bM9kL/d3hFKtOkjVRIPuESI87XrXZX1JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nu7VeUVs7Prq6cCbL51kPbNWgiaAYoc+TCFuqBY27jo=;
 b=mlPRaNt2KxpBTIKTp0k1ZnsZ3yjvcY+J5dwc0XJdcDrGbzNYSZmxcSFOROovp8/zHJuAKgzH/a7MklVg21plZgUkiWy/70LOXfvXZFdhp1HvH44ePUIEPMEOSXJKAsc8szJoh6K/WqWAgx2s0g+w+0PWv8ZTOA7CoN2MtIpgSOTuGu4O5eFURtQsU+TYXiDJVuemkXzfCW8rP0LGcMKzroRzgoN4fYvG1Wo09MEnqtR0y82LVHeS68RkzN/84K8HjVura44RVxQblDJFvVxWJWADD2gEdYT/HZHNd6vkogbPaD9xF1rrKHYVdf/FbcCxt0N82KoHUznf/Ukhb0Zfbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nu7VeUVs7Prq6cCbL51kPbNWgiaAYoc+TCFuqBY27jo=;
 b=b1nc5XVQT6hYwh3Xgiut9HE7+adA7C8EiSqdj9wiuk9dS2nVLghUeKvS6c1jP6c6Si83vFDLQbBiiRAahZw/XyHl3voo7P0M6LPz/jjdAAplJWHPkcquQzWjvq3acHP9xMTE7zWWq7cUjHoprDtA2RM5nttwF9oj/hDWaqIE0x8=
Received: from BN0PR10MB5030.namprd10.prod.outlook.com (2603:10b6:408:12a::18)
 by CY4PR10MB1430.namprd10.prod.outlook.com (2603:10b6:903:26::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.17; Fri, 11 Mar
 2022 11:30:11 +0000
Received: from BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::b9d4:8912:7bf8:14fb]) by BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::b9d4:8912:7bf8:14fb%9]) with mapi id 15.20.5061.022; Fri, 11 Mar 2022
 11:30:11 +0000
From:   Liam Merwick <liam.merwick@oracle.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, x86@kernel.org
Cc:     pbonzini@redhat.com, bp@alien8.de, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, krish.sadhukhan@oracle.com,
        liam.merwick@oracle.com
Subject: [PATCH 5.4 0/4] Backport fixes to avoid SEV guest with 380GB+ memory causing host cpu softhang
Date:   Fri, 11 Mar 2022 11:29:23 +0000
Message-Id: <20220311112927.8400-1-liam.merwick@oracle.com>
X-Mailer: git-send-email 2.27.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0088.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bc::7) To BN0PR10MB5030.namprd10.prod.outlook.com
 (2603:10b6:408:12a::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 358b3b9d-546b-481b-b2f9-08da03528115
X-MS-TrafficTypeDiagnostic: CY4PR10MB1430:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB14300DB102C04F168ACCC7F1E80C9@CY4PR10MB1430.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KE3itc/fLEiPecTT0ZFMk/3agFCPH2luO1FqfsLmupTGITQLBDwzjI9nIT4yPuBMiBLouob3+Ep6FcnQ+BFfhRNIMI6Lm/fbD9wbwEYs/2nczYoQ3viuOQVuq8rfguN6R1ADTHU4bG1/YrqqSh1KS1jZ86XV+vIb/RlcRAkAzuXkhmTT/fbbmb0Itj4m3bS++gBvU9mdyiJrfebh6KzVF916mgnZqNotsmdkBgnHhr1Ia9s59Eput/SbIeX9T0VkGvor74GF543qnyIfXUgmVjeLMBQM/oZTG16DnpBUF1X2ChVUnfA65gan4FZhBm2RSXqQkXFoEnQeYTlyCnP7ac9fsK5G0hFyPeGo4fofKKPzBnOojCxyDDroFfZEoaYSNKRG5ufAeZ7wmW7QiB6Lwo3OPnrXcNZ8azJyC1yYS1ToIQsXkvxGVByrH+CJg4m7DBvtP2JrirdkdSeHwr24QdOmUBj6+2g1aHwPAGmTZdbDEpPIDhv2hGPleDjkXzqkQB5T6VW9sYoWxwjHMRkhn0ixTEeHySKSdST8a2+8Cz3BBC+LFc8Nh0ivz5nPyo7qvzxnVYAt5Cgiqgb5V4m0qFVMj7mqQeAEc3TWPaCwRCgH2nNEcTnbu0CuZKK0Ve9t389EKksJmkaUI1ygJYI81gEgeocLFGOs69pCfZtEabQAGVkRJHyyTc969ZQlCm4xcgK6rxTXGW5QfZW6BozFAg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5030.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(8936002)(4326008)(6666004)(5660300002)(8676002)(66556008)(66476007)(66946007)(508600001)(44832011)(316002)(52116002)(6512007)(6506007)(38350700002)(6486002)(107886003)(86362001)(1076003)(186003)(26005)(2616005)(36756003)(83380400001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?A+ch/Mnz+c6CTZbB4n5Ew36SiEPB22ka8KOmg041z3xWc7G2u62VlVoqiBR0?=
 =?us-ascii?Q?3Nggui9y3jiVwNAluL4x3LoC8XHP7dU1badZS4vijz7fMqMd5T316346K7V7?=
 =?us-ascii?Q?9afxwMVTK9UAB/EpwOziKO5eB6OXTQhujJVR0gIDWVwUlczdXnyw4LoAyPFZ?=
 =?us-ascii?Q?6cEp9jp2LAccVavJ5+B7AD9HoNkljL2JX/1rsKhn2f4NOtbFeHJ/BYtoxSBl?=
 =?us-ascii?Q?lQKei+GINNOGSjjgdTjEDoxBKPyrH7S1jn9DQv8LcYupQLhVNDKy7AzySaAH?=
 =?us-ascii?Q?nH0alRTlkMaZyhJqTsyTXhQN7WqDArTXRplhvm8xPq2aA/EAcIiBQjnX3DBF?=
 =?us-ascii?Q?J5Yag3D9fhTr4xbxy1dUrFXwj73rnPRIMkUBRN59Sm69TWcQrk5DdsVepRt+?=
 =?us-ascii?Q?LjgNNHYF4OCYGKjLLnnaJP3T8HcM/s4Z3NkvA+vT6W10ZyRR3JPYdJ0g7jnI?=
 =?us-ascii?Q?HuN5XAnhKgTecJUX7u7ToMGFxuWBJbsGPTKmPELDLpeWETxXgr8LJ/YyYnl0?=
 =?us-ascii?Q?edmErb5dS/cbknuz6XCtokNaoGkkbADeQyD0BxZ3R2b1YEtYa4yhzim1H8Gz?=
 =?us-ascii?Q?RZW4NNTj+qsCG0KeogSk2mTVrhmXPXo+L4StP8tVWOY0EBcqYXBplZ4BF1Rb?=
 =?us-ascii?Q?M03jPuigM+MYkZ/YH5huC1PPtWNKI1D5czBIsIeEBY2vgT4S3RLUsdv5Iysg?=
 =?us-ascii?Q?5e9aAku/ytyCT81og7qnPNU8Ctl/i+4VcOvEyvAzYjKVUNj9pXm+Z5WvXtMk?=
 =?us-ascii?Q?+rjuaKWHIqAXn/BTk3Uow8gMCQ/pQ569OagNaCbpCEnH1EykQjaA87GBLeDO?=
 =?us-ascii?Q?NPsvUWFrv05yBbgWp2wvQxvEUcB9FsZsZL/8AsY/ZhPSVDEzKCRt+Afy7ujz?=
 =?us-ascii?Q?2/Ovl2V3FEy+eUDnl7GeZhKF0fr1nz9i9sITL9zcxZM0KXegb9pnvgn2bQKr?=
 =?us-ascii?Q?I7Pq0Em1QaOKMHv3/3rVXPqcquah7LbYPo8gl/NbmbqNKWBCT8F6oUJ9iqhL?=
 =?us-ascii?Q?rJ6DPs7q3sk0pvW1KCC5zMiXhgHZtGFiemd4iwKlIPd/LzEw5+Gw3WaebXTo?=
 =?us-ascii?Q?j6lCnlciNB2+QRDahL0Ec3o3uX557gwnoYFI6pcOKJXfWaRLUOb9TYn0jxO1?=
 =?us-ascii?Q?EGL42AAzUGr/l+vxGMOzPJPXdbKWL71HQ8xCmiI7E7u3kYW2EO0ba8oD2rek?=
 =?us-ascii?Q?bic8lfkbdHTRni98s/ZYoWJ05xnmBefr4k0swFoA6OsrI6+qrEj9QfH0xB09?=
 =?us-ascii?Q?eO5dSZMdSlk209LDAAlG61kQWeXcx8qsBB8vhYMvrjS9SLtq2PKTT1pxKKUC?=
 =?us-ascii?Q?dQp1K/UHiH3JhtSjTUWoT2zRJMpsRHkbIe4p1WlchLBTA436pQgBfeb9/8Qc?=
 =?us-ascii?Q?lW9FOu2GYr+S4Q90cHCoZLRPHHq1oonL67rHzojHDPQTePp+JFPHYZY51GVe?=
 =?us-ascii?Q?Fap7Ue/fNBcjBSs7iQ8/3ZRLR2LNEo4uIiLqqCmhGc8n0fvoKA98arXkxFls?=
 =?us-ascii?Q?wIbPpg+g0MlnJqjB1SbEd4VNXzU2ppQCQEBAXtZ7bKi0WItsDbLPbPugrc7r?=
 =?us-ascii?Q?tTXMv4bpBzYJYv9ffSvW8KcYW9DB5ddAb2CCvKFw71J2YKtyyrOkG/lC3t53?=
 =?us-ascii?Q?PvHmVmM4rkwRdbSZVTxykZ0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 358b3b9d-546b-481b-b2f9-08da03528115
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5030.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 11:30:11.7059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /fj/k7m4ktdgEWmjaXMzALslicxwqKloOxXRoK9evAboovRksbz4BouSBIKR+iWth0n73Z+EMPsmM9Oja7heoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1430
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10282 signatures=692556
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=704 bulkscore=0
 phishscore=0 malwarescore=0 suspectscore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203110055
X-Proofpoint-ORIG-GUID: VJ43iHY2riC7DVRiJTYLKZqjzrHGNEmU
X-Proofpoint-GUID: VJ43iHY2riC7DVRiJTYLKZqjzrHGNEmU
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ patch series targeting linux-5.4.y stable branch. ]

Creating a SEV-enabled guest with 380GB or more of memory causes a
cpu soft-hang in the host running 5.4 with the following stacktrace:

kernel: watchdog: BUG: soft lockup - CPU#214 stuck for 22s! [qemu-kvm:6424]
...
kernel: CPU: 214 PID: 6424 Comm: qemu-kvm Not tainted 5.4.183.stable #1
kernel: Hardware name: Oracle Corporation ORACLE SERVER E4-2c/Asm,MB
Tray,2U,E4-2c, BIOS 78014000 01/05/2022
kernel: RIP: 0010:clflush_cache_range+0x35/0x40
kernel: Code: f0 0f b7 15 63 53 99 01 89 f6 48 89 d0 48 f7 d8 48 21 f8 48 01 f7
48 39 f8 73 0c 66 0f ae 38 48 01 d0 48 39 c7 77 f4 0f ae f0 <5d> c3 66 0f 1f 84
00 00 00 00 00 0f 1f 44 00 00 55 48 89 e5 0f ae
kernel: RSP: 0018:ffffacba5e98fc30 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
kernel: RAX: ffffa1193cfbc000 RBX: ffffacbba4701000 RCX: 0000000000000000
kernel: RDX: 0000000000000040 RSI: 0000000000001000 RDI: ffffa1193cfbc000
kernel: RBP: ffffacba5e98fc30 R08: ffffacba5f44aca0 R09: ffffacbac3701000
kernel: R10: 0000000000000080 R11: ffff9f8500000af0 R12: ffffa18074a22f80
kernel: R13: ffffacbaf6889dd8 R14: ffffacba5f41d960 R15: ffffacba5f44aca0
kernel: FS:  00007fbe04321f00(0000) GS:ffffa1814ed80000(0000)
knlGS:0000000000000000
kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
kernel: CR2: 00007dfbebd7d000 CR3: 000801fb93d68002 CR4: 0000000000760ee0
kernel: PKRU: 55555554
kernel: Call Trace:
kernel: sev_clflush_pages.part.56+0x50/0x70 [kvm_amd]
kernel: svm_register_enc_region+0xe2/0x120 [kvm_amd]
kernel: kvm_arch_vm_ioctl+0x524/0xbd0 [kvm]
kernel: ? release_pages+0x212/0x430
kernel: ? __pagevec_lru_add_fn+0x192/0x2f0
kernel: kvm_vm_ioctl+0x9c/0x9d0 [kvm]
kernel: ? __lru_cache_add+0x59/0x70
kernel: ? lru_cache_add_active_or_unevictable+0x39/0xb0
kernel: ? __handle_mm_fault+0xa74/0xfd0
kernel: ? __switch_to_asm+0x34/0x70
kernel: do_vfs_ioctl+0xa9/0x640
kernel: ? __audit_syscall_entry+0xdd/0x130
kernel: ksys_ioctl+0x67/0x90
kernel: __x64_sys_ioctl+0x1a/0x20
kernel: do_syscall_64+0x60/0x1d0
kernel: entry_SYSCALL_64_after_hwframe+0x44/0xa9
kernel: RIP: 0033:0x7fbe0086563b
kernel: Code: 0f 1e fa 48 8b 05 4d b8 2c 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff
ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff
73 01 c3 48 8b 0d 1d b8 2c 00 f7 d8 64 89 01 48
kernel: RSP: 002b:00007ffedf577418 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
kernel: RAX: ffffffffffffffda RBX: 00007dfbebe00000 RCX: 00007fbe0086563b
kernel: RDX: 00007ffedf577490 RSI: ffffffff8010aebb RDI: 000000000000000d
kernel: RBP: 000001c200000000 R08: ffffffffffffffff R09: ffffffffffffffff
kernel: R10: ffffffffffffffff R11: 0000000000000246 R12: 000001c200000000
kernel: R13: 00007dfbebe00000 R14: 0000000000000000 R15: 0000000000000000

The problem is the time spent flushing the caches when pinning memory for
SEV but it's unnecessary as it turns out - it is resolved by backporting
the following commits from Linux 5.10

e1ebb2b49048 KVM: SVM: Don't flush cache if hardware enforces cache coherency
across encryption domains
(conflict due to the function it fixed being moved in a refactoring in 5.7).

along with 3 other commits needed as dependencies.
(fbd5969d1ff2 avoids a conflict in 5866e9205b47)

fbd5969d1ff2 x86/cpufeatures: Mark two free bits in word 3
5866e9205b47 x86/cpu: Add hardware-enforced cache coherency as a CPUID feature
75d1cc0e05af x86/mm/pat: Don't flush cache if hardware enforces cache coherency across encryption domnains                                                                                                        

Tested by creating various sized guests up to 1.8TB, with and without SEV enabled,
running a few benchmarks and passing kvm-unit-tests.


Borislav Petkov (1):
  x86/cpufeatures: Mark two free bits in word 3

Krish Sadhukhan (3):
  x86/cpu: Add hardware-enforced cache coherency as a CPUID feature
  x86/mm/pat: Don't flush cache if hardware enforces cache coherency
    across encryption domnains
  KVM: SVM: Don't flush cache if hardware enforces cache coherency
    across encryption domains

 arch/x86/include/asm/cpufeatures.h | 2 ++
 arch/x86/kernel/cpu/scattered.c    | 1 +
 arch/x86/kvm/svm.c                 | 3 ++-
 arch/x86/mm/pageattr.c             | 2 +-
 4 files changed, 6 insertions(+), 2 deletions(-)

-- 
2.27.0

