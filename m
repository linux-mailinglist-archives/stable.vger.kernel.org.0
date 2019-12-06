Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1E61154DD
	for <lists+stable@lfdr.de>; Fri,  6 Dec 2019 17:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbfLFQKR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Dec 2019 11:10:17 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:37003 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726271AbfLFQKR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Dec 2019 11:10:17 -0500
Received: by mail-pl1-f195.google.com with SMTP id bb5so2901994plb.4;
        Fri, 06 Dec 2019 08:10:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FW+xoM+XNZFXfI9u3US9PFT2FKkWvrVyiLqgVBMf4T4=;
        b=NqrWjRq72uyLD5eSa13wzYR3I4iR0gzbri5rhbFtsYJ/5vd/scWgGsNyiJW1c1A2TD
         rJOSYPQ/qXszecAFohYSlb92ok8SJM5WA5Cc9ah121CgeKraqv/fbuuU75gnQSnp8q2G
         cl3S4wBxTFcQZsYn/o8GS+cpBzj8+T2zii6VuyeVKY2R+iRPcdBc9mLR46bKStnkLxF6
         1CbIpWqMHual3oiooGX09PliisjWKCBOS9TJvmrCSsosHlLqEJu/Nn9BoNgZH2rNMoWf
         Sw00iPVGdZgS9c+GjQA/YHaJgeG6wjwEm6D4hQirlSWTgfuYJ7DkyeW/IgO/iaZ1Pl5x
         G1Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FW+xoM+XNZFXfI9u3US9PFT2FKkWvrVyiLqgVBMf4T4=;
        b=j3q8IJ9jLuK4ck6D/gNgVs9+V8JGdyQVxgtV18q8mXZFHEPlnRjpJuCu57XB3KSywu
         rMXORLUfbgVzXVGCIDc6IJY++KiCL7uRMbKO/caCKg3dXTcPMx13U+CbLrxqcghr8rOB
         zNkVoAJaTIEaLqdu2jddazyez5RrnYeaXuHjslSE0muQqSIHZ5R6z8wakebgv/kio00c
         8Ps9kFGPGcjbj/XvAYXQqcYTGH3KX1fWkW0s5TVvjLZQUOe/R/Bwhj9Q1BdR0Gts4egA
         CYDCbpeucQHR0252c8stETa5B520I1XMoJ+jvT31/UqNrgN+Xqo90WfQPGjT6GqnCqhw
         SZKQ==
X-Gm-Message-State: APjAAAUmAtPK7bA2QZiZGGaeIxo5V6felmjzPk8xJtJc4I0+G8VVl2vp
        WWDoky0ufUrZlMunSQm4/pNXY0I7
X-Google-Smtp-Source: APXvYqwbbpq8kVzJk6y/sdlrcq1H+aFuZOHPXTbIWdYVfn8Cb2WMQQz9HYbDo9jaeZejghBcaq1nkg==
X-Received: by 2002:a17:902:b095:: with SMTP id p21mr15109764plr.313.1575648615981;
        Fri, 06 Dec 2019 08:10:15 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d22sm15739959pgg.52.2019.12.06.08.10.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Dec 2019 08:10:14 -0800 (PST)
Subject: Re: [PATCH 4.14 000/209] 4.14.158-stable review
To:     shuah <shuah@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20191204175321.609072813@linuxfoundation.org>
 <1dac10cd-7183-9dfd-204c-05fae75bcd74@kernel.org>
 <20191206152823.GA75339@kroah.com>
 <785c9534-1eb2-ea9b-8c9b-6713fdefdd01@kernel.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <e04a233b-0854-2dd4-060e-47e1013879ee@roeck-us.net>
Date:   Fri, 6 Dec 2019 08:10:12 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <785c9534-1eb2-ea9b-8c9b-6713fdefdd01@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/6/19 7:35 AM, shuah wrote:
> On 12/6/19 8:28 AM, Greg Kroah-Hartman wrote:
>> On Fri, Dec 06, 2019 at 08:24:36AM -0700, shuah wrote:
>>> On 12/4/19 10:53 AM, Greg Kroah-Hartman wrote:
>>>> This is the start of the stable review cycle for the 4.14.158 release.
>>>> There are 209 patches in this series, all will be posted as a response
>>>> to this one.  If anyone has any issues with these being applied, please
>>>> let me know.
>>>>
>>>> Responses should be made by Fri, 06 Dec 2019 17:50:10 +0000.
>>>> Anything received after that time might be too late.
>>>>
>>>> The whole patch series can be found in one patch at:
>>>>     https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.158-rc1.gz
>>>> or in the git tree and branch at:
>>>>     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
>>>> and the diffstat can be found below.
>>>>
>>>> thanks,
>>>>
>>>> greg k-h
>>>>
>>>
>>> Starting with Linux 4.14.157, 4.9.204, and 4.4.204 stables stopped
>>> booting on my system. It can't find the root disk. No config changes
>>> in between.
>>>
>>> I have been bisecting 4.14 and 4.9 with no luck so far. I updated
>>> to Ubuntu 19.10 in between.
>>>
>>> The only other thing I see is CONFIG_GCC_VERSION which is supported
>>> starting 4.18. I don't this boot failing issue on 4.19 + up. I am
>>> also chasing any links between this config and scripts and tools
>>> that generate the initramfs.
>>
>> Did you also upgrade your version of gcc?  I know I build those older
>> kernels with the latest version of gcc for build tests, but I do not
>> boot them.  I think everyone who still uses them uses older versions of
>> gcc.
> 
> Yes. gcc version changed. That has been my strong suspect since I started poking around the CONFIG_GCC_VERSION.
> 

What version of gcc are you using ? I currently use gcc 8.3.0 for all
qemu boot tests (except for 3.16 which doesn't support it, or at least
it didn't when I last checked), and have not observed any problems.

Thanks,
Guenter
