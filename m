Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2F8BABCC
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 23:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728513AbfIVVJQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 17:09:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:41964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726785AbfIVVJQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 17:09:16 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F5F82070C;
        Sun, 22 Sep 2019 21:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569186555;
        bh=alZlAFI88uQKO3TI1efMXalp7W4GG2ubqw4flqan360=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=neTRPkl1pEW+5+uJ3z+Isq6PgSNSqyXg/acK+8gDHyNa9MSmLdXgYM+HH3gWf3bGG
         qCmvzwnsPRlV5egA2EmoiPvXoGd/Fg43yWaZK25/QWAkZDIg8WgLdzS5stw2QMuDAk
         N7OG7Dsw09rGpyYfmvUdkW2LT7bSAZoW/mNJ7UGM=
Date:   Sun, 22 Sep 2019 17:09:14 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: Please apply commit 0f0727d971f6 ("drm/amd/display: readd -msse2
 to prevent Clang from emitting libcalls to undefined SW FP routines") to
 4.19.y
Message-ID: <20190922210914.GC8171@sasha-vm>
References: <CAKwvOdm0sWCF=PiNJvKWxt7CaTXSF13cZNuYPhKC=Kq8ooi1HA@mail.gmail.com>
 <20190820210716.GA31292@kroah.com>
 <20190820212539.GA1581@sasha-vm>
 <20190820213524.GA25049@kroah.com>
 <CAKwvOdkp8aV9VeJhd5oxshJLTmrB3i9juea4CMo5K8o9CadOfw@mail.gmail.com>
 <20190922081638.GC2524798@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190922081638.GC2524798@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Sep 22, 2019 at 10:16:38AM +0200, Greg KH wrote:
>On Tue, Aug 20, 2019 at 02:41:15PM -0700, Nick Desaulniers wrote:
>> On Tue, Aug 20, 2019 at 2:35 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>> >
>> > On Tue, Aug 20, 2019 at 05:25:39PM -0400, Sasha Levin wrote:
>> > > On Tue, Aug 20, 2019 at 02:07:16PM -0700, Greg KH wrote:
>> > > > On Tue, Aug 20, 2019 at 02:00:21PM -0700, Nick Desaulniers wrote:
>> > > > > Please apply commit 0f0727d971f6 ("drm/amd/display: readd -msse2 to
>> > > > > prevent Clang from emitting libcalls to undefined SW FP routines") to
>> > > > > 4.19.y.
>> > > > >
>> > > > > It will help with AMD based chromebooks for ChromeOS.
>> > > >
>> > > > That commit id is not in Linus's tree, are you sure you got it correct?
>> > >
>> > > That's a linux-next commit.
>> >
>> > Great, we can wait for it to show up in Linus's tree first :)
>>
>> *checks tree*
>> Oh yeah, oops.  Sorry for the noise.
>
>It's in Linus's tree now, but it does not apply to 5.2.y or 4.19.y, so
>can you provide a working backport for those kernels?

Looks like it was mostly due to missing 7ed4e6352c16f ("drm/amd/display:
Add DCN2 HW Sequencer and Resource") on older kernels. I've fixed it up
and queued it up.

--
Thanks,
Sasha
