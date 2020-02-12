Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7502D15AA08
	for <lists+stable@lfdr.de>; Wed, 12 Feb 2020 14:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727662AbgBLNaj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Feb 2020 08:30:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:54072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725887AbgBLNaj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 Feb 2020 08:30:39 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BBBDF20661;
        Wed, 12 Feb 2020 13:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581514237;
        bh=AcjdVVoP0TYLfXTwuTOv4a+GMYgqOI6mbOrzqIgvPwQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UEKv5Dh3icrofal9goHcw6Po2lotjshH3+8Q27C5kqUZ+iFD0WHU1Zkv3+lHPCV6j
         YrfAjvv14HDIpqdhXBGPAVmsKtNYm7P2Pf70C5s/uonaLejpH8DTZjz6IM4Dl8iPe5
         hnvxqzbJKBCGxkpX60TE3UqqldzjceRecimhZGJY=
Date:   Wed, 12 Feb 2020 05:30:37 -0800
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jeffrin Jose <jeffrin@rajagiritech.edu.in>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/309] 5.4.19-stable review
Message-ID: <20200212133037.GA1791775@kroah.com>
References: <20200210122406.106356946@linuxfoundation.org>
 <20200212073531.GA5184@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200212073531.GA5184@debian>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 12, 2020 at 01:05:31PM +0530, Jeffrin Jose wrote:
> On Mon, Feb 10, 2020 at 04:29:16AM -0800, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.19 release.
> > There are 309 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 12 Feb 2020 12:18:57 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.19-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> 
> hello ,
> 
> compiled and booted 5.4.19-rc1+ . No new error according to "sudo dmesg -l err"

Thanks for testing, there shouldn't be a need to run 'sudo' for that
dmesg command :)

greg k-h
