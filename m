Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8AD426C02
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 15:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233971AbhJHNyx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 09:54:53 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:46474 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233133AbhJHNyw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Oct 2021 09:54:52 -0400
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 198CCYJm022313;
        Fri, 8 Oct 2021 06:52:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=k6gj1ZwwD1p/JHr3twldnYQK/44iIhHRLaLjfijijFk=;
 b=GN+peCZp/2xgo+O6LlwHIqS/f8w8zj7rzZVIW3pDKTFKTvUx57tBM432ofw0TtjUzbjA
 U9vgpkSKqr4d3Q0zsuKftpXYdAAxkHDqEWiItTsa06RJeWB27EJ0RCZKLxbeFlmvfcsd
 zbXifhsbXlkvxFNejel/6FXT+6RKkRqUCkIwrGCfDn0WZJLJDc0ZX5o1rYiknkNyujB5
 cqyR1ev04d/qs0fVFyICAm4PjbBZv0wWr8ACmTNktPYEJz7/mbykwC+w9QRcJ3omosux
 2V3bmuXgm1GOWa5sWGrwIAG3PDperllBhjopEx5pXObYRP782NsA+g1ne88EhLLnN1kA 7g== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by mx0a-0064b401.pphosted.com with ESMTP id 3bhx4n9837-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Oct 2021 06:52:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QjiCHHics6nd9vbh1CaP+4tS+qR5aEjHQQWv8YzYrhatEZ1MFknWzzvrH2Wk71hb5RYvfDuKgl1vnLgR3jPX866mXq/cN2SzKiu7JpCXPstcuW64UlqiHsy12SLjyLMiier3/y4zoZJMIi5GJxV9LGtTsnPNCwkkSHxevyuIz5EBV/8SXF+ZPpUt9Aom4bNkONnJDPctdNtRqzcW+lswadvhIHZhapHdUVTIELdKxiEF02GzZMwlGLy9acl/9n+H+LDTwoLHZje0WstJ7+ZEh6d6iBIuCNlMSeSx8d7fneg+kF74QtU3rsxuDGnIkYCroEtxvtVwSUj8kEKQ8r/w7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k6gj1ZwwD1p/JHr3twldnYQK/44iIhHRLaLjfijijFk=;
 b=oWJx0t7bIaP27+8VHGgiRIwtp24T7aeUO8fNEKWuPYkYVLMw3qxs43sM7meXWTisH8xA94RlU/2CnA/plvLNmeBCUfYlDXZcRRstpERkpMqqJPP0bO/aIaGNMv+K4fZ82cW7eQA7g13dzko3hJj3m3LEb2ARfOB7U/0wbwIm9zDFHAUWOnj/83WWwuI15IS8IK/BtLMyr+Hydu+5BMIIFP8U/ujzvjq4RQzHDzwXTA8hpuZAeBcCeM3S5WyN7aFQFfVtOLnlGIuZz0CZg8SkhKwXr0eUze8Kkyc9xKmO8IrWhb7RQrIXyxOszwqcXMgJLElSjFC/VQEyyjvz+iS6mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM5PR11MB2059.namprd11.prod.outlook.com (2603:10b6:3:8::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4566.20; Fri, 8 Oct 2021 13:52:38 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::3d20:a9f3:70c4:f286]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::3d20:a9f3:70c4:f286%5]) with mapi id 15.20.4587.022; Fri, 8 Oct 2021
 13:52:38 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     piotras@gmail.com, paulburton@kernel.org, daniel@iogearbox.net,
        johan.almbladh@anyfinetworks.com
