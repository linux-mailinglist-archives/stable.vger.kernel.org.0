Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA677383A62
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 18:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238542AbhEQQte (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 12:49:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240200AbhEQQtR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 12:49:17 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC20AC06138A;
        Mon, 17 May 2021 09:27:47 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id k15so4993685pgb.10;
        Mon, 17 May 2021 09:27:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mx4uew0MVPJR7i0oTY96YMZZ29hK38r70gY7hQXazqs=;
        b=XOeQGM5hI1scTFGVvCJLQFicp9XWE9txAw3MjdtrsPblP5x3otLLx7Sk2zNqkBgVNJ
         tCY7sW/AC8QVg7GsCy4j3Mw/go9Mnx2/IF0wRCz99lmTpztXkU3PYiYC7sDEU4m3fBPT
         Od/8o28tV+kUWspNbUmYQqjwHXBg5iqB+SlCCqB46M320bQJsprZk0zVrbeJVLvY1w5h
         s0V8n1Dm/PXCmZfb6egpNC7ogyzZPIwDnd828OFNBsxhNAd7UEbW45cO3OnlaMzgjiXM
         +fxN82viqY38m1oLpTnRmZISnoPW1qFmTclrPqH+nr5umWfkbkPrTObptt4ImtHy27qF
         hnlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mx4uew0MVPJR7i0oTY96YMZZ29hK38r70gY7hQXazqs=;
        b=ntpoe99ka6BrgEZfpaMS+0SIl9VNEnY7KRu9UTjITXO/MkEwW1WKhaIr1Lha7E9mCU
         O4AQfQv/Tz7hEM5WaYOMQKDutMXUiKEf2713PphiIKlDypYxRT5VHoTDT+bS1Qf7ohJ7
         BMjW3ra0rNG67ZLcH7TA3DSEPysvmscA9DCgZPHTbmB5UU1lOghjB8qvtnFlz9EtJs6U
         dNRkiV3uzRDxKQN7ih8CXGNLbFtlKe7ANToMR35pHWD9peyHz06XBVGyrq5FaRjAWZdj
         bej8CR/U/TQyvCCOSVKMWjxaWWWND0+8Zp3G3wNeXLzOivDAFmTJdJa7305VevBvG/dt
         201Q==
X-Gm-Message-State: AOAM531c0dM+GznL7ScDYL88wkNQdY0hQsIOlR+n1c62F/atKq9joGl+
        iQXHzXaThDa5UNZNl5uFcMiVBmSWMpU=
X-Google-Smtp-Source: ABdhPJyvAqve5o0RR+IPyfaArfEJYUMu4Kmx6h1WtwUYo9QHvZw5Q5MqLXSJuGEgsGHeLpw6vAyhdQ==
X-Received: by 2002:a62:7e41:0:b029:249:287:3706 with SMTP id z62-20020a627e410000b029024902873706mr445658pfc.76.1621268866893;
        Mon, 17 May 2021 09:27:46 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id n6sm11368923pgq.72.2021.05.17.09.27.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 May 2021 09:27:46 -0700 (PDT)
Subject: Re: [PATCH 5.10 000/289] 5.10.38-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210517140305.140529752@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <3d273f4f-0b9e-2404-cd32-2e214cf586ca@gmail.com>
Date:   Mon, 17 May 2021 09:27:44 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/17/2021 6:58 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.38 release.
> There are 289 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 19 May 2021 14:02:24 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.38-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
