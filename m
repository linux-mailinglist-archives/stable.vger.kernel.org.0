Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7E42A0DDF
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 19:53:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727478AbgJ3Sw7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 30 Oct 2020 14:52:59 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:37179 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727522AbgJ3Swy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Oct 2020 14:52:54 -0400
X-Originating-IP: 91.224.148.103
Received: from xps13 (unknown [91.224.148.103])
        (Authenticated sender: miquel.raynal@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 85FC460004;
        Fri, 30 Oct 2020 18:52:52 +0000 (UTC)
Date:   Fri, 30 Oct 2020 19:52:51 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
Subject: Re: [PATCH] mtd: cfi_cmdset_0002: Use status register where
 possible
Message-ID: <20201030195251.687809f7@xps13>
In-Reply-To: <aefef0187e5ebbe315e57e834ff1ba756ba88817.camel@infinera.com>
References: <20201022154506.17639-1-joakim.tjernlund@infinera.com>
        <20201030184736.4ec434f5@xps13>
        <aefef0187e5ebbe315e57e834ff1ba756ba88817.camel@infinera.com>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Joakim,

Joakim Tjernlund <Joakim.Tjernlund@infinera.com> wrote on Fri, 30 Oct
2020 18:39:35 +0000:

> On Fri, 2020-10-30 at 18:47 +0100, Miquel Raynal wrote:
> > 
> > Hi Joakim,  
> 
> Hi Miquel
> 
> > 
> > Please Cc the MTD maintainers, not only the list (get_maintainers.pl).  
> 
> I figure all maintainers are on the list ?

I personally don't look at the list very often. I expect patches to be
directed to me (in the current case, Vignesh) when I am concerned.

> 
> > 
> > Joakim Tjernlund <joakim.tjernlund@infinera.com> wrote on Thu, 22 Oct
> > 2020 17:45:06 +0200:
> >   
> > > Commit "mtd: cfi_cmdset_0002: Add support for polling status register"
> > > added support for polling the status rather than using DQ polling.
> > > However, status register is used only when DQ polling is missing.
> > > Lets use status register when available as it is superior to DQ polling.
> > >   
> > 
> > I will let vignesh comment about the content (looks fine by me) but you will
> > need a Fixes tag here.  
> 
> This is not a Fixes situation, no bug just a hw enabling thing.
> Also, I would like to see the Status patches be backported to 4.19 as well.

Backporting features is IMHO not relevant. I guess stable kernel only
take fixes...

Thanks,
Miquèl
