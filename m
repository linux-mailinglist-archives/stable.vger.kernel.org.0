Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D306710D2BA
	for <lists+stable@lfdr.de>; Fri, 29 Nov 2019 09:53:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbfK2IxB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Nov 2019 03:53:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:54764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726808AbfK2IxB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 29 Nov 2019 03:53:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A13D5217BA;
        Fri, 29 Nov 2019 08:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575017580;
        bh=rfLlSLEgtmmMX1xKzGEwXMRDmRX90YsWzTqfkUgFeRM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J1y0d0IEoNAVMPTrlMOtFz+ja34sii0Xpt33KFe9FLiMiTiUXUM618C2DwbMxtHU0
         s9QvNVi8x6hG9bdIamojKGCXAIRkNMdCwnTmbcbNd8EYYmPSACq8Nazy/wdlWlynJv
         69+UUYW3Ac9vkTGgnQgx+OJMUR9Iz3sPBVg6KYjA=
Date:   Fri, 29 Nov 2019 09:52:57 +0100
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
Subject: Re: [PATCH 5.4 00/66] 5.4.1-stable review
Message-ID: <20191129085257.GD3584430@kroah.com>
References: <20191127202632.536277063@linuxfoundation.org>
 <CA+G9fYt8UCoKYnemrGFX4btoNukF0FFTsppzePKDbGbV5sQrtg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYt8UCoKYnemrGFX4btoNukF0FFTsppzePKDbGbV5sQrtg@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 28, 2019 at 02:26:27PM +0530, Naresh Kamboju wrote:
> On Thu, 28 Nov 2019 at 02:47, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.4.1 release.
> > There are 66 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri, 29 Nov 2019 20:18:09 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.1-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> >
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.

Great, thanks for testing and letting me know.

greg k-h
