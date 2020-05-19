Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6614A1D8F4E
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 07:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgESFnc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 01:43:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:46146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726396AbgESFnc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 May 2020 01:43:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D81920708;
        Tue, 19 May 2020 05:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589867010;
        bh=i8esXH5Ow6FF3jAidh3vVtwgoEXxUcAaATRRRjhOz+0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QK2cy88FxwdwIj9vD7darq/n/4zw341JKZ68o98Vj5Eg68jySMHw8zDeL9g2yFCZV
         75gtNN/HtgvAkImUSg7fnTaw37nQvOWc3Qjk/OVavv64XUCD7Jn2BQ501bgfsr8KWF
         siDNZnWXY+RrnSWKRar1TEUxvhvpKTX3ewiDIHdA=
Date:   Tue, 19 May 2020 07:43:28 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.6 000/194] 5.6.14-rc1 review
Message-ID: <20200519054328.GA3791824@kroah.com>
References: <20200518173531.455604187@linuxfoundation.org>
 <433eae0c-e84b-5694-a953-11f3843cfa24@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <433eae0c-e84b-5694-a953-11f3843cfa24@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 18, 2020 at 07:10:45PM -0700, Guenter Roeck wrote:
> On 5/18/20 10:34 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.6.14 release.
> > There are 194 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 20 May 2020 17:32:42 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Quick feedback:
> 
> You also need to pull in commit 92db978f0d68 ("net: ethernet: ti: Remove TI_CPTS_MOD workaround")
> which fixes commit b6d49cab44b5 ("net: Make PTP-specific drivers depend on PTP_1588_CLOCK").
> This is necessary to avoid compile errors.

Sasha has now dropped that original patch, so we should be fine.  I'll
push out a -rc2 soon with that change.

thanks,

greg k-h
