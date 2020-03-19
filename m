Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9662218BAC3
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 16:15:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727878AbgCSPPp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 11:15:45 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:34078 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727540AbgCSPPp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Mar 2020 11:15:45 -0400
Received: by mail-pl1-f195.google.com with SMTP id a23so1203428plm.1;
        Thu, 19 Mar 2020 08:15:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uHJGQXmL96S+ux+ssxyQDazEjTpL8ZpuwcZafnV+i50=;
        b=m2wPsd5eU+GG5ea6yCk0HuCl3l0VDt7lz/JTfHP/yWz/o/dBKr8dimksUSh/TEmdcj
         x1tmBJ8k+NjjQZVA2C2f0W2HfjJvGL/3xHcEi6VEQvuaRFnzTaK9x6TLYKa4jzvU1rXF
         mBF1NLtFBKiUzXld3+ltumzlWwUZuNr4tjewYm+QoiO+cJ4f0jKqXrXCRyFk9hqHbZhT
         SGVx58UracaclCAz8y0mdEdWfDyYba0+2IQ7zcIIIY+bKizFiwpnjEyZ3WyrKlvnt5aG
         +gwlzL0v0qeluaZFY9bVRn8q6d4kBV6GpWO1twIxKUgmNxR+cisGU5dG/JzfLuS2zlN3
         8Pkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=uHJGQXmL96S+ux+ssxyQDazEjTpL8ZpuwcZafnV+i50=;
        b=Rjsa5HCx2XcGI3t+4z6vQwHn+/lGiDgKFI8bkGAXUembHLfiMsMvDYjDN97dQaXLPP
         rBMBDE8Od7PTSSBcEk6gCVaLq5GpQoBnFkV9qy7P9GVDl8gmoCL/Sr6baEnQJ+OaljtX
         X9mqrYRaouUKrd+DFcQvSOZbNImo3XfzHXWOH9ICQTxY2nX1qtbgJnRevLjVVlFs/fqN
         PpX/OI45TRHUoiWovg3/t3Rj8f1ccgD53rahTj+5Ewbv5w5tO6y7EM9NnENFo16SxjYk
         JpGAPacrqo1TI1RXh8ABlvrhNSY8pUPRXX05S+ISQDMgejyex1rDOLDfEuDCUxieWvDj
         3low==
X-Gm-Message-State: ANhLgQ2nVsES+4fd4ZAGtqrAUpEKbLEoKhMr9fSceH5teLHPs24guUMU
        IukI3RZhHbsPVK9SPqz83hc=
X-Google-Smtp-Source: ADFU+vvHbndJ5Ga3yWtDe/v8OSvQB/FsD3B6Tta6S+R7vdqAVBH0J9urhE3cWuAzhpwF8+xR6xALvg==
X-Received: by 2002:a17:90a:4487:: with SMTP id t7mr4326052pjg.104.1584630943565;
        Thu, 19 Mar 2020 08:15:43 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b24sm2709466pfi.52.2020.03.19.08.15.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Mar 2020 08:15:42 -0700 (PDT)
Subject: Re: [PATCH 5.5 00/65] 5.5.11-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, Kevin Hao <haokexin@gmail.com>
References: <20200319123926.466988514@linuxfoundation.org>
 <fcf6db4c-cebe-9ad3-9f19-00d49a7b1043@roeck-us.net>
 <20200319145900.GC92193@kroah.com>
