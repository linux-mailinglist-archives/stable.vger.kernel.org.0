Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4033E148ABD
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 15:55:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387597AbgAXOzb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 09:55:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:46574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387565AbgAXOzb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 09:55:31 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE08B2071A;
        Fri, 24 Jan 2020 14:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579877731;
        bh=m0t1jjsy3xs2HWlELIF07IJZDDbROxtZDkIG0+qm2ho=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2J2wJtUVMRudb2eQ3NOMrxEJLjk0Ofy4ty9o/+3AsHMU53umohu3tsdB9ek2C6y0o
         9Cr5m6VtVX7LkGMFDvagZZYiAuj3w3ijBrqJQkfL+Sh7o1hJJMyDcItAZY6p6SocOm
         zi3465AjOnF624VEk5PAZAMeO2DEa8TsxidKTX6s=
Date:   Fri, 24 Jan 2020 09:55:29 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Mark Brown <broonie@kernel.org>,
        Guillaume Tucker <guillaume.tucker@collabora.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        mgalka@collabora.com,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: stable-rc/linux-4.19.y bisection: baseline.login on
 sun8i-h3-libretech-all-h3-cc
Message-ID: <20200124145529.GG1706@sasha-vm>
References: <5e2ad951.1c69fb81.6d762.dd8e@mx.google.com>
 <0ed4668a-fb29-fca8-558e-385ef118d432@collabora.com>
 <20200124131821.GA4918@sirena.org.uk>
 <CACRpkdYdX-k+YT5wmyRzDnvaziwEDhYe82r3V2WOW6tyvNomFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CACRpkdYdX-k+YT5wmyRzDnvaziwEDhYe82r3V2WOW6tyvNomFg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 24, 2020 at 02:44:19PM +0100, Linus Walleij wrote:
>On Fri, Jan 24, 2020 at 2:18 PM Mark Brown <broonie@kernel.org> wrote:
>> On Fri, Jan 24, 2020 at 12:58:32PM +0000, Guillaume Tucker wrote:
>>
>> > Please see the bisection report below about a boot failure, it
>> > looks legit as this commit was made today:
>>
>> > >     Fix it by ignoring the config in the device tree for now: the
>> > >     later patches in the series will push all inversion handling
>> > >     over to the gpiolib core and set it up properly in the
>> > >     boardfiles for legacy devices, but I did not finish that
>> > >     for this kernel cycle.
>
>So here the patch clearly says it is for "this kernel cycle"
>which I feel implies that it is NOT for any previous kernels
>stable or not...

This read to me as if this patch plasters the issue for now, and a
proper fix will follow in the next cycle.

>I'm sorry if I missed the "look at this thing that we will
>apply to stable soon" mail, sadly there are just too many
>of these for me to handle sometimes. (Maybe it means I
>am making too many mistakes to begin with, mea culpa.)
>
>> > >     Reported-by: Leonard Crestez <leonard.crestez@nxp.com>
>> > >     Reported-by: Fabio Estevam <festevam@gmail.com>
>> > >     Reported-by: John Stultz <john.stultz@linaro.org>
>> > >     Reported-by: Anders Roxell <anders.roxell@linaro.org>
>> > >     Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>> > >     Tested-by: John Stultz <john.stultz@linaro.org>
>> > >     Signed-off-by: Mark Brown <broonie@kernel.org>
>> > >     Signed-off-by: Sasha Levin <sashal@kernel.org>
>>
>> Oh dear, this is another bot backported commit which I suspect is
>> lacking some context or other from all the other work that was done with
>> GPIO enables :(
>
>This AI seems a bit confused :/
>Maybe it is the prolific use of the word "fix" that triggers it?

Right, it's a combo of a few things: one of them is indeed the work
"fix", but few others are the Reported-by tags, the simplicity of the
commit, and so on.

I'll drop this patch, sorry about this.

-- 
Thanks,
Sasha
