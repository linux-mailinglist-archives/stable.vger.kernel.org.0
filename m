Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7403E1ECAC1
	for <lists+stable@lfdr.de>; Wed,  3 Jun 2020 09:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725881AbgFCHoU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jun 2020 03:44:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:42916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725275AbgFCHoU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Jun 2020 03:44:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E94E2077D;
        Wed,  3 Jun 2020 07:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591170259;
        bh=pFaM0jC/GpF0ltYSGQTJaqEcQbks55Z4VoCbLMtK9zQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BzlwRXNkMlISTN/UJGSM4hieymdJ0+HBWX0LAQQjt3w3LoFk1gw7otIqy7aYyrXGL
         EN7NAGDx4EbLKrDqoNZorGT2c8p4/rrr27aPT/gQkNMNWU8Hw4EbYzMPPJVs6htG/F
         AhsJPbvSbDWmCEE72pWO+cgqqF37J9tJ74JuTepM=
Date:   Wed, 3 Jun 2020 09:44:17 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.6 000/174] 5.6.16-rc2 review
Message-ID: <20200603074417.GF612108@kroah.com>
References: <20200602101934.141130356@linuxfoundation.org>
 <20200602191356.GE203031@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200602191356.GE203031@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 02, 2020 at 12:13:56PM -0700, Guenter Roeck wrote:
> On Tue, Jun 02, 2020 at 12:24:19PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.6.16 release.
> > There are 174 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 04 Jun 2020 10:16:52 +0000.
> > Anything received after that time might be too late.
> > 
> Build results:
> 	total: 155 pass: 155 fail: 0
> Qemu test results:
> 	total: 429 pass: 429 fail: 0

Thanks for testing all of these and letting me know.

greg k-h
