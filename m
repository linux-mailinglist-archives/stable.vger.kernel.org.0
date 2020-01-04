Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC8BC130198
	for <lists+stable@lfdr.de>; Sat,  4 Jan 2020 10:20:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726133AbgADJUx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Jan 2020 04:20:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:55950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726094AbgADJUx (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 4 Jan 2020 04:20:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B2F8215A4;
        Sat,  4 Jan 2020 09:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578129653;
        bh=TQ19fM74/phZQOTJgGbOJ80IHU9IfGxhTIOfjf5P+II=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ncAvgUjbeHSuf7VlwktuVK+AeQliPYmgiURPRaDAHIoQ1Y2x5RfesGq68Vg3ay16t
         KXjvoEH1VMknpU/7j3HDDQ0Yyv7pb34XPge6bg+nDLSzsuLR6NMRqE5JTfg/XT53N3
         oXzaJg3v1grngFpWA+cGSH2kABzMAM0seFyB3FVk=
Date:   Sat, 4 Jan 2020 10:20:50 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/191] 5.4.8-stable review
Message-ID: <20200104092050.GB1249964@kroah.com>
References: <20200102215829.911231638@linuxfoundation.org>
 <59e0fada-0277-d5db-f550-f1ff9db01212@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <59e0fada-0277-d5db-f550-f1ff9db01212@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 03, 2020 at 02:48:58PM -0700, shuah wrote:
> On 1/2/20 3:04 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.8 release.
> > There are 191 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 04 Jan 2020 21:55:35 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.8-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
