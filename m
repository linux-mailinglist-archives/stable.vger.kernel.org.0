Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A71A63146
	for <lists+stable@lfdr.de>; Tue,  9 Jul 2019 08:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726031AbfGIG47 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jul 2019 02:56:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:53922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725818AbfGIG47 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jul 2019 02:56:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 092EC21537;
        Tue,  9 Jul 2019 06:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562655418;
        bh=dEkw4tLIQfW07iinojJG510qYCl6qWkBON8wmYXyHEY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n9pQhMyjobyRvH/7tJxUz447tG4OxO9++Dko5oZjDvWMZb2hx6NrPe/3ZJZ2XUiqH
         TS8p6tYzJMPKahg8/9kU6v2xt/jrHuo3A6qdj3I+vOBraiXbVU/ccL3Um9eGOjRssB
         61p7tEl74MNuhTi3wkspJ3AhAOA3HMgxXo7nt0R8=
Date:   Tue, 9 Jul 2019 08:56:56 +0200
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
Subject: Re: [PATCH 5.1 00/96] 5.1.17-stable review
Message-ID: <20190709065656.GB13978@kroah.com>
References: <20190708150526.234572443@linuxfoundation.org>
 <CA+G9fYuUEib3uaKkTSf4Sfqv9DEUyXjx+nKcdPN70w15JU6AFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYuUEib3uaKkTSf4Sfqv9DEUyXjx+nKcdPN70w15JU6AFQ@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 09, 2019 at 10:13:17AM +0530, Naresh Kamboju wrote:
> On Mon, 8 Jul 2019 at 21:02, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.1.17 release.
> > There are 96 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed 10 Jul 2019 03:03:52 PM UTC.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.17-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.

Great, thanks for testing all of these!

greg k-h
