Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0E728E571
	for <lists+stable@lfdr.de>; Thu, 15 Aug 2019 09:19:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730476AbfHOHTy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Aug 2019 03:19:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:51314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726366AbfHOHTx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Aug 2019 03:19:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6FC1C206C2;
        Thu, 15 Aug 2019 07:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565853592;
        bh=pBw8ORQn4mttXj6tf+hS7vuCm6iM+ZgsBbeZqNFrqxs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vZndUSmcGXon7Fv0PxATNy0NmDuAiaWbAXYVoSFRhFXP8X4GnGhw4VaieO2B/ZOK9
         kTC/NjdQ1PDjD5z8jdgJSD058Z4DvY27HVnuiqn/M6ZDfxFCK8UqSVC73DFVWMfJtm
         cb47dWIS2KM5YzPqTvnDw/07l+jZ++51M1XEWBJs=
Date:   Thu, 15 Aug 2019 09:19:50 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>
Subject: Re: [PATCH 5.2 000/144] 5.2.9-stable review
Message-ID: <20190815071950.GB26670@kroah.com>
References: <20190814165759.466811854@linuxfoundation.org>
 <CA+G9fYuTC_TWJVD4mug6UdrmNwK59uZAbUYT4zLETvcjZpr0VA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYuTC_TWJVD4mug6UdrmNwK59uZAbUYT4zLETvcjZpr0VA@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 15, 2019 at 07:04:45AM +0530, Naresh Kamboju wrote:
> On Wed, 14 Aug 2019 at 22:33, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.2.9 release.
> > There are 144 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri 16 Aug 2019 04:55:34 PM UTC.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.9-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.2.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> >
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.

Thanks for testing all of these and letting me know.

greg k-h
