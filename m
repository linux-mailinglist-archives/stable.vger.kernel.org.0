Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 219EC348796
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 04:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbhCYDm1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Mar 2021 23:42:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbhCYDmK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Mar 2021 23:42:10 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB2E7C06174A;
        Wed, 24 Mar 2021 20:42:09 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id w3so632306ejc.4;
        Wed, 24 Mar 2021 20:42:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YrNEtx3GF0/17teyR0hvgZXPfUXgsIoIIciNQMJe7JY=;
        b=JAz1O4ARqZJl0bfX6yUgXWif4M4VBnibbeBadv60qzHLZ1NBZDLZv85jmMJhX8vsq0
         E01bQ/UHrrTFWh5cSZLcNyct3MeDnqYT5Lq+L0fYoB3B/2IVyP8rpYeQxeMfNB9d/Ngf
         nOcqzb7kBkC4sIh+YY93OKOzKru9myf9Bpj8+SBfEKfBoYz78VjANKsd6iRhULD3SYbw
         /7oDuL1uN8J8Ukn6/2mYzVDzAExfw6Z7UPodnqAPP3o54goehZX7C3ZCNPzjp5m1+UoC
         i8Nz4tOM0rUhfRt7n3w092NBpRivUsAUdvM8bvvNvwvD7NrpfwB6PjpumdFR287x4Gyy
         CqkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YrNEtx3GF0/17teyR0hvgZXPfUXgsIoIIciNQMJe7JY=;
        b=WaJCSYQT0X0yVoY1sDw56nocMc0WzMG5nnY/hq6o8Vxe62H/8Ow+WEE+qfIZXpn8OR
         rg2+eqso1tzNk0ExPUzsh2yjpWBJwxBxzMPAw2slfkTPuqOPBWYZvvG3Bh9C+y+Tnrc8
         g+aG7TaOnpCFtv7g6pqiPaQQ4BuWL9RIlZz9HR9+z4SkvEFgnA8C/wNUD7zTTLJ25sUG
         LtWYGYf7+nESd0c31MAFLubURPNcG+BkX5/ehgI9EeZfBrsvF6IbiIjcnTb88K9HRdHM
         lg9PA8IezePWRcmT1VxttVYUrXdKG2AMgjpdicZVbVui075k2rd2JsDDfazNJ+iM0Yoh
         M+XA==
X-Gm-Message-State: AOAM533bWIMol1mfe9JSFYrYFYbTV+hkOUPHUyMmj/EMnyYXFKBrmC0l
        J/xdfBLinpVEGQlZ+nhjQy3aZOHzRU4=
X-Google-Smtp-Source: ABdhPJydz85Tu3TOwLgNCL51DPDPcl/Q4cRN4rFoRk1bg9zUbthwekUwNNJ+Db3S6OCSWWfLpHAESw==
X-Received: by 2002:a17:906:22d2:: with SMTP id q18mr7064007eja.437.1616643728304;
        Wed, 24 Mar 2021 20:42:08 -0700 (PDT)
Received: from [192.168.1.67] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id bj7sm1853910ejb.28.2021.03.24.20.42.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Mar 2021 20:42:08 -0700 (PDT)
Subject: Re: [PATCH 5.10 000/150] 5.10.26-rc3 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210324093435.962321672@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <7bbdabd2-6212-38e5-0e3d-ddd764ddb3ce@gmail.com>
Date:   Wed, 24 Mar 2021 20:42:03 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210324093435.962321672@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/24/2021 2:40 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.26 release.
> There are 150 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 26 Mar 2021 09:33:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.26-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
