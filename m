Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 355505E5DAE
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 10:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbiIVIlv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 04:41:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbiIVIlt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 04:41:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFAB5CDCCF;
        Thu, 22 Sep 2022 01:41:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 11F0D611DF;
        Thu, 22 Sep 2022 08:41:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B4DBC433C1;
        Thu, 22 Sep 2022 08:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663836106;
        bh=0eoFjcQopkDVXGcndNRjQDg5nJ3lKUmDPXyMxFGOeHo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iX6RKUvT1p92sezDzPubezh1aonVxG6Swuk58miPNcurs6dHVCCYWP2RuGqh8HQaj
         UGn1AfTG1Bn5Gx2ukwC64vlAWHwOh9BVYg83bh2AuAnosLatGqCrYAZLwZxYU8lBKy
         FfjJS/enFgr6FKW43CxE+XjK/YH3vnuYmhAxtj0o=
Date:   Thu, 22 Sep 2022 10:41:43 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sean Young <sean@mess.org>, linux-media@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Oliver Neukum <oneukum@suse.com>, stable@vger.kernel.org,
        Dongliang Mu <mudongliangabcd@gmail.com>
Subject: Re: [PATCH RESEND] media: flexcop-usb: fix endpoint type check
Message-ID: <YywfxwBmdmvQ0i21@kroah.com>
References: <20220822151027.27026-1-johan@kernel.org>
 <YymBM1wJLAsBDU4E@hovoldconsulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YymBM1wJLAsBDU4E@hovoldconsulting.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 20, 2022 at 11:00:35AM +0200, Johan Hovold wrote:
> Mauro and Hans,
> 
> On Mon, Aug 22, 2022 at 05:10:27PM +0200, Johan Hovold wrote:
> > Commit d725d20e81c2 ("media: flexcop-usb: sanity checking of endpoint
> > type") tried to add an endpoint type sanity check for the single
> > isochronous endpoint but instead broke the driver by checking the wrong
> > descriptor or random data beyond the last endpoint descriptor.
> > 
> > Make sure to check the right endpoint descriptor.
> > 
> > Fixes: d725d20e81c2 ("media: flexcop-usb: sanity checking of endpoint type")
> > Cc: Oliver Neukum <oneukum@suse.com>
> > Cc: stable@vger.kernel.org	# 5.9
> > Reported-by: Dongliang Mu <mudongliangabcd@gmail.com>
> > Signed-off-by: Johan Hovold <johan@kernel.org>
> > ---
> > 
> > It's been two months and two completely ignored reminders so resending.
> > 
> > Can someone please pick this fix up and let me know when that has been
> > done?
> 
> It's been another month so sending yet another reminder. This driver as
> been broken since 5.9 and I posted this fix almost four months ago and
> have sent multiple reminders since.
> 
> Can someone please pick this one and the follow-up cleanups up?

I've taken this one in my tree now.  Which one were the "follow-up"
cleanups?

thanks,

greg k-h
