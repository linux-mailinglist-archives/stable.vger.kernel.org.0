Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDA461CBE5
	for <lists+stable@lfdr.de>; Tue, 14 May 2019 17:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbfENPab (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 May 2019 11:30:31 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:42752 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbfENPab (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 May 2019 11:30:31 -0400
Received: from svr-orw-mbx-01.mgc.mentorg.com ([147.34.90.201])
        by relay1.mentorg.com with esmtps (TLSv1.2:ECDHE-RSA-AES256-SHA384:256)
        id 1hQZNp-0002lK-D1 from George_Davis@mentor.com ; Tue, 14 May 2019 08:30:25 -0700
Received: from localhost (147.34.91.1) by svr-orw-mbx-01.mgc.mentorg.com
 (147.34.90.201) with Microsoft SMTP Server (TLS) id 15.0.1320.4; Tue, 14 May
 2019 08:30:23 -0700
Date:   Tue, 14 May 2019 11:30:22 -0400
From:   "George G. Davis" <george_davis@mentor.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
CC:     Eugeniu Rosca <erosca@de.adit-jv.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Chris Brandt <chris.brandt@renesas.com>,
        Ulrich Hecht <ulrich.hecht+renesas@gmail.com>,
        Andy Lowe <andy_lowe@mentor.com>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS 
        <devicetree@vger.kernel.org>, Magnus Damm <magnus.damm@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] serial: sh-sci: disable DMA for uart_console
Message-ID: <20190514153021.GC18528@mam-gdavis-lt>
References: <1557762446-23811-1-git-send-email-george_davis@mentor.com>
 <CAMuHMdVaNWa=Q-7K-+_rM-8yYWB0-+4_o4hgACK6o-4BOrY07A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAMuHMdVaNWa=Q-7K-+_rM-8yYWB0-+4_o4hgACK6o-4BOrY07A@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-ClientProxiedBy: svr-orw-mbx-01.mgc.mentorg.com (147.34.90.201) To
 svr-orw-mbx-01.mgc.mentorg.com (147.34.90.201)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Geert,

On Tue, May 14, 2019 at 10:28:34AM +0200, Geert Uytterhoeven wrote:
> Hi George,
> 
> On Mon, May 13, 2019 at 5:48 PM George G. Davis <george_davis@mentor.com> wrote:
> > As noted in commit 84b40e3b57ee ("serial: 8250: omap: Disable DMA for
> > console UART"), UART console lines use low-level PIO only access functions
> > which will conflict with use of the line when DMA is enabled, e.g. when
> > the console line is also used for systemd messages. So disable DMA
> > support for UART console lines.
> >
> > Fixes: https://patchwork.kernel.org/patch/10929511/
> 
> I don't think this is an appropriate reference, as it points to a patch that
> was never applied.

I included it as a link to an upstream problem report similar to other commits
that I previewed. The link provides the extra context that I was perhaps to
lazy to note in the commit header.

> As the problem has basically existed forever,

Agreed

> IMHO no Fixes tag
> is needed.

I've dropped the Fixes line.

> > Reported-by: Michael Rodin <mrodin@de.adit-jv.com>
> > Tested-by: Eugeniu Rosca <erosca@de.adit-jv.com>
> > Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
> > Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
> > Cc: stable@vger.kernel.org
> > Signed-off-by: George G. Davis <george_davis@mentor.com>
> > ---
> > v2: Clarify comment regarding DMA support on kernel console,
> >     add {Tested,Reviewed}-by:, and Cc: linux-stable lines.
> 
> Thanks for the update!

Thanks!


I'll submit v3 later today.

> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> -- 
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds

-- 
Regards,
George
