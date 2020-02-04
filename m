Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10DB8151C73
	for <lists+stable@lfdr.de>; Tue,  4 Feb 2020 15:44:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727261AbgBDOoB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Feb 2020 09:44:01 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:51123 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727279AbgBDOoA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Feb 2020 09:44:00 -0500
Received: by mail-pj1-f66.google.com with SMTP id r67so1469332pjb.0;
        Tue, 04 Feb 2020 06:44:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8n810gaGJvuL2/9scbf9Fe+76HM2g6iAgGCEUyKkt88=;
        b=HvogxxIGZLajYutQIqHhjSNzgdIWOdt53DrmV6sIFa97n81BzHiHQMzQ4kP/ePA06V
         SHDbpcwL3TH0Ca7ZQSn0IUSD368G/6seVWzjCirotXdECqKUq6rDWqAq9usPrfp2e7nM
         w3hWUTW1igTD8tX7qtLTXTZ1yTDeiJV/i57jes1D8k+teYxlIWrm58yMhFK6m6Rsg2j2
         hA0p07ZNmhqp7SynDYELfXJhpXbUgoYNqt3Ydok3o12WcXvOalvR6rLiaSPcFX00GYUW
         KThToPYxWFnrF665HgRLHsKyXwUmiPv/gzUNxA7ohlNMPrMAmONihXECPOWVRQLgqKfk
         ATnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8n810gaGJvuL2/9scbf9Fe+76HM2g6iAgGCEUyKkt88=;
        b=b5bObNLbdePqR34YN2s3ho/G/w411SY77WJztrzLsRP9frAQp9BVRhvbEyfB0GsQ7D
         nwtLzbOk5miD+95dIj4vIYZal88V6RvWxJEIaxQc2IiwGEugmgPk3SgdRTKjKYNjUxYG
         meIZYy/hh/id8i1uFoRLxjUz3PJX5kcB6IAB0Vrft5PXrTKOaTOiIBR7y8rqDcHPAS7L
         fDDJgdpLqppdrQzoThMwU3ynWrHXu1vic0Ug+ENfy9H9RpOETlCtPMXMot7K4qnXjKW9
         oEKt5EqNc1v0OHtdpbgPu8VSkgWNOBku/M8JTkBP2mdHWt9FsMsAKin1kMG1yjw0xjQi
         A2RQ==
X-Gm-Message-State: APjAAAUrQx9pU2U8i4mRhxMDk8uwH8qiKiP5B70lljrAi9GKh125cSLN
        xut8nh4eKR+vNu7xoG8YJvcR22Fp
X-Google-Smtp-Source: APXvYqxthy5HpgQTLe7bGeZlbz4t/D9rqFcBLoDbg3oaO7UibdPjMnWH0TfWPdt9HHmk27jaa+7q6w==
X-Received: by 2002:a17:90a:cc02:: with SMTP id b2mr6565751pju.137.1580827439993;
        Tue, 04 Feb 2020 06:43:59 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l12sm2860348pgj.16.2020.02.04.06.43.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Feb 2020 06:43:59 -0800 (PST)
Subject: Re: [PATCH 4.4 00/53] 4.4.213-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20200203161902.714326084@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <3bd0423b-478e-d626-88e7-5d62167ee7e0@roeck-us.net>
Date:   Tue, 4 Feb 2020 06:43:58 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200203161902.714326084@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/3/20 8:18 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.213 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Feb 2020 16:17:59 +0000.
> Anything received after that time might be too late.
> 

arm:{allmodconfig, omap2plus_defconfig, imx_v6_v7_defconfig}"

arch/arm/kernel/hyp-stub.S: Assembler messages:
arch/arm/kernel/hyp-stub.S:147: Error: selected processor does not support `ubfx r7,r7,#16,#4' in ARM mode

Guenter
