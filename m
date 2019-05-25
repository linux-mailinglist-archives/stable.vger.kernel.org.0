Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD5162A533
	for <lists+stable@lfdr.de>; Sat, 25 May 2019 18:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbfEYQHW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 May 2019 12:07:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:35602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727078AbfEYQHW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 25 May 2019 12:07:22 -0400
Received: from localhost (unknown [62.129.28.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 805F320879;
        Sat, 25 May 2019 16:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558800442;
        bh=6kkHhphK43SOTA/X5v5OL8mboRaL39VABoDkJKgD44o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fR6it+lMarvUo8jkpM8uyvsnaU0ATqO0XHptbuD4kBsE1iRriFa8Mqw4Zu+wHylZG
         lT6P0g/zeYaUL6jMiaJDNSJ1I60aQONoVJGFBOXcHbnDG7jhDJNFjCW/uHY/RWZFPJ
         LFa0V4kHUW155g+c+qJVjr0x/DGXEUeTG10vqk+w=
Date:   Sat, 25 May 2019 18:07:19 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Kevin Hilman <khilman@baylibre.com>
Cc:     "kernelci.org bot" <bot@kernelci.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.1 000/122] 5.1.5-stable review
Message-ID: <20190525160719.GB26722@kroah.com>
References: <20190523181705.091418060@linuxfoundation.org>
 <5ce727ee.1c69fb81.fbeca.2a40@mx.google.com>
 <7h7eaf1vmr.fsf@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7h7eaf1vmr.fsf@baylibre.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 24, 2019 at 12:48:44PM -0700, Kevin Hilman wrote:
> "kernelci.org bot" <bot@kernelci.org> writes:
> 
> > stable-rc/linux-5.1.y boot: 138 boots: 1 failed, 121 passed with 14 offline, 2 untried/unknown (v5.1.4-123-gad8ad5ad6200)
> >
> > Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux-5.1.y/kernel/v5.1.4-123-gad8ad5ad6200/
> > Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y/kernel/v5.1.4-123-gad8ad5ad6200/
> >
> > Tree: stable-rc
> > Branch: linux-5.1.y
> > Git Describe: v5.1.4-123-gad8ad5ad6200
> > Git Commit: ad8ad5ad6200a933bc774415620bb31dd8b2da66
> > Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> > Tested: 76 unique boards, 24 SoC families, 14 builds out of 209
> >
> > Boot Failure Detected:
> >
> > arm:
> >     multi_v7_defconfig:
> >         gcc-8:
> >             bcm4708-smartrg-sr400ac: 1 failed lab
> 
> FYI, this one has a fix submitted to mainline (and tagged for stable)
> this week.

Great, thanks for following up on this.

greg k-h
