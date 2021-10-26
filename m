Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4289E43A983
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 02:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235661AbhJZBB3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 21:01:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235967AbhJZBB3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Oct 2021 21:01:29 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C1DCC061767
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 17:59:06 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id y17so15094973ilb.9
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 17:59:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=r/93flgoPAibw9TrMBsmA1tH1WmHaddSeHXSGb4pbC0=;
        b=MPca3Iusd4ca1zyXvvyCIip9B0/gtVGELbrq5P22f82Yj+sY3YMyqKIICOB3sZYe4X
         dsZXLF3SYA7m/EVwxZ1KoyyCQJ1VujWJyk/hMmLJBi/dtHMP3dcRSaNqIrcyZq7BMAon
         xrBb8QcXPVrloAmEbJ7qcrG2f9q3NBab6r8ME=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=r/93flgoPAibw9TrMBsmA1tH1WmHaddSeHXSGb4pbC0=;
        b=gqR8JsYXtZcfC8EJx/3aJ+JIpHhb/p/SjgCEj+1Q0gk9RUg8KtOQP7CFUYBD/A5jF9
         xpuHZD3JVolAYetWr22PHm48DyVWc2XsbAiiBXJaKsTMLK3bo1oPktxY08lo+GK7SWcM
         j8xYgMG5pnxW9ZrstY8oIGV4ELqmknK3RS9g72k6lbnR39zDhf4t7Gbt+9NDSxH6hSHi
         jSwxCKXRHO1GDw+XWWVoQP89T5DfHv9GYbjz2+B47uzy+xsI/kKxME2DZyZIwEfYETwa
         5+mlXXx6xg89iGyVjL31CYhRAUAgTYd/BLG8lGil081sy+TfhyNZqGmckbySDpVQn+6L
         sSIw==
X-Gm-Message-State: AOAM5330RV5b4QN0161pkSWfcSa5jFcyQ2sfCO1nRpUU539Wn2YnwOfq
        2y2Cs1u6unJM61plzdVmr/IFKA==
X-Google-Smtp-Source: ABdhPJzWbEimFyCb5K4GLGi0lb3Ftal3/l/f8ycjvOSYnBUNyegjAS3krA62pdLh2f0SDKPuC2uebw==
X-Received: by 2002:a92:d801:: with SMTP id y1mr11065765ilm.159.1635209945906;
        Mon, 25 Oct 2021 17:59:05 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id e14sm9845649ioe.37.2021.10.25.17.59.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Oct 2021 17:59:05 -0700 (PDT)
Subject: Re: [PATCH 5.10 00/95] 5.10.76-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211025190956.374447057@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <b7e3fc5c-1cc3-6be9-0b84-82310e280d01@linuxfoundation.org>
Date:   Mon, 25 Oct 2021 18:59:04 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211025190956.374447057@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/25/21 1:13 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.76 release.
> There are 95 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 27 Oct 2021 19:07:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.76-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
