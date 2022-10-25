Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A21960CDAC
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 15:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232907AbiJYNha (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 09:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232793AbiJYNhM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 09:37:12 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A72BF1956F4;
        Tue, 25 Oct 2022 06:37:08 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id g130so14124612oia.13;
        Tue, 25 Oct 2022 06:37:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5jYA4CRt7QwFxQ2WJSL+6qpHoqAMY4yfe7v64iFTEeg=;
        b=KMv+Ujbtf9SE9T3fWLARgIMD8dbNUhfiDS39mJbUVKWDXSkcfY17IW89WFcRZi1/YC
         fSSRRIbACOz6R3JKItclWb9tEY/GClRIlEFt4ybhrL4YZ5YaKsEmAwfyEobi8mI/yjZe
         uHMejs5tRKWe1U1Ko2LFB60OSVUGL0RJKhbo9omuEYfIFy7SXMX6oRWri/hCZR2SRYlA
         G5j+shdwHTAyzGGAcG5XPmIEhOD/iklVUHI7KVAZgnWkPpS7cNKTG8oWSyINMZkHivw3
         iiQwEpj4SEmukIZiS9GdSYD3DtueSQT1jUQNd//LNQZ7xJ2l1GLSF0pYpJEcc+DQZZE0
         fjWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5jYA4CRt7QwFxQ2WJSL+6qpHoqAMY4yfe7v64iFTEeg=;
        b=kakDwEtAvJFpaG0h45HOyuoU/H68PkHpl8p8+J307tWc1FHhJVPpQJkBuEy/MBhiIU
         Z2aIah0Oyukq4QFO3l8RNuIgioKGfau1bOmRg49/w12UFs15Bm0es5lxQsNrQRsNYv77
         AjYfCf8mAxmc4IjMzrZoLyW8g6YpC/dgzUEFXVBcs+BQYSw8KAPe5bC1iD2OGlpP1XWC
         e0lp5KqrAiEcutxId6qIjQonmZwLSbjQ5UG55/RKXxjlT4X36K2C0OMsFTZkALEtkZop
         Kqqzl0m1jj+q0rDh+sjwiI8a/VpFINv42EDM6drxlOYPCFA88VtBP9xLL6g5q2Xp82Yj
         EFBw==
X-Gm-Message-State: ACrzQf3o19ONjFUdo37D25Bbr5iw7zxpC5e0eq6I8CFb2Zj1FazBRCtg
        vs+n1atqg9oqE53fpwIGDmiXkozHG0k=
X-Google-Smtp-Source: AMsMyM5WKNa9inG277X3WE+Hxvew5Iq1MaPP04sOO3fCVaaTKDsT4e9kpQ4vtyQvvbEj6fjBB87kGQ==
X-Received: by 2002:a05:6870:d79b:b0:130:f29c:b54c with SMTP id bd27-20020a056870d79b00b00130f29cb54cmr22926276oab.125.1666705016366;
        Tue, 25 Oct 2022 06:36:56 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i11-20020a54408b000000b00354b575424csm938403oii.29.2022.10.25.06.36.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Oct 2022 06:36:55 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <5373483d-adde-2884-6017-75f3bd25d6bc@roeck-us.net>
Date:   Tue, 25 Oct 2022 06:36:52 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Content-Language: en-US
To:     Christian Bach <christian.bach@scs.ch>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
References: <ZR0P278MB0773545F02B32FAF648F968AEB319@ZR0P278MB0773.CHEP278.PROD.OUTLOOK.COM>
 <ZR0P278MB0773072DD153BA902AFE635AEB319@ZR0P278MB0773.CHEP278.PROD.OUTLOOK.COM>
 <Y1fYjmtQZa53dPfR@kroah.com>
 <ZR0P278MB077321F8565A4FF929B132A1EB319@ZR0P278MB0773.CHEP278.PROD.OUTLOOK.COM>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Re: AW: tcpci module in Kernel 5.15.74 with PTN5110 not working
 correctly
In-Reply-To: <ZR0P278MB077321F8565A4FF929B132A1EB319@ZR0P278MB0773.CHEP278.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 10/25/22 05:48, Christian Bach wrote:
> Thank you for answering. I did try a Kernel from 1 year ago (11. December 2020 - with the Hash b5206275b46c30a8236feb34a1dc247fa3683d83). But this Kernel had the exact same behavior.
> I even wanted to go back further the when the tcpm module got it's own subdirectory (v4.20 - 20. September 2018 - Hash ae8a2ca8a2215c7e31e6d874f7303801bb15fbbc) to see if it still worked at that time but my build system was not able to build it.
> 

Greg asked for you to test with a v5.4.y kernel. ae8a2ca8a221..b5206275b46c30a82
is again a pretty large step with more than 100 commits in the drivers/usb/typec/tcpm/
directory.

Also, it might be useful to provide the respective kernel logs.

Thanks,
Guenter

> -----Ursprüngliche Nachricht-----
> Von: Greg KH <gregkh@linuxfoundation.org>
> Gesendet: Dienstag, 25. Oktober 2022 14:38
> An: Christian Bach <christian.bach@scs.ch>
> Cc: stable@vger.kernel.org; regressions@lists.linux.dev; linux@roeck-us.net; linux-usb@vger.kernel.org
> Betreff: Re: tcpci module in Kernel 5.15.74 with PTN5110 not working correctly
> 
> [You don't often get email from gregkh@linuxfoundation.org. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> 
> On Tue, Oct 25, 2022 at 12:19:39PM +0000, Christian Bach wrote:
>> Hello
>>
>> For a few weeks now I am trying to make the PTN5110 chip work with the new Kernel 5.15.74. The same hardware setup was working with the 4.19.72 Kernel. The steps I took so far are as follows:
> 
> That is a huge jump.  Why not use 'git bisect'?
> 
> Or start with a smaller jump.  Why not go to 5.4.y first, that's only a year's worth of changes, instead of 4 years of changes.
> 
> thanks,
> 
> greg k-h

