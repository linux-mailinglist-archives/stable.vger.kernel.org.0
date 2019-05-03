Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 861A2128E6
	for <lists+stable@lfdr.de>; Fri,  3 May 2019 09:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726022AbfECHcv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 May 2019 03:32:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:53314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725768AbfECHcv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 May 2019 03:32:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1ECA52075C;
        Fri,  3 May 2019 07:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556868770;
        bh=NCOqAHbr04W3fEc+gwthvKv36/OfLDeO7qlPWhVGpyk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xXmQQhw5idyZnqcAdHvJCpJRLJ2MhR28IoA9OSokyVyJ0po5kWEXlR0Ey+NEWqHyE
         RlEjVrRkas+LkjxQpb04RQN1PXTrsyxAbHcoVPy9ShyWgHrgzNzxMA8k50depe+Wj6
         Z5gR667vkiiWlscFeQQughY/74NX2XhNG+5UttS0=
Date:   Fri, 3 May 2019 09:32:47 +0200
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
Subject: Re: [PATCH 5.0 000/101] 5.0.12-stable review
Message-ID: <20190503073247.GA24977@kroah.com>
References: <20190502143339.434882399@linuxfoundation.org>
 <CA+G9fYuu37iYrWuY_+jYjawjmFmjvMTOXJCFKT7k853-_ruiew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYuu37iYrWuY_+jYjawjmFmjvMTOXJCFKT7k853-_ruiew@mail.gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 03, 2019 at 12:19:51PM +0530, Naresh Kamboju wrote:
> On Thu, 2 May 2019 at 21:00, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.0.12 release.
> > There are 101 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat 04 May 2019 02:32:10 PM UTC.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.0.12-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.0.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> >
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.

Great!  Thanks for testing all of these and letting me know.

greg k-h
