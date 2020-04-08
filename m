Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B045E1A23C7
	for <lists+stable@lfdr.de>; Wed,  8 Apr 2020 16:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728180AbgDHOHB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Apr 2020 10:07:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:42994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728159AbgDHOHA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Apr 2020 10:07:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD26D20780;
        Wed,  8 Apr 2020 14:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586354820;
        bh=mwQWgzVnM1Gk3FCn6bt7z1/0O75c4sfpqBfxxPs/al0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Gh7bxstm1xQxcj6Pf/epMrYu3OflWzvm5XzwmHvdoWuHVaZrCDtMitxeuZTT5im+L
         8ntbEZpPrf/BJgbl+SZHwn3dy4pcYd9O8Zqyvweblvr/Q0Ndbw7FDB5ypNHT7CObXT
         vQTJ87Osa66oVYrL/5pWmbpjesQ87Sz/FMHCyFsc=
Date:   Wed, 8 Apr 2020 16:06:58 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH 5.6 00/30] 5.6.3-rc2 review
Message-ID: <20200408140658.GA1251074@kroah.com>
References: <20200407154752.006506420@linuxfoundation.org>
 <CA+G9fYsyETNoV58oyrBtb2o_vyFi1MPUNkZ9uUZK6uRCg5OK5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYsyETNoV58oyrBtb2o_vyFi1MPUNkZ9uUZK6uRCg5OK5w@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 08, 2020 at 03:16:45PM +0530, Naresh Kamboju wrote:
> On Tue, 7 Apr 2020 at 22:09, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.6.3 release.
> > There are 30 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 09 Apr 2020 15:46:32 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.6.3-rc2.gz
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
