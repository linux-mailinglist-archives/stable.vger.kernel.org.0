Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61D863CB801
	for <lists+stable@lfdr.de>; Fri, 16 Jul 2021 15:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232897AbhGPNnN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Jul 2021 09:43:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232849AbhGPNnN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Jul 2021 09:43:13 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B61D5C06175F;
        Fri, 16 Jul 2021 06:40:18 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id s23so10968358oij.0;
        Fri, 16 Jul 2021 06:40:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aqCY19jEVOzitR5f1hOTd+qW/pWsIpStMp1k5yIewx8=;
        b=osgGfoJBPGNdPwWrsmE1GMbLbKpQ/LVRq+W5NXg/Hu+xyskpghgPDd6arWb2SzLy5Y
         dPxMBYjOYlPZZTRuK0iKiFHHgowjcUtsSFxydq99onk1IPCfydJR5Bey98DVJHSJtxeP
         X667y1ymHHd41ftTTzqjzA4Imn+OBFHabdkEU4VtXw+1/V1eeoYL8r8P65V8ieksCWug
         3+YFBvFrLguo6Ho5xpzMB1WUX4NpZfoW+KaDnEtgpKoS9RKtTyIRc1ppMYTpWJgpTl2X
         E+4MMpW0lLH0xNVSzQXpMKPzk+0puAaZywGKgkpSfyrQfi34VaLFvUhJRqjBf3Gc48Ng
         0tfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aqCY19jEVOzitR5f1hOTd+qW/pWsIpStMp1k5yIewx8=;
        b=tQBl2EAQFVA1TxNcKx6xNyjhRp88m+xhsH25K7rwLYMU1uVVhLnTydF3yJAG8kNxJX
         ktFDvPfAZomdNTLU3XWlRE+PNoiW2Ou9vXcf2LM3BT2QXG/EF+VMxezSodPCxpUFdC08
         i6FKu4j9kJmj61GaCZhCaiNEe+WMFeqKuGODHfeAWzt/od3tIK1n1vzRm13E6BYRmhrZ
         Y6yX0Z6cgfP55CAHHkwymLpXXgl+6gMtrWOBSJN6dIn+HpB8t1yoaaWeYTD+GpQmN/fW
         SZi8EbMqXPNTZGNm8pC2H7ip50rZExiT1cbAy7HM9rqYqyaL9AxAfWchmsBwj+QMpElQ
         z+MQ==
X-Gm-Message-State: AOAM531K9WwGuBzeYgeGP8tVr0+RC5MJfl+EQkmx3KQh+2RfzSryZCv/
        0SbxHySAKHoi6SsKztjd3BSc9IC8gkc=
X-Google-Smtp-Source: ABdhPJx0RmWoBIDXp1X5zxoHXYfyLzOXhNC32Rq2dzRr1rMv7pCanhK8Ml4X5tX6Ocg1tTkd8AZrKw==
X-Received: by 2002:a05:6808:490:: with SMTP id z16mr11984275oid.89.1626442817868;
        Fri, 16 Jul 2021 06:40:17 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s24sm798603ooq.37.2021.07.16.06.40.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jul 2021 06:40:17 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: [PATCH 5.12 000/242] 5.12.18-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
References: <20210715182551.731989182@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <dcc3c82c-a026-99c8-0342-b231665ec301@roeck-us.net>
Date:   Fri, 16 Jul 2021 06:40:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/15/21 11:36 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.18 release.
> There are 242 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Jul 2021 18:21:07 +0000.
> Anything received after that time might be too late.
> 

Building s390:defconfig ... failed
--------------
Error log:
/bin/sh: arch/s390/kernel/vdso64/gen_vdso_offsets.sh: Permission denied
/bin/sh: arch/s390/kernel/vdso32/gen_vdso_offsets.sh: Permission denied
...

Original commit:

diff --git a/arch/s390/kernel/vdso32/gen_vdso_offsets.sh b/arch/s390/kernel/vdso32/gen_vdso_offsets.sh
new file mode 100755
               ^^^^^^
index 000000000000..9c4f951e227d
--- /dev/null
+++ b/arch/s390/kernel/vdso32/gen_vdso_offsets.sh

This commit:

diff --git a/arch/s390/kernel/vdso32/gen_vdso_offsets.sh b/arch/s390/kernel/vdso32/gen_vdso_offsets.sh
new file mode 100644
               ^^^^^^
index 000000000000..9c4f951e227d
--- /dev/null
+++ b/arch/s390/kernel/vdso32/gen_vdso_offsets.sh

Same with v5.13.y.

Guenter
