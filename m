Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF08835AEE6
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 17:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234392AbhDJPq0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 11:46:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234334AbhDJPqZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Apr 2021 11:46:25 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14639C06138A;
        Sat, 10 Apr 2021 08:46:11 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id v19-20020a0568300913b029028423b78c2dso20502ott.8;
        Sat, 10 Apr 2021 08:46:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language;
        bh=KU0WavPCi7USSurej2fEyQxwkfN+CeSd8HSNyBxxRbk=;
        b=gfikdfykR/1Mg62pEqBL0/C+jDj6PVBbX5fIZ97w0MW14HEjE8qiTP3rBqyx5ruGY0
         aVyl9lLis/dcf/pHYdzqlccFj+wg67H3cMDzifhjIR3N1RO5H4YuFIc6La1e3gh6FcYw
         MPRxMjJff0FHFASbR2BgDaiqC6auXzjKu+48Q7jw+NZV2GVKz7BAxhDnb45qwYWIJmQn
         mkBK5cJn0zGs7ExISax0L939vzfAxqQ0t3NTH73r1Qox0Qj8PTbyZ9MPXSK9hq1Df0SD
         NcdAicajfAr+UtZnM7u36dQ3+3bmzFKy0mLM6taOqrEdXvuGxbaYA1MRNsYUte9LBJcs
         bmgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language;
        bh=KU0WavPCi7USSurej2fEyQxwkfN+CeSd8HSNyBxxRbk=;
        b=ibGGvOYJiUO+VYOPPk52+ZePRUsnDNDnEnKvZhGBTC/5AA5a8wyi+gzuffbG1iOsU/
         +yrU414VVnA1mpVaWIw/K9btC/nt09Y8PR68Xq3Qo5G+fxBh9msasQUxyUJSumhob1Os
         pQl3cBZ/2vefz0xPnmjFIxQOSd4H0w7LLRfZK+3uG5ZlEFslp6kpcwRj26QBUAyEVamF
         xZT9TsQ/54/A0/cAZ/Q7LR8IQCd4hQMtvcxGqaI7vr1ttv6S6snkK/5lBH013ROYlpWt
         1kEJSs+utvnKRs5288JNlI4cwcxyq7S75FHXsTCoMBNafA9dugLGFFwMMVasMc/US3qm
         HdzA==
X-Gm-Message-State: AOAM532Gt4L40ZtYDV5Jb0+c5yjk4jqRVzl90ElewDBiLDAJ5OGGoyXh
        VKJZ5VLAuEllA5VCUJiulQSCsPfQBHE=
X-Google-Smtp-Source: ABdhPJxe9ar0mjrxZsysD6RNuuthVxhL9LlbaKn/M8WbRsz+lwiLXXtq7W5+IGEhK/uM5i5xH4eWeg==
X-Received: by 2002:a05:6830:2083:: with SMTP id y3mr10056937otq.73.1618069569970;
        Sat, 10 Apr 2021 08:46:09 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p3sm1147767oif.53.2021.04.10.08.46.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 10 Apr 2021 08:46:09 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: [PATCH 4.14 00/14] 4.14.230-rc1 review
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-stable <stable@vger.kernel.org>
References: <20210409095300.391558233@linuxfoundation.org>
 <20210409201306.GC227412@roeck-us.net>
 <CA+G9fYuB5wgnoa4Q7Ag5XW+HSKeXKRFOtScQ3m6OZGLEnBs0dQ@mail.gmail.com>
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
Message-ID: <a7421119-3e6d-bdb9-5fba-eef3c9b89b43@roeck-us.net>
Date:   Sat, 10 Apr 2021 08:46:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CA+G9fYuB5wgnoa4Q7Ag5XW+HSKeXKRFOtScQ3m6OZGLEnBs0dQ@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------5A5AFD6F6AE5D5D1AFA574D9"
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a multi-part message in MIME format.
--------------5A5AFD6F6AE5D5D1AFA574D9
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

On 4/10/21 2:21 AM, Naresh Kamboju wrote:
> On Sat, 10 Apr 2021 at 01:43, Guenter Roeck <linux@roeck-us.net> wrote:
>>
>> On Fri, Apr 09, 2021 at 11:53:25AM +0200, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 4.14.230 release.
>>> There are 14 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Sun, 11 Apr 2021 09:52:52 +0000.
>>> Anything received after that time might be too late.
>>>
>>
>> Build results:
>>         total: 168 pass: 168 fail: 0
>> Qemu test results:
>>         total: 408 pass: 408 fail: 0
>>
>> Tested-by: Guenter Roeck <linux@roeck-us.net>
>>
>> Having said this, I did see a spurious crash, and I see an unusual warning.
>> I have seen the crash only once, but the warning happens with every boot.
>> These are likely not new but exposed because I added network interface
>> tests. This is all v4.14.y specific; I did not see it in other branches.
>> See below for the tracebacks. Maybe someone has seen it before.
> 
> I do not notice these warnings.
> Please share the testing environment / device / setup / network interfaces
> and Kernel configs and steps to reproduce.
> 
>  - Naresh
> 

Hi Naresh,

the configuration is based on aspeed_g5_defconfig (see attached configuration file)
and the following qemu command line (qemu v5.2):

qemu-system-arm -M romulus-bmc -kernel \
	arch/arm/boot/zImage -no-reboot \
	-initrd rootfs-armv5.cpio -nic user -nodefaults \
	--append "panic=-1 slub_debug=FZPUA rdinit=/sbin/init console=ttyS4,115200 earlycon=uart8250,mmio32,0x1e784000,115200n8" \
	-dtb arch/arm/boot/dts/aspeed-bmc-opp-romulus.dtb \
	-nographic -monitor null -serial stdio

It also happens with other bmc platforms using the same network interface, though
it is for some reason more prevalent on romulus-bmc.

The root file system is generated with buildroot. See buildone.sh / buildall.sh
in branch local-2021.02 of git@github.com:groeck/buildroot.git. The warning happens
with almost every boot; the crash in maybe one of 5-10 boots. The test, if you want
to call it that, uses udhcpc to get an IP address and then

net_test_successful=0
ifconfig eth0 2>/dev/null | grep -q "inet addr:10.0.2.15"
if [ $? -eq 0 ]; then
    ping -q -c 1 -s 1000 -W 1 -I eth0 10.0.2.2 >/dev/null
    if [ $? -eq 0 ]; then
	telnet 10.0.2.2:22 </dev/null >/dev/null 2>dev/null
	if [ $? -eq 0 ]; then
	    net_test_successful=1
	fi
    fi
fi

See package/busybox/run.sh in the above repository/branch.

Guenter

--------------5A5AFD6F6AE5D5D1AFA574D9
Content-Type: application/gzip;
 name="defconfig.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="defconfig.gz"

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
--------------5A5AFD6F6AE5D5D1AFA574D9--
