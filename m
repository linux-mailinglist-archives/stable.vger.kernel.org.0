Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12B31164DF4
	for <lists+stable@lfdr.de>; Wed, 19 Feb 2020 19:50:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbgBSSu5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Feb 2020 13:50:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:37034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726645AbgBSSu5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Feb 2020 13:50:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 346722465D;
        Wed, 19 Feb 2020 18:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582138256;
        bh=Yy81ui9qoVqGZ9eC0htXLiu+PBhXSenGmlWpoMOXdSs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=crLP5cLcqhPCMrlGH9JUmlSIBiX+188k20PlEZkHW49J5FUIVPDam0jKBFv2d3JYH
         soW6qdpeMWW+8f9YaR/9kiCRMgF3H4ROZgX6408SsjLEarInKCYzhqUSnMxeFBQOrx
         WVXNMWFW7E4+ZTdJEkTjOQ+zSeJjy9bIEWyX01ak=
Date:   Wed, 19 Feb 2020 19:50:54 +0100
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
Subject: Re: [PATCH 5.5 00/80] 5.5.5-stable review
Message-ID: <20200219185054.GB2857377@kroah.com>
References: <20200218190432.043414522@linuxfoundation.org>
 <CA+G9fYtcyGqf=L3nwt6Qfm6O4CeCVCwYqYrQcLwiB9DWVrY6hw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYtcyGqf=L3nwt6Qfm6O4CeCVCwYqYrQcLwiB9DWVrY6hw@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 19, 2020 at 10:00:27AM +0530, Naresh Kamboju wrote:
> On Wed, 19 Feb 2020 at 01:32, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.5.5 release.
> > There are 80 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 20 Feb 2020 19:03:19 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.5.5-rc1.gz
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

Great, thanks for testing all of them and letting me know.

greg k-h
