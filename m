Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C79E5337B18
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 18:40:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbhCKRjr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 12:39:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:45796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230027AbhCKRjm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Mar 2021 12:39:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 228C264F97;
        Thu, 11 Mar 2021 17:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615484381;
        bh=0jYjJ0cCaYA8YhHBEuwTaRi10Wab+szfGOSTf27fuhc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lJvEdw4l7x+MIC+cVABeDa5RqxLEX6i+eGgGG6YwZT2LqdGRLo9i1BDykc9Z+A3A+
         z8ZXctF4lKZUVsQc8SFh5+Bguz9Flv2ovPp5HkoAbJ3sHXzxbsv+HNU6PsCsndNtZl
         laxrlKdX7Mk/t5Vb1nznOUMHvIc1XzHr6vbhNxlE=
Date:   Thu, 11 Mar 2021 18:39:39 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/47] 5.10.23-rc2 review
Message-ID: <YEpV2yOv9gfes24a@kroah.com>
References: <20210310182834.696191666@linuxfoundation.org>
 <20210310202419.GC13374@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210310202419.GC13374@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 10, 2021 at 09:24:19PM +0100, Pavel Machek wrote:
> Hi!
> 
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > This is the start of the stable review cycle for the 5.10.23 release.
> > There are 47 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> CIP testing did not find any kernel problems here: (Renesas boards
> are still unavailable)
> 
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-5.10.y
> 
> Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Thanks for testing some of these.
