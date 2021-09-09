Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4F07404F02
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241291AbhIIMQ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:16:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:52734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348555AbhIIMMO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:12:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA41661A4E;
        Thu,  9 Sep 2021 11:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631188132;
        bh=/QI+BRvDB+1wIbje5a8x8kgwfLi5dRyIuCwEUMJ67Uc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0rrCGvHzXq4q4P3wRbIPfFdZj9aoF9xeWh+QVHYOtkYUMxcQckD/vmyNkpTr8OuMG
         33EhjEWIYevpzewX5QQtfFPAQYO0NpH30f/XC4si7SVH+pMmivhYpl2AYPpkA2z4FD
         Zybdev5tXrSDqGn3sLsrHYRp1loN5/lRdWq4zVQ8=
Date:   Thu, 9 Sep 2021 13:48:49 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Phillip Potter <phil@philpotter.co.uk>,
        kernel test robot <lkp@intel.com>,
        linux-staging@lists.linux.dev
Subject: Re: [PATCH AUTOSEL 5.14 044/252] staging: rtl8188eu: remove
 rtw_wx_set_rate handler function
Message-ID: <YTn0ofrVzKH/IuyV@kroah.com>
References: <20210909114106.141462-1-sashal@kernel.org>
 <20210909114106.141462-44-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210909114106.141462-44-sashal@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 09, 2021 at 07:37:38AM -0400, Sasha Levin wrote:
> From: Phillip Potter <phil@philpotter.co.uk>
> 
> [ Upstream commit ac5951a6e3d50cfa861ea83baa2ec15d994389cb ]
> 
> Remove rtw_wx_set_rate handler function, which currently handles the
> SIOCSIWRATE wext ioctl. This function (although containing a lot of
> code) set nothing outside its own local variables, and did nothing other
> than call a now removed debugging statement repeatedly. Removing it and
> leaving its associated entry in rtw_handlers as NULL is therefore the
> better option. Removing this function also fixes a kernel test robot
> warning.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
> Link: https://lore.kernel.org/r/20210625191658.1299-1-phil@philpotter.co.uk
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  .../staging/rtl8188eu/os_dep/ioctl_linux.c    | 75 -------------------
>  1 file changed, 75 deletions(-)

This whole driver is now gone in 5.15-rc1, so no need for doing anything
like this for older kernels.  Please drop this patch from all branches.

thanks,

greg k-h
