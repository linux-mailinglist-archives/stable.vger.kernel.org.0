Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A062B493F93
	for <lists+stable@lfdr.de>; Wed, 19 Jan 2022 19:04:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351948AbiASSEA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jan 2022 13:04:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347237AbiASSEA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jan 2022 13:04:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B1AAC061574;
        Wed, 19 Jan 2022 10:04:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8ED0B81AC7;
        Wed, 19 Jan 2022 18:03:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09543C004E1;
        Wed, 19 Jan 2022 18:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642615437;
        bh=Ur3kMaWZaSi8Y1AlfKrGVvzr1w1PXgLKGlTQ8hbEPdg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UqtOEiVDmbJkeSg9ZBr4qVNEmD+RdY8gtfaHaYx4XaCSXa81H9wT213LyHP+HC6bN
         dROwYJYBVU+H0oSM3maSBuGP5uetiU223PEUYfL6j703KBgJlN4IVBTn6u8UK5a6MX
         xqtUn6CkVyeH/l/p6ERq8/vn+ezodc+D9lakA69o=
Date:   Wed, 19 Jan 2022 19:03:55 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: 4.4 series end of line was Re: [PATCH 4.4 00/17] 4.4.297-rc1
 review
Message-ID: <YehSi9Bati3sNado@kroah.com>
References: <20211227151315.962187770@linuxfoundation.org>
 <20220119102858.GB4984@amd>
 <YefooANkr6eem49U@kroah.com>
 <20220119134943.GA1032@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220119134943.GA1032@duo.ucw.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 19, 2022 at 02:49:43PM +0100, Pavel Machek wrote:
> Hi!
> 
> > > > This is the start of the stable review cycle for the 4.4.297 release.
> > > > There are 17 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > 
> > > 4.4.X series is scheduled for EOL next month. Do you have any
> > > estimates if it will be more like Feb 2 or Feb 27?
> > 
> > I would bet on Feb 1 :)
> 
> Hmm. That does not leave us too much time.
> 
> FAQ states:
> 
> # Why are some longterm versions supported longer than others?  The
> # "projected EOL" dates are not set in stone. Each new longterm kernel
> # usually starts with only a 2-year projected EOL that can be extended
> # further if there is enough interest from the industry at large to
> # help support it for a longer period of time.
> 
> Is there anyone else interested in continued 4.4.X maintainence?

I do not know of any companies or interested parties that is interested
in this.  The ones that rely on 4.4.x right now are going to be dropping
support for it this month, if they haven't already from what I know.

So I have no resources to maintain this anymore, sorry, and I STRONGLY
recommend that everyone else just move off of it as well.

> CIP project will need to maintain 4.4.X-cip and 4.4.X-cip-rt for some
> more years.

That is up to them to do, I wish them well, I think it is a loosing game
and one that is going to cost more money than they realize.  Remember,
it costs more money and time the older the kernel is to keep it "alive".
It is cheaper and easier to use more modern kernels.

> Do you think it would make sense to maintain 4.4.X-stable as well?

Not at all.  It is barely alive as-is.  If you _HAVE_ to maintain it, I
recommend only doing it on a very narrow way (i.e. limited functionality
and hardware support).  That's the only possible way you will be able to
do this.

good luck!

greg k-h
