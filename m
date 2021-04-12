Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E76DF35D0D2
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 21:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245157AbhDLTIX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 15:08:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245173AbhDLTIW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Apr 2021 15:08:22 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94806C061574;
        Mon, 12 Apr 2021 12:08:04 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id nm3-20020a17090b19c3b029014e1bbf6c60so3483483pjb.4;
        Mon, 12 Apr 2021 12:08:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Fl5cKkzo+oqLjKg2i6xIeWK/R01U0ObuWWVBW7+vdcY=;
        b=GBwCmTuGtULiJ7e4vQSxdFj42Zufpr8QPIglVZiG4BzywNfVqccbmgo3HKHuqgSjpw
         q/xXjEsL0va8NwCnVrQKFtqX+hv0vewRzSDf/cDizfX7IIqZh1rrzn0d+uEvZEWlFbF2
         K/3O6LLIYZzG94yqu4InHV3vReUcvI5D1EVVhK6PC+UJcPY81apdxCy0UzO3HjGJmMf5
         DL+3WS23hftt3Mw+VFWi8jWqN2fM8jfP1AzPwFJDecF26v8wx+TSLVgkbJMyAmL/yB15
         pyL8N1rw4jW8A4c0ordFcht3CrjgL7UylGN7PTu7UIXYHlN1yzhpm0aj0r3HZc2+h0kR
         6XYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Fl5cKkzo+oqLjKg2i6xIeWK/R01U0ObuWWVBW7+vdcY=;
        b=f3XSyL7+Q5PtgSCvck2n+yZ7v1mpthmPVr6iAAbbePS+W6taePKnpzQPzVGfEOJIn9
         Tegx6cEPVLECkMlQSU6fB4TSL8rVNgcNvk633VvabOl2jO+eNNtAMHQMhzlqI2k6oDmZ
         7dz0/j5hujWyTHOZf5FbMGDRek8uWiLw8D9vLcAWYVUqx7U6pl9WoConJ71IlIvF62pT
         jFpZSlgFh0ZNWaSmHNUneBdGMoAyOjBmJ5rB5qKLzm279iQDy7fq2dWP0XpqZiaXgF33
         kalBaeB7r70tyZ5/hloIi4+U0atsmYGE37ajQTiYz2bmp+jf+nVDNDa8DJkmzF5tuV1/
         Eifg==
X-Gm-Message-State: AOAM530SUpx2AtT32JHMz3vXi1NVemGZKbzZ5WNbflcerh44yDvR5b2n
        6uoSM6SELbofgbqsmqJnEndaabFEwZ4=
X-Google-Smtp-Source: ABdhPJxZR7UOmXm0T/0tpM00oI7VZBgjA2u5J21mcqGl3KbjR2FRQBZhO+VVUysYx8670Q1NPraaQw==
X-Received: by 2002:a17:90a:c788:: with SMTP id gn8mr671521pjb.60.1618254483580;
        Mon, 12 Apr 2021 12:08:03 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e31sm186965pjk.4.2021.04.12.12.07.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Apr 2021 12:08:03 -0700 (PDT)
Subject: Re: [PATCH 5.10 000/188] 5.10.30-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210412084013.643370347@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <8fc3537b-1165-5cb6-2070-9068cccc22cd@gmail.com>
Date:   Mon, 12 Apr 2021 12:07:55 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/12/2021 1:38 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.30 release.
> There are 188 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Apr 2021 08:39:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.30-rc1.gz
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
