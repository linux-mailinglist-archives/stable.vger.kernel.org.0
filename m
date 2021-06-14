Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36D553A6F5D
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 21:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232975AbhFNTuI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 15:50:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233791AbhFNTuF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Jun 2021 15:50:05 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCB27C061574;
        Mon, 14 Jun 2021 12:47:51 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id n12so9497901pgs.13;
        Mon, 14 Jun 2021 12:47:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DcBdrMvLGsscxFWW6kXUdT76eH31NBxCNjbnOvB7xYI=;
        b=RYuQ9wpqwTCm7etCkWjbkFbOFhXZMz2nEGqZdhpABpT9jXNEboEZqvjlKg8OwxM177
         DUOq+UES++R6attE/xq6jBI9M8jtSu2txzNR8YKSusdDPFnkw2wFdmOD41xgp9Y0mRtO
         MeGLCxaowlIHM7nqxsfb/sV/FGdKLk0I4b47C82OPjb2etM5+IjyBYbiPMukmmlXOutz
         R6EBVkI+LMkgXRBbhhj1tQCTE1jcz66CArVG+XF+o4ON67n8I924P+7W0Gcyty05FjBS
         E1pyn5ympCf3Y+NanNcIMeSR2v9hjqZVlR3zAS0/l03/N4qwhpMdv2HsghEJFuRrpa2n
         OIcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DcBdrMvLGsscxFWW6kXUdT76eH31NBxCNjbnOvB7xYI=;
        b=JYc15WLw9+lXKlhcGe4q4s7c/Fl+5Ka5H/cj6Y1UKUEr4uB3LaBTCMzOMWeJABNTMp
         l0BzmQhW8qr33HACF708cvQZ+82AIYkYSKaa+ZQRBeVQalZ3nkYgX1JwW5DX80GiUS7O
         7NHYr1j9p0CVEuwPwHBPtZ01H5h9y/zbGDaQqHQlzjFJyUVtjilvK+xrI6WzFgty+8KD
         iA4Ep3H0FolP2/Km3L7oZNl2qbM7Ym9GyQ4LKtkIMt/FrzHpXbAKIimRBsCrFklw3iIV
         V09ytUomZYq4a1Zhm/vDaFvULBhZSJuvzq4GzOZsEE2lWp8teWHLJWEGSxN9x3FyJj8j
         Kljg==
X-Gm-Message-State: AOAM531K1TsEKZRJxe1MV+q4iUmwAfSp85GqXAWBRZH9lrtbL/ffccVI
        QJFaQ7RHjgIuwLxkKVZv+cuIV5cvjOw=
X-Google-Smtp-Source: ABdhPJwsCRi8vESFuiatSMg7xgN5CToe/8vliR/XtSO49RQRonwV1anklusbAkJ5uh4E75zboCoZ/A==
X-Received: by 2002:a62:860a:0:b029:2ec:81e1:23e4 with SMTP id x10-20020a62860a0000b02902ec81e123e4mr547727pfd.11.1623700070878;
        Mon, 14 Jun 2021 12:47:50 -0700 (PDT)
Received: from [192.168.1.67] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id u12sm26752pjc.0.2021.06.14.12.47.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Jun 2021 12:47:50 -0700 (PDT)
Subject: Re: [PATCH 5.12 000/173] 5.12.11-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210614102658.137943264@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <c75b1c44-464c-9ec1-7e3f-dea5f37765dc@gmail.com>
Date:   Mon, 14 Jun 2021 12:47:45 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 6/14/2021 3:25 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.11 release.
> There are 173 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Jun 2021 10:26:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
