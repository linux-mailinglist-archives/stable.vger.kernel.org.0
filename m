Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A323409B67
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 19:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344127AbhIMR7a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 13:59:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239541AbhIMR7a (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 13:59:30 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20A51C061760;
        Mon, 13 Sep 2021 10:58:14 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id k23-20020a17090a591700b001976d2db364so633446pji.2;
        Mon, 13 Sep 2021 10:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=2WxYJlU4KgxAibTaNFJdmmGzS/DHdkvvb4gvwL9Mh1Y=;
        b=TXGyRVNe0bPy5rvyyn4bYcWetgu5T/kmnn71UQNpkBJd7L4YFAIiykR6rw5Th7iRyM
         0p/tfdS2b9RIjXQ0etwyo3htsY7pVFXNo55Z+jS/yaNrMRsppLAYp4ITstphq/s31oNe
         H1cYM0/ffQeLBrDpGS0KWC3YYCzBdV2QR5BxAMQp1ldb74XMewDm55edPbI2Blx5ArA5
         OrwQ3QUZLghrC7Ah2ZOm5OGHD6nrHS95NyZ7NDIvhK8E/EWYE2lJqx4J5xa30VEFyAqp
         RYURPNWAVVM+pv7HRO6ZEmUZchxqQUTUL3rZRoJDB1UTyaudUFDFthgkvmJlfxozIaoE
         sYCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:content-language:in-reply-to
         :content-transfer-encoding;
        bh=2WxYJlU4KgxAibTaNFJdmmGzS/DHdkvvb4gvwL9Mh1Y=;
        b=zxkE4MNUjOTw0jGLm9wKBoroGLITJBIYbpxuhaNMAN3SfOHpMw/ipdSstkoYZjZyk4
         DrKok5DKg/K8zORFRyBhI2HtVs3G1ambkTGbw0jx3ruQra59/d4XGRMbU9LdhzdVZ/Nb
         Oh8hijBl+zUCSJO4goszYZ1XofTsygeXfnSTNo1yqNdqyU0gLghVJXJTXKSF3ggOE33V
         7McIlumXsi9Mr+on/baEb2Y4OyUsx4Qp5USPudbv03oYsOuEGh9PTHeFuZGJN0SCrUU1
         4a6uUZ6fVObUhP3T7jM6GIRKhmBbnwdRqNZR7Az7Y9LTMedSGzH4s69fkbifGPZYn0Wz
         uMEQ==
X-Gm-Message-State: AOAM53224Sg+5BxSNogZT7OX+g4FxHYSVVm8oHNREG4m69BKvsEcovRu
        7DMsZLYPNcc5OkrggC3XFjw=
X-Google-Smtp-Source: ABdhPJzI0KrpRfiWcYhOnllOEjiHIN67Ns0FDxBjWkGp1S/dcA2fxVKLCKgHzxjG79tA86T5h0B0og==
X-Received: by 2002:a17:902:7103:b0:13a:356c:d0e8 with SMTP id a3-20020a170902710300b0013a356cd0e8mr11558509pll.32.1631555893603;
        Mon, 13 Sep 2021 10:58:13 -0700 (PDT)
Received: from [192.168.1.121] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id l9sm7511994pjz.55.2021.09.13.10.58.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Sep 2021 10:58:13 -0700 (PDT)
Message-ID: <10bc90e1-21e9-42d3-3bf4-02b396b6419e@gmail.com>
Date:   Mon, 13 Sep 2021 10:58:11 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.13 000/300] 5.13.17-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210913131109.253835823@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 9/13/2021 6:11 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.13.17 release.
> There are 300 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Sep 2021 13:10:21 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.17-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

