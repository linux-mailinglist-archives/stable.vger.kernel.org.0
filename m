Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79E3CB63E1
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 14:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727616AbfIRM7O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 08:59:14 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:32830 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727243AbfIRM7O (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Sep 2019 08:59:14 -0400
Received: by mail-pf1-f195.google.com with SMTP id q10so4440048pfl.0;
        Wed, 18 Sep 2019 05:59:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2KzX9yQQB2le8oqzNGc5Ap3CJZ0FDKYjjqdufeUqBKc=;
        b=p5kh6odFcDsrY5kgkQR+CK/EkOKVnG0ukHhluun66xDPpsZ9xJJddUGxFEO53HOzAW
         qQvmEE/NxKuJ7Y6cz2BFgIjyR8JVUqII9Pt1/HVIKJ4cfjRelT3LtwMOe2oSuPG/NOJy
         22s8/3T05l1c7ukuLpVGOow7GFwh2axxiph3cB/dgJsobSd+ptUV3ceIxf+xawp8FD9K
         9A6jP9JGiZHc/qmbUFQMUUR1bHycHe7Uft413cuhcus6ysVquYnuJjYLKcXUgLCcJlIv
         9pfCVqMJAFQnSw9Vdm11Lgv1+KKC2FniET87Fl3bx33w8Pl7zX9kLQTvnIz4EvS7T8ow
         68Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2KzX9yQQB2le8oqzNGc5Ap3CJZ0FDKYjjqdufeUqBKc=;
        b=r4rLUVmq0YBPmce3owpFWaYyW4VYmcA+fX2kHwVstdvFHFdPZCGqg2vReOWX25NjXO
         Z+AwLVN5p8IA3dWQJklDQQGBBcjbTAwb2CDwNu/VAW2exc4WXNnFVgScencUzj6V4KdW
         LVBa9XaRU9lHzQJ0I5qOMtcRELzXq4+y4AUJ1Xj98ZKUEK3PUWaY0l1NpG4/k4TjecRF
         xaKHDKl/3BSnxiu+ECwybz6wNjueSGAHa6CzVvQFW4muXa+8qgLSyOzSdYeuR+yWKKze
         h8g3M0puIpuMCCZieQ0aZSwhrqhM8LF0t41QZuBA4MnVb+P9WNBp50DGhqeJDyOQ0mCN
         x6hA==
X-Gm-Message-State: APjAAAXBfYMRmAfKguMI1rjGjU+y0yeE0z0OfhbFU6mANiz8XPCU2W6f
        JnBXDArDZDUMkcEHB5/kB1k5AxXQ
X-Google-Smtp-Source: APXvYqzgVVmbqhy+3up5X2+VQa7MNKjO5SdWpt4WUNzsZXkQGx9iiYDO0tOto9TSaW+VS8kSmA1iCQ==
X-Received: by 2002:a17:90a:a393:: with SMTP id x19mr3594539pjp.91.1568811552874;
        Wed, 18 Sep 2019 05:59:12 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j9sm5755655pff.128.2019.09.18.05.59.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Sep 2019 05:59:11 -0700 (PDT)
Subject: Re: [PATCH 4.19 00/50] 4.19.74-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20190918061223.116178343@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <b1cff98a-d08f-d6cc-393f-9ca80c9229fe@roeck-us.net>
Date:   Wed, 18 Sep 2019 05:59:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190918061223.116178343@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/17/19 11:18 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.74 release.
> There are 50 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 20 Sep 2019 06:09:47 AM UTC.
> Anything received after that time might be too late.
> 

I see lots of build failures.

kernel/module.c: In function 'free_module':
kernel/module.c:2187:2: error: implicit declaration of function 'disable_ro_nx'; did you mean 'disable_irq'?

kernel/module.c: In function 'load_module':
kernel/module.c:3828:2: error: implicit declaration of function 'module_disable_nx'; did you mean 'module_disable_ro'?

Reverting

ed510bd0bce3 modules: fix compile error if don't have strict module rwx
22afe9550160 modules: fix BUG when load module with rodata=n

fixes the problem.

Guenter
