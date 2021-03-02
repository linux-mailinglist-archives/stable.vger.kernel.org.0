Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AEB632AEFA
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:13:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233356AbhCCAMX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:12:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:40824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349612AbhCBKnG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 05:43:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 45C7764F07;
        Tue,  2 Mar 2021 10:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614681745;
        bh=DdXKVUnksCfTHHjSak+aaPQQWvh1EP0gYUAhBkgneOI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qgUK+IynVfVN+gnX6Wv85Nd8QTMDCbIEleqCaOsTCa7eNC/6R5tUma6pIQJvodUFn
         sZzk/HhYwyQK78G4tqZcO6WhfgOp2mOSv8WSbOUGxMJftxM3b0QiB0LrTlcqpI7D5y
         JNTSpPWRvdbp3u7zRxfmZDN3C3A4X4hOOZ0jJ9VA=
Date:   Tue, 2 Mar 2021 11:42:23 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 4.19 000/246] 4.19.178-rc2 review
Message-ID: <YD4WjzEIz2aLA/o8@kroah.com>
References: <20210301193544.489324430@linuxfoundation.org>
 <CA+G9fYs+tDGcOA8xJrkgOAdENg+tDSWeK1J9UvbR9fzo3bV6CQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYs+tDGcOA8xJrkgOAdENg+tDSWeK1J9UvbR9fzo3bV6CQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 02, 2021 at 04:09:29PM +0530, Naresh Kamboju wrote:
> On Tue, 2 Mar 2021 at 01:19, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 4.19.178 release.
> > There are 246 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 03 Mar 2021 19:35:01 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.178-rc2.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> 
> [For the record]
> 
> Results from Linaro’s test farm.
> Regressions detected on 4.19.178-rc2 for below listed devices and configs.
> 
> 
> Build error:
> ---------------
> include/linux/icmpv6.h: In function 'icmpv6_ndo_send':
> include/linux/icmpv6.h:70:2: error: implicit declaration of function
> '__icmpv6_send'; did you mean 'icmpv6_send'?
> [-Werror=implicit-function-declaration]
>    70 |  __icmpv6_send(skb_in, type, code, info, &parm);
>       |  ^~~~~~~~~~~~~
>       |  icmpv6_send
> cc1: some warnings being treated as errors

Only on allnoconfig and tiny configs, right?  Will work on this after
lunch...

thanks,

greg k-h
