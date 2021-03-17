Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8B4733E9C7
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 07:36:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbhCQGdi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Mar 2021 02:33:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:51698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229492AbhCQGdT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Mar 2021 02:33:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 63A3364F8F;
        Wed, 17 Mar 2021 06:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615962799;
        bh=Z8KXPQq77SzPlEdNFIzyWTeYlgt7pgmbHOi0pXY5px0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lXJurWpsVncdIR+/DUZcK4BImoapn2F3pf8BTX6UkC6HFWbsB/YZh2CHB0N5d5czo
         JVEX9edy1NEYkySoL6rn5s4ytaIFBci5Iu15QZFVrVIA0e2yYspGy0d/fCccB+CXTp
         C6eAEpWHPgpe67zDFJPJ/Satnt+w3tYWqgun2bskZCKgHg5Jq4djSn0/XbRi+uZ2z5
         D8eFn67wvoTZMAgTkWHtOGF/ojTvu30S3SjRarrKDygR9uUG7svgez37ocU1HxyBfL
         cl47c5KZEYFgaq02EDg+Luz7VI1BVSUIcVhsHeM8f0lb157M530MJ0w9UKB4pNfZoy
         VJZ7n7tLXyerQ==
Date:   Wed, 17 Mar 2021 08:33:11 +0200
From:   Mike Rapoport <rppt@kernel.org>
To:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Tiezhu Yang <yangtiezhu@loongson.cn>,
        Jinyang He <hejinyang@loongson.cn>,
        Youling Tang <tangyouling@loongson.cn>,
        Tobias Wolf <dev-NTEO@vplace.de>,
        Marcin Nowakowski <marcin.nowakowski@mips.com>,
        linux-mips@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] MIPS: fix memory reservation for non-usermem setups
Message-ID: <YFGip16ObFp/vOZS@kernel.org>
References: <20210307194030.8007-1-ilya.lipnitskiy@gmail.com>
 <20210312151934.GA4209@alpha.franken.de>
 <CALCv0x1AEZanNsVcNuUrbHuLyWYNegEVuye9Gso-Ou9xX8JEAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCv0x1AEZanNsVcNuUrbHuLyWYNegEVuye9Gso-Ou9xX8JEAg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Ilya,

On Tue, Mar 16, 2021 at 10:10:09PM -0700, Ilya Lipnitskiy wrote:
> Hi Thomas,
> 
> On Fri, Mar 12, 2021 at 7:19 AM Thomas Bogendoerfer
> <tsbogend@alpha.franken.de> wrote:
> >
> > On Sun, Mar 07, 2021 at 11:40:30AM -0800, Ilya Lipnitskiy wrote:
> > > From: Tobias Wolf <dev-NTEO@vplace.de>
> > >
> > > Commit 67a3ba25aa95 ("MIPS: Fix incorrect mem=X@Y handling") introduced a new
> > > issue for rt288x where "PHYS_OFFSET" is 0x0 but the calculated "ramstart" is
> > > not. As the prerequisite of custom memory map has been removed, this results
> > > in the full memory range of 0x0 - 0x8000000 to be marked as reserved for this
> > > platform.
> >
> > and where is the problem here ?
> Turns out this was already attempted to be upstreamed - not clear why
> it wasn't merged. Context:
> https://lore.kernel.org/linux-mips/6504517.U6H5IhoIOn@loki/
> 
> I hope the thread above helps you understand the problem.

The memory initialization was a bit different then. Do you still see the
same problem? 

-- 
Sincerely yours,
Mike.
