Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B720444DA5C
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 17:26:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234229AbhKKQ3R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Nov 2021 11:29:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234203AbhKKQ3P (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Nov 2021 11:29:15 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45D40C061766
        for <stable@vger.kernel.org>; Thu, 11 Nov 2021 08:26:26 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id j28so6402181ila.1
        for <stable@vger.kernel.org>; Thu, 11 Nov 2021 08:26:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Lk/yN+EyR4iwNeMFvXGxKhh7xX7AkHPc4DA7pDgu7gA=;
        b=YviBg9nIwU+0ZlAjKHWEsoRn3nemhwHZs4+dZP+uZeDc4WswP3fYQi2kSA4VXMibRQ
         POHRXwWre9oOnKOo4Dgl2NWDD29XuIyWa2ZT3uMY+S7/iCUKyCcBh9vc4f07UwNDTz9s
         cvWPkG/lufaOJb2Z8I4YgNGkU0Z3HpIrysuhM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Lk/yN+EyR4iwNeMFvXGxKhh7xX7AkHPc4DA7pDgu7gA=;
        b=XZ2+Q691onAKtWpGXSiWCiCdpPSAhXgm2DccbzACoVjk1C1ACAkZvCv2wvDpIilxch
         292tIVbKllOF9NZamtfL+0WSekYokNVv4/FQdylxBI1lsCGZBz78lyiXL8B2EiQX9os9
         zlJZLXmH50Z6uX+PErMH8EzEv2XiVk0A2yYu92aRUnD6xQTvApVSe7TJBUCvoVEU8gsF
         /VrZRR6NZXrbo16SLCnHjGw6wk49Q2GutHPKq9TbF3/mZaaHZkxTIJXE6lCbBdqolcku
         uJHAcjDJBxoAeHGWF7edRiigzSCz3izLae4AeQn7WoyUYbKC6Du22sSvE+FQy5AHgRWb
         aWKg==
X-Gm-Message-State: AOAM5301OPZwC3O823PeRbzYsM269xorY8bq5fUvdBK0ZtORANv8BMq+
        ++yp8KA51nnzi1ILYO6gXYBahg==
X-Google-Smtp-Source: ABdhPJwZXBweMEyVtMRjaAjlS2dWfF+KVJRM4iJa0Xn4+XJyfT+YGQAgtJRH2SsOOQ3zMIOgfQ9Hxw==
X-Received: by 2002:a92:d341:: with SMTP id a1mr5076548ilh.59.1636647985670;
        Thu, 11 Nov 2021 08:26:25 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id c12sm2103142ils.31.2021.11.11.08.26.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Nov 2021 08:26:25 -0800 (PST)
Subject: Re: [PATCH 5.15 00/26] 5.15.2-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211110182003.700594531@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <83be18b6-dce4-d790-855a-d29b58643228@linuxfoundation.org>
Date:   Thu, 11 Nov 2021 09:26:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211110182003.700594531@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/10/21 11:43 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.2 release.
> There are 26 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 12 Nov 2021 18:19:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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



