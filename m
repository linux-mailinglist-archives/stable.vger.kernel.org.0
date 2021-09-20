Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2EE3412CEE
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 04:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242283AbhIUCs1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 22:48:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348926AbhIUCZA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Sep 2021 22:25:00 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55D74C0A8891;
        Mon, 20 Sep 2021 11:53:01 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id p12-20020a17090adf8c00b0019c959bc795so671744pjv.1;
        Mon, 20 Sep 2021 11:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=m5BJH16boVP7rRcxwqeiaoZfcWc5Kg084T+ceyYOfzo=;
        b=oJc/mSWJ+6G5qMi+zuSGSH9E9w6QKkTk5a8HuUBIl0Yak9fvmcsArwM6i8VZQZcfjM
         FZyl/1gPNCHqOENpkm3HTtAVqk+M7cYPtkr3rLUiNT1QnaLT+DFylTknRNrncbayaa8c
         KHYcOjKHnq1DXAAW+pZCIppmT2Uzf03STjYQ8ULXwDEgZgFH6XJHRD2SzlY1PDJ5Bba/
         zrNW3ZIjRR27DY3nwpZqJ9Pi1pkyfRxd2fdqTsAU1BsqaxjLo474SIdmBPOGLLCYBnZn
         DRmqdl+5O25sZ1XWGhRVuEVI3HXF1Opy0y9TUqQDhJOtmdRIniofg36aXvY0Y2j3vAoQ
         JybQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=m5BJH16boVP7rRcxwqeiaoZfcWc5Kg084T+ceyYOfzo=;
        b=DUGwy9uxCejeQc0EEH7aqB599LcafUEPGvgMVy80Qdr2DIovAu1Ly1WJdsiOkA+JOZ
         8otOeqA+Eo7SUf9i6OHjLAPhwpG+ubzNuWbA3jFHFipPtNIvaG+D5Yhz576J1285NfDm
         AF6UqppELF2suekSNoCzcc2vSCq2x7yNtACbzi5dmkNVVJ4eKNR7sGBLL7O1VEb5TSNQ
         HnZTJP7VSkOrtFT0RwSZl7lWYR4cLiHNzgmp4ulVWR7gO/RUjQCZ3y5gRSRPfLvHJTxG
         EcaJ896e28xPNcl30m+N9ShYY02d6oB5kK9Ho7/qNm4vm49GftIPE4Oq0rmoqHqYu0id
         Fikg==
X-Gm-Message-State: AOAM533G/1Y0Ah5Tn2GuBrXoi4eg+DgJ2fFpUqDL0UV2PPgWh4l7bl99
        QMaLyi0YkzWr75+wSBvENnqnWaz10nE=
X-Google-Smtp-Source: ABdhPJy5NSfuI0AqjYGXwD2OlgtSs/4jSGaCEqNWfEX46HZINvEbcu5J4GCPhQbKO5tWzpKOJ4LcIA==
X-Received: by 2002:a17:902:e752:b0:13b:7e90:af8b with SMTP id p18-20020a170902e75200b0013b7e90af8bmr23778990plf.12.1632163980272;
        Mon, 20 Sep 2021 11:53:00 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id t13sm577924pjj.1.2021.09.20.11.52.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Sep 2021 11:52:59 -0700 (PDT)
Subject: Re: [PATCH 5.10 000/122] 5.10.68-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210920163915.757887582@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <27465b72-212f-9f09-478f-2f8b3032620d@gmail.com>
Date:   Mon, 20 Sep 2021 11:52:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210920163915.757887582@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/20/21 9:42 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.68 release.
> There are 122 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Sep 2021 16:38:49 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.68-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

[snip]

> Rafał Miłecki <rafal@milecki.pl>
>     net: dsa: b53: Set correct number of ports in the DSA struct

This patch will cause an out of bounds access on two platforms that use
the b53 driver, you would need to wait for this commit:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=02319bf15acf54004216e40ac9c171437f24be24

to land in Linus' tree and then you can also take Rafal's b53 change.
This is applicable to both the 5.14 and 5.10 trees and any tree where
this change would be back ported to in between.

Thank you!
-- 
Florian
