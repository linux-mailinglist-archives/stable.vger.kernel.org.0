Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F08129A8D
	for <lists+stable@lfdr.de>; Fri, 24 May 2019 17:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389331AbfEXPBq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 May 2019 11:01:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:36128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389321AbfEXPBq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 May 2019 11:01:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2FB202133D;
        Fri, 24 May 2019 15:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558710105;
        bh=Oj9G6qrOx4MxnHRPww+ypylXeuYaU/WyJccmTQzoOtE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=C2VSzfNUuSipCKR6sjE+RO1OEJY1PD4PP83Ir859Xe/Ks1jNMT3Y5+jTEjMvsRlJk
         ruWw/EO7E54vWagaedSY+NIrxq/vRJJhCwzZySoe2QXw3ZOAS80FHatOZzmRIPPaw8
         cTGPQQftqlN+pzT0X8lqDAQRBJF9mxch+wDYPgLI=
Date:   Fri, 24 May 2019 17:01:43 +0200
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
Subject: Re: [PATCH 5.1 000/122] 5.1.5-stable review
Message-ID: <20190524150143.GC9757@kroah.com>
References: <20190523181705.091418060@linuxfoundation.org>
 <CA+G9fYsY+=+kMgc+Wz88YP-L5zba0iTn0c1JfCFQEHKDHhFAxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYsY+=+kMgc+Wz88YP-L5zba0iTn0c1JfCFQEHKDHhFAxg@mail.gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 24, 2019 at 02:23:49PM +0530, Naresh Kamboju wrote:
> On Fri, 24 May 2019 at 00:56, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.1.5 release.
> > There are 122 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat 25 May 2019 06:14:44 PM UTC.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.5-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.

Great!  Thanks for testing all of these and letting me know.

greg k-h
