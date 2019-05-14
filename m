Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 405A41CCBC
	for <lists+stable@lfdr.de>; Tue, 14 May 2019 18:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725980AbfENQQL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 May 2019 12:16:11 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:44543 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbfENQQL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 May 2019 12:16:11 -0400
Received: from svr-orw-mbx-01.mgc.mentorg.com ([147.34.90.201])
        by relay1.mentorg.com with esmtps (TLSv1.2:ECDHE-RSA-AES256-SHA384:256)
        id 1hQa63-0006ru-LN from George_Davis@mentor.com ; Tue, 14 May 2019 09:16:07 -0700
Received: from localhost (147.34.91.1) by svr-orw-mbx-01.mgc.mentorg.com
 (147.34.90.201) with Microsoft SMTP Server (TLS) id 15.0.1320.4; Tue, 14 May
 2019 09:16:05 -0700
Date:   Tue, 14 May 2019 12:16:04 -0400
From:   "George G. Davis" <george_davis@mentor.com>
To:     Wolfram Sang <wsa@the-dreams.de>
CC:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Eugeniu Rosca <erosca@de.adit-jv.com>,
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
Message-ID: <20190514161604.GD18528@mam-gdavis-lt>
References: <1557762446-23811-1-git-send-email-george_davis@mentor.com>
 <CAMuHMdVaNWa=Q-7K-+_rM-8yYWB0-+4_o4hgACK6o-4BOrY07A@mail.gmail.com>
 <20190514153021.GC18528@mam-gdavis-lt>
 <20190514155450.GB6508@kunai>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190514155450.GB6508@kunai>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-ClientProxiedBy: svr-orw-mbx-04.mgc.mentorg.com (147.34.90.204) To
 svr-orw-mbx-01.mgc.mentorg.com (147.34.90.201)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Wolfram,

On Tue, May 14, 2019 at 05:54:51PM +0200, Wolfram Sang wrote:
> 
> > > > Fixes: https://patchwork.kernel.org/patch/10929511/
> > > 
> > > I don't think this is an appropriate reference, as it points to a patch that
> > > was never applied.
> > 
> > I included it as a link to an upstream problem report similar to other commits
> > that I previewed. The link provides the extra context that I was perhaps to
> > lazy to note in the commit header.
> 
> We have a "Link:" tag for things like this, e.g.:
> 
> Link: https://patchwork.kernel.org/patch/10929511/

Right, I've changed it to a Link instead.

Thanks!

-- 
Regards,
George
