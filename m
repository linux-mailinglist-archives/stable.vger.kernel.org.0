Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23933383A52
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 18:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239895AbhEQQsB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 12:48:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242595AbhEQQrz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 12:47:55 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59841C04A04B;
        Mon, 17 May 2021 09:15:55 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id i5so5024682pgm.0;
        Mon, 17 May 2021 09:15:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7Yp6Eyxkhp5gDluerel0QRWQ5C1YolOL9RSoU0qywaM=;
        b=MlU0Vi0/gpo+dP0xQ6LB6sOFGJJJxPpV2/jC9BetYubue/P6ug1gAWSd+LZT9xzK04
         5I5TwTECUr+giSG8P5oRVd0mAo6nUeso1hfM+kDMFS5FY1uNfhSKokDIUkLHh/9RbOtb
         VueAqUYsisdxkZ9z9NqJr1wnkN+s8I7pimIFblHjm0lGWbg3qkO7LvzHugONHNdyFjPk
         6x+SuNIjVPOqm+N5dJAuvzJRJkzmBN0ML1Hrg9cUmL7dYxbLPX8EA15LpUsAGNu9pbsN
         nKmKAEZWDgWuQCZySWjM7wV2PYt/CAIh6FzuU44j2jHzQwvE9mkte6GH4/r+TpD7yNyN
         A42w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7Yp6Eyxkhp5gDluerel0QRWQ5C1YolOL9RSoU0qywaM=;
        b=MVQ6Tj4JXQ2das3pT4yrGg3+iU6zbnmIs8t7L50AdQWkUDE2fiOU7wKdT14+XOsgY1
         UrY5/UWgbRPpQwpEg1g/OSWcc5q2PnsruPcJFIE14/Q9F1gRvspBIf0ZhzHnKywfVYBc
         ajuc7HkVmbwMFogXQwoz4xv3CamyEfIuRyeJ6vE+XuVoZT3A+NsjTy4OHnPNLNHrm7FH
         Mdrc+SVWXfbh8ydSMXQEOWpqLMXVpqLqU4ZNcLOLQmKcPzG9bcOk0a7CsRCUw6LVlH6O
         tsMkslhwiO2jo4ZiaBzsLE/JxCcc8W8GdCcqQRZQcpacqeYt5h1o5q0aMWaHOAmcRZD+
         y4gQ==
X-Gm-Message-State: AOAM533PnaVYNu1vMSkjrPtwdSoLLtx0yYUtXJOybRqxoRYCnkxnHB5g
        MG/iLXlW/cVg23MY9rzpx1iVVTiv6q8=
X-Google-Smtp-Source: ABdhPJwqnT3rwId+dbuCI+usvDj3AqTgxdldAtAQZg0gCY7ZzbT3Y7DNrZIRMmKVjm6xTNnrFUSsHw==
X-Received: by 2002:a63:e114:: with SMTP id z20mr323553pgh.207.1621268154516;
        Mon, 17 May 2021 09:15:54 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i17sm10251593pfd.84.2021.05.17.09.15.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 May 2021 09:15:54 -0700 (PDT)
Subject: Re: [PATCH 5.11 000/329] 5.11.22-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210517140302.043055203@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <e5bdf2ac-7082-1393-f793-bcca4e220564@gmail.com>
Date:   Mon, 17 May 2021 09:15:50 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/17/2021 6:58 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.11.22 release.
> There are 329 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 19 May 2021 14:02:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.22-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Since we are still missing some key dependencies from 5.12 to boot
properly on ARCH_BRCMSTB I only build tested this branch to make sure
that ahci_brcm.c and pcie-brcmstb.c built fine, thanks!
-- 
Florian
