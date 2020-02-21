Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9D00168030
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 15:28:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727851AbgBUO2S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 09:28:18 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:32907 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727096AbgBUO2R (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Feb 2020 09:28:17 -0500
Received: by mail-pj1-f67.google.com with SMTP id m7so2256034pjs.0;
        Fri, 21 Feb 2020 06:28:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=b07MWTn4cm5EQDnXMvps62Xb+DMWIEbzB/N2nZP5EJc=;
        b=YxyjHCnKvD+YTlSVeD2WndCNtWCgtNBt3DoWN2SY3iTVE0tVoHI4cETnpNKHgZ6zZv
         IiY97qUXT4cBsNlONXv2XM1sH7E24Gylxc2TNmbAv1i9GunXTBIQ8EU8AM7pYZbM+xpf
         dFEoz+Cl7Kjqsq9ABsGyyo8cafmZxbRJ5wwvrGqwKuXOy5AAm9lZP5Y1o1ib8Mkl4T4/
         tdbu94mhT0NASbb713Vp3YKZT6HQTpc9MpXQbFtJAv5JbR3+zx7bvf1arCW7oK0Kquf/
         yHmzcT3q5kM9keK603WNadGKLdg0PJA27U1OJDAdvAdUbDyQn8ON+O2ctUrAcE0unTPo
         4EMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=b07MWTn4cm5EQDnXMvps62Xb+DMWIEbzB/N2nZP5EJc=;
        b=Zqd6yZl6s/mH35aeKS0CrpS73SuEXoL/v2H6fbMRua2K4maV+rqzSRABPbyVrl8DrY
         JnE9tzjzx5MCU4TSH46/SdKJUTOZL3N+wOXxloawSQxCssh/WEjyLi2oELiQ7WxY+CaT
         lkBkbhiy8BF+6XWTsqTVpeOMost11AFIpygouwEvylcFZppuIh7MdTjR7VbShPnEWfnr
         jMC0cu8K0IL2Du+zzfREeMnwAHCOctj8/gC0uMNfbx+XtrMgP1JmlchCP/dp3wB+SP2q
         4hwlnKbOmXL6GjLeg3uHcMAlm19soNvWVZ2Joag+2BIEjjr84GwXvqmMIbYnJfSRIfbE
         PtUQ==
X-Gm-Message-State: APjAAAUu08v9VBZsGRtzrkrtRAjQE1zshUlyk9hc0zJKJg8gcNsBBPrF
        U/IRDWMqmls8lw7dJaNzvFQ7CUCu
X-Google-Smtp-Source: APXvYqzAXQTHNbdbQHNiXtkaONDUCcFbsbpalG9qfDUodFeWGInCtGpHbOlNkclGQ/tzE1OxpHmrtg==
X-Received: by 2002:a17:902:b215:: with SMTP id t21mr36597410plr.190.1582295296551;
        Fri, 21 Feb 2020 06:28:16 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f81sm3069725pfa.118.2020.02.21.06.28.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2020 06:28:15 -0800 (PST)
Subject: Re: [PATCH 5.4 000/344] 5.4.22-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20200221072349.335551332@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <4e8cb265-4745-4249-45e4-86bd84f068ed@roeck-us.net>
Date:   Fri, 21 Feb 2020 06:28:14 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/20/20 11:36 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.22 release.
> There are 344 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 23 Feb 2020 07:19:49 +0000.
> Anything received after that time might be too late.
> 

As already reported:

Build reference: v5.4.21-345-gbae6e9bf73af
gcc version: arm-linux-gnueabi-gcc (GCC) 9.2.0

Building arm:allmodconfig ... failed
Building arm:omap2plus_defconfig ... failed
--------------
Error log:
arch/arm/mach-omap2/pdata-quirks.c:27:10: fatal error: linux/platform_data/ti-prm.h: No such file or directory

Also:

Building powerpc:defconfig ... failed
Building powerpc:mpc83xx_defconfig ... failed
--------------
Error log:
drivers/rtc/rtc-ds1307.c:1570:21: error: variable 'regmap_config' has initializer but incomplete type

as well as various follow-up errors.

The second problem affects both v5.4.y and v5.5.y.

Guenter
