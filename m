Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB23D4C1A49
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 18:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235076AbiBWRza (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Feb 2022 12:55:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234110AbiBWRza (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Feb 2022 12:55:30 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F8162736;
        Wed, 23 Feb 2022 09:55:02 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id v5-20020a17090ac90500b001bc40b548f9so3245556pjt.0;
        Wed, 23 Feb 2022 09:55:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Dq2lraIciZDzd/HjyDAhppfvMrvTs3Uqdjz3uy1ukcg=;
        b=hZX24zwOTwAikIMX91EWvSTmc3hj4azwzlrBe5DoY3zZ0sgO78yJFEa9vNs8ziWtay
         VEq414kNw6DsVs0un+vEZndls2jYorbjw9DhGNwGBO4ITvUrelHkpk9cXYMn5U3AXSL1
         PczXf3R9WQSTa3yNBvMrp7e5cSC41/sDFllRWrDZ35hdXFEahK4f0wN1a8Re/n9mi/j/
         C5y+CTH3htqf/7/8v3C5OsazILtxNg/D34Ul2zfpFSXgzW/IhXO5mkhXBTaM77P5csvC
         1aR4Vv+IBE+5zH2g0SJb+xLSLOYPDeNtNQ+g52T0CgXot+fF/uO+Amoe0Kg7h/TCwriq
         WEMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Dq2lraIciZDzd/HjyDAhppfvMrvTs3Uqdjz3uy1ukcg=;
        b=oQDINTYQHpm0a9PkNjgyTX4va/9b6J4tIQ/pLy5FK6BZZ0NosLF+lVX0G5/i9hqTmj
         dno+wp0epAmjGFdmMuDYFTXPyChq+OOuzvDPvsL+Nh56OHEt51ql8IJy372+zmVFV4JS
         tHOmiZ28m1GlhhdOu27FdJguLrPzwf254hcGCw6cY0w8K2ttRJNxH/SBVEcxTfp6IdXV
         ISbXi9aU2h7sSEj8o3FqJgatkUOrtWycQu6GkgAH248cpwQWf2uFuYYjVAMk95RpLUQf
         KlpbblFboLC4VODbVnSosa8yIL1T726QrDVQ4kp/G4EhSMDkXyAGei3rDm8IDANPjSz1
         gQgg==
X-Gm-Message-State: AOAM530XioLyubh8Qx712QzfG44qBBkMRlnMSt1D5Bxuo3vqJtjSp5i2
        l092OGf5hLMIHbgFKkByluk=
X-Google-Smtp-Source: ABdhPJzgqmLhCMk9lL1zw0mhcc9V9PLsblLiFXuJIx66GOem/jOUW9+Y+o/Ln6kd4OgM5H+u+fkP1w==
X-Received: by 2002:a17:902:6acb:b0:150:c60:294a with SMTP id i11-20020a1709026acb00b001500c60294amr884052plt.71.1645638901514;
        Wed, 23 Feb 2022 09:55:01 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id k15sm152074pff.36.2022.02.23.09.55.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Feb 2022 09:55:00 -0800 (PST)
Message-ID: <325bb69b-691b-3c61-9578-d42ec33277b8@gmail.com>
Date:   Wed, 23 Feb 2022 09:54:59 -0800
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
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <YhZ0vZxlp1VTgNG8@kroah.com>
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



On 2/23/2022 9:54 AM, Greg KH wrote:
> On Wed, Feb 23, 2022 at 09:44:31AM -0800, Florian Fainelli wrote:
>> From: david regan <dregan@mail.com>
>>
>> commit 36415a7964711822e63695ea67fede63979054d9 upstream
>>
>> The brcmnand driver contains a bug in which if a page (example 2k byte)
>> is read from the parallel/ONFI NAND and within that page a subpage (512
>> byte) has correctable errors which is followed by a subpage with
>> uncorrectable errors, the page read will return the wrong status of
>> correctable (as opposed to the actual status of uncorrectable.)
>>
>> The bug is in function brcmnand_read_by_pio where there is a check for
>> uncorrectable bits which will be preempted if a previous status for
>> correctable bits is detected.
>>
>> The fix is to stop checking for bad bits only if we already have a bad
>> bits status.
>>
>> Fixes: 27c5b17cd1b1 ("mtd: nand: add NAND driver "library" for Broadcom STB NAND controller")
>> Signed-off-by: david regan <dregan@mail.com>
>> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
>> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
>> Link: https://lore.kernel.org/linux-mtd/trinity-478e0c09-9134-40e8-8f8c-31c371225eda-1643237024774@3c-app-mailcom-lxa02
>> [florian: make patch apply to 4.14, file was renamed]
>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>> ---
>>   drivers/mtd/nand/brcmnand/brcmnand.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Why is this a RESEND?  What happened with the first set?

I forgot to copy stable and you and Sasha, wanted to make it clear to 
the MTD folks why this is being resent.
-- 
Florian
