Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E403A3C2AF7
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 23:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbhGIVqv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 17:46:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230406AbhGIVqv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Jul 2021 17:46:51 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17EC1C0613DD
        for <stable@vger.kernel.org>; Fri,  9 Jul 2021 14:44:07 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id t39so4105187oiw.6
        for <stable@vger.kernel.org>; Fri, 09 Jul 2021 14:44:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NtJKIdAw9icG9Nsajry4Foamg7xSDmE8pPvjonOc6FQ=;
        b=EdjIlc92MffRg7Yia4brOr2NIudRy+iU6UMoTAiDq5f8r/D95NtaAQFkso6MSdW3M9
         UZoJIHLyMl13YYqaWWgNBI02wjlvNLZR/Injz0+OKdI72rNYvTilbQXxsujjmhn0YO12
         onvHIURQjbGuhP6UN3ESrfyXyACSQcky2JqD8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NtJKIdAw9icG9Nsajry4Foamg7xSDmE8pPvjonOc6FQ=;
        b=XFuegzG/MWw0d7XnraEgCyb4b0HqcnQ7FiFoxanwTMLUD8AGlf34+04rmynIjF5tEN
         4XBs/aiNuahJIMiWCJuj8e1oUWIYr9pBoLhCgeTfDZI4mpSmQZkai2mUcJuEwv4pHMIp
         xiV390SEPuOQYCP4GTMpU08znVgKaoz/F9Wf+CWhaAAknAx/TUjTXy02H/M5A5ugAC3s
         DvUy4vOH8jzPjY1PNE6zrRmX/sqaOL1ym9rqbTplVHylcjWtugOoC+x/ErTIV18ArjCU
         +rQDMjpWXWBWmEwtPNCF//r7pHTefb6UisKqqz0q3/WtwxQSBd90TyXnWr1LyXbPJiQe
         VXCg==
X-Gm-Message-State: AOAM5331wILBwnW3sa8DCn+0HC+rGwsPe5YyXdxgvapODMrzDzpeJLTk
        nb2LHJsTiLDGoJAQXIfaeoZRYQ==
X-Google-Smtp-Source: ABdhPJy/Zv/q/WiFzlN9R6YUz9my2iBR+anwMHQVCk/dUyHPWwPcZo8STwZMTO4sAJ+EjktepWvPHw==
X-Received: by 2002:a05:6808:b14:: with SMTP id s20mr770475oij.101.1625867046519;
        Fri, 09 Jul 2021 14:44:06 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id x20sm489834otq.62.2021.07.09.14.44.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jul 2021 14:44:06 -0700 (PDT)
Subject: Re: [PATCH 4.4 0/4] 4.4.275-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210709131529.395072769@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <7cb2531e-925b-60c1-31b0-70b7a1b9b77d@linuxfoundation.org>
Date:   Fri, 9 Jul 2021 15:44:04 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210709131529.395072769@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/9/21 7:18 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.275 release.
> There are 4 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 11 Jul 2021 13:14:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.275-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
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
