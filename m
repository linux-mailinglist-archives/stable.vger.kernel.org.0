Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 965C0426EF5
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 18:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239780AbhJHQ22 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 12:28:28 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:2886 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240503AbhJHQ2J (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Oct 2021 12:28:09 -0400
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 198BHAos024921;
        Fri, 8 Oct 2021 16:25:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=hhot6v+kULR1ZKeDB0xXaIMfHxsVsnD+/4ObKI5nNpg=;
 b=jfoKMzkdGncW1H9kIEyLX90PquLzxrQaPWoXRj5YVDX5GCvSxJJCXJQj3rhc2oRW3ySw
 XOtnKJf9O9rOOeXZBzQaO8mlJCsumfdAD+fiTgS8MpnA+DKbTnJ6Ak31DkBQMtguo7vk
 4dC9ld+0cIzzM30Gm9yva4HSLY6G2g5STXm3KRLX25sRegSFKRzP6DAjQDKiAeeZWydG
 WV23HX1xWEBC5XJoI7afdwTKj2jWgbxuhyDOtHoyWb+ExBpuI+zxczF0+ekVarXrr2QY
 CTcLkwOp2P73dm8ANO4Zo9BSTw06nB/zDcjWH5cgrFqCaR0A1o03bP8dbzY6+da3+E7S Aw== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by mx0a-0064b401.pphosted.com with ESMTP id 3bjdt9ghrt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Oct 2021 16:25:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XqicwTdtoCgl7MFsEACbHEegYrkW4iGcrjC62qFrH96FSqlVVh2JeCgLt2EZlA2JgjRAEF7RitVZ64m6A80eUKwZk2W5stppMDTnwpmbD9BsWOxO5yCV1e7kx/lY+G04YAmDvtF56Gbg5ZmG1Nxv7PVsVoe565s8GPCssZgmM5jgkGotcO3z2fZdeH+1BUctOb7rzgH7nqRgcdmsEDDFZy+Ute76TDnda29SOQrzWdtzpzBlY4+IFQ2rDjsOMXpZ9y/28avxgAVbrZjhtnYHRiXwZuf+3hoB2npGtS/FW4ta2guKyiucQt3kMSEbJ7YN4L+/ipkVFVbDRqVkXuua+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hhot6v+kULR1ZKeDB0xXaIMfHxsVsnD+/4ObKI5nNpg=;
 b=Xn3V1+7WJmPI8uVOIQtNEeADHmwJUWnlBm81Jz5O+Gn0TU76LiMi0OTLjEXiqNNaFGk9Rx0aXu4Ose+SSVTCfWXnNn6vLVN9+K/0fwZ4AjvbhKa3LG+Jv6mF2PbpSvM0wnimM7dII5/IgmPWJJRJgMQrAeUG8xN7C9y8zV52IRC2NtwCYSEuyPvgWy7i7U02J+NIf7ieBC0btvLZoJMWGf+4HaNoQSYgn4I7i/yNp+4g8uhELR6JNmOnTe8Brxagy1YvTNApxM3QRB4fsSUzqTdVlvwtywtyDuqaDwgckW4IfHWlbzarWllzaLQ4LF9dX2LgDcpkE9qc5Bi5Aw/Dhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from BN9PR11MB5321.namprd11.prod.outlook.com (2603:10b6:408:136::8)
 by BN0PR11MB5728.namprd11.prod.outlook.com (2603:10b6:408:165::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Fri, 8 Oct
 2021 16:25:56 +0000
Received: from BN9PR11MB5321.namprd11.prod.outlook.com
 ([fe80::98b4:7a11:22a8:3916]) by BN9PR11MB5321.namprd11.prod.outlook.com
 ([fe80::98b4:7a11:22a8:3916%5]) with mapi id 15.20.4587.020; Fri, 8 Oct 2021
 16:25:56 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     piotras@gmail.com, daniel@iogearbox.net,
        johan.almbladh@anyfinetworks.com
Subject: [PATCH 4.14 2/2] bpf, mips: Validate conditional branch offsets
Date:   Fri,  8 Oct 2021 19:25:28 +0300
Message-Id: <20211008162528.1233570-2-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211008162528.1233570-1-ovidiu.panait@windriver.com>
References: <20211008162528.1233570-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0183.eurprd09.prod.outlook.com
 (2603:10a6:800:120::37) To BN9PR11MB5321.namprd11.prod.outlook.com
 (2603:10b6:408:136::8)
MIME-Version: 1.0
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR09CA0183.eurprd09.prod.outlook.com (2603:10a6:800:120::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15 via Frontend Transport; Fri, 8 Oct 2021 16:25:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3f46e667-b784-4678-444b-08d98a784dee
X-MS-TrafficTypeDiagnostic: BN0PR11MB5728:
X-Microsoft-Antispam-PRVS: <BN0PR11MB5728152D8F9900CBD824D728FEB29@BN0PR11MB5728.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:181;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: inYzg5GLcfP94QRYEmvt9iNK1pZLtlLXpsmhjMvnwDdC+GqZfZpO3MCECJOrSxfjDcYvJ+j1y6Zj/Ib3SsUs0qrtHcCihd5ElNjSfINFhZFKbTMbawoG4rqTUCn0Hz++UIoeutQABAiO+EMr7mmpdSkhbs4swB1bxfxA7J59ELyDDvvXqsmEAkCQE0YbahbDrSS/mQ6BpO2lynY6UIXzGKqMdT+hDaoTAACuU7FDe7/JB1857d3mimOI6Q3dakIRf/y4LCxKGI5f0A9gdoEJQSXd4USqHWPo8MIliEF3xZBLFbqKMJgWLspkxmsiYTVvO+MKrfQPXkaLAOB31hOZtNo0YkLdl/7KNuOsBqqZU5ITmAY/ZSpJlBOKaCEh6H06O8VeG7zsgZxQeW+N0z+nj3Sn5v1GvSBd6j2bQjpwl+Na7ialaC1ocWkLjrjkCoTFeV8Y77foNll9Z2aZiF/ziWWEJeRmk7eKvWQxm4PIfGIVK5Ck88v0B3F5mJlZtZMrkz1rr1ivpyT9EIKGujUTPlKc0Fv6aAAMNrB9npk2Ai2V5FiB5DXzlmLn4eZP4MExtWzxLff6fqKKPWNQflk2VfR7MSG1RqYPlnP3qIO4SlbBBGv9AVf5nU029QrGfJBwfUHEzcxem9Y2jZBWwltTZOXkrh5Nbr6Buk2o88tq49WuY6trL73kN/fWNMmZ4kK9rKCs7arIZ6/BixSQp9uzMHhGvDpswsbYLS7RCrtFvYRP5xyjxyYHjPJsN2JlkbIuen830a+D3tX7BxBVYu7QBMDpMdtuyPYmXhxeZi4mcgk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5321.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(5660300002)(2906002)(316002)(30864003)(6916009)(6666004)(508600001)(45080400002)(2616005)(186003)(6512007)(26005)(966005)(15650500001)(956004)(8676002)(8936002)(52116002)(66476007)(66946007)(66556008)(4326008)(38100700002)(38350700002)(6506007)(6486002)(44832011)(36756003)(1076003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pfmTlgwRyP7ulvpuL7TtkezHI2YHgF5spO59rti6LbbBCCkuay1sUbEIse3z?=
 =?us-ascii?Q?mg9Dc5Tyvb+ztIAxbhBQYcT0P9SlcG9SqkkrkfdpJzGt9hE3Uieh2bgqjrSW?=
 =?us-ascii?Q?DpTCZjnupNaksxHgIyVvPInrOjDYLcmGKc9IXHIy5Q8EVSchI2sJ2tpgrKTq?=
 =?us-ascii?Q?wizWL54SBlB56Ikuy2MoWJkFc2fePHCScV3aOgmVRMGnGhcLJYM925xLhoIh?=
 =?us-ascii?Q?E26fBXGnH3+ElObSe4SwuwlnhaNexfVWlTzMsctmac09nJyWxZPk/ndFU9sI?=
 =?us-ascii?Q?1Pfw+4TahOdlvRkSnM751IBd/L7eF6TgfVCJ3+ljeDCYhG3/X3ok1ygAx+Gi?=
 =?us-ascii?Q?zeFM3FQ3MVgBF+1+bpypqBmIaLPmywBCRbIKFaZLQrK40dBCLsOY8EZwOb16?=
 =?us-ascii?Q?rmmOv+pCxSGrdyBJ4a/J2bCJ3H5DHwfQzqxTYu9d9YQbe9XknCXRX7X0X+Ge?=
 =?us-ascii?Q?mVVteUDBDwCV9jnE/05Jopt/ei0L3Y8dxVN7nHIbgpF9G985AqDBWGNkpNnA?=
 =?us-ascii?Q?D8Dc/aX+aY3yXDCF4IRnv823pRyhp9hV/7zt1hA4dQOIMo9iezZo/Xmpu+wG?=
 =?us-ascii?Q?Udr94u4PismWWbKc61pSkBKsdKtVTMiszAu8PEZNNmNaIL6ddMIbBhAWjCG5?=
 =?us-ascii?Q?tEXlA1IYGzWZM2L9bHvFW9IAapb9S+Lvezv6ZE4iszBfThJ27CS0EK25NViC?=
 =?us-ascii?Q?CVerwNIx8Yk2Z0er6/StNNyCQo7vg/krUXjxqyifikLonpkNABaYp+3EYpUP?=
 =?us-ascii?Q?IrLXzemAKOBA1qMFi3+8VoVwl7dxUKEXDBURmFRX08ZiAC0YbJNxBMYpvRDG?=
 =?us-ascii?Q?yAdhhq1UL0di7svNHLG/KHQPZ1VcOuiKYWtLrdvUpg4EFAWcvhh5pKHjxyrk?=
 =?us-ascii?Q?IO8mQlZR98dQpTFABg/n8H2X7uNqmSt+3C8/IO94ird6P1XZ6ov/8SRCSj3K?=
 =?us-ascii?Q?JvYCbhneuWPrB5a0OB+M1iiYYBMUvPvdD+ZiB2FKhMIxS1ZNUq8x5Khv7kLk?=
 =?us-ascii?Q?tqpPcXjy3QSi9Kzq6CEJNdIekzjToMAr5pRV+wZJjWO93dxTGWfIUDHQR00i?=
 =?us-ascii?Q?XP8gVdYfa3MUok0Iqt0Xl8SlD9/z7ZvzQ5MgXQ1o/iXnBZg6eyCGurEUSuIU?=
 =?us-ascii?Q?mtwwaR53bxxLPEk0lOge0qHZGrX0ycj7gB4I+lf1ikyDpDwXDpa7TEhrCYW9?=
 =?us-ascii?Q?MpUkXAYb3Zqqu8xFgrmZ27tjYNPtiiXRYn1OlN8+tVj7RinSALYMKBGS9a/+?=
 =?us-ascii?Q?5pBElBdxLIBqHGGth5+0YGlaxh46T03AJVIGOQtvzVpxRXBKgHNl6Vqcc6xm?=
 =?us-ascii?Q?y3i4fmuB2G2Iybo9KqRD1WjP?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f46e667-b784-4678-444b-08d98a784dee
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5321.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2021 16:25:56.0473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GdgLGCOntxOnkkon4K+5f5Lpvh3/LpbpgMiW3XRtSGsFW80N2UvjaNO6px6bwBaQU9dqp8C62s1un7TJDeR0pAiN49WwXm6I/A4ZRbtqukI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR11MB5728
X-Proofpoint-GUID: 2k2vH6SLSGfyF6Hb9o95H93CTqIRRgZ-
X-Proofpoint-ORIG-GUID: 2k2vH6SLSGfyF6Hb9o95H93CTqIRRgZ-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-08_05,2021-10-07_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 mlxlogscore=999 suspectscore=0 adultscore=0 phishscore=0
 lowpriorityscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109230001 definitions=main-2110080093
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Piotr Krysiuk <piotras@gmail.com>

commit 37cb28ec7d3a36a5bace7063a3dba633ab110f8b upstream.

The conditional branch instructions on MIPS use 18-bit signed offsets
allowing for a branch range of 128 KBytes (backward and forward).
However, this limit is not observed by the cBPF JIT compiler, and so
the JIT compiler emits out-of-range branches when translating certain
cBPF programs. A specific example of such a cBPF program is included in
the "BPF_MAXINSNS: exec all MSH" test from lib/test_bpf.c that executes
anomalous machine code containing incorrect branch offsets under JIT.

Furthermore, this issue can be abused to craft undesirable machine
code, where the control flow is hijacked to execute arbitrary Kernel
code.

The following steps can be used to reproduce the issue:

  # echo 1 > /proc/sys/net/core/bpf_jit_enable
  # modprobe test_bpf test_name="BPF_MAXINSNS: exec all MSH"

This should produce multiple warnings from build_bimm() similar to:

  ------------[ cut here ]------------
  WARNING: CPU: 0 PID: 209 at arch/mips/mm/uasm-mips.c:210 build_insn+0x558/0x590
  Micro-assembler field overflow
  Modules linked in: test_bpf(+)
  CPU: 0 PID: 209 Comm: modprobe Not tainted 5.14.3 #1
  Stack : 00000000 807bb824 82b33c9c 801843c0 00000000 00000004 00000000 63c9b5ee
          82b33af4 80999898 80910000 80900000 82fd6030 00000001 82b33a98 82087180
          00000000 00000000 80873b28 00000000 000000fc 82b3394c 00000000 2e34312e
          6d6d6f43 809a180f 809a1836 6f6d203a 80900000 00000001 82b33bac 80900000
          00027f80 00000000 00000000 807bb824 00000000 804ed790 001cc317 00000001
  [...]
  Call Trace:
  [<80108f44>] show_stack+0x38/0x118
  [<807a7aac>] dump_stack_lvl+0x5c/0x7c
  [<807a4b3c>] __warn+0xcc/0x140
  [<807a4c3c>] warn_slowpath_fmt+0x8c/0xb8
  [<8011e198>] build_insn+0x558/0x590
  [<8011e358>] uasm_i_bne+0x20/0x2c
  [<80127b48>] build_body+0xa58/0x2a94
  [<80129c98>] bpf_jit_compile+0x114/0x1e4
  [<80613fc4>] bpf_prepare_filter+0x2ec/0x4e4
  [<8061423c>] bpf_prog_create+0x80/0xc4
  [<c0a006e4>] test_bpf_init+0x300/0xba8 [test_bpf]
  [<8010051c>] do_one_initcall+0x50/0x1d4
  [<801c5e54>] do_init_module+0x60/0x220
  [<801c8b20>] sys_finit_module+0xc4/0xfc
  [<801144d0>] syscall_common+0x34/0x58
  [...]
  ---[ end trace a287d9742503c645 ]---

Then the anomalous machine code executes:

=> 0xc0a18000:  addiu   sp,sp,-16
   0xc0a18004:  sw      s3,0(sp)
   0xc0a18008:  sw      s4,4(sp)
   0xc0a1800c:  sw      s5,8(sp)
   0xc0a18010:  sw      ra,12(sp)
   0xc0a18014:  move    s5,a0
   0xc0a18018:  move    s4,zero
   0xc0a1801c:  move    s3,zero

   # __BPF_STMT(BPF_LDX | BPF_B | BPF_MSH, 0)
   0xc0a18020:  lui     t6,0x8012
   0xc0a18024:  ori     t4,t6,0x9e14
   0xc0a18028:  li      a1,0
   0xc0a1802c:  jalr    t4
   0xc0a18030:  move    a0,s5
   0xc0a18034:  bnez    v0,0xc0a1ffb8           # incorrect branch offset
   0xc0a18038:  move    v0,zero
   0xc0a1803c:  andi    s4,s3,0xf
   0xc0a18040:  b       0xc0a18048
   0xc0a18044:  sll     s4,s4,0x2
   [...]

   # __BPF_STMT(BPF_LDX | BPF_B | BPF_MSH, 0)
   0xc0a1ffa0:  lui     t6,0x8012
   0xc0a1ffa4:  ori     t4,t6,0x9e14
   0xc0a1ffa8:  li      a1,0
   0xc0a1ffac:  jalr    t4
   0xc0a1ffb0:  move    a0,s5
   0xc0a1ffb4:  bnez    v0,0xc0a1ffb8           # incorrect branch offset
   0xc0a1ffb8:  move    v0,zero
   0xc0a1ffbc:  andi    s4,s3,0xf
   0xc0a1ffc0:  b       0xc0a1ffc8
   0xc0a1ffc4:  sll     s4,s4,0x2

   # __BPF_STMT(BPF_LDX | BPF_B | BPF_MSH, 0)
   0xc0a1ffc8:  lui     t6,0x8012
   0xc0a1ffcc:  ori     t4,t6,0x9e14
   0xc0a1ffd0:  li      a1,0
   0xc0a1ffd4:  jalr    t4
   0xc0a1ffd8:  move    a0,s5
   0xc0a1ffdc:  bnez    v0,0xc0a3ffb8           # correct branch offset
   0xc0a1ffe0:  move    v0,zero
   0xc0a1ffe4:  andi    s4,s3,0xf
   0xc0a1ffe8:  b       0xc0a1fff0
   0xc0a1ffec:  sll     s4,s4,0x2
   [...]

   # epilogue
   0xc0a3ffb8:  lw      s3,0(sp)
   0xc0a3ffbc:  lw      s4,4(sp)
   0xc0a3ffc0:  lw      s5,8(sp)
   0xc0a3ffc4:  lw      ra,12(sp)
   0xc0a3ffc8:  addiu   sp,sp,16
   0xc0a3ffcc:  jr      ra
   0xc0a3ffd0:  nop

To mitigate this issue, we assert the branch ranges for each emit call
that could generate an out-of-range branch.

Fixes: 36366e367ee9 ("MIPS: BPF: Restore MIPS32 cBPF JIT")
Fixes: c6610de353da ("MIPS: net: Add BPF JIT")
Signed-off-by: Piotr Krysiuk <piotras@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Tested-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
Acked-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
Cc: Paul Burton <paulburton@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Link: https://lore.kernel.org/bpf/20210915160437.4080-1-piotras@gmail.com
[OP: small context adjustment for 4.14]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
Note: the testcase mentioned in the commit message passes in qemu with this fix
applied and fails (generates multiple warnings from build_bimm()) without the
fix.

Before:
root@qemumips:~# echo 1 > /proc/sys/net/core/bpf_jit_enable
root@qemumips:~# modprobe test_bpf test_name="BPF_MAXINSNS: exec all MSH"
[  106.405628] test_bpf: #299 BPF_MAXINSNS: exec all MSH 
[  106.407671] ------------[ cut here ]------------
[  106.411772] WARNING: CPU: 0 PID: 177 at arch/mips/mm/uasm-mips.c:196 build_insn+0x3cc/0x4c0
[  106.426688] Micro-assembler field overflow
[  106.427631] Modules linked in: test_bpf(+)
[  106.429041] CPU: 0 PID: 177 Comm: modprobe Not tainted 4.14.249-yocto-standard+ #3
[  106.430737] Stack : 00000000 00000000 00000000 00000046 1000a400 80190cc0 00000000 00000000
[  106.432484]         80b00000 0000000b 80c240d4 84a1da7c 80c1b63c 1000a400 84a1da18 ffffffff
[  106.435603]         00000000 00000000 80e00000 806d50ac 00000000 00000000 00000000 0000ffff
[  106.436958]         00000000 00000000 00000001 0000010c 00000000 1000a401 80000000 84a1db38
[  106.438381]         00000000 000000c4 80131ef4 00000000 00000000 806d4218 0018a617 0018a657
[  106.439802]         ...
[  106.440736] Call Trace:
[  106.441688] [<8010d520>] show_stack+0x94/0x154
[  106.443072] [<80a69edc>] dump_stack+0xa0/0xcc
[  106.444338] [<80136050>] __warn+0xd8/0x11c
[  106.447240] [<801360c8>] warn_slowpath_fmt+0x34/0x40
[  106.448389] [<80122d3c>] build_insn+0x3cc/0x4c0
[  106.449360] [<80122f84>] uasm_i_bne+0x1c/0x28
[  106.450256] [<80130fe8>] build_body+0x2be8/0x321c
[  106.513233] [<80131db8>] bpf_jit_compile+0x104/0x1cc
[  106.568537] [<808fa0cc>] bpf_prepare_filter+0x294/0x464
[  106.623162] [<808fa318>] bpf_prog_create+0x7c/0xbc
[  106.676441] [<c061a2c8>] test_bpf_init+0x2c8/0x91c [test_bpf]
[  106.729250] [<8010050c>] do_one_initcall+0x44/0x188
[  106.783082] [<801caac8>] do_init_module+0x68/0x21c
[  106.836401] [<801ccd64>] load_module+0x2058/0x2764
[  106.888906] [<801cd6ac>] SyS_finit_module+0xc8/0xe8
[  106.941491] [<801162a4>] syscall_common+0x34/0x58
[  107.045016] ---[ end trace 40ab5871d8f30921 ]---
[  107.098115] ------------[ cut here ]------------

After:
root@qemumips:~# modprobe test_bpf test_name="BPF_MAXINSNS: exec all MSH"
[  441.097217] test_bpf: #299 BPF_MAXINSNS: exec all MSH jited:0 452628 PASS
[  445.630459] test_bpf: Summary: 1 PASSED, 0 FAILED, [0/1 JIT'ed]

 arch/mips/net/bpf_jit.c | 57 +++++++++++++++++++++++++++++++----------
 1 file changed, 43 insertions(+), 14 deletions(-)

diff --git a/arch/mips/net/bpf_jit.c b/arch/mips/net/bpf_jit.c
index 4d8cb9bb8365..43e6597c720c 100644
--- a/arch/mips/net/bpf_jit.c
+++ b/arch/mips/net/bpf_jit.c
@@ -662,6 +662,11 @@ static void build_epilogue(struct jit_ctx *ctx)
 	((int)K < 0 ? ((int)K >= SKF_LL_OFF ? func##_negative : func) : \
 	 func##_positive)
 
+static bool is_bad_offset(int b_off)
+{
+	return b_off > 0x1ffff || b_off < -0x20000;
+}
+
 static int build_body(struct jit_ctx *ctx)
 {
 	const struct bpf_prog *prog = ctx->skf;
@@ -728,7 +733,10 @@ static int build_body(struct jit_ctx *ctx)
 			/* Load return register on DS for failures */
 			emit_reg_move(r_ret, r_zero, ctx);
 			/* Return with error */
-			emit_b(b_imm(prog->len, ctx), ctx);
+			b_off = b_imm(prog->len, ctx);
+			if (is_bad_offset(b_off))
+				return -E2BIG;
+			emit_b(b_off, ctx);
 			emit_nop(ctx);
 			break;
 		case BPF_LD | BPF_W | BPF_IND:
@@ -775,8 +783,10 @@ static int build_body(struct jit_ctx *ctx)
 			emit_jalr(MIPS_R_RA, r_s0, ctx);
 			emit_reg_move(MIPS_R_A0, r_skb, ctx); /* delay slot */
 			/* Check the error value */
-			emit_bcond(MIPS_COND_NE, r_ret, 0,
-				   b_imm(prog->len, ctx), ctx);
+			b_off = b_imm(prog->len, ctx);
+			if (is_bad_offset(b_off))
+				return -E2BIG;
+			emit_bcond(MIPS_COND_NE, r_ret, 0, b_off, ctx);
 			emit_reg_move(r_ret, r_zero, ctx);
 			/* We are good */
 			/* X <- P[1:K] & 0xf */
@@ -855,8 +865,10 @@ static int build_body(struct jit_ctx *ctx)
 			/* A /= X */
 			ctx->flags |= SEEN_X | SEEN_A;
 			/* Check if r_X is zero */
-			emit_bcond(MIPS_COND_EQ, r_X, r_zero,
-				   b_imm(prog->len, ctx), ctx);
+			b_off = b_imm(prog->len, ctx);
+			if (is_bad_offset(b_off))
+				return -E2BIG;
+			emit_bcond(MIPS_COND_EQ, r_X, r_zero, b_off, ctx);
 			emit_load_imm(r_ret, 0, ctx); /* delay slot */
 			emit_div(r_A, r_X, ctx);
 			break;
@@ -864,8 +876,10 @@ static int build_body(struct jit_ctx *ctx)
 			/* A %= X */
 			ctx->flags |= SEEN_X | SEEN_A;
 			/* Check if r_X is zero */
-			emit_bcond(MIPS_COND_EQ, r_X, r_zero,
-				   b_imm(prog->len, ctx), ctx);
+			b_off = b_imm(prog->len, ctx);
+			if (is_bad_offset(b_off))
+				return -E2BIG;
+			emit_bcond(MIPS_COND_EQ, r_X, r_zero, b_off, ctx);
 			emit_load_imm(r_ret, 0, ctx); /* delay slot */
 			emit_mod(r_A, r_X, ctx);
 			break;
@@ -926,7 +940,10 @@ static int build_body(struct jit_ctx *ctx)
 			break;
 		case BPF_JMP | BPF_JA:
 			/* pc += K */
-			emit_b(b_imm(i + k + 1, ctx), ctx);
+			b_off = b_imm(i + k + 1, ctx);
+			if (is_bad_offset(b_off))
+				return -E2BIG;
+			emit_b(b_off, ctx);
 			emit_nop(ctx);
 			break;
 		case BPF_JMP | BPF_JEQ | BPF_K:
@@ -1056,12 +1073,16 @@ static int build_body(struct jit_ctx *ctx)
 			break;
 		case BPF_RET | BPF_A:
 			ctx->flags |= SEEN_A;
-			if (i != prog->len - 1)
+			if (i != prog->len - 1) {
 				/*
 				 * If this is not the last instruction
 				 * then jump to the epilogue
 				 */
-				emit_b(b_imm(prog->len, ctx), ctx);
+				b_off = b_imm(prog->len, ctx);
+				if (is_bad_offset(b_off))
+					return -E2BIG;
+				emit_b(b_off, ctx);
+			}
 			emit_reg_move(r_ret, r_A, ctx); /* delay slot */
 			break;
 		case BPF_RET | BPF_K:
@@ -1075,7 +1096,10 @@ static int build_body(struct jit_ctx *ctx)
 				 * If this is not the last instruction
 				 * then jump to the epilogue
 				 */
-				emit_b(b_imm(prog->len, ctx), ctx);
+				b_off = b_imm(prog->len, ctx);
+				if (is_bad_offset(b_off))
+					return -E2BIG;
+				emit_b(b_off, ctx);
 				emit_nop(ctx);
 			}
 			break;
@@ -1133,8 +1157,10 @@ static int build_body(struct jit_ctx *ctx)
 			/* Load *dev pointer */
 			emit_load_ptr(r_s0, r_skb, off, ctx);
 			/* error (0) in the delay slot */
-			emit_bcond(MIPS_COND_EQ, r_s0, r_zero,
-				   b_imm(prog->len, ctx), ctx);
+			b_off = b_imm(prog->len, ctx);
+			if (is_bad_offset(b_off))
+				return -E2BIG;
+			emit_bcond(MIPS_COND_EQ, r_s0, r_zero, b_off, ctx);
 			emit_reg_move(r_ret, r_zero, ctx);
 			if (code == (BPF_ANC | SKF_AD_IFINDEX)) {
 				BUILD_BUG_ON(FIELD_SIZEOF(struct net_device, ifindex) != 4);
@@ -1244,7 +1270,10 @@ void bpf_jit_compile(struct bpf_prog *fp)
 
 	/* Generate the actual JIT code */
 	build_prologue(&ctx);
-	build_body(&ctx);
+	if (build_body(&ctx)) {
+		module_memfree(ctx.target);
+		goto out;
+	}
 	build_epilogue(&ctx);
 
 	/* Update the icache */
-- 
2.25.1

