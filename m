Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66D4237922D
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 17:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237167AbhEJPNV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 11:13:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234322AbhEJPNB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 11:13:01 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A5D9C0515C3;
        Mon, 10 May 2021 07:31:43 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id t2-20020a17090ae502b029015b0fbfbc50so10172662pjy.3;
        Mon, 10 May 2021 07:31:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9kClovlLUzpEzdz9iQ8IeZeld5vvQVt6iXPVE+HL4YM=;
        b=u48VD+hwED7xcX38VtJhi47WwAO9cQG6I8MLVYZZtbQb+DGl/lw3YK0RP8xV2rxAB2
         LSEQyuvFTO7dD7f5k6cO3DRHdGTrg8pCnjPj07HlqhiJFzJg0lzJt7yX1qPsr6pI3fKU
         aeMcmQ12nPYXZMvhmG2iWcLV6y147M/Vnke0nByx/tFoBI+gkSajnCZtZQQ1FlKjZsEz
         2oipMwl5CYWulA4kbM3iHbCoYw+w0Q5GdvAv2LxcM99NK64OgVqd1SehQFXnxLmdDXWk
         ZANG+gp6x1BilL8e3VYZlCx8QqCwRB+A1aQHkC6EkZu//fW4llyk9MJV+8JWeXnZF0lf
         xRfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9kClovlLUzpEzdz9iQ8IeZeld5vvQVt6iXPVE+HL4YM=;
        b=b7zsUtTuKE4kRK2FQ65n6+7SucKe9TYOZQaST/kUEK7whNqwzvfsTVOQN8cc9jhsEN
         DK8mJ48maLS2qJCVk1NBG9P/yBvcrC+6gAXlDhww4wSzxS+ktWkbW4Ics630wJblVJBH
         j8ewqFQtBLh1uQvcWJcxcjsTKasMXgvvFMpn3D7qRnHu8EF4vgO8n7G+NhGwCjG0KRy1
         7u9rIAdbV42W7OSCWHoEbI7VdG/ldzBmR39vEilYvc/sqC24H4++HbHktLodCmlWbtut
         yijkC473Jikb9kG68gWDZidZAEtFyxZh34PTEuRoDjE8/ebb8FC9cEwJyhdeyuRuUWPD
         FsXw==
X-Gm-Message-State: AOAM532r2ZtLZNuUhMMKPjmmPlsHq1EPLyY8EwQTED4jnp+Lyu/2Vm4g
        oSvWqqpjdDjnNiiHYC+9WHQQV+Kanw4=
X-Google-Smtp-Source: ABdhPJwMkiz1inLmeKZ8K3a5VA9LgixaPhrWIfS9KKuelLIyliIRMWh/Ia39J8oZ89BUW1ucktKKdg==
X-Received: by 2002:a17:90a:b389:: with SMTP id e9mr16116612pjr.56.1620657102532;
        Mon, 10 May 2021 07:31:42 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j27sm11836247pgb.54.2021.05.10.07.31.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 May 2021 07:31:41 -0700 (PDT)
Subject: Re: [PATCH 5.4 000/184] 5.4.118-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210510101950.200777181@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <4f9ee283-0b79-74ed-7bde-e8bb09675978@gmail.com>
Date:   Mon, 10 May 2021 07:31:34 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210510101950.200777181@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/10/2021 3:18 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.118 release.
> There are 184 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 May 2021 10:19:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.118-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
