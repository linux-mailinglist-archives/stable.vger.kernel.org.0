Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52A8367A94
	for <lists+stable@lfdr.de>; Sat, 13 Jul 2019 16:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727626AbfGMOcr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Jul 2019 10:32:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:38822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727504AbfGMOcr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 13 Jul 2019 10:32:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1718520838;
        Sat, 13 Jul 2019 14:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563028366;
        bh=ylDyKOmWTYulTWHBIjFdesqcerW9m+T420/PmqHvVbA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ega8OaLnYZzbfnmzgA3n5n3wcWHtIDXi1gOQVg9f9UqKjJXFmL3LS+p2X+0oLLJJm
         ldwNcV6WvWl5K5WSP5DCUQWg6bN2ZxcW5mvvRrcBXegnIQd0v1yCA3dTJVA8UJsTo5
         K5Wqrn04yZBuQa2jlstdPLKler6EYGDvbap4gvzI=
Date:   Sat, 13 Jul 2019 16:32:44 +0200
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
Subject: Re: [PATCH 5.2 00/61] 5.2.1-stable review
Message-ID: <20190713143244.GC7695@kroah.com>
References: <20190712121620.632595223@linuxfoundation.org>
 <CA+G9fYsm6jgQm6tdQU9Pyc5cUoW9D5Ff7kxb-2mPzzhE99+Q5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYsm6jgQm6tdQU9Pyc5cUoW9D5Ff7kxb-2mPzzhE99+Q5w@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jul 13, 2019 at 08:34:51AM +0530, Naresh Kamboju wrote:
> On Fri, 12 Jul 2019 at 18:04, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.2.1 release.
> > There are 61 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sun 14 Jul 2019 12:14:36 PM UTC.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.1-rc1.gz
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

Great!  Thanks for testing these and letting me know.

greg k-h
