Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D31AE2F7E80
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 15:47:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729011AbhAOOru (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 09:47:50 -0500
Received: from elvis.franken.de ([193.175.24.41]:53922 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728292AbhAOOru (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 09:47:50 -0500
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1l0QNY-0006aU-03; Fri, 15 Jan 2021 15:47:08 +0100
Received: by alpha.franken.de (Postfix, from userid 1000)
        id E782CC057E; Fri, 15 Jan 2021 15:42:22 +0100 (CET)
Date:   Fri, 15 Jan 2021 15:42:22 +0100
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Aurelien Jarno <aurelien@aurel32.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        YunQiang Su <syq@debian.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        "open list:MIPS" <linux-mips@vger.kernel.org>
Subject: Re: [PATCH] MIPS: Support binutils configured with
 --enable-mips-fix-loongson3-llsc=yes
Message-ID: <20210115144222.GD15166@alpha.franken.de>
References: <20210109193048.478339-1-aurelien@aurel32.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210109193048.478339-1-aurelien@aurel32.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 09, 2021 at 08:30:47PM +0100, Aurelien Jarno wrote:
> >From version 2.35, binutils can be configured with
> --enable-mips-fix-loongson3-llsc=yes, which means it defaults to
> -mfix-loongson3-llsc. This breaks labels which might then point at the
> wrong instruction.
> 
> The workaround to explicitly pass -mno-fix-loongson3-llsc has been
> added in Linux version 5.1, but is only enabled when building a Loongson
> 64 kernel. As vendors might use a common toolchain for building Loongson
> and non-Loongson kernels, just move that workaround to
> arch/mips/Makefile. At the same time update the comments to reflect the
> current status.
> 
> Cc: stable@vger.kernel.org # 5.1+
> Cc: YunQiang Su <syq@debian.org>
> Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
> ---
>  arch/mips/Makefile            | 19 +++++++++++++++++++
>  arch/mips/loongson64/Platform | 22 ----------------------
>  2 files changed, 19 insertions(+), 22 deletions(-)

I've applied it to mips-next, but I consider such changes as rather rude.
I would have expected, that the workaround is only enabled via command
line option and not by default.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
