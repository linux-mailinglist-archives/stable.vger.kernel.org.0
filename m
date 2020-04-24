Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57F5F1B7055
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 11:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbgDXJNB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 05:13:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:49654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726298AbgDXJNB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Apr 2020 05:13:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F94C20724;
        Fri, 24 Apr 2020 09:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587719581;
        bh=VUbZ3LRQI5qQroc1jTBzwNv73zK9D1/8U6/W3QlH2R8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z81J7org7Q+wFxEMCH7BLItFnZ+UHSE+ESvdoF16gTtSjycrF7+CaeCT8eL/sbv+N
         ubXWLJ+bS5ACehBarUWZ8RnEhLhyL219/nufzQuw88R76jMEETgXqIwvorhvJ/w9xL
         a9nf9Lg1HliGI6H2e8lO5/v1K4HxhS8ygXWXN/dU=
Date:   Fri, 24 Apr 2020 11:12:58 +0200
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
Subject: Re: [PATCH 5.6 000/166] 5.6.7-rc1 review
Message-ID: <20200424091258.GB359097@kroah.com>
References: <20200422095047.669225321@linuxfoundation.org>
 <CA+G9fYt+DmKn-h_XoG1TseqP7J5BxgrwQPNqyaL+htn40qLo9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYt+DmKn-h_XoG1TseqP7J5BxgrwQPNqyaL+htn40qLo9w@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 23, 2020 at 01:16:22PM +0530, Naresh Kamboju wrote:
> On Wed, 22 Apr 2020 at 15:55, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.6.7 release.
> > There are 166 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri, 24 Apr 2020 09:48:23 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.6.7-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.6.y
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
