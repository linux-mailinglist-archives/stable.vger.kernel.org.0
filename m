Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE2154328B1
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 23:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233775AbhJRVCU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 17:02:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbhJRVCU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Oct 2021 17:02:20 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CF6BC06161C
        for <stable@vger.kernel.org>; Mon, 18 Oct 2021 14:00:08 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id g2so16314599ild.1
        for <stable@vger.kernel.org>; Mon, 18 Oct 2021 14:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9iDEH9s3SYN/2o6Dnyml+lF+spW3V7+dMTflhdwzT/0=;
        b=XGMt+nzu3r08/4TODpwfqaneqSX0imp6YLnZ6AeC+kR1RI5t5brbJHcReNvSoi6zrh
         G9E/yxbtNC6QeULfDyKxgPPBoWe+wzTGlWAeoOfzcSFczdv8mKNz+m5VL6BM4LXY7gWD
         qBs7EGPc2zgOKWa896xqbtOOZtd12gZVXG0Ws=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9iDEH9s3SYN/2o6Dnyml+lF+spW3V7+dMTflhdwzT/0=;
        b=mRgXQV9pPDc1XuwznUgHgnDU3Qx576r9Cup7JNkQQVn/jKwvCHlK1gC/gPA2BXAwLe
         4skEamZoq0XxG/AZwLge0nKL7WbEdwb+5JftsRuAkHEnAXPBt0lFQe8T8MybRnrWY6Pe
         Ic7k4C83xIzuO9uK/8MbkI7SYXRjYVVctjWYJTZrF+leCaEaPJOUe4u27CIBhmENO9mQ
         m8e7HdjbrG8JCTQa2jQQxcHa2Y6gmyLAmG8go/DGoTYrqjoF03NYde4MlIFAoI7nuhhu
         j5qeFB7LdqxZaUrnQIxWTCDz6G/mBpuoVI1LJQStqHyjJuOS5oI4N+/S/lIZS8ft6sMM
         /TfQ==
X-Gm-Message-State: AOAM533FTaUxuqFyKBWeB5YdFbPRFsyTzS+ZhUuB94IdR9eUqy179iSy
        g25sAaANxPGV47SaQ6obOcx7xQ==
X-Google-Smtp-Source: ABdhPJxKOCqMloSr3C8jzamHG8vjypbw04fZ9QJFgp34lwiEMITkxR0ecuZ9a/3T8eXOE3cOWtSDiA==
X-Received: by 2002:a05:6e02:1a05:: with SMTP id s5mr15447645ild.164.1634590807885;
        Mon, 18 Oct 2021 14:00:07 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id i18sm8153830ila.32.2021.10.18.14.00.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Oct 2021 14:00:07 -0700 (PDT)
Subject: Re: [PATCH 4.19 00/50] 4.19.213-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211018132326.529486647@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <9584fca6-afda-ed4b-6a95-deefbabb80f9@linuxfoundation.org>
Date:   Mon, 18 Oct 2021 15:00:06 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211018132326.529486647@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/18/21 7:24 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.213 release.
> There are 50 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Oct 2021 13:23:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.213-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
