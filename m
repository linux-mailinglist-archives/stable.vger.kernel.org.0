Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41AD03B2B22
	for <lists+stable@lfdr.de>; Thu, 24 Jun 2021 11:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbhFXJLw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Jun 2021 05:11:52 -0400
Received: from mail-co1nam11on2082.outbound.protection.outlook.com ([40.107.220.82]:17697
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230102AbhFXJLv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 24 Jun 2021 05:11:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iW2d2nnc2S8xj6t6S253Ad7kIZWjzdzJNnCPA9srIA3kBxRc9q+Q6Eohrea/ePjtc9+SKxPsKN4TPPm/EEZWWKj4TdT9T7n/HuR4AvR4PKPRXgwZaBO3yvphUt39CEnsvPNAWze0ZyLMtuQZ1E5f2a6QTTDBOD6PSEUMvZSh7i/jm2Yt7Oe6iI4WoKkTbIfd7SLeX7ZQZTEBtHcLd9zEQiZhgpQ3jYZq9Ez4n6tcFFlmXcrypLeSzi0ldy2tqPHESFefNN8DbWs5zrFzAWtkmMC6hW4oT4z4rnufOg6ZL3oQYV47RdihAgsN5MOqVWowQ/0vc83tDxpW8l2uNTgACA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ntAtTCMcbHSjuDHVGPGm1FRLN0bmiJDw3df60Y/3c3o=;
 b=UAxK5d3q3ZkLr7USZmSxs6RIzkGgwaDR4qClgrHZvuGKUHZ4YNJOptwyqVKq+uCvHVuvzcqHbOEwKNMNwRoqoyiltUikgDK3X+27+oXCk3VT7ZTvF8j7GREftiN7dR5Cj2JXivH+0TUUoOK+db0SCXLNPEWePSRz2WxcOJHupxsFTQGzvpAFYnYTePf2ktI8JM+EneQbM+wFMSyQNcL4RBE2z/Kx2UaevOlIXdMuNgPy28Byb09kTlNfcgLQjO0OCiQiAxXw2xHd8k0V76UObFhaYsZYT++0j9ucZEEMkOKLclLRKKJwKs4UrnIdS9hAZcdVdG7zle6XHd//0SOrjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ntAtTCMcbHSjuDHVGPGm1FRLN0bmiJDw3df60Y/3c3o=;
 b=jmEW5CFRVk7CoY8wxiXMAeLUCxnOzuAIkY6N6GbB1npmWRLZkIW6FFOrVJ+/iioWa36JABDHBprcLM/mcp2TqLulhIBq+lqtEPNKkyFDOA9xU2EtFaRrmMZ3N8Zmxh69T5usyXwxH+YTnDMreTwmGbpSONWfp5MGh1ouZZx5wXI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=synaptics.com;
Received: from BN9PR03MB6058.namprd03.prod.outlook.com (2603:10b6:408:137::15)
 by BN6PR03MB2914.namprd03.prod.outlook.com (2603:10b6:404:119::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.21; Thu, 24 Jun
 2021 09:09:31 +0000
Received: from BN9PR03MB6058.namprd03.prod.outlook.com
 ([fe80::502a:5487:b3ee:f61c]) by BN9PR03MB6058.namprd03.prod.outlook.com
 ([fe80::502a:5487:b3ee:f61c%3]) with mapi id 15.20.4264.020; Thu, 24 Jun 2021
 09:09:31 +0000
Date:   Thu, 24 Jun 2021 17:09:19 +0800
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Alan Modra <amodra@gmail.com>,
        =?UTF-8?B?RsSBbmctcnU=?= =?UTF-8?B?w6wgU8Oybmc=?= 
        <maskray@google.com>, Quentin Perret <qperret@google.com>
Subject: [PATCH stable v5.4] arm64: link with -z norelro for LLD or
 aarch64-elf
Message-ID: <20210624170919.3d018a1a@xhacker.debian>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [192.147.44.204]
X-ClientProxiedBy: BYAPR02CA0039.namprd02.prod.outlook.com
 (2603:10b6:a03:54::16) To BN9PR03MB6058.namprd03.prod.outlook.com
 (2603:10b6:408:137::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xhacker.debian (192.147.44.204) by BYAPR02CA0039.namprd02.prod.outlook.com (2603:10b6:a03:54::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.19 via Frontend Transport; Thu, 24 Jun 2021 09:09:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 46bb5bfb-a4bc-42da-b8f1-08d936efc6c9
X-MS-TrafficTypeDiagnostic: BN6PR03MB2914:
X-Microsoft-Antispam-PRVS: <BN6PR03MB2914690956DAB87BA5F78C9CED079@BN6PR03MB2914.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y1L8T87OsiFWNTGX9Od13IZ52Ka9q6uSA8gLZQ6QavTsMEElxUq3qIrjAsoObpK0sKZLavk+tD/Q/hD62HrCUQnJKDn7nYBa4n4A1rllArAl71HcokscVfU26WXi6IHr7E88mUPu77ZuOsz5Y6vSKpqUD1aKVukQgTu/hyTt4ZxbNNHlIArf15L3gmM5bj/FWKUpQK0V8OW4ZOuowTaXDk2WHRJ5w/EGos42gPEbbP42V8e6+RIBb3QVVBuklczF9FjdbKwf7DIjl3ylIpWAPj6cQirI3Vl2rRNksXSCMx9eDYReamFYdKdAhd7ycdR5tpCxInez0vFaG5IagEnNj9Y42NWYsYIHCnX5BRcqrx/KfM9PNfYmeep4KddO7Z32EwHwbtInjp653pQ87/CYAR4F0oJ55fGn0DfWcHDXe4P/FVzpg+cc3+dTPpcBuXj+8RaeQNkSDlj9NkTu4T54vulP90F9FUyY277xSfU9sKDFzpz/2x5stHZaX+/PIBfNAuiubG6aSxF0u0DneitXMpOkrK8rW7irH/p8S3WT+UySrJcxlW+QbXMdLXWvgN7BZVot0vbjvZ0witWgzDNu3Vrjm+7QfBbz4HkHtcRSDNivIxkI9oFAICQ9DdbcdP4eW7OmB0vbUvtcix8udD1T0Raf6bZrODoCvyrXWw8L1eOKh9Squ3+DOarqMQUJT8LDBTQ7427V8ajLeRXU4savHNUkcaQtx+MZDUr/2Z3mpWyTbxbSdnq9PO+ZSmSQumTojdyRreeYfCEmgxrSbz17jm8jdf8EV2CvBkWhft0/apU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR03MB6058.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39850400004)(376002)(366004)(346002)(396003)(38100700002)(2906002)(38350700002)(316002)(1076003)(86362001)(8936002)(6666004)(5660300002)(956004)(8676002)(186003)(26005)(83380400001)(66574015)(478600001)(16526019)(4326008)(110136005)(966005)(52116002)(7696005)(66476007)(6506007)(66556008)(55016002)(9686003)(66946007)(7416002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?STUwck10S2R2YWozQ2Q1M2k4b3MzNGNmamJKVXRnQzI0L1BtMzlGRUYwdEo3?=
 =?utf-8?B?TGoxNnAzQWZtemRHdHoxUjhqSUo0ZW01cDJkV2ZBY2RpazNnSmdUb0c1eG94?=
 =?utf-8?B?dTB2U2gvcGJWaHQvM2pPWUgzNkdhdTl4WHY0aWhXcUFDWTZWRXBTdGxsUHlj?=
 =?utf-8?B?eWRES21MSXdZUkwrVjkrRzBGTXdrV29oeS9MWGJscU1kSjBWa2JsU1cvd0VZ?=
 =?utf-8?B?a3JBMDZybkV4YkFGTmJXeEVPOEhFM2Jldnc4STkxRTk1VG1ja1FtbDlRbE9F?=
 =?utf-8?B?TTV1cWg5R2Fkb3RHQ2c1bzl1K0RwQUNWMWRLWjhCOURsSkY2R05aVCtZOE5a?=
 =?utf-8?B?elhuWnh0bXNBVFZ5RVpWeGplMURIdnpraHFqd2ExLzI3ck5QMmlwZkRGZDJP?=
 =?utf-8?B?eU5OcityVXpLWHF3eHljTW8rTFg0TWpmN0RlMkZ6bUJtNGJ0dUp1N2Z4NzlR?=
 =?utf-8?B?aGVxNEZaeEFTR0V0cHZDdVM0b1JnVkpVWVZyT01pUThDUUR4YkpycGJkY3Zo?=
 =?utf-8?B?Zk5PMVRWbVZlcGNId0JJSzRvTFpKQmRIRUFMMWJFeDdMVG9xV3VEc1RBUjll?=
 =?utf-8?B?VitwdHdSbFdWaUlHdG8zRldYOW9xY3VCcjF1bEFKY0k0Z3krSmRDRVNxTC9X?=
 =?utf-8?B?U05yaDlzNFZKNkRUelNqMjhBQVFDc1Bqdk1STU8vTy9qVFh5cU1oN3c1eHBv?=
 =?utf-8?B?SFU3QkRKV3U1U2NaMzczR010MUxKN09oRVl1aDFJcms5UllJc1p5dmd5TTBY?=
 =?utf-8?B?Szl0TVJCckROWElRaDRIT21KdnhaMzBoTVZRcGxhRElkd2dmUTA2VzJvd2x4?=
 =?utf-8?B?SHRQRmp0UkgwdTBVdWZWdmxrOUZ1OHBpSVJYeE5Gc29URDVPRnJZbnpjcitt?=
 =?utf-8?B?M1l3RHYwT2ZjNE9OZCtHYTNWV1hvTUx5eVNBTnFXbXRqWlJuYmQ0aTVJOXAv?=
 =?utf-8?B?ckYvMjI3aGVPRHdiL1lBTEZOL3NiczBobFhGcHNUUXpaNXZYL2FlSkxyK3lL?=
 =?utf-8?B?d3dnMkJDL08wOHRQR2dHbk1HQkI0QTd3ZWpPUm9IRVF3SWcvTU9tWHg2Ykk2?=
 =?utf-8?B?U1cwV2phMVk1ckk1bkVreGw0V0NrMjdYMXNPMmhWM1BtS2JHbjNIL2J1NzdZ?=
 =?utf-8?B?cGJ3RzVPNWtRR1BNcGpLdWNmbXNNMksvcHRHNWtOOEptVk8ydlcvU0lwMlVS?=
 =?utf-8?B?UlVndWwwVFhOQ0NkTlNwbE00ZnoyNXc3a1oyVWZFbVVSQXZrVWNUemk1TEZL?=
 =?utf-8?B?M1QxZEVyNzV4K1ZJQUdHTEs1MUV6RTc3UnM3RzRUeFh5QnVqM2lDT295ZEN5?=
 =?utf-8?B?cjNTNzM1cEdsVEIxOXVLc0ZZUndSYVYzSTVjMmhXc3dKQ0czRzdHT2FKUlpX?=
 =?utf-8?B?bWYrUTlNMlFFNXM5V0krNUVnZlBEMU5SOGhkd2RUMndBY3Y0UGdiNWcvQWRC?=
 =?utf-8?B?ZDFQWm5SWTFKY2YwWUlmMTNIVkJSR0s1WENVZ3lBcHdFRWljeGhFRlBlKzQr?=
 =?utf-8?B?eS9rdDdDUGFId1BLcjVUQjRYczJCTjd0MWgzYlp5YXkwbEtzZkFIZjcrSGVX?=
 =?utf-8?B?dmJSTXY1Mk1XaXZEL2Z1SmxldlU5YVpKTkZ1a3d3dGV6OTNvMHBUVTVYdE1u?=
 =?utf-8?B?clNJNVJzN29ZV3BsMk9MSzZLc3ljMGduS2tXMCtYbW9KdlorZWdYelFzMHYw?=
 =?utf-8?B?L2dSeHBUQ3hvQ3pCelZxVFBaUGdQYnc4Z1pLTDI2eUg2RXA0ZFNJcWR1bGRj?=
 =?utf-8?Q?7DzMwdyA338aNTtho6WITREefQgMaQG+F6V+wyD?=
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46bb5bfb-a4bc-42da-b8f1-08d936efc6c9
X-MS-Exchange-CrossTenant-AuthSource: BN9PR03MB6058.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2021 09:09:31.1102
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sea1ax7A2VebJn+H/wjvWtYGO8PojUTmjvhv0cV+afovydfRFThWm4fX8ZzCUzckZZKUtOErvQnnggklDf3C3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR03MB2914
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

