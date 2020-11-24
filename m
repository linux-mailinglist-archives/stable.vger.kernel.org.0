Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3B0E2C31F6
	for <lists+stable@lfdr.de>; Tue, 24 Nov 2020 21:29:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731059AbgKXU2u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Nov 2020 15:28:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:43254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726631AbgKXU2t (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Nov 2020 15:28:49 -0500
Received: from localhost (82-217-20-185.cable.dynamic.v4.ziggo.nl [82.217.20.185])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C65AB20678;
        Tue, 24 Nov 2020 20:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606249729;
        bh=q4n6b3EZ69vbVGXxe0Kg1aJMnwwDL2ELyWBvL2w2+tg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NSVFrGy6lHGIEswzIfk1ZyONk6m+YvCZjhXu5GcVtBgS4df9UxSMAkCzu3ixN6XHT
         vbhPft+48YQ8zUEW6kyo2+wmH/hJu9f89LrmXZQTZPRhiJFMQZ2ft3N5/ggyriTqb/
         YHspL/4j/Gi90FmqupyK2WbxvAJbKL3LEQduDtY8=
Date:   Tue, 24 Nov 2020 21:28:47 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        linux-stable <stable@vger.kernel.org>
Subject: Re: [PATCH 5.9 000/252] 5.9.11-rc1 review
Message-ID: <X71s/0vcxSuYRZ+3@kroah.com>
References: <20201123121835.580259631@linuxfoundation.org>
 <CA+G9fYtOd8pajJ4aDYjMqScyfd_VCtvudzhKzPybuNiJOWSKJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYtOd8pajJ4aDYjMqScyfd_VCtvudzhKzPybuNiJOWSKJQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 24, 2020 at 11:41:57AM +0530, Naresh Kamboju wrote:
> On Mon, 23 Nov 2020 at 18:14, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.9.11 release.
> > There are 252 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 25 Nov 2020 12:17:50 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.9.11-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.9.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.
> 
> Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Thanks for testing and letting me know.

greg k-h
