Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B692A33E93
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 07:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbfFDFtr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 01:49:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:38950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726530AbfFDFtr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jun 2019 01:49:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A16732064A;
        Tue,  4 Jun 2019 05:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559627386;
        bh=Cp1M7M5lwY2172OZCuc8q6Bam/oQDv/B2nA08ZbydRg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i9LyBIRv7aF+DPTixovlNvUtojp+B1dBAaE4w+88LGUgHfmamuvHb1b0WM4hE5YFB
         V0rRkR1yDWQgfueaEPbRq7LZeAGfGa3SVEbCl8UF04avnNfgilADt3Rud0/Ao9fQ8H
         oBA+C0h3vkG5swz7rAoTEPbU9gkQN8/SryEXifgM=
Date:   Tue, 4 Jun 2019 07:49:43 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Kevin Hilman <khilman@baylibre.com>
Cc:     "kernelci.org bot" <bot@kernelci.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.1 00/40] 5.1.7-stable review
Message-ID: <20190604054943.GB16504@kroah.com>
References: <20190603090522.617635820@linuxfoundation.org>
 <5cf53378.1c69fb81.9dd1b.494b@mx.google.com>
 <7hmuiyjzg8.fsf@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7hmuiyjzg8.fsf@baylibre.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 03, 2019 at 11:28:23AM -0700, Kevin Hilman wrote:
> "kernelci.org bot" <bot@kernelci.org> writes:
> 
> > stable-rc/linux-5.1.y boot: 132 boots: 1 failed, 131 passed (v5.1.6-41-ge674455b9242)
> >
> > Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux-5.1.y/kernel/v5.1.6-41-ge674455b9242/
> > Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y/kernel/v5.1.6-41-ge674455b9242/
> >
> > Tree: stable-rc
> > Branch: linux-5.1.y
> > Git Describe: v5.1.6-41-ge674455b9242
> > Git Commit: e674455b924207b06e6527d961a4b617cf13e7a9
> > Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> > Tested: 73 unique boards, 23 SoC families, 14 builds out of 209
> >
> > Boot Failure Detected:
> >
> > arm:
> >     multi_v7_defconfig:
> >         gcc-8:
> >             bcm4708-smartrg-sr400ac: 1 failed lab
> 
> FYI, this one has been fixed and marked with Fixes tag[1], but it
> appears the patch hasn't yet landed in mainline.

A Fixes: tag will not guarantee it will make it into a stable release.
It might, a month or so later, if we get bored.  You should always use a
 Cc: stable@ tag instead, as that is the documented way to ensure that
the patch makes it into a stable release.

Once this hits Linus's tree, send me the SHA1 and I will be glad to
queue it up.

thanks,

greg k-h