Subject: [PATCH 5.4 2/2] bpf, mips: Validate conditional branch offsets
Date:   Fri,  8 Oct 2021 16:50:59 +0300
Message-Id: <20211008135059.1114363-3-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211008135059.1114363-1-ovidiu.panait@windriver.com>
References: <20211008135059.1114363-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0401CA0008.eurprd04.prod.outlook.com
 (2603:10a6:800:4a::18) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR0401CA0008.eurprd04.prod.outlook.com (2603:10a6:800:4a::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18 via Frontend Transport; Fri, 8 Oct 2021 13:52:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5829ec14-e999-4700-431e-08d98a62e38a
X-MS-TrafficTypeDiagnostic: DM5PR11MB2059:
X-Microsoft-Antispam-PRVS: <DM5PR11MB2059C976F005F9D0CA8F18DFFEB29@DM5PR11MB2059.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:181;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pf2vc1H6RreDDQxTVdsk+vyBVJS/BDlsaonoxc1hdhc0r3VdRh7a4Ah2uWkyi0g2lXKsv7eX9ULffIvEypkTXUDts2Kn8uu7hF+joCZryodh3j9xrjbhjGzViEY6teZwCY7havFnYDF7/+hsu3IINaTp6fSeyhgpcKmMQAf4IcjN8x1pJoNKj7qf+41vH7HojH30f8cOeEavP5YGJXxGqKeBXDwXSRDRmJiKHdAmwuSJwS3wnsrXZyJcg+2g6NmuNYQaa+aMrUxz5IXufah/TPPi5XYZUAAjnw0Ar1hxAr0rbAeplzbNIgtkyUpHlN1P8pQF0+2AUQrMBnKzcFowrw7UP+act9iYF6qTnmequ65mj7B007JAmv5dEnm9kWUISrfGp0pBcPDxvo6sj3F4NXYPqHgs9tXOw12Oq2DaboFpLm96MTi6uFDZ69J6BZOihrq+9/ECzi56dDOxoFibhRiQ81mPYY2TaiMmPEUMdq6VYLqTH1pZsYTr7CAdzzkituBvKPx/AyUbWjgCsWETWXZJI7SF5GjnkFAYARLfV1Dki2hfVuhdNM6lWIC3L2r/veeUrvPDU2F1Hufv2s3lL13qNqKH9NCWMlPtnIwQBgrtFIxQSUrngrmE57KVI0IM6wn6HsaNbv1P5zm9+oO0Cg0ke5Pzb7Z2SVBDJz5hS0qez9s5oKRnEs14TPbijEzn4IHwpx6MqVlLJnZJrk9nYXAkeC1K0ANijYXxjj5xo9s2E11ugGam4ZUeMCZ12Rp+hYvdygAjk1AXNNMIU+ZICVHu+Aezqcs8VfBD4UK2GFA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(66476007)(6486002)(66556008)(8676002)(66946007)(38100700002)(956004)(6506007)(2616005)(38350700002)(1076003)(316002)(45080400002)(508600001)(52116002)(966005)(5660300002)(44832011)(6512007)(8936002)(83380400001)(36756003)(2906002)(15650500001)(6666004)(6916009)(186003)(26005)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oqmT3YIdy4hT7DCYYnk6GnEakY3YB8wpUYm8aqhO7v5QGiNaOwzt0RZT4+Xq?=
 =?us-ascii?Q?9Dy/fKiN8CAwP1k9z1MCdA/9nnPv4dGS+PB2ceW2RqRIslEaNd1+dtG7h1Ls?=
 =?us-ascii?Q?sEdGlJ+ENYNeLGqScTsrMErN0+zmnydIf9DEkvmztuh5V/w7/D40HKFLD1jo?=
 =?us-ascii?Q?mBYXmwdRLXCoMvLK12O911XWIj9kb/Id+AWC4SO1DwiJk00FoH5o1zBYK4+T?=
 =?us-ascii?Q?RRg8+QXDNujMzV4zj4G7hspWI2bhV/DZjFoezrKDOJMWf7BdlQ5CNCfrPWBL?=
 =?us-ascii?Q?Rs4nFup8W4ZkOcPpwIt/xqMQ9sypLc/4I/tIj2/DZVNgbegx45NgKuRpV8tu?=
 =?us-ascii?Q?lKJnXFYdRFQhNAbQF+6PZ4XPo+WohH/oNkAzyoF9JloVPooMyDBIVhdFEr6Y?=
 =?us-ascii?Q?T0sx9EGtikCGnUaK4X9TjxlrsP2GM3njDa30L4M0R/BP3lXh+oqtc3aB8/ZC?=
 =?us-ascii?Q?Yi5/oty6eNFiLbaPR6mS2j2cNJPmcfh0Lc9G04hE69/P8F2WIpgLReJj9hAO?=
 =?us-ascii?Q?DJYPba19W50Ggz+MUkY+gUlwh6+A7jf1jPJOlk2B1iH7jQBFMkA4O6uOojHz?=
 =?us-ascii?Q?fD5n9ZtO/rgncbXbqiuLqyNof8RLEZDUeKAwNU5zjBz9rh3S5YzOAqYve6BC?=
 =?us-ascii?Q?AKklfdiGsyrTV0ByMAcNeIfTcyVKzmh4uhzYIcePWGXc3Gi4bfuPmW4Fpz75?=
 =?us-ascii?Q?EOLmUGQ8HwAY/wBLZ1znypSlYAW5DSB7juPYG4ne8gTu4RCA0QuyWn+g+NIW?=
 =?us-ascii?Q?P/sTTzLFWm+6Mn5dQrImOjA6vFgmaHwiS1u0UUEZxDq2S9BuMNEI3BUww99M?=
 =?us-ascii?Q?ua7qszfHarHXe99VeUvBaccX1MmKn0L0Vz7C1HQvV6nTCoJf3qJd0LlfdC/3?=
 =?us-ascii?Q?k21ahDrB3TDdIwyVQqhVLiwZTEUZ8lLAPtH1PHBCRAoy+ecRi2sbnZoG8v7Z?=
 =?us-ascii?Q?bzU5z/MetQ+fKmgSiLRhfYwNaXkybj0GG8dMRjE4E6Kzfb1Ix/HCMBe+6YKN?=
 =?us-ascii?Q?bt8HK5IEwYpJyHOml3VXqKVahl4LfqAEgGaEzWIIdyT9eQ1Eh6sYpA9jT1y1?=
 =?us-ascii?Q?XEbtE/Dt4p/pXGtLZHeiiD3NMNHBM/aAfZ6istYKQiED+i/1Sgq4jfogZ8D7?=
 =?us-ascii?Q?5MiHnFTI/fXzswPq9a/NF9epVj28GBiJuhAZSjdVD94gBj7irg6/yLyfS+v7?=
 =?us-ascii?Q?xHnxww35JvG261d2709aZwLRIGrnWXB9x8pFDhXVGkVMMOtpXABK73Sqmgrs?=
 =?us-ascii?Q?3hCnE0TMn+YhYK0bXEJpTDQDGqHAG/PljV7CLHMfc8EhNmzLkvJq7Og3bAw/?=
 =?us-ascii?Q?Fl9n3SEhl54slFI7gE7j66Le?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5829ec14-e999-4700-431e-08d98a62e38a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2021 13:52:38.2953
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BN2RE6eefVa59cGGaG1q2aajDp0NSqCUNZ76eGWyBOVq+smmIyRadP5gMyJneVy8PzDJz3Tf5YTzsgppFGREWOu5B9hyrQ7ikf5GISjHrC8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB2059
X-Proofpoint-ORIG-GUID: IaOG0QD8dKIphmiLIXhFFz56S1d4rp3N
X-Proofpoint-GUID: IaOG0QD8dKIphmiLIXhFFz56S1d4rp3N
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-08_04,2021-10-07_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 impostorscore=0 clxscore=1015 bulkscore=0 spamscore=0
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110080083
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
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 arch/mips/net/bpf_jit.c | 57 +++++++++++++++++++++++++++++++----------
 1 file changed, 43 insertions(+), 14 deletions(-)

diff --git a/arch/mips/net/bpf_jit.c b/arch/mips/net/bpf_jit.c
index 3a0e34f4e615..29a288ff4f18 100644
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

