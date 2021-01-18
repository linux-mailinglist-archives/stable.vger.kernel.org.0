Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E30DD2F9DB0
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 12:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388407AbhARLKN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 18 Jan 2021 06:10:13 -0500
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:51169 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389955AbhARLKI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jan 2021 06:10:08 -0500
X-Originating-IP: 86.201.233.230
Received: from xps13 (lfbn-tou-1-151-230.w86-201.abo.wanadoo.fr [86.201.233.230])
        (Authenticated sender: miquel.raynal@bootlin.com)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id 37ACE20005;
        Mon, 18 Jan 2021 11:09:18 +0000 (UTC)
Date:   Mon, 18 Jan 2021 12:09:17 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Sean Nyekjaer <sean@geanix.com>
Cc:     Han Xu <han.xu@nxp.com>, Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Martin =?UTF-8?B?SHVuZGViw7hsbA==?= <martin@geanix.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] mtd: rawnand: gpmi: fix dst bit offset when extracting
 raw payload
Message-ID: <20210118120917.544af10c@xps13>
In-Reply-To: <d3ebfc3c-4842-a506-512a-28c6c02f6c42@geanix.com>
References: <20210104103558.9035-1-miquel.raynal@bootlin.com>
        <7db4b36e-23a6-6075-132c-214d043e78bd@geanix.com>
        <20210104121516.3d50fb58@xps13>
        <d3ebfc3c-4842-a506-512a-28c6c02f6c42@geanix.com>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sean,

Sean Nyekjaer <sean@geanix.com> wrote on Mon, 18 Jan 2021 12:07:01
+0100:

> On 04/01/2021 12.15, Miquel Raynal wrote:
> > Hi Sean,
> >
> > Sean Nyekjaer <sean@geanix.com> wrote on Mon, 4 Jan 2021 11:50:10 +0100:
> >  
> >> On 04/01/2021 11.35, Miquel Raynal wrote:  
> >>> On Mon, 2020-12-21 at 10:00:13 UTC, Sean Nyekjaer wrote:  
> >>>> Re-add the multiply by 8 to "step * eccsize" to correct the destination bit offset
> >>>> when extracting the data payload in gpmi_ecc_read_page_raw().
> >>>>
> >>>> Fixes: e5e5631cc889 ("mtd: rawnand: gpmi: Use nand_extract_bits()")
> >>>> Cc: stable@vger.kernel.org
> >>>> Reported-by: Martin Hundebøll <martin@geanix.com>
> >>>> Signed-off-by: Sean Nyekjaer <sean@geanix.com>  
> >>> Applied to https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git nand/next, thanks.
> >>>
> >>> Miquel  
> >> Hi Miquel
> >>
> >> Will you please queue this for fixes? It's quite relevant for 5.10 LTS :)  
> > Right, that will be quicker to have it in Linus' tree. I moved
> > the patch to the mtd/next branch.
> >  
> Hi Miquel,
> 
> Any guess to when the mtd/fixes branch will be pulled into Linus' tree?
> 
> /Sean

It should be in linux-next already, I hope to collect an other
important fix this week before requesting a merge of the mtd/fixes
branch for the next -rc.

Thanks,
Miquèl
