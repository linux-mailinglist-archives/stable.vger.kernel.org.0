Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F229A23DF22
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 19:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728365AbgHFRih (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Aug 2020 13:38:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:55152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729819AbgHFRbn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Aug 2020 13:31:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5773723109;
        Thu,  6 Aug 2020 12:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596717854;
        bh=3ou9omZc4Nra39WBs2vjwo4o71UySqGYORcZDy+9Of0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=muSooC1zKf0fyERxc69b+JeSq4moOoQrnp+6V7oRuGvIV4DKdpmNaoqtI0FshKW1E
         YkZO3GZ/vgWLO077nzlSpOTNBJdd5BpwMfmpA94C6+S+tGeHsWX3ri8cnVxpyqsLJC
         5ZbvmTyOmK/We90L/Gu9I0vZ05qbOzFxCpacBz4A=
Date:   Thu, 6 Aug 2020 14:44:28 +0200
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
Subject: Re: [PATCH 5.7 0/7] 5.7.14-rc2 review
Message-ID: <20200806124428.GC2876088@kroah.com>
References: <20200805195916.183355405@linuxfoundation.org>
 <CA+G9fYs-vNeH=BCbFZAA28-C=dE+iajWEF+0vvgZMwr=yw-5xA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYs-vNeH=BCbFZAA28-C=dE+iajWEF+0vvgZMwr=yw-5xA@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 06, 2020 at 02:16:26PM +0530, Naresh Kamboju wrote:
> On Thu, 6 Aug 2020 at 01:29, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.7.14 release.
> > There are 7 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri, 07 Aug 2020 19:59:06 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.14-rc2.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.7.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.

Great, thanks for testing all of these and letting me know.

greg k-h
