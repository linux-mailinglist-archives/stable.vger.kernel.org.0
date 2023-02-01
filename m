Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8FD6686EDD
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 20:24:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbjBATYb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Feb 2023 14:24:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbjBATYa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Feb 2023 14:24:30 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C9BB82407
        for <stable@vger.kernel.org>; Wed,  1 Feb 2023 11:24:29 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id m2so54025453ejb.8
        for <stable@vger.kernel.org>; Wed, 01 Feb 2023 11:24:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=poo4tsXckRFrYwGi5N8FZZfjWRpt0+is5KS+2Zd2Jt4=;
        b=eZmHGchBgXT3XVl46I30x59CAAK9BnGHOTL7cH0wURQ7y2u9DkSeK/rk+X/NE3a/3R
         poQcPwA6LnrsElUxwy56FMgUopmbSaJk9h+sxFvEtgqiwikuNfooHjItZViIGdDuQRRF
         QPTM6itx2CYNA9ayOy9cak0ST3l8IdOYnucgPO4OTvC1UE+D4+/mjM72NqIp0gMLEhEI
         EKFCqaH1+N0h1EsU4Y27h9QOiYDeVLOie5O5BkL1MO9FPRsxYIj2zDG7GL3/LpU/biwg
         FfCuZ2dKkFRH1l7uzsZf2Tml2EU6UMHZJ2xQblL+0rxxcqZakrui+0aNk+f/w/57mnRr
         zT0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=poo4tsXckRFrYwGi5N8FZZfjWRpt0+is5KS+2Zd2Jt4=;
        b=plvcy+Ra6sM7jUm19z+YQdndh0EygvIoDO220OhUKwsDo35GL2LqyHzcFkrlYX4opI
         oCZurHOAoO3VQsTypyCVi4y9/PNlqIz0aTg4UGTkarUr9hDrCcTbFUUa+SEodyplJzQD
         LaMmboryMaXn4gbXGs3EwL/4n82HYinm6J2B4fkIfUy8xcayH1ya8BJsxaC0UL5DKnzO
         2ifEa6jirg7b6Y3Hpqwz6ru1jM4lddNRtLj+zFNnk+DbzWTtETPLWd5cll+S7sQxl+at
         Aisfclaqmpeg5jslLHqbaxWRrm/sDNpNLM1daFCnWhCrk/ezt3mYQUsnRLNBxTt3kkUs
         7XVw==
X-Gm-Message-State: AO0yUKXH05X90SpcrQeNVV0gT9tCZ1O3p51Pr2NAIoCCcM1Gd2r1uU1S
        JcSLmt84Ke7C7JNcNxHPCeU=
X-Google-Smtp-Source: AK7set/ctkKx13DC24Sh9RE3eedTVbueLsS2BP/eQ/OqhYUA24xbDfbRYX1nrp86sIKkzDH3VDi8dw==
X-Received: by 2002:a17:906:7fd8:b0:87b:d376:b850 with SMTP id r24-20020a1709067fd800b0087bd376b850mr3430008ejs.10.1675279467864;
        Wed, 01 Feb 2023 11:24:27 -0800 (PST)
Received: from [192.168.178.20] (host-95-250-162-30.retail.telecomitalia.it. [95.250.162.30])
        by smtp.gmail.com with ESMTPSA id v24-20020a1709067d9800b008857fe10c5csm6458308ejo.126.2023.02.01.11.24.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Feb 2023 11:24:26 -0800 (PST)
Message-ID: <7a8a4290-eb81-a848-8386-c080523fb3bd@gmail.com>
Date:   Wed, 1 Feb 2023 20:24:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
Subject: Re: [Nouveau] [PATCH] nouveau: explicitly wait on the fence in
 nouveau_bo_move_m2mf
To:     Lyude Paul <lyude@redhat.com>, Greg KH <gregkh@linuxfoundation.org>
Cc:     Salvatore Bonaccorso <carnil@debian.org>, stable@vger.kernel.org,
        Karol Herbst <kherbst@redhat.com>,
        Ben Skeggs <bskeggs@redhat.com>, nouveau@lists.freedesktop.org
References: <20220819200928.401416-1-kherbst@redhat.com>
 <CAHSpYy0HAifr4f+z64h+xFUmMNbB4hCR1r2Z==TsB4WaHatQqg@mail.gmail.com>
 <CACO55tv0jO2TmuWcwFiAUQB-__DZVwhv7WNN9MfgMXV053gknw@mail.gmail.com>
 <CAHSpYy117N0A1QJKVNmFNii3iL9mU71_RusiUo5ZAMcJZciM-g@mail.gmail.com>
 <cdfc26b5-c045-5f93-b553-942618f0983a@gmail.com> <Y9VgjLneuqkl+Y87@kroah.com>
 <Y9V8UoUHm3rHcDkc@eldamar.lan>
 <51511ea3-431f-a45c-1328-5d1447e5169b@gmail.com> <Y9eWhGj/ecjUcYO/@kroah.com>
 <9e4cb1d818e4ce04c3e465a397e5652349e3938a.camel@redhat.com>
