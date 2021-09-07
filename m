Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC3A40298A
	for <lists+stable@lfdr.de>; Tue,  7 Sep 2021 15:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344644AbhIGNUV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Sep 2021 09:20:21 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:3984 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234054AbhIGNUA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Sep 2021 09:20:00 -0400
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 187CCRLB018662;
        Tue, 7 Sep 2021 13:18:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=/Vmeb52B+9ixGp87OLYDUIKdF9M3v6IdqQ6CpmYcPv0=;
 b=X+8jnZlHw8+uUNVfa0EyQ7kkw/bO4Nhn4qofTsZ5ERqMaItSo+Ps7f0WR624aBjfkdSi
 iTTea7NuAMqGYzUismEzsGGDspL2VDc8SOZN7qpXpOpwdgfa4F+Z7MLOSkp6SBb2jV2q
 ssK0M1YT3YbHpgbJL3HQSdn4V5jXZiyf6BYegrwMUhaCIkFGt0IJBiTrfTRp17am+Nc6
 NSKUiraUttLN5+kmfq+vb626MLbbhOvHIVQTYnhD+0RU16uDGukhMUDcP1Ewurbmluyq
 ouZgFQPhnSnsP7eDp4hr5CGspiCqgxSRGHxq3YcKTOlcJLkvT5J/OuJ8RJbgnpLJsFqN vg== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by mx0a-0064b401.pphosted.com with ESMTP id 3awjhygq68-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Sep 2021 13:18:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gU8TwJH8wu3iX2hQHkubXx/MmhzSe2+sE5tw2PlDRv9hCS4ABNtg7eT8IJCjN9mjX7oBQicPu3G9RW1JNFAYl+hdcH1cBs4dsL1mgi/ZDOo21bSsPgwiNvH5ABBSo5BqqGostZHrkkexzc6vf7CbLoaA/6GTk4XCP/h2arcauWF+ZGA8vPj/DzL6bqCSD+jLKO8XxgmC+h63GSs7oAieMIj/0Tsx3fqPfrXPJqS00MLAPzEv4t+Lun7cuYkwiQZdZz3D9HXETo2l7N05/YOIYaSQCy3H1FXrLlW9C8nUJTcX+1JXkmTQKh92RKsslnTmVGtm4UeiWtVV/zc36OYP3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=/Vmeb52B+9ixGp87OLYDUIKdF9M3v6IdqQ6CpmYcPv0=;
 b=b8dJbu56fl+wp0hshe39hIK/3sHXzvpuiO0YsDYaJG/X0gRD8pObjpkU8A6rZWENCob8EmZy60gwEgbiGgywUR39o7cfYthiR9iVk+us4cPWG0JOw8GXWtpqWGpGM96vic4Mb9UK1CEkiy0KUcdckxLdWkG15JHsbgurcKzSP7vx6rP54VJcm6JPWwvZfC2TcrCi8LqTvrz23yQWj0unrVljaG9Pwic34gWKdTsTfXe4kkCHIN4WyATicsiAxM1slm9i+aTkHErxTks++65+G1jJiAc9CNR2fRxGPg/t36fC1JxX3iXj1NwfqbXrW7eullPih+9XFDiOqKhy6H+OOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB3114.namprd11.prod.outlook.com (2603:10b6:5:6d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19; Tue, 7 Sep
 2021 13:18:37 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::952a:bdc6:20c3:94cb]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::952a:bdc6:20c3:94cb%6]) with mapi id 15.20.4478.025; Tue, 7 Sep 2021
 13:18:37 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     bpf@vger.kernel.org, daniel@iogearbox.net
