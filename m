Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80ED83B6E24
	for <lists+stable@lfdr.de>; Tue, 29 Jun 2021 08:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231938AbhF2GOH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Jun 2021 02:14:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:34762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231952AbhF2GOH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Jun 2021 02:14:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D3DD61D9A;
        Tue, 29 Jun 2021 06:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624947099;
        bh=WQApMykM3D0yLbOZzKUfd0ATWHP2ebBWdCDGuQfRGyI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=isRn3VcThnpdxIDUZSW/bYVoc3ZTtSOrmqaafNmr6yVABxjUCFEIUk/UoRxyFAFJM
         1tCu8pb/NQfMBub9TqSYnBDHeKZACG1OX2VRdRLfgg3w+7F4pZrV8/zORnhzq0Uy1X
         fsdrCwdKbuVUHWUJmYlyoEOY7xfjRmIxLhR7IOqw=
Date:   Tue, 29 Jun 2021 08:11:37 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org
Subject: Re: [PATCH 5.4 00/71] 5.4.129-rc1 review
Message-ID: <YNq5mSk5MW3Uq60H@kroah.com>
References: <20210628143004.32596-1-sashal@kernel.org>
 <d3122f35-4659-8bed-65eb-77087eec82fe@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d3122f35-4659-8bed-65eb-77087eec82fe@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 28, 2021 at 02:57:20PM -0600, Shuah Khan wrote:
> On 6/28/21 8:28 AM, Sasha Levin wrote:
> > 
> > This is the start of the stable review cycle for the 5.4.129 release.
> > There are 71 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed 30 Jun 2021 02:29:43 PM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> >          https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-5.4.y&id2=v5.4.128
> 
> My tools are failing on this link. Is it possible to keep the rc patch
> convention consistent with Greg KH's naming scheme?

What is failing on this, the use of "&" in the link?  The patch itself
from this link works for me.

thanks,

greg k-h
