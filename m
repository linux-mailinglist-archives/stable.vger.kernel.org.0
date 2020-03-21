Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DABFC18DE6B
	for <lists+stable@lfdr.de>; Sat, 21 Mar 2020 08:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728143AbgCUHM2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Mar 2020 03:12:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:41778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728132AbgCUHM2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 21 Mar 2020 03:12:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5165120739;
        Sat, 21 Mar 2020 07:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584774747;
        bh=o5rAMtBdROjKvqV3s/BSssTNMhXLD4MSQZT00wKQUtA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JLCZz3W7wCIJU/TFomPT1r3iUHmCNjNihLpdfYLJKVKI1uLm/TpkYCWXiizW7J+va
         VVxlDyy23dCq02WNr52YGbvkXls5A0HZs70cEvh0kUcuQEePkbA7gFeKpkFdw9tA0H
         jCACXq7hro/RHvzjX0Csyx6sLBqa8XE3jf9k3XMg=
Date:   Sat, 21 Mar 2020 08:12:25 +0100
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
Subject: Re: [PATCH 4.4 00/93] 4.4.217-rc1 review
Message-ID: <20200321071225.GE850676@kroah.com>
References: <20200319123924.795019515@linuxfoundation.org>
 <CA+G9fYvJEAHcfqr2NrGdxdkW2JJEUHRxmGF0uY1xTevW-jEAww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYvJEAHcfqr2NrGdxdkW2JJEUHRxmGF0uY1xTevW-jEAww@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 21, 2020 at 09:31:32AM +0530, Naresh Kamboju wrote:
> On Thu, 19 Mar 2020 at 18:35, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 4.4.217 release.
> > There are 93 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat, 21 Mar 2020 12:37:04 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.217-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.

Thanks for testing all of these and letting me kow.

greg k-h
