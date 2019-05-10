Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2658E19E68
	for <lists+stable@lfdr.de>; Fri, 10 May 2019 15:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727727AbfEJNn4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 May 2019 09:43:56 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:35927 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727247AbfEJNnz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 May 2019 09:43:55 -0400
Received: by mail-pl1-f196.google.com with SMTP id d21so2885576plr.3;
        Fri, 10 May 2019 06:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=MFzl1fQrtuoWibRLm4kbP1gPY0qwI9/jaf8DipreLmU=;
        b=FYO1NIM3BfCw7samzLgtsqQ6Hxc0Zs/Mect7gTZY53WxdLEJT9ZR3iVHx9Igtxm+vC
         sRmUTUGr+GVlg9JfLen2l89m1CUMJYGyU59O2ByUzVA8XEgUNUedh5NJLckBZOD2oB4n
         SMlTOo2q/3/yVEmUYQty3i/CU5PM00156BtYUyq29Hmh0DCW803Uw8EybXqyn/yRb0XJ
         71+ZNG7jvAghM8vS7Oh245qCzwnvVzNLb+4/c4SKiDxrfSu1u+kQOz1daXeuaoOwl41M
         pwMdvPaoercWhPlZqoRi8upa2xw6IJmwIHJDi0rTZ719L4R0aAPGZMZW5dxrKVHO8qiX
         V37A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=MFzl1fQrtuoWibRLm4kbP1gPY0qwI9/jaf8DipreLmU=;
        b=mHBHTtpgsbD8rwqZAtwtW9GNu/zM1tn7ftZpj0PReidbNihq6kNSitsurQzXe6qxe2
         gYXwU/fiRdh2crNVo/hiUjst7d7ka1YlfwDmZigwjk91wkiyQa+yaE8a8xv7oXGNw9Cv
         cmwdfT2cRlA/jgaEha97TktT0hTg6JLlULN5EbXdqlQQ+nOwyUtlMWmHF/YaZRvqNFYy
         JPUbHd1qM4+ZrJCO1w+khcbsQaa4lVKV694nousdZyesNT6gSEZGX2y12K9XNwcHOVZL
         1bJ0RxHF4r8OfydE8ecAOVurA/dxBlNAPcjzsl2dr761U2rIlb1iDMcxRbo9dU4ngbwB
         VFEg==
X-Gm-Message-State: APjAAAU51J9jHk6t4audZ4bU6Y2t1UL4TYUOLjlJNnoxQh/vhxfXR3NT
        aHCMlrrOWi6vCj+SsrAlNuk/dYTkblY=
X-Google-Smtp-Source: APXvYqxU8iZXoP9Oe7KD13k+NmlIgobn7tMxDfpv2uoLmIkr4S+P8nO/mrutIjvEXYoEjrJ5O+PPdQ==
X-Received: by 2002:a17:902:5ac9:: with SMTP id g9mr13074173plm.134.1557495830150;
        Fri, 10 May 2019 06:43:50 -0700 (PDT)
Received: from [192.168.1.7] ([117.248.70.207])
        by smtp.gmail.com with ESMTPSA id x66sm7315309pfb.78.2019.05.10.06.43.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 May 2019 06:43:49 -0700 (PDT)
Subject: Re: [PATCH 5.0 00/95] 5.0.15-stable review
To:     Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20190509181309.180685671@linuxfoundation.org>
 <411e19b0-7f02-a1e3-e1b6-1ff9ca4e1145@roeck-us.net>
From:   Vandana BN <bnvandana@gmail.com>
Message-ID: <58ff150d-31b6-a393-c3e4-77a8e72462b1@gmail.com>
Date:   Fri, 10 May 2019 19:13:43 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <411e19b0-7f02-a1e3-e1b6-1ff9ca4e1145@roeck-us.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 10/05/19 7:06 PM, Guenter Roeck wrote:
> On 5/9/19 11:41 AM, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 5.0.15 release.
>> There are 95 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Sat 11 May 2019 06:11:22 PM UTC.
>> Anything received after that time might be too late.
>>
>
> Build results:
>     total: 159 pass: 159 fail: 0
> Qemu test results:
>     total: 349 pass: 349 fail: 0
>
> Guenter

compiled booted and no regressions on my system.

Thanks,

vandana

