Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 324803CEA32
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 19:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348228AbhGSRJA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 13:09:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376972AbhGSRGZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 13:06:25 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A37B5C06178C;
        Mon, 19 Jul 2021 10:29:04 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 70so16385915pgh.2;
        Mon, 19 Jul 2021 10:46:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=567lMHe3NlgilbfxJyqh3uDUfUKAOXLKcBBON8GKkVE=;
        b=t0xchnQD1+iKAiFXsM8I7l2XPZrmqZpq/+BsTcJVkTjgv97DH0dJwwNgjsA8gOQFUu
         80Q3+OxWeU0MJN4in9P8Cqn2701zeLLmx1O688lwZQjA9rrjBw92TdW7pxZCl5eRXvZQ
         Bi66qINxokIlVrPBeZVoAi10AkHZABHlD7yPqsO9TDFpgwNnxOCaaJUWBMqJ1rzcC8Lc
         V2mzZ2nzV2z9eIi9rByn1/xrog/qwXWq5S1gCnPw4GynWxjfqrCVS8p3ZONF0jqwRHkJ
         Li//zQzn1u1hLz4/VcxZJAJMBmpAKR82C+jCt2+Zzbwl5rBg1rKnvgLq4HC2XPgeDD+W
         keZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=567lMHe3NlgilbfxJyqh3uDUfUKAOXLKcBBON8GKkVE=;
        b=MCHRPosdN5c5KUUxpSyQOdeU/ImsWaT3MkicP1iug2AdbrHKIbCPlpFBOVN2MMhDrk
         uC1AvthZHr4Dh4H37Y2T2NMSdyVpQwGOWuVmfIvlgwAMIvLwvVidlShMlO60yRfsRJIO
         eGh2YkvS4doP8uNdluLw0AJ73srxAm/QKmH6YFcqrBf9pAwMuwNiapiBbocv/okehjYl
         lGAm941iIy88I0XqRxsKFzyX6BOaTtX2dvmHO72wbAeuVqLuZhOkEw4Kme/GLMZfc6TR
         dZnoVOtVIq9JbrkLMV+2Pa+OsgQta82PzfCElFmEsif+aD2/JQrPOlXyUKTJg79petzD
         78Qw==
X-Gm-Message-State: AOAM530TASZk3Jkr0nDcz1LDObRPC9MKetkuSOBKNVGnan0WE9b7/riM
        zqbt1OoMqq+SPHNqLAZURkWOEJqeHcMJjA==
X-Google-Smtp-Source: ABdhPJwwdYvh2bILtb63ANKpGRqLAoqdZifLUcDO03Pco3zlAEET3iCf1uaF27Q21gQKpoOTvVfq+g==
X-Received: by 2002:aa7:938c:0:b029:32a:1725:a3d7 with SMTP id t12-20020aa7938c0000b029032a1725a3d7mr27140847pfe.64.1626716776682;
        Mon, 19 Jul 2021 10:46:16 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id l7sm9694723pfd.164.2021.07.19.10.46.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jul 2021 10:46:16 -0700 (PDT)
Subject: Re: [PATCH 5.4 000/149] 5.4.134-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210719144901.370365147@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <fc7a7b3a-26d2-dd9b-131f-00a1c558d729@gmail.com>
Date:   Mon, 19 Jul 2021 10:46:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210719144901.370365147@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/19/21 7:51 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.134 release.
> There are 149 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Jul 2021 14:47:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.134-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

If you need to post an rc2, could you also pick up:

d0244847f9fc5e20df8b7483c8a4717fe0432d38 ("mmc: sdhci: Fix warning
message when accessing RPMB in HS400 mode") which is in 4.9, 4.14 and
4.19 stable queues but not stable 5.4 and beyond. Thanks!

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
