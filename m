Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 099711FF79
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 08:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726429AbfEPGV1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 02:21:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:59840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726296AbfEPGV0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 May 2019 02:21:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 850ED20862;
        Thu, 16 May 2019 06:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557987686;
        bh=HlrV4ycJYaKgxVRVxbbwrsz5dVU1yzfML1x5QQyuh+c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Gcmvs1aBFVSlCd8V7iMXbHiZO9pHYXCqXvtXtcoFFCR4p0mPIjNOO1ZGckFj8WGeN
         AYyTIc1Oz+Yb4DqLidTfS/4D3EjuajI1Iygiagw92n7rPYLg/ue9S9sBSwPE/x9QHg
         m4Fhd7Rc56Fa4Pa5JkCv2vzL4rWHhenDtIf4Pgtw=
Date:   Thu, 16 May 2019 08:21:23 +0200
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
Subject: Re: [PATCH 5.1 00/46] 5.1.3-stable review
Message-ID: <20190516062123.GB16818@kroah.com>
References: <20190515090616.670410738@linuxfoundation.org>
 <CA+G9fYuYYDpNTv9B5Y0uc1hAWfjv08EoUMhLFdOwVr6FQQC6Rw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYuYYDpNTv9B5Y0uc1hAWfjv08EoUMhLFdOwVr6FQQC6Rw@mail.gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 16, 2019 at 01:26:41AM +0530, Naresh Kamboju wrote:
> On Wed, 15 May 2019 at 17:04, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.1.3 release.
> > There are 46 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri 17 May 2019 09:04:22 AM UTC.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.3-rc1.gz
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

Wonderful!

Thanks for testing all of these and letting me know.

greg k-h
