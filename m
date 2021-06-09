Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABFE93A1D46
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 20:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbhFIS70 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 14:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbhFIS7Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Jun 2021 14:59:25 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EFD8C061574;
        Wed,  9 Jun 2021 11:57:17 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id pi6-20020a17090b1e46b029015cec51d7cdso2050020pjb.5;
        Wed, 09 Jun 2021 11:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CvxEU/y35Z5QN5sL8S8hykpRPTn1Es2BsdTK3qOc3+I=;
        b=fE0Ww7iNwkGqvdAWPbgomHkAdJbjGyU2V+FE1Q4UwsuOgdWc64qwFAyS5oEYhbQPUb
         Je4WMohE3sqLsKgI2uIOvUuX6ZoOlrrbWutgNqBKK6yW0KuAeWflWjmMNMUxkRJwK6uH
         s/mvtpvqDnTbc/ukvienMrXpGbMAEIXMPzZ5uwgFD8EzRpd2mroOYQsoo8iJGA2de1Xf
         6pKATcR2ad4BBw475PhfQnxPgJbHu92n7SGqOCLXRSxUkyi0PVgG3PoJ7/EquMMris/o
         ciD0/zkCYBkvbFaSBNTqvDQXS9zrKE1gNzTGywapAuLT4Ie/s0XuRGf4+ey2XZWtl+ZW
         tAmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CvxEU/y35Z5QN5sL8S8hykpRPTn1Es2BsdTK3qOc3+I=;
        b=eP61DnxYiPs2+lYtDOYbxO/PhzHpzzMMyy/KSfBJgiumU/wBJ3/vC+tjrXyvD0orqC
         XTfK9fOS3JOvJ79EwvLtGIEVFX1z4npkyxRIRVGyvVBsbwQn4cJnw0T5OkuXI5jG3nP9
         fdqN32JvSSM5hI0+OxAeEzk5t/lR/O8MNaQj8UUFehc6eewkKIScOB+kvvIsTOoGPpZl
         6LjgPAzYRljg9p64FP5PMEgysNgTRquT5oDJuHyxo3phsdDSGFE/ssrVjbGBiaVQNPDL
         AuVxIDqfv9KCnfjHjXL2r6KFTpxWUQf9WpB1k2Biiryt4v6QeZvuBenS7pAgsbdrwB0f
         9b3A==
X-Gm-Message-State: AOAM531/N9amgKkcQFHJcObVjM8p+a85Z5ZCDnrPcSEbDGzDsEQJ8tG/
        jFR6KQt2D5nGZIdvVxEaUlnLyVatL9k=
X-Google-Smtp-Source: ABdhPJyUfcNXUJdVNNXso7nr+i/I4ht//3UF6nRgO45MisFQct3BB6DP/w1UIX52/W2oaZIZ8741cg==
X-Received: by 2002:a17:90a:17ad:: with SMTP id q42mr12223103pja.181.1623265035308;
        Wed, 09 Jun 2021 11:57:15 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i21sm263276pfd.219.2021.06.09.11.57.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 11:57:14 -0700 (PDT)
Subject: Re: [PATCH 5.12 000/161] 5.12.10-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210608175945.476074951@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <c7f17da8-7099-9e7e-a71e-24ee5f578f7f@gmail.com>
Date:   Wed, 9 Jun 2021 11:57:07 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 6/8/2021 11:25 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.10 release.
> There are 161 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Jun 2021 17:59:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
