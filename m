Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 864F536BC54
	for <lists+stable@lfdr.de>; Tue, 27 Apr 2021 01:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234084AbhDZXsK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 19:48:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237410AbhDZXsK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Apr 2021 19:48:10 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA503C061574
        for <stable@vger.kernel.org>; Mon, 26 Apr 2021 16:47:26 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id q25so14322411iog.5
        for <stable@vger.kernel.org>; Mon, 26 Apr 2021 16:47:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=N1+iUjpt+DqfIQDqoAZUROb2PFGSGx7v6tjWvb6+dwI=;
        b=igVYFsShZh/AhNP6P10pgFaI6MMt09jJf+YhkQYzhBdx9ecSTUsepPwozgLXyQpszU
         5bg0rxNa7EfuuZHjuGPs2msscgwfnS7x5ERpXgBert5KB3Yr3BQz9KA3N+WDz7WM+XgR
         0RBZ8FaQE5KsmTB+WdLhOGnD/NRQOmZKFR+gU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=N1+iUjpt+DqfIQDqoAZUROb2PFGSGx7v6tjWvb6+dwI=;
        b=UB2AS1ESpBMQQZmz9a0gAOlxtOZrb1SBGN902YdHvl/i1wk2O/znS5ZNn4hQMtVzL6
         hq+YZp7WTik0Qa5+8WPkB9JEFc/IKdwOdlRZsMf7sI6LzOlOYOg0zJoH1hPhEyzQE/yk
         SpWbdbvfBBYcoS2egBqlirKTeyG6lIKl96xNJp2WNXSXLvoI1wlwUDYjyFIP3ME1BLyY
         1/JcU7nLhdrVOq7gnkImkUWUWUWu/L2TxEo15un5/aGp52Sz02UkCBRbISGjiLYBIISt
         JutWmCGa6DiwN8nuEYOLvAjDSpBC6LqorNfcz9HB7EjmkiiQZGMR/SEqimCIo07MfPkp
         JN4g==
X-Gm-Message-State: AOAM5320foT6ML0IyKpPtogGvDVREPPxEv482sT60J1XsTWcIfRGSyxy
        AVXtvAfYozX22r+bpgAihpV+lw==
X-Google-Smtp-Source: ABdhPJzzg5+PEH5nVFyTjJIYORnWOxYRq7VXwRWtouwh8VcL5mAz8TZqWpVja8OdoT2J/c23X9wI4A==
X-Received: by 2002:a6b:14c4:: with SMTP id 187mr16770938iou.134.1619480846176;
        Mon, 26 Apr 2021 16:47:26 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id q5sm8159606iop.17.2021.04.26.16.47.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Apr 2021 16:47:25 -0700 (PDT)
Subject: Re: [PATCH 4.19 00/57] 4.19.189-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210426072820.568997499@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <4b32f1a3-4518-59e9-7a40-5012cc1b6412@linuxfoundation.org>
Date:   Mon, 26 Apr 2021 17:47:25 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210426072820.568997499@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/26/21 1:28 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.189 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Apr 2021 07:28:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.189-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
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


