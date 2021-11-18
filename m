Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0AC4556D1
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 09:16:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244578AbhKRITs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 03:19:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:40790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244580AbhKRIRy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Nov 2021 03:17:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F1D460F11;
        Thu, 18 Nov 2021 08:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637223294;
        bh=/RMzfvO9g/O9EBRfqQyu3cL+5cxmpru4SLA4CxGakgY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iyfy1THpLUbmvuITWcCak3RY0uUgc2uIqYxuHFVzMejyEeys8y3EQ0RXQZ0ZRT8Rp
         9F7xh+RYAdTc8AxFfr0AVd0l9CSIWJBMBlQWZNVbZVeL7UL/xNLhbgmSrx0sc8djet
         tUAEB+Z4NvCvWF7dj0LSb8I3gk1e8+e3yAxK4n58=
Date:   Thu, 18 Nov 2021 09:14:51 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Kees Cook <keescook@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Holger =?iso-8859-1?Q?Hoffst=E4tte?= 
        <holger@applied-asynchrony.com>,
        Qi Zheng <zhengqi.arch@bytedance.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Justin Forbes <jmforbes@linuxtx.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        stable <stable@vger.kernel.org>,
        Wang Yugui <wangyugui@e16-tech.com>,
        =?iso-8859-1?Q?Fran=E7ois?= Guerraz <kubrick@fgv6.net>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH 5.15 000/923] 5.15.3-rc3 review
Message-ID: <YZYLe+9ijN8S8TNW@kroah.com>
References: <20211117101657.463560063@linuxfoundation.org>
 <YZV02RCRVHIa144u@fedora64.linuxtx.org>
 <55c7b316-e03d-9e91-d74c-fea63c469b3b@applied-asynchrony.com>
 <CAHk-=wjHbKfck1Ws4Y0pUZ7bxdjU9eh2WK0EFsv65utfeVkT9Q@mail.gmail.com>
 <202111171609.56F12BD@keescook>
 <7bc0d46b-1412-a630-bbf7-57e7ec702784@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7bc0d46b-1412-a630-bbf7-57e7ec702784@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 17, 2021 at 10:26:31PM -0800, Guenter Roeck wrote:
> On 11/17/21 4:16 PM, Kees Cook wrote:
> > On Wed, Nov 17, 2021 at 03:50:17PM -0800, Linus Torvalds wrote:
> > > Sorry for top-posting and quoting this all, but the actual people
> > > involved with the wchan changes don't seem to be on the participant
> > > list.
> > 
> > Adding more folks from a private report and
> > https://bugzilla.kernel.org/show_bug.cgi?id=215031
> > 
> > and for the new people, here's a lore link for this thread:
> > https://lore.kernel.org/stable/YZV02RCRVHIa144u@fedora64.linuxtx.org/
> > 
> > 
> > FWIW, earlier bisection pointed to the stable backport of
> > 5d1ceb3969b6b2e47e2df6d17790a7c5a20fcbb4 being the primary culprit.
> > At first glance it seems to me that the problem with -stable is that an
> > unvetted subset of the wchan refactoring series landed in -stable.
> > 
> 
> Can the (partial) wchan backport possibly be dropped from v5.15.y until
> someone figures out what exactly - if anything - is needed ?

Now dropped.
