Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99A6726BD03
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 08:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbgIPG2C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 02:28:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:46866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726140AbgIPG2C (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Sep 2020 02:28:02 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1947206A4;
        Wed, 16 Sep 2020 06:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600237681;
        bh=ebK2N6SDuTxooVxF0/qzEYFcYRAy7jX4uvQFnm0puww=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=sjXpvi8jueOKby6OBVPuBaMaVJECIwDWZwgqaMaMw95Q0iuYYWz3hNTcwmstco6we
         FTDlZQGeQ9DgE5q5gbtmyB3mN/2MeOUMBm7dmPpTOigRAWwkx2MSEnwWV++KAcoM5K
         5Sp7Kbset6GUiV7u1D2sEcdirnf/X6xofs9FzYCE=
Date:   Wed, 16 Sep 2020 08:27:50 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, ben.hutchings@codethink.co.uk,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net,
        Jonathan Marek <jonathan@marek.ca>
Subject: Re: [PATCH 5.4 000/130] 5.4.66-rc2 review
Message-ID: <20200916062750.GG142621@kroah.com>
References: <20200915164455.372746145@linuxfoundation.org>
 <20200915201732.4474qpgnxwshanpw@nuc.therub.org>
 <20200916003117.GF2431@sasha-vm>
 <20200916015854.inqx3u2ovzhq45ou@nuc.therub.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200916015854.inqx3u2ovzhq45ou@nuc.therub.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 15, 2020 at 08:58:54PM -0500, Dan Rue wrote:
> On Tue, Sep 15, 2020 at 08:31:17PM -0400, Sasha Levin wrote:
> > On Tue, Sep 15, 2020 at 03:17:32PM -0500, Dan Rue wrote:
> > > On Tue, Sep 15, 2020 at 06:45:55PM +0200, Greg Kroah-Hartman wrote:
> > > > This is the start of the stable review cycle for the 5.4.66 release.
> > > > There are 130 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > > 
> > > > Responses should be made by Thu, 17 Sep 2020 16:44:19 +0000.
> > > > Anything received after that time might be too late.
> > > > 
> > > > The whole patch series can be found in one patch at:
> > > > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.66-rc2.gz
> > > > or in the git tree and branch at:
> > > > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > > > and the diffstat can be found below.
> > > > 
> > > > thanks,
> > > > 
> > > > greg k-h
> > > > 
> > > > -------------
> > > > Pseudo-Shortlog of commits:
> > > > 
> > > > Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > >     Linux 5.4.66-rc2
> > > > 
> > > > Jordan Crouse <jcrouse@codeaurora.org>
> > > >     drm/msm: Disable the RPTR shadow
> > > > 
> > > > Jonathan Marek <jonathan@marek.ca>
> > > >     drm/msm/a6xx: update a6xx_hw_init for A640 and A650
> > > 
> > > This one ("drm/msm/a6xx: update a6xx_hw_init for A640 and A650") is
> > > still causing builds to fail on arm and arm64.
> > 
> > I've dropped it, thanks!
> 
> Could you push it? 😊

Will go do so in a minute...

thanks,

greg k-h
