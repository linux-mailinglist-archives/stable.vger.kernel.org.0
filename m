Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19F85409786
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 17:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235347AbhIMPhq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 11:37:46 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:40888 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241059AbhIMPhh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 11:37:37 -0400
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18DFWGwg016966;
        Mon, 13 Sep 2021 15:36:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=mteNhSHB5F2WrjqyGdyxY6XvhUEeuyEt61mitW6Sxhs=;
 b=b0f+EAd2lN1YXrhPOWLajyIJFDH1e+9LnJrLYF1N4ajSfRrZoS6+teR0hRU3zOMceQyd
 vAUBk61Yh/Zu3CWvZ+RfBclRARwvaX6kbs6H4+LIflCVGoNG791l4Yl1bMEtm9I6RPOe
 QicZRkzjwhcA5z/PeS0WkoaHcXJ92p0h9JvXL5yMAmCjgKEawoC2Anv2vW5dPBV5E2UJ
 rLP8bttxl/3jDnR6AOv4p35oLp+2ohgq++xBy3d+WJVOuZOH+XEF1vr/8HedPgU+cBfk
 jD0m4qA19q4kLCT0AqD2NwslSdR6XSYkVFmYcT2EvaU8SgVwi117wjBhcNUa7dCtv/5J yQ== 
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2040.outbound.protection.outlook.com [104.47.56.40])
        by mx0a-0064b401.pphosted.com with ESMTP id 3b26m1854b-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Sep 2021 15:36:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GSKX3B1wLt2Tqz8dEyml1GVFPWFcQh9LAU1hXEGnwG9AqtRgfd6PJ15BjQ3/oVU1OEXojWrBZWZQ6iYm05e8umP6JSDcp42J6qU310gdLfYBiAY8NEwT+d4LsTIxHF4wSbYujSEqNGUo6OhuYObquQjNp/+7DPZHYiFtKw+nIq0I9nTQ4ACyDPTwOovbeqUXnvI7HmLB+04uI2Ln4D7yTTGN3q09wJ4eapYnnp0aRuknJVdGRg/wFji70vNLeXANBbJhqYAXukgRjM8nR6S9iSbyh1yu1Z26cEjGS3vFzTGFJt+7fpR5QQN6KNwXHPvvG/2cYYTVWKFhU2x3SQIOrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=mteNhSHB5F2WrjqyGdyxY6XvhUEeuyEt61mitW6Sxhs=;
 b=hc+1vFMTPd4AjzhSoCwkh7KTT5hn/D85EtIJFibrbPmRFGT0LCuC7XUE6jkiBqtglG0X8CGc4wli9HEARSsYdPy5XyZihi05AH7HEHP9M3DYmXG7cUJ9e6Z4hnHlKxzxJtgoWCVhA0FHNoaZGofpIntbwwd1fyrkeBn4XHT+E/0RyaEwJ8BnJ0m1pPXo8icDm6tS1wGuERJVF3OZ0Q8fY/MTxttzKKzAbBgxiulgTr8BtnDQNW3EAHmFE9cndUbacFJ4lHA2+jGInMK1hrbdXRkIZ8lb0dh07HXhnD9wwqMI2qLNfvXUxwkJlgwDK+wCIqurAo3I9DwXPrHengKNSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM5PR1101MB2201.namprd11.prod.outlook.com (2603:10b6:4:51::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.15; Mon, 13 Sep
 2021 15:36:08 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::952a:bdc6:20c3:94cb]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::952a:bdc6:20c3:94cb%7]) with mapi id 15.20.4500.019; Mon, 13 Sep 2021
 15:36:08 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     bpf@vger.kernel.org, daniel@iogearbox.net