Subject: [PATCH 5.4 1/4] bpf: Introduce BPF nospec instruction for mitigating Spectre v4
Date:   Tue,  7 Sep 2021 16:16:58 +0300
Message-Id: <20210907131701.1910024-2-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210907131701.1910024-1-ovidiu.panait@windriver.com>
References: <20210907131701.1910024-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0181.eurprd07.prod.outlook.com
 (2603:10a6:802:3e::29) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR07CA0181.eurprd07.prod.outlook.com (2603:10a6:802:3e::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.6 via Frontend Transport; Tue, 7 Sep 2021 13:18:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c5de3aa6-faee-4490-f2ea-08d972020050
X-MS-TrafficTypeDiagnostic: DM6PR11MB3114:
X-Microsoft-Antispam-PRVS: <DM6PR11MB3114C8BFCE6DA9FEF4E49F57FED39@DM6PR11MB3114.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:229;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1yt0N+QXaKOq9br7PSK4jrJkKqRqAojiRvKpcjhum6uOHQpLjPmDkMnzvyNsn5nT8lRhutLRNmvPvqR/lHgHZuoszzgw2/x3d4yXYm49EsWv2dm+Hpq4ma3SYPgYBuRysvzLl7qI7CUG3lTORo4Ftex6R0ShP4VzfuhJryNWjKmWxzq/R+wSO/QuVzcJ8SLi1EmPA1PCraXpiUgMm4JEKTPPVMw2e/xTkFpxoe4Nk/5GWGz3yXWOrNlUiIn5N513sMDLtZNYsvvLTLuXafAxkh5PbPxcgzWtKC5CLmgA35YpXhmRHZ25u1nMnieXrc5NV4WcmB/AJuFre4D9Aw2NQv9mHnsW20uzyNx1uJu1TWN8+xg1YJxEToDrI1p3QTL2kwotJJ7k0IrrSu4dwfFpnYrfNcS85klMRprH5Rfy1etv6mzdP8zVKvf0P88omvUcP6ojoKH1VIJpW+ES46TRkTew6vtNKEl5vuHxCEzTnMzvQ47XhJrKY1gJ8+CFUC4pUXRn9C1KbUUBu19fV4WgEOUHwaolHM7ei1DxeVVDkfuP/pw6Cn8B8cVWLmnj6pdZWEqkgHChDZs350WZUbBGNC/SS59DEwWp6XUlWZY7Lzl5LuXQBeZZ2hCj7eAzQLcGwNAipurNh6+DCUjlmR+T2blNVvUa4zNp/vHpXbJAhhLiviv8Ew0Cb5VMAl+LUwEfufmiFmf5PVDONnA46iEcfg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(366004)(136003)(376002)(39850400004)(8936002)(83380400001)(38100700002)(6916009)(186003)(4326008)(36756003)(38350700002)(86362001)(2906002)(956004)(26005)(6666004)(2616005)(8676002)(66476007)(1076003)(66556008)(44832011)(6506007)(6512007)(52116002)(6486002)(30864003)(478600001)(66946007)(316002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mqeLYXQ3I05hwe1i+EPQRbqzPgLMpNCLz0glDLksi8fdW22jH+SR92YSSVqA?=
 =?us-ascii?Q?Gfzx0/SNMX05F+QxLt6zmneKLyps7dnC3I0coPOJzWUjXx/i1sWD5EDAPmy2?=
 =?us-ascii?Q?5SzG6WCxvJFZ3ueIacQWCrmijWo9V62IWMQmTGaxE41jODYI/r8BztjFLIno?=
 =?us-ascii?Q?eV/vVx4QPpLtFpAnrGmkVIdKpp4G84ITrzfZzaoYVLNbb+JcqOuIygWAcUQy?=
 =?us-ascii?Q?UmFEKQv0G4Buw6fskOD84XNd+6/tepIbuX2YQQe1ldqF2Asi+DucYWG4cNb8?=
 =?us-ascii?Q?F4b0AQmK5RSbW0YZc0dDov3wfK752x0327wu5XMeMoVJgnhj1RrA5xL5kidZ?=
 =?us-ascii?Q?Rde04oWfj0wM/LCE7NACO5ODNsxBQWLNGV7z37c9nCDkNDgxn/hQbGpIfQIk?=
 =?us-ascii?Q?AvEZC1M/DhSKSDKVGzNSHN8N6vBoqxsn/plLmR8MWaSc8vrjEnlTxpiC9Ryd?=
 =?us-ascii?Q?7tYveOqQ3U2aHzce8aN5KDOnIbtCbnN7ozJc2xJO481nMX2Rhe9BlpMRqhE/?=
 =?us-ascii?Q?F8yx3m12LlJJXOrtLKPUf7saBLMdMTiVEbwiF/6TN0uNNQCP3mpWhwuCrxHX?=
 =?us-ascii?Q?CiAUG3SLKacNEvyeu87MGZJAZtDnFoDFb9zrU3vEf2E0M8Gp7PvbD0sndWpo?=
 =?us-ascii?Q?Ft0icwI1R5ZHu7fVHtXiUmKIzwG8ssMK62HVtyHzrelyEfmSG3RHWqYn+HSP?=
 =?us-ascii?Q?yIuJWCHWP299+pIUcb1XF+Qd61tCOJeynU/8kAnA/h47RvwYr72xENKWwzXL?=
 =?us-ascii?Q?dDJpZj988kSewH0I9KSYu3oY6Fs5aFatrPwaxXCwe+BsJpq6AatTseniKraL?=
 =?us-ascii?Q?MWKT6qaGSA1oVqqM607c4Q9XUwW6fABUYGleobKw/FDgMH6tzkABJs/9vRDD?=
 =?us-ascii?Q?vx0+AxhEDnnwPxPtVBeJGn3kHjTGELHgIcBwos6yLMAPyLtMMOtaZUz9ENji?=
 =?us-ascii?Q?kGSqlzcpKTsZKGhLYhdvI7shR7cDX0EYvyv2ovFAeWuWQ/XCACEV+hHqbhC4?=
 =?us-ascii?Q?MFehFpEktQ26EwaGZct1iPZoAq8ijbT1+sJYDm9mghgzde8L3VXFMfWpptnh?=
 =?us-ascii?Q?WArnEHrwf+cyfgp19BB8nCyEHUy74zPOkwn0piObdInE3xekdTSeJvJro2qA?=
 =?us-ascii?Q?L+HIDkIrv2pJGlbFqR9vzO7/oiDsrDrpFOGYLj+jUPKKashmtDt2NfOQ5MyS?=
 =?us-ascii?Q?qjG6XCyuj3c6kje3DpZauV75/JVNdROMdL7WHKCDhd3q9nlrxGTAacjr6ASn?=
 =?us-ascii?Q?M/wng5NW897M4jQzrGxywHEDbQvSL348YVKgooc4a+Md+wqfrbEAUxvnGuO9?=
 =?us-ascii?Q?NPhXQUQ39U8OBih3tM2HYMYM?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5de3aa6-faee-4490-f2ea-08d972020050
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2021 13:18:37.3259
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 11SxoCi7jJjoF7VnnW1mY4Tyn5g6FROQfFLRJct87gDC7/SKMTJT+nGPyJsEMnTgEcvP1tINodulKMotdVbKcto1gKGrFQ49vFrUxI7Nv4o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3114
X-Proofpoint-GUID: 0juY_PYzOZq9wOdzEiD6blK9t5QKCqie
X-Proofpoint-ORIG-GUID: 0juY_PYzOZq9wOdzEiD6blK9t5QKCqie
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-07_04,2021-09-07_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 lowpriorityscore=0 bulkscore=0 suspectscore=0 mlxscore=0 adultscore=0
 impostorscore=0 priorityscore=1501 phishscore=0 mlxlogscore=999
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2108310000 definitions=main-2109070088
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
[OP: - adjusted context for 5.4
     - apply riscv changes to /arch/riscv/net/bpf_jit_comp.c]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 arch/arm/net/bpf_jit_32.c         |  3 +++
 arch/arm64/net/bpf_jit_comp.c     | 13 +++++++++++++
 arch/mips/net/ebpf_jit.c          |  3 +++
 arch/powerpc/net/bpf_jit_comp64.c |  6 ++++++
 arch/riscv/net/bpf_jit_comp.c     |  4 ++++
 arch/s390/net/bpf_jit_comp.c      |  5 +++++
 arch/sparc/net/bpf_jit_comp_64.c  |  3 +++
 arch/x86/net/bpf_jit_comp.c       |  7 +++++++
 arch/x86/net/bpf_jit_comp32.c     |  6 ++++++
 include/linux/filter.h            | 15 +++++++++++++++
 kernel/bpf/core.c                 | 18 +++++++++++++++++-
 kernel/bpf/disasm.c               | 16 +++++++++-------
 12 files changed, 91 insertions(+), 8 deletions(-)

diff --git a/arch/arm/net/bpf_jit_32.c b/arch/arm/net/bpf_jit_32.c
index 7216653424fd..b51a8c7b0111 100644
--- a/arch/arm/net/bpf_jit_32.c
+++ b/arch/arm/net/bpf_jit_32.c
@@ -1602,6 +1602,9 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx)
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
index 945e5f690ede..afc7d41347f7 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -701,6 +701,19 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
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
index 561154cbcc40..b31b91e57c34 100644
--- a/arch/mips/net/ebpf_jit.c
+++ b/arch/mips/net/ebpf_jit.c
@@ -1355,6 +1355,9 @@ static int build_one_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 		}
 		break;
 
