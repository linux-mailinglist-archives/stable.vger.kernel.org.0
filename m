Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FBCA49F046
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 02:01:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241444AbiA1BBb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 20:01:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234861AbiA1BBa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 20:01:30 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72FB5C061714
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 17:01:30 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id 9so5923755iou.2
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 17:01:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DtIHByrmtg/N6r8E0c5x7qqpNKMlVncwM44j0DO3CY8=;
        b=IFXvUuUy79IXzd6VOL/3b58aUeYZaitnalo/G42ozAK1MrGaFkZ2tCC8k7weJyrTWi
         Rkw+LsH2Kra78SuSoZeQVO2XfEeaGsBvGyofa0S8W/o5omv8u0eLoAGREortjkZzLI3j
         Nfvg8cliW9KWxsAkS7RmwTWTf/BiFZId0a5H8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DtIHByrmtg/N6r8E0c5x7qqpNKMlVncwM44j0DO3CY8=;
        b=OTr/0ZMLUjPlBsyop81EW4wdyG3WhU3IPeSupoE8rQwM402C3kkv/tZASaIYzNCetE
         o5a3L7eJ3reT8ioPQRKwzq1Dahb0YiYZBqmBYIDXsyKxPTh8gEDhO5obBolMvlBU3xct
         mX7g2jM0lGvPlgq/UW2PnxPkC5Cmtrm8fDmu/eNJtczvagFi68T/gY7YJpm5e4VCLQa+
         WC5JQe7TQ6uCZ5LAjKxYyffk06+eOEEz/ujFwoD/VTMAKHkYI/l8rePV7mLUe0nZror7
         n+Ww7GlS0cJ+b174ivO3Epn2Lv9TNItwOAJ8TKGg2OxX5rucGTYSjfKGCbEGN1xD1Ldk
         348A==
X-Gm-Message-State: AOAM5333/0TGTVqiRyw8cJa9jnH8XDuHU9Hi7Q1b/2cZVGkgoRD35BOa
        0oStKP1j90j9NHFlBT5b/AYzWw==
X-Google-Smtp-Source: ABdhPJwjU+vrxsp3NYD3+0pEfhyhOkH88CNLtwjUNSJk+a2xCuITgCB/cOANHciokAD+OUu9cFn13Q==
X-Received: by 2002:a5d:884b:: with SMTP id t11mr3684882ios.53.1643331689740;
        Thu, 27 Jan 2022 17:01:29 -0800 (PST)
Received: from ?IPv6:2601:282:8200:4c:fcdb:3423:ed25:a583? ([2601:282:8200:4c:fcdb:3423:ed25:a583])
        by smtp.gmail.com with ESMTPSA id l7sm13086344ilv.75.2022.01.27.17.01.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Jan 2022 17:01:29 -0800 (PST)
Subject: Re: [PATCH 5.15 00/12] 5.15.18-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, Shuah Khan <skhan@linuxfoundation.org>
References: <20220127180259.078563735@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <2752ffb2-19d1-d463-0317-4aabd4e691b1@linuxfoundation.org>
Date:   Thu, 27 Jan 2022 18:01:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220127180259.078563735@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/27/22 11:09 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.18 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Jan 2022 18:02:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.18-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
