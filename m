Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FBB03A0A5B
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 04:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236226AbhFIC7F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 22:59:05 -0400
Received: from mail-ot1-f54.google.com ([209.85.210.54]:38633 "EHLO
        mail-ot1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230199AbhFIC7F (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 22:59:05 -0400
Received: by mail-ot1-f54.google.com with SMTP id j11-20020a9d738b0000b02903ea3c02ded8so8890547otk.5
        for <stable@vger.kernel.org>; Tue, 08 Jun 2021 19:56:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Q27Bi1DUGYXugCdW5DXGuEwdkikr5U74gsr9b1PMcU0=;
        b=dxLotJHvVEbxURaDAg9T4+YQs8elzUZag8sVPjCuVrXb/V+iIyAOUhBqP1P52Zp6Sc
         +ESTXkSKHow6y5oF9Tjp8qNwAUQbuZt8XtK+6KArKRVE63CbmZ+J+QefxdC+R6UoqUfO
         Aan0j+97EZdUq1mGvM8jqsAryc+FXugSL1FSs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Q27Bi1DUGYXugCdW5DXGuEwdkikr5U74gsr9b1PMcU0=;
        b=sKSwJ02m2+hLANEA7rqEGlt3vk85yM84mN5Fr+T2HJ910BJCkIGVGNDCQGyT/+eNPC
         0YQmV3XDuuy5+7jiBaO/lvpUIzxEN6YNQlnP7+18rAxiuoPuYCWKIIrcjJ8GZ6AYczV4
         QGiu+esLN9W/Qu1HqI6o86CSw/HLSoSfguqt1Y1SttPa6EdQao401pu3ItqwTmjx5I52
         TDcXshiBCjzw2o/LmF1/We3sahH6JB8PRsZ3zJvxlj/7ZhXYQXn3+guuYJs0nhDhKsdO
         9IkcHA2/6TsJPwgpwVnmvFUhkH2T4jPbQcqdjQqg064wKkxQMZTpwFsmXGnzmsZ4+rv6
         8B+w==
X-Gm-Message-State: AOAM533W7gaUP9jl6io+vftgmO2uvmA2tC+4Vk83yRI/E1pbTFtqXBIa
        W8YFvtrq9MyE47YlL74xwRPKAA==
X-Google-Smtp-Source: ABdhPJxbPcQNZncoajurgs2SFwpPgvBSN/QSgDH1rwIpSzzxpOktBSCfzTtHLknM3Is0auIU1iyreQ==
X-Received: by 2002:a9d:554b:: with SMTP id h11mr20320138oti.4.1623207358468;
        Tue, 08 Jun 2021 19:55:58 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id t39sm3209231ooi.42.2021.06.08.19.55.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Jun 2021 19:55:58 -0700 (PDT)
Subject: Re: [PATCH 4.9 00/29] 4.9.272-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210608175927.821075974@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <7717baaf-15f7-4918-d068-3481587e620a@linuxfoundation.org>
Date:   Tue, 8 Jun 2021 20:55:57 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210608175927.821075974@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/8/21 12:26 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.272 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Jun 2021 17:59:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.272-rc1.gz
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

