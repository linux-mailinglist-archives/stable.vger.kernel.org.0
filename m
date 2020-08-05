Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01C6923C95B
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 11:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728423AbgHEJii (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 05:38:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:60936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728416AbgHEJfX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Aug 2020 05:35:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E15A92067C;
        Wed,  5 Aug 2020 09:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596620123;
        bh=sRK1VT2n7iXkftZGPejCEcTo2BNKyrAMP+gaG0CRD5I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tHkbuu8xPAEJ9ciXcq6XPAI0aM13ahh4h/kEpFpBy0p+eK0fJVFm5wLgIloAEdQE2
         27qfosrKd9MMF2R6TAXsqZz2MT5QRiWoMHtZOnA9NvLXziKN7B/ku9AXwqMdHo9jsj
         cLUKDidhRZV8Qn3MVqeP3gbFZtlYubJx5ATAULWc=
Date:   Wed, 5 Aug 2020 11:35:41 +0200
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
Subject: Re: [PATCH 5.7 000/116] 5.7.13-rc3 review
Message-ID: <20200805093541.GC1388764@kroah.com>
References: <20200804085233.484875373@linuxfoundation.org>
 <CA+G9fYsPq80QDQYbkCQPwS5DLCZXk7cZR8BeY6VHU4gyWGckwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYsPq80QDQYbkCQPwS5DLCZXk7cZR8BeY6VHU4gyWGckwA@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 05, 2020 at 11:32:56AM +0530, Naresh Kamboju wrote:
> On Tue, 4 Aug 2020 at 14:24, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.7.13 release.
> > There are 116 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 06 Aug 2020 08:51:59 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.13-rc3.gz
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

Thanks for testing all of these and letting me know.

greg k-h
