Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7BE8267A68
	for <lists+stable@lfdr.de>; Sat, 12 Sep 2020 14:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725899AbgILMqh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Sep 2020 08:46:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:43014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725920AbgILMoZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 12 Sep 2020 08:44:25 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DE0521D7E;
        Sat, 12 Sep 2020 12:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599914664;
        bh=tyF+M/yD8qApilYS/UyqK4hG/UX82QyjFBqlhiXv2pA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RDNYNNJqpyHR0Nm69SgP4CGAb5qzmzoyNVmbLh8p0QWcCZknuZTNse6e7wIXGNUZS
         SFX5O41Ayo4L31HzpMIIep1lyPAMMdSH1cJBS/DCeIMBK88/Rd9t7j2qD0Zl+x6XUa
         +FmybnppIkIm4djv+HLW8pqzvFxmFH4I2adnM5k4=
Date:   Sat, 12 Sep 2020 14:44:28 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.8 00/16] 5.8.9-rc1 review
Message-ID: <20200912124428.GB539446@kroah.com>
References: <20200911122459.585735377@linuxfoundation.org>
 <e96f6dab-ff0d-eea3-86f4-95e4cd81bc69@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e96f6dab-ff0d-eea3-86f4-95e4cd81bc69@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 11, 2020 at 04:19:48PM -0600, Shuah Khan wrote:
> On 9/11/20 6:47 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.8.9 release.
> > There are 16 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 13 Sep 2020 12:24:42 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.9-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.8.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Compiled and booted on my test system. No dmesg regressions.
> 
> Tested-by: Shuah Khan <skhan@linuxfoundation.org>

Thanks for testing all of these and letting me know.

greg k-h
