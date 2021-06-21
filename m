Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80CA43AF646
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 21:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbhFUTlg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 15:41:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230520AbhFUTlg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Jun 2021 15:41:36 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EFF6C061574;
        Mon, 21 Jun 2021 12:39:21 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id y21so3288751plb.4;
        Mon, 21 Jun 2021 12:39:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fw8e0QGAyBFyQwC0T6EatUmLOF1fUFPjIT22kDbtqW0=;
        b=qwG9NpTVN83UAvrRCZPveYHBZdAfHjqEl0bHubMuURwCAKtSgiIU2pFN8kjOmm8G7d
         td3iFjCpdOl4Jx22sspGPUUyn85gZxn0iBFeW6vjT6f6AmFJZS4ihzwJv3w7DMM7QT0Y
         GKBOO08rfwu3vHQeO/VORztw2ESbIQnhYvYqACHH3YKF712vX9tTOFXX8TpmyFmkW4ph
         YZ6GKrOtVF4TUzokp63Z56BM1ZutmMGWxO298EasDu5KBLP6IpaAVlJr0Po4GWhSElCV
         7rlax4oVPdBfSRo7XYYT03KqmPzmBPAQaChWk10f3PbnEUezeM7etjb/F2Dl+oIca9p9
         ZL1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fw8e0QGAyBFyQwC0T6EatUmLOF1fUFPjIT22kDbtqW0=;
        b=D1Hq+ruZbOjZWXjSA6CmokukKQS0aVjqM78sKQZ4Lr+An60ZCACOgaKuhH8w/fDKft
         yMja12c5foil2qQbFf4kgAX3VuJjyiPtstIuRAF2//kHEJkyhlv4jATneNQ1YCuqo3qt
         P4ubUFtRR7nuBDr7SMHaRL4sEdvnXy0hAkluKhiasDmJVCGxDUMX5nO/FAWJ3JW49RWk
         qit+i1Gs40v90IK+qQqYkPRmnsRHlaCNKSWjLHPTRkKZlHDVEkRaSk2JZWDyWzsYoQBe
         fQ0n2V8cpxiAEOr/CspkDcIbYdr+1XjLzcZGEB7R4S618hYw4PgrTT1Q8P8CTU2Hw0FZ
         hOtg==
X-Gm-Message-State: AOAM530mEGWXnxXVkZYpbcPo1nhISdM0z1sr+XlxAsOg0XrmsmhUZ/oN
        zcSqNc0kqrvy3sxnj/2ecTT5EXtF6ik=
X-Google-Smtp-Source: ABdhPJwb9qcdX1mAgaEHhLd2n8/gbzdz2XewzZKvvFfs+yajTPbXnKE0Jtfw0UPctg1wRFv3JebVFg==
X-Received: by 2002:a17:90a:cc08:: with SMTP id b8mr143348pju.128.1624304360776;
        Mon, 21 Jun 2021 12:39:20 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id n129sm15759882pfn.167.2021.06.21.12.39.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Jun 2021 12:39:20 -0700 (PDT)
Subject: Re: [PATCH 5.12 000/178] 5.12.13-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210621154921.212599475@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <eecadf15-5a8f-696f-46c2-349bf6bd91b3@gmail.com>
Date:   Mon, 21 Jun 2021 12:39:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/21/21 9:13 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.13 release.
> There are 178 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Jun 2021 15:48:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.13-rc1.gz
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
