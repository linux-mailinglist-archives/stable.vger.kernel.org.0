Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFB7C3A6EED
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 21:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234257AbhFNT1S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 15:27:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234239AbhFNT1S (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Jun 2021 15:27:18 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EB4FC061574
        for <stable@vger.kernel.org>; Mon, 14 Jun 2021 12:25:15 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id m137so15536574oig.6
        for <stable@vger.kernel.org>; Mon, 14 Jun 2021 12:25:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8DCn5MXUMTxfEDrOT14pCt4lS1xqSJ3zb2cgdkFs2bU=;
        b=gmFEg4i3H8bnraEzaVj1Oo9pUzetzP68fHWF6B/m6azeI9Nju7aX1XGPOqCxD81cyQ
         3/YfVRSe8McG+W9KhIbYIeaNtF1JlcDAg8xyffw/d0yDzkv6SSMRGm3HGS8qVTZ0Rdwu
         A3VKeICGXniE/hqR7eZCmVi8rDZlus1iwUmQo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8DCn5MXUMTxfEDrOT14pCt4lS1xqSJ3zb2cgdkFs2bU=;
        b=kw71UVy1tUF+yHJhJTdUXuNVNwo4l74VkDrGSL5Kvo47NpE27rHrGtt6jbQRqa8v1q
         ASPwPn+lE3ql9iEb8ErutZhU3w81SftUf+SCWatuhQ9EtA8N8TTFzHvftZ3oFCPilR/s
         HXeYJbD73QiWTLNXRaoR4TYzuixjn3F4P7Qg4DsMFwaQlSl66p7rmZ4eVR83af2oEfaN
         mq/Dd3u7DnXmn8El/tJ86yuH15HbtE6ZfSXK0EJB4WRwpWtYz6e6JcdLZ+6FbV00TexI
         mbqzdk70aR9uzdNfmw3XkzyHagxug1R2TkQ/4SxTBfCa1976+e7RpYvfE3/O/xLC5thW
         FCeA==
X-Gm-Message-State: AOAM532ayEaveko61xWgZo5ApmdpXnCFG0jJtGGiz2saGoeOEl6issmS
        naAfJfsazlhHQsPSYNmIXKCtAQ==
X-Google-Smtp-Source: ABdhPJzrgrWvFZaku3g0DEDK+QgqiIswdsVrMRAGEPFYkoq3s7/HrKPhNCM78RKWP6xuQP2h4bIH/w==
X-Received: by 2002:aca:1b11:: with SMTP id b17mr451858oib.41.1623698714610;
        Mon, 14 Jun 2021 12:25:14 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id n11sm3524241otq.63.2021.06.14.12.25.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Jun 2021 12:25:14 -0700 (PDT)
Subject: Re: [PATCH 4.19 00/67] 4.19.195-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210614102643.797691914@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <face5a87-9ea4-a661-d623-f11d5c75f25b@linuxfoundation.org>
Date:   Mon, 14 Jun 2021 13:25:13 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210614102643.797691914@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/14/21 4:26 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.195 release.
> There are 67 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Jun 2021 10:26:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.195-rc1.gz
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

