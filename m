Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E51AA3E9AD8
	for <lists+stable@lfdr.de>; Thu, 12 Aug 2021 00:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232498AbhHKWVw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Aug 2021 18:21:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232479AbhHKWVw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Aug 2021 18:21:52 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CB1EC061765
        for <stable@vger.kernel.org>; Wed, 11 Aug 2021 15:21:28 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id a7-20020a9d5c870000b029050333abe08aso5203776oti.13
        for <stable@vger.kernel.org>; Wed, 11 Aug 2021 15:21:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Hl+cowkcsqz9pS2qQfdEeFQsOzDImHAlBOUF6NAHZN0=;
        b=JU0U/pOG4BhbMfsSqf/MaL1Bf8RUPJHCXLOKj4458RaFceH5G8bbIpSBzfN+DfqdxJ
         qm4KYaB4QBXnt9QI/+NhIsz37NW9zHcXKue0cCjxq+1kLv3JOnwuM/u7Zo4MikmPOVRN
         NxBQZSsFIFvCemJ9JIiEkBWNmKchCa+ZUi0h8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Hl+cowkcsqz9pS2qQfdEeFQsOzDImHAlBOUF6NAHZN0=;
        b=nufIKiXVobRw6FFwyf2IUG0p5ISWt5QtIjjDO5RvtjeWcV2qeaZZnE69U2lR+AZQ+M
         BY2T+yA+GG3N5q4d53KKDOFStF0Soa2+f0ixRqP40+sJreGHtQSm2gaSSeEc1+mKt+x7
         gr99e6jN0BPeojil8kos9IrPJ7w/l3kr+StetL5gs2S5zCUceMTeXesYzXzgYL5UYbVi
         uuO4nl9RPR+ll7NwH5XlDv8vsNueRB9caLlQKOoYJ1afrs4ux1/8S8Y5NyXVS4XEAWRv
         9CCD0Stv4Nib0Bb05liNGsqPs+IRIgNa7y63TwSY6xDsolAvLbIQFxpm94XcQlCOx3cA
         BnFw==
X-Gm-Message-State: AOAM5334pYSL7eDkLUW08oyL014GwtKV8G0aroOkYtodUyLUp2kDtYAO
        rC7gBOaOYAiTgoewfNEr4w/c3Q==
X-Google-Smtp-Source: ABdhPJzEStZR2W+DelQd8ribGe9t8M9kR5JxayyFiItHU1nHdd8YwKpRAG2gifEeGm+Fco/2hsGJHA==
X-Received: by 2002:a9d:4817:: with SMTP id c23mr995709otf.98.1628720487456;
        Wed, 11 Aug 2021 15:21:27 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id w9sm125541ooe.15.2021.08.11.15.21.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Aug 2021 15:21:27 -0700 (PDT)
Subject: Re: [PATCH 5.10 000/135] 5.10.58-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210810172955.660225700@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <e010bd66-43fd-bc01-243d-e94f095e58a0@linuxfoundation.org>
Date:   Wed, 11 Aug 2021 16:21:26 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210810172955.660225700@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/10/21 11:28 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.58 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 Aug 2021 17:29:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.58-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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

