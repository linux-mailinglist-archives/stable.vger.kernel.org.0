Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA79725A158
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 00:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbgIAWUD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 18:20:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726117AbgIAWUB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Sep 2020 18:20:01 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54E57C061244
        for <stable@vger.kernel.org>; Tue,  1 Sep 2020 15:20:01 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id v16so2555447otp.10
        for <stable@vger.kernel.org>; Tue, 01 Sep 2020 15:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WNfZAUxXAABQdDQchDkXXMD/igGrhM8AWkqaIapbhzY=;
        b=DjpZ8Pz43XQPA4tMFhKjxeMvsZnmgo5TZYK6EQtknRt18NBR+Z1CPP8FvDanN1eqrI
         5RfLYveqvbJ0UoMN3poP3t7ptYdA0ifx2+onPY4KHHIpho2WohvUCN5+WBn/l40YwGce
         E7tiPyJ3v9nH2j5rdWXzC0IkhPmDsYx4ne9q4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WNfZAUxXAABQdDQchDkXXMD/igGrhM8AWkqaIapbhzY=;
        b=kWrOUhovku9tnzJXR+cNlRjkn4TyLkOp8ifawnbBV6g3QlQj3HElV9u7iwA+6kOTLX
         GFWfsU3lUl+uU4AXD8TD2oa8dCeXyyRhIR61ram+KeHHFhMZvoApLSgq9E3SMpt8vFeN
         NDNsljO/JydtOj4gdhO/oL7nJ9tgs6dvMyfZmzZAeBQAJzLqL5rj/7S3uuhF+0SjOh3a
         +1Rc7pBXDtIXLVgDM4o4GelG7j4A6lR0VoLG2Z9MsDiX32AGhzviHlAsmi6kMI/qZLHK
         syAPVDjbZKQLdz+x2zTH0kwZrg97WlJib7K62J+uBK7y1b8tPrY/jwmo83NDxb1Y7w1a
         2Iaw==
X-Gm-Message-State: AOAM533b3AlubDc00RUJRGBZ0RzFfl7btQ3cYVRFMYJza97zK0yKbSFu
        Iw4yLLx2FvS5r2TlMG8V1cLu5muKyQbitA==
X-Google-Smtp-Source: ABdhPJzVdMILrV31cHU4FnnfEnKxSF+tr4R1UsCYj9MSPtvicCYZx37ciIkB9EknaLKLbehoAOgvqw==
X-Received: by 2002:a05:6830:3097:: with SMTP id f23mr2752664ots.305.1598998800742;
        Tue, 01 Sep 2020 15:20:00 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id 3sm419299otu.46.2020.09.01.15.19.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2020 15:20:00 -0700 (PDT)
Subject: Re: [PATCH 5.8 000/255] 5.8.6-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <5774a892-bf17-c759-0616-aaec4b740b9d@linuxfoundation.org>
Date:   Tue, 1 Sep 2020 16:19:59 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/1/20 9:07 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.8.6 release.
> There are 255 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 03 Sep 2020 15:09:01 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.8.y
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

