Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5E25337B0A
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 18:38:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbhCKRiN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 12:38:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:45248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229468AbhCKRh5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Mar 2021 12:37:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6955964F98;
        Thu, 11 Mar 2021 17:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615484277;
        bh=dlMHb3KE/RhyEBBWI4zdc+ER/nJyeOr+s4whzEDb21w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ySu2a6KKMLKZzMoqd2Q26wQHOE89gyySDh0rY2fI6suJHDF2W3hWAITd46APCEcdt
         hUf0DFNkHPBhIDI0iVvBZZ8COtsxWy6P12OAed9ALj0+4H8Ibk1Dr1+Mb16dUDzqgO
         w3k4wR3ZgvK3GIeWfOalFZbWoVaznk7ml4G5aNVM=
Date:   Thu, 11 Mar 2021 18:37:54 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.11 00/36] 5.11.6-rc1 review
Message-ID: <YEpVcqMuXvnLaSCX@kroah.com>
References: <20210310132320.510840709@linuxfoundation.org>
 <20210310235301.GG195769@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210310235301.GG195769@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 10, 2021 at 03:53:01PM -0800, Guenter Roeck wrote:
> On Wed, Mar 10, 2021 at 02:23:13PM +0100, gregkh@linuxfoundation.org wrote:
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > This is the start of the stable review cycle for the 5.11.6 release.
> > There are 36 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 12 Mar 2021 13:23:09 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 155 pass: 155 fail: 0
> Qemu test results:
> 	total: 437 pass: 437 fail: 0
> 
> Tested-by: Guenter Roeck <linux@roeck-us.net>

Thanks for all the testing.

greg k-h
