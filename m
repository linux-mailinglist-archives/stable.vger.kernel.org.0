Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1239F3B6F79
	for <lists+stable@lfdr.de>; Tue, 29 Jun 2021 10:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232421AbhF2IgB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Jun 2021 04:36:01 -0400
Received: from elvis.franken.de ([193.175.24.41]:57423 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232386AbhF2IgA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Jun 2021 04:36:00 -0400
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1ly9BU-0004qC-00; Tue, 29 Jun 2021 10:33:32 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
        id 6822BC0720; Tue, 29 Jun 2021 10:31:10 +0200 (CEST)
Date:   Tue, 29 Jun 2021 10:31:10 +0200
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Paul Cercueil <paul@crapouillou.net>
Cc:     list@opendingux.net, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] MIPS: MT extensions are not available on MIPS32r1
Message-ID: <20210629083110.GA4650@alpha.franken.de>
References: <202106192349.LlB9JRTC-lkp@intel.com>
 <20210625104929.42689-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210625104929.42689-1-paul@crapouillou.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 25, 2021 at 11:49:29AM +0100, Paul Cercueil wrote:
> MIPS MT extensions were added with the MIPS 34K processor, which was
> based on the MIPS32r2 ISA.
> 
> This fixes a build error when building a generic kernel for a MIPS32r1
> CPU.
> 
> Fixes: c434b9f80b09 ("MIPS: Kconfig: add MIPS_GENERIC_KERNEL symbol")
> Cc: stable@vger.kernel.org # v5.9
> Signed-off-by: Paul Cercueil <paul@crapouillou.net>
> ---
>  arch/mips/include/asm/cpu-features.h | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

applied to mips-next.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
