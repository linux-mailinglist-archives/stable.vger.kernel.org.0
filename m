Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD1625DA8
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 07:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728346AbfEVFf3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 01:35:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:33504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725801AbfEVFf3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 01:35:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CE5620862;
        Wed, 22 May 2019 05:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558503328;
        bh=3Zz3CfQ6lA6uwqZSH/IUmdW4bO0v9073FkSJh3kwkjg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dFrJCyI8CdXFXJTs9/pwzS0yZrPs6mcrW9yTl4lnlz8ys9H88BIY5z+HZBc1WKvXP
         C7384Kvg8cuCfISjGkzWaqcfk2v8idSpA7QOQiQm9mB086LNNmHBBrjJdH1ZohxS1x
         4I5xSZ9vgYliVqtw5B+HlP4ZdKAU7Q85CDlK+HQQ=
Date:   Wed, 22 May 2019 07:35:26 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 5.1 000/128] 5.1.4-stable review
Message-ID: <20190522053526.GB16977@kroah.com>
References: <20190520115249.449077487@linuxfoundation.org>
 <CA+G9fYsUvkgLUnb5AcZBUqd_FMo5JSH-RHEWOqTNRdwKqsrnSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYsUvkgLUnb5AcZBUqd_FMo5JSH-RHEWOqTNRdwKqsrnSw@mail.gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 22, 2019 at 10:33:06AM +0530, Naresh Kamboju wrote:
> On Mon, 20 May 2019 at 18:03, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.1.4 release.
> > There are 128 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed 22 May 2019 11:50:41 AM UTC.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.4-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> >
> 
> 5.1.4-rc2 report,
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.

Wonderful, thanks for testing all of these again, and letting me know.

greg k-h
