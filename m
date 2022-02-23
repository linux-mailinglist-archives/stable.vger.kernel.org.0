Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38ADA4C1AEF
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 19:30:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243752AbiBWSa0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Feb 2022 13:30:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236852AbiBWSa0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Feb 2022 13:30:26 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A93A045AE4;
        Wed, 23 Feb 2022 10:29:58 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id g1so16190027pfv.1;
        Wed, 23 Feb 2022 10:29:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=SkZuVNW5EhwJqSpZnaByyGJdLCPW7Ju2zPYGUOXsjqM=;
        b=dC5HMCo5K4kF82jU3P9MGgHYmjD3SgZHQBVNL8r+3dcbwmwSC9FQKBkqvwUDKNSIp1
         MEJXGQh9ZvlPZlPWjKdxsCvDCNJ9CF/6kZTPmNfEU9zMdR7ip8su2U1QLXEkj+uZ0Jdl
         2LIt4R6GhXnT6bo77+ag2StqHl6/Wc/CKcePtMk8lgWmY7INuVg1XBlwFI7py58WhosU
         T3ETmSugjcBdc7g0NTMlrTOu/e5m1qXcbYXgJT1VCavksgHjRjqvKYyV01YZMLj1l5Ej
         lSsJ6sPdEzh1zrKnvYQa1ctRd5vPshfZS06bFcoNE1QEIpXoq3z7Fpw8j5DCOmo+IYPs
         3+vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=SkZuVNW5EhwJqSpZnaByyGJdLCPW7Ju2zPYGUOXsjqM=;
        b=sf2xsP8uIHKMxP/A+mP54ZLPnEHHf3O23u/u/JrHX+gjlqvjMl8dCBWqmVonRPrdts
         b+ZsBBVh6aus4pKGTKPBT/ZzCJmvSHW517YU+Sy+4+bsbZiJeAaTPeyeu4zeuKSUmNzW
         p5yomj4r3PNoSUEbXNIT2R+xq4LrFuo6bW/YLu4JDbP7iTnXRBkjy86MQnhQ7oZA/KND
         3ADcGjWnDvXgAuR27OxfrHbgL8MghsO/Dk7CMi85v7fb0ULcnrQdGdQ6CnfciiBJfhdM
         ss8qRNbzedOWJRt/kIK5J+UBrfR9rBjWUS/r/HU+f0xyej+y5PNvMRv52CPDfdobg4Bj
         zwEQ==
X-Gm-Message-State: AOAM533niuAwbb1S+RdVBZEPM4o2CzMIHZhAzrsf1yntg8Dp2zfmdtC0
        ZCf4Acgd4/BoxNs92WqofvU=
X-Google-Smtp-Source: ABdhPJw/aMkWYOkacTh9GK6zrN6Pxp+9MvTli2gOQggpOzRKne7hPDI4EZw1xVpdukjvOB118IG5Lg==
X-Received: by 2002:a05:6a00:198f:b0:4e1:abfd:43cc with SMTP id d15-20020a056a00198f00b004e1abfd43ccmr1069614pfl.20.1645640998104;
        Wed, 23 Feb 2022 10:29:58 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id u25sm224039pfh.46.2022.02.23.10.29.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Feb 2022 10:29:57 -0800 (PST)
Message-ID: <0a1d6269-62b2-ebd4-f302-efe14ffa4b66@gmail.com>
Date:   Wed, 23 Feb 2022 10:29:55 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH RESEND stable 4.9] mtd: rawnand: brcmnand: Fixed incorrect
 sub-page ECC status
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, sashal@kernel.org,
        david regan <dregan@mail.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Brian Norris <computersforpeace@gmail.com>,
        "open list:NAND FLASH SUBSYSTEM" <linux-mtd@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20220223174431.1083-1-f.fainelli@gmail.com>
 <20220223174431.1083-3-f.fainelli@gmail.com> <YhZ0vZxlp1VTgNG8@kroah.com>
 <325bb69b-691b-3c61-9578-d42ec33277b8@gmail.com> <YhZ70pTGdGoPEMUb@kroah.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <YhZ70pTGdGoPEMUb@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2/23/2022 10:24 AM, Greg KH wrote:
> On Wed, Feb 23, 2022 at 09:54:59AM -0800, Florian Fainelli wrote:
>>
>>
>> On 2/23/2022 9:54 AM, Greg KH wrote:
>>> On Wed, Feb 23, 2022 at 09:44:31AM -0800, Florian Fainelli wrote:
>>>> From: david regan <dregan@mail.com>
>>>>
>>>> commit 36415a7964711822e63695ea67fede63979054d9 upstream
>>>>
>>>> The brcmnand driver contains a bug in which if a page (example 2k byte)
>>>> is read from the parallel/ONFI NAND and within that page a subpage (512
>>>> byte) has correctable errors which is followed by a subpage with
>>>> uncorrectable errors, the page read will return the wrong status of
>>>> correctable (as opposed to the actual status of uncorrectable.)
>>>>
>>>> The bug is in function brcmnand_read_by_pio where there is a check for
>>>> uncorrectable bits which will be preempted if a previous status for
>>>> correctable bits is detected.
>>>>
>>>> The fix is to stop checking for bad bits only if we already have a bad
>>>> bits status.
>>>>
>>>> Fixes: 27c5b17cd1b1 ("mtd: nand: add NAND driver "library" for Broadcom STB NAND controller")
>>>> Signed-off-by: david regan <dregan@mail.com>
>>>> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
>>>> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
>>>> Link: https://lore.kernel.org/linux-mtd/trinity-478e0c09-9134-40e8-8f8c-31c371225eda-1643237024774@3c-app-mailcom-lxa02
>>>> [florian: make patch apply to 4.14, file was renamed]
>>>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>>>> ---
>>>>    drivers/mtd/nand/brcmnand/brcmnand.c | 2 +-
>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> Why is this a RESEND?  What happened with the first set?
>>
>> I forgot to copy stable and you and Sasha, wanted to make it clear to the
>> MTD folks why this is being resent.
> 
> But this commit is already in the 4.14.268 and 4.19.231 release, why do
> we need to add it again?

We don't, sorry I got an email that the patch failed to apply and forgot 
to check 4.19 and 4.14 thinking they would not be there.

>  > For 4.9 we need the backport, I'll take that one...

Thanks!
-- 
Florian
