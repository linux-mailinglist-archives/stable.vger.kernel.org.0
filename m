Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCAD92CFC57
	for <lists+stable@lfdr.de>; Sat,  5 Dec 2020 19:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728235AbgLESCg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Dec 2020 13:02:36 -0500
Received: from bmailout2.hostsharing.net ([83.223.78.240]:44597 "EHLO
        bmailout2.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728225AbgLESBk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Dec 2020 13:01:40 -0500
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by bmailout2.hostsharing.net (Postfix) with ESMTPS id 7A42328007E15;
        Sat,  5 Dec 2020 19:00:40 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 6FE42369; Sat,  5 Dec 2020 19:00:55 +0100 (CET)
Date:   Sat, 5 Dec 2020 19:00:55 +0100
From:   Lukas Wunner <lukas@wunner.de>
To:     gregkh@linuxfoundation.org
Cc:     broonie@kernel.org, f.fainelli@gmail.com, olteanv@gmail.com,
        s.hauer@pengutronix.de, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] spi: bcm2835: Fix use-after-free on
 unbind" failed to apply to 4.19-stable tree
Message-ID: <20201205180055.GA8830@wunner.de>
References: <160612166517133@kroah.com>
 <20201205093613.GB29065@wunner.de>
 <20201205165010.GA2170@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201205165010.GA2170@wunner.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Dec 05, 2020 at 05:50:10PM +0100, Lukas Wunner wrote:
> On Sat, Dec 05, 2020 at 10:36:13AM +0100, Lukas Wunner wrote:
> > On Mon, Nov 23, 2020 at 09:54:25AM +0100, gregkh@linuxfoundation.org wrote:
> > > The patch below does not apply to the 4.19-stable tree.
> > > If someone wants it applied there, or to any other stable or longterm
> > > tree, then please email the backport, including the original git commit
> > > id to <stable@vger.kernel.org>.
> > 
> > Below please find the backport of e1483ac030fb to linux-4.19.y.
> 
> This backport is also applicable to 4.14-stable and 4.9-stable,
> as is the one I sent out for spi-bcm2835aux.c as well as the backport
> of 666224b43b4b.

Same for 4.4-stable.  As a prerequisite, this requires the 4.9 backport of
5e844cc37a5c ("spi: Introduce device-managed SPI controller allocation")
which I sent out today.

Thanks,

Lukas
