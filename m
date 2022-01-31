Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3F604A4FB2
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 20:49:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240770AbiAaTtm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 14:49:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231583AbiAaTtm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 14:49:42 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A131C061714;
        Mon, 31 Jan 2022 11:49:41 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id d1so13397810plh.10;
        Mon, 31 Jan 2022 11:49:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=6R6OUgnfV1k8Sve3u9OgysfGAeZ1zorxKpacMbFUxbs=;
        b=ja6gI1H5SbNDkZ/NdDhjF0S7EANdILuP5RRGIidH6X1o4uRF+YxGImErNm3vDNTSdB
         PVYrXCbaDb90fIJ7++FvVsy/Mn+Ury8PNCdGLCE6fBHN//FW4FGzohGrLJKxe1yWBg0o
         37FTTxOSeifJxuYc3rgwRiDFKRbIXLXf/As51qGrGi1ReTYVFEF1vJ3q3Wzz/Z0veKGr
         Z+2B6cDIqyTtlBF4nxD6YEMzsbKiixr8uqEcCpAXFaefHWgVKX3DNBCrk81SdVByEV/T
         ddYRJv62Wi7zs+IMcag2IhF0axcySmWTNZkCk7fytbzCTHibSxxXl1uybmjOJJUV4KAg
         COHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=6R6OUgnfV1k8Sve3u9OgysfGAeZ1zorxKpacMbFUxbs=;
        b=DkDFLkbhdJgO1g1Ymi44qLmnLwXdfUOu2yEmXqx19CAUzC9jiyv8UaEPu5zRWU6sDP
         g4I/CAAMjpF3ZtFRoxX1WzlL3t9KXhKTfJ0NLoIgEDAklr7J5i2SGdabnhgkZ+TDmlon
         UHE6jdEY4vHNrqTL/ha/A0B6VDrSlPu73wv6AEMM0+jBERQMyaSMnACVoKQLAgMURwol
         n3ANi9wSnqjh3S00ERNXxhIm9Lvdq1/iZytnnwRZ+wwIk/am1ZcF/Yr923hd41n/uMx9
         ca73+tJz7ZrHss7QfOYkQKrHaQ00WR59bVggmoudRMKm5YlLtzYczh1+riO8+8hHHoQ9
         66Jw==
X-Gm-Message-State: AOAM530iRRjSr+ClzfFlhoD9JwORVv+e7bmYqLQV0GVSsZ8tzJohWUki
        BcE33SQU2T3NcML8g7ELafZIaygNoEA=
X-Google-Smtp-Source: ABdhPJyTpReZMFOt5r7yEbJ/OQOk6PJvlfSO7lScnbzh++HVzukIbA+jju0jRDGKehNrrzhX0MsqvA==
X-Received: by 2002:a17:90a:b107:: with SMTP id z7mr36285123pjq.38.1643658580574;
        Mon, 31 Jan 2022 11:49:40 -0800 (PST)
Received: from [10.230.4.36] ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id x23sm16351475pfh.216.2022.01.31.11.49.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Jan 2022 11:49:39 -0800 (PST)
Message-ID: <6cd5d2c3-4097-bb86-ad96-508cddb6b027@gmail.com>
Date:   Mon, 31 Jan 2022 11:49:38 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 5.4 00/64] 5.4.176-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com
References: <20220131105215.644174521@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220131105215.644174521@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 1/31/2022 2:55 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.176 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Feb 2022 10:51:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.176-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
