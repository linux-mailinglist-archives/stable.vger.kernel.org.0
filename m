Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E65DD349195
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 13:09:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbhCYMIi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 08:08:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:57042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230005AbhCYMIW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 08:08:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC9DF61A1B;
        Thu, 25 Mar 2021 12:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616674102;
        bh=2fAeFP0aMQRyTARYA8le2vh966PJiWW/sbxfvybPx08=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BECVou6AhuFPT7gxC6PO9wW8VBRJ+45wPicDzLjTJQYVqRBqfNInTnE6DytB9Gcm+
         aXa8a/EZTF8QF+g3eYdq5hsBnVR0aCD6oZkHMUm9Ytlz9WKsPZRvzfna0onXApjnHz
         l81ir35B7EAMtDTKJ1tyBZoDCsM38CBmInlwbm/E=
Date:   Thu, 25 Mar 2021 13:08:19 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/150] 5.10.26-rc3 review
Message-ID: <YFx9M6BiqDavC8cU@kroah.com>
References: <20210324093435.962321672@linuxfoundation.org>
 <20210324192853.GA32709@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210324192853.GA32709@duo.ucw.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 24, 2021 at 08:28:53PM +0100, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 5.10.26 release.
> > There are 150 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> CIP testing did not find any problems here:
> 
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-5.10.y
> 
> Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Thanks for testing.

greg k-h
