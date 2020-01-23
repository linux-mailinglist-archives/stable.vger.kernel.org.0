Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5808F14621F
	for <lists+stable@lfdr.de>; Thu, 23 Jan 2020 07:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725785AbgAWGo5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 01:44:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:36048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725535AbgAWGo5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jan 2020 01:44:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43B00217F4;
        Thu, 23 Jan 2020 06:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579761896;
        bh=6sdhIS//fwShMit7ksf+WjBeNo3at8hC8qzOZNYS17o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=x98zDvQjDP7BNO63LTRpKURD+zhuzDlDVNC4i06osYz5xTBoXC1e6AaHHiR3fFe54
         ySQ7znx0GiWrIxJzmjY2jPt0+2BVv9+G5sKZ2VVvERx52VtNayaPc4LuFsBLkIdGsu
         MR5kzyen9fd/L8c5Q0lUSerCdWPZfvdWVDdQMWSI=
Date:   Thu, 23 Jan 2020 07:44:54 +0100
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
Subject: Re: [PATCH 5.4 000/222] 5.4.14-stable review
Message-ID: <20200123064454.GD124954@kroah.com>
References: <20200122092833.339495161@linuxfoundation.org>
 <CA+G9fYuFsU+3V_3wKdkfNEr=LB+QsPv6WCzFVfbi6gHR5T=vmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYuFsU+3V_3wKdkfNEr=LB+QsPv6WCzFVfbi6gHR5T=vmQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 22, 2020 at 11:39:19PM +0530, Naresh Kamboju wrote:
> On Wed, 22 Jan 2020 at 18:48, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.4.14 release.
> > There are 222 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri, 24 Jan 2020 09:25:24 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.14-rc1.gz
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

Thanks for testing all of these and letting me know.

greg k-h
