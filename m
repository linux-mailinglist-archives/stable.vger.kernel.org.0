Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 387B13549AF
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 02:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243007AbhDFA3s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 20:29:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243004AbhDFA3s (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Apr 2021 20:29:48 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9A6AC06174A
        for <stable@vger.kernel.org>; Mon,  5 Apr 2021 17:29:39 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id w21-20020a9d63950000b02901ce7b8c45b4so13017265otk.5
        for <stable@vger.kernel.org>; Mon, 05 Apr 2021 17:29:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=E+L5MyUKgt10IqRLpYxAcvw5MalrCEuSBsKE9uMTLfg=;
        b=ZP3lQq+x1ZlaKn2UeDWd9hLMsF36M3uLQaCGWvw6+omcUy/N0LRGV+ZbH2SBg4Gh+V
         JJK4XBoLHviEKm2nxxgQVqWQEUIQD9x+96SVa0GXkKCrpLMo6rEZtbKAe5mQiYhe9VqH
         RQRCmuw2VRbkMzvSbwQsQML8oF04ix6oiUwAA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=E+L5MyUKgt10IqRLpYxAcvw5MalrCEuSBsKE9uMTLfg=;
        b=DcBRy4B9HV02MyHzI2CY7Yu5bGh7hQnzAIvD0+pXOwYLRkX3No0nvO5B03OXXlxHPC
         rNpJ1Fpg01FWJ21rklAV6vJvx2juLC7pHwcmvUf0RIcbGyPiPcDI7lQdR8oYijFJEd1Y
         1rGcP6d7NKo2ZJ2NrLe7rKGrQswhVkj6YFAsnijDlGlG4PlhTTKAXcHteuO7VLxkB2LK
         RjjleUB5hQbRWmVWYC3ntpO3XoXH61y6fgY2PQgt/YHHz8ymj7Xx6amhxhpulEwuKLMN
         e5tgbGEnTj3HkLBPWTNUoSqcVcxdBDllkWjHrJgXa8/F5iYLRMRt7COyQtMPRNZgb5v3
         Wr9Q==
X-Gm-Message-State: AOAM532rsBRkkph6Y1dIVzeNsR6Y0AhD7xDxqgFPSmvJUWwLyzPzPR4l
        09vt/9IGrRdP3cR8yZdWfjLu2Q==
X-Google-Smtp-Source: ABdhPJwBfkoNVzXXT7SElPXqNWk0XylYfUAh0YJYfOcv4RtMQ4MWSQ0kE048dUGs/STsqkFUjhwSLQ==
X-Received: by 2002:a05:6830:1da5:: with SMTP id z5mr25159158oti.257.1617668979408;
        Mon, 05 Apr 2021 17:29:39 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id r16sm3343127oic.29.2021.04.05.17.29.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Apr 2021 17:29:39 -0700 (PDT)
Subject: Re: [PATCH 4.9 00/35] 4.9.265-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210405085018.871387942@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <4f0d7f65-9da5-b13e-847a-1cd99912b5e6@linuxfoundation.org>
Date:   Mon, 5 Apr 2021 18:29:38 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210405085018.871387942@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/5/21 2:53 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.265 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 07 Apr 2021 08:50:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.265-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
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

