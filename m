Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8885B3C6872
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 04:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbhGMCVT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 22:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbhGMCVT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Jul 2021 22:21:19 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DE4DC0613DD;
        Mon, 12 Jul 2021 19:18:29 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id m83so10495614pfd.0;
        Mon, 12 Jul 2021 19:18:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Axli3ymKTNSpOavgT//HKAT44cBIJTQgeyjPiS39+Ds=;
        b=I1iKybbQIMq/kzbMPRb93Bh/+YJ3lkcEsS0FWVAQFNCJYUg3w4vtyBmyKqSuiAqZyS
         PYiRYGO91eJvF0fsjg4un++IteZgCtzNVRXsKdp0YC6EPy2Fw41+fC6hf8nd1bLVaMmr
         DcMUYilmrbXVA4OVDbDTO3LyAQPemI+rLC5a1vMkCwEb3YKCywEz+jVwaaMOQccbOKSm
         T61VFtbsUWbGq24qtvOZBZ49+nJEbXUIsk3XQYwHYC+Ht/3nqdSj3g/K5pUa3KbMT2cr
         gfh/69tYQFVz67sAroqsf12RAcPwhp3odCZqf8vWufhugImqXOeddmjdCYL96nYn3FND
         MVHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Axli3ymKTNSpOavgT//HKAT44cBIJTQgeyjPiS39+Ds=;
        b=MiyM1nc9fQTi2WVcGg/K9fRl8zdTntgutV2vBkXHwU63KOQFPUkDIFoGU6xZA89EA2
         lqXQDVN/5LQjdVhrpOp+e9TqSRuoLMeXB+Q0+g7KB4w26y6WM6LPFK/vp6ciP6upjWIM
         WkTPR/hzElUNxEEaxoFr4r9RqTZozybRVokAYYaO26TqSgFN7evt1uqNlsQIqzG3gjZm
         oDbWH2ewNdJSTCDbmwn/f7cPF/Jw2ZrUbLmOwifADs4TWP4825Wm3KumrIXj8DBhEglN
         b7j+auPt/2y3aEM5o0pk6lxJG7W8VYHm2yjVT8mQsLrb9QnKILVRQq1avAgIre48OxOj
         Ghjg==
X-Gm-Message-State: AOAM533teaXO8r4wNZSneMhzJUlFT9S/30pEkMJGZnfDcRXXOH/hLwX9
        HBr6EpW9R7J/xjLl3UnyV/TypXhJcQZTAA==
X-Google-Smtp-Source: ABdhPJzn3ngpfVap59T9AArxBafIfo4ZH5cXhuRAecQYxz8+FY6GML3cJsBDq7mM9ow4OJ/QTi7PGQ==
X-Received: by 2002:a65:60c3:: with SMTP id r3mr2043198pgv.116.1626142707343;
        Mon, 12 Jul 2021 19:18:27 -0700 (PDT)
Received: from [10.230.31.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id m1sm727554pjk.35.2021.07.12.19.18.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jul 2021 19:18:26 -0700 (PDT)
Subject: Re: [PATCH 5.4 000/349] 5.4.132-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210712184735.997723427@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <7cca05f4-0aff-0104-70d5-e1e694a8ed78@gmail.com>
Date:   Mon, 12 Jul 2021 19:18:18 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210712184735.997723427@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 7/12/2021 11:49 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.132 release.
> There are 349 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Jul 2021 18:45:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.132-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
