Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D24CC370D80
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 17:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231909AbhEBO5G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 10:57:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:46112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230110AbhEBO5G (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 10:57:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D0EE600D1;
        Sun,  2 May 2021 14:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619967373;
        bh=i+GNc/hZ8lPa7KbkQ305SjPnkwd3pho1sduIJrmnOa0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KvWQTvX2wAQGums8bmADZVRytG7IzM5wghvGfObjAlQGHi3MfsVciwpjpF2aLQK8b
         8UbYxXVoef92KS4f9UuvVxj84esAAKlVm5Y43X+cT2Se9nYnM+b9p1BwykB0AcunJI
         5ia6wiL24nweUVj0qxm6cLxSFm4QPc1hWtEQZgGk=
Date:   Sun, 2 May 2021 16:56:11 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.12 16/79] usb: dwc3: gadget: Remove invalid
 low-speed setting
Message-ID: <YI69i5JE3NdIx4Sb@kroah.com>
References: <20210502140316.2718705-1-sashal@kernel.org>
 <20210502140316.2718705-16-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210502140316.2718705-16-sashal@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, May 02, 2021 at 10:02:13AM -0400, Sasha Levin wrote:
> From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
> 
> [ Upstream commit 0c59f678fcfc6dd53ba493915794636a230bc4cc ]
> 
> None of the DWC_usb3x IPs (and all their versions) supports low-speed
> setting in device mode. In the early days, our "Early Adopter Edition"
> DWC_usb3 databook shows that the controller may be configured to operate
> in low-speed, but it was revised on release. Let's remove this invalid
> speed setting to avoid any confusion.
> 
> Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
> Link: https://lore.kernel.org/r/258b1c7fbb966454f4c4c2c1367508998498fc30.1615509438.git.Thinh.Nguyen@synopsys.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/usb/dwc3/core.c   | 1 -
>  drivers/usb/dwc3/core.h   | 2 --
>  drivers/usb/dwc3/gadget.c | 8 --------
>  3 files changed, 11 deletions(-)

This is a "cleanup only" and does not fix or solve anything, so it can
be dropped from all of the kernels it has been "autoselected" for.

thanks,

greg k-h
