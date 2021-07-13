Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CECD3C6B26
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 09:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234121AbhGMHXg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Jul 2021 03:23:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:59880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234167AbhGMHXf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Jul 2021 03:23:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D033361260;
        Tue, 13 Jul 2021 07:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626160846;
        bh=8wlSDI4tTgOSlWOwnMmrSjP4tB1ejVKX9pbMdywe+Kw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gDViQvdS8I2wWhc4QaTse9j4ADbx3w9UlEUu+6jU3W+HPK4c+KvQFbviRc/HNlo/h
         f3WLy2SpKUvK5O7/2CvnBI//Gx13NNvVKG9MEwIWuiAr7G+rz/seiV+mPSFQUs94Sh
         C3IvLw5Hr1zucQAn3ENiMJXlnWObkmjt9eGna2q8=
Date:   Tue, 13 Jul 2021 09:20:43 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Hugh Dickins <hughd@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org
Subject: Re: 5.13.2-rc and others have many not for stable
Message-ID: <YO0+y+verYM2Hrts@kroah.com>
References: <2b1b798e-8449-11e-e2a1-daf6a341409b@google.com>
 <YO0zXVX9Bx9QZCTs@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YO0zXVX9Bx9QZCTs@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 13, 2021 at 08:31:57AM +0200, Greg Kroah-Hartman wrote:
> On Mon, Jul 12, 2021 at 10:55:01PM -0700, Hugh Dickins wrote:
> > On Mon, 12 Jul 2021, Greg Kroah-Hartman wrote:
> > 
> > > This is the start of the stable review cycle for the 5.13.2 release.
> > > There are 800 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Wed, 14 Jul 2021 06:02:46 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.2-rc1.gz
> > > or in the git tree and branch at:
> > > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
> > > and the diffstat can be found below.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > > 
> > > -------------
> > > Pseudo-Shortlog of commits:
> > > 
> > > Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > >     Linux 5.13.2-rc1
> > 
> > Hi Greg,
> > 
> > Sorry to be making waves, but please, what's up with the 5.13.2-rc,
> > 5.12.17-rc, 5.10.50-rc, 5.4.132-rc stable release candidates?
> 
> They show the problem that we currently have where maintainers wait at
> the end of the -rc cycle and keep valid fixes from being sent to Linus.
> They "bunch up" and come out only in -rc1 and so the first few stable
> releases after -rc1 comes out is huge.  It's been happening for the past
> few years and only getting worse.  These stable releases are proof of
> that, the 5.13.2-rc release was the largest we have ever done and it
> broke one of my scripts because of it :(
> 
> I know personally I do this for my subsystems, having fixes that are
> trivial things batch up for -rc1 just because they are generally not
> worth getting into -final.  But that is not the case with many other
> subsystems as you can see by these huge patch sequences.

Hm, maybe it really isn't a "problem" here, as the % overall is still
quite low of patches with fixes: and cc: stable on them compared to the
overall number of commits going in for -rc1 vs. later -rcX releases.

So it's just what it is, large numbers of changes happening, small % of
them are needed to be backported.  If someone wanted to, odds are they
could get a master's thesis out of analyzing all of this stuff :)

thanks,

greg k-h
