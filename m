Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FECD241398
	for <lists+stable@lfdr.de>; Tue, 11 Aug 2020 01:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbgHJXID (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 19:08:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726648AbgHJXIC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Aug 2020 19:08:02 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C609C06174A
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 16:08:02 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id k12so8702235otr.1
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 16:08:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/hX+GfJb3Viv3KK4EvLL5eD6BcXLtKNelj8RJ3CjTlw=;
        b=ScccAjM3eQV8eLe4NrvD3VYFcuYYMd6JZ1QYIAbz1bSLd+OwiIHEnL3Ck8B71PGu3l
         FgSdayBeTQd8qjpafbGOHr9Cg4drRJZ4etTb/y5Ryr9x7/dSq7XtLnjV3wvzZcQkbRBw
         XeVotDaR51OY7PKP5ORwsVDCtduOBmB9ZiFMQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/hX+GfJb3Viv3KK4EvLL5eD6BcXLtKNelj8RJ3CjTlw=;
        b=RSB10QDR0tGLigAz9mgGNxKXKnHILwE1lGo1KWN74G758ErnGEvNX1mGWfxapl2jyW
         74U8Z6fGH2Eim7jGswyfJVa92VJK1PPeC2JZuq/5c9ZHtgKIqPpwlnLr/SON3itMxdyy
         UV04toYGwzs7pUt4LtzPwVBH1q2rZAFhIoxOogCjnCCJbQWSFOlqhINgrwshhvFcqQRv
         qcAYgFMQoNLwRneZB5LJnfk+4FepF0Z3psso78ciY00MjdE59T1/TZzBOQYXqspVBsOn
         u6yOhexyFhW1rP39NbBjHYlb7GwUa49+p8iLTVo3CxvoatT/ZE2mkwaThNZ/7EiXM2z0
         +vnA==
X-Gm-Message-State: AOAM530RgKb9ZCY/m+rLO2A/Skvsalrl0rPa+nwjBX2v75N6Pjaislun
        pl1EJCQl8mjpt6grIOkYJLVynA==
X-Google-Smtp-Source: ABdhPJxUetoWrrQsAS4UzCeoXx66B3zFAAeOiL8+2mTJ+EmqHzIUeiX0/x33RtI+9Y78wOEJ/YIEfA==
X-Received: by 2002:a9d:2926:: with SMTP id d35mr2583664otb.181.1597100881727;
        Mon, 10 Aug 2020 16:08:01 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id p9sm3497667oti.22.2020.08.10.16.08.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2020 16:08:01 -0700 (PDT)
Subject: Re: [PATCH 5.7 00/79] 5.7.15-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20200810151812.114485777@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <2f87ea34-7643-8a54-054c-cec2ec371521@linuxfoundation.org>
Date:   Mon, 10 Aug 2020 17:07:59 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200810151812.114485777@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/10/20 9:20 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.7.15 release.
> There are 79 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Aug 2020 15:17:47 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.15-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.7.y
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

