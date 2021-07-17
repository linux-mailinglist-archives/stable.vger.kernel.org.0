Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0767B3CC6FA
	for <lists+stable@lfdr.de>; Sun, 18 Jul 2021 01:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbhGRAAh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Jul 2021 20:00:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230259AbhGRAAh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Jul 2021 20:00:37 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FB4DC061762;
        Sat, 17 Jul 2021 16:57:40 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id i14so733210pfd.5;
        Sat, 17 Jul 2021 16:57:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KZ8KPrGTn9OA5fnTg2Aua33JFfJNUaNDTtuE4XF0600=;
        b=ULYuXQGWtlzCaUeJoq+h45/EUWsbEwv0cIDOlyN1cKI9Gg61qNuR9iOad3OoWKiMCf
         LqjnPgMvCqEUgTmEjK4exA5UkoEokDw1hor27Wz5hxswbjDcdT8n0q5rjOUowuoqTyG7
         bm6j3vrPq8OYTh7goBYtf33kY8+TX5IIi48PV6CEouk1uVzX2et+noxqB16sAyjtqPnf
         +DnT0aRnpWVRt8U52tgZEmMCNrAIThhC4VaIC3B0dR7E1D0bm9PnHE59ttGF400fdUb5
         xJ90V9fIGcO74eFZU9mOqMkDSaQM5CK6v0+HUdZVkiZmiD82W1GbOOJfq4nfmNde5aEt
         C1NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KZ8KPrGTn9OA5fnTg2Aua33JFfJNUaNDTtuE4XF0600=;
        b=RRaxFAKIKxNUNY2qaL1auAT9J50hgH8J5zp8ZUI0zsqriZbJWJlr4C0n4ORgd3B4VB
         RUw7UHw+K4vStHmLN+0f7nP+nxblDChCkVKpTaw3BU5W+eJyOejwG5Q51j0p4toqDCzN
         2+6kL1a6pg2c9mipOnO0WlHhILE6g4RAF705HmgeiaxwqJKP/8IFExAB8xComd9R2k49
         ptMuMzplIwHA82OMKzXS3UkSgGcqn+hIy0JkaqeckuTBQ/k6CT6o1xxV37Z720tisrM3
         PJT16bKTy58AWE1/ENO+zFgJe1CgZh+4S0lN9H4Zd9dbLu5tlUlOFc42lnQHW+Xj9CDh
         xkYw==
X-Gm-Message-State: AOAM53155TsR+e7g1vaaCQ9UWa4pLHrd766cPnytg06HsTAA3M3S8IEp
        thtvfg1dAy69HwN7dZCDYpuk/0RwRFvu0w==
X-Google-Smtp-Source: ABdhPJy13afSpOFqjnsYyIeG3cSWO1IiR48A9ntNGfu7m5uKzAQdu+CAPjS/o7klZxfP69iqKfjlow==
X-Received: by 2002:a05:6a00:158e:b029:32b:9de5:a198 with SMTP id u14-20020a056a00158eb029032b9de5a198mr18007990pfk.3.1626566259660;
        Sat, 17 Jul 2021 16:57:39 -0700 (PDT)
Received: from [10.230.31.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u62sm2554800pfb.19.2021.07.17.16.57.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Jul 2021 16:57:39 -0700 (PDT)
Subject: Re: [PATCH 5.13 000/258] 5.13.3-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210716182150.239646976@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <1d9e4220-980c-aa1c-39be-9c3beeb6d654@gmail.com>
Date:   Sat, 17 Jul 2021 16:57:37 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210716182150.239646976@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 7/16/2021 11:29 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.13.3 release.
> There are 258 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 18 Jul 2021 18:16:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.3-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
