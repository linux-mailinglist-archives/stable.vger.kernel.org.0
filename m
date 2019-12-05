Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30DAC11425F
	for <lists+stable@lfdr.de>; Thu,  5 Dec 2019 15:13:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729497AbfLEONj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Dec 2019 09:13:39 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:45320 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729426AbfLEONj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Dec 2019 09:13:39 -0500
Received: by mail-pf1-f193.google.com with SMTP id 2so1666738pfg.12;
        Thu, 05 Dec 2019 06:13:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yCA5YO6Wcf1JVbCDDpSkeJp8KE9P2CIs7/CH65FUNWU=;
        b=Qitp02WezTjgaKGilAMW1/3cmT1kpt0fo8s9PvqCo8XpoJLYZsChq78to5yaJVpLaY
         Gf3X9KpxEBW6qcOinV8cTPu6GUTOTjUkpeUj3Vn4qGWMkmuvw6dZTPwA2tYuJ2/KzNuT
         ON9yrnqa5AwfmwLlywowuFCJCb342z39r9IUT3cOF9H+9KQAgBaogHxEeVQjzhirsuni
         oraoJ5apovr3Xk8KW24+1Yrbyl76R8EXFqLSh3geBs9Y+3tJI2utaMvIrp9/5gKD4+Fq
         a6XRfC6EYHqrteYvouNVVGGsn65N3RykJGU6tMqG9up7mhFfkRAoDJo3kKgbKFKb/efX
         cffA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yCA5YO6Wcf1JVbCDDpSkeJp8KE9P2CIs7/CH65FUNWU=;
        b=d9ir97IrDwMMwVO5ian8zU/q5N1nll6zFrqFuy+YM8+Uf0tKvmcsI7K1iJn5MaLDQb
         AHHzoteILHjK/hiA7SYgTAXorGf13bMU24XvWh9cdt/RX+zcLms6pMbK+EMjTMFkw9Qo
         LGqjY4gJji0bt1i85kQlIhPE7ZBC9NacfyyA8AKcaj8t1WHImFfebCWEbGQ0SHJMnZoC
         f1tE3ss8SzlX1Fb5cILB5aLHI5Mh0LTt8sk60ICL5cvsMRQ3BZUemNXt31J+ajG3eykM
         aBY9m72vdZHo/RxS8BFcRBP19W8ab7cp63p3Lx8FQOQ4rEaz45305oRa3KN+1uP/fIml
         3Iyw==
X-Gm-Message-State: APjAAAWc9jQ9qZ+GdcxDao583P+brKwbfEWfhwVLrZaPEaS7BWoxfyTZ
        5WxC/NNuCfHs5xRHEbVtKeuQs0F0
X-Google-Smtp-Source: APXvYqzPeMg1x8C8we7dSGvRHy+zJZ89d3t2Re/8xYPbbjdk5jLXxzJkIjY3exZgZlGfOgo5cOPbjA==
X-Received: by 2002:aa7:8f05:: with SMTP id x5mr9148553pfr.86.1575555218098;
        Thu, 05 Dec 2019 06:13:38 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 133sm12302072pfy.14.2019.12.05.06.13.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Dec 2019 06:13:37 -0800 (PST)
Subject: Re: [PATCH 4.9 000/125] 4.9.206-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20191204175308.377746305@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <1d271999-5b15-3df8-8035-bc20f2fe6b32@roeck-us.net>
Date:   Thu, 5 Dec 2019 06:13:36 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191204175308.377746305@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/4/19 9:55 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.206 release.
> There are 125 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 Dec 2019 17:50:36 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 356 pass: 356 fail: 0

Guenter
