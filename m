Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4E38453C07
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 22:59:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbhKPWCQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 17:02:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230467AbhKPWCP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 17:02:15 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92962C061746;
        Tue, 16 Nov 2021 13:59:17 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id w33-20020a17090a6ba400b001a722a06212so3034030pjj.0;
        Tue, 16 Nov 2021 13:59:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=SxYidUcQF/JRSeOjMS+zF5IXpdU1AyWxQh1T5sdHgXo=;
        b=AFa6UZ2QDYSmQw0ehe2r+5tWvs2jmVBk9R/zUM3vCM4cU4o+xmZPAnh80M2lcsxY7H
         BVm4l4ktmV7ip8fGeMKlNp4E0aEpmMjqLB+QphgoRBvakPsvG+MK31gzj/hATBqC7KSV
         cWLFYf/YidsqPM1naBw54/7ssupWmujuXqCE5s4vyx97SuiFwVS1bUXw8lGpcSFe/Pzo
         AqxRxXXIf3jFrgCL00zZ8QgJiAzo+OQvxOVigvXo8a1BIsWpjKYwdfuGFKL01xnAizaf
         NUf7y2qm66r3O2UHbl1mhTlzsoEtXWlqGz12fu5KD1zpcMCrSQetA3z+679bbs3qKOrv
         VYGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=SxYidUcQF/JRSeOjMS+zF5IXpdU1AyWxQh1T5sdHgXo=;
        b=rCS4Cb563BYzfwbqWkpMPL5qk0r18OoE+212CDNJkeIqCApX6prnMOktWklsfDlhLt
         MTqIrnPj4oBdXVh6bQf0lZNw879vLI1BoXtkpfhioOitRGhUYctt1Uw1YingiTRIE16n
         EnJJv69jeHHq0r6JlBNytWSnLM9f9NicJw9SUYInZw/9rKZBmuPhRVa5dK0RmJ/YYJlj
         AnrVMyqhV8HUGtU76i+zfEuvYZZsGYDuEnBfLaS2oZG2WPxmXyNQMGpltK27uvOmV+is
         UvEnoD6yZZpQawsA6lSxEvmBl206W+PHvczxU1uD0V2MsITDpScKu/TDj50po/ZAO20I
         v2cg==
X-Gm-Message-State: AOAM531XrEFIiq3yFWnVjYeG2vXPiuI14ElTst44sAtf5CjjQ8NkwDZA
        4GVatZ6vhh+NmAlMKiZa5i8=
X-Google-Smtp-Source: ABdhPJznFZdv3R0iVf5XnrBfpjS3EK+hgBZ7MQaDZd0t6sCV8VHA5pRG8/ArIWtu97PnyY+CrF3Twg==
X-Received: by 2002:a17:90b:1b4a:: with SMTP id nv10mr2892663pjb.87.1637099957157;
        Tue, 16 Nov 2021 13:59:17 -0800 (PST)
Received: from ?IPV6:2601:206:8000:2834::19b? ([2601:206:8000:2834::19b])
        by smtp.gmail.com with ESMTPSA id d6sm18751621pfh.190.2021.11.16.13.59.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Nov 2021 13:59:16 -0800 (PST)
Message-ID: <4ef11d86-28f6-69c8-ed79-926d39bdc13d@gmail.com>
Date:   Tue, 16 Nov 2021 13:59:14 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 5.15 000/927] 5.15.3-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
References: <20211116142631.571909964@linuxfoundation.org>
From:   Scott Bruce <smbruce@gmail.com>
In-Reply-To: <20211116142631.571909964@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/16/21 07:01, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.3 release.
> There are 927 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Nov 2021 14:24:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.3-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Regression found on x86-64 AMD (ASUS GA503QR, Cezanne platform) 
somewhere between 7f9a9d5d9983 and 5.15.3-rc1. The very early -rc1 tag 
from a day and a half ago boots fine, -rc1 final and -rc2 boot into a 
kernel panic during init.

Unfortunately I can't gather any useful debug info from the panic as the 
relevant bits are instantly pushed off the screen by rest of the dump.
	
Here's what I'm left with on screen after the panic, hopefully someone 
can get something useful out of it: 
https://photos.app.goo.gl/6FrYPfZCY6YdnPDz6

I'll bisect and try to narrow this down some today but I'm running 
builds on my laptop while I work so it won't be super quick.

Scott
