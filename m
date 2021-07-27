Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4DF3D6DDE
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 07:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234781AbhG0FOO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 01:14:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:40544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234905AbhG0FOO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Jul 2021 01:14:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90145610A1;
        Tue, 27 Jul 2021 05:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627362854;
        bh=8VonUF7E8l/saHVZpJSIFekUDI4ifTMTqmLbaZjJpYc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qcKZuG2FBnQcptn8huoxsu71yn6kSiutOi0+jDMt7kGrCI+gm34uYILWpz0Etxmmc
         6lOKib4dsIvWYdoyCycll9EQD8i18T7ZgZQClZMninq7yA5s7JGNyDyvamnoYTCUQc
         AT2Q0SZLFibZ5YJnjbr7FR4gg9TIFJqBNZZozpmo=
Date:   Tue, 27 Jul 2021 07:13:09 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Stable <stable@vger.kernel.org>, Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5.13 000/223] 5.13.6-rc1 review
Message-ID: <YP+V5cR8aswcin+6@kroah.com>
References: <20210726153846.245305071@linuxfoundation.org>
 <99b34fe9-0f1f-c94f-58d5-cfb43de98d76@linaro.org>
 <CADVatmPpBKtaUtzU+APGvNE_1pqgcmXYovWOqrt8qJkRqLM25w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADVatmPpBKtaUtzU+APGvNE_1pqgcmXYovWOqrt8qJkRqLM25w@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 26, 2021 at 06:05:27PM +0100, Sudip Mukherjee wrote:
> On Mon, Jul 26, 2021 at 5:47 PM Daniel Díaz <daniel.diaz@linaro.org> wrote:
> >
> > Hello!
> >
> > On 7/26/21 10:36 AM, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.13.6 release.
> > > There are 223 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Wed, 28 Jul 2021 15:38:12 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >       https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.6-rc1.gz
> > > or in the git tree and branch at:
> > >       git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> >
> > Build regressions detected across plenty of architectures and configurations:
> 
> I was going to report the same but just noticed that Greg has pushed out -rc2.

I forgot to push it out last night, it's there now, sorry for the delay.

greg k-h
