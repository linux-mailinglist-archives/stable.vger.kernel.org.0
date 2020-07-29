Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C84E231B1D
	for <lists+stable@lfdr.de>; Wed, 29 Jul 2020 10:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbgG2IVt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jul 2020 04:21:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:43228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726336AbgG2IVt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 Jul 2020 04:21:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87850206D4;
        Wed, 29 Jul 2020 08:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596010909;
        bh=TCS6rlHqRgKIRSiQN/E3F/x769JXIhynjdK6A3hFFxg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nkhj9P6QcJdooJtvkhepJuWG/1lZR/DRp0HcwwE9rkKXG+C9F1J14XHvXqQL6oug6
         TiFN4UI2HNG5Bq+4Npp6JuDV3zA/dkFhvrsUhuVwJ87tNr2OGzGg8OzX0ttKM6CHUO
         VluWEyZ2etGwF7mkVahdvHIEmB69+Z5MmFkfpQjo=
Date:   Wed, 29 Jul 2020 10:21:40 +0200
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
Subject: Re: [PATCH 4.19 00/86] 4.19.135-rc3 review
Message-ID: <20200729082140.GB529870@kroah.com>
References: <20200728153252.881727078@linuxfoundation.org>
 <CA+G9fYvfC=PVM3HvQCmBZJdaEYGLQ2vjN1r=vL872XTRWW-PaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYvfC=PVM3HvQCmBZJdaEYGLQ2vjN1r=vL872XTRWW-PaA@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 29, 2020 at 07:52:17AM +0530, Naresh Kamboju wrote:
> On Tue, 28 Jul 2020 at 21:21, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 4.19.135 release.
> > There are 86 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 30 Jul 2020 15:32:32 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.135-rc3.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.

Great, glad it's now working.

Thanks for testing all of these and letting me know.

greg k-h
