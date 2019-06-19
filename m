Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 650524BDC0
	for <lists+stable@lfdr.de>; Wed, 19 Jun 2019 18:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726109AbfFSQKW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jun 2019 12:10:22 -0400
Received: from linuxlounge.net ([88.198.164.195]:34154 "EHLO linuxlounge.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725843AbfFSQKW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Jun 2019 12:10:22 -0400
X-Greylist: delayed 491 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Jun 2019 12:10:20 EDT
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxlounge.net;
        s=mail; t=1560960128;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp:autocrypt:autocrypt;
        bh=Ujr3SGWwolYYbNyZ7XPeBIp6gIMbzVP7DHNPDTCIwus=;
        b=YHeZPiJaifw4YYCSKs+695Mib/e7DjqNF/xdkiodF4fA7bgen9xdXeesTorUbj7oaMw4sz
        qPYRwDa8Oi3ldgtWSyQJUQJPTTK0NcRnrzOYoTmKHuEXtW21ReCt6lQYe79joJ5W1dLjJw
        dZzLKGkyZYwc7FO7s/dPihzowpRjBYY=
References: <20190609164127.843327870@linuxfoundation.org>
 <20190609164131.760341489@linuxfoundation.org>
From:   Martin Weinelt <martin@linuxlounge.net>
Openpgp: preference=signencrypt
Autocrypt: addr=martin@linuxlounge.net; prefer-encrypt=mutual; keydata=
 mQENBEv1rfkBCADFlzzmynjVg8L5ok/ef2Jxz8D96PtEAP//3U612b4QbHXzHC6+C2qmFEL6
 5kG1U1a7PPsEaS/A6K9AUpDhT7y6tX1IxAkSkdIEmIgWC5Pu2df4+xyWXarJfqlBeJ82biot
 /qETntfo01wm0AtqfJzDh/BkUpQw0dbWBSnAF6LytoNEggIGnUGmzvCidrEEsTCO6YlHfKIH
 cpz7iwgVZi4Ajtsky8v8P8P7sX0se/ce1L+qX/qN7TnXpcdVSfZpMnArTPkrmlJT4inBLhKx
 UeDMQmHe+BQvATa21fhcqi3BPIMwIalzLqVSIvRmKY6oYdCbKLM2TZ5HmyJepusl2Gi3ABEB
 AAG0J01hcnRpbiBXZWluZWx0IDxtYXJ0aW5AbGludXhsb3VuZ2UubmV0PokBWAQTAQoAQgIb
 IwYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4ACGQEWIQTu0BYCvL0ZbDi8mh+9SqBSj2PxfgUC
 W/RuFQUJEd/znAAKCRC9SqBSj2PxfpfDCACDx6BYz6cGMiweQ96lXi+ihx7RBaXsfPp2KxUo
 eHilrDPqknq62XJibCyNCJiYGNb+RUS5WfDUAqxdl4HuNxQMC/sYlbP4b7p9Y1Q9QiTP4f6M
 8+Uvpicin+9H/lye5hS/Gp2KUiVI/gzqW68WqMhARUYw00lVSlJHy+xHEGVuQ0vmeopjU81R
 0si4+HhMX2HtILTxoUcvm67AFKidTHYMJKwNyMHiLLvSK6wwiy+MXaiqrMVTwSIOQhLgLVcJ
 33GNJ2Emkgkhs6xcaiN8xTjxDmiU7b5lXW4JiAsd1rbKINajcA7DVlZ/evGfpN9FczyZ4W6F
 Rf21CxSwtqv2SQHBuQENBEv1rfkBCADJX6bbb5LsXjdxDeFgqo+XRUvW0bzuS3SYNo0fuktM
 5WYMCX7TzoF556QU8A7C7bDUkT4THBUzfaA8ZKIuneYW2WN1OI0zRMpmWVeZcUQpXncWWKCg
 LBNYtk9CCukPE0OpDFnbR+GhGd1KF/YyemYnzwW2f1NOtHjwT3iuYnzzZNlWoZAR2CRSD02B
 YU87Mr2CMXrgG/pdRiaD+yBUG9RxCUkIWJQ5dcvgrsg81vOTj6OCp/47Xk/457O0pUFtySKS
 jZkZN6S7YXl/t+8C9g7o3N58y/X95VVEw/G3KegUR2SwcLdok4HaxgOy5YHiC+qtGNZmDiQn
 NXN7WIN/oof7ABEBAAGJATwEGAEKACYCGwwWIQTu0BYCvL0ZbDi8mh+9SqBSj2PxfgUCW/Ru
 GAUJEd/znwAKCRC9SqBSj2PxfpzMCACH55MVYTVykq+CWj1WMKHex9iFg7M9DkWQCF/Zl+0v
 QmyRMEMZnFW8GdX/Qgd4QbZMUTOGevGxFPTe4p0PPKqKEDXXXxTTHQETE/Hl0jJvyu+MgTxG
 E9/KrWmsmQC7ogTFCHf0vvVY3UjWChOqRE19Buk4eYpMbuU1dYefLNcD15o4hGDhohYn3SJr
 q9eaoO6rpnNIrNodeG+1vZYG1B2jpEdU4v354ziGcibt5835IONuVdvuZMFQJ4Pn2yyC+qJe
 ekXwZ5f4JEt0lWD9YUxB2cU+xM9sbDcQ2b6+ypVFzMyfU0Q6LzYugAqajZ10gWKmeyjisgyq
 sv5UJTKaOB/t
Cc:     Dan Carpenter <dan.carpenter@oracle.com>, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 45/83] staging: vc04_services: prevent integer
 overflow in create_pagelist()
