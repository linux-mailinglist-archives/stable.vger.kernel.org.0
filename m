Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCC35323815
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 08:50:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231880AbhBXHue (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 02:50:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:57146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233695AbhBXHuV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 02:50:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85BB264ECB;
        Wed, 24 Feb 2021 07:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614152980;
        bh=SEbKfXxCR6DNQ4kVpaNjbe58/pQSEVJrjdf2buv8r1U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Q7tmumvu48/NochGEipuz2vmyPlweksbrbHYaKUQ/kk2mTODGYr8aMNsmLh3m/n96
         M1rXy2eF07f4ZRRQwc5fPOa5G67R4nKmdTNUx/SPvCeQnpBV+OuYW2obdDhOg9tfRf
         LLCHXFCnej97JroqeenCBpUyxNH1kzL8nk+jP+/I=
Date:   Wed, 24 Feb 2021 08:49:37 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.11 00/12] 5.11.1-rc1 review
Message-ID: <YDYFEYOs0RYIjOnc@kroah.com>
References: <20210222121013.586597942@linuxfoundation.org>
 <9edd3b90-aa95-379f-01b1-ccbb3afec6ce@linuxfoundation.org>
 <6359a822-c0b2-75f7-40e3-c0c7bf002e3f@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6359a822-c0b2-75f7-40e3-c0c7bf002e3f@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 23, 2021 at 05:12:56PM -0700, Shuah Khan wrote:
> On 2/23/21 2:05 PM, Shuah Khan wrote:
> > On 2/22/21 5:12 AM, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.11.1 release.
> > > There are 12 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Wed, 24 Feb 2021 12:07:46 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > >     https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.1-rc1.gz
> > > 
> > > or in the git tree and branch at:
> > >     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> > > linux-5.11.y
> > > and the diffstat can be found below.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > > 
> > 
> > Compiled and booted on my test system. No dmesg regressions.
> > 
> > I made some progress on the drm/amdgpu display and kepboard
> > problem.
> > 
> > My system has
> >   amdgpu: ATOM BIOS: 113-RENOIR-026
> > 
> > I narrowed it down to the following as a possible lead to
> > start looking:
> > amdgpu 0000:0b:00.0: [drm] Cannot find any crtc or sizes
> > 
> 
> It is resolved now. A hot-unplugged/plugged the HDMI cable which
> triggered reset sequence. There might be link to  AMD_DC_HDCP
> support, amdgpu_dm_atomic_commit changes that went into 5.10 and
> this behavior.
> 
> I am basing this on not seeing the problem on Linux 5.4 and until
> Linux 5.10. In any case, I wish I know more, but life is back to
> normal now.

Great, thanks for testing and tracking this down.

greg k-h
