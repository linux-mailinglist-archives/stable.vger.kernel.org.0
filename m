Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD3C426C01
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 15:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233149AbhJHNyw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 09:54:52 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:55758 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233133AbhJHNyv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Oct 2021 09:54:51 -0400
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 198D3Twa023897;
        Fri, 8 Oct 2021 13:52:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=or3rIdpqmILnPwf7xo0/+TEmq3dUA8vF5D6EnUAhBU4=;
 b=KT2jc9WFOgX7+N2vZZUevyBsrXg94S8aYxlXvMIN8b/5wsM5kZg32s5eFTD9EZPd/Jc8
 qUjL/u1o+h37qEE0G/m8y00vh1Byz68oQhkQtCDGSm4oVmcY1D/FlUbXAD2qrT3afVOZ
 eCbr/9lftbo+hAHtKpGwUK+Bp+9P9PFOawkilsmusPcVJPHM+tDuOMVe+MUXwI9QD/ey
 AwBdXSIf5aoCTNe5wRVIepipdsghfaaeLEzIZwNfjOS/OUmcW6FEe+A7RrXjo8d/35bV
 9benqRJlPlkf3dAumRngufZJi+GLHFeIh1J+1+L00OME4Sm2/gA9aH51N1/1UJHCyuyA Wg== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by mx0a-0064b401.pphosted.com with ESMTP id 3bj9sdgk0b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Oct 2021 13:52:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c6TOhs2aNqQ959jN7H2YgVDMawQZ3haQYjFwZyX4sdkUNo1gd4Z0o8jF23mOG8WWFOHF2IF+wYYmAnQJM1l/QHDh8JBVymLn4xQ2IWzyMwDihICc1tghQBtWXflv0lqwBTrjEJqc4ycY4mDHvbRXTTO17bwZwt2lJvwSDyaS5GywWINimGBhKS28Nl9kx/BwUIdM9zn5E7+RZGv+WRcDbKXoqWE14Qcpi61wP24IeMuVVbnb2tC2eQV1ks5Ng7nhDteNIGwrpwkv9HuRLeWvqfqLKUmlTveaj83ucw1yfeGaASlOf210Q1ReC0BFHpeTXp2GNvc2WalAbr6itESvLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=or3rIdpqmILnPwf7xo0/+TEmq3dUA8vF5D6EnUAhBU4=;
 b=ZayIAviZdCfIKhsdopoWF9OA065lOZqbpOhLCXWqg0/HfEAcmKuDSpJcmtOj+VmdpvFeeMEFL0eTO/kZFHE5b8MuTUY3/CRwo2haAd2e9hvgMPB/7L/pScAkn1eFY6nVBV1JAbkFQuT2h/G3e/O4Z+bqep2qreXEbfhkCijwwQCl7uyzy0JF5ZgXAFMzFYVylmKS3LxFTJFFJQe3g/g07GJW02PFjL3VTkt9K8LpzjUFQi/C9JJmYkvfdqPl1V0uQbgzB8pMjpV/I6xc4X3MKtxuK3Ctu2PVh1TETO+32X+a8yBuoLYQksRrlZN4nqmCtlEipmA4V4eUmlnC50+5hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM5PR11MB2059.namprd11.prod.outlook.com (2603:10b6:3:8::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4566.20; Fri, 8 Oct 2021 13:52:34 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::3d20:a9f3:70c4:f286]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::3d20:a9f3:70c4:f286%5]) with mapi id 15.20.4587.022; Fri, 8 Oct 2021
 13:52:34 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     piotras@gmail.com, paulburton@kernel.org, daniel@iogearbox.net,
        johan.almbladh@anyfinetworks.com
