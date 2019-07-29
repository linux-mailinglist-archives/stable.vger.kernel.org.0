Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 768BA79192
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 18:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727481AbfG2Q4P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 12:56:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:55898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727165AbfG2Q4O (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 12:56:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FEC3206E0;
        Mon, 29 Jul 2019 16:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564419373;
        bh=Jb7YttoUfhXk57tI+td6fw5yT58F4sBic2hI+PXmoR4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FvEucwLp9F/97X8skoF+H8Wz10sVG1GIsV67VKgXl8I6siTOxMPv55fryyZ/wJ/XO
         cOcRut/6QT2SZSqhKdxd5kQ9W1nGAfPtBFWyf4lqspLrmAf6GObQEfzv95jQKIIiMm
         XEdddmHh458+5qHmcwmIyJHnOiDl9zs27NxITJ1M=
Date:   Mon, 29 Jul 2019 18:56:11 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Saranya Gopal <saranya.gopal@intel.com>
Cc:     stable@vger.kernel.org, linux-usb@vger.kernel.org,
        fei.yang@intel.com, john.stultz@linaro.org,
        Felipe Balbi <felipe.balbi@linux.intel.com>
Subject: Re: [PATCH 4.19.y 3/3] usb: dwc3: gadget: remove req->started flag
Message-ID: <20190729165611.GA14160@kroah.com>
References: <1564407819-10746-1-git-send-email-saranya.gopal@intel.com>
 <1564407819-10746-4-git-send-email-saranya.gopal@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1564407819-10746-4-git-send-email-saranya.gopal@intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 29, 2019 at 07:13:39PM +0530, Saranya Gopal wrote:
> From: Felipe Balbi <felipe.balbi@linux.intel.com>
> 
> [Upstream commit 7c3d7dc89e57a1d43acea935882dd8713c9e639f]
> 
> Now that we have req->status, we don't need this extra flag
> anymore. It's safe to remove it.
> 
> Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
> Signed-off-by: Saranya Gopal <saranya.gopal@intel.com>
> ---
>  drivers/usb/dwc3/core.h   | 2 --
>  drivers/usb/dwc3/gadget.c | 1 -
>  drivers/usb/dwc3/gadget.h | 2 --
>  3 files changed, 5 deletions(-)

Why is this patch needed for a stable tree?  It just cleans stuff up, it
doesn't actually change any functionality.

thanks,

greg k-h
