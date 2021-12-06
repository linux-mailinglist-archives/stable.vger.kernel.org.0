Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFF1346AB1B
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 22:57:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350171AbhLFWA6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 17:00:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356707AbhLFWAs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 17:00:48 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA01FC0613F8
        for <stable@vger.kernel.org>; Mon,  6 Dec 2021 13:57:17 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id e128so14720466iof.1
        for <stable@vger.kernel.org>; Mon, 06 Dec 2021 13:57:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OyafP4fjpdN34kgQVAiLgkpt+hsgmiNoBpXe5qIk5dI=;
        b=Y5yOiSFADCfW2LI2mLLA4SLbf3U9K6VUWiR3ZdkW+t+71C5BX+S7CAaollxVpij1CP
         eNf69P9ViPvuUwvPDYLk30dHkxJVu1D4wwlFX7aps20FPCbK68uMbtHBQPFpVFyCPLpR
         GqSS2guPpQ+gmtz84qSSxi8NMdtTDlDUroniE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OyafP4fjpdN34kgQVAiLgkpt+hsgmiNoBpXe5qIk5dI=;
        b=M5GE91oaGQXzKRzrhHnA6+XpImDV8G/qm2Ey+alrb11/Ds/zVv1s8zxwnGK6pkan4o
         EQIa4TxkimrCaPZ2T8vnDmqSNVC3YadWzXLVHKob9nVssWRqr/tLeji/JQDyZg5YuYr+
         6fbR0TqK1C7U3D9IobvT9PGZ8rZJU+pF6f14J8i1wNfSthN28Qq8rMJiaONW3p2Qk0Ve
         vAvuK0SVZpvnlZDtkGrXBMFGD4acQ95Cuyv34hCLRCko9XUHT+TY+92/B1ePJIM/QiVU
         F116+JLgqlrftKLrQhwhSzBIMFawYR4p/n0BqKjDudL7JQ5i7+AxU++6piMxxorJ0MVo
         SZiA==
X-Gm-Message-State: AOAM533Yu0wzW3fKTFZ2QmMBVWqjI6rWm7OhVRTPLlkmQIEfOoeO9GgI
        SGm6YkAAeHGmF7NuQCenNnu6Jg==
X-Google-Smtp-Source: ABdhPJwKM/ePpvOwrKsQ0YuSr579BbqdBY5kML/iHqOomEPgjfO83r3NVcVeAC/kKti3ZxWWTkDArA==
X-Received: by 2002:a6b:3b43:: with SMTP id i64mr38045487ioa.182.1638827837258;
        Mon, 06 Dec 2021 13:57:17 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id r12sm7472971iln.72.2021.12.06.13.57.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Dec 2021 13:57:17 -0800 (PST)
Subject: Re: [PATCH 4.19 00/48] 4.19.220-rc1 review
To:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211206145548.859182340@linuxfoundation.org>
 <20211206193811.GB11359@duo.ucw.cz>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <8fb68763-43e1-5d66-0bfe-1a15581bbbb5@linuxfoundation.org>
Date:   Mon, 6 Dec 2021 14:57:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211206193811.GB11359@duo.ucw.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/6/21 12:38 PM, Pavel Machek wrote:
> Hi!
> 
>> This is the start of the stable review cycle for the 4.19.220 release.
>> There are 48 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
> 
> CIP testing did not find any problems here:
> 
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-4.19.y
> 
> Tested-by: Pavel Machek (CIP) <pavel@denx.de>
> 
> Best regards,
>                                                                  Pavel
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
