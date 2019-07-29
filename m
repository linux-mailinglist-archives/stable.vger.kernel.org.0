Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB7279194
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 18:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728691AbfG2Q4x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 12:56:53 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:52255 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727165AbfG2Q4x (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jul 2019 12:56:53 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 46DD421B42;
        Mon, 29 Jul 2019 12:56:52 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 29 Jul 2019 12:56:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=dXt+y2OikSZHX8DwfF0NTpZ/VZB
        EKbTy7A/AfNd2IhE=; b=Zb1OhdcIG1jl+rS+EiFW+7zi73um7cLj0sVCzi3ijn1
        jJsKcBrnEeE91EVljTU+L2sWbvuB/gjNPFy8QC7PFLFv7SKktvFlxSPCk5sBL4WH
        OLQ3qY/u/aTMpwm1tMBCsC0kx972s2/P9Ycau2B5lCH6BWb80nQJBrMegZgpNHnl
        Ka43JCa9JK9bfQrGzMw3ws6kBQIbm9+u3npoODW2+YNFvgn2XJw1/5LJrD12sf6c
        MY1bwf+Hwn5YjWrm8cQIStOD3WM3rwDTLPLICspkY2jgOmbU19pKJBHx+BKT40kN
        w2gEX71cX/7Y0L0C0eRBlqB8AwvHtZJEqNOTRDOHjZg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=dXt+y2
        OikSZHX8DwfF0NTpZ/VZBEKbTy7A/AfNd2IhE=; b=mK09SJipVKYhK1oLU68fUf
        TqFFpoivOKD8SGUpYLGhVVgck5UWv/0DIvccG3iLASg5bYroQRq702qPkLbEixa9
        8tM8+8Ydpq0rp6ZI3Sj2oWsPxJAynGRLNT6zahUXH+EjN3JV3AzUDeCXLd76aYsl
        y6c8oUu+d/FKBxM+4acxHp87dzXdG9dvuIuxSWz0jcbyqxk2qQcM+zxVALgWwb0d
        FxEVeh/ratESOQ35d2Q5B/3g157UDvI5E+el8L9j112sWa/NneKYF4knOUvwnmSP
        7JB7BsPJJ/rLUT387ZRo6T/41RKzB7neC3BmkplTSNv6q78QsypyL1KY997NBPaA
        ==
X-ME-Sender: <xms:UyU_XReB5tX-mqTwKZoP-dj02QK99X2lh-4oIOllAGhki1QfmeviYw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrledugddutdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:UyU_XUJZBnRfZuVc6HKVXjpUGq4v7fGWHBFFt5o9rKmZsAMegl7UKg>
    <xmx:UyU_XWAqEoiiNZrKUWwZ2kX2pcUx8_ilo9_-ESuqkhEvf51JxKqtJQ>
    <xmx:UyU_XeFQc_GURo0lFOT2D4WM6jkU6poIjy3hwVYLOED2JKpWxlSufg>
    <xmx:VCU_XV3PWKvk8XHq9fCq12FgwDgMSDvE4VYjqjYg0bLH6J7CkfVJFw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4E844380076;
        Mon, 29 Jul 2019 12:56:51 -0400 (EDT)
Date:   Mon, 29 Jul 2019 18:56:49 +0200
From:   Greg KH <greg@kroah.com>
To:     Saranya Gopal <saranya.gopal@intel.com>
Cc:     stable@vger.kernel.org, linux-usb@vger.kernel.org,
        fei.yang@intel.com, john.stultz@linaro.org,
        Felipe Balbi <felipe.balbi@linux.intel.com>
Subject: Re: [PATCH 4.19.y 2/3] usb: dwc3: gadget: prevent dwc3_request from
 being queued twice
Message-ID: <20190729165649.GB14160@kroah.com>
References: <1564407819-10746-1-git-send-email-saranya.gopal@intel.com>
 <1564407819-10746-3-git-send-email-saranya.gopal@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1564407819-10746-3-git-send-email-saranya.gopal@intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 29, 2019 at 07:13:38PM +0530, Saranya Gopal wrote:
> From: Felipe Balbi <felipe.balbi@linux.intel.com>
> 
> [Upstream commit b2b6d601365a1acb90b87c85197d79]
> 
> Queueing the same request twice can introduce hard-to-debug
> problems. At least one function driver - Android's f_mtp.c - is known
> to cause this problem.
> 
> While that function is out-of-tree, this is a problem that's easy
> enough to avoid.
> 
> Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
> Signed-off-by: Saranya Gopal <saranya.gopal@intel.com>
> ---
>  drivers/usb/dwc3/gadget.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> index 3f337a0..a56a92a 100644
> --- a/drivers/usb/dwc3/gadget.c
> +++ b/drivers/usb/dwc3/gadget.c
> @@ -1291,6 +1291,11 @@ static int __dwc3_gadget_ep_queue(struct dwc3_ep *dep, struct dwc3_request *req)
>  				&req->request, req->dep->name))
>  		return -EINVAL;
>  
> +	if (WARN(req->status < DWC3_REQUEST_STATUS_COMPLETED,
> +				"%s: request %pK already in flight\n",
> +				dep->name, &req->request))
> +		return -EINVAL;

So we are going to trip syzbot up on this out-of-tree driver?  Brave...

