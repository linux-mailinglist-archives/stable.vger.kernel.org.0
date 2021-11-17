Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31E3F45434D
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 10:07:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234802AbhKQJKH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 04:10:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:51870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234800AbhKQJKD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Nov 2021 04:10:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A9E261BF5;
        Wed, 17 Nov 2021 09:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637140025;
        bh=jSFeocSlc6IofAObidh4I1D1bgngavZHyAu2iZpsyoY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Jn4SfpFEs22vvlVgwGhLZ//4vz0X5kRnla9/eATJkG9nK4IO9dkdV8ljTXTjVbTAn
         L86XZkse3ajqEpWtBzJwC/sYyczw3tyJGhInWqtHCGstuiUIxspWz3oVXnDWrqLnfZ
         ocPhkfrUVvaIztlNKo1I/DzKb+EgZtbvIovegi6uOU6QMeiIxyLi30/mr2p+djUKCy
         vzDVHKPf9hEd0RDvUTlMvpBSOJgv7oyaG7CsA7XHyjTpUu2MUjqTffSD0IAuCsvRK9
         i6va3OVYU5uLgtx9IV9RelIlvCkmFqE7T+A1vIOeYKVV47yZDVQ4L4u9+5C6awNTpg
         mNwrB3OGjSYNA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mnGtz-00075Z-Bb; Wed, 17 Nov 2021 10:06:47 +0100
Date:   Wed, 17 Nov 2021 10:06:47 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ilia Sergachev <silia@ethz.ch>,
        Karol Gugala <kgugala@antmicro.com>,
        Mateusz Holenko <mholenko@antmicro.com>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Filip Kokosinski <fkokosinski@antmicro.com>,
        Stafford Horne <shorne@gmail.com>
Subject: Re: [PATCH 1/3] serial: liteuart: fix compile testing
Message-ID: <YZTGJzJcQ3oIEsGy@hovoldconsulting.com>
References: <20211115133745.11445-1-johan@kernel.org>
 <20211115133745.11445-2-johan@kernel.org>
 <CAHp75VeGinEWv0BuAsrHtif2b1p26uUEmSRqG4_y76vDdvNKAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VeGinEWv0BuAsrHtif2b1p26uUEmSRqG4_y76vDdvNKAw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 16, 2021 at 05:44:14PM +0200, Andy Shevchenko wrote:
> On Mon, Nov 15, 2021 at 3:44 PM Johan Hovold <johan@kernel.org> wrote:
> >
> > Allow the liteuart driver to be compile tested by fixing the broken
> > Kconfig dependencies.
> 
> ...
> 
> >  config SERIAL_LITEUART
> >         tristate "LiteUART serial port support"
> > +       depends on LITEX || COMPILE_TEST
> >         depends on HAS_IOMEM
> > -       depends on OF || COMPILE_TEST
> > -       depends on LITEX
> 
> > +       depends on OF
> 
> AFAICS this is optional and prevents compile testing in some cases.

Yeah, you're right; that clause should stay. I'll send a v2. Thanks.

> >         select SERIAL_CORE
> >         help
> >           This driver is for the FPGA-based LiteUART serial controller from LiteX

Johan
