Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1D147A405
	for <lists+stable@lfdr.de>; Tue, 30 Jul 2019 11:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730211AbfG3JZs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jul 2019 05:25:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:59124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728824AbfG3JZs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Jul 2019 05:25:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C95D220679;
        Tue, 30 Jul 2019 09:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564478745;
        bh=bWa7o3DpbgFsj7vcewJBghXmSWWR025QOoI9mCN0rl4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IOSbxYsUOWC+FNQvLQjL1Ul+m0sjUufIuJ0z4OciHQ0HQ7uhmAP3kUkL+yv755HNS
         Q6tHhL7JvNBtPCcI+w+K/bRXAkt+u8ua/Tvkx8xVIwb4wGYP531wPmX0FJh/+J7nX6
         FpeT5nFtIAKVOy/EFFT3EAoWOZRVRZrNvqeVJiis=
Date:   Tue, 30 Jul 2019 11:25:43 +0200
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
Subject: Re: [PATCH 5.2 000/215] 5.2.5-stable review
Message-ID: <20190730092543.GA14034@kroah.com>
References: <20190729190739.971253303@linuxfoundation.org>
 <CA+G9fYvpvFXfoiaiaKTgTVggvEi--xFS=4y=R9a4+Xw1Havb9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYvpvFXfoiaiaKTgTVggvEi--xFS=4y=R9a4+Xw1Havb9w@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 30, 2019 at 02:48:15PM +0530, Naresh Kamboju wrote:
> On Tue, 30 Jul 2019 at 01:16, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.2.5 release.
> > There are 215 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed 31 Jul 2019 07:05:01 PM UTC.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.5-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.2.y
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
