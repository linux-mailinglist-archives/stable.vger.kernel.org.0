Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABF0A15F749
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 21:02:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389170AbgBNUCG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 15:02:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:33512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389150AbgBNUCF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 15:02:05 -0500
Received: from localhost (unknown [12.246.51.142])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C33A424650;
        Fri, 14 Feb 2020 20:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581710525;
        bh=ztpXQ3aF4UkpMSJFf+D6IiWO+EhlaCwYM1dfM/Fw0yE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LsdIPxZxjt5BZ8/P6UTstPfMX5IvknzxdBFD7/z4Y/2jFPvNQgIQCjkWZ/TvRMtLa
         vlWTpBYh0sVHjNdqvVOVPwg1v5V5XHcyjOXdxNBVBEMdz12BEwVuuL3n1IE0Y9y34A
         eZDfzI/tSO4/tSJPn6MtioZJGQNJCu50P16OW8JY=
Date:   Fri, 14 Feb 2020 07:22:29 -0800
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.5 000/120] 5.5.4-stable review
Message-ID: <20200214152229.GE3959278@kroah.com>
References: <20200213151901.039700531@linuxfoundation.org>
 <ac7421a1-63d0-3a81-f049-0be6a3bc4db0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac7421a1-63d0-3a81-f049-0be6a3bc4db0@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 13, 2020 at 05:40:48PM -0700, shuah wrote:
> On 2/13/20 8:19 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.5.4 release.
> > There are 120 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 15 Feb 2020 15:16:41 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.5.4-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.5.y
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
