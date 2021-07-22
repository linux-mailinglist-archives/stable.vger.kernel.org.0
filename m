Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95F793D2AB6
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbhGVQUj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235968AbhGVQUE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Jul 2021 12:20:04 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0685AC061575
        for <stable@vger.kernel.org>; Thu, 22 Jul 2021 10:00:38 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id t143so7284896oie.8
        for <stable@vger.kernel.org>; Thu, 22 Jul 2021 10:00:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VnQgrFKyL09FZWGvfGlkFGfOAsk4lk9cRxNnmKHljlc=;
        b=qzx2csD+ZONV/WpNcx7ZKj3ZCYB712jM1U7zmNX/eyFMm0ONOb7Zqu7XFRah2ru8Rx
         YN1ki3WqYr6ppOdU+jmhj9hUrh5S0tz7GS+F5EjmofH3Humhnmsdh8cN0n3sR91LAAQ3
         bmymODYV7FQHWuGJrKVD+t+qqgKWeSXn1XrlRcLN87VMwpQulwOBh3kNuLpjuOpSKw7Y
         7bYBC0XoueexAFyPZSg7xJ3o2UPr7E40+6mSzW9M9Rivow5+AnYc/IPU6zz1KzRhmJji
         P/KWRoWPHb+xH4++ovBYdIASU2r62+l4Ukp32bZcols4T/aUikq5mJ1ukWNEeEuKQBA9
         R4ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VnQgrFKyL09FZWGvfGlkFGfOAsk4lk9cRxNnmKHljlc=;
        b=HWIDPT+iFydw9LA+lVFP0BSNLLbF1EnjD7yRJUdKo7o2hVwINUG8L6X4j2Xv/dI3f4
         nZuydt8Ktq52y/Afj/iZB/rXS1fmrB0fM8zI8xHqtt8NdToF5gFcJzWpPg9QxFEho0oo
         VUT+lLoUMfWZW8JMfw2Q8u+LosCXzggEz567TcBOttgzlwCoed3leFzLIEcrZugsMUg2
         u3mjCCmQtT4v8fcbEOmRVmZTYPLQOH65zJvQUrZ4nryjVl0ly7mJfxvaDWVXFWSngCFX
         iWK5xPOCH5zgO+WKhw4z/YZAd4lyWRgL9cW2ZKTmRF0g9w9pwA0BHRVZ0ToKky4jJnfs
         mRFA==
X-Gm-Message-State: AOAM531TIgfONTymBb5gKpJZhAWHVZBm+1RPRYcJnqjvomIo7YUnL7U4
        G1u+DsReOf1DrnAVLJrAeHZR6Q==
X-Google-Smtp-Source: ABdhPJxCmixWOKi0mabBWT2LmHuw7Hr3B/1k5C/ebhNqD+gtPsOiV8bMW0JtgPNMuzfSMoPstxUGqQ==
X-Received: by 2002:aca:a8cf:: with SMTP id r198mr634517oie.143.1626973237417;
        Thu, 22 Jul 2021 10:00:37 -0700 (PDT)
Received: from [192.168.17.50] ([189.219.74.83])
        by smtp.gmail.com with ESMTPSA id t7sm489781otl.25.2021.07.22.10.00.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Jul 2021 10:00:36 -0700 (PDT)
Subject: Re: [PATCH 5.10 000/125] 5.10.53-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, aford173@gmail.com
References: <20210722155624.672583740@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <beeb7568-388f-38e4-eb1f-28b1557bc191@linaro.org>
Date:   Thu, 22 Jul 2021 12:00:34 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210722155624.672583740@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 7/22/21 11:29 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.53 release.
> There are 125 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 24 Jul 2021 15:56:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.53-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Build regressions detected on Arm64:

   make --silent --keep-going --jobs=8 O=/home/tuxbuild/.cache/tuxmake/builds/current ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- 'CC=sccache aarch64-linux-gnu-gcc' 'HOSTCC=sccache gcc' dtbs
   Error: /builds/linux/arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi:298.1-13 Label or path usb2_clksel not found
   FATAL ERROR: Syntax error parsing input tree
   make[3]: *** [scripts/Makefile.lib:326: arch/arm64/boot/dts/renesas/r8a774a1-beacon-rzg2m-kit.dtb] Error 1
   make[3]: Target '__build' not remade because of errors.
   make[2]: *** [/builds/linux/scripts/Makefile.build:497: arch/arm64/boot/dts/renesas] Error 2
   make[2]: Target '__build' not remade because of errors.
   make[1]: *** [/builds/linux/Makefile:1359: dtbs] Error 2
   make: *** [Makefile:185: __sub-make] Error 2
   make: Target 'dtbs' not remade because of errors.


Greetings!

Daniel Díaz
daniel.diaz@linaro.org
