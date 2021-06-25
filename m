Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C29453B3E14
	for <lists+stable@lfdr.de>; Fri, 25 Jun 2021 09:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229474AbhFYH7k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Jun 2021 03:59:40 -0400
Received: from mail-bn8nam12on2089.outbound.protection.outlook.com ([40.107.237.89]:63905
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229454AbhFYH7j (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Jun 2021 03:59:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OgeOMtT2or774+unO0zvKKs+YU0d6wonFbqPZsE7AFfSBtUrJoTdlK6lU/+DXlJXQDRQaZzoEo91qM9WBSKeF69mhMLxi0Jk7Lh/ft1oNqaInSO/ticAgzYvXktryFZZcH+qv1xsHgpONeBcq7zOtT1fZHwWRgAwy0YtMQQyfIDGWxu0WytHMfI1sILuSW0jNo/h7QDBv0TUxSP9dX2xnVUCVHcmUw+V0kdSMJg4ddKm/950P5PsUd5Bl/4NCzP0beZLj3v5kPpmdMAMFYzUcI4gKe8ZRZVCWBxuNBquIlEvvVmUr/i0U3hS4LLDbdIW6QGdPv3NrqLAVKhdmId4AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ntAtTCMcbHSjuDHVGPGm1FRLN0bmiJDw3df60Y/3c3o=;
 b=iRg/NoWOwWjjjc4h96e680DZH7H0iU9lI5b/g805M02nIWsc/91QaYJSPR2VyHTi5MBxfKSMe5AbWgYx/tcwAicZ5CQgShcQ6vqMQ5X+aL9fiBPO4+1QnkLpezwM33zwIG1+9Y9mwTIaFYI6cd5L5VECbBuEQY7v5ZuFzi2IToGE7kZsyj410mSJZmWcGZXZPmMBjLga+1mVKyLeIcxoxTQdpcAT5Ho0zsVt9EfO1YKVq2JRQ62wDDQl/NhZLzsBChxGVL/qP7vPU3YCuxSXu4VyUTryMGT1CixM5V0qMqxQg7xbsK7QQsjwGCOyGULV0ofvuSCxvEmBDXdBsT0Bcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ntAtTCMcbHSjuDHVGPGm1FRLN0bmiJDw3df60Y/3c3o=;
 b=VOxLsZlxllY75Miftz8l9LqXMwOxCqwGszT2/qvkJDCetb+TsEhMb3pofuGUPdZ0+nW2naLp0M41ooI1QPEARWfU68d7xJelLZXoBs7CCgajVnDO1UmQoScdoMc83ywQa/mCGtm2+U4c+LHRWiPj39fzZhUKD/eTxERU/oUb8/s=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=synaptics.com;
Received: from BN9PR03MB6058.namprd03.prod.outlook.com (2603:10b6:408:137::15)
 by BN9PR03MB6137.namprd03.prod.outlook.com (2603:10b6:408:11a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.20; Fri, 25 Jun
 2021 07:57:17 +0000
Received: from BN9PR03MB6058.namprd03.prod.outlook.com
 ([fe80::502a:5487:b3ee:f61c]) by BN9PR03MB6058.namprd03.prod.outlook.com
 ([fe80::502a:5487:b3ee:f61c%3]) with mapi id 15.20.4264.023; Fri, 25 Jun 2021
 07:57:17 +0000
Date:   Fri, 25 Jun 2021 15:50:12 +0800
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     Nick Desaulniers <ndesaulniers@google.com>, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Alan Modra <amodra@gmail.com>,
        =?UTF-8?B?RsSBbmctcnU=?= =?UTF-8?B?w6wgU8Oybmc=?= 
        <maskray@google.com>, Quentin Perret <qperret@google.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH stable-v5.4 v2 2/2] arm64: link with -z norelro for LLD or
 aarch64-elf
Message-ID: <20210625155012.4aec8450@xhacker.debian>
In-Reply-To: <20210625154737.3d64a434@xhacker.debian>
References: <20210625154737.3d64a434@xhacker.debian>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [192.147.44.204]
X-ClientProxiedBy: BYAPR06CA0033.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::46) To BN9PR03MB6058.namprd03.prod.outlook.com
 (2603:10b6:408:137::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xhacker.debian (192.147.44.204) by BYAPR06CA0033.namprd06.prod.outlook.com (2603:10b6:a03:d4::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.19 via Frontend Transport; Fri, 25 Jun 2021 07:57:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 14318e6b-7165-4199-c414-08d937aeda0c
X-MS-TrafficTypeDiagnostic: BN9PR03MB6137:
X-Microsoft-Antispam-PRVS: <BN9PR03MB61372E2FCFCFE1A04D415A1FED069@BN9PR03MB6137.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4IV2hppgoe4nxQaMeQnnFa7NB9eZC8lq7K3BWtHf/49sQQQTsA6nBqFkajLC19zPI1GEtEFVNvziGPJBeL7vuPU052hxGuif+Rm/nhNnZRme5J6t4iU9M+WxxB+TZRSit9mpSAx/G5ABIOPBvYOHVxCK3uoluV+/BWWj8rq8ua4Zl6G5KAXEVrj98hijiT5GKyi/nPMm8o1eGd3nYGTvBM0kd/bFNZD5+r6Yq4xFyNl7p1iVAtlNRp6yorJha8zTOZ95niEfYxjkSrL20YNhDTQY+l+eOs6JsPsRISRTiNlpljmd582bJedES8rCtPWlUL2Bu+pPOA8m697kPPDUMH71bHmn1Nt49Kb/w0Wy1BFPX8GxlvAuzKwdRHkfPzLnkuBX3//ui/n97QMk9VVNkme+XxUNejHLS9hqWNGqjR3CCwab95Aq3K8Om0DSsh+GWfK7JNWsgMY5FSQArTNsdiEWVL6zVY9HLJLPPnfIaF0Zm8HrwL4p5MPNNEbpSl2wzysqFcFqaxdY+Vkm10nW7Lc/n9my0Iq4i2BnZlfO4wgJeFf302TpSDHwgQErNYvZZYpjjjuYw9J5NzrSfxNrUI3F9u9Axgh6tpQphtwjQi3fnL3ME+6yP6034CVZ3+Os7PlObW3kZLNbUqv9wEWlRayj5mm/cgrpXUay3P9s1HlxGMkwAFmc/QjpyAXAh1ZAhmOmoORa5I7CkDZoYzgrKCu9bXaO8+Yi/y1kGkWzQVpMqil5WAGVEEyTlQ9S/1EqxXYdn+dmS32UOS03zKaaHJUeSerVVORuZgThZiwMKV+RIO5ZmphyeG2wJCwr9mS6Qvl7NJjd2RTVuVeNyiIqFg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR03MB6058.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(366004)(396003)(39850400004)(376002)(52116002)(2906002)(186003)(66946007)(316002)(66476007)(8936002)(66556008)(7696005)(26005)(478600001)(55016002)(5660300002)(966005)(16526019)(66574015)(9686003)(110136005)(7416002)(1076003)(54906003)(86362001)(6506007)(8676002)(38350700002)(38100700002)(956004)(4326008)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TzBtN3B0WGthRUExNGwvUUJQV29FV012Tk5EcE9ZcEdOVUM4YUJGeEtCK05z?=
 =?utf-8?B?MEkyelpFam1QRUR3d0dUeWFhQkFLRzQvWTJPenNLWDVrM1JHWGc0QmRNclB1?=
 =?utf-8?B?d2s5RWpUQmlvaC9XUWV2dUh3RnNSS1VNbHllN05tV2k4cVd6YklKVllJeW9l?=
 =?utf-8?B?UVRQMWpwcWI1dXFaQ0hWczdmY0tmWVVuQ041ellWV3JkRXQvdXJCQ0FHVi91?=
 =?utf-8?B?QjgvYXpQc1pGMXAvd09HYzlHZWE1M1lJQTdReHFYazQwZnM1MDQ5T3l3TmJ5?=
 =?utf-8?B?MFVuMVVOOHBUTEh6eFBZNkttMU9sdHJUeUJ4eXJ2OWFlYUplRWwvVjlnZ0dq?=
 =?utf-8?B?M2ZZdk9yT1BvVVkvN0ZIamFMUTJ3aUhYMkhEenppcWs4b0RuWWlpdmY0NlFD?=
 =?utf-8?B?RGZneHowdzRWNjgrMU4wR2dITGMrcUsrbkRkNU9FamtMQkJRSGtabExGU2Qw?=
 =?utf-8?B?MktjaEJZWTdBTkFHUFAwSk93Z0RxVWhORm51VW9BSmJJRExpNDA5TWRyWWV0?=
 =?utf-8?B?VFg5TG5XUHhlemtGb1p3UVIwMmdYZXNaZG5idnBOeXN5c1JQS2RCU0NtZW1t?=
 =?utf-8?B?clFBSWd1TXV1NkVQcEdMR2VPQ0tZVnVFNnNJZFlwYjJuZ3ZNaE8vYlZGYjFt?=
 =?utf-8?B?dzlidVBSOWxCSFdPSUZJbnpyQWttUlJiU215bWYrZnd6Q2lXNFZSSXljS1Fo?=
 =?utf-8?B?cmRmQWtxOTRRNlB5a0cwK2sxKytPQWlWdnI2dVppMzhMTnc0TEs3N1B3N0dG?=
 =?utf-8?B?aTFlK0xhN3FzMS9WTEM0eDQ4bnhFMXBFRWliOHczWCt0aEdzOTdDUHI3T2Z0?=
 =?utf-8?B?UVF2V253SWtHM1FyNW9YbmdCT0h3Q3dkSTRLNm0vQk9tK2s3N2JlZjU3emVQ?=
 =?utf-8?B?ODNmWVNUZWQwODR5M3pOQ2RrTUVid3RhUkNZUzQ1Qy9HeXNPRm9lN21nbG12?=
 =?utf-8?B?MzlKREVaZ2p1U0N3UGZhY2hadW1QaXBRYmRKZUtmOXhEaW9wQXNNeDdEekNz?=
 =?utf-8?B?VDh6OUlKZVRjeDBGTjB5SEpZa2ZGRE9WRVI1dEQ3Y3RLLzlQYUZJMW4yajU0?=
 =?utf-8?B?Ni9PdVdTcTAzanB4bXdZdThYa2Zrd0htVHVPQXpUZ0JVaEpQTDFUN2tuaDFQ?=
 =?utf-8?B?bG9YSk02dW1iVnFmTFI5YkRhZDByTUJvMWd4d1FQVHJyTXg3WlhUTEVNbk84?=
 =?utf-8?B?TjErN1Z4Y1RxNXJCL2U1V3VWZi95ZTdMV2s4ZGVMUzNwb09yWjc0WDA3dHgr?=
 =?utf-8?B?VW4yZE03NjRLMFRLbzBQU2txcEpTckxLSy9PdzFWVmFKME5EMXRpSUNJWjVO?=
 =?utf-8?B?d0ZBcXpOTnhpc1JQRTZMMERWdittNHB6ME8zR3VEVVRNUm5EdCt4WlZrL2dX?=
 =?utf-8?B?TUtmZVh6eTRnWW1ZcGliTkUycCtCNVIzTjhmMUo3N1MvYVpWSEliWEZWb1l6?=
 =?utf-8?B?c2UxM0k5MzJUMklBZ3FUbjU5cWUxRlRiU2d0MlZ3MWZhOUpmVWZnUXJBZ3FR?=
 =?utf-8?B?Q01qUy81QWJDUk1wcndsZVcyNlU0a1o1UGFDRmZxT0FLb3M1dU1mcVFFQ0Er?=
 =?utf-8?B?YUI1cUdWN0x0Z2VJNW9OcFcrNWh3L3RlUWhobk1DMFpzbTE4dERmdG1kZFBX?=
 =?utf-8?B?WVlYYWhjUFJyNG91aUZpVWNkOGlGQXVUQnFBa2NqbGR2N3VFd3g2VHZaME45?=
 =?utf-8?B?dlZSVjZVSjJ5ZEJpSnNlaUlUZlBZbmNJdUx0QWlhWXhqMDMrVTdwdFYzaUta?=
 =?utf-8?Q?ir+Vl1rzlzyIJwWMzHss+KXCQNZ8tHs3lBojzTJ?=
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14318e6b-7165-4199-c414-08d937aeda0c
X-MS-Exchange-CrossTenant-AuthSource: BN9PR03MB6058.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2021 07:57:17.3564
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a6mkC3YbMYqKDtHJMwrS7s2vECuequtvWIK1c2lqqXUHECjjdW4p+zaAEu4V890BGtlktBsV7acKOQkuFvxxdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR03MB6137
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nick Desaulniers <ndesaulniers@google.com>

commit 311bea3cb9ee20ef150ca76fc60a592bf6b159f5 upstream.

With GNU binutils 2.35+, linking with BFD produces warnings for vmlinux:
aarch64-linux-gnu-ld: warning: -z norelro ignored

BFD can produce this warning when the target emulation mode does not
support RELRO program headers, and -z relro or -z norelro is passed.

Alan Modra clarifies:
  The default linker emulation for an aarch64-linux ld.bfd is
  -maarch64linux, the default for an aarch64-elf linker is
  -maarch64elf.  They are not equivalent.  If you choose -maarch64elf
  you get an emulation that doesn't support -z relro.

The ARCH=3Darm64 kernel prefers -maarch64elf, but may fall back to
-maarch64linux based on the toolchain configuration.

LLD will always create RELRO program header regardless of target
emulation.

To avoid the above warning when linking with BFD, pass -z norelro only
when linking with LLD or with -maarch64linux.

Fixes: 3b92fa7485eb ("arm64: link with -z norelro regardless of CONFIG_RELO=
CATABLE")
Fixes: 3bbd3db86470 ("arm64: relocatable: fix inconsistencies in linker scr=
ipt and options")
Cc: <stable@vger.kernel.org> # 5.0.x-
Reported-by: kernelci.org bot <bot@kernelci.org>
Reported-by: Quentin Perret <qperret@google.com>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Cc: Alan Modra <amodra@gmail.com>
Cc: F=C4=81ng-ru=C3=AC S=C3=B2ng <maskray@google.com>
Link: https://lore.kernel.org/r/20201218002432.788499-1-ndesaulniers@google=
.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/Makefile | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index cd8f3cdabfd0..d227cf87c48f 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -10,7 +10,7 @@
 #
 # Copyright (C) 1995-2001 by Russell King
=20
-LDFLAGS_vmlinux	:=3D--no-undefined -X -z norelro
+LDFLAGS_vmlinux	:=3D--no-undefined -X
 CPPFLAGS_vmlinux.lds =3D -DTEXT_OFFSET=3D$(TEXT_OFFSET)
 GZFLAGS		:=3D-9
=20
@@ -82,17 +82,21 @@ CHECKFLAGS	+=3D -D__AARCH64EB__
 AS		+=3D -EB
 # Prefer the baremetal ELF build target, but not all toolchains include
 # it so fall back to the standard linux version if needed.
-KBUILD_LDFLAGS	+=3D -EB $(call ld-option, -maarch64elfb, -maarch64linuxb)
+KBUILD_LDFLAGS	+=3D -EB $(call ld-option, -maarch64elfb, -maarch64linuxb -=
z norelro)
 UTS_MACHINE	:=3D aarch64_be
 else
 KBUILD_CPPFLAGS	+=3D -mlittle-endian
 CHECKFLAGS	+=3D -D__AARCH64EL__
 AS		+=3D -EL
 # Same as above, prefer ELF but fall back to linux target if needed.
-KBUILD_LDFLAGS	+=3D -EL $(call ld-option, -maarch64elf, -maarch64linux)
+KBUILD_LDFLAGS	+=3D -EL $(call ld-option, -maarch64elf, -maarch64linux -z =
norelro)
 UTS_MACHINE	:=3D aarch64
 endif
=20
+ifeq ($(CONFIG_LD_IS_LLD), y)
+KBUILD_LDFLAGS	+=3D -z norelro
+endif
+
 CHECKFLAGS	+=3D -D__aarch64__
=20
 ifeq ($(CONFIG_ARM64_MODULE_PLTS),y)
--=20
2.32.0

