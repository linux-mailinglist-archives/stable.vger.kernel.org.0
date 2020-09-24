Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE860277762
	for <lists+stable@lfdr.de>; Thu, 24 Sep 2020 19:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727136AbgIXRFf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Sep 2020 13:05:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:55226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726458AbgIXRFf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 24 Sep 2020 13:05:35 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E64321D7F;
        Thu, 24 Sep 2020 17:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600967135;
        bh=lbzalMhqOfvnc6Q+c317/Eg4dQ2olUBHiipwDx79lrQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jB0kPI0sMTZvPOAqfFRnU+RbUGBE7Z2/gw54is9m873u08p83sZmkXuucfwJTiJcm
         atF7u4uY2S3cVEw8k5PVkVO43u41CVZxySme+pQUGkwQOts4J9WAJhj/+QWpjfTptn
         BCHFdia1dT6HMd/SkG9jytVF16biJ51m9pwagRco=
Date:   Thu, 24 Sep 2020 19:05:51 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     sashal@kernel.org, open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        linux- stable <stable@vger.kernel.org>
Subject: Re: [PATCH 5.8 000/118] 5.8.11-rc1 review
Message-ID: <20200924170551.GA1182944@kroah.com>
References: <20200921162036.324813383@linuxfoundation.org>
 <CA+G9fYvt-f_h_6Fr7qo2MDuWbgi4W9QHOMt_eOB3=r+isGV8dQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYvt-f_h_6Fr7qo2MDuWbgi4W9QHOMt_eOB3=r+isGV8dQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 22, 2020 at 10:32:13AM +0530, Naresh Kamboju wrote:
> On Mon, 21 Sep 2020 at 22:14, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.8.11 release.
> > There are 118 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 23 Sep 2020 16:20:12 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.11-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.8.y
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
> Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Thanks for testing all of these and letting me know.

greg k-h
