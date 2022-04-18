Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E571505BD5
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 17:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345866AbiDRPuv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 11:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345591AbiDRPuT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 11:50:19 -0400
Received: from angie.orcam.me.uk (angie.orcam.me.uk [78.133.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B75C4110E;
        Mon, 18 Apr 2022 08:28:24 -0700 (PDT)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 1E13992009E; Mon, 18 Apr 2022 17:28:24 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 1006B92009C;
        Mon, 18 Apr 2022 16:28:24 +0100 (BST)
Date:   Mon, 18 Apr 2022 16:28:23 +0100 (BST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>
Subject: Re: [PATCH v4 4/5] serial: 8250: Also set sticky MCR bits in console
 restoration
In-Reply-To: <CAHp75VccGqH-peGQHnM+guu8KfkGo6-R3wwGUPKRWKqQZid7AA@mail.gmail.com>
Message-ID: <alpine.DEB.2.21.2204181619520.9383@angie.orcam.me.uk>
References: <alpine.DEB.2.21.2204161848030.9383@angie.orcam.me.uk> <alpine.DEB.2.21.2204162156340.9383@angie.orcam.me.uk> <CAHp75VccGqH-peGQHnM+guu8KfkGo6-R3wwGUPKRWKqQZid7AA@mail.gmail.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 18 Apr 2022, Andy Shevchenko wrote:

> > Sticky MCR bits are lost in console restoration if console suspending
> > has been disabled.  This currently affects the AFE bit, which works in
> > combination with RTS which we set, so we want to make sure the UART
> > retains control of its FIFO where previously requested.  Also specific
> > drivers may need other bits in the future.
> 
> Since it's a fix it should be moved to the beginning of the series.

 OK, patch reordered in v5.

  Maciej
