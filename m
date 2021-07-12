Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C08B53C613C
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 18:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233633AbhGLRAG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 13:00:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232710AbhGLRAG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Jul 2021 13:00:06 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC0A2C0613DD;
        Mon, 12 Jul 2021 09:57:17 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id x16so16940633pfa.13;
        Mon, 12 Jul 2021 09:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZUBkGDbyG6OhDXoj6zhEbgo7RPjJvJwXYKKxiLP2N7k=;
        b=SI/Gg0+aR8tJzuVkR6KrH+IFypdf5BdP4790ovR4ZBUVQu7qazMzCri4V0uo90wdeM
         s9Ts0VGe8Mc6cqYxxoHG1oE7eMNH1vXIAaMqS8ti7oWmZFZ9zluT82oM4L62ADJAnrBb
         6BhdzzQIbaU89j558JJ4b28lIQqOYuI03YnqwrZbKYnFsSlELZCTIlBAhetqHWUvv9lH
         PBjDPo7jg7SfnEMkTGZbUNB+C6WQ1MwPJjcIiu0KcZvwKttxecV7z/0p3f192+bI6u2b
         zenKqYlJelEE9Ht3e+lJpGOx3ZG/PEqeQXpaGyzAK3tDTufiOI4duKBf4qRoIHl1EuaF
         /dpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZUBkGDbyG6OhDXoj6zhEbgo7RPjJvJwXYKKxiLP2N7k=;
        b=U7+kiFu6aIzxYZ9Hw0GD/CW9lVJXNoReeBN4G7Mb0wMkJ3MGilDVF/efF62vkejuKr
         BMOyHhZNSneOebFQXFzspLgy7MpvddI9nzHUTvkXcAuO+Sm856w+x4STy1afkooA2Hv9
         +OqkhMoK6xQo9KkWIMCpzrobVx6R+0ZXHvW3nJR4/4WO3gcDFfFw+7eGeMm+WfhYjz3L
         9U2GBdJkZvSFs8EEl3UBrVj8g3zBmKOu176xn0GPgr+/4oJWGLjipA7HOHU2NE7pd9wa
         /uTzF1cl+4nDIHUhur2dRAb9qmlSdQ5Ce6OxPe0wkpABi03SUXSgSMqGxYwHO/HpZDAu
         V5JQ==
X-Gm-Message-State: AOAM532iZwcTFFZy8TonO+4k4EfLmKU2lD/U+GP4WCRcnsvcd3+QuZT3
        Y84nF7aSEu5hYYQwuJbnyVLGzSTuiilNtQ==
X-Google-Smtp-Source: ABdhPJz+yH97iAZ/yeG82jS6lSqWOTLu2vav0H4pC4pvQdiAWIskB8WwVFwrGNTHPVQpkMcyFwvx0w==
X-Received: by 2002:a05:6a00:1390:b029:32a:e2a2:74de with SMTP id t16-20020a056a001390b029032ae2a274demr36179pfg.6.1626109036828;
        Mon, 12 Jul 2021 09:57:16 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id a20sm6238pjh.46.2021.07.12.09.57.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jul 2021 09:57:16 -0700 (PDT)
Subject: Re: [PATCH 5.4 000/348] 5.4.132-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210712060659.886176320@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <e6314428-906a-a8c3-69b0-fa8561f69665@gmail.com>
Date:   Mon, 12 Jul 2021 09:57:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/11/21 11:06 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.132 release.
> There are 348 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Jul 2021 06:02:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.132-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
