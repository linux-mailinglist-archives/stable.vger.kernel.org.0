Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 605664ACF23
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 03:47:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344780AbiBHCrm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 21:47:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbiBHCrl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 21:47:41 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82BC3C061355;
        Mon,  7 Feb 2022 18:47:41 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id i17so16368156pfq.13;
        Mon, 07 Feb 2022 18:47:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=STzONllMjqG5DicuoZaOkrmtu7tH4GniyjrQLs6/7us=;
        b=D/Qrr90etvAgOdRmz9A/XFt/TSm5Omtq2lGZ339b+xthjglvIulAAxEmCfKWP/msHm
         6MCdayJXxvTrTtsOEGSm0toTy+t+H5uV7aD8FG3NmcSuSqy0PYbazUuJIvOtMmXUUtG6
         PSOHDwopNrTKoQhkQUarkfsdILTsNYw1LSWoPy9aGs2kSNjIR1Y9E/ML6Bl6Os8o0JYr
         tupnOFnQJHOUevbdu8dKfoDzes82ixbyasvtekxjFIISbSnj8LNah7LpyjyHCXNLSdTZ
         2aczgKofMF4laCjm17U6wYm6qsq7ePuBlf1EijFekX18WzPG1vH9L3laWQbToqDHhA4a
         PlVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:content-language:in-reply-to
         :content-transfer-encoding;
        bh=STzONllMjqG5DicuoZaOkrmtu7tH4GniyjrQLs6/7us=;
        b=1N7ErAJNmdLJI4tIBGvzwDIw1aI79ynT1JwDk9JAulEl4kd847a5ZlG3nplE0MKMaS
         wFIBKpZysd89FlsK1k8z8Wb7TXZsTNJ+9AxQQDCXcNn8AKOY7SZQcoR7L5DmytYcA+Rr
         V5I/iGnD+3nNZVkWoMzPIsHfg/NnCkSpESTXoposSNQNxEs1znTcjc9yfzc3hQRNueEo
         Hq49BMigQctcBt/QaXzpp0PwXP6GiTDW3eY+DQ7y40S7Bph8W4JSYYagl18owr7Af20/
         2lIWkSN+Mk3uW33h47IOkctLjuprBqQf/L2PhOgvHU0lKzZ0TTZc+5ujaPKPNFirNahl
         7n2Q==
X-Gm-Message-State: AOAM533pia515WzTgRjef2frAjUMxs59YH/VXgnANx6Ri8qzb/kqabIQ
        yFEFPS/YPKNuZUT2sCuSmRonptDA6/w=
X-Google-Smtp-Source: ABdhPJz7a94hZYqvKvVezBNhAgWHt68alPfKzLkicTqBjpDLdvCXzbgpU/vdvRTcmZsC2u5V4P/bHA==
X-Received: by 2002:a63:fc65:: with SMTP id r37mr1862266pgk.123.1644288461052;
        Mon, 07 Feb 2022 18:47:41 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id e12sm13130072pfl.8.2022.02.07.18.47.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Feb 2022 18:47:40 -0800 (PST)
Message-ID: <afbb9fe1-9714-da99-0135-2ef196f397cc@gmail.com>
Date:   Mon, 7 Feb 2022 18:47:38 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.16 000/127] 5.16.8-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220207133856.644483064@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20220207133856.644483064@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/7/22 6:04 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.8 release.
> There are 127 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 09 Feb 2022 13:38:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.8-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
