Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B74B2CFC32
	for <lists+stable@lfdr.de>; Sat,  5 Dec 2020 17:59:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727369AbgLEQ4P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Dec 2020 11:56:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727169AbgLEQy2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Dec 2020 11:54:28 -0500
Received: from bmailout3.hostsharing.net (bmailout3.hostsharing.net [IPv6:2a01:4f8:150:2161:1:b009:f23e:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88DCEC09425C
        for <stable@vger.kernel.org>; Sat,  5 Dec 2020 07:37:00 -0800 (PST)
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by bmailout3.hostsharing.net (Postfix) with ESMTPS id D99661003CE60;
        Sat,  5 Dec 2020 16:35:08 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 8D2E1814B; Sat,  5 Dec 2020 16:35:09 +0100 (CET)
Date:   Sat, 5 Dec 2020 16:35:09 +0100
From:   Lukas Wunner <lukas@wunner.de>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     Mark Brown <broonie@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, kdasu.kdev@gmail.com,
        Stable <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] spi: bcm-qspi: Fix use-after-free on
 unbind" failed to apply to 5.4-stable tree
Message-ID: <20201205153509.GA22211@wunner.de>
References: <160612300715987@kroah.com>
 <20201124134123.ie5jvzygygayajo5@debian>
 <X71Lv314xaqrtn9B@kroah.com>
 <CADVatmMFEYRSKcq4mkZqs0feVPSWX9miG49ffbCR0utLtFSgfA@mail.gmail.com>
 <CADVatmNVjKBAZPh2voCHaFdAaU3pz2fs0sdL58eLSD4d-W8LQg@mail.gmail.com>
 <20201205090027.GA29065@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201205090027.GA29065@wunner.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Dec 05, 2020 at 10:00:27AM +0100, Lukas Wunner wrote:
> On Tue, Nov 24, 2020 at 07:28:44PM +0000, Sudip Mukherjee wrote:
> > On Tue, Nov 24, 2020 at 6:53 PM Sudip Mukherjee <sudipm.mukherjee@gmail.com> wrote:
> > > On Tue, Nov 24, 2020 at 6:06 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> > > > On Tue, Nov 24, 2020 at 01:41:23PM +0000, Sudip Mukherjee wrote:
> > > > > On Mon, Nov 23, 2020 at 10:16:47AM +0100, gregkh@linuxfoundation.org wrote:
> > > > > > The patch below does not apply to the 5.4-stable tree.
> > > > > > If someone wants it applied there, or to any other stable or longterm
> > > > > > tree, then please email the backport, including the original git commit
> > > > > > id to <stable@vger.kernel.org>.
> > > > >
> > > > > Here is the backport for all the stable tree from v4.9.y to v5.4.y.
> > >
> > > I was modifying one of my script which pulls in the stablerc and
> > > stable-queue and I have completely messed up today  :(
> > > Please drop this from v4.14.y. It will fail to build there. I had been
> > > working on the version for v4.14.y and v4.9.y, but I will keep it
> > > aside for today.
> > > Really sorry for the confusion.
> > 
> > v4.19.y also. :(
> > I have rechecked and only v5.4.y is ok.
> 
> Sudip's patch for 4.19 is actually correct, but it depends on commit
> 5e844cc37a5c ("spi: Introduce device-managed SPI controller allocation").
> If that commit is cherry-picked to 4.19 (applies cleanly), Sudip's patch
> compiles without errors.

Same situation for 4.14:

Sudip's patch applies and compiles cleanly if 5e844cc37a5c is applied before,
as do all the backports for spi-bcm2835.c and spi-bcm2835aux.c I sent out
earlier today.

Thanks,

Lukas
