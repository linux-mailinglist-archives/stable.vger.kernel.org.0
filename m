Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92B75192FEE
	for <lists+stable@lfdr.de>; Wed, 25 Mar 2020 18:54:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727843AbgCYRyu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Mar 2020 13:54:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:37670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727006AbgCYRyu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Mar 2020 13:54:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12685206F6;
        Wed, 25 Mar 2020 17:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585158888;
        bh=9ihdfZAOYRAaqC0XBdLAl2zGzdR+z6H0O8D0fLFiScw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rkCLY1+KAlrXzNMgQ4ADifcwG7HbpIwu+2LxO4e2bQtN53pvhULA2RG4Nivctah0B
         4A0r45Lqd4JKJTngUk1GlhgRqw7B30KAsb7xA1a/uT3oh87CZYhOvyq2DFQcJTnQKL
         UIUwsLyyALPnwjwyOxvIjH/L0FtjfhDHzg7Dkodw=
Date:   Wed, 25 Mar 2020 18:54:46 +0100
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
Subject: Re: [PATCH 5.5 000/119] 5.5.12-rc1 review
Message-ID: <20200325175446.GD3765240@kroah.com>
References: <20200324130808.041360967@linuxfoundation.org>
 <CA+G9fYvNRXe7phaXrUeAtx+KUnmRXG7ic=suN9Ek7dgDdYOv6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYvNRXe7phaXrUeAtx+KUnmRXG7ic=suN9Ek7dgDdYOv6Q@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 25, 2020 at 11:16:22AM +0530, Naresh Kamboju wrote:
> On Tue, 24 Mar 2020 at 18:52, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.5.12 release.
> > There are 119 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 26 Mar 2020 13:06:42 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.5.12-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.5.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.

Great, thanks for testing these and letting me know.

greg k-h
