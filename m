Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCB57285BA5
	for <lists+stable@lfdr.de>; Wed,  7 Oct 2020 11:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727250AbgJGJLq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Oct 2020 05:11:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:50080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726302AbgJGJLq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Oct 2020 05:11:46 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB4C32083B;
        Wed,  7 Oct 2020 09:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602061906;
        bh=52rWsOExDDPmAHNn6Ft0He+B0sqyHGMSlFLkhKStQds=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qIpbHkMUywQOZIDxXw5vZWDxYzIFWjaohmR3Jz6SjoDnXdYNAkyXT4Q3q1cKSc0r3
         zoe16IdbkWbOvJ0oVyvnwdpyj5vK0FJwQvZretItWv/eh6hNd7eQumHaNLgCsldRb+
         56M6Tu9FXfwrh+LLmkyusx8pawjTzqg6cEAyc6IY=
Date:   Wed, 7 Oct 2020 11:12:30 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.8 00/85] 5.8.14-rc1 review
Message-ID: <20201007091230.GD614379@kroah.com>
References: <20201005142114.732094228@linuxfoundation.org>
 <796191d0-b72a-296d-1fa9-ea9384597024@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <796191d0-b72a-296d-1fa9-ea9384597024@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 05, 2020 at 06:18:56PM -0600, Shuah Khan wrote:
> On 10/5/20 9:25 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.8.14 release.
> > There are 85 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 07 Oct 2020 14:20:55 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.14-rc1.gz
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

Thanks for testing them all and letting me know.

greg k-h
