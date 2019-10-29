Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A875EE8319
	for <lists+stable@lfdr.de>; Tue, 29 Oct 2019 09:20:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728868AbfJ2IUb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Oct 2019 04:20:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:56356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728113AbfJ2IUb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Oct 2019 04:20:31 -0400
Received: from localhost (unknown [91.217.168.176])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B9FA20717;
        Tue, 29 Oct 2019 08:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572337230;
        bh=CrG2u9UyUZXG3Xr/MHkZ4yqOAoADNz6ZmA0e8aqOJMQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tP2EWmWDTDOwlKQY6OqmtNaVVbLWFdrj7VyVwMH7t57sVVQfl04E5mvl2rFY8xg/U
         FA8Y4x8hqVZDCZNLH1K0QfxAnApHr8bdIolMQZHpr/KPFQRSt1+KFtxtZcqjeaD9+6
         b/SoVB+76aT8kjXLi1pqANXyN/ciYHGSy99WYBHM=
Date:   Tue, 29 Oct 2019 09:20:28 +0100
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
        LTP List <ltp@lists.linux.it>
Subject: Re: [PATCH 4.19 00/93] 4.19.81-stable review
Message-ID: <20191029082028.GA554294@kroah.com>
References: <20191027203251.029297948@linuxfoundation.org>
 <CA+G9fYuA+kLqLo1_ev0=QRvYtMrVhwRvm+QO-tOCVYca2Mt97Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYuA+kLqLo1_ev0=QRvYtMrVhwRvm+QO-tOCVYca2Mt97Q@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 29, 2019 at 11:51:26AM +0530, Naresh Kamboju wrote:
> On Mon, 28 Oct 2019 at 02:44, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 4.19.81 release.
> > There are 93 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Tue 29 Oct 2019 08:27:02 PM UTC.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.81-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> >
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.
> 
> Note:
> The new test case  from LTP version upgrade syscalls sync_file_range02 is an
> intermittent failure. We are investigating this case.
> The listed fixes in the below section are due to LTP upgrade to v20190930.

Thanks for testing two of these and letting me know.

greg k-h
