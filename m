Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92886DB85B
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 22:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437255AbfJQUfc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Oct 2019 16:35:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:56582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391182AbfJQUfc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Oct 2019 16:35:32 -0400
Received: from localhost (unknown [104.132.0.109])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8587120872;
        Thu, 17 Oct 2019 20:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571344531;
        bh=NwiZ/AX6sGMeBkyWgJppvW4FId3fDKSIv1el/x66+bY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sWROEH/qmmfRnJJSunjulu7xyyJB0d2EMJj88WlM7jphBGEhUYrpGgwXm6NBtIrNF
         IWFeMSyNBblzRqWLEIpOAO/rRvGgrj2o8PYRchrlCXo9oQXyQ3YWSlZiPsiFn2v4Wz
         kWMNcY+mLmZ5OVUbrIPHol4FgRBzXP8pEx86xH7c=
Date:   Thu, 17 Oct 2019 13:35:30 -0700
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
Subject: Re: [PATCH 5.3 000/112] 5.3.7-stable review
Message-ID: <20191017203530.GA1105066@kroah.com>
References: <20191016214844.038848564@linuxfoundation.org>
 <CA+G9fYsV=wVPaF4Uwbtddb1753Bfqz5EDhTzV2A8CX576JNqYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYsV=wVPaF4Uwbtddb1753Bfqz5EDhTzV2A8CX576JNqYA@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 17, 2019 at 10:51:15PM +0530, Naresh Kamboju wrote:
> On Thu, 17 Oct 2019 at 03:29, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.3.7 release.
> > There are 112 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri 18 Oct 2019 09:43:41 PM UTC.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.7-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.3.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.

Great, thanks for testing all of these and letting me know.

greg k-h