Subject: [PATCH 4.19 10/13] bpf: Introduce BPF nospec instruction for mitigating Spectre v4
Date:   Mon, 13 Sep 2021 18:35:34 +0300
Message-Id: <20210913153537.2162465-11-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210913153537.2162465-1-ovidiu.panait@windriver.com>
References: <20210913153537.2162465-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR10CA0095.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:28::24) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR10CA0095.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:803:28::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 15:36:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4af51a2d-3b5e-4302-0088-08d976cc34e2
X-MS-TrafficTypeDiagnostic: DM5PR1101MB2201:
X-Microsoft-Antispam-PRVS: <DM5PR1101MB22011DE81D88C39B8BE9167CFED99@DM5PR1101MB2201.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:229;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FtWp3/3grlsP7fiW8uibOM1jbTCOrySykhlPduedfUS5N6eqphRRaGTQsThoSxuQUrJKDTc7aC2GZk889iTIe+Wfa1VVPWwCQfkN6RYjDadNxj9fQYHUuBr02VSaJzmHMDR3HnQE0enQEDUPgQDiPo6id8ghtJcCR1CMSASAGMNpxxuvx7t+T/DRSPL43F7o1A12MXUYpf5a05FMdjaFEOGtT8pWWQADT3+TxQOrxU/iX03+Subqw1uM4ov10VeLzpzqA5DsPPyMg4f1K5zRH3pvey2AmydVTQKL9RrjIWB4ZjZK3B4DNQRnGS1YsGE3Tl2JiMIEkpl3yRRi2ZiR2WzLDjqF4N0FXBXKFlxwmlsSFnMPG6QBCgJFa8xUb9En7AL47/eMQ1cCKXM6hTykGhwjQ0gk0grMCJagYT+VbS32EdAbcv2Yf+0NQr36hvPazEO8cAbuebZqb25crsUay79Fbi5jZb2IpqvbuDPfUiMtmTtR8a9Dn0rl+4NalRx43OkMU0bRN1vIPZhgyPyc8XTSU1I+V5ABV641YZwn74rOZqUv69LWQDITJtOnoM0t6z0MZ3+YjygIvljOpbJAf56QkdhNS9P7YqU5+TlN4vzzhJtlqG8gph0gxTwCsb2Usv9CgX7YRbxjLMpacMUASKFwZXHRVuEEHgUufNi4jtUoV6b8m5BSg4JKGmLYa794uU/rChKriDre+icVGzEOKA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(366004)(39850400004)(376002)(346002)(52116002)(6916009)(316002)(6486002)(38350700002)(6666004)(86362001)(5660300002)(2616005)(4326008)(8936002)(26005)(38100700002)(6512007)(6506007)(956004)(83380400001)(478600001)(1076003)(36756003)(186003)(44832011)(66476007)(2906002)(8676002)(66946007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5OJeizZV6tUhQbNsHM+OPKO6iPeASsGb3NLbyOiyKrwkWJfh3Mj7JqblIt1n?=
 =?us-ascii?Q?0tV5n+XruVvzfcjLSXpvSZL5p2BddxTK/+qfk9KMu3JZEY4DPxOo5h7uu7Nh?=
 =?us-ascii?Q?rstBCcVtIMPS8hNidME69UAdrjm6eOtQnaCNn7EtpMn+Bg6PPycS3A00FHvI?=
 =?us-ascii?Q?YhunW3gsm61SPUGp2PCmrw+qrRd9baqwwazVYetRQZOnFCC/1AfDRRPcqObJ?=
 =?us-ascii?Q?3khkm0Gk1zmU0f6vR+9S7BWFZGbW0jHMF9eMfzqeJcKWoUv5C+eMlTEqLUla?=
 =?us-ascii?Q?QJpzKDPWDB5G0rVVspHFKryFa674iottX9Y2ehgZlZXxAzl10+5ce7iyfbFJ?=
 =?us-ascii?Q?n5bOb1E0fbbXtnpy4cwu4DICHr3WNX8PBfp7kway6yBaT5kTMaTuUOfZRexG?=
 =?us-ascii?Q?Ews2Qy59zc2bUCxZg1DoGXKVVkcbCJd33K2t0L7pXT1nydM0lswhYpE9gtJp?=
 =?us-ascii?Q?RrnmVcV052w9Q6gWoI0IzsD6rbuisw9v65ZX1jKmaM1re8MY79mDvRqB6L9w?=
 =?us-ascii?Q?RHISB9xKjI4tfA/hd0c1rcFyS1lM0SkA4zqCcJf4A1QtC9nP/3bRum6T8tIu?=
 =?us-ascii?Q?Oa1R75q4QfMzLUA9/atDeSgZRlOe1iccCp8kwHH2qNq3XMvy1SO7wD2eBz9D?=
 =?us-ascii?Q?VDIaNE6SHECxKN33be9PlwskYUgp1jzPOL5ggGCf2eb8RQsS1qAm6sfhedAY?=
 =?us-ascii?Q?KIkE3XR8EhZUE7DeKiEokhZcEKrp51WyEyULIRlZPOdxLhLlahFSe+UBfpx9?=
 =?us-ascii?Q?JNnmHV5dVaCF+AEEzKLv0l7vP2/KtKbdXejNQryHEpc5tr8CS4Tbsa4F8sQR?=
 =?us-ascii?Q?oJ2pGwFvfaRLZ4HlcsGHtqSrGZ+2foccn7LJl8Zo1E09852yG7QUWhJAXL9U?=
 =?us-ascii?Q?kOGFamSyqC7KsUCRhWeT7jCmHB4j689PL5VkUN2CVdlJhazKgcIV0rYbq2VJ?=
 =?us-ascii?Q?umCWw9p33Ay/l7J5bgXkby0/LgcQ+57F9PHyyDI5K5seLYz/Z/icWzo8Difd?=
 =?us-ascii?Q?QagtrM1obedsUlBbh2yjquURDh+l81eoDuXhtqB5u2FFgG9nrPF37TZ8fAHv?=
 =?us-ascii?Q?mXU9jZuCszIkGvsu98gykHVx5biO196LRgQQUZGL968FhwcRzdzyVl5ym0ur?=
 =?us-ascii?Q?Ikp6ii7EKWeZgAqRQVE9Sjm/bxiy0ltBOVe2ly6c+DLZxb3n9s8G0IxTno0s?=
 =?us-ascii?Q?x4bvKL7SUBLtsD5d/AOweO9JQajxbHJMlVeQBB/YqzaV0XXN4bXnOBg7Cu/k?=
 =?us-ascii?Q?V2HXOtcyUnWZzIweERO/JtU44f+c7Nd0Rd4ERCxerun/wiUEZ8BZmG2S2JO8?=
 =?us-ascii?Q?1TddhdWLkhJPfl0VKAjmkGFu?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4af51a2d-3b5e-4302-0088-08d976cc34e2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 15:36:08.3821
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zU5qcklWL43LMxe6B1f4KkuH05ZwNjwV432fNGqo8VSmgAJCY3JCIKOa9LSfcCj3JkQguimoEHF+vF68GW6naUFzdOMNnU5VVS//Jp2nLMU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1101MB2201
X-Proofpoint-GUID: n2qKqqFN5Ea6Gca2u8hEFZCe86tJbFLY
X-Proofpoint-ORIG-GUID: n2qKqqFN5Ea6Gca2u8hEFZCe86tJbFLY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-13_07,2021-09-09_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 adultscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 bulkscore=0 spamscore=0 clxscore=1015 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109130103
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit f5e81d1117501546b7be050c5fbafa6efd2c722c upstream.

In case of JITs, each of the JIT backends compiles the BPF nospec instruction
/either/ to a machine instruction which emits a speculation barrier /or/ to
/no/ machine instruction in case the underlying architecture is not affected
by Speculative Store Bypass or has different mitigations in place already.

This covers both x86 and (implicitly) arm64: In case of x86, we use 'lfence'
instruction for mitigation. In case of arm64, we rely on the firmware mitigation
as controlled via the ssbd kernel parameter. Whenever the mitigation is enabled,
it works for all of the kernel code with no need to provide any additional
instructions here (hence only comment in arm64 JIT). Other archs can follow
as needed. The BPF nospec instruction is specifically targeting Spectre v4
since i) we don't use a serialization barrier for the Spectre v1 case, and
ii) mitigation instructions for v1 and v4 might be different on some archs.

