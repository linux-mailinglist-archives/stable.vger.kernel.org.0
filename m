Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09EB338F07F
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 18:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235347AbhEXQDj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 12:03:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:46880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234686AbhEXQCd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 12:02:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A15661415;
        Mon, 24 May 2021 15:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621871299;
        bh=IACmiSZ6SmyoIHouhO0WcNw4uMoQ4JeFPx63RIO6+6w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BphjKpjfphH7Bdz9/9OvC1145SbWVxtM2gO+WyolGSYvlVpQ4l6NqkFGirmfrEY5A
         IA4+Pa05MCgDuBcrdDc4cbM2Q2yXn0kf7Rila0hjDrROtKts9LbMFtxS4PBuAHaWwb
         tXf4JHF9xPcyPThAtqHgO7q8L1vhkPPJCl2DL+3Q=
Date:   Mon, 24 May 2021 17:42:03 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Fox Chen <foxhlchen@gmail.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.12 00/45] 5.12.6-rc1 review
Message-ID: <YKvJS+mUVMTpSp55@kroah.com>
References: <20210520092053.516042993@linuxfoundation.org>
 <60a64a4e.1c69fb81.9c251.4d30@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <60a64a4e.1c69fb81.9c251.4d30@mx.google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 20, 2021 at 04:38:54AM -0700, Fox Chen wrote:
> On Thu, 20 May 2021 11:21:48 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > This is the start of the stable review cycle for the 5.12.6 release.
> > There are 45 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 22 May 2021 09:20:38 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.6-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> 5.12.6-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
>                 
> Tested-by: Fox Chen <foxhlchen@gmail.com>
> 

Thanks for testing and letting me know,

greg k-h
