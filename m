Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 877135BF16C
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 01:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbiITXml (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 19:42:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231468AbiITXmW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 19:42:22 -0400
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1D8364DB21;
        Tue, 20 Sep 2022 16:40:48 -0700 (PDT)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 3B2399200B4; Wed, 21 Sep 2022 01:35:47 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 3517392009B;
        Wed, 21 Sep 2022 00:35:47 +0100 (BST)
Date:   Wed, 21 Sep 2022 00:35:47 +0100 (BST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Jiri Slaby <jirislaby@kernel.org>
cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Anders Blomdell <anders.blomdell@control.lth.se>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] serial: 8250: Let drivers request full 16550A feature
 probing
In-Reply-To: <ec300579-9565-a96a-2e8e-a42363fd9ad7@kernel.org>
Message-ID: <alpine.DEB.2.21.2209202144070.41633@angie.orcam.me.uk>
References: <alpine.DEB.2.21.2209162317180.19473@angie.orcam.me.uk> <alpine.DEB.2.21.2209171043270.31781@angie.orcam.me.uk> <8fa701a1-3f34-9152-daf6-1618dd0e7727@kernel.org> <alpine.DEB.2.21.2209190911540.14808@angie.orcam.me.uk>
 <ec300579-9565-a96a-2e8e-a42363fd9ad7@kernel.org>
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

> > > Why __u64 and not u64?
> > 
> >   For consistency as there's `__u32' used elsewhere in this file.  It's not
> > clear to me what our rules WRT the use of `s*'/`u*' vs `__s*'/`__u*' are.
> > I don't think we have it mentioned under Documentation/.  Please clarify
> > if you know and I can update the change accordingly.
> 
> The rule is, AFAICT, use __u*/__s* in user (uapi) headers. Everywhere else,
> use u*/s*.

 Fair enough, that's consistent with ISO C's designation of identifiers 
whose names start with an underscore as reserved (for system use, etc.).

  Maciej