From:   Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 xsFNBE6H1WcBEACu6jIcw5kZ5dGeJ7E7B2uweQR/4FGxH10/H1O1+ApmcQ9i87XdZQiB9cpN
 RYHA7RCEK2dh6dDccykQk3bC90xXMPg+O3R+C/SkwcnUak1UZaeK/SwQbq/t0tkMzYDRxfJ7
 nyFiKxUehbNF3r9qlJgPqONwX5vJy4/GvDHdddSCxV41P/ejsZ8PykxyJs98UWhF54tGRWFl
 7i1xvaDB9lN5WTLRKSO7wICuLiSz5WZHXMkyF4d+/O5ll7yz/o/JxK5vO/sduYDIlFTvBZDh
 gzaEtNf5tQjsjG4io8E0Yq0ViobLkS2RTNZT8ICq/Jmvl0SpbHRvYwa2DhNsK0YjHFQBB0FX
 IdhdUEzNefcNcYvqigJpdICoP2e4yJSyflHFO4dr0OrdnGLe1Zi/8Xo/2+M1dSSEt196rXaC
 kwu2KgIgmkRBb3cp2vIBBIIowU8W3qC1+w+RdMUrZxKGWJ3juwcgveJlzMpMZNyM1jobSXZ0
 VHGMNJ3MwXlrEFPXaYJgibcg6brM6wGfX/LBvc/haWw4yO24lT5eitm4UBdIy9pKkKmHHh7s
 jfZJkB5fWKVdoCv/omy6UyH6ykLOPFugl+hVL2Prf8xrXuZe1CMS7ID9Lc8FaL1ROIN/W8Vk
 BIsJMaWOhks//7d92Uf3EArDlDShwR2+D+AMon8NULuLBHiEUQARAQABzTJHdWVudGVyIFJv
 ZWNrIChMaW51eCBhY2NvdW50KSA8bGludXhAcm9lY2stdXMubmV0PsLBgQQTAQIAKwIbAwYL
 CQgHAwIGFQgCCQoLBBYCAwECHgECF4ACGQEFAlVcphcFCRmg06EACgkQyx8mb86fmYFg0RAA
 nzXJzuPkLJaOmSIzPAqqnutACchT/meCOgMEpS5oLf6xn5ySZkl23OxuhpMZTVX+49c9pvBx
 hpvl5bCWFu5qC1jC2eWRYU+aZZE4sxMaAGeWenQJsiG9lP8wkfCJP3ockNu0ZXXAXwIbY1O1
 c+l11zQkZw89zNgWgKobKzrDMBFOYtAh0pAInZ9TSn7oA4Ctejouo5wUugmk8MrDtUVXmEA9
 7f9fgKYSwl/H7dfKKsS1bDOpyJlqhEAH94BHJdK/b1tzwJCFAXFhMlmlbYEk8kWjcxQgDWMu
 GAthQzSuAyhqyZwFcOlMCNbAcTSQawSo3B9yM9mHJne5RrAbVz4TWLnEaX8gA5xK3uCNCeyI
 sqYuzA4OzcMwnnTASvzsGZoYHTFP3DQwf2nzxD6yBGCfwNGIYfS0i8YN8XcBgEcDFMWpOQhT
 Pu3HeztMnF3HXrc0t7e5rDW9zCh3k2PA6D2NV4fews9KDFhLlTfCVzf0PS1dRVVWM+4jVl6l
 HRIAgWp+2/f8dx5vPc4Ycp4IsZN0l1h9uT7qm1KTwz+sSl1zOqKD/BpfGNZfLRRxrXthvvY8
 BltcuZ4+PGFTcRkMytUbMDFMF9Cjd2W9dXD35PEtvj8wnEyzIos8bbgtLrGTv/SYhmPpahJA
 l8hPhYvmAvpOmusUUyB30StsHIU2LLccUPPOwU0ETofVZwEQALlLbQeBDTDbwQYrj0gbx3bq
 7kpKABxN2MqeuqGr02DpS9883d/t7ontxasXoEz2GTioevvRmllJlPQERVxM8gQoNg22twF7
 pB/zsrIjxkE9heE4wYfN1AyzT+AxgYN6f8hVQ7Nrc9XgZZe+8IkuW/Nf64KzNJXnSH4u6nJM
 J2+Dt274YoFcXR1nG76Q259mKwzbCukKbd6piL+VsT/qBrLhZe9Ivbjq5WMdkQKnP7gYKCAi
 pNVJC4enWfivZsYupMd9qn7Uv/oCZDYoBTdMSBUblaLMwlcjnPpOYK5rfHvC4opxl+P/Vzyz
 6WC2TLkPtKvYvXmdsI6rnEI4Uucg0Au/Ulg7aqqKhzGPIbVaL+U0Wk82nz6hz+WP2ggTrY1w
 ZlPlRt8WM9w6WfLf2j+PuGklj37m+KvaOEfLsF1v464dSpy1tQVHhhp8LFTxh/6RWkRIR2uF
 I4v3Xu/k5D0LhaZHpQ4C+xKsQxpTGuYh2tnRaRL14YMW1dlI3HfeB2gj7Yc8XdHh9vkpPyuT
 nY/ZsFbnvBtiw7GchKKri2gDhRb2QNNDyBnQn5mRFw7CyuFclAksOdV/sdpQnYlYcRQWOUGY
 HhQ5eqTRZjm9z+qQe/T0HQpmiPTqQcIaG/edgKVTUjITfA7AJMKLQHgp04Vylb+G6jocnQQX
 JqvvP09whbqrABEBAAHCwWUEGAECAA8CGwwFAlVcpi8FCRmg08MACgkQyx8mb86fmYHNRQ/+
 J0OZsBYP4leJvQF8lx9zif+v4ZY/6C9tTcUv/KNAE5leyrD4IKbnV4PnbrVhjq861it/zRQW
 cFpWQszZyWRwNPWUUz7ejmm9lAwPbr8xWT4qMSA43VKQ7ZCeTQJ4TC8kjqtcbw41SjkjrcTG
 wF52zFO4bOWyovVAPncvV9eGA/vtnd3xEZXQiSt91kBSqK28yjxAqK/c3G6i7IX2rg6pzgqh
 hiH3/1qM2M/LSuqAv0Rwrt/k+pZXE+B4Ud42hwmMr0TfhNxG+X7YKvjKC+SjPjqp0CaztQ0H
 nsDLSLElVROxCd9m8CAUuHplgmR3seYCOrT4jriMFBtKNPtj2EE4DNV4s7k0Zy+6iRQ8G8ng
 QjsSqYJx8iAR8JRB7Gm2rQOMv8lSRdjva++GT0VLXtHULdlzg8VjDnFZ3lfz5PWEOeIMk7Rj
 trjv82EZtrhLuLjHRCaG50OOm0hwPSk1J64R8O3HjSLdertmw7eyAYOo4RuWJguYMg5DRnBk
 WkRwrSuCn7UG+qVWZeKEsFKFOkynOs3pVbcbq1pxbhk3TRWCGRU5JolI4ohy/7JV1TVbjiDI
 HP/aVnm6NC8of26P40Pg8EdAhajZnHHjA7FrJXsy3cyIGqvg9os4rNkUWmrCfLLsZDHD8FnU
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
Message-ID: <32c627bf-0e6b-8bc4-88d3-032a69484aa6@roeck-us.net>
Date:   Thu, 19 Mar 2020 08:15:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200319145900.GC92193@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/19/20 7:59 AM, Greg Kroah-Hartman wrote:
> On Thu, Mar 19, 2020 at 07:44:33AM -0700, Guenter Roeck wrote:
>> On 3/19/20 6:03 AM, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 5.5.11 release.
>>> There are 65 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Sat, 21 Mar 2020 12:37:04 +0000.
>>> Anything received after that time might be too late.
>>>
>>
>> arm:davinci_all_defconfig fails to build.
>>
>> include/linux/gpio/driver.h: In function 'gpiochip_populate_parent_fwspec_twocell':
>> include/linux/gpio/driver.h:552:1: error: no return statement in function returning non-void [-Werror=return-type]
>>   552 | }
>>
>> The problem is caused by commit 8db6a5905e98 ("gpiolib: Add support for the
>> irqdomain which doesn't use irq_fwspec as arg") which is missing its fix,
>> commit 9c6722d85e922 ("gpio: Fix the no return statement warning"). That one
>> is missing a Fixes: tag, providing a good example why such tags are desirable.
> 
> Thanks for letting me know, I've now dropped that patch (others
> complained about it for other reasons) and will push out a -rc2 with
> that fix.
> 

I did wonder why the offending patch was included, but then I figured that
I lost the "we apply too many patches to stable releases" battle, and I didn't
want to re-litigate it.

Guenter
