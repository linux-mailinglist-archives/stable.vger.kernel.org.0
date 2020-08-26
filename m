Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3EE0252AB3
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 11:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728070AbgHZJtr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 05:49:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:48906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727997AbgHZJtq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Aug 2020 05:49:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 193312075E;
        Wed, 26 Aug 2020 09:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598435385;
        bh=JYJ+Y46FS1ZwPvEWPhdO+SM1Aq3byD/lyloKt5oIRNU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LDQYBf05hoLxi7MpEm3q+7QW2BOSZZNQwZAxibdUlL0H/mz5bcBEkIQYkBhr1lPtS
         yEy+1f/zbE3AHuieRDhUU+qV1jAuVPbW/MD5DcbILQk7LHxsImOazhJ/H9NC+EpkiQ
         ZrIXVpECQAXuInXTFQfkvn7zILAGX/BMLaL/J7Cc=
Date:   Wed, 26 Aug 2020 11:50:00 +0200
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
Subject: Re: [PATCH 5.8 000/149] 5.8.4-rc2 review
Message-ID: <20200826095000.GB2047935@kroah.com>
References: <20200824164745.715432380@linuxfoundation.org>
 <CA+G9fYuQ5+7HW_K2GieeAX3jubxqUXADd-7_Sx89ypyAmKUJgw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYuQ5+7HW_K2GieeAX3jubxqUXADd-7_Sx89ypyAmKUJgw@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 25, 2020 at 10:55:58AM +0530, Naresh Kamboju wrote:
> On Mon, 24 Aug 2020 at 22:18, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.8.4 release.
> > There are 149 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 26 Aug 2020 16:47:07 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.4-rc2.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.8.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.
> 

Thanks for testing all of these and letting me know.

greg k-h
