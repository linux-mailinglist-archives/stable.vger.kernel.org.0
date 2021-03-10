Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2788A334A4E
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 23:04:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232920AbhCJWAd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 17:00:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232874AbhCJWAJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 17:00:09 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50D4FC061574
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 14:00:09 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id u8so19614321ior.13
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 14:00:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dm/C6XQ32zAZrLyNDRsfaU+O/spR8lL3llpiTvdmEm4=;
        b=Rei+kDchY650JNAD/uHdfIUeifbLHjwrLn/0oN9rum0G3Cf1/L9zRHMPIMpvOgSUOB
         S8PGoPeTvEF/YXTDuihv7R/BU8vimxyMnlJjM17qo7Zi/UG9TvMT2AmONvTmtzjkv5Iz
         cOpsOLzAl++tmycjLijeIdVoO0jN5RE6rfsOo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dm/C6XQ32zAZrLyNDRsfaU+O/spR8lL3llpiTvdmEm4=;
        b=pO2wBnZcWQmlxkLmFLVjvpUKrUjZTIufVXkqmQ8oJNE2DnCoSfZcNK2wgZZyahtskz
         2Wv90tIwFO3L3xx84atkSchot85Tz1qkiIlA0LKYfNspco8E2J6ylA6v151TpwXAl4cC
         Nl6qMTHBbdAYcjg+ZeTI20hgIqENBIl6ISa9Q8CBJkuNoszQ3rgbZsWUWSr6kpcR8g7e
         mkbJ2oMIUzRV4LMVVlhe3Gy4NLMsNJ+bEgCdujIq74rAtcz5QAtSsubZQjkBqBfJ52d1
         DyBC1FF6M/r0vz81SrG8SvZM4M5GdEDLGEY9u9ebbvhfNsFl67MJ3tP9fFRWhF2ozJln
         b5aA==
X-Gm-Message-State: AOAM531khFYaU/l2Hr93m19ioqyR5mOTZKM8SHSi4LgndS8BbV9P+Log
        iz8KKRbx+ggQIJnp88wNGO65pQ==
X-Google-Smtp-Source: ABdhPJx6hr8hFj10U9L/ZvYXEVo7Oh3s3837pFjDs6dF7Yjdh5sck97bZABMjahmpXn6/jNhOlVWRQ==
X-Received: by 2002:a5d:9285:: with SMTP id s5mr3966188iom.139.1615413608845;
        Wed, 10 Mar 2021 14:00:08 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id b9sm390260ioz.49.2021.03.10.14.00.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Mar 2021 14:00:08 -0800 (PST)
Subject: Re: [PATCH 5.4 00/24] 5.4.105-rc1 review
To:     gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210310132320.550932445@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <a541f05c-60c6-1d9d-87f9-762599fa6295@linuxfoundation.org>
Date:   Wed, 10 Mar 2021 15:00:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210310132320.550932445@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/10/21 6:24 AM, gregkh@linuxfoundation.org wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This is the start of the stable review cycle for the 5.4.105 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 12 Mar 2021 13:23:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.105-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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

