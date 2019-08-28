Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F7D5A06A0
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 17:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbfH1Pwz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Aug 2019 11:52:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:37416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbfH1Pwz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Aug 2019 11:52:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D0AC208CB;
        Wed, 28 Aug 2019 15:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567007574;
        bh=SsZ4iXPbYBtXmvPRwgJjHWlXD/QfM0EJ6Lmi78cXE54=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=HM3+ncI/+us9wCrrIWt43S/Zyt+5GHVwhWFrGX47cI1UC0o+RF9pA/xwqNfgiKAdj
         mBF3Luj3jWiM0OSjIfD7pjX2YQ4+t9bQyMcr4BbWWaL36nkLZwfahVsJ6dr8OpeRIA
         oZcV6EA1+thz+eMElkViG8rIvaIT0Y1AiXKjKXz0=
Date:   Wed, 28 Aug 2019 17:52:52 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>
Subject: Re: [PATCH 5.2 000/162] 5.2.11-stable review
Message-ID: <20190828155252.GA3803@kroah.com>
References: <20190827072738.093683223@linuxfoundation.org>
 <CA+G9fYtmHsr8XWvmSLy9QKvF37KfZ4v+T1VnRy2uhpE0HB4Ggg@mail.gmail.com>
 <20190828151608.GC9673@kroah.com>
 <20190828154718.nesaolp7gfxxh5o5@xps.therub.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190828154718.nesaolp7gfxxh5o5@xps.therub.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 28, 2019 at 10:47:18AM -0500, Dan Rue wrote:
> On Wed, Aug 28, 2019 at 05:16:08PM +0200, Greg Kroah-Hartman wrote:
> > On Wed, Aug 28, 2019 at 10:30:09AM +0530, Naresh Kamboju wrote:
> > > On Tue, 27 Aug 2019 at 13:30, Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > This is the start of the stable review cycle for the 5.2.11 release.
> > > > There are 162 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > >
> > > > Responses should be made by Thu 29 Aug 2019 07:25:02 AM UTC.
> > > > Anything received after that time might be too late.
> > > >
> > > > The whole patch series can be found in one patch at:
> > > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.11-rc1.gz
> > > > or in the git tree and branch at:
> > > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.2.y
> > > > and the diffstat can be found below.
> > > >
> > > > thanks,
> > > >
> > > > greg k-h
> > > 
> > > Results from Linaro’s test farm.
> > > No regressions on arm64, arm, x86_64, and i386.
> > 
> > Thanks for testing all of these and letting us know.
> > 
> > Also, how did you all not catch the things that the redhat ci system was
> > catching that caused us to add another networking aptch?
> 
> Hi Greg -
> 
> I'll follow up with them off list. That said, I expect different CI
> setups to find different issues - that's the point, after all. It would
> be bad if we all ran the exact same things, and found the exact same
> things, because then we'd also miss the exact same things. In the macro
> sense, there is a lot to test, and I would rather see CI teams go after
> areas that are weak, rather than areas that are well covered.

I totally agree, but here we actually have a known failure (for once!)
so it would be nice to see why the very large test suite that you all
run missed this.

thanks,

greg k-h
