Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD211E47B0
	for <lists+stable@lfdr.de>; Wed, 27 May 2020 17:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728275AbgE0Php (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 May 2020 11:37:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:46864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728224AbgE0Php (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 May 2020 11:37:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A9B020776;
        Wed, 27 May 2020 15:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590593864;
        bh=jAkMEUHBqdEO/QszEQaHMrmSFZfYvlTNLoTI/ewiBbo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lJsdueIkTxkhujGy8F7+ZyRYofmEVlcyWjp5QPEirpbUJExxaMWAJbPsY0KBdTLtd
         Ea5F8NxXoz+ohsz1GBI5tCVWdl1wD/t4fk5chRVo3645DCOGcf7qCKvtziDmvN6voL
         TU9ggbO0pUoEiQKyHeAH4nP7xm7lSjj3Zh6bC8vA=
Date:   Wed, 27 May 2020 17:37:42 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.6 000/126] 5.6.15-rc1 review
Message-ID: <20200527153742.GB524990@kroah.com>
References: <20200526183937.471379031@linuxfoundation.org>
 <ed76968d-55b5-79c5-61d1-40e8d2842421@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed76968d-55b5-79c5-61d1-40e8d2842421@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 27, 2020 at 06:54:27AM -0700, Guenter Roeck wrote:
> On 5/26/20 11:52 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.6.15 release.
> > There are 126 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 28 May 2020 18:36:22 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 155 pass: 155 fail: 0
> Qemu test results:
> 	total: 431 pass: 431 fail: 0

Thanks for testing all of these and letting me know.

greg k-h