The BPF nospec is required for a future commit, where the BPF verifier does
annotate intermediate BPF programs with speculation barriers.

Co-developed-by: Piotr Krysiuk <piotras@gmail.com>
Co-developed-by: Benedict Schlueter <benedict.schlueter@rub.de>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Piotr Krysiuk <piotras@gmail.com>
Signed-off-by: Benedict Schlueter <benedict.schlueter@rub.de>
Acked-by: Alexei Starovoitov <ast@kernel.org>
[OP: adjusted context for 4.19, drop riscv and ppc32 changes]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 arch/arm/net/bpf_jit_32.c         |  3 +++
 arch/arm64/net/bpf_jit_comp.c     | 13 +++++++++++++
 arch/mips/net/ebpf_jit.c          |  3 +++
 arch/powerpc/net/bpf_jit_comp64.c |  6 ++++++
 arch/s390/net/bpf_jit_comp.c      |  5 +++++
 arch/sparc/net/bpf_jit_comp_64.c  |  3 +++
 arch/x86/net/bpf_jit_comp.c       |  7 +++++++
 arch/x86/net/bpf_jit_comp32.c     |  6 ++++++
 include/linux/filter.h            | 15 +++++++++++++++
 kernel/bpf/core.c                 | 18 +++++++++++++++++-
 kernel/bpf/disasm.c               | 16 +++++++++-------
 11 files changed, 87 insertions(+), 8 deletions(-)

