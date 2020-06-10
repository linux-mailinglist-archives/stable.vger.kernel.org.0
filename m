Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BACC1F5B59
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 20:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbgFJSjh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 14:39:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:33488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726105AbgFJSjh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Jun 2020 14:39:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 409F52070B;
        Wed, 10 Jun 2020 18:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591814376;
        bh=/nwQv7HXY+4bnbap37SNwzFMFGsDsxZDiqThHNWQbJc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oy1cCCPKx5iFNIzc7JpcFTYTyFIZlrf+nPIl2u/tnAfvbGT9xRKRd0/MjfMwS3Avi
         sz6mD+FHTiVTWxjaeCmCpvW+NZa3ogHGcj8kKGtFnQBfNGWGEZAq7CQ+xp6dGVnHdG
         vd+xbceoBDXbJ/atB43WcmcsUkt+PQ5SeZKGA9uw=
Date:   Wed, 10 Jun 2020 20:39:31 +0200
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
Subject: Re: [PATCH 5.7 00/24] 5.7.2-rc1 review
Message-ID: <20200610183931.GA14871@kroah.com>
References: <20200609174149.255223112@linuxfoundation.org>
 <CA+G9fYurJXfpg7QfsxxRPSFhG2cNkU-zA=VM==1b4E8bmjxecg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYurJXfpg7QfsxxRPSFhG2cNkU-zA=VM==1b4E8bmjxecg@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 10, 2020 at 11:47:30AM +0530, Naresh Kamboju wrote:
> On Tue, 9 Jun 2020 at 23:25, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.7.2 release.
> > There are 24 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 11 Jun 2020 17:41:38 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.2-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.7.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.

Thanks for testing all of these and letting me know.

greg k-h
