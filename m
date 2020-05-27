Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38D4A1E474F
	for <lists+stable@lfdr.de>; Wed, 27 May 2020 17:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730265AbgE0P2r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 May 2020 11:28:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:42846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725971AbgE0P2r (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 May 2020 11:28:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A100208DB;
        Wed, 27 May 2020 15:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590593327;
        bh=JHQk4AB7jeHZmyK0aVzq79SFANigBikIIIzGgcKppg8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ty6DH76ciXxETEUjplknXeWAevGZ90Zhtegr/dsNoGdKCSCWzyi1idRhf8EoBTwHg
         hFOVqztXdiSMGJ8SIWmox/BYb9HoSnhnIt9ENJDC9xwwhSo+Zd8LSSbsFMOyGJI9rU
         D8yHmsYuY7VnzpSDZ1FjAEypmG1mYJKT57zZO9sM=
Date:   Wed, 27 May 2020 17:28:44 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/81] 4.19.125-rc1 review
Message-ID: <20200527152844.GA524990@kroah.com>
References: <20200526183923.108515292@linuxfoundation.org>
 <20200527140225.GA214763@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200527140225.GA214763@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 27, 2020 at 07:02:25AM -0700, Guenter Roeck wrote:
> On Tue, May 26, 2020 at 08:52:35PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.19.125 release.
> > There are 81 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 28 May 2020 18:36:22 +0000.
> > Anything received after that time might be too late.
> > 
> Build results:
> 	total: 155 pass: 155 fail: 0
> Qemu test results:
> 	total: 421 pass: 390 fail: 31
> Failed tests:
> 	<all alpha>
> 	<all sh>
> 	<all sheb>
> 
> Bisect log (for alpha) below. Reverting the offending patch fixes the
> problem. Note that the problematic patch is associated with several
> other patches in the upstream kernel. Not all of them have a Fixes: tag,
> and I am not sure if all of them reference the problematic patch.

ah, I was worried about that patch.  ugh.  Ok, I'll drop it and make the
submitter send all of the fixups as well.

thanks,

greg k-h
