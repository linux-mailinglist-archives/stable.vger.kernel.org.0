Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25BA9B2A7C
	for <lists+stable@lfdr.de>; Sat, 14 Sep 2019 10:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbfINIjY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Sep 2019 04:39:24 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33684 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726313AbfINIjY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Sep 2019 04:39:24 -0400
Received: by mail-pg1-f194.google.com with SMTP id n190so16571937pgn.0;
        Sat, 14 Sep 2019 01:39:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MFBj5Xpt4eX33W4LGNmdyfPk2/8Ey1tboMZgwQx+h30=;
        b=aDoMKQflAcyUyhsvqbZu2m7kB2fXM7OYswWp9+0YVx4fAqxvk052jB3dhIL1Ujy4Qa
         ovyeja0MDqKjXd9MNKU+Q5fD04uFAjP5XTAsdjImiXaWgx60knHqGtsjNj4NhvyAKoPh
         m0QWVGIPnMkhOAzgV2K4Gv4b5b6Xn23hrpZgNvMzLtrS8ZVFG6GPm9xTwcmQRTCYO8uy
         XhJrb9CFytfdmnfuAH98x918EPtIVWrcK0k4O2bB5Fc6jlukTm103WKSEygg8gyPRMHE
         vZ7rkPn863XWORMAL7t/pQmkDZA4ywGWTIbwdH6vp/pnTSaixKwR5BdOGbQ0isl14eLx
         LObw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MFBj5Xpt4eX33W4LGNmdyfPk2/8Ey1tboMZgwQx+h30=;
        b=bXvcgX2VUlK5T9PiuzznMkIYYbqefSU9xyHSqwtnytbs6hFmnlBJEMCEYqO57S0KAg
         rFFJwhaP/sygY351aG6QzUewwDNecinNCxRGFg4wrmloPBBvoiixb8dkeEhrXF3GFFmX
         4KMK7T4hCbWUDDAYWsW8OT/Id91JEx8vejwZJX8yrWLm4AfC4MRSaQ/Z74iMoRXJdUEk
         r2Yqbn1YTh3G/aIEQP4oS0/GJUtF5NOJVuky1cO/97LinDOcTM/QSjZ0DVYK2cXvTttR
         +0UhqMp6ZGZMmhu0uvfwtuYSZnydFG64ukjcj8EHNb0OXNcFAAfRFPNBtbEJz/QnE46K
         D0TQ==
X-Gm-Message-State: APjAAAV/mgX0b1KjFq0/lqvrTTnaMdWI9ZllQ73+kNvuZpyay0Cnrfcq
        pa3htbPM6le5XVQApuOPGEQOVM6K
X-Google-Smtp-Source: APXvYqyPhp+EV1suabAlDOxqi/WA0A9DHYdQqTBrc4KmHBgQigdEbpx57Iq3wBerYu0q09i7JIkl4A==
X-Received: by 2002:a65:64c4:: with SMTP id t4mr43929079pgv.298.1568450363993;
        Sat, 14 Sep 2019 01:39:23 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k4sm4210996pjl.9.2019.09.14.01.39.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 14 Sep 2019 01:39:23 -0700 (PDT)
Subject: Re: [PATCH 4.9 00/14] 4.9.193-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
References: <20190913130440.264749443@linuxfoundation.org>
 <aefa6832-073e-493c-8576-5b2f06e714fb@roeck-us.net>
 <20190914083126.GA523517@kroah.com>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <e2e978d3-38a0-a845-53f9-3634b14b43bf@roeck-us.net>
Date:   Sat, 14 Sep 2019 01:39:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190914083126.GA523517@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/14/19 1:31 AM, Greg Kroah-Hartman wrote:
> On Sat, Sep 14, 2019 at 01:28:39AM -0700, Guenter Roeck wrote:
>> On 9/13/19 6:06 AM, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 4.9.193 release.
>>> There are 14 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Sun 15 Sep 2019 01:03:32 PM UTC.
>>> Anything received after that time might be too late.
>>>
>>
>> Is it really only me seeing this ?
>>
>> drivers/vhost/vhost.c: In function 'translate_desc':
>> include/linux/compiler.h:549:38: error: call to '__compiletime_assert_1879' declared with attribute error: BUILD_BUG_ON failed: sizeof(_s) > sizeof(long)
>>
>> i386:allyesconfig, mips:allmodconfig and others, everywhere including
>> mainline. Culprit is commit a89db445fbd7f1 ("vhost: block speculation
>> of translated descriptors").
> 
> Nope, I just got another report of this on 5.2.y.  Problem is also in
> Linus's tree :(
> 

Sending a fix in a minute. I'll copy you and Linus.

Guenter
