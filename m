Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDF6B426D56
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 17:15:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242778AbhJHPRD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 11:17:03 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:55186 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242715AbhJHPRD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Oct 2021 11:17:03 -0400
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 198Bf9xP030973;
        Fri, 8 Oct 2021 15:14:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=FTPxULYvZdu7s19zU8cvRhTSIwhUObCdxE9ncpE6cMw=;
 b=Xf/KxA91Zz+QDyZciF3rWAE2RYQYrBl0sDbPGJ9nurYrmMJWcyQ5K/AVs01k11Sdhw+G
 72qYkmLMjzVpAJEWku9B5+xNRViIyHcOAQ8oweiuVF8uT8S9MNOOLlqM5jfpSANdytwN
 Z6dH2d9+9e35b9kGo4a1BWtMqPGntc6KF58D4UliDiCNhkjL+eISdVhrIAMrt8TfX6kI
 x+Kdqwc1nCwV1b1OqJL2/tXnEBfwstjTCclP3+RSzAJfue/NSjQbXyIryJ0kQhpMbJ29
 kng0aOcVwURK6lfKWX59JNaXAkShwB25MBNb0H7ppU4+L3J/FXmIfJV9Nqr3xAHbUWkq hw== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by mx0a-0064b401.pphosted.com with ESMTP id 3bjdt9gg2g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Oct 2021 15:14:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZYjUjgDZdUDLEbRR6xOTfh3aHS1jGYEA/ti/aENV2ePdLUX92LP5VPFYnnRxk73FVB+b4RzT1yCYXM8c9pY8YfvSm8FKm1SxkBvnbDhevAx8kxkC7rxBPCo5Ailp49bGghQRZOfn2Baa4ogeFchlkcV9mjAFz8NyZEvxvVclmESUAqhtZ+3xORK8GGkGtRFgQajbdAsdo9syliYb26sGFLnjTic3jzNbXXEM9xE/fxpIvCK+rC+pKw4/m3+aMsQjJ/vTbrZyYOw+DXIMCfil87Q15kURzVnPyeGUtGUQChJkffZSCrcVClO6Kyms4rtcGmXgWORkweMYIh7gbFBsog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FTPxULYvZdu7s19zU8cvRhTSIwhUObCdxE9ncpE6cMw=;
 b=aYsBlcYkhR/7br3ohTo4wVfJvofDYoen2HNLnnc6i9t1hFUdJjZjdjhB2SCl5iwTdNDhpeGcyqJd5Jkh1HJ8T3Okldf52UOlAYvpU+Kdcr7EClzldShjk6Lgie3yiqPAktNx0p6WuY7fQV9qok/TeP3wrskmnt7bi2rVQ2g/AU5zAtItC0AtnAJOYLBsIqHI7Ckcd3JJ0cqL1IN++0U1z21ykROctzsHK3EaR3KwixTaB/ceydKG1MViEaCQRIzn3LbCiyFIV44oYucQapX5OFVptRbAN1cYXOcW7cOLLp8k24PLqkGHMunO1mS0ceifiokCGuRM91kiLQQ7rKnHIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB3211.namprd11.prod.outlook.com (2603:10b6:5:58::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22; Fri, 8 Oct
 2021 15:14:48 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::3d20:a9f3:70c4:f286]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::3d20:a9f3:70c4:f286%5]) with mapi id 15.20.4587.022; Fri, 8 Oct 2021
 15:14:47 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     piotras@gmail.com, daniel@iogearbox.net,
        johan.almbladh@anyfinetworks.com
