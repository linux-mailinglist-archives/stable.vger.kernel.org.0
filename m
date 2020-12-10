Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 405C52D69B5
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 22:26:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394050AbgLJVZX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 16:25:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394043AbgLJVZN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Dec 2020 16:25:13 -0500
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D863AC0613D6
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 13:24:32 -0800 (PST)
Received: by mail-io1-xd43.google.com with SMTP id o8so7219005ioh.0
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 13:24:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FQTCIYbnriEUCHVRbS9qYEl7y26CsKk4na4wxDADtBU=;
        b=iNEVETYXCw3dzjZ2pW2f92pF+9FP7fxYausJemupPdmo9yoK2mgP+ZF9h5zb99wHSg
         D1oQ7Rv5rhpbrdPahPXQmz+nkjWzFrGXTQ3gjE/lOfH2D549g1b6EwsPnR5/BPw0weeN
         naMMqu+PiwSo0m3g4O5/bXBm7fXi5Z/EBlyjk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FQTCIYbnriEUCHVRbS9qYEl7y26CsKk4na4wxDADtBU=;
        b=kGKs9n44diMFs4SvZ4jYAFYL3DQwibh/7nxtRb0hEieqiScmU0UVXCd+ThD5nk/QxW
         pJETJv4AecPi8felGDbKOK+Z8FMUigO8lXUqe+EFIU7327i/j72xcdGsUKFdGO56HyuY
         2Fv4gGwRydxg/236n65OivfXd1iPZTOmmDykZrTKCXUdKQEsiYoJpzm3z3yxuh6pciM2
         c6/8SHM5EZ7x/j3iKtdYgyGa2hX+jJ7/R2mo2jKxhxD69PS0bto1/rjv0gwZGvcBJmzk
         skaoOjfQD28X3Ie1BnV1MzwJ0dOBwEr/GH77tT85RTcCKbf7irW/IAc+D3qdB4amZv1i
         5D6w==
X-Gm-Message-State: AOAM531QkR4B/bfuGIxtQP/AfJIRRMrjjoc5rCZXbzKCFqkm7PDUGVfX
        vvFdLDNBIii0CodRh02UASJ3Yg==
X-Google-Smtp-Source: ABdhPJyZx0EQgJ40VIbYuS0O5uA1q0gaUDxQY6JbjDW7puSNeo6tX6d1gAzvgCAhYbJGW6Pb230XjQ==
X-Received: by 2002:a5e:c111:: with SMTP id v17mr10295894iol.29.1607635472309;
        Thu, 10 Dec 2020 13:24:32 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id l4sm3836795ilo.29.2020.12.10.13.24.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Dec 2020 13:24:31 -0800 (PST)
Subject: Re: [PATCH 4.4 00/39] 4.4.248-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20201210142600.887734129@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <1530953c-b8b5-db3d-bc0f-d1a3272d91e6@linuxfoundation.org>
Date:   Thu, 10 Dec 2020 14:24:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201210142600.887734129@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/10/20 7:26 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.248 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 12 Dec 2020 14:25:47 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.248-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
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