Subject: [PATCH 5.4 0/2] bpf, mips: fix CVE-2021-38300
Date:   Fri,  8 Oct 2021 16:50:57 +0300
Message-Id: <20211008135059.1114363-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0401CA0008.eurprd04.prod.outlook.com
 (2603:10a6:800:4a::18) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR0401CA0008.eurprd04.prod.outlook.com (2603:10a6:800:4a::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18 via Frontend Transport; Fri, 8 Oct 2021 13:52:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0a858fde-fd7f-4bd6-9a71-08d98a62e16b
X-MS-TrafficTypeDiagnostic: DM5PR11MB2059:
X-Microsoft-Antispam-PRVS: <DM5PR11MB2059D7A441F137DE4E5A3E4CFEB29@DM5PR11MB2059.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1060;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9iTGX3sWEpvEmcNRDs1bb11HU7QfxzOovQBuveTSqXzzKYrPjiWPmLYvMKLGLn97JwaYnPp882cHO1SUDvYvlYAj0Vkr+AMrhMNmZtzE2xaoQzZKJczqwml9uLCU3BbIvudCNlx83qzE+SCrvzw693MwmUwqEzvcI2GoA1JfP/vDcJe/5KEqAAf769YDX1pdyb5dIGtTQiLC8O+iuNTr8rkGKEkHjpl+yky6MefRodnXuxoaMU9WOZ3aGlYPBmITKUVN9MyfP3HGImGJxhbEKAYg+G5QRO8tj3V86D4wWIuNl4ftHd8HfGoZ43845aE5zVG0rF8WLy6tNkAB7BNG8vsOC192vDtTvo+a2PiPgjSIuSRJ3Ml+PUJ/LPtuENayqDGScSYlGeB6OeyRjchenIPiqOrwtl4l/t7J1wTG9bfMgZiO8+mdVOjUJdRPTM7md1Ru4u/XQY2aghqe8BR3klwDFGp7Vmax23SCXZa244TPPt6wS1mCPOTm+OeVK35uvrW1U0kvfA+qau7Fw/qTfvwH9TgujtfuoJ+d4+Enkjl7A64xmCwec+cy5//+v18IY/xJbvcSLYAEwBP5NY1ctwarziIHzxZB+w/hfZzYbx1rLFJ8Oj1bwmrxcqly99oq7J3OVAJwCK5kcxzKNYS8NxFNM3ip2uUjSh7n15Jtjn3HA7T28muU3/u2ZiC6YrVF88Zcc2l/I0nAM2KpA4mDvA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(66476007)(6486002)(66556008)(8676002)(66946007)(38100700002)(956004)(6506007)(2616005)(38350700002)(1076003)(316002)(45080400002)(508600001)(52116002)(5660300002)(44832011)(6512007)(8936002)(83380400001)(36756003)(2906002)(6666004)(6916009)(186003)(26005)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lx0FBzEnLRpxKYGCiKcfaOII+d9HnlOqqBMeb7CVwEmUJhXoN2qu+Wao8Lfo?=
 =?us-ascii?Q?f10+O2u0dQlsWYi7ANCzcQNc1kIqcIVBW86oNEYZNyV5eYtwUvc/pr14lg5a?=
 =?us-ascii?Q?HdXk00D7jw5by61KoSpsgEz0QMdmkSpY5cX7C6qejZYn6TOMEKTRGeti3hAU?=
 =?us-ascii?Q?3NFJC80KHRiQzSH6FMkA8k3XPRDUJYsFxwsvsjpxLxViyBzXsb6eEBtp98RB?=
 =?us-ascii?Q?MbemSLwck8XXwoZudHChkOBUIxtIlMYxCXLS7YjZf7k2glw/bMxJwShKFnPG?=
 =?us-ascii?Q?w/1weadH9Xcf9doadN+/GrEVWLPyEPynt5D5k8DhoB81F6cq3t9Phq5qE+PI?=
 =?us-ascii?Q?09MpZKsMeJTvsj3pbPFQCd5WUOGOnZaTE6MYp7qK595EtUOzu4N4WP9bxyk/?=
 =?us-ascii?Q?7LmG/5QKVpU4ef3fw/nktBm8o/16IFsW9b/QaL9YGUH+THeGArZoSrBOaaDT?=
 =?us-ascii?Q?/7ZycZfObZXlUV0Bh6CfnJ0acaSt30t27CdZtUZfSuhw1/bUhibhc7NfCP6e?=
 =?us-ascii?Q?h9/Tmg34x5yPqfELML9w+tDYutiC0khaVn5u9tJeJTmFv6qoosN5dsgjFAn5?=
 =?us-ascii?Q?IxhIa+pYXrMvNMwmM2Ky7O1+WpuX3LlwFYnFKzCucT54tlt4m/TfUfdxvlI6?=
 =?us-ascii?Q?6TD8y0k8s9feHQlidn7V1MC4lATJ0Raq5vI/0Jtph7qa6CS4C8yIpMwgr3b2?=
 =?us-ascii?Q?m1HzRF2tfDY6HsTiukv3QMhpVnTmFkquPpE/9/CPG4PdcHVeuaoGvCLYAsSI?=
 =?us-ascii?Q?OcD2Z09cJlVcF3Nl2MInxDrlbX9u6MZQFwWPNKulJi+uyDCqyC8Ul5nYcElk?=
 =?us-ascii?Q?UmfPMoeDVOxXVlOpd4Lk7sZ/+keYmvQWIjvBUktVdLB2oxTeebY3gL5Tsb+v?=
 =?us-ascii?Q?nUqUujIlQ8aKev1Y8PLmWF9NMf6TuH8MJcqBrijT9iSGtjr2sgGp14sJMmaV?=
 =?us-ascii?Q?dqygTT19ALhHoVVKIH22hI8cCBD1VIhfIQtnemCToqHQAOrrK5hjbWx+dMNo?=
 =?us-ascii?Q?8eksi3CyEiUdfJ9UPz49RD7jGZeb2ijCCm0QmIRzSqQDwMW+Oj0QJ+zlHmP0?=
 =?us-ascii?Q?K9dBRwVDNJw0XVEI8pT6bMzwWy5z+K11udte2j0Tq81ljidbSrimjHUzMWQv?=
 =?us-ascii?Q?J2yjAmhNIaab7CxNC8vtL1UJDEGXYEafT1xwXgrWbPN+9V3RVmbZaR/pZyp3?=
 =?us-ascii?Q?bn+PA6DUtXZRpMHHgsTpVrKJQ9jjCpTG+fkNaStgzcKGKmcSQgZBSfq8sxHt?=
 =?us-ascii?Q?7W1E2jeSdstdFHHhmmREnAVeUWeOlfyZCuUSQdn3BDWoC97ME/5VYAxb0/nv?=
 =?us-ascii?Q?h1aIdUR1NU2Z3FzQzDVbDYiz?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a858fde-fd7f-4bd6-9a71-08d98a62e16b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2021 13:52:34.5428
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mtfcUzSTWReejZwifzD1QqbIJUnbNGi3Lp8faSbIm8pq6+qyY0YCui1PP7ig7cxoZHhUROkDhLsrjt2gqP7yc4mYTG05vq+zNk9W6IEBj5o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB2059
X-Proofpoint-GUID: X5T4SKQ8zsVj1xLaioW86l_lWUbFtZSz
X-Proofpoint-ORIG-GUID: X5T4SKQ8zsVj1xLaioW86l_lWUbFtZSz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-08_03,2021-10-07_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 suspectscore=0 impostorscore=0 priorityscore=1501 spamscore=0
 lowpriorityscore=0 clxscore=1011 malwarescore=0 phishscore=0 bulkscore=0
 mlxlogscore=811 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110080082
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

5.2 upstream commit 716850ab104d ("MIPS: eBPF: Initial eBPF support for MIPS32
architecture.") introduced eBPF JIT support for MIPS32 and removed the cBPF JIT
interface. However, it was subsequently reverted by the following commits,
bringing back the old cBPF JIT implementation:
    f8fffebdea75 ("MIPS: BPF: Disable MIPS32 eBPF JIT")
    36366e367ee9 ("MIPS: BPF: Restore MIPS32 cBPF JIT")

    From 36366e367ee9 ("MIPS: BPF: Restore MIPS32 cBPF JIT") commit message:
    """
    ...
    Until these problems are resolved, revert the removal of the cBPF JIT
    performed by commit 716850ab104d ("MIPS: eBPF: Initial eBPF support for
    MIPS32 architecture."). Together with commit f8fffebdea75 ("MIPS: BPF:
    Disable MIPS32 eBPF JIT") this restores MIPS32 BPF JIT behavior back to
    the same state it was prior to the introduction of the broken eBPF JIT
    support.
    """

In 5.4, only f8fffebdea75 ("MIPS: BPF: Disable MIPS32 eBPF JIT") was
backported. This patchseries re-enables cBPF JIT support by backporting the
second part of 16850ab104d ("MIPS: eBPF: Initial eBPF support for MIPS32
architecture.") revert and also fixes CVE-2021-38300. Both patches are clean
cherry-picks.

The testcase specified in 37cb28ec7d3a ("bpf, mips: Validate conditional
branch offsets") commit message now passes in qemu:

Before:
-------
root@qemumips:~# echo 1 > /proc/sys/net/core/bpf_jit_enable
root@qemumips:~# modprobe test_bpf test_name="BPF_MAXINSNS: exec all MSH"
[   58.577385] test_bpf: #296 BPF_MAXINSNS: exec all MSH 
[   58.579267] ------------[ cut here ]------------
[   58.603827] WARNING: CPU: 0 PID: 166 at arch/mips/mm/uasm-mips.c:210 build_insn+0x4e8/0x520
[   58.605354] Micro-assembler field overflow
[   58.606585] Modules linked in: test_bpf(+) i2c_piix4 sch_fq_codel openvswitch nsh nf_conncount nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4
[   58.608979] CPU: 0 PID: 166 Comm: modprobe Not tainted 5.4.151-yocto-standard+ #3
[   58.610838] Stack : 00000000 00000000 0000010e 1000a400 80f90000 00000045 0000010f 801978cc
[   58.612647]         80c40000 0000000b 00000000 00000000 80e051d8 1000a400 8d119950 ffffffff
[   58.615304]         00000000 00000000 81030000 0000010f 00000000 00000000 00000000 0000ffff
[   58.617685]         00000000 00000000 00000001 0000010f 00000000 80e60000 00000000 80000000
[   58.618968]         8d119a8c 00000000 80130000 c0064000 00000000 807742f4 00000001 003871d7
[   58.620309]         ...
[   58.621313] Call Trace:
[   58.622310] [<8010e748>] show_stack+0xb4/0x17c
[   58.623612] [<80b90cbc>] dump_stack+0xa0/0xcc
[   58.624755] [<80134a90>] __warn+0xcc/0x11c
[   58.626008] [<80b85ec0>] warn_slowpath_fmt+0x8c/0xb8
[   58.629175] [<80121a18>] build_insn+0x4e8/0x520
[   58.630225] [<80121ba4>] uasm_i_bne+0x1c/0x28
[   58.687860] [<8012d3a4>] build_body+0x6b8/0x2f38
[   58.740612] [<8012fd38>] bpf_jit_compile+0x114/0x1e4
[   58.793484] [<809cb584>] bpf_prepare_filter+0x2b0/0x464
[   58.843345] [<809cb7b8>] bpf_prog_create+0x80/0xc0
[   58.894788] [<c00572d8>] test_bpf_init+0x2d8/0xcf8 [test_bpf]
[   58.946096] [<80100e50>] do_one_initcall+0x54/0x2c4
[   58.992934] [<801d9850>] do_init_module+0x64/0x240
[   59.042867] [<801dbc84>] load_module+0x2180/0x27fc
[   59.093033] [<801dc568>] sys_finit_module+0xe8/0x100
[   59.142974] [<80117304>] syscall_common+0x34/0x58
[   59.823417] ---[ end trace af3af640ae837a28 ]---

After:
------
root@qemumips:~# echo 1 > /proc/sys/net/core/bpf_jit_enable
root@qemumips:~# modprobe test_bpf test_name="BPF_MAXINSNS: exec all MSH"
[  215.882154] test_bpf: #296 BPF_MAXINSNS: exec all MSH jited:0 667558 PASS
[  216.618220] test_bpf: Summary: 1 PASSED, 0 FAILED, [0/1 JIT'ed]

Paul Burton (1):
  MIPS: BPF: Restore MIPS32 cBPF JIT

Piotr Krysiuk (1):
  bpf, mips: Validate conditional branch offsets

 arch/mips/Kconfig           |    1 +
 arch/mips/net/Makefile      |    1 +
 arch/mips/net/bpf_jit.c     | 1299 +++++++++++++++++++++++++++++++++++
 arch/mips/net/bpf_jit_asm.S |  285 ++++++++
 4 files changed, 1586 insertions(+)
 create mode 100644 arch/mips/net/bpf_jit.c
 create mode 100644 arch/mips/net/bpf_jit_asm.S

-- 
2.25.1

