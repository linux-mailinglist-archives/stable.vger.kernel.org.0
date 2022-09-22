Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32D815E6021
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 12:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231377AbiIVKnz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 06:43:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231395AbiIVKnr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 06:43:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94C8FAA358;
        Thu, 22 Sep 2022 03:43:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 316FE62C01;
        Thu, 22 Sep 2022 10:43:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5215C433D6;
        Thu, 22 Sep 2022 10:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663843422;
        bh=hQve4RUpU6UvGleEcv5d/p34i3nmjflrXZmmiQ+EPQU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ggw5XBcfAjEsF6klSZQhkI65IOZK2fTlkK/KIcDZLLIwXLgamy2U7WLUrXn8L5UDS
         JSusgY/8NGa7KV53ZdmSJ1Y/lVlkRS6+j0V5uQPxFGhSABeSD6smaY9r0TErH33p+j
         WKqOddkUUfWVIL3TgP6WK16FNZi0+vObXzW1qYpo=
Date:   Thu, 22 Sep 2022 12:43:39 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sean Young <sean@mess.org>
Cc:     Johan Hovold <johan@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        stable@vger.kernel.org, Dongliang Mu <mudongliangabcd@gmail.com>
Subject: Re: [PATCH RESEND] media: flexcop-usb: fix endpoint type check
Message-ID: <Yyw8W8rnhHv9Aqgk@kroah.com>
References: <20220822151027.27026-1-johan@kernel.org>
 <YymBM1wJLAsBDU4E@hovoldconsulting.com>
 <YywfxwBmdmvQ0i21@kroah.com>
 <Yyws4Pd4bAl3iq2e@hovoldconsulting.com>
 <Yyw1CJgv6nreCtB9@kroah.com>
 <Yyw7X2KkabBpPvIo@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yyw7X2KkabBpPvIo@gofer.mess.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 22, 2022 at 11:39:27AM +0100, Sean Young wrote:
> On Thu, Sep 22, 2022 at 12:12:24PM +0200, Greg Kroah-Hartman wrote:
> > On Thu, Sep 22, 2022 at 11:37:36AM +0200, Johan Hovold wrote:
> > > Thanks. These are the follow-up cleanups:
> > > 
> > > 	https://lore.kernel.org/lkml/20220822151456.27178-1-johan@kernel.org/
> > 
> > Thanks, I'll take them after the first one was merged into Linus's tree.
> > 
> > > Perhaps we should start taking USB related changes like this through the
> > > USB tree by default. Posting patches to the media subsystem feels like
> > > shooting patches at a black hole.
> > 
> > I agree, there's been a bunch of patches sent there (some with security
> > fixes) that are not getting responded to :(
> 
> The patches were missed are all DVB related, which is Mauro's responsibility.
> 
> As far as I can see, other parts of the media subsystem are well looked after.

That's good, it's hard to know who is responsible for which parts at
times.

Hopefully Mauro comes back soon...

greg k-h
