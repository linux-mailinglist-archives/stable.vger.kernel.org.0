Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36CE114F3C7
	for <lists+stable@lfdr.de>; Fri, 31 Jan 2020 22:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726109AbgAaVai (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jan 2020 16:30:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:51148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726199AbgAaVai (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 31 Jan 2020 16:30:38 -0500
Received: from localhost (unknown [83.216.75.91])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E38B20CC7;
        Fri, 31 Jan 2020 21:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580506237;
        bh=7rm5QBIBcquRskYlwTK6rpmwJGMsnsxrqoFtI+gWoIA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YiQWYv5PTd92ROUjNUK+Q0s3ZDxpKui9HON7BBjcXWiwBNzwtAPsrsHGpaAoaqYHT
         YxSFKDmKVxF3DtjphxAfJ+1XxkGgPXVlrwYZjQG7ICIX0uUUkZH2qeh7cH+p0WzFXt
         ls7G7HtHL8NcMzD52mG5vk1rKjx8iaZqaxGOdEnM=
Date:   Fri, 31 Jan 2020 22:30:29 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/55] 4.19.101-stable review
Message-ID: <20200131213029.GF2278356@kroah.com>
References: <20200130183608.563083888@linuxfoundation.org>
 <20200131131223.GA13686@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200131131223.GA13686@duo.ucw.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 31, 2020 at 02:12:23PM +0100, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 4.19.101 release.
> > There are 55 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 01 Feb 2020 18:35:06 +0000.
> > Anything received after that time might be too late.
> 
> No problems detected in CIP compile/boot tests:
> 
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/commit/bb5fd2ed7f74648a46141afdad5902a3a7cf2c00

Thanks for testing and letting me know.

greg k-h
