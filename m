Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3631A1CC7A9
	for <lists+stable@lfdr.de>; Sun, 10 May 2020 09:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728154AbgEJHen (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 May 2020 03:34:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:34538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725810AbgEJHem (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 10 May 2020 03:34:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C78020801;
        Sun, 10 May 2020 07:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589096082;
        bh=Bp5yQpPNyFeK0vz4OHQXvDWCtP0jXhWuqnsHewf8uvU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AmWpOAg6aKeP3r1oqL2zhImw3LaCliHf3uq8Xyy9Vm7Aw5XkVt+5iXJDimPp6lr2R
         2TN66XaZd4Mv1JhruIQH4jalpoE0//vvs0WN5Jz1bfNQ413lQJVNRC/E0CQw8Kc5bt
         Ph5Seq+nizptz8CFbIUBKPfTH7bJIL3Hy601T4hM=
Date:   Sun, 10 May 2020 09:34:39 +0200
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
Subject: Re: [PATCH 5.6 00/49] 5.6.12-rc1 review
Message-ID: <20200510073439.GC3474912@kroah.com>
References: <20200508123042.775047422@linuxfoundation.org>
 <CA+G9fYv6g1ArV5u1raGkFtFKRqVJreP8dRe8r+XtOASPhN+PzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYv6g1ArV5u1raGkFtFKRqVJreP8dRe8r+XtOASPhN+PzQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 09, 2020 at 01:15:48PM +0530, Naresh Kamboju wrote:
> On Fri, 8 May 2020 at 18:25, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.6.12 release.
> > There are 49 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sun, 10 May 2020 12:29:44 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.6.12-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.6.y
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