diff --git a/arch/arm/net/bpf_jit_32.c b/arch/arm/net/bpf_jit_32.c
index 328ced7bfaf2..79b12e744537 100644
--- a/arch/arm/net/bpf_jit_32.c
+++ b/arch/arm/net/bpf_jit_32.c
@@ -1578,6 +1578,9 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx)
 		rn = arm_bpf_get_reg32(src_lo, tmp2[1], ctx);
 		emit_ldx_r(dst, rn, off, ctx, BPF_SIZE(code));
 		break;
+	/* speculation barrier */
+	case BPF_ST | BPF_NOSPEC:
+		break;
 	/* ST: *(size *)(dst + off) = imm */
 	case BPF_ST | BPF_MEM | BPF_W:
 	case BPF_ST | BPF_MEM | BPF_H:
diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index 7f0258ed1f5f..6876e8205042 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -685,6 +685,19 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx)
 		}
 		break;
 
+	/* speculation barrier */
+	case BPF_ST | BPF_NOSPEC:
+		/*
+		 * Nothing required here.
+		 *
+		 * In case of arm64, we rely on the firmware mitigation of
+		 * Speculative Store Bypass as controlled via the ssbd kernel
+		 * parameter. Whenever the mitigation is enabled, it works
+		 * for all of the kernel code with no need to provide any
+		 * additional instructions.
+		 */
+		break;
+
 	/* ST: *(size *)(dst + off) = imm */
 	case BPF_ST | BPF_MEM | BPF_W:
 	case BPF_ST | BPF_MEM | BPF_H:
diff --git a/arch/mips/net/ebpf_jit.c b/arch/mips/net/ebpf_jit.c
index 3832c4628608..947a7172c814 100644
--- a/arch/mips/net/ebpf_jit.c
+++ b/arch/mips/net/ebpf_jit.c
@@ -1282,6 +1282,9 @@ static int build_one_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 		}
 		break;
 
+	case BPF_ST | BPF_NOSPEC: /* speculation barrier */
+		break;
+
 	case BPF_ST | BPF_B | BPF_MEM:
 	case BPF_ST | BPF_H | BPF_MEM:
 	case BPF_ST | BPF_W | BPF_MEM:
diff --git a/arch/powerpc/net/bpf_jit_comp64.c b/arch/powerpc/net/bpf_jit_comp64.c
index 7e3ab477f67f..e7d56ddba43a 100644
--- a/arch/powerpc/net/bpf_jit_comp64.c
+++ b/arch/powerpc/net/bpf_jit_comp64.c
@@ -596,6 +596,12 @@ static int bpf_jit_build_body(struct bpf_prog *fp, u32 *image,
 			}
 			break;
 
