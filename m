Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49EDD454E8C
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 21:29:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbhKQUcK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 15:32:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232078AbhKQUcH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Nov 2021 15:32:07 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1220C061570;
        Wed, 17 Nov 2021 12:29:08 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id 7so8941713oip.12;
        Wed, 17 Nov 2021 12:29:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=l2c/Mo1vnDLVFgGYS+avexQqPx6Mzci3ar4zKnAbiR4=;
        b=mKdGecS8HQtyreL9XLvbh+pBuvhXx6VFllmWySale3mrOGaW6U0JuVz6aM+3jSr847
         KMkVVtWAhrdDVgVbQ9ApCeseBvIj4KarApgv42VFgEMbkgWV++Li7IxOLwk9z6/rhb5g
         joBaya2Jd5Eb9bW+yzqy7n8SVTihO8HKvolG1pknKrzVv6JY83FJCLl7zbVRMcH/wWDn
         BtSMloJst4YlXUi9UPeILNO9ZeMLD0JsI9lmoG8hBguj5XyRnyZiUXtbciFLildNht2x
         e6aiaFvIZkpi+F1K3MLp3d89m39mjUq277/kwUMN8ZVpX+/Xj0ZvWKFvakdIrCF/2Tl+
         Cwxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=l2c/Mo1vnDLVFgGYS+avexQqPx6Mzci3ar4zKnAbiR4=;
        b=Moq6IPAL8ucbMFTQH8PVi5YW3uwdFNTd08detVWXWdU6BFeyzFUd58W2aP62WvMIZF
         VQsLyCpd2hBu1OLVJqXtfZ8tenyvn49ka7K+NGokKUwshG9BGF9xTSTbwAcX7QYijX2u
         R2REWejMKoUSpDmmGxey3ylEeBqP4rMkk9ZCDYHKLwBmwXoHG3pfgGtiN+TzFYIJZ4Bp
         Z3//ZI8VFkE+Wxj/oQhveJFmR0t+if1CtBDNbZqjuHFYorUHyXJ17Wd4+YdydG3H6AFx
         L6cpEUHmZbb/ZCwbz4Q9s6hCaie9lzF2TVq2tCvt7Ir9FkMIEeVDA1Fufv6a1u/0sByK
         7eHw==
X-Gm-Message-State: AOAM531/Hx84vD6XHdNr0xFimV3IN4ecmGShsoK8JoEVv6XTvTHaQ/IM
        Vn5NlwFm35JzcUxg/TMYRi3RpBLtYSg=
X-Google-Smtp-Source: ABdhPJyj31JG2MY4d1T0MDP1XfV3MhwCecGO8wItWGkEq69uxIeU+BXXQboDn2Bb/PTZ242M3hdkTw==
X-Received: by 2002:a05:6808:bc2:: with SMTP id o2mr2500319oik.115.1637180947857;
        Wed, 17 Nov 2021 12:29:07 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n23sm199838oic.26.2021.11.17.12.29.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Nov 2021 12:29:06 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: [PATCH 5.10 000/569] 5.10.80-rc4 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
References: <20211117144602.341592498@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <97dfe80b-1847-2326-8fca-fc4318d115f7@roeck-us.net>
Date:   Wed, 17 Nov 2021 12:29:04 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211117144602.341592498@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 11/17/21 6:46 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.80 release.
> There are 569 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 19 Nov 2021 14:44:50 +0000.
> Anything received after that time might be too late.
> 

You were correct, v5.10.y also needs commit 19221e3083020 ("soc/tegra:
pmc: Fix imbalanced clock disabling in error code path") to fix the
following build warning.

drivers/soc/tegra/pmc.c: In function 'tegra_powergate_power_up':
drivers/soc/tegra/pmc.c:726:1: warning: label 'powergate_off' defined but not used [-Wunused-label]
   726 | powergate_off:

Guenter
