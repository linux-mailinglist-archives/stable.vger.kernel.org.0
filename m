Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70ABB35D4DA
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 03:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240441AbhDMBdv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 21:33:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237080AbhDMBdu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Apr 2021 21:33:50 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87AADC061574
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 18:33:31 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id s16so10187636iog.9
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 18:33:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1zSwk+CCEogc630LEHl5RvzQDUBmzTV2qxrYb9cB3Hk=;
        b=B24q9wJST01FRsZsarkzCP1lwZwRPEPqExf6Hu+l/Kd+8WaisnQaG2zYdisMujlv6p
         iEBaVOeXwEFVP1jH7Rg21zTxYBAQmOie3LIGcikrH3h5CbA4X2ZraHhvETVDtiEs+oTz
         05OaRttzVMbn9jULtSrdCOCB1AHayAtbKOGrA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1zSwk+CCEogc630LEHl5RvzQDUBmzTV2qxrYb9cB3Hk=;
        b=dUNZtEB5HFTBD6qp76rVuOGXMLUBEjqD/Ctr2BDbTX6Zx9hN1vzj4tYRRojHty2ixE
         /npzYB2yUgx/SXU5DcyDFM9gAB6cXQtI0RGDzAI9N2TZ04NFlB9LcWIwuvGNaIiCb54d
         wq9toX+cBmSg9odFC7/tTbe0x3LANhvznpxuuu/ZniEEH6+O/xpwOXM1td0UZ+A1OTfd
         M5VF+2KUe/A8V5LK2ptHh8gE4SVmiPcYgfYc6vpMyQdrtbKkdwW6rE/OEEFF3EtyxmXf
         kTNQEf8/11XmD5Aal6LsTxb440XdC4dYd7+XuD1/p/Zz7wz/MVZ2qdtNx93KsghK1Igh
         1EOg==
X-Gm-Message-State: AOAM530GGobItqpq1hN3qRUDZdTJJDZvDBqcT6HmG4CVNklfo17ykh+a
        05YkQwGqp8yFMeTapvEipxJ6MA==
X-Google-Smtp-Source: ABdhPJyTolXxo/bbblE34HUnjb7BH2KP2F7vK26sDVYh2nVRsnaWeDarYtarehVPQTIQI1b3deRutg==
X-Received: by 2002:a02:272d:: with SMTP id g45mr31833069jaa.117.1618277610753;
        Mon, 12 Apr 2021 18:33:30 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id z12sm6369144ilb.18.2021.04.12.18.33.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Apr 2021 18:33:30 -0700 (PDT)
Subject: Re: [PATCH 5.11 000/210] 5.11.14-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <bd74f887-f858-e69e-86e1-6104cf95a4ca@linuxfoundation.org>
Date:   Mon, 12 Apr 2021 19:33:29 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/12/21 2:38 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.11.14 release.
> There are 210 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Apr 2021 08:39:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.14-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
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