+		/*
+		 * BPF_ST NOSPEC (speculation barrier)
+		 */
+		case BPF_ST | BPF_NOSPEC:
+			break;
+
 		/*
 		 * BPF_ST(X)
 		 */
diff --git a/arch/s390/net/bpf_jit_comp.c b/arch/s390/net/bpf_jit_comp.c
index e42354b15e0b..2a36845dcbc0 100644
--- a/arch/s390/net/bpf_jit_comp.c
+++ b/arch/s390/net/bpf_jit_comp.c
@@ -883,6 +883,11 @@ static noinline int bpf_jit_insn(struct bpf_jit *jit, struct bpf_prog *fp, int i
 			break;
 		}
 		break;
+	/*
+	 * BPF_NOSPEC (speculation barrier)
+	 */
+	case BPF_ST | BPF_NOSPEC:
+		break;
 	/*
 	 * BPF_ST(X)
 	 */
diff --git a/arch/sparc/net/bpf_jit_comp_64.c b/arch/sparc/net/bpf_jit_comp_64.c
index ec4da4dc98f1..1bb1e64d4377 100644
--- a/arch/sparc/net/bpf_jit_comp_64.c
+++ b/arch/sparc/net/bpf_jit_comp_64.c
@@ -1261,6 +1261,9 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx)
 		emit(opcode | RS1(src) | rs2 | RD(dst), ctx);
 		break;
 	}
+	/* speculation barrier */
+	case BPF_ST | BPF_NOSPEC:
+		break;
 	/* ST: *(size *)(dst + off) = imm */
 	case BPF_ST | BPF_MEM | BPF_W:
 	case BPF_ST | BPF_MEM | BPF_H:
diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 924ca27a6139..81c3d4b4c7e2 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -731,6 +731,13 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 			}
 			break;
 
+			/* speculation barrier */
+		case BPF_ST | BPF_NOSPEC:
+			if (boot_cpu_has(X86_FEATURE_XMM2))
+				/* Emit 'lfence' */
+				EMIT3(0x0F, 0xAE, 0xE8);
+			break;
+
 			/* ST: *(u8*)(dst_reg + off) = imm */
 		case BPF_ST | BPF_MEM | BPF_B:
 			if (is_ereg(dst_reg))
diff --git a/arch/x86/net/bpf_jit_comp32.c b/arch/x86/net/bpf_jit_comp32.c
index adee990abab1..f48300988bc2 100644
--- a/arch/x86/net/bpf_jit_comp32.c
+++ b/arch/x86/net/bpf_jit_comp32.c
@@ -1683,6 +1683,12 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 			i++;
 			break;
 		}
+		/* speculation barrier */
+		case BPF_ST | BPF_NOSPEC:
+			if (boot_cpu_has(X86_FEATURE_XMM2))
+				/* Emit 'lfence' */
+				EMIT3(0x0F, 0xAE, 0xE8);
+			break;
 		/* ST: *(u8*)(dst_reg + off) = imm */
 		case BPF_ST | BPF_MEM | BPF_H:
 		case BPF_ST | BPF_MEM | BPF_B:
diff --git a/include/linux/filter.h b/include/linux/filter.h
index 7c84762cb59e..e981bd92a4e3 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -64,6 +64,11 @@ struct sock_reuseport;
 /* unused opcode to mark call to interpreter with arguments */
 #define BPF_CALL_ARGS	0xe0
 
