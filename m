Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 974455B68C1
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 09:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbiIMHh1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 03:37:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbiIMHhZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 03:37:25 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F269A57E2E;
        Tue, 13 Sep 2022 00:37:23 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id v16so25422620ejr.10;
        Tue, 13 Sep 2022 00:37:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date;
        bh=lzCjj4e1n9t9IQqzlLuW7nZyRLt7gzrz/oqLfcOYBJo=;
        b=QAyx8P59UPICELew93zou/RH2Ml+kd2I7MRmcDtbbz5eEhudPk6ezVT+I4rqcvHjzh
         EOALXHwNQ9hS9s0FcwvkO5KKVQX89qNB6JvTFWH6sR1LvndNJdnAIpk3gI0JW5ULodRN
         PSPMEytd8qxx7RNmAAjZFKClYbIMnMg2qEEyjzbofj9QZG1NVKF5rJAT4KqMKjUSqytu
         0t4boLURlDeJeGGqhqx/gvDmt1hUvuIPqYzpimRO3WhY1p4P1RGWWdq+LT9svwh7sSm5
         PlHEcx5TEHIZPx/Vpl9iSWWla9mpXgvV3hqn56VBIcwI7ptul60KYlG4cfLqj3toTz2Q
         51Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date;
        bh=lzCjj4e1n9t9IQqzlLuW7nZyRLt7gzrz/oqLfcOYBJo=;
        b=A0pZprJ5K2pe10L35eQppCw12rsXsfxrc/14eXsOK2cSgVuM+YAkQZEjCgIme0NnlL
         qHrYvf9xs0S2SFCPQo2fyZ/mnT1NnPxiZaTBKdX60EP0txj0OMsTIzt98Z5I5ucdbyDF
         UsbcFvA/8KVRnmsq+V0gPW9GRs3rBKWAZdCF09fQOauWm8zlviEkkZ9EBW4gCRPIf6RX
         MW4Jilbdu5vG4QZzw3tB6qmOur2Y5rZHi4F4vGRWSncyUCK2Q2rDoor9p0ITdvHwoWEH
         wWfLbMdayNjP+m5eUXcqYsTgcfuesiGWUVIZloUGWJOkm9VYzn7+e9iWV+lOK5PNnKTh
         jSlg==
X-Gm-Message-State: ACgBeo0qNU3e1uQzyK9a5bfPn0DOVuQ1QyiVs6x6efKjtYvoWQ0Ywbjl
        9NLn1runTSrHOSnqRYqq4NQ=
X-Google-Smtp-Source: AA6agR5F+AIP1OradTbq3GgwPQDWo1ENqpICuNDTzLf0vNAx5BDUiZAweHJLerxTyQ+7k7Lsc/IvXg==
X-Received: by 2002:a17:907:6e0b:b0:73d:5850:ca15 with SMTP id sd11-20020a1709076e0b00b0073d5850ca15mr21398115ejc.344.1663054642389;
        Tue, 13 Sep 2022 00:37:22 -0700 (PDT)
Received: from [192.168.26.149] (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id e17-20020a170906249100b00778e3e2830esm191067ejb.9.2022.09.13.00.37.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Sep 2022 00:37:21 -0700 (PDT)
Message-ID: <43059215-aa56-e8c5-53a4-143643058797@gmail.com>
Date:   Tue, 13 Sep 2022 09:37:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:96.0) Gecko/20100101
 Thunderbird/96.0
Subject: Re: [PATCH 1/1] mtd: mtdpart: Fix cosmetic print
To:     Adrian Zaharia <Adrian.Zaharia@windriver.com>,
        linux-mtd@lists.infradead.org
Cc:     miquel.raynal@bootlin.com, richard@nod.at, vigneshr@ti.com,
        jani.nurminen@windriver.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20220825060407.335475-1-Adrian.Zaharia@windriver.com>
 <20220825060407.335475-2-Adrian.Zaharia@windriver.com>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
In-Reply-To: <20220825060407.335475-2-Adrian.Zaharia@windriver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 25.08.2022 08:04, Adrian Zaharia wrote:
> From: Jani Nurminen <jani.nurminen@windriver.com>
> 
> The print of the MTD partitions during boot are off-by-one for the size.
> Fix this and show the real last offset.

I see that PCI subsystem and printk() + %pR do that. Probably more. I
guess it makes sense but I'm also wondering if/how confusing is that
change going to be for users. We did printing like that for probably
dozens of years.


> Fixes: 3d6f657ced2b ("mtd: mtdpart: Fix cosmetic print")

I can't find that hash / commit anywhere. Are you sure it exists?


> Signed-off-by: Jani Nurminen <jani.nurminen@windriver.com>
> Signed-off-by: Adrian Zaharia <Adrian.Zaharia@windriver.com>
> ---
>   drivers/mtd/mtdpart.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/mtd/mtdpart.c b/drivers/mtd/mtdpart.c
> index d442fa94c872..fab10e6d4171 100644
> --- a/drivers/mtd/mtdpart.c
> +++ b/drivers/mtd/mtdpart.c
> @@ -118,7 +118,7 @@ static struct mtd_info *allocate_partition(struct mtd_info *parent,
>   		child->part.size = parent_size - child->part.offset;
>   
>   	printk(KERN_NOTICE "0x%012llx-0x%012llx : \"%s\"\n",
> -	       child->part.offset, child->part.offset + child->part.size,
> +	       child->part.offset, child->part.offset + child->part.size - 1,
>   	       child->name);
>   
>   	/* let's do some sanity checks */

