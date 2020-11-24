Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 961AF2C31ED
	for <lists+stable@lfdr.de>; Tue, 24 Nov 2020 21:29:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728047AbgKXU1z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Nov 2020 15:27:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:42362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726631AbgKXU1z (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Nov 2020 15:27:55 -0500
Received: from localhost (82-217-20-185.cable.dynamic.v4.ziggo.nl [82.217.20.185])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30A4B20678;
        Tue, 24 Nov 2020 20:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606249674;
        bh=o+3M3sZ5eRNPnkGBmnDpQgsyQETAEi2X7ujxqJcKlg8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uwcsNewAZEsYVqPeickNeDI1QhT1SF5m9G8k5dpZ1fA4jvHNP0VnXGweys5r69G6S
         E54Qy4SfDoqr05oFmgFVa799gv7VLyZRc6tNH7dZoLyu94LGGnBxLddHZbNpM3W4Fw
         +6AWgU5VxSd59woOBNdu3WmwLiOFJKjEuQi4l2IQ=
Date:   Tue, 24 Nov 2020 21:27:52 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/91] 4.19.160-rc1 review
Message-ID: <X71syA7pN8qd9v5/@kroah.com>
References: <20201123121809.285416732@linuxfoundation.org>
 <20201124195347.GB6517@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201124195347.GB6517@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 24, 2020 at 08:53:47PM +0100, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 4.19.160 release.
> > There are 91 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 25 Nov 2020 12:17:50 +0000.
> > Anything received after that time might be too late.
> 
> CIP testing did not find any problems here.
> 
> Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Thanks for the review!

greg k-h
