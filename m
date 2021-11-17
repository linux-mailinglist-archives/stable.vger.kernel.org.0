Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A45BD45404B
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 06:41:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbhKQFoT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 00:44:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbhKQFoT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Nov 2021 00:44:19 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15DC4C061570;
        Tue, 16 Nov 2021 21:41:21 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id y12so5410273eda.12;
        Tue, 16 Nov 2021 21:41:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fr3VLJskTOFKiVvw+yCtoxoTKRIP3uOfB1n4lVeIfU8=;
        b=CdUFCGxzlVrC0dwHVsxuLDE0z2SIRLMVUFvANEa8mgM79gc9RndkcUtLxxJy9jkuAa
         R41vEtfO2W6M6mkcF1dYhsXyQ4cTnQxksdIP+nbyUb4nOcIUosasrPpo5UiluqgEHIXg
         OzrWIA1O91ZcVGSzrqbh9sW28xpp+v/EDRETHD8wejU71svubIPvUJtkOcoDMzM7TKTM
         wgP5F2qoCTiklfeR7nmDzspb29QAR2aIBYttsUO2rnry5+pPtfjRNZj9ggM0pIG4XRFS
         6P6hSCdrKjA/M3es0YuaO+nwsF+gA4WEhS/O2j0jM5sG7gFoHTU1TkQEUaiRUo9TE+UF
         KQlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fr3VLJskTOFKiVvw+yCtoxoTKRIP3uOfB1n4lVeIfU8=;
        b=iFKZ2qA2O03QUnxqpKu9q8eA/BJitetAJMrT3xmCC2gZsSdHvd6CaX9mv6VIIl73mi
         ihTrKUhPle9VXXexUGSV5RyJ7sUa+R5ZZFvsT1f/MqEWTY8N7JOfNUbDN9qb2TivevPB
         AVD/AGu7kVBspij20zFcpCRSD8QjIRmpL2YgkCu2PjR5KImCoNEOdeESZhFpZmIWHZQm
         wFGeneX+VNTjq5f5eMLyGFhoM4xQF+I3wMchY0dhiQvlpVGQtYN7lserVrO1SExrNczE
         F7XkD2p+ahOCz+zZJRkU0QGbNYO/0ABYMRutDpDInuCsgGqmvq8am/mxHE2BYE4X5Gvc
         XdDw==
X-Gm-Message-State: AOAM532lvL9tM2wI8HTw/r1Mgd9sSZ2EUfvDhf67rBY5rvNVcLoPXxb0
        PqAWtnaKPGla47ZJed4v6kQH0q+qXlLqy+X6pl8LO5LoDQyNgQ==
X-Google-Smtp-Source: ABdhPJxFplkvrFJ+i8rRMovYTGSGeeJ7l49S5Qp2DVFGl6MpnYUDigwncH5xqCS2tNSqQXf/FHUOIIWK2zGwP/QdNcw=
X-Received: by 2002:a05:6402:40d3:: with SMTP id z19mr10230413edb.185.1637127678508;
 Tue, 16 Nov 2021 21:41:18 -0800 (PST)
MIME-Version: 1.0
References: <20211116142631.571909964@linuxfoundation.org> <4ef11d86-28f6-69c8-ed79-926d39bdc13d@gmail.com>
In-Reply-To: <4ef11d86-28f6-69c8-ed79-926d39bdc13d@gmail.com>
From:   Scott Bruce <smbruce@gmail.com>
Date:   Tue, 16 Nov 2021 21:41:07 -0800
Message-ID: <CAPOoXdHjqm=9K5BHc8p48NEf0jzZ92yiZZFQwmhGMxcTAX020w@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/927] 5.15.3-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/16/21 13:59, Scott Bruce wrote:
> On 11/16/21 07:01, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 5.15.3 release.
>> There are 927 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Thu, 18 Nov 2021 14:24:22 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>     https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.3-rc2.gz
>>
>> or in the git tree and branch at:
>>     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>> linux-5.15.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
>>
>
> Regression found on x86-64 AMD (ASUS GA503QR, Cezanne platform)
> somewhere between 7f9a9d5d9983 and 5.15.3-rc1. The very early -rc1 tag
> from a day and a half ago boots fine, -rc1 final and -rc2 boot into a
> kernel panic during init.
>
> Unfortunately I can't gather any useful debug info from the panic as the
> relevant bits are instantly pushed off the screen by rest of the dump.
>
> Here's what I'm left with on screen after the panic, hopefully someone
> can get something useful out of it:
> https://photos.app.goo.gl/6FrYPfZCY6YdnPDz6
>
> I'll bisect and try to narrow this down some today but I'm running
> builds on my laptop while I work so it won't be super quick.
>
> Scott

Reverting c3fc9d9e8f2dc518a8ce3c77f833a11b47865944 "x86: Fix
__get_wchan() for !STACKTRACE" resolves this issue.

With this revert in place 5.15.3-rc2 boots successfully with no dmesg
regressions on my AMD Cezanne laptop, I'll wait for actual use
tomorrow to leave a proper
tested by.

Scott
