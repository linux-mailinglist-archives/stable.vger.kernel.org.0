Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 486E14AB0ED
	for <lists+stable@lfdr.de>; Sun,  6 Feb 2022 18:20:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244791AbiBFRUh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Feb 2022 12:20:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbiBFRUh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Feb 2022 12:20:37 -0500
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51962C043184
        for <stable@vger.kernel.org>; Sun,  6 Feb 2022 09:20:36 -0800 (PST)
Received: by mail-qv1-xf36.google.com with SMTP id g3so5112428qvb.8
        for <stable@vger.kernel.org>; Sun, 06 Feb 2022 09:20:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Hnu13BcRGddplmpUh1YzEX2nWwPlpBt573XpCqqfRXM=;
        b=jmdEcLuNUGiAknaXt/CQ/QmliWWDM94ilAD5x/JECjHNyRrKh+Bg+JQsjC4oLBDKma
         Ljf8yOXPdOjJs265K+E+Hv/WOu8kWlJVYvtbpDa92gdegkZvx20+hYm5zL9lwVBigciz
         d6L2VY2vz2a5nd0wmz0py23O9tdGohez+0OllwsxGf/hpSndjckaQzy06VYF/WOyH6mE
         Xtb9xRj6wYeGYCW5gViw7kU7QN/li56bXlpB2gf+eM1bQia9qb8dtnPdM3JCjDBzBTnD
         rYbGQZskqfXrol8QRUA0fzw90DV9wbHHzo1uhbrQUz72REyWHFWY2kdXVOGLJEK9Y+5A
         NejA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Hnu13BcRGddplmpUh1YzEX2nWwPlpBt573XpCqqfRXM=;
        b=hQaNg5jYL9EbhFCWucc4lEB4ou+IaKNpWIzKa7WkQRkMgii+8nWBdXDGNCtI7zfQZS
         bbPz5W9EjFvHJTNbBvixjylJC52HAWXcHXCNjAwx+RgqhQvMw0JDzKNyf+JxeSN/LhuN
         yplz49POnKQRnS5yK+5nu05cPejMhQfFmCfCqFBN0fhG10fdPeflg30gOJ23mVKMeCp6
         xKtJqYzB4y0bOq0VWCEQGgDQLuJaBaV+93uaRaSWOi+GOF7mSF79949B4jkCkGAzh6TB
         jz79LYBzEnW8PLEv+R3ZNsZd7AQWERAk8QKfCZp30wBLVNz4p18Pfv+5a6nQRKX/iwAU
         4xIw==
X-Gm-Message-State: AOAM5338eDDY4i15GKyjmDUQf72JyFRsqZLCH+yGCKti+miflrlxpqJI
        yT39ueu030nNVRlheF6s6i2WvLhiSg==
X-Google-Smtp-Source: ABdhPJwqyd2n63Ifl3I4CA3ERIvz+OuhYXyq/lpVcBrpRz9GTjZ0ddDPh0nUgadnp6v/9UzDWRcJnQ==
X-Received: by 2002:ad4:5dc4:: with SMTP id m4mr8212062qvh.17.1644168035499;
        Sun, 06 Feb 2022 09:20:35 -0800 (PST)
Received: from [10.1.1.242] (207-38-182-214.s3007.c3-0.wsd-cbr1.qens-wsd.ny.cable.rcncustomer.com. [207.38.182.214])
        by smtp.gmail.com with ESMTPSA id j11sm4463819qtj.74.2022.02.06.09.20.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Feb 2022 09:20:35 -0800 (PST)
Message-ID: <b3f1ab29-d46c-5d43-717f-d27f1bd852d8@gmail.com>
Date:   Sun, 6 Feb 2022 12:20:34 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: Asus Router Kernel Panics
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev,
        tech.support@broadcom.com
References: <4f5dccba-ab28-8007-bed8-f2594498c8c1@gmail.com>
 <Yf/+npr9xV2HVg9k@kroah.com>
From:   MP <fromschoollaptop@gmail.com>
In-Reply-To: <Yf/+npr9xV2HVg9k@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks for the reply. Will put pressure on Asus to properly research 
this. Their solution is\was to send a refurb unit to me... Which is not 
going to solve much of anything.. TY, enjoy the rest of the weekend all.

On 2/6/2022 12:00 PM, Greg KH wrote:
> On Sun, Feb 06, 2022 at 09:57:15AM -0500, MP wrote:
>> Hello all,
>>
>>   Just looking for a bit of guidance here and a suggestion on proper next
>> steps. I think there may be an issue within the below broadcom nand driver
>> implementation.
>>
>> I have an Asus GTE-AX11000 and it reboots\crashes multiple times a week,
>> upon inspection of snmp logging you can see the below entries, when the
>> kernel panic occurs the entire router locks up, and sometimes reboots.
>> Sometimes it doesn't reboot and the router hangs completely and drops all
>> network devices, and removes wireless SSIDs and all of your devices lose
>> their connection.
>>
>> Not sure who to turn to but Asus support has not grasped the gravity of this
>> problem and I am thinking this can only really be resolved with a
>> firmware\driver\linux update, so just hoping for some additional help or
>> guidance from this group.
> This is a very old, obsolete, and known buggy kernel version running any
> number of unknown closed source kernel modules.  Only the manufacturer
> can help you here, there is nothing the community can do at all, sorry.
>
> Best of luck!
>
> greg k-h