From:   Computer Enthusiastic <computer.enthusiastic@gmail.com>
In-Reply-To: <9e4cb1d818e4ce04c3e465a397e5652349e3938a.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Greg,

On 30/01/2023 23:27, Lyude Paul wrote:
> Thanks a ton for the help Greg!
> 
> On Mon, 2023-01-30 at 11:05 +0100, Greg KH wrote:
>> On Sun, Jan 29, 2023 at 10:36:31PM +0100, Computer Enthusiastic wrote:
>>> Hello Greg,
>>> Hello Salvatore,
>>>
>>> On 28/01/2023 20:49, Salvatore Bonaccorso wrote:
>>>> Hi Greg,
>>>>
>>>> I'm not the reporter, so would like to confirm him explicitly, but I
>>>> believe I can give some context:
>>>>
>>>> On Sat, Jan 28, 2023 at 06:51:08PM +0100, Greg KH wrote:
>>>>> On Sat, Jan 28, 2023 at 03:49:59PM +0100, Computer Enthusiastic wrote:
>>>>>> Hello,
>>>>>>
>>>>>> The patch "[Nouveau] [PATCH] nouveau: explicitly wait on the fence in
>>>>>> nouveau_bo_move_m2mf" [1] was marked for kernels v5.15+ and it was merged
>>>>>> upstream.
>>>>>>
>>>>>> The same patch [1] works with kernel 5.10.y, but it is not been merged
>>>>>> upstream so far.
>>>>>>
>>>>>> According to Karol Herbst suggestion [2], I'm sending this message to ask
>>>>>> for merging it into 5.10 kernel.
>>>>>
>>>>> We need to know the git commit id.  And have you tested it on 5.10.y?
>>>>> And why are you stuck on 5.10.y for this type of hardware?  Why not move
>>>>> to 5.15.y or 6.1.y?
>>>>
>>>> This would be commit 6b04ce966a73 ("nouveau: explicitly wait on the
>>>> fence in nouveau_bo_move_m2mf") in mainline, applied in 6.0-rc3 and
>>>> backported to 5.19.6 and 5.15.64.
>>>>
>>>> Computer Enthusiastic, tested it on 5.10.y:
>>>> https://lore.kernel.org/nouveau/CAHSpYy1mcTns0JS6eivjK82CZ9_ajSwH-H7gtDwCkNyfvihaAw@mail.gmail.com/
>>>>
>>>> It was reported in Debian by the user originally as
>>>> https://bugs.debian.org/989705#69 after updating to the 5.10.y series in Debian
>>>> bullseye.
>>>>
>>>> I guess the user could move to the next stable release Debian bookworm, once
>>>> it's released (it's currently in the last milestones to finalize, cf.
>>>> https://release.debian.org/ but we are not yet there). In the next release this
>>>> will be automatically be fixed indeed.
>>>>
>>>> Computer Enthusiastic, can you confirm please to Greg in particular the first
>>>> questions, in particular to confirm the commit fixes the suspend issue?
>>>>
>>>> Regards,
>>>> Salvatore
>>>
>>> Thanks for replaying to my request: I really appreciate.
>>>
>>> I apologize if my request was not formally correct.
>>>
>>> The upstream kernel 5.10.y hangs on suspend or fails to resume if it is
>>> suspended to ram or suspended to disk (if nouveau kernel module is used with
>>> some nvidia graphic cards).
>>>
>>> I confirm the commit ID 6b04ce966a73 (by Karol Herbst) fixes the
>>> aforementioned suspend to ram and suspend to disk issues with kernel 5.10.y
>>> . It tested it with my own computer.
>>>
>>> The last kernel version I tested is 5.10.165, that I patched and installed
>>> in Debian Stable (11.6) that I'm currently running and that I tested again
>>> today.
>>>
>>> It would be nice if the next point release of Debian Stable could ship a
>>> kernel that includes patch commit ID 6b04ce966a73 for the benefit of nouveau
>>> module users.
>>
>> Ok, I've queued it up for 5.10.y now, thanks.
>>
>> greg k-h
>>

Thank you so much.

Many thanks to Salvatore for the help and, of course, to Karl for the 
patch and to all of you who made it possible.
