Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7AD3230598
	for <lists+stable@lfdr.de>; Tue, 28 Jul 2020 10:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728017AbgG1IjC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jul 2020 04:39:02 -0400
Received: from elvis.franken.de ([193.175.24.41]:51658 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728115AbgG1IjA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jul 2020 04:39:00 -0400
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1k0L8B-0000DV-02; Tue, 28 Jul 2020 10:38:39 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
        id B8779C0A94; Tue, 28 Jul 2020 10:30:51 +0200 (CEST)
Date:   Tue, 28 Jul 2020 10:30:51 +0200
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Paul Cercueil <paul@crapouillou.net>
Cc:     od@zcrc.me, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] MIPS: qi_lb60: Fix routing to audio amplifier
Message-ID: <20200728083051.GC9062@alpha.franken.de>
References: <20200727181128.25756-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200727181128.25756-1-paul@crapouillou.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 27, 2020 at 08:11:28PM +0200, Paul Cercueil wrote:
> The ROUT (right channel output of audio codec) was connected to INL
> (left channel of audio amplifier) instead of INR (right channel of audio
> amplifier).
> 
> Fixes: 8ddebad15e9b ("MIPS: qi_lb60: Migrate to devicetree")
> Cc: stable@vger.kernel.org # v5.3
> Signed-off-by: Paul Cercueil <paul@crapouillou.net>
> ---
>  arch/mips/boot/dts/ingenic/qi_lb60.dts | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

applied to mips-next.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
