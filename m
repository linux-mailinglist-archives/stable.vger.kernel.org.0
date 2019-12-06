Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54269115439
	for <lists+stable@lfdr.de>; Fri,  6 Dec 2019 16:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726258AbfLFP21 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Dec 2019 10:28:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:40216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726250AbfLFP21 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Dec 2019 10:28:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E70C124659;
        Fri,  6 Dec 2019 15:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575646106;
        bh=WPCzgRYIBJNYXlDKmUkFx7z55QQD0LFmcs9vlUCD0jw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iWFKL713wr2ESB9xLxw5mrVBPkrU3vGY/yBhiebYa3y9edOBrg2JmVC/yweKj0MJw
         QdSuOchvwAZ/QsWmxZXuSwJsghCeRxV3lYtNnFoGKiFWnkdik3sRzrVhy/4V2YIle/
         G3dwZAFrHXnvSJpirrT9Ya+BeYZ2XMrz5kINLeqc=
Date:   Fri, 6 Dec 2019 16:28:23 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 000/209] 4.14.158-stable review
Message-ID: <20191206152823.GA75339@kroah.com>
References: <20191204175321.609072813@linuxfoundation.org>
 <1dac10cd-7183-9dfd-204c-05fae75bcd74@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1dac10cd-7183-9dfd-204c-05fae75bcd74@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 06, 2019 at 08:24:36AM -0700, shuah wrote:
> On 12/4/19 10:53 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.14.158 release.
> > There are 209 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 06 Dec 2019 17:50:10 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.158-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Starting with Linux 4.14.157, 4.9.204, and 4.4.204 stables stopped
> booting on my system. It can't find the root disk. No config changes
> in between.
> 
> I have been bisecting 4.14 and 4.9 with no luck so far. I updated
> to Ubuntu 19.10 in between.
> 
> The only other thing I see is CONFIG_GCC_VERSION which is supported
> starting 4.18. I don't this boot failing issue on 4.19 + up. I am
> also chasing any links between this config and scripts and tools
> that generate the initramfs.

Did you also upgrade your version of gcc?  I know I build those older
kernels with the latest version of gcc for build tests, but I do not
boot them.  I think everyone who still uses them uses older versions of
gcc.

> I am still debugging ... Serious for me since I can no longer test
> older stables. :(

Ick, not good, sorry.  If you find anything bisecting, please let me
know.

thanks,

greg k-h
