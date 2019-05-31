Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5452A30EC1
	for <lists+stable@lfdr.de>; Fri, 31 May 2019 15:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726330AbfEaNUp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 May 2019 09:20:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:39622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726037AbfEaNUp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 31 May 2019 09:20:45 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98F1425FAB;
        Fri, 31 May 2019 13:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559308844;
        bh=IVpg/xGn7qe8/tHwC9TEBHbh9a1nkzglnzMUdZRU/Cw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LrNhS0OxAzs3zpV7Bl3Hc7gBmj4dvlpnv7kdO1HOtNz3ahaN2tp+34dPXGSs+BqdW
         +5k6hzl1LiYCldy6Eqjs2LBSHmGjiyntpL8Ru1cX25nFoED/BCTxkhsOJG/C0dBylI
         /chJdDpjwId9B6JEXNbJ22ShJc9TgamTuBpFeMqg=
Date:   Fri, 31 May 2019 06:20:43 -0700
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
Subject: Re: [PATCH 5.0 000/346] 5.0.20-stable review
Message-ID: <20190531132043.GA5211@kroah.com>
References: <20190530030540.363386121@linuxfoundation.org>
 <CA+G9fYtW1E+jOKaU3qnhdwa63r1t7i04uMAcigWAUjVmDss6Pg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYtW1E+jOKaU3qnhdwa63r1t7i04uMAcigWAUjVmDss6Pg@mail.gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 30, 2019 at 09:53:33PM +0530, Naresh Kamboju wrote:
> On Thu, 30 May 2019 at 08:48, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.0.20 release.
> > There are 346 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat 01 Jun 2019 03:02:10 AM UTC.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.0.20-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.0.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.

Thanks for testing 4 of these and letting me know.

greg k-h
