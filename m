Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF20338A34
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 11:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233409AbhCLKep (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 05:34:45 -0500
Received: from elvis.franken.de ([193.175.24.41]:52576 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231317AbhCLKem (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Mar 2021 05:34:42 -0500
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1lKf7u-0007WV-02; Fri, 12 Mar 2021 11:34:38 +0100
Received: by alpha.franken.de (Postfix, from userid 1000)
        id 081E0C1E4A; Fri, 12 Mar 2021 11:27:31 +0100 (CET)
Date:   Fri, 12 Mar 2021 11:27:30 +0100
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Cc:     Matthias Brugger <matthias.bgg@gmail.com>,
        John Crispin <john@phrozen.org>, linux-mips@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] MIPS: pci-mt7620: fix PLL lock check
Message-ID: <20210312102730.GC7027@alpha.franken.de>
References: <20210307041724.3185139-1-ilya.lipnitskiy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210307041724.3185139-1-ilya.lipnitskiy@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 06, 2021 at 08:17:24PM -0800, Ilya Lipnitskiy wrote:
> Upstream a long-standing OpenWrt patch [0] that fixes MT7620 PCIe PLL
> lock check. The existing code checks the wrong register bit: PPLL_SW_SET
> is not defined in PPLL_CFG1 and bit 31 of PPLL_CFG1 is marked as reserved
> in the MT7620 Programming Guide. The correct bit to check for PLL lock
> is PPLL_LD (bit 23).
> 
> Also reword the error message for clarity.
> 
> Without this change it is unlikely that this driver ever worked with
> mainline kernel.
> 
> [0]: https://lists.infradead.org/pipermail/lede-commits/2017-July/004441.html
> 
> Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
> Cc: John Crispin <john@phrozen.org>
> Cc: linux-mips@vger.kernel.org
> Cc: linux-mediatek@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Cc: stable@vger.kernel.org
> ---
>  arch/mips/pci/pci-mt7620.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

applied to mips-next.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
