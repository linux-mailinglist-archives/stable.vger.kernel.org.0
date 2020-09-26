Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6055D279A74
	for <lists+stable@lfdr.de>; Sat, 26 Sep 2020 17:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726210AbgIZPtu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Sep 2020 11:49:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:53042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725208AbgIZPtu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 26 Sep 2020 11:49:50 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0AC5921527;
        Sat, 26 Sep 2020 15:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601135389;
        bh=YqveA6BCYac4thEZ+T8oTBjl7vnA0yJDu4WyvVaGkys=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zz/sQM4FOXaI7/Sj1IG6A52cDIINVYVrW8o0n4DtqL90HHOFS55DmZfZMiimq5fkL
         7QTgRs9N1cHsf1Lxx92eirKBe5fprBRkPMqnNhFA5F8Kg6PWCRQBCT4hxWFTYZpA47
         TZ5F1l6C60dnPu4BgKUZAz6alZg3uC2TPAWwfpgg=
Date:   Sat, 26 Sep 2020 17:50:01 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/37] 4.19.148-rc1 review
Message-ID: <20200926155001.GB3347445@kroah.com>
References: <20200925124720.972208530@linuxfoundation.org>
 <20200925173946.GB7253@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200925173946.GB7253@duo.ucw.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 25, 2020 at 07:39:46PM +0200, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 4.19.148 release.
> > There are 37 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> CIP testing did not detect any problems.
> 
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-4.19.y

Great!

> I see significant part of this is LLVM support... I'm quite surprised
> to see it in -stable. Few words if LLVM is now officially supported in
> 4.19 or what is going on here would be welcome.

See the stable list archives for the submission of these patches if you
are curious about it.

And yes, many systems run 4.19.y with llvm, many many millions of
devices or so :)

thanks,

greg k-h
