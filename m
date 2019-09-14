Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2A0FB2B90
	for <lists+stable@lfdr.de>; Sat, 14 Sep 2019 16:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728533AbfINOQs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Sep 2019 10:16:48 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:34063 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727661AbfINOQs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Sep 2019 10:16:48 -0400
Received: by mail-pf1-f193.google.com with SMTP id b128so925465pfa.1;
        Sat, 14 Sep 2019 07:16:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8dZQWJRyjWIwi4RxaO9m8wBOO2EfU7kHLgPwca7x4SU=;
        b=f5uh+r6DSEsxp1R3fdF8M/11BwpSz5lf5pmr1C0kYssDmcWaI42ZrODyT/3UimJSwl
         Yoru3oj3juzSuzjvIx+dtl4Eovd6owdKVP3W9HTyIjOCmo7aNO8tEHmOsVjCicyr4tkM
         KGQ2lliQVNnZ75iualeIdqIa6E/wCIsoMIZRISqkZC3O8+lUbeHn5Hv/wdvIhuVkxCVO
         Mlx/NMdWhRtW6jVmMLIViI3t0OUxiEGz6GB7zM14XqBwOZKbFtyIZAGmm7gqu7o6O+83
         dChWsP1fldOqizOaSoJTqY2odi6SLrWiSIBYFEYkU9vIH3kFkNZhr6Borfwf7I6Usij3
         zz/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8dZQWJRyjWIwi4RxaO9m8wBOO2EfU7kHLgPwca7x4SU=;
        b=BOGV34aXKPxHJdw7dq1UNTAEvLVOjAkW6lRLjWi6LuT0NhckoMZH9sB8VJN0XlZd9F
         UXFJGc314hIu/ZYs9zSedQeuivYf/sTg/NWshDmHOUr/2zijBdMfcisGBbhitsqSD31i
         2Uc1P9YV44oSV87qynV2YGyQK9+rbC4w4UkrhMH0u29ppLPqpJTd5ScwVnhXJeiP/qdi
         /dreMIgvJanWOlRGDV54hzgz10KMIcF+MV5ddNh084M+rD5EDZE5mnLw4JHScEVDw2aB
         Xrek2RE1wPSBGux1EM0C51Ubp6wpTmQKQoQnObQU8PnWK15r1Cugr2uwesbgXyt1YKzU
         R3Uw==
X-Gm-Message-State: APjAAAXw1hdf+Pg0vXNWkpIyn+0CLzVMW6zgghpi8A+IYrgVSKEUGjLk
        zxciFB7w5vjMjXIE1FdEUm5vG0Jg
X-Google-Smtp-Source: APXvYqy/8x3PYri6R5u0vzIJ7adOjDdTeW8v6AcWUARSQAz4TlAZBQ0VVc+wphzbnEK3nrOrVHr/Qw==
X-Received: by 2002:a65:6254:: with SMTP id q20mr11788338pgv.423.1568470607384;
        Sat, 14 Sep 2019 07:16:47 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n185sm26959458pga.16.2019.09.14.07.16.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 14 Sep 2019 07:16:46 -0700 (PDT)
Subject: Re: [PATCH 4.9 00/14] 4.9.193-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20190913130440.264749443@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <f287565d-63fd-4cb6-714a-780260d6c977@roeck-us.net>
Date:   Sat, 14 Sep 2019 07:16:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190913130440.264749443@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/13/19 6:06 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.193 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun 15 Sep 2019 01:03:32 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 172 pass: 168 fail: 4
Failed builds:
	arm:allmodconfig
	i386:allyesconfig
	i386:allmodconfig
	mips:allmodconfig
Qemu test results:
	total: 356 pass: 356 fail: 0

Guenter
