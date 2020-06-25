Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9198209B4E
	for <lists+stable@lfdr.de>; Thu, 25 Jun 2020 10:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390652AbgFYIbP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jun 2020 04:31:15 -0400
Received: from elvis.franken.de ([193.175.24.41]:36823 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389537AbgFYIbP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jun 2020 04:31:15 -0400
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1joNHs-0001Gi-02; Thu, 25 Jun 2020 10:31:12 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
        id 98D3FC06F9; Thu, 25 Jun 2020 10:23:11 +0200 (CEST)
Date:   Thu, 25 Jun 2020 10:23:11 +0200
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     =?iso-8859-1?Q?Jo=E3o_H=2E?= Spies <jhlspies@gmail.com>
Cc:     Paul Cercueil <paul@crapouillou.net>, devicetree@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] MIPS: ingenic: gcw0: Fix HP detection GPIO.
Message-ID: <20200625082311.GA6319@alpha.franken.de>
References: <20200623211945.823-1-jhlspies@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200623211945.823-1-jhlspies@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 23, 2020 at 06:19:45PM -0300, João H. Spies wrote:
> Previously marked as active high, but is in reality active low.
> 
> Cc: stable@vger.kernel.org
> Fixes: b1bfdb660516 ("MIPS: ingenic: DTS: Update GCW0 support")
> Signed-off-by: João H. Spies <jhlspies@gmail.com>
> ---
>  arch/mips/boot/dts/ingenic/gcw0.dts | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

applied to mips-fixes.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
