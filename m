Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 008A025E6B9
	for <lists+stable@lfdr.de>; Sat,  5 Sep 2020 11:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbgIEJ2S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Sep 2020 05:28:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:40598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726568AbgIEJ2S (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 5 Sep 2020 05:28:18 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA9AB206A5;
        Sat,  5 Sep 2020 09:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599298098;
        bh=qbGRxJSVtAFz8x1JSRuPA0iFYaXeunLT5C9VXt8avnQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=u9mVN5lAoOZObsq30cVOzuTJJFzcrqMOZH1VMSgRyv7JsLyYTlFqU3XQkjWXM6vcf
         +jQKa/X+gSJPFk364znr7VdfdiYxa3ZN8T0z8NRHIyOimHmpPdmCIc6dxY15vSn9/f
         UAAhONpxvUw4tpa/RfXcZa77s+3BLrlIjo6ZUAko=
Date:   Sat, 5 Sep 2020 11:28:37 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.8 00/17] 5.8.7-rc1 review
Message-ID: <20200905092837.GA3975295@kroah.com>
References: <20200904120257.983551609@linuxfoundation.org>
 <46d98b44-ec5a-2f86-55ab-ac69e36c4c53@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46d98b44-ec5a-2f86-55ab-ac69e36c4c53@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 04, 2020 at 02:11:08PM -0600, Shuah Khan wrote:
> On 9/4/20 7:29 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.8.7 release.
> > There are 17 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 06 Sep 2020 12:02:48 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.7-rc1.gz
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

Thanks for testing both of these and letting me know.

greg k-h
