Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7E02E93F7
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 12:16:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726026AbhADLQB convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 4 Jan 2021 06:16:01 -0500
Received: from relay12.mail.gandi.net ([217.70.178.232]:38497 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbhADLQB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 06:16:01 -0500
Received: from xps13 (lfbn-tou-1-1535-bdcst.w90-89.abo.wanadoo.fr [90.89.98.255])
        (Authenticated sender: miquel.raynal@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id AE75620000C;
        Mon,  4 Jan 2021 11:15:17 +0000 (UTC)
Date:   Mon, 4 Jan 2021 12:15:16 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Sean Nyekjaer <sean@geanix.com>
Cc:     Han Xu <han.xu@nxp.com>, Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Martin =?UTF-8?B?SHVuZGViw7hsbA==?= <martin@geanix.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] mtd: rawnand: gpmi: fix dst bit offset when extracting
 raw payload
Message-ID: <20210104121516.3d50fb58@xps13>
In-Reply-To: <7db4b36e-23a6-6075-132c-214d043e78bd@geanix.com>
References: <20210104103558.9035-1-miquel.raynal@bootlin.com>
        <7db4b36e-23a6-6075-132c-214d043e78bd@geanix.com>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sean,

Sean Nyekjaer <sean@geanix.com> wrote on Mon, 4 Jan 2021 11:50:10 +0100:

> On 04/01/2021 11.35, Miquel Raynal wrote:
> > On Mon, 2020-12-21 at 10:00:13 UTC, Sean Nyekjaer wrote:  
> >> Re-add the multiply by 8 to "step * eccsize" to correct the destination bit offset
> >> when extracting the data payload in gpmi_ecc_read_page_raw().
> >>
> >> Fixes: e5e5631cc889 ("mtd: rawnand: gpmi: Use nand_extract_bits()")
> >> Cc: stable@vger.kernel.org
> >> Reported-by: Martin Hundebøll <martin@geanix.com>
> >> Signed-off-by: Sean Nyekjaer <sean@geanix.com>  
> > Applied to https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git nand/next, thanks.
> >
> > Miquel  
> Hi Miquel
> 
> Will you please queue this for fixes? It's quite relevant for 5.10 LTS :)

Right, that will be quicker to have it in Linus' tree. I moved
the patch to the mtd/next branch.

Cheers,
Miquèl