+	case BPF_ST | BPF_NOSPEC: /* speculation barrier */
+		break;
+
 	case BPF_ST | BPF_B | BPF_MEM:
 	case BPF_ST | BPF_H | BPF_MEM:
 	case BPF_ST | BPF_W | BPF_MEM:
diff --git a/arch/powerpc/net/bpf_jit_comp64.c b/arch/powerpc/net/bpf_jit_comp64.c
index be3517ef0574..20bfd753bcba 100644
--- a/arch/powerpc/net/bpf_jit_comp64.c
+++ b/arch/powerpc/net/bpf_jit_comp64.c
@@ -644,6 +644,12 @@ static int bpf_jit_build_body(struct bpf_prog *fp, u32 *image,
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
diff --git a/arch/riscv/net/bpf_jit_comp.c b/arch/riscv/net/bpf_jit_comp.c
index e2279fed8f56..0eefe6193253 100644
--- a/arch/riscv/net/bpf_jit_comp.c
+++ b/arch/riscv/net/bpf_jit_comp.c
@@ -1313,6 +1313,10 @@ static int emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 		emit(rv_ld(rd, 0, RV_REG_T1), ctx);
 		break;
 
+	/* speculation barrier */
+	case BPF_ST | BPF_NOSPEC:
+		break;
+
 	/* ST: *(size *)(dst + off) = imm */
 	case BPF_ST | BPF_MEM | BPF_B:
 		emit_imm(RV_REG_T1, imm, ctx);
diff --git a/arch/s390/net/bpf_jit_comp.c b/arch/s390/net/bpf_jit_comp.c
index e160f4650f8e..3e6612d8b921 100644
--- a/arch/s390/net/bpf_jit_comp.c
+++ b/arch/s390/net/bpf_jit_comp.c
@@ -913,6 +913,11 @@ static noinline int bpf_jit_insn(struct bpf_jit *jit, struct bpf_prog *fp,
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
index 3364e2a00989..fef734473c0f 100644
--- a/arch/sparc/net/bpf_jit_comp_64.c
+++ b/arch/sparc/net/bpf_jit_comp_64.c
@@ -1287,6 +1287,9 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx)
 			return 1;
 		break;
 	}
