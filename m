Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 893863156DF
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 20:36:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233364AbhBITd7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 14:33:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:51186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233582AbhBITY6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Feb 2021 14:24:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CE4264E8A;
        Tue,  9 Feb 2021 19:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612897803;
        bh=hvYO2j/PRH4qRxqLb3TFcHAVZtdC/7ir8b1IOHUYKHM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZE+xMlhxdiltpEpQ6O5iqW9cDW7zGdkl5TjDMr+KGw1tIywkJrYeEV+ytyS8VDR5V
         XbtpuDxkgu8q/RDmhYG6gSDKjwLU/fvT2bLLYkGMumCMps3xQrXfwJCwMwNQPNeWy3
         qT2mmmjRToap3Qg/xrmBeb+UyhEvEYLZI0kqoW3o=
Date:   Tue, 9 Feb 2021 20:10:00 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Thiago Jung Bauermann <bauerman@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Roman Gushchin <guro@fb.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Michal Hocko <mhocko@kernel.org>,
        Rik van Riel <riel@surriel.com>,
        Wonhyuk Yang <vvghjk1234@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 051/120] memblock: do not start bottom-up
 allocations with kernel_end
Message-ID: <YCLeCPWy6samik/W@kroah.com>
References: <20210208145818.395353822@linuxfoundation.org>
 <20210208145820.464727041@linuxfoundation.org>
 <875z31th2q.fsf@manicouagan.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <875z31th2q.fsf@manicouagan.localdomain>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 09, 2021 at 12:07:57PM -0300, Thiago Jung Bauermann wrote:
> 
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> 
> > From: Roman Gushchin <guro@fb.com>
> >
> > [ Upstream commit 2dcb3964544177c51853a210b6ad400de78ef17d ]
> >
> > With kaslr the kernel image is placed at a random place, so starting the
> > bottom-up allocation with the kernel_end can result in an allocation
> > failure and a warning like this one:
> 
> Not sure if this is ready for stable yet (including stable branches 4.19
> and 5.4), since it seems to uncover latent bugs in x86 early memory
> reservation. I asked about this issue here:
> 
> https://lore.kernel.org/lkml/87ft26yuwg.fsf@manicouagan.localdomain/

If there are fixes for this that get merged, please make sure they get
tagged properly to go to the stable trees as well.

thanks,

greg k-h
