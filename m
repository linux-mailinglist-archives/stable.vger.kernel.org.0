Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B80E33C54
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 02:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726211AbfFDAFg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 20:05:36 -0400
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:42236 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbfFDAFg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jun 2019 20:05:36 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id 885D327E27;
        Mon,  3 Jun 2019 20:05:33 -0400 (EDT)
Date:   Tue, 4 Jun 2019 10:05:44 +1000 (AEST)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     Michael Schmitz <schmitzmic@gmail.com>
cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        scsi <linux-scsi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        linux-m68k <linux-m68k@lists.linux-m68k.org>
Subject: Re: [PATCH 5/7] scsi: mac_scsi: Fix pseudo DMA implementation, take
 2
In-Reply-To: <247ed79a-75c7-41fd-0932-0b7701ee5d4e@gmail.com>
Message-ID: <alpine.LNX.2.21.1906040954330.40@nippy.intranet>
References: <cover.1559438652.git.fthain@telegraphics.com.au> <c56deeb735545c7942607a93f017bb536f581ae5.1559438652.git.fthain@telegraphics.com.au> <CAMuHMdWxRtJU2aRQQjXzR2mvpfpDezCVu42Eo1eXDsQaPb+j6Q@mail.gmail.com> <alpine.LNX.2.21.1906030903510.20@nippy.intranet>
 <CAMuHMdUFxQnmJmkr2qm4waTfFA5yfCHAFngyD37cFH6gbbD-Pg@mail.gmail.com> <alpine.LNX.2.21.1906031702220.37@nippy.intranet> <247ed79a-75c7-41fd-0932-0b7701ee5d4e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 4 Jun 2019, Michael Schmitz wrote:

> Hi Finn,
> 
> On 3/06/19 7:40 PM, Finn Thain wrote:
> > 
> > > There are several other drivers that contain pieces of assembler code.
> > > 
> > Does any driver contain assembler code for multiple architectures? I was
> > trying to avoid that -- though admittedly I don't yet have actual code for
> > the PDMA implementation for mac_scsi for Nubus PowerMacs.
> > 
> I've seen that once, for one of the ESP drivers that were supported on both
> m68k and ppc (APUS, PPC upgrade to Amiga computers). But that driver was
> removed long ago (after 2.6?).
> 
> In that case, the assembly file did reside in drivers/scsi/. That still
> appears to be current practice (see drivers/scsi/arm/acornscsi-io.S).
> 

The presence of that file would be an argument for adding 
drivers/scsi/m68k/. This seems to be begging the question.

Since there's no clear policy, I'll combine the two files and avoid the 
question for now.

-- 

> Cheers,
> 
> ??? Michael
> 
> 
> 
