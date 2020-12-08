Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6715F2D27F1
	for <lists+stable@lfdr.de>; Tue,  8 Dec 2020 10:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728987AbgLHJmX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Dec 2020 04:42:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:47648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728813AbgLHJmX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Dec 2020 04:42:23 -0500
Date:   Tue, 8 Dec 2020 10:42:51 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607420503;
        bh=OPRdtXo+b3fj0Tly5SZe2L9SsKslAawkKaxtdea4VmQ=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=VxPt11EmjME54Y3knWT0FywaT4ox9CyA43xmhiu0siuFmvKxQH/pubclg4YHAYMUp
         VlyNXg71zAjSxDgIH2152GVb0RJteL1w7BOTMwdRbduxak1+pmDlGZTM/EgIwWEUw2
         LlcdShyTSqoYXPpKYo6F5OUE1QvWGp5h5JYbH85w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        linux-stable <stable@vger.kernel.org>
Subject: Re: [PATCH 5.9 00/46] 5.9.13-rc1 review
Message-ID: <X89KmwbnuWvh7Eus@kroah.com>
References: <20201206111556.455533723@linuxfoundation.org>
 <CA+G9fYt6AO+iz42u=9PKW2UwXcU_FLr35YfsKEEMsbf2gdaqqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYt6AO+iz42u=9PKW2UwXcU_FLr35YfsKEEMsbf2gdaqqA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 07, 2020 at 12:47:38PM +0530, Naresh Kamboju wrote:
> On Sun, 6 Dec 2020 at 17:14, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.9.13 release.
> > There are 46 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Tue, 08 Dec 2020 11:15:42 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.9.13-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.9.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.
> 
> Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Thanks for testing all of these and letting me know.

greg k-h