+/* unused opcode to mark speculation barrier for mitigating
+ * Speculative Store Bypass
+ */
+#define BPF_NOSPEC	0xc0
+
 /* As per nm, we expose JITed images as text (code) section for
  * kallsyms. That way, tools like perf can find it to match
  * addresses.
@@ -354,6 +359,16 @@ struct sock_reuseport;
 		.off   = 0,					\
 		.imm   = 0 })
 
+/* Speculation barrier */
+
+#define BPF_ST_NOSPEC()						\
+	((struct bpf_insn) {					\
+		.code  = BPF_ST | BPF_NOSPEC,			\
+		.dst_reg = 0,					\
+		.src_reg = 0,					\
+		.off   = 0,					\
+		.imm   = 0 })
+
 /* Internal classic blocks for direct assignment */
 
 #define __BPF_STMT(CODE, K)					\
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index d2b6d2459aad..341402bc1202 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -33,6 +33,7 @@
 #include <linux/rcupdate.h>
 #include <linux/perf_event.h>
 
+#include <asm/barrier.h>
 #include <asm/unaligned.h>
 
 /* Registers */
@@ -1050,6 +1051,7 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u64 *stack)
 		/* Non-UAPI available opcodes. */
 		[BPF_JMP | BPF_CALL_ARGS] = &&JMP_CALL_ARGS,
 		[BPF_JMP | BPF_TAIL_CALL] = &&JMP_TAIL_CALL,
+		[BPF_ST  | BPF_NOSPEC] = &&ST_NOSPEC,
 	};
 #undef BPF_INSN_3_LBL
 #undef BPF_INSN_2_LBL
@@ -1356,7 +1358,21 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u64 *stack)
 	JMP_EXIT:
 		return BPF_R0;
 
-	/* STX and ST and LDX*/
+	/* ST, STX and LDX*/
+	ST_NOSPEC:
+		/* Speculation barrier for mitigating Speculative Store Bypass.
+		 * In case of arm64, we rely on the firmware mitigation as
+		 * controlled via the ssbd kernel parameter. Whenever the
+		 * mitigation is enabled, it works for all of the kernel code
+		 * with no need to provide any additional instructions here.
+		 * In case of x86, we use 'lfence' insn for mitigation. We
+		 * reuse preexisting logic from Spectre v1 mitigation that
+		 * happens to produce the required code on x86 for v4 as well.
+		 */
+#ifdef CONFIG_X86
+		barrier_nospec();
+#endif
+		CONT;
 #define LDST(SIZEOP, SIZE)						\
 	STX_MEM_##SIZEOP:						\
 		*(SIZE *)(unsigned long) (DST + insn->off) = SRC;	\
diff --git a/kernel/bpf/disasm.c b/kernel/bpf/disasm.c
index d6b76377cb6e..cbd75dd5992e 100644
--- a/kernel/bpf/disasm.c
+++ b/kernel/bpf/disasm.c
@@ -171,15 +171,17 @@ void print_bpf_insn(const struct bpf_insn_cbs *cbs,
 		else
 			verbose(cbs->private_data, "BUG_%02x\n", insn->code);
 	} else if (class == BPF_ST) {
-		if (BPF_MODE(insn->code) != BPF_MEM) {
+		if (BPF_MODE(insn->code) == BPF_MEM) {
+			verbose(cbs->private_data, "(%02x) *(%s *)(r%d %+d) = %d\n",
+				insn->code,
+				bpf_ldst_string[BPF_SIZE(insn->code) >> 3],
+				insn->dst_reg,
+				insn->off, insn->imm);
+		} else if (BPF_MODE(insn->code) == 0xc0 /* BPF_NOSPEC, no UAPI */) {
+			verbose(cbs->private_data, "(%02x) nospec\n", insn->code);
+		} else {
 			verbose(cbs->private_data, "BUG_st_%02x\n", insn->code);
-			return;
 		}
-		verbose(cbs->private_data, "(%02x) *(%s *)(r%d %+d) = %d\n",
-			insn->code,
-			bpf_ldst_string[BPF_SIZE(insn->code) >> 3],
-			insn->dst_reg,
-			insn->off, insn->imm);
 	} else if (class == BPF_LDX) {
 		if (BPF_MODE(insn->code) != BPF_MEM) {
 			verbose(cbs->private_data, "BUG_ldx_%02x\n", insn->code);
-- 
2.25.1