Subject: [PATCH 4.19 1/1] bpf, mips: Validate conditional branch offsets
Date:   Fri,  8 Oct 2021 18:14:12 +0300
Message-Id: <20211008151412.1186343-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0312.eurprd07.prod.outlook.com
 (2603:10a6:800:130::40) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR07CA0312.eurprd07.prod.outlook.com (2603:10a6:800:130::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.13 via Frontend Transport; Fri, 8 Oct 2021 15:14:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 22b6c6d8-9dd7-46f8-0ec3-08d98a6e5dca
X-MS-TrafficTypeDiagnostic: DM6PR11MB3211:
X-Microsoft-Antispam-PRVS: <DM6PR11MB32118000A4A7E02EEDBF1A25FEB29@DM6PR11MB3211.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:181;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AT2EaZ0N/Lti7ACHewgNwsjtM6Iaxt5a8DlScMxFnvI+H/OphU9oO3VFX6HI/Lq33JdxXwIBa4A+AoxgiBL2MTCqcVa3k/XNDMuF4mdQPf4enIw/JmiH4kwHkXdbD4yMToiBmkuDnF2mkO2M2zd5HywPbnkToAlJCEAyIumWuhAG11KXWr18E/LjaBtH81kDsJDpckSMS8Ihrq+qei19MYBLd4kY++PgUkY9xu8M0XHH805oARicyQpaB1DzYFiyhPw3JDYl84Uyl8HhJMetQqM2OwwplR2juet76z1e1GnnxhJiPckqP+/LLrQt7inyiFkz54ueqaBt67xu8lqJdMHIDjzkDw65EGKFwE0H1cgWXY7zkph5GevpgP2eUPTTF25oUvSFYFI5hGx/YVyYbPJ7u5lcY/6WRv/vUFDGw8xjHxlqLORbViLlDcXqDnjIFxtj6g0rJbLVOw1UZPRdFQahi5DoTG8sBcToHimOQh3zkGdCyw2Q49kv9CQAOJ44ehWQTXPVlGvVQlUXSXjgBUNO3mu9I3tfnaysM6wQlA88jtO4tdEavJNB4Vo8fOV0ZPjCGn6PnZChfx7ONS2XL9IlBz0dv8wYcteS0eN4zG/2vgLjzTDY2o2TgfOoaWGliFSPITvdoReUivJ2cVjoApImy72wRs6UUMKHaPkDuiS5AogPRqCX8va+i6QYQr5mQVhB7uGlc6QzzN12xrgAK5bBZYd+ZHHeyWV3Txt1gYuVHp+sYlVNHAElvA/pIbxjrbrZ+v6HXx+CJBdVYJE2GxZoxpj0GLUvbQRHBGSjKBE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(508600001)(8936002)(6512007)(44832011)(30864003)(26005)(6666004)(52116002)(45080400002)(4326008)(38100700002)(8676002)(6506007)(38350700002)(5660300002)(966005)(956004)(15650500001)(66946007)(83380400001)(66476007)(316002)(6916009)(86362001)(36756003)(2906002)(6486002)(186003)(1076003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uNDsIAlU0112z/k7w0bPf0SpsbcuQLQe6tZxV3d4Q4Lz8q7edR2mzrxXKbY6?=
 =?us-ascii?Q?Mo5ShB7Jm9wR/pGuSLOE1sDHbeC6AHvRBWxPM29lSFP0JALDyOCEnwtFT98m?=
 =?us-ascii?Q?JCZT4bbiuF5mkwcs+lx/Ijhk2nAOiDI4Ma1CfEtZKBQQmmnuR1XQ9tlj0lJA?=
 =?us-ascii?Q?PIQ9b4uo/K6M5QqM3Fte3FgJ3sEHHpWXYUSy/jWD0VLmpTEPNzJ/qs+B38+e?=
 =?us-ascii?Q?poWnZmRtDbVIOzwBzHmywt4DSC1XoeA6euGtU+6TjRu33IQCymhrH4M8oWbo?=
 =?us-ascii?Q?EA0JZ48SdTihJiDMvHxrWlOdS/6AESr3FshIS9KTMGNmuSc+CaaxkMNlqVD4?=
 =?us-ascii?Q?c4aqmqCeuc3Ijw/BKeBbxwuOERXtbXwhn5O8h3CZlfvMjNd7EgCREzeCg15w?=
 =?us-ascii?Q?5d74kFTP5HvCdj4fQa2+9d9Gp4ZGD7IrPCRvIruVSnPGzYCd5LQBrcBHPrXv?=
 =?us-ascii?Q?7sFK0bfWZl4B467KEUMwEGGiuPlA3j1NHCNyA9qKDszGHF73Al4MqYFdTy87?=
 =?us-ascii?Q?YWE9T00MoSjp4Ns4dV0G9hzhL/jiLOwa9iu7KGPQCZCONvNy6nRIDhme9jxQ?=
 =?us-ascii?Q?tAKCiqS3+Y+vb88c5WkCvHl1QcG+kUr/vFeUZ/r7nt861dURr7YLca2wmRxl?=
 =?us-ascii?Q?YHdOlA6IUCkJTZz73kkXzFFPaeTiPTRA/NYkjKM7xqSd9RGlzRS8AzAC1n8w?=
 =?us-ascii?Q?KqbhMiZYtqVRHej2w/eklE6ghXcveIcddtL9AfH2EaaTdG7st0Fkp5utFMTX?=
 =?us-ascii?Q?Ay6rnCcLqbOOQeic9Ig7YwTz+kqxt9NMU1IEyDghJr1KtW4UMBxpXy220mRy?=
 =?us-ascii?Q?xG9qaqLphBypfvfpcKjxLKy/MQNMIvP3wgi7ur6Pql+BqcvtGXVP03GBHTfc?=
 =?us-ascii?Q?n1ZlCRBw/yc8tPqQbpFpzQrPax9Qr9xqkaVUrhJVAopaRlh5TsAm4I5agW7k?=
 =?us-ascii?Q?bQieWo3thG5NhAqBsWnVVUmBRJBw0Wfy75UmD54N/WBD0BgCuFdaqOneOlDB?=
 =?us-ascii?Q?9ckAMivPAgByqVjWxwCALkFx/MOFK1GowQ20zXlkzQ8kDZP/8eGCdKWq4doG?=
 =?us-ascii?Q?+EqseLa4xe2tBezQw7IT5137KPo7C6+OujlHDRsF5a1f22+jaFqFBTWb+is4?=
 =?us-ascii?Q?yLVOXjiexWJyIXm1vQ1NTtUzMa23IwauVcJi99G+D4DiG4DN9TzhagwPuS7M?=
 =?us-ascii?Q?v+UlyuihV+Ef02pwdO95J6J9j9DFeenP44gCR0wa6m2Mh7zYsApke16mrLG9?=
 =?us-ascii?Q?EsIzSZl/9okGLWL22mRERu30Z0ERlharz1pB6ltmRM6MNqQGcYQe+IrsD2uY?=
 =?us-ascii?Q?iFK7okSjtddUj5ZPTCaM6DHF?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22b6c6d8-9dd7-46f8-0ec3-08d98a6e5dca
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2021 15:14:47.7559
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: luVOSdVWZT2dAsVseeIjKpiPmSJYMx4lYRtvBh5zQ5GRNbVL5dHU5gWWdklGfAuVNjo+yjNVEfnqRIzxmwWjVVj+o1wi1qT98z3mVGNeBw0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3211
X-Proofpoint-GUID: ow6x3Wg2Anm-UxhiP3SGUBhC6p3ci2Qe
X-Proofpoint-ORIG-GUID: ow6x3Wg2Anm-UxhiP3SGUBhC6p3ci2Qe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-08_04,2021-10-07_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 mlxlogscore=999 suspectscore=0 adultscore=0 phishscore=0
 lowpriorityscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109230001 definitions=main-2110080090
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
[OP: small context adjustment for 4.19]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
Note: the testcase mentioned in the commit message passes in qemu with this fix
applied and fails (generates multiple warnings from build_bimm()) without the
fix.

Before:
root@qemumips:~# echo 1 > /proc/sys/net/core/bpf_jit_enable
root@qemumips:~# modprobe test_bpf test_name="BPF_MAXINSNS: exec all MSH"
[  129.474022] test_bpf: #296 BPF_MAXINSNS: exec all MSH
[  129.476108] ------------[ cut here ]------------
[  129.480530] WARNING: CPU: 0 PID: 184 at arch/mips/mm/uasm-mips.c:195 build_insn+0x3f0/0x4ec
[  129.482259] Micro-assembler field overflow
[  129.483528] Modules linked in: test_bpf(+)
[  129.499989] CPU: 0 PID: 184 Comm: modprobe Not tainted 4.19.208-yocto-standard #4
[  129.501999] Stack : 00000000 1000a400 00000000 80ed0000 0000010a 00000045 0000010b 801993b8
[  129.503344]         80bc0000 0000000b 00000000 00000000 80d65798 1000a400 8bc65978 ffffffff
[  129.504720]         00000000 00000000 80f70000 0000010b 00000000 00000000 00000000 0000ffff
[  129.506135]         00000000 00000000 00000001 0000010b 00000000 80dc0000 00000000 80000000
[  129.507885]         80dc0000 00000000 c0699000 80dc0000 00000000 8073b878 003abd97 00358717
[  129.509685]         ...
[  129.511000] Call Trace:
[  129.513853] [<8010e744>] show_stack+0xb4/0x17c
[  129.515100] [<80b1b198>] dump_stack+0xa0/0xcc
[  129.516063] [<80b14a88>] __warn.part.0+0xc0/0xe8
[  129.517093] [<80b14b1c>] warn_slowpath_fmt+0x6c/0x98
[  129.518133] [<80122760>] build_insn+0x3f0/0x4ec
[  129.519179] [<801229b0>] uasm_i_bne+0x1c/0x28
[  129.520242] [<8013131c>] build_body+0x2bbc/0x3200
[  129.581758] [<80132128>] bpf_jit_compile+0x118/0x1e8
[  129.636529] [<80986f60>] bpf_prepare_filter+0x2b4/0x46c
[  129.690051] [<80987198>] bpf_prog_create+0x80/0xc0
[  129.742493] [<c06962dc>] test_bpf_init+0x2dc/0x1000 [test_bpf]
[  129.794190] [<80100e94>] do_one_initcall+0x54/0x2a0
[  129.846842] [<801d7b44>] do_init_module+0x68/0x21c
[  129.898433] [<801d9f50>] load_module+0x21c8/0x2818
[  129.949496] [<801da80c>] sys_finit_module+0xe8/0x100
[  130.001439] [<80117444>] syscall_common+0x34/0x58
[  130.099050] ---[ end trace 52e4980fae45d52d ]---
[  130.147433] ------------[ cut here ]------------

After:
root@qemumips:~# echo 1 > /proc/sys/net/core/bpf_jit_enable
root@qemumips:~# modprobe test_bpf test_name="BPF_MAXINSNS: exec all MSH"
[   88.499931] test_bpf: #296 BPF_MAXINSNS: exec all MSH jited:0 1017092 PASS
[   89.526981] test_bpf: Summary: 1 PASSED, 0 FAILED, [0/1 JIT'ed]

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

