Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83033104ADF
	for <lists+stable@lfdr.de>; Thu, 21 Nov 2019 07:57:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbfKUG5d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 01:57:33 -0500
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:50547 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725842AbfKUG5c (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Nov 2019 01:57:32 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id C41E377D;
        Thu, 21 Nov 2019 01:57:31 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Thu, 21 Nov 2019 01:57:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=YrpEYFNL+uV5C1VBK+m3dkKRA32
        9pp9FzNFG1t30KAM=; b=n9O8qjb+PGYaS7TXbT3ZWMhXjffZMmmlWf8uc8d4SdU
        TOQaj8Y6XXtNZFFOj1vDZq0OA8uc4B0q9qbsLg7Cfau4HAtQb/wdLL9Vj7WXWNAg
        E2NwYt043B755fymPRTkhS5V9MXgCF8qW5YXdJdXe1T0MbX12bEJ4TG3Fr01nX/i
        iUi9Wdc697rCEtLN0bhmCtQP0hcXxGCI09gAd+AXBLBEmOlZy6zOmUUZCr2SBAN3
        imR9KybzV5oro66sE8bjVajhYfyUsIv9dUJdJKH+Vv20INclgig2F6YVJ8ab0zf1
        uvqivP8HsSu7eMB5rqogskc+SQ2qzAAhc93EvnH/fVw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=YrpEYF
        NL+uV5C1VBK+m3dkKRA329pp9FzNFG1t30KAM=; b=GDWoETM0SN8dnQQtlduJvG
        npq/yd8jTazfdvWDxQt1KQ1KB+RrkEZdcWAwEWKXIGAb/lqhlpFcBPIRDsYVv1xL
        V04UmUwYxdSmKNDz8UyhLOnD3yEa88NQDrLm1d3qOZr/RBKHLJdcPKOoBRXJ8VMX
        6Unz9MvVsDM4XVelBq8nVOqHDQKczD32SUnF0UM0xEMIDI+unswzYAPlHc4q+SVv
        S+hVtRVmphAarpSOo/8IaNDH1aI/K8n88jGP9cWEL7Ofp+zxSx6b+47gGSJGGIWs
        e69I5n7nSrIUzntfaNf9bKb8PESiA8AU+PVlp3pMs7Znq0d+ICvefDnKyKmzmfFg
        ==
X-ME-Sender: <xms:WzXWXenavyKceJHomATcnP48BdZSnnti66srqzP-pjb4wxVwPoQYbQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudehuddguddtudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:WzXWXRQ9W9EvAz33jaqhHviTjuh13AInkbBHRMK-N_AQuo-YEuX4sQ>
    <xmx:WzXWXQOPwZNXlD-C0UTuC3pPc6QoEkETkz7lttQ25bkZdi2O5Q5F_g>
    <xmx:WzXWXbm1sROG7GOCl-5tKKWFn4BzE5V4GFsCVtBwUQBXHiiQQvjWHw>
    <xmx:WzXWXW7uWtZD96N1I1hdluSFMLjWXea7EMNIZnThNSq572fKtZrwmw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D2F9D306005F;
        Thu, 21 Nov 2019 01:57:30 -0500 (EST)
Date:   Thu, 21 Nov 2019 07:57:28 +0100
From:   Greg KH <greg@kroah.com>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH website] releases: Extend 3.16 EOL to match Debian 8
Message-ID: <20191121065728.GA343863@kroah.com>
References: <20191119213141.GA19244@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191119213141.GA19244@decadent.org.uk>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 19, 2019 at 09:31:41PM +0000, Ben Hutchings wrote:
> I'm maintaining 3.16 primarily for Debian 8.  I originally expected
> that to have an EOL of April 2020 but it's actually June.
> 
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> Acked-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
> ---
>  content/releases.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/content/releases.rst b/content/releases.rst
> index dbbe0d69db9d..0908fd090cdc 100644
> --- a/content/releases.rst
> +++ b/content/releases.rst
> @@ -45,7 +45,7 @@ Longterm
>      4.14     Greg Kroah-Hartman & Sasha Levin 2017-11-12   Jan, 2024
>      4.9      Greg Kroah-Hartman & Sasha Levin 2016-12-11   Jan, 2023
>      4.4      Greg Kroah-Hartman & Sasha Levin 2016-01-10   Feb, 2022
> -    3.16     Ben Hutchings                    2014-08-03   Apr, 2020
> +    3.16     Ben Hutchings                    2014-08-03   Jun, 2020
>      ======== ================================ ============ ==================
>  
>  Distribution kernels

Now applied to the tree, the website should update on the public side
"soon".

thanks,

greg k-h
