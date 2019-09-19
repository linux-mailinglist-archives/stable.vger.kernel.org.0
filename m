Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3CB8B733A
	for <lists+stable@lfdr.de>; Thu, 19 Sep 2019 08:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388284AbfISGhO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 02:37:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:35756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388253AbfISGhO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 02:37:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9C2D21924;
        Thu, 19 Sep 2019 06:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568875033;
        bh=PplNxJHEBIUulTCA3xqY59zCBR7bWqHKud3noDEgPX8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dsMlTpUmwc83E2Z9HS+SWVRI6VLkt5AK0gBI682DqjbUn6nua/k6SIzBhZTQT1L9v
         68SZj3zYpEVUpA69SsiLrIUxLn21ZzDRa5BWKngvq3RpFAwG6m51/yCnCXiIgc4E6T
         2BuZypWYbWHBY5oMcetjwhs/QQ+BTL956GnMqKe4=
Date:   Thu, 19 Sep 2019 08:37:10 +0200
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
Subject: Re: [PATCH 5.2 00/85] 5.2.16-stable review
Message-ID: <20190919063710.GC2069346@kroah.com>
References: <20190918061234.107708857@linuxfoundation.org>
 <CA+G9fYtke31TKiWz3UBmUT5EgUYcB4g47VURxvrWSz-jtF+=Gg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYtke31TKiWz3UBmUT5EgUYcB4g47VURxvrWSz-jtF+=Gg@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 18, 2019 at 08:47:06PM +0530, Naresh Kamboju wrote:
> On Wed, 18 Sep 2019 at 11:56, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.2.16 release.
> > There are 85 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri 20 Sep 2019 06:09:47 AM UTC.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.16-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.2.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> >
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.

Great, thanks for testing all of these and letting me know.

greg k-h
