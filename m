Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C91A112F92E
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 15:27:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727598AbgACO14 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 09:27:56 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41980 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727543AbgACO14 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jan 2020 09:27:56 -0500
Received: by mail-pf1-f195.google.com with SMTP id w62so23620401pfw.8;
        Fri, 03 Jan 2020 06:27:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2UEgk7Xlp4vtJRrJrDq/jOr+mLPoas4s+u6gscDHuPE=;
        b=KVKQXXlyk/FkWCCdC8Y0Iot7VGV3g/WcuVMgRC3lEUJUnDeDv92oH/skUI9wQQPwwq
         ghikwk7x3PcUDGkqmYZmnQOaodPRVy0CdJtbZWKIpF1mUYfFiRI7r+d3Nd454HgfPA0r
         gLc/10KcrXUiWL35+QqkORnK5Cs534uDLK+YwqMyr+chUrIMqWtvttW+rcmj9sbFdMgK
         wQB2Qd5JG4kZqvwHCYdlWh6kfCHWyHcLc2QKcF3GiYwsDggUD2WaRojDxekIzwhTdYWw
         SNBE5zMlmy3eVfrJV09052RqcrfA4HnmmdxoKa3niA1wKPQLEWM+BkQa7tIRivKmmFB6
         svAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2UEgk7Xlp4vtJRrJrDq/jOr+mLPoas4s+u6gscDHuPE=;
        b=SLofBryTKj4DRX48DvxwJyExjqb04T5iuzzSKwpHJiy6k5oLjDn9rb49pEnlKtjFmq
         sW0PHwvNz/FxoJmuKj1MLFE0mW4aipAtZrmRFW4MBwXp9PR5nyrfUiEzrYkXpVUezqvt
         47JtuwGMsDx89EkMW0nTHs7xyoS8l1CwAhxb6PpyND6OrWVcEBlfOmlT8RaHMTbrIxaC
         JABEFFbyoP8tWe5gYFwhn34GY1sLB8rw2Bhd4Zp7qg8FDWYrUWy7vjNtkC1kVdKcUZHZ
         02EivPbPT85yma9r+pe47DNrsyLJT1Tv2E5EONJObfwzvALjJbI5IsWDAywYlPEI5OQU
         Lpwg==
X-Gm-Message-State: APjAAAVx0DMxwVuoiyOnvRyEaaPcisymVhXQnxo8s0sAYE73XJhowOHx
        QiGOD9oCxV6la8oAeN0iPBgP21x/
X-Google-Smtp-Source: APXvYqwJwcz1UUVvUVmE8tzDRw0UTR3JC4ZYN6aNc4uQjho9c/ZTYTwdmb/jlOr7prJglG1Uamisvw==
X-Received: by 2002:a62:1783:: with SMTP id 125mr76679400pfx.189.1578061675388;
        Fri, 03 Jan 2020 06:27:55 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y4sm15047277pjw.9.2020.01.03.06.27.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jan 2020 06:27:54 -0800 (PST)
Subject: Re: [PATCH 4.19 000/114] 4.19.93-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20200102220029.183913184@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <72f41f89-bf68-d275-2f1e-d33a91b5e6cd@roeck-us.net>
Date:   Fri, 3 Jan 2020 06:27:53 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200102220029.183913184@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/2/20 2:06 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.93 release.
> There are 114 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 04 Jan 2020 21:58:48 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 155 fail: 1
Failed builds:
	sparc64:allmodconfig
Qemu test results:
	total: 381 pass: 381 fail: 0

ERROR: "of_irq_to_resource" [drivers/spi/spi-fsl-spi.ko] undefined!

Caused by 3194d2533eff ("spi: fsl: don't map irq during probe")
which is missing its fix, 63aa6a692595 ("spi: fsl: use platform_get_irq()
instead of of_irq_to_resource()")

Guenter

