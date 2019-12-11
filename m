Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC50711BBBE
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 19:28:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731128AbfLKS2z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 13:28:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:57250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729955AbfLKS2z (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 13:28:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FE7D2077B;
        Wed, 11 Dec 2019 18:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576088934;
        bh=Roq6pbFHUDAl032rVPM2wyMcVk33Z+yJFKAG9AUB8ZM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=elqC9b1cI+aYjtja2APG7QZSaJv9Tky2ca7AbAVQWq0qCWMDHL290RxC2DUrPCkqI
         QEHft3u50ygC53o4L+FdCqe4D+y56l8oMT2ufNQQlKBTP38TxJguaQTrL/aJ1TSFNc
         4vn2bnWCVX5wN/gDHZk9T6aenSB7wFfBHzvO4xSQ=
Date:   Wed, 11 Dec 2019 19:28:52 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jeffrin Jose <jeffrin@rajagiritech.edu.in>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.3 000/105] 5.3.16-stable review
Message-ID: <20191211182852.GA715826@kroah.com>
References: <20191211150221.153659747@linuxfoundation.org>
 <20191211161605.GA4849@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211161605.GA4849@debian>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 11, 2019 at 09:46:05PM +0530, Jeffrin Jose wrote:
> On Wed, Dec 11, 2019 at 04:04:49PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.3.16 release.
> > There are 105 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 13 Dec 2019 14:56:06 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.16-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.3.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> i get the following when i try to compile...
> 
> -------------------x--------------------x--------------------x--------------
> $sudo make -j4
>   DESCEND  objtool
> make[4]: *** No rule to make target 'arch/x86/lib/x86-opcode-map.txt', needed by '/home/jeffrin/UP/linux-stable-rc/tools/objtool/arch/x86/lib/inat-tables.c'.  Stop.
> make[3]: *** [/home/jeffrin/UP/linux-stable-rc/tools/build/Makefile.build:139: arch/x86] Error 2
> make[2]: *** [Makefile:50: /home/jeffrin/UP/linux-stable-rc/tools/objtool/objtool-in.o] Error 2
> make[1]: *** [Makefile:67: objtool] Error 2
> make: *** [Makefile:1752: tools/objtool] Error 2
> make: *** Waiting for unfinished jobs.
> ------------------x-------------------------x----------------x-----------
> 
> the file "x86-opcode-map.txt" has been deleted upstream.

that's really odd.  How are you building this, from the git tree, or the
tarball generated?

And I still see that file in the 5.3 tree, what do you mean it was
deleted?

thanks,

greg k-h
