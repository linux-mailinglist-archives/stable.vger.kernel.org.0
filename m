Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ABE62911AE
	for <lists+stable@lfdr.de>; Sat, 17 Oct 2020 13:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437541AbgJQLdy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Oct 2020 07:33:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:55366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437477AbgJQLdy (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 17 Oct 2020 07:33:54 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7E95206E5;
        Sat, 17 Oct 2020 11:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602934434;
        bh=Ijejz0IbKLsBWc0IaCVJ2POo44GMntMKOVDff+u8Ou4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2XptrUE7VAOKQ+e2zX0vB5b9w66GYk/GjBGWDhqhUROzRnQJF/bESUq05NgRcBbhz
         oTepXQ7847g97keVQ800c4A8Emfdw2E2nGxfkT6U1p8oPAM37yCSgMuOrMkd/+NOIa
         LP8zRe6t6cxucI/8Wm6nHEnp1oD6lxG07yXu1jAQ=
Date:   Sat, 17 Oct 2020 13:34:44 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 5.9 00/15] 5.9.1-rc1 review
Message-ID: <20201017113444.GD2978968@kroah.com>
References: <20201016090437.170032996@linuxfoundation.org>
 <CA+G9fYuEpbTX3_hjeGhfue49a051i3iuzdKfFQ3YGpy86vCZnQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYuEpbTX3_hjeGhfue49a051i3iuzdKfFQ3YGpy86vCZnQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Oct 17, 2020 at 12:33:06AM +0530, Naresh Kamboju wrote:
> On Fri, 16 Oct 2020 at 14:42, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.9.1 release.
> > There are 15 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sun, 18 Oct 2020 09:04:25 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.9.1-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.9.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> >
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.
> 
> Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Thanks for testing all of these so quickly and letting me know.

greg k-h
