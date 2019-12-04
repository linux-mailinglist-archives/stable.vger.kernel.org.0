Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2874113692
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 21:38:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728031AbfLDUiX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 15:38:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:45676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728238AbfLDUiX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 15:38:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 232162073B;
        Wed,  4 Dec 2019 20:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575491902;
        bh=N+AIo2dmNSGRqulQQ0r2IijkmkIO/Lap3bo/h6ut8Lg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WIetwm/69rJbvd9DX8sEFgnIhmpyMmc6yHe/D2HQwDa+H0WNd41HJfXmCV/6jRALA
         frfiUI+soQQPNvv+5gLTR7tlshhXXQN+576ot6cOs/S5ZjKclrsJqDci7b313VPFMh
         ZNPSdOLr/QfnAZDbpYjRhEatb8mUH4chvTR6uNIU=
Date:   Wed, 4 Dec 2019 21:38:20 +0100
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
Subject: Re: [PATCH 5.4 00/46] 5.4.2-stable review
Message-ID: <20191204203820.GD3685601@kroah.com>
References: <20191203212705.175425505@linuxfoundation.org>
 <CA+G9fYt+OD3ggbPcoDA=TAXL0b930yVSqpo4-kpbuYKu0A8iHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYt+OD3ggbPcoDA=TAXL0b930yVSqpo4-kpbuYKu0A8iHQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 04, 2019 at 07:26:23PM +0530, Naresh Kamboju wrote:
> On Wed, 4 Dec 2019 at 04:07, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.4.2 release.
> > There are 46 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 05 Dec 2019 21:20:36 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.2-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.

Thanks for testing these and letting me know.

greg k-h
