Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 806E720047E
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 10:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730893AbgFSI7g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 04:59:36 -0400
Received: from winnie.ispras.ru ([83.149.199.91]:14572 "EHLO smtp.ispras.ru"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728712AbgFSI7g (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 04:59:36 -0400
Received: from monopod.intra.ispras.ru (monopod.intra.ispras.ru [10.10.3.121])
        by smtp.ispras.ru (Postfix) with ESMTP id C0A0C203C1;
        Fri, 19 Jun 2020 11:59:34 +0300 (MSK)
Date:   Fri, 19 Jun 2020 11:59:34 +0300 (MSK)
From:   Alexander Monakov <amonakov@ispras.ru>
To:     Greg KH <gregkh@linuxfoundation.org>
cc:     Sasha Levin <sashal@kernel.org>, stable-commits@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: Patch "x86/amd_nb: Add AMD family 17h model 60h PCI IDs" has
 been added to the 5.7-stable tree
In-Reply-To: <20200619083502.GC473790@kroah.com>
Message-ID: <alpine.LNX.2.20.13.2006191155380.21166@monopod.intra.ispras.ru>
References: <20200618211421.CDE7820890@mail.kernel.org> <alpine.LNX.2.20.13.2006191051350.31660@monopod.intra.ispras.ru> <20200619083502.GC473790@kroah.com>
User-Agent: Alpine 2.20.13 (LNX 116 2015-12-14)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On Fri, 19 Jun 2020, Greg KH wrote:

> On Fri, Jun 19, 2020 at 10:56:42AM +0300, Alexander Monakov wrote:
> > On Thu, 18 Jun 2020, Sasha Levin wrote:
> > 
> > > This is a note to let you know that I've just added the patch titled
> > > 
> > >     x86/amd_nb: Add AMD family 17h model 60h PCI IDs
> > > 
> > > to the 5.7-stable tree which can be found at:
> > >     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> > > 
> > > The filename of the patch is:
> > >      x86-amd_nb-add-amd-family-17h-model-60h-pci-ids.patch
> > > and it can be found in the queue-5.7 subdirectory.
> > > 
> > > If you, or anyone else, feels it should not be added to the stable tree,
> > > please let <stable@vger.kernel.org> know about it.
> > 
> > It's not good to pick this patch alone into stable. Either all 3 patches
> > from https://lore.kernel.org/lkml/20200510204842.2603-1-amonakov@ispras.ru/
> > should be taken, or none of those.
> > 
> > In particular, the edac module will warn on load without the third patch.
> > 
> > Likewise for 5.4-stable (should I send a separate mail for that?)
> 
> What are the git commit ids that should be applied that are not?

279f0b3a4b8066 ("hwmon: (k10temp) Add AMD family 17h model 60h PCI match")

b6bea24d41519e ("EDAC/amd64: Add AMD family 17h model 60h PCI IDs")

Alexander
