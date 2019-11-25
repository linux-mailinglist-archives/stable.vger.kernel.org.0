Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5EB108F94
	for <lists+stable@lfdr.de>; Mon, 25 Nov 2019 15:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727752AbfKYOIW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Nov 2019 09:08:22 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:42803 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727716AbfKYOIW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Nov 2019 09:08:22 -0500
Received: by mail-oi1-f193.google.com with SMTP id o12so13148990oic.9;
        Mon, 25 Nov 2019 06:08:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UI6/+Qy1/ozY837ZiVV/rwFL/3CAShOLxfI+zVnajZ8=;
        b=WnRP4OCz2R/9RwdtD/5N+CSxdwTpvyhsPJXr0pXCc677NsLUE2UFk7R7FolmEjmLOG
         MW+UfOLAN+nafKj/hrLt9M4JIC/tW7ryY8aj/lsbUyB8LR8ZTOhcQugF3QlLvus8X1Xp
         +mKHBAYoG3qU5xQ6FSqFc1wd4YoOOjUKGgGtWpNYeDC9DZ9kDesDLitqXJUnhN9d2ldi
         tPpZqlQo7MJ/kJz1/rsso8kNHliEBlv9JP+RZ4/hgAx7C6I9VsntBocJBj+XVJIeX5ap
         aDA+FPZnegZXk5r5BQc147A+KEIqHkuMDV2zLpjyCZ0Hz7MNq5wEUtyzMZpkT8Cduhv8
         hEBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UI6/+Qy1/ozY837ZiVV/rwFL/3CAShOLxfI+zVnajZ8=;
        b=QySZRZ+I9vH5kp6Aa/ftH+5gWsQkioZypkk3U4PUekdwSPijqpfLSBXRxpRdvxWQwQ
         c1DHlmh16KznRstBlaebUJmc8lPZ2EEkX7+Bso2dBLeL4MMbZjm1dWPhifTjZ/pdgMrz
         YpHWWKojZEQIDoqV8bp5Qo8He3e0zRcJUyUCBhWg5hD5LIto0jqGipjtQcEuFayHKKKl
         Gj+R+9hZoaz/WQmeW9XIw4YA1L+S1M9mjHb+6Db2xEb02ofwrGYwB3Xdx9bU/QaYgEMK
         T7eH0/FNpgIuzb8NKaSZ2bDtz1RJ9/+p1ILwz/I4M9xpKs85pTHBRl21QrXkF9H+Dyt2
         Stdg==
X-Gm-Message-State: APjAAAVw2HYsNyIhiC/fgIYUDFKh8uUObhJGm/b8jrNlqitXVY3Q64bx
        nyJZQeRDUH5epK+fs05t/wKvM/ox
X-Google-Smtp-Source: APXvYqzfOJkxScn8yONmxK45qSyx+ZW4f6Js4Dpv88xujk2hRsF2k665HQKgCn/htnATWNpVuKIcCw==
X-Received: by 2002:aca:dd84:: with SMTP id u126mr21814245oig.90.1574690900902;
        Mon, 25 Nov 2019 06:08:20 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h132sm2451722oif.44.2019.11.25.06.08.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 25 Nov 2019 06:08:20 -0800 (PST)
Subject: Re: [PATCH 4.4 000/159] 4.4.203-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, linux-tegra <linux-tegra@vger.kernel.org>
References: <20191122100704.194776704@linuxfoundation.org>
 <f0f505ae-5113-1abd-d4f7-0c3535c83de4@nvidia.com>
 <20191122133931.GA2033651@kroah.com> <20191122134131.GA2050590@kroah.com>
 <20191122134627.GB2050590@kroah.com>
 <9f976044-2dbc-6c19-11e7-210cd7ab35ea@nvidia.com>
 <a5d68f07-5f9a-2809-404d-bcd8ca593d70@roeck-us.net>
 <7edc9531-347e-9ac7-2583-5efb49acffdb@nvidia.com>
 <20191125094116.GA2340170@kroah.com>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <db428001-f6b5-3132-2d93-ef04f67078dc@roeck-us.net>
Date:   Mon, 25 Nov 2019 06:08:17 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191125094116.GA2340170@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/25/19 1:41 AM, Greg Kroah-Hartman wrote:
> On Sun, Nov 24, 2019 at 08:31:46PM +0000, Jon Hunter wrote:
>>
>> On 23/11/2019 15:46, Guenter Roeck wrote:
>>> On 11/22/19 6:48 AM, Jon Hunter wrote:
>>>
>>> [ ... ]
>>>
>>>> Error: arch/arm/boot/dts/omap5-board-common.dtsi:636.1-6 Label or path
>>>> dwc3 not found
>>>> FATAL ERROR: Syntax error parsing input tree
>>>> scripts/Makefile.lib:293: recipe for target
>>>> 'arch/arm/boot/dts/omap5-igep0050.dtb' failed
>>>> make[1]: *** [arch/arm/boot/dts/omap5-igep0050.dtb] Error 1
>>>> arch/arm/Makefile:338: recipe for target 'dtbs' failed
>>>> make: *** [dtbs] Error 2
>>>>
>>>>
>>>> This is caused by the following commit ...
>>>>
>>>> commit d0abc07b3d752cbe2a8d315f662c53c772caed0f
>>>> Author: H. Nikolaus Schaller <hns@goldelico.com>
>>>> Date:   Fri Sep 28 17:54:00 2018 +0200
>>>>
>>>>       ARM: dts: omap5: enable OTG role for DWC3 controller
>>>>
>>>
>>> On top of the breakage caused by this patch, I would also argue
>>> that it is not a bug fix and should not have been included
>>> in the first place.
>>>
>>> The dwc3 label was added with commit 4c387984618fe ("ARM: dts: omap5:
>>> Add l4 interconnect hierarchy and ti-sysc data"). Given the size of
>>> that patch, I highly doubt that a backport to 4.4 would work.
> 
> Good catch, I have now dropped both of these patches and pushed out a
> -rc3
> 
>> FYI ... I am still seeing a build failure because of this with -rc2 ...
> 
> Can you see if -rc3 is also giving you problems?
> 

For v4.4.202-157-g2576206c30b5:

Build results:
	total: 170 pass: 170 fail: 0
Qemu test results:
	total: 324 pass: 324 fail: 0

Guenter
