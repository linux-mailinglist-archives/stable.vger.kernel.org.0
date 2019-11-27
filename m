Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E790F10AB57
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 08:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726227AbfK0H6G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 02:58:06 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:40795 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726111AbfK0H6F (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Nov 2019 02:58:05 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id D233199B;
        Wed, 27 Nov 2019 02:58:04 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 27 Nov 2019 02:58:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=EVuFkfM4drVnSoDf+l5B9PIcNFB
        23a6yWkCKyQ5AdYs=; b=RXqos6jDxE49h8zdEMP1BYd5y1hoWDGGwQhLeRjxKzj
        AghAEF4H/czv+wpr4Efe4robAEnBMpfj6ocjSrJ+CMvTSd6Q3YOsJ6HwkkqsZcOu
        OA8mBwg3hsWzA93npYtNXfb8D7jhwKZ4yMfrPZzIxkhFxQeF37WdQQE4T/RY3zZE
        ++gI67cXMiJoW6tnnqrGZL7Z7UBf7CuUB+RoIGO+Iyq5kIoWEn5zyS1RzAOlCuE2
        OI+aW3W3sAeeftelnfyIdbWQLxznZCYPc1nYGmUM21A8SK6qRMYC3fhYIOQaas5k
        ZWi58UlNLCWPqatObEQLDOIihMlwAt1wEsxYzK2a5Lw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=EVuFkf
        M4drVnSoDf+l5B9PIcNFB23a6yWkCKyQ5AdYs=; b=W71CHSxnU0vpi6am4XEO/1
        L9Q25Fno5GceQoII1Cs7nTl0Us+SNiZY/PWYT35+1KGV19HuCdJN77yiCSs3NA59
        CKax3V6h9zOSgWfc6HSeAmU+Gy4/ICu4DkjiHWpd7uLQ/17p05aYYKynsj6k1qE0
        77mCzC0rBC2KGdawElCUk/gpCkHovGLMzPUd18by/lUaFcGo258ufKzEKHcEs+I+
        ZaQhIqFReHR8ve1tjxOG3rE1s4QdRM9ZSWuu5VHTgjCh4RSb6EZ9urOPvAV8SBk3
        EOS8uJYUt5pXxXEnqCKUxAzn/nsOvX4Nk+2Yvr9VegNTpak8/xFjRSzhcK5k7lrg
        ==
X-ME-Sender: <xms:jCzeXSxPK6i04jzNrxCUC3V-fcnePoScRSk8wlRRftnDVLTyYoogyg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudeigedguddugecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:jCzeXbP7rjt_rQ9mljXnk79KLU3DKzOyKiQlK4xs1eUmb2jOeQRUcw>
    <xmx:jCzeXf8akVfHBBc7CzZr8bm4Kk8hvPbzDoRoxxj81SCrc89NuJq2iA>
    <xmx:jCzeXQ4nXNR85U-vNmaotHoiVwxXfQ60Yer-Ek4kCBqXRZQAX_XAZQ>
    <xmx:jCzeXdCcB4EYhSbBmFECS1Jla4kLOYbLg6MBduIyVclcJR15XT2JgQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 16F99306005C;
        Wed, 27 Nov 2019 02:58:03 -0500 (EST)
Date:   Wed, 27 Nov 2019 08:58:02 +0100
From:   Greg KH <greg@kroah.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 4.19 2/3] media: siano: Use kmemdup instead of
 duplicating its function
Message-ID: <20191127075802.GA1822469@kroah.com>
References: <20191127072210.30715-1-lee.jones@linaro.org>
 <20191127072210.30715-2-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191127072210.30715-2-lee.jones@linaro.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 27, 2019 at 07:22:09AM +0000, Lee Jones wrote:
> From: Wen Yang <wen.yang99@zte.com.cn>
> 
> [ Upstream commit 0f4bb10857e22a657e6c8cca5d1d54b641e94628 ]
> 
> kmemdup has implemented the function that kmalloc() + memcpy().
> We prefer to kmemdup rather than code opened implementation.
> 
> This issue was detected with the help of coccinelle.
> 
> Signed-off-by: Wen Yang <wen.yang99@zte.com.cn>
> CC: Tomoki Sekiyama <tomoki.sekiyama@gmail.com>
> CC: linux-kernel@vger.kernel.org
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/media/usb/siano/smsusb.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/media/usb/siano/smsusb.c b/drivers/media/usb/siano/smsusb.c
> index 3071d9bc77f4..38ea773eac97 100644
> --- a/drivers/media/usb/siano/smsusb.c
> +++ b/drivers/media/usb/siano/smsusb.c
> @@ -225,10 +225,9 @@ static int smsusb_sendrequest(void *context, void *buffer, size_t size)
>  		return -ENOENT;
>  	}
>  
> -	phdr = kmalloc(size, GFP_KERNEL);
> +	phdr = kmemdup(buffer, size, GFP_KERNEL);
>  	if (!phdr)
>  		return -ENOMEM;
> -	memcpy(phdr, buffer, size);
>  
>  	pr_debug("sending %s(%d) size: %d\n",
>  		  smscore_translate_msg(phdr->msg_type), phdr->msg_type,
> -- 
> 2.24.0
> 

Why does this patch qualify for stable inclusion?


