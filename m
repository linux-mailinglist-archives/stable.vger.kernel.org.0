Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 848232756C5
	for <lists+stable@lfdr.de>; Wed, 23 Sep 2020 13:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbgIWLA3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Sep 2020 07:00:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:36978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726419AbgIWLA2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Sep 2020 07:00:28 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60753235FC;
        Wed, 23 Sep 2020 11:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600858827;
        bh=1FLlLoKhI8jFAzxGn/pX4LIgO96pXGzKo7MWgSaa5CU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aR43T2WnSdUL19GqzJ5374w0b6hIrZnLcMEAKhF9QhjO5VIf2fVtfKBBWlbPT2OeW
         KFimd+WkjmVv9z8fpMy6zS9+VPhDxwQimdHVSI06NlGj+MVYGUEEpwrVIq1Um+lnlr
         NhqJ3bDP/eUlAXjlsqCmX3bpDadaXcFtU+AhR75w=
Date:   Wed, 23 Sep 2020 13:00:47 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH 5.8 000/118] 5.8.11-rc1 review
Message-ID: <20200923110047.GA3340140@kroah.com>
References: <20200921162036.324813383@linuxfoundation.org>
 <CAMuHMdVhowO4jK7hNk9MK5-SdmgQs3BTV3rd9jvYBknTX0GeXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdVhowO4jK7hNk9MK5-SdmgQs3BTV3rd9jvYBknTX0GeXA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 21, 2020 at 08:44:29PM +0200, Geert Uytterhoeven wrote:
> Hi Greg,
> 
> On Mon, Sep 21, 2020 at 6:47 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > This is the start of the stable review cycle for the 5.8.11 release.
> > There are 118 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 23 Sep 2020 16:20:12 +0000.
> > Anything received after that time might be too late.
> 
> > Jan Kara <jack@suse.cz>
> >     dax: Fix compilation for CONFIG_DAX && !CONFIG_FS_DAX
> >
> > Jan Kara <jack@suse.cz>
> >     dm: Call proper helper to determine dax support
> 
> Perhaps it would be wise to hold-off a bit on backporting these, until
> they have received more testing?

Seems to be passing all of the testing bots we have thrown at it :)

thanks,

greg k-h
