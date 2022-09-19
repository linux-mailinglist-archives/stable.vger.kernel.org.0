Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59C7F5BC437
	for <lists+stable@lfdr.de>; Mon, 19 Sep 2022 10:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbiISIXI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Sep 2022 04:23:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbiISIXH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Sep 2022 04:23:07 -0400
Received: from angie.orcam.me.uk (angie.orcam.me.uk [78.133.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F2D725FE2;
        Mon, 19 Sep 2022 01:23:06 -0700 (PDT)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id BC24892009C; Mon, 19 Sep 2022 10:23:05 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id B61FD92009B;
        Mon, 19 Sep 2022 09:23:05 +0100 (BST)
Date:   Mon, 19 Sep 2022 09:23:05 +0100 (BST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Jiri Slaby <jirislaby@kernel.org>
cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Anders Blomdell <anders.blomdell@control.lth.se>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/2] serial: 8250: Request full 16550A feature probing
 for OxSemi PCIe devices
In-Reply-To: <7785ca40-2f4d-a0a8-2ada-ca5fb941b6a2@kernel.org>
Message-ID: <alpine.DEB.2.21.2209190918450.14808@angie.orcam.me.uk>
References: <alpine.DEB.2.21.2209162317180.19473@angie.orcam.me.uk> <alpine.DEB.2.21.2209171020390.31781@angie.orcam.me.uk> <7785ca40-2f4d-a0a8-2ada-ca5fb941b6a2@kernel.org>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 19 Sep 2022, Jiri Slaby wrote:

> > linux-serial-8250-oxsemi-efr.diff
> > Index: linux-macro/drivers/tty/serial/8250/8250_pci.c
> > ===================================================================
> > --- linux-macro.orig/drivers/tty/serial/8250/8250_pci.c
> > +++ linux-macro/drivers/tty/serial/8250/8250_pci.c
> > @@ -1232,6 +1232,10 @@ static void pci_oxsemi_tornado_set_mctrl
> >   	serial8250_do_set_mctrl(port, mctrl);
> >   }
> >   +/*
> > + * We require EFR features for clock programming, so set UPF_FULL_PROBE
> > + * for full probing regardless of CONFIG_SERIAL_8250_16550A_VARIANTS
> > setting.
> > + */
> 
> It'd make more sense to me to move this comment right before the line you add
> below.

 I favour the style where what a function does is documented above it, but 
I won't insist on it if having a comment within is what we prefer here.

  Maciej
