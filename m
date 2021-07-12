Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A327C3C60C3
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 18:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233869AbhGLQtD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 12:49:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233444AbhGLQtD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Jul 2021 12:49:03 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C63DCC0613DD;
        Mon, 12 Jul 2021 09:46:14 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id z2so6614230plg.8;
        Mon, 12 Jul 2021 09:46:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fYWxI1WPtqwGOfHD9uqZBoCANHh3/qp2c+wINGNSqdI=;
        b=Goe/1eTboe5rFD1Fst141Gak9jWeD8HylFYefZLqgXNyIItNnwHm1IAWebmrT6kLvM
         Z14g7M+SnjSVZjfQ58xps0dUemBkN1IJRyRu3EBps12Dgs17FLxZdNIM5tqIy2gl/G/U
         W6mDPZxe6gL4sAgj/QbLxN6v6+ZPXKf4O+xH3+AsTFFTL1ecp5eeNyoygtTQ+5MjPPzk
         t32YkZ6jiga0ODxs4VPfUfZ2QTLW4bDedrofI9oEmkuYWtRwqC7cUIN15fQvSWl+bwun
         829QcxVzrQYqcKwzJCWHCwdHOM2YSAFb9OFC/+OoglLrZo+r54GvMvH0XuTkxKEbF948
         xUHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fYWxI1WPtqwGOfHD9uqZBoCANHh3/qp2c+wINGNSqdI=;
        b=esu9k9lCcH5vPTrfy1+tVwW2SGKxtghOlgQD2n9Pi1U31RTX9MQp1Huk2YHl3wDc3y
         QuMQgym3/BtwGhjpi5WKpTj3TGfF9KPP+0AE8He2I4ZIXPPX/DNW0zUpDWBIef6xkLX+
         XM9fXHli6L08d15N/SO7ilrlopT935bMtd2xR9cIAjws4L1HJTVbpYmzonD7EbMdBRqy
         MhsWnZpXorbeXWvNW/EA3w7GtTtPo+WQekej2fk6j8Rgq94cbadz+jPcsD2Y20YbQwJ5
         z/1ichKJ8l+gdFGASStXRgkSXnyZseSDiiPjVm+/txFnkoqKsqN3WIikaKv2U9rJI2Xw
         Xibw==
X-Gm-Message-State: AOAM533vw86PwXYBkvoFROcfctRx3213Ee4vEHRDn2X8iHV4kKYdWDMe
        JPR1WSx9Ov/rjaxst9fBCg+UVTnFxwX5bA==
X-Google-Smtp-Source: ABdhPJz2Q2NI5F+OFXUZiDuo3nD/VsIaFrpQBY0768xnPueM0Kjr8GJNQEmsPxdVKMfPtvm8jpnpHQ==
X-Received: by 2002:a17:902:9004:b029:f0:b40d:38d with SMTP id a4-20020a1709029004b02900f0b40d038dmr44313950plp.85.1626108373873;
        Mon, 12 Jul 2021 09:46:13 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id i12sm7402479pjj.9.2021.07.12.09.46.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jul 2021 09:46:13 -0700 (PDT)
Subject: Re: [PATCH 4.9 0/9] 4.9.275-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210709131542.410636747@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <8d53b5c9-b5d8-03df-6a38-1e1e5c3a62d1@gmail.com>
Date:   Mon, 12 Jul 2021 09:46:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210709131542.410636747@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/9/21 6:18 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.275 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 11 Jul 2021 13:14:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.275-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
