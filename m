Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB7A3113D51
	for <lists+stable@lfdr.de>; Thu,  5 Dec 2019 09:48:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728991AbfLEIsW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Dec 2019 03:48:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:57816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726032AbfLEIsW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Dec 2019 03:48:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55A77224F8;
        Thu,  5 Dec 2019 08:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575535701;
        bh=nvmdoKn/TI7KsGLRiKbr33Ub6XrfjaXy6E6Z8CeVjJc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QJvVCLlaVznI8M/byNoO9JyuFr1/Um02FzsS1ktr2/OeLriDDo7QlOaIjxELNBkef
         TvCVtC+8o4fQ1UrbA7UOaSbPu4DyxrlWDeCLk4Nhy14hY2YsNOfPoNb3Fk0zmYVEYF
         CU1ucCn4Ke7vP1/iYBWkv/HwOwAvFv10rP8fs2rM=
Date:   Thu, 5 Dec 2019 09:48:19 +0100
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
Subject: Re: [PATCH 4.14 000/209] 4.14.158-stable review
Message-ID: <20191205084819.GB302248@kroah.com>
References: <20191204175321.609072813@linuxfoundation.org>
 <CA+G9fYuMt0GJ87r7xkME4xz6rD2wx-Sn=mFph_7k2Dr_DXCKOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYuMt0GJ87r7xkME4xz6rD2wx-Sn=mFph_7k2Dr_DXCKOQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 05, 2019 at 10:47:43AM +0530, Naresh Kamboju wrote:
> On Wed, 4 Dec 2019 at 23:33, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 4.14.158 release.
> > There are 209 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri, 06 Dec 2019 17:50:10 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.158-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
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
