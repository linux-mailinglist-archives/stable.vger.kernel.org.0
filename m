Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EDF42AC939
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 00:21:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729451AbgKIXVc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 18:21:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729336AbgKIXVc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Nov 2020 18:21:32 -0500
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E7B4C0613D3
        for <stable@vger.kernel.org>; Mon,  9 Nov 2020 15:21:32 -0800 (PST)
Received: by mail-il1-x141.google.com with SMTP id n5so9919370ile.7
        for <stable@vger.kernel.org>; Mon, 09 Nov 2020 15:21:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=y0vhPiUJufiusUCpG7Aq8SbPfnYgOKIGrM2IV4KV5tA=;
        b=Ee4hIdjUWua0iycUw9IrK5/fm9znTFj1KwlJjrdgs3huO/hS5p6qAKEfizeRcuV8Fp
         pEcCpHWnK02b7Vle2jA5W6rNlBA65EnswvH6ss4YlEjpK8rfgBUCzlBWpFYIxNVKMGsB
         zTX55ZkLSLFA8jdmpXvD7+Bos4OmLOj6NgtY8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=y0vhPiUJufiusUCpG7Aq8SbPfnYgOKIGrM2IV4KV5tA=;
        b=oTnOADHtLC6dUoGusxWhC5ABzKBG7jD21k/buudC750cGf4Bu32dDnozGi0vYe9NBG
         1hPZoP+glqH7rjm9IBbSAMTpYMm/flAn92shm6WR4OUbYI8IC0q0StcoGGEZGtgG4Nby
         6+KXZtIbXhUxnOyq/xLwh9pvNxC3IZT6dQmPnX+F3C4xDacSLSwEcg0jN5tbweF0+FJX
         AdqSVebNVAL2Z5p3ui1EpDHwsITE8/+8bjHEOpGms0W3j45KBEOZuNtoxeJHtnhuxr92
         HR9obweVE1onMnbKATBuJei7yebJyxWM+MMhdkPxmxZu+gcvVvtVdw4L6ZhwFw+qQvH+
         dFBA==
X-Gm-Message-State: AOAM5339L8TuiK5w+2lQmTDaCjDfYayTvCuNCAZbLZ754ctBhFuX1E/F
        trqmVVQhg5CjA5o1lKylXNCvKw==
X-Google-Smtp-Source: ABdhPJwbzxCy2Edt2uABy6e0CA3zssrBqJG+Bx4YVlou+0CjJd2eRoCHQtTX03AE+yU3rhCBpeKYBA==
X-Received: by 2002:a92:d9ca:: with SMTP id n10mr11376000ilq.21.1604964091641;
        Mon, 09 Nov 2020 15:21:31 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id o124sm7806422ila.62.2020.11.09.15.21.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2020 15:21:30 -0800 (PST)
Subject: Re: [PATCH 5.9 000/133] 5.9.7-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org, skhan@linuxfoundation.org
References: <20201109125030.706496283@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <419da435-c08b-7ee8-4994-60f9d8042b49@linuxfoundation.org>
Date:   Mon, 9 Nov 2020 16:21:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/9/20 5:54 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.9.7 release.
> There are 133 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 11 Nov 2020 12:50:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.9.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my new AMD Ryzen 7 4700G test system. No major
errors/warns to report. This is the baseline for this release.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
