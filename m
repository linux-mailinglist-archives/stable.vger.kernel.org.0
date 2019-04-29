Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96DB7DE8A
	for <lists+stable@lfdr.de>; Mon, 29 Apr 2019 11:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727589AbfD2JAY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 29 Apr 2019 05:00:24 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:50423 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727525AbfD2JAY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Apr 2019 05:00:24 -0400
X-Originating-IP: 90.88.147.33
Received: from xps13 (aaubervilliers-681-1-27-33.w90-88.abo.wanadoo.fr [90.88.147.33])
        (Authenticated sender: miquel.raynal@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 0C63560012;
        Mon, 29 Apr 2019 09:00:13 +0000 (UTC)
Date:   Mon, 29 Apr 2019 11:00:13 +0200
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Richard Weinberger <richard@nod.at>
Cc:     Daniel Mack <daniel@zonque.org>,
        Boris Brezillon <boris.brezillon@collabora.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        Tudor Ambarus <Tudor.Ambarus@microchip.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-mtd@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] mtd: rawnand: marvell: Clean the controller state
 before each operation
Message-ID: <20190429110013.68984b7f@xps13>
In-Reply-To: <2565820.SR17ECleB1@blindfold>
References: <20190408083145.13178-1-miquel.raynal@bootlin.com>
        <20190414105019.5bac65d3@collabora.com>
        <9a8a3963-1b8a-9f9b-8e54-200945518f99@zonque.org>
        <2565820.SR17ECleB1@blindfold>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Richard,

Richard Weinberger <richard@nod.at> wrote on Sun, 28 Apr 2019 15:07:40
+0200:

> Daniel,
> 
> Am Sonntag, 28. April 2019, 14:20:49 CEST schrieb Daniel Mack:
> > On 14/4/2019 10:50 AM, Boris Brezillon wrote:  
> > > On Mon,  8 Apr 2019 10:31:45 +0200
> > > Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > >   
> > >> Since the migration of the driver to stop using the legacy  
> > >> ->select_chip() hook, there is nothing deselecting the target anymore,    
> > >> thus the selection is not forced at the next access. Ensure the ND_RUN
> > >> bit and the interrupts are always in a clean state.
> > >>
> > >> Cc: Daniel Mack <daniel@zonque.org>
> > >> Cc: stable@vger.kernel.org
> > >> Fixes: b25251414f6e00 ("mtd: rawnand: marvell: Stop implementing ->select_chip()")
> > >> Suggested-by: Boris Brezillon <boris.brezillon@collabora.com>
> > >> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>  
> > > 
> > > Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>  
> > 
> > Has this one been queued in any tree yet?  
> 
> Isn't it visible in linux-next?
> I was about to send a final PR to Linus later today.
> 

Indeed the patch is missing in 20190426 -next. 


Thanks,
Miquèl
