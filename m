Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3734744CDF8
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 00:43:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234005AbhKJXqa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 18:46:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233948AbhKJXq3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Nov 2021 18:46:29 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E4AEC061766;
        Wed, 10 Nov 2021 15:43:41 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id u17so4281416plg.9;
        Wed, 10 Nov 2021 15:43:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1VK3rLRn6OYaOmxBqnHyRzVXgoVp+e8leNU4bJO8vw8=;
        b=cogiWocK65YeIFa2SAoHNh9+pyz4vSOJEZsA2BuZnMXOWI5c+/uTyeHQnAGaCsJYxr
         Eh2g+fwo5opcronxZbN5Izc2YiRXVayjvpmsX8g0LfytqejaTIXHktotIQhp0vSA0yVV
         6ZutOvs34gu50uhNajubBj+FxfShRiqPfiJ7p/d7kV5MxrSvYaBTbfE3aBXzao0QeU6r
         mnkicAsPL+LrIQlxiiniZf61qUsmBvf02c5AzOsA6uhaRlByJG2tcOPzyS43cD9/G43q
         LcYkCr5WFr+CXHzotQjXB4s7gG2OP7laW/GAEccyoOfN177CvaPT+76pCAurWvqZx+GC
         UuXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1VK3rLRn6OYaOmxBqnHyRzVXgoVp+e8leNU4bJO8vw8=;
        b=NX8WpFELV6Mjwa71eGeGzBhGSbnCE8HjmCPqc0RxnEPNAtobYfTXvw5jEsEGr47VIM
         71CfqcwLQhW8pIKk2k6y1tt07JqUmHVW4ChGNf34HaouLotm6CEPvPeFh3VfstHFmDCA
         M50G0+E4DHjTK+awzfWd7mTzExh9JjIdZo0HnIyL2TCpzzkLHyX/1yl49cyGVXXOs5jV
         Z8O/KBo58esnubjbDJALPBDqRVqvgTOTPFBxR3LPNLC9cDcSy5aq3JApL7bg+n24Djmj
         u+6cpLmPW6Tv80GLhpFxbBfnXGU2sH4hriehdsLp0Pqfu/6uh0IW8fvPrfjjmyOXGw5v
         Fs2w==
X-Gm-Message-State: AOAM53211Ml+aaRux7NbTXucRtHoAO12ng7onrWuON96OZTpxMR2allD
        Jky+BhbbQMTw88ztu4JcvTEi+IjIceQ=
X-Google-Smtp-Source: ABdhPJwqthERfb8HW2LPWTXJ4qcBZ+St7rtfvExpPze2X+ufVKcgMukcsnb6qABKq+S3uW37YzNdFw==
X-Received: by 2002:a17:90b:fd5:: with SMTP id gd21mr3358691pjb.37.1636587820758;
        Wed, 10 Nov 2021 15:43:40 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id p19sm747485pfo.92.2021.11.10.15.43.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Nov 2021 15:43:39 -0800 (PST)
Subject: Re: [PATCH 5.15 00/26] 5.15.2-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211110182003.700594531@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <6e6488da-ed66-6595-668c-98136189af6a@gmail.com>
Date:   Wed, 10 Nov 2021 15:43:38 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211110182003.700594531@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/10/21 10:43 AM, Greg Kroah-Hartman wrote:
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

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
