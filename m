Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACD7A247EF8
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 09:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbgHRHHE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 03:07:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:40546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726043AbgHRHHE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Aug 2020 03:07:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A493720658;
        Tue, 18 Aug 2020 07:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597734424;
        bh=+XlUuiYgxpjWLxJnFmdvDv42C/DsTrYSpERrcEEgrRo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rYjUiCoj48gNlq+617b1au+TbIcSRSE/beRJD6kJhx1AUYzmdpVS+FHaGkFhyjgxk
         E36rY2CoCJpOPpZfRSyelpD1vRoi23yE3MdY6EvtPwDX7aOZ7gY8ZsGZ2y2aNNgzR2
         81+3C2vWCKEKQ99tReAPg/4awcQ9ATw0MCx5oDRs=
Date:   Tue, 18 Aug 2020 09:07:27 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 5.8 000/464] 5.8.2-rc1 review
Message-ID: <20200818070727.GA3333@kroah.com>
References: <20200817143833.737102804@linuxfoundation.org>
 <CA+G9fYtidMe-oYY7ZZi-cYMz1HYxdsLAX-6oJHerfr1SD6taXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYtidMe-oYY7ZZi-cYMz1HYxdsLAX-6oJHerfr1SD6taXw@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 18, 2020 at 10:38:20AM +0530, Naresh Kamboju wrote:
> On Mon, 17 Aug 2020 at 20:49, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.8.2 release.
> > There are 464 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 19 Aug 2020 14:36:49 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.2-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.8.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.

Thanks for testing all of these and letting me know, that was fast!

greg k-h
