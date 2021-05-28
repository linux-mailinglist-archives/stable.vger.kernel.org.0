Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B01C3939EC
	for <lists+stable@lfdr.de>; Fri, 28 May 2021 02:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235754AbhE1ADJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 20:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235598AbhE1ADJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 May 2021 20:03:09 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34078C061574
        for <stable@vger.kernel.org>; Thu, 27 May 2021 17:01:34 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id k16so2350665ios.10
        for <stable@vger.kernel.org>; Thu, 27 May 2021 17:01:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LnyhJn5gtIF03M0Kgg95HPA1ShOuz0j+8xu9tClOGIQ=;
        b=ZgUBeBJUY2NCUOMuXcUjso9Y8KC/krnv5BbHo0ouPiMQ+gyhu9VjtDGsHT2pwi0yKb
         CkNZODQSCCRQUdOyZk+5dKGD4TaTpJ+TNqzwomWcgVGBPcaQ6jPashPef/t3yEBy0avW
         kdQwtK6rx6wOmuaIEBhHFRgLfHMwE5Xzl2THQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LnyhJn5gtIF03M0Kgg95HPA1ShOuz0j+8xu9tClOGIQ=;
        b=Ox0/gzL/bF4NhXYuAhS/dQdX/QEy0jRC/TpIx6i8H47tGL39wjXFjyfvN7DqRn/7/t
         iImNtMiR8rH61bnxXnSa1yUDpkGc3ofo8oTwBzE8XL7cUI0IyOarEn7eSHgfHviQPgyN
         zIorjXRfDNDKi0NJo7iX/0ZMhFgi5ReWQJyKnEIO79CpcSLFvvWj2uuOOQYWz/EDAUCJ
         La/HId7lvJoXXX+JadAvZETZFoa8e3N2zmqPeEI1RhMLuvFYhYHe9FegBqFhikVPVJ3F
         d2j0Km1FMqNL+JTVP9hWlDSBeajt9dxYjJpopJo2ysu74m4QiPdkOBCtn4NrubbEgJJ9
         gUng==
X-Gm-Message-State: AOAM5339dLSlYUTkgkPVmng4nNuy/galSb17k+anLVJ6us1YrtwWSmDn
        Zo4gOkZFwA1o42R4el0UNylb4g==
X-Google-Smtp-Source: ABdhPJxPvrMFMBOEG7KzJnYu38xBVhgmDMwGxbW2oo7wEFwiWHDT8M1GCHSeNKy85RIuPpHcYKYv5w==
X-Received: by 2002:a6b:d80b:: with SMTP id y11mr4933274iob.202.1622160093570;
        Thu, 27 May 2021 17:01:33 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id 11sm1963376ilg.50.2021.05.27.17.01.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 May 2021 17:01:33 -0700 (PDT)
Subject: Re: [PATCH 5.4 0/7] 5.4.123-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210527151139.224619013@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <1c9a7080-bbba-6a1a-45f6-49ed2d91881e@linuxfoundation.org>
Date:   Thu, 27 May 2021 18:01:32 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210527151139.224619013@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/27/21 9:12 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.123 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 May 2021 15:11:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.123-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