+	/* speculation barrier */
+	case BPF_ST | BPF_NOSPEC:
+		break;
 	/* ST: *(size *)(dst + off) = imm */
 	case BPF_ST | BPF_MEM | BPF_W:
 	case BPF_ST | BPF_MEM | BPF_H:
diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 6e884f17634f..55f62dca28aa 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -728,6 +728,13 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
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
index 0fcba32077c8..2914f900034e 100644
--- a/arch/x86/net/bpf_jit_comp32.c
+++ b/arch/x86/net/bpf_jit_comp32.c
@@ -1705,6 +1705,12 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
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
index c53e2fe3c8f7..c4f89340f498 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -68,6 +68,11 @@ struct ctl_table_header;
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
@@ -368,6 +373,16 @@ static inline bool insn_is_zext(const struct bpf_insn *insn)
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
index 323913ba13b3..d9a3d995bd96 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -31,6 +31,7 @@
 #include <linux/rcupdate.h>
 #include <linux/perf_event.h>
 
+#include <asm/barrier.h>
 #include <asm/unaligned.h>
 
 /* Registers */
@@ -1310,6 +1311,7 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u64 *stack)
 		/* Non-UAPI available opcodes. */
 		[BPF_JMP | BPF_CALL_ARGS] = &&JMP_CALL_ARGS,
 		[BPF_JMP | BPF_TAIL_CALL] = &&JMP_TAIL_CALL,
+		[BPF_ST  | BPF_NOSPEC] = &&ST_NOSPEC,
 	};
 #undef BPF_INSN_3_LBL
 #undef BPF_INSN_2_LBL
@@ -1550,7 +1552,21 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u64 *stack)
 	COND_JMP(s, JSGE, >=)
 	COND_JMP(s, JSLE, <=)
 #undef COND_JMP
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
index b44d8c447afd..ff1dd7d45b58 100644
--- a/kernel/bpf/disasm.c
+++ b/kernel/bpf/disasm.c
@@ -162,15 +162,17 @@ void print_bpf_insn(const struct bpf_insn_cbs *cbs,
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

