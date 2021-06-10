Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 230C13A3402
	for <lists+stable@lfdr.de>; Thu, 10 Jun 2021 21:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbhFJT2K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Jun 2021 15:28:10 -0400
Received: from bmailout3.hostsharing.net ([176.9.242.62]:56937 "EHLO
        bmailout3.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbhFJT2J (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Jun 2021 15:28:09 -0400
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout3.hostsharing.net (Postfix) with ESMTPS id C7FEC100DA1A7;
        Thu, 10 Jun 2021 21:26:08 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 94C163512BA; Thu, 10 Jun 2021 21:26:08 +0200 (CEST)
Date:   Thu, 10 Jun 2021 21:26:08 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Saravana Kannan <saravanak@google.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Mark Brown <broonie@kernel.org>,
        linux-spi <linux-spi@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 5.12 03/43] spi: Fix spi device unregister flow
Message-ID: <20210610192608.GA31461@wunner.de>
References: <20210603170734.3168284-1-sashal@kernel.org>
 <20210603170734.3168284-3-sashal@kernel.org>
 <20210606111028.GA20948@wunner.de>
 <YMJR/FNCwDllHIDG@sashalap>
 <CAGETcx_w8pHs3OXQyVXYWV1CY4qGTWrZ9QNEwz=TL8SLbyq1bA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGETcx_w8pHs3OXQyVXYWV1CY4qGTWrZ9QNEwz=TL8SLbyq1bA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 10, 2021 at 12:22:40PM -0700, Saravana Kannan wrote:
> On Thu, Jun 10, 2021 at 10:55 AM Sasha Levin <sashal@kernel.org> wrote:
> > On Sun, Jun 06, 2021 at 01:10:28PM +0200, Lukas Wunner wrote:
> > >On Thu, Jun 03, 2021 at 01:06:53PM -0400, Sasha Levin wrote:
> > >> From: Saravana Kannan <saravanak@google.com>
> > >>
> > >> [ Upstream commit c7299fea67696db5bd09d924d1f1080d894f92ef ]
> > >
> > >This commit shouldn't be backported to stable by itself, it requires
> > >that the following fixups are applied on top of it:
> > >
> > >* Upstream commit 27e7db56cf3d ("spi: Don't have controller clean up spi
> > >  device before driver unbind")
> > >
> > >* spi.git commit 2ec6f20b33eb ("spi: Cleanup on failure of initial setup")
> > >  https://git.kernel.org/broonie/spi/c/2ec6f20b33eb
> > >
> > >Note that the latter is queued for v5.13, but hasn't landed there yet.
> > >So you probably need to back out c7299fea6769 from the stable queue and
> > >wait for 2ec6f20b33eb to land in upstream.
> > >
> > >Since you've applied c7299fea6769 to v5.12, v5.10, v5.4, v4.14 and v4.19
> > >stable trees, the two fixups listed above need to be backported to all
> > >of them.
> >
> > I took those two patches into 5.12-5.4, but as they needed a more
> > complex backport for 4.14 and 4.19, I've dropped c7299fea67 from those
> > trees.
> 
> Sounds good. Also, there was a subsequent "Fixes" for this patch and I
> think another "Fixes" for the "Fixes". So, before picking this up,
> maybe make sure those Fixes patches are pickable too?

Aren't those the commits I've listed above?  Or did I miss any fixes?
I'm not aware of any others besides these two.

Thanks,

Lukas
