Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBE141A082
	for <lists+stable@lfdr.de>; Fri, 10 May 2019 17:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727318AbfEJPuz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 May 2019 11:50:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:58750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727264AbfEJPuz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 May 2019 11:50:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA9FA20881;
        Fri, 10 May 2019 15:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557503455;
        bh=1BVvOWCjoaFQDVl6i/Zn1Sw6NKesESpsYSrv+0kFYWY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rRM4nRWfRRZ40yQKb+fRWhQlHDrHcrQCb1c+k5tnCZ7vPnorUA4P6onuV3zIqD0Iz
         VhSxVSlofoJN5bL2mtZjd/nuxj2oajHeV9C69FhUZqxIgYNHqV0jYe3OOJNdtPoeeB
         Asgcg7shiKvSW+bUS4mBTC4CJFD/4YN1DILDA9+4=
Date:   Fri, 10 May 2019 17:50:51 +0200
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
Subject: Re: [PATCH 5.0 00/95] 5.0.15-stable review
Message-ID: <20190510155051.GC2209@kroah.com>
References: <20190509181309.180685671@linuxfoundation.org>
 <CA+G9fYvKNb-WD+0govE2NWzjHisdJXiRRioTQGZKHP0gvO9WKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYvKNb-WD+0govE2NWzjHisdJXiRRioTQGZKHP0gvO9WKw@mail.gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 10, 2019 at 12:06:07PM +0530, Naresh Kamboju wrote:
> On Fri, 10 May 2019 at 00:21, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.0.15 release.
> > There are 95 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat 11 May 2019 06:11:22 PM UTC.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.0.15-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.0.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> >
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.

Thanks for testing 4 of these (no 5.1?) and letting me know.

greg k-h
