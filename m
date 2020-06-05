Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78F101F02D2
	for <lists+stable@lfdr.de>; Sat,  6 Jun 2020 00:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728639AbgFEWQP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 18:16:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728627AbgFEWQN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Jun 2020 18:16:13 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0E8CC08C5C3
        for <stable@vger.kernel.org>; Fri,  5 Jun 2020 15:16:11 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id b8so9569323oic.1
        for <stable@vger.kernel.org>; Fri, 05 Jun 2020 15:16:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ekLpFzBqNwOuTQsawmJlVyGtYM79JpHBNAHjc5cJoYM=;
        b=Rd/UwoBCFhO7dS0mm77XO3/TFZK2GF8yR5H6IAR6AoDSsLlxbYRvDJqOwUmaUcURVi
         Jzsvo9/nCM64Z1qlf5X+5uJJhFlRrA19pzAugG0g4oGlZm6QSXMpEoYGCvXeGfM0mJpq
         aTt6UJCxF2goAYZQXp8kLUgmXrOvy/X5Q19tU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ekLpFzBqNwOuTQsawmJlVyGtYM79JpHBNAHjc5cJoYM=;
        b=knU7YGKKjPxrY0j2vNGQnl21auIjFJDNfBPRTFpWw4mS4Te50uSG34J3B0baCJTl2y
         m0Yyyfzkp2kWctLnE5rKD8/xI8MkOsmL9ZiTZhWd06dEpdUzzwU4OJsg92ifBCLhKYzH
         gAZAdfa+WNdbR/iqt6BGA2GBFRJyDdb9g9/FlFVQkNXoiPPM73MEIRMuOb6jizl8BjXG
         RQqkbZXHAS/eulhBUMJHy2PF1YBIGFLJmL2lOSvGoFrV6j0dJHB1EGM0eT3UuYuDKrIQ
         jSQuyCaIN1GvIWbl+3/JAdGf3taKslnZ8aofAr8dHIehClbCMMcRCW9uCyA9vOr4kb5w
         C4VA==
X-Gm-Message-State: AOAM531MiVYecPEmUFUg6tGviHt9AXD1FwqLgziO+qiP6rowTHYtBhlY
        rN4nhQMmzHZZiH7WQa0KYHUzNQ==
X-Google-Smtp-Source: ABdhPJwmKrFIwY+oBUlJ3CciDrWIsAIN0caHXaTutLGctrVfOOIespo5psnZh+By0FHJDlCST8iepg==
X-Received: by 2002:aca:3008:: with SMTP id w8mr3380358oiw.157.1591395371303;
        Fri, 05 Jun 2020 15:16:11 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id a3sm973613ool.43.2020.06.05.15.16.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Jun 2020 15:16:10 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/38] 5.4.45-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, skhan@linuxfoundation.org
References: <20200605140252.542768750@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <b42534a8-64b6-2d9d-ecb0-47ecde5f25c3@linuxfoundation.org>
Date:   Fri, 5 Jun 2020 16:16:09 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200605140252.542768750@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/5/20 8:14 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.45 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 07 Jun 2020 13:54:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.45-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah
