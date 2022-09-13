Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70BE85B6749
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 07:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbiIMFZI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 01:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbiIMFZH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 01:25:07 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64D431B780;
        Mon, 12 Sep 2022 22:25:05 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id y3so24945010ejc.1;
        Mon, 12 Sep 2022 22:25:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date;
        bh=CYG+gCQrNaZX712OWhKDDc9oytVFjJznZ+Wqaxz+G2w=;
        b=eVBAQtKp8A6UusDfiUzUBOJBjzt0eDI9jd+RDy1VOKE3bpFzyvN9sCDjp4892H8yE8
         rDyIGGPMEaavoDFn7s4RYBonGnUkfmHLOZM1DXMphXTjMjaeLoyfGeiKsp/En+dwtwJx
         Qi0ZeA2SWLgXxPGQ6YhVcmsxleI7umGfoTW9dHWiL6qzWzkROh+WSYwTHv1C02SfywKl
         KUMPgYTi8HRbB4Dzk5Y6noG8dMbJUQPteSlMGtAS2uxeR7bbRwf8I8/Ywc9FFH10OTC/
         d700nf8ZgqSN0NJ2K1g9mVJlIeKGzShU873PFhhOGimJeb2Hz2n1qLr4/3c8PuXPa9q8
         pPNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date;
        bh=CYG+gCQrNaZX712OWhKDDc9oytVFjJznZ+Wqaxz+G2w=;
        b=aPYGQ8gN5ZBjR5wZ1YyN6FiFmBQf1B+zy5WsL5xLSfJOyngQGmzs8FyL6zbxAGbu8Y
         YGToMoiF8jSz7FIvlWm5J0R8o3IUKrLdezG7iswXhlU7fPUDG1E9abuOIbA54Pnxxqx/
         VYvqEIfQjdCKjqJPJ/juzSAKkz56SWLliw0/wq7RYwFpGUXfp2tky7cXA1a9CKd87gGo
         V2f/MkMdP9LENyu42cCHWd1SdKzTVaLn2kLZPiUmwKHwSsKUiLDnoPyKL5v0Dfkc8yTZ
         +1mO5lTMPVMVeLYZoZeix5dDtBlMNe2DlSV3PEgRUQUWuPA990CoaRJjeJ+P3NChnf2s
         /IMQ==
X-Gm-Message-State: ACgBeo07q/1jF7STnsTIMom3Nvi50aZo5gaJnzOXHN9HaYpCypCk4Ds5
        vl6ks+UgaaqUM+TO7Jl4IzbjzTIKqKQ=
X-Google-Smtp-Source: AA6agR5zAa3oSAhpnAjqb9RISRRQDjjY4Oz0nWxMzo/2HvJrrULrbQuhYQ7u9bdsmtdwbkGgbc1C+g==
X-Received: by 2002:a17:907:2cd2:b0:770:8363:1f38 with SMTP id hg18-20020a1709072cd200b0077083631f38mr20181284ejc.381.1663046703828;
        Mon, 12 Sep 2022 22:25:03 -0700 (PDT)
Received: from [192.168.26.149] (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id tl1-20020a170907c30100b0077fde38993asm624953ejc.152.2022.09.12.22.25.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Sep 2022 22:25:03 -0700 (PDT)
Message-ID: <df6751b4-32cb-4bad-07e1-c0ad8a852f25@gmail.com>
Date:   Tue, 13 Sep 2022 07:25:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:96.0) Gecko/20100101
 Thunderbird/96.0
Subject: Re: [PATCH 0/1] mtd: mtdpart: Fix cosmetic print
To:     Adrian Zaharia <Adrian.Zaharia@windriver.com>,
        linux-mtd@lists.infradead.org
Cc:     miquel.raynal@bootlin.com, richard@nod.at, vigneshr@ti.com,
        jani.nurminen@windriver.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20220825060407.335475-1-Adrian.Zaharia@windriver.com>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
In-Reply-To: <20220825060407.335475-1-Adrian.Zaharia@windriver.com>
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

Hi,

On 25.08.2022 08:04, Adrian Zaharia wrote:
> The print of the MTD partitions during boot are off-by-one for the size.
> This patch fixes this issue and shows the real last offset.
> 
> Jani Nurminen (1):
>    mtd: mtdpart: Fix cosmetic print
> 
>   drivers/mtd/mtdpart.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> base-commit: 072e51356cd5a4a1c12c1020bc054c99b98333df

this cover latter (0/1) is rather useless. Doesn't say anything more
than actual (and the only) patch 1/1.
