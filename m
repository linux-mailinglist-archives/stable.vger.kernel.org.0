Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87A7212F931
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 15:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727610AbgACO3M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 09:29:12 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34362 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727543AbgACO3M (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jan 2020 09:29:12 -0500
Received: by mail-pf1-f195.google.com with SMTP id i6so16780245pfc.1;
        Fri, 03 Jan 2020 06:29:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eB12D2S7lx5RdyisNAEVrgr4+ch/07vfDXva98uANRo=;
        b=lbvgj5JqoZLaHg9xVbs2nPnYAZvSaBGpwn/zkZ2qKhZHzvT6fsnvvohp2DvE4inlV6
         t+SoB1+WiOFdiR2/yGhOnI6bmXaejcWdP45qvBZuG8O95q3hYUfVf/QvMx7geEkSQFF0
         aH+5Ww3dfpUgPo7OZpK1c0UhUfnqfyJI5TfBUQkT5XSPUEtoLEnvw0rawA0amuCBvAab
         EJZWaR4fIW8Rqzh4lCCJvhb0Xdf+ItLX5ogMPu3cPBSLcSIMaJuhweCh+6//bl1Jrvdq
         ByTdi6KwBab8s3F04W8yViske8sXZe7WiyO/M6wcEyKK4ME5COoZGzG6GpVfLFbqKKKb
         glRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eB12D2S7lx5RdyisNAEVrgr4+ch/07vfDXva98uANRo=;
        b=o4VVdBzfveAJDEpM7VvKU0PGa6XuoD2gpy+sdZSq00U82r/1SyWAeQurV3w/3G+Nu/
         9hDF3BGXhJszA3ck37J3inBlYguw8hhSbWBOvKmpHCWe9MIXk1xbuoa2Bgyhv0jEEVoh
         ZuZifq7RFeOqQU0AwvLfwAEIz8RTBCe2oE88n2mNjjZfWTArstJSsrhoFwQrhbPK4imu
         YyuTtFhpsfYWfPx27on/5t/1If0ETq81DJJBDuqSq8v5JULlO73op2R9p5Hlw4DgABjA
         a8x8YRHq1Ax0yfWpG5OHiTI2J7IKwK31f7+7vOmx9HF4bKHOgh2RH6QfTNgwGZAtnjui
         Ixrw==
X-Gm-Message-State: APjAAAWuhaSFigJdDEW3CNjV+2NcFWvGYE4lIsEbyMYxQvUvyq27GSVq
        ps77z2J/JhA3vdtQxscWpBSqz8QY
X-Google-Smtp-Source: APXvYqxkeNAAHtyYUzAnI2qMqLN4wd7LrkcPwHGuEvW6hL9F3to7F9+JY8yf2LY71MSFGQPKKt4Gsw==
X-Received: by 2002:a65:50c6:: with SMTP id s6mr99219072pgp.365.1578061751588;
        Fri, 03 Jan 2020 06:29:11 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w11sm62827658pfi.77.2020.01.03.06.29.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jan 2020 06:29:10 -0800 (PST)
Subject: Re: [PATCH 4.14 00/91] 4.14.162-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20200102220356.856162165@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <2e665a0d-f0e3-c1f7-6166-dea59d6ff6af@roeck-us.net>
Date:   Fri, 3 Jan 2020 06:29:09 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200102220356.856162165@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/2/20 2:06 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.162 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 04 Jan 2020 22:01:54 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 172 pass: 171 fail: 1
Failed builds:
	sparc64:allmodconfig
Qemu test results:
	total: 373 pass: 373 fail: 0

Same problem as with v4.19.y.

Guenter
