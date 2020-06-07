Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 798931F0AEA
	for <lists+stable@lfdr.de>; Sun,  7 Jun 2020 13:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726455AbgFGLS3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jun 2020 07:18:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:48392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726446AbgFGLS3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Jun 2020 07:18:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A459E20663;
        Sun,  7 Jun 2020 11:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591528709;
        bh=zxofbnThS4Dt2UXvOR5tDVXfnh9SzujjlcICZIeQrm4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CWcSwkt2Z4Mm5Asvc4K8Tl3yJYAYdsBxZvBeOeZZKK8xLIwCqzKdPkrbvBueKa6Xr
         +nASUwFPNgFU5Q61uqvw4829W6Ba7Ry9FS9PmXPBBfqs/TVot555S5euYr79o+pnp2
         LsjT+qvfXoGFYal7rmRxaTa88LP10RhJB1+pTNlk=
Date:   Sun, 7 Jun 2020 13:18:26 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.7 00/14] 5.7.1-rc1 review
Message-ID: <20200607111826.GA47740@kroah.com>
References: <20200605135951.018731965@linuxfoundation.org>
 <ca04681a-77a3-09b8-d399-a27f1e48ba75@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca04681a-77a3-09b8-d399-a27f1e48ba75@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 05, 2020 at 04:11:49PM -0600, Shuah Khan wrote:
> On 6/5/20 8:14 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.7.1 release.
> > There are 14 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 07 Jun 2020 13:54:56 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.1-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.7.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Compiled and booted on my test system. No dmesg regressions.

Thanks for testing all of these and letting me know.

greg k-h
