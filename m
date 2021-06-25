Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2ACF3B413C
	for <lists+stable@lfdr.de>; Fri, 25 Jun 2021 12:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230436AbhFYKPF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Jun 2021 06:15:05 -0400
Received: from mail-bn8nam12on2065.outbound.protection.outlook.com ([40.107.237.65]:23905
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230251AbhFYKPE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Jun 2021 06:15:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F0CXlm2KINe2a9mbkKAL4JiKpDoKA02Cow+FTtXnp8vXoES8tXeD+aVZNHBcJofTrYCf4t6hNe4Q+vyM7h20rFLIaXRSCcBeP4sE0MQkppa+xeHFyP2xY/XAsuk+eq9Wwxn031xTqc+gTvyZfbac0tPh4iXg2nbr+oqtJ5DuelTroyrA+F0T5KOwHi9sCy9LwQOUsMWAe/xS1XYCZNL8QPr5lKq1g488PRGLjNl74GoBk3HH9vv/7fE5uXfMNFQM2E35ATUOblBD1JrexxAp6cOpyJvx/6qS6Azyzit4/lJe0AOujQdnikkjDdYwgGJecXPNx1KcHLlKcR2xRqWvpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vewdj5LWw/wlfSDJ6NQ1c9khynQc+Y+gFwZznceGomg=;
 b=amHbqF99+sKj5MFqgtjsTA/3tVSALAKY1E7fytrCI+xFJY2StH0YYw2uNZ91R3QibQg4j7Tr8ILsBc8W9ohwMancy9RkP/WFjIwsFVFOKGw6jUukwqnvT5uFMjoYb3zgRGCpCIBcI1JKBC0vYa5zm1soIR4qZSmp1x2G0Ev8QTS4i0FEDD7Sntw5Oc8hrY2v3cvPxOxHNS2z1fsydp8LjBcCxQXJT8dlKtP95c8l1PDO5bDrbkw2do323BsRWX2V19/6vAqpyU/N3VnLOHFYUBy1J+CYz4/nBmX+FVlioRSjqLwoekEh3SKBl0o19lqPIaxiSFO1n52JmYZn46XTOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vewdj5LWw/wlfSDJ6NQ1c9khynQc+Y+gFwZznceGomg=;
 b=dYw1GGJnc0SJm6C71bRyYD/njBwgsXft/lYiOIHwMru9TDQ6ymBoO16N2npcn343OfeY4TGIfjMdpVSH/tRBAelUBzK69tokP8wcJiC8bjPVy7Ed8kv6nOAE9Aok6WuqVMK03oXQobGAH3TQ1J/imsAjVfhwtGragI/IZAgd3oQ=
Authentication-Results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=synaptics.com;
Received: from BN9PR03MB6058.namprd03.prod.outlook.com (2603:10b6:408:137::15)
 by BN6PR03MB2916.namprd03.prod.outlook.com (2603:10b6:404:10f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.20; Fri, 25 Jun
 2021 10:12:40 +0000
Received: from BN9PR03MB6058.namprd03.prod.outlook.com
 ([fe80::502a:5487:b3ee:f61c]) by BN9PR03MB6058.namprd03.prod.outlook.com
 ([fe80::502a:5487:b3ee:f61c%3]) with mapi id 15.20.4264.023; Fri, 25 Jun 2021
 10:12:40 +0000
Date:   Fri, 25 Jun 2021 18:12:30 +0800
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Alan Modra <amodra@gmail.com>,
        =?UTF-8?B?RsSBbmctcnU=?= =?UTF-8?B?w6wgU8Oybmc=?= 
        <maskray@google.com>, Quentin Perret <qperret@google.com>
Subject: Re: [PATCH stable v5.4] arm64: link with -z norelro for LLD or
 aarch64-elf
Message-ID: <20210625181230.7e0b02c9@xhacker.debian>
In-Reply-To: <YNWrXZNrtdg+8wEK@kroah.com>
References: <20210624170919.3d018a1a@xhacker.debian>
        <YNWrXZNrtdg+8wEK@kroah.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [192.147.44.204]
X-ClientProxiedBy: SJ0PR03CA0356.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::31) To BN9PR03MB6058.namprd03.prod.outlook.com
 (2603:10b6:408:137::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xhacker.debian (192.147.44.204) by SJ0PR03CA0356.namprd03.prod.outlook.com (2603:10b6:a03:39c::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18 via Frontend Transport; Fri, 25 Jun 2021 10:12:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e2d7c759-c298-4b75-0926-08d937c1c3a9
X-MS-TrafficTypeDiagnostic: BN6PR03MB2916:
X-Microsoft-Antispam-PRVS: <BN6PR03MB2916232DE394AD285E3E6BBDED069@BN6PR03MB2916.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DEjWHzk/XAFAs7PkFnE9KIGFVITf/46eofxqXbsnJpGlGwCnu9kyKmdpIVq9yLBy23M1r9NyP4jH8E3DteL5NyOVPvL4e2UCfE1MeFWCK57U4Jz3T2yv5c+OqNQZU2mhBPjwP67BsX+CAb1/nXzcQcV2iHMi47IFOerQNe3oOXkMVAOHE1F4X+KaiAeFZT5UqVhcwCZMnsS18EZ8kJhjeKFYEwhoEAs8SkIgLZpiqnKqfteUNyBVM4b+v2ybOrQrZKh6TbzM0EVE8fgjZ90WejswxOMf/VIb0Tj8GZ6N9IZV2NW+4ZfHFzPkbT1DlAV19JK3GIfw82zPPKJYYwbfjjLrjrokTFqFCMnqqh5+vzwYhBaJThj1Ud2rLeKN/84JV8RMF290EGzVQGxfaC6kCUUDMD67m3JWC7CUlMEcz+fvhRRpZhX9FeN2adWGclpKY4fwDc9dWe3KbVmOuzoNiopZu8BNxuRMyF7rrqexLtvd2ANBzFqiNzfqpr4g6XHK/36xDPOFcH7wEloViOvh2OluhNxC7Oe51BU0bqm3C85pgW97P78dH5SV+dIaoIJz+rxzzVRV9tEeoiuZ5l84i9KqeJSYOr+UDNEijbP2wUlyXY5MC8CKTCp9sqWJ2Ka6bxEZCqf/dN/GHg8XbNZU82p3tGCSAAzBqmvem9kzTUVsanPuC2rMD/zpQ5wbPlRSGyDDsfovw4aZXN7Xb4ekWw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR03MB6058.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(376002)(366004)(39860400002)(346002)(6666004)(55016002)(5660300002)(316002)(9686003)(2906002)(1076003)(478600001)(38350700002)(83380400001)(66574015)(66946007)(7416002)(38100700002)(66556008)(66476007)(8676002)(16526019)(86362001)(956004)(4326008)(186003)(6916009)(6506007)(7696005)(54906003)(52116002)(26005)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TTBtQ0dqOVYwOElVbkd1dE5ybkV4UnltMlFINzNnUnRYbnNpYkRrVU9XTE83?=
 =?utf-8?B?OStwVkRYQ2MvUVcvbUR4Z2RHS0FqWnIyZ3BXK1Y3Q0twbVNGZURtTldIbldw?=
 =?utf-8?B?eGZyaWduUWgzbk02M3JDS1NjVGl5TDFvbEJRQXZXazBHcENrbElIUk9yS0c0?=
 =?utf-8?B?a09ZWEUxd2JVWHF4Mm40aFFUMTNteDlJOERtNUhUWnRGV0xnZ3VxbXJKaUdE?=
 =?utf-8?B?TkVyZHZUQ01YUCtyOTJnaTl3eGFwZDZxbXIzUGFpWnB0U1EvYlVwZW9oZE4r?=
 =?utf-8?B?NFU5L0JobjgyZld3Z2QyOW5ibDlvVkxibkVscmhIeTNEMC9XejRucS9WNjF3?=
 =?utf-8?B?SmhodkFpZ0hJbENPK1hFYUhydU5xZTR0ckRXT3MrY3ZhZ2prd1JyNVkwWlBp?=
 =?utf-8?B?TjdydThRZC9Jc3lPRVVFSG1yd2Zta1NKTGhweFp2THBkOFNQRUJVT3pYeGts?=
 =?utf-8?B?bWVuZGtKNnNKQTROMEs3U01ZbnpBUWFPTmRPaEpmUitSTjkzekFHdlAzTzJY?=
 =?utf-8?B?N1MwT3luWXZRMkRQV3I2bCt4TmhzNm1CdXNVYUZienZLL0dYM1ZRUnY0Skpm?=
 =?utf-8?B?eWh6QmxLL20zQ3ZEYjd6bGt5MDhCWDFsR1NNK0xkaXkxMlpSYU9YbU9MRmg2?=
 =?utf-8?B?ZEdmSUZpK2FZNTA0RTVGK1JOOXRlckVoSko1STIvelR1NjdNcmpXaFlQaVgx?=
 =?utf-8?B?eDdMNktQR0JkRW92d09hdVF3UndjbWcvMFRJdC92WUVQakZ3YXd0ZWpJZWc4?=
 =?utf-8?B?ak1WTnRId0g4RTBYNzBTbTBieGtYVFR2eG9aZnBoYzJNN3FKZlRmc3lObDdQ?=
 =?utf-8?B?blhKZlNuQ0RKTUdqZnVBVU1JdFRCbFZHS25YZzI0Mjg0STNhd0IySFBhYzM0?=
 =?utf-8?B?eXVxcnJHeVFieTZVVjVjWjBialdmbUFnM1JhUTFNK2lLWEN5T3FRUUVlUi9m?=
 =?utf-8?B?OXRBVXVjNWRvM2gwaDhkYlhSNHdKV2V4dDBweG8vT1JmQllLeHkxR295Q3dF?=
 =?utf-8?B?WTgzK1VyZ0lxSDhkRGgreTdUbmZRd1dPTldIWStBQUhzUXdQZXk0aTZNbnNo?=
 =?utf-8?B?TUlBVmN4UkhKeStOdXBZNVZabEIwL1hrcTBCWTJiTkc2ZXoxSHF1UHRySXJX?=
 =?utf-8?B?ZWIzbG16cDBNOU1zZ0YxN0tNRk1Ody9qNGYwQ3ZBcTBORmUzQjBlcHp5cGhE?=
 =?utf-8?B?VlhvTUg0dzlHVUYvTElKZU10M3hCcVJMQzdoMW10Q2UvUDVWQkYrU0hFYWE4?=
 =?utf-8?B?NlpnWlJzQVJsc28xVUQwY2VleGZ2WCtmam54OTRBeWR1KytLWUg1emJPaHF5?=
 =?utf-8?B?Q0V1UDBUUTdUTWF0T3dKKzMvZC9nYUMxQjJESTY1RW1hWm0vU1AvMSt1UGVZ?=
 =?utf-8?B?aE8vM01PWW91Y2hyOFM0Z3N2Yk5vVXoyUHBYaHlsQ20veXE4RDVad0RkbDlq?=
 =?utf-8?B?SFgrTU1OQnVmd09VNnBTVkVNVi9WWkF6Zng2Mk1FZlVHcldqUU4vaWpESEdS?=
 =?utf-8?B?Qkc2TDJIc1MwWEd1TGh2cXQ0SFpNMWEzOTlBTmMrZFBSZnUrYUtBZHJXZnhN?=
 =?utf-8?B?MWJEOVJyUDVIUGhWdEVScGZwWlVyWURUbENwZEw3QU9tYk15U1FoencyMCsz?=
 =?utf-8?B?MXJ3MWZJalR3bXVxZnVlTGJCeUNsd1VJdDBnZ1JTR3gxVDEwMHpkZi93WU5r?=
 =?utf-8?B?QTZxVTdtWnJBKzB5U1NUTjJibkdqV051Vk5IbFNXQ054a25NRWZJK3kxSE80?=
 =?utf-8?Q?aMebqY/3R7415wrhWfZA3ONXOcMZVo/nlWLR2Ex?=
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2d7c759-c298-4b75-0926-08d937c1c3a9
X-MS-Exchange-CrossTenant-AuthSource: BN9PR03MB6058.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2021 10:12:40.2069
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LOcNLKhwRW1zWH/nf5Z3b24/BHwxw3dwXmpzx9GbhBCyDsG+4OVWS0fkqffADE/VJztT+V54mZX9QT+sjA6Hxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR03MB2916
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Fri, 25 Jun 2021 12:09:33 +0200
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:


>=20
> On Thu, Jun 24, 2021 at 05:09:19PM +0800, Jisheng Zhang wrote:
> > From: Nick Desaulniers <ndesaulniers@google.com>
> >
> > commit 311bea3cb9ee20ef150ca76fc60a592bf6b159f5 upstream.
> >
> > With GNU binutils 2.35+, linking with BFD produces warnings for vmlinux=
:
> > aarch64-linux-gnu-ld: warning: -z norelro ignored
> >
> > BFD can produce this warning when the target emulation mode does not
> > support RELRO program headers, and -z relro or -z norelro is passed.
> >
> > Alan Modra clarifies:
> >   The default linker emulation for an aarch64-linux ld.bfd is
> >   -maarch64linux, the default for an aarch64-elf linker is
> >   -maarch64elf.  They are not equivalent.  If you choose -maarch64elf
> >   you get an emulation that doesn't support -z relro.
> >
> > The ARCH=3Darm64 kernel prefers -maarch64elf, but may fall back to
> > -maarch64linux based on the toolchain configuration.
> >
> > LLD will always create RELRO program header regardless of target
> > emulation.
> >
> > To avoid the above warning when linking with BFD, pass -z norelro only
> > when linking with LLD or with -maarch64linux.
> >
> > Fixes: 3b92fa7485eb ("arm64: link with -z norelro regardless of CONFIG_=
RELOCATABLE")
> > Fixes: 3bbd3db86470 ("arm64: relocatable: fix inconsistencies in linker=
 script and options")
> > Cc: <stable@vger.kernel.org> # 5.0.x-
> > Reported-by: kernelci.org bot <bot@kernelci.org>
> > Reported-by: Quentin Perret <qperret@google.com>
> > Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> > Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
> > Acked-by: Ard Biesheuvel <ardb@kernel.org>
> > Cc: Alan Modra <amodra@gmail.com>
> > Cc: F=C4=81ng-ru=C3=AC S=C3=B2ng <maskray@google.com>

> > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> > ---
> >  arch/arm64/Makefile | 10 +++++++---
> >  1 file changed, 7 insertions(+), 3 deletions(-) =20
>=20
> Now queued up, thanks.
>=20

I assume the two patches in v2 series are queued up. Nick pointed out
applying only this patch can break kernel building with lld.

Thanks
