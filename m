Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B49A1C5FC8
	for <lists+stable@lfdr.de>; Tue,  5 May 2020 20:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730505AbgEESMe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 May 2020 14:12:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:57962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730184AbgEESMd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 May 2020 14:12:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E16B206B8;
        Tue,  5 May 2020 18:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588702353;
        bh=cfXlHUhlmzsnbp3xF7JwuyNyI7Wa9u8sBDQfEmOeyaA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RyqF5+Lg1iiVjMeCf/WXQEowUJtq/smJx++54IgjL5ZF5PcGvlPXfm8Gj5k++IfDL
         JHXg84yPl9TjggqZAJ8tiTAjuSra1fxZRfhuXxCV/XpfsSjf9D44DaIgTrJG+t8ezX
         Whsn0yIUJgZEo4wgm06dulszFvNUS5GblhlHMURk=
Date:   Tue, 5 May 2020 20:12:30 +0200
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
Subject: Re: [PATCH 5.6 00/73] 5.6.11-rc1 review
Message-ID: <20200505181230.GB1210667@kroah.com>
References: <20200504165501.781878940@linuxfoundation.org>
 <CA+G9fYtwpo01W30vF8PRNrDOxVgyVwyViC5RCmLvLu04t98u4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYtwpo01W30vF8PRNrDOxVgyVwyViC5RCmLvLu04t98u4Q@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 05, 2020 at 07:57:55PM +0530, Naresh Kamboju wrote:
> On Mon, 4 May 2020 at 23:36, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.6.11 release.
> > There are 73 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 06 May 2020 16:52:55 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.6.11-rc1.gz
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
