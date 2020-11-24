Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3D862C31F4
	for <lists+stable@lfdr.de>; Tue, 24 Nov 2020 21:29:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731037AbgKXU2j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Nov 2020 15:28:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:43080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726631AbgKXU2j (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Nov 2020 15:28:39 -0500
Received: from localhost (82-217-20-185.cable.dynamic.v4.ziggo.nl [82.217.20.185])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94A2B20708;
        Tue, 24 Nov 2020 20:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606249719;
        bh=x80qNXnx+dnYPiUUE5ECuB+/aHmPybSjFC4eWGaXJlg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OMhLJiE/p7MFzw+Ql62Y/aFSweVzUNYPyOUzRJe8MeLBMMwiZ//D5eWmo7xjcJWWB
         XEcNflcAPmercDUzYYirTtidWpb6qYcZEYvJd/BQTQEYJaVKPBM2tWgA3qoRl8NmkB
         2Mn12N9inWkz5CXRytMZy616S+/C6vvuqy4kE9Bk=
Date:   Tue, 24 Nov 2020 21:28:36 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.9 000/252] 5.9.11-rc1 review
Message-ID: <X71s9Dhh2ararNGq@kroah.com>
References: <20201123121835.580259631@linuxfoundation.org>
 <673cbcf4-2f4d-cea9-2b81-967c9d41ed3e@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <673cbcf4-2f4d-cea9-2b81-967c9d41ed3e@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 23, 2020 at 05:31:09PM -0700, Shuah Khan wrote:
> On 11/23/20 5:19 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.9.11 release.
> > There are 252 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 25 Nov 2020 12:17:50 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.9.11-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.9.y
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