Message-ID: <c069dac7-7416-78af-80fd-e8836c76c82d@linuxlounge.net>
Date:   Wed, 19 Jun 2019 18:02:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
In-Reply-To: <20190609164131.760341489@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi.

On 6/9/19 6:42 PM, Greg Kroah-Hartman wrote:
> From: Dan Carpenter <dan.carpenter@oracle.com>
> 
> commit ca641bae6da977d638458e78cd1487b6160a2718 upstream.

This commit breaks the kernel build because the vchiq_pagelist_info
struct is not defined in v4.9.182.

It was only added in v4.10, in commit
4807f2c0e684e907c501cb96049809d7a957dbc2.


Best regards,

Martin Weinelt


In file included from ./include/uapi/linux/posix_types.h:4:0,
                 from ./include/uapi/linux/types.h:13,
                 from ./include/linux/compiler.h:224,
                 from ./include/linux/linkage.h:4,
                 from ./include/linux/kernel.h:6,
                 from
drivers/staging/vc04_services/interface/vchiq_arm/vchiq_2835_arm.c:34:
drivers/staging/vc04_services/interface/vchiq_arm/vchiq_2835_arm.c: In
function 'create_pagelist':
./include/linux/stddef.h:7:14: warning: return makes integer from
pointer without a cast [-Wint-conversion]
 #define NULL ((void *)0)
              ^
drivers/staging/vc04_services/interface/vchiq_arm/vchiq_2835_arm.c:385:10:
note: in expansion of macro 'NULL'
   return NULL;
          ^~~~
drivers/staging/vc04_services/interface/vchiq_arm/vchiq_2835_arm.c:391:12:
error: invalid application of 'sizeof' to incomplete type 'struct
vchiq_pagelist_info'
     sizeof(struct vchiq_pagelist_info)) /
            ^~~~~~
In file included from ./include/uapi/linux/posix_types.h:4:0,
                 from ./include/uapi/linux/types.h:13,
                 from ./include/linux/compiler.h:224,
                 from ./include/linux/linkage.h:4,
                 from ./include/linux/kernel.h:6,
                 from
drivers/staging/vc04_services/interface/vchiq_arm/vchiq_2835_arm.c:34:
./include/linux/stddef.h:7:14: warning: return makes integer from
pointer without a cast [-Wint-conversion]
 #define NULL ((void *)0)
              ^
drivers/staging/vc04_services/interface/vchiq_arm/vchiq_2835_arm.c:394:10:
note: in expansion of macro 'NULL'
   return NULL;
          ^~~~


> 
> The create_pagelist() "count" parameter comes from the user in
> vchiq_ioctl() and it could overflow.  If you look at how create_page()
> is called in vchiq_prepare_bulk_data(), then the "size" variable is an
> int so it doesn't make sense to allow negatives or larger than INT_MAX.
> 
> I don't know this code terribly well, but I believe that typical values
> of "count" are typically quite low and I don't think this check will
> affect normal valid uses at all.
> 
> The "pagelist_size" calculation can also overflow on 32 bit systems, but
> not on 64 bit systems.  I have added an integer overflow check for that
> as well.
> 
> The Raspberry PI doesn't offer the same level of memory protection that
> x86 does so these sorts of bugs are probably not super critical to fix.
> 
> Fixes: 71bad7f08641 ("staging: add bcm2708 vchiq driver")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/staging/vc04_services/interface/vchiq_arm/vchiq_2835_arm.c |    9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> --- a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_2835_arm.c
> +++ b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_2835_arm.c
> @@ -381,9 +381,18 @@ create_pagelist(char __user *buf, size_t
>  	int run, addridx, actual_pages;
>          unsigned long *need_release;
>  
> +	if (count >= INT_MAX - PAGE_SIZE)
> +		return NULL;
> +
>  	offset = (unsigned int)buf & (PAGE_SIZE - 1);
>  	num_pages = (count + offset + PAGE_SIZE - 1) / PAGE_SIZE;
>  
> +	if (num_pages > (SIZE_MAX - sizeof(PAGELIST_T) -
> +			 sizeof(struct vchiq_pagelist_info)) /
> +			(sizeof(u32) + sizeof(pages[0]) +
> +			 sizeof(struct scatterlist)))
> +		return NULL;
> +
>  	*ppagelist = NULL;
>  
>  	/* Allocate enough storage to hold the page pointers and the page
> 
