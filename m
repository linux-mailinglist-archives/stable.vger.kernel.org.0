Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBE8F35498E
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 02:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238020AbhDFAJk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 20:09:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232730AbhDFAJk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Apr 2021 20:09:40 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 194EFC06174A
        for <stable@vger.kernel.org>; Mon,  5 Apr 2021 17:09:33 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id d10so11542713ils.5
        for <stable@vger.kernel.org>; Mon, 05 Apr 2021 17:09:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XWIubwUXF/jy2PvmQiEwr0O1TmH8h43aglO/vnVr6AA=;
        b=bs/tBPanj/C2XeyPg92BG4yBREpHf+G4YvjUrY9PV9uryTHqmfk8ezl3XJt4GD78lt
         IzChCBuESi4rRaprCCdYVrgLg1R21A0Mr8FNVYNlmozOvcCy3TdQX73Fws5ELo+0pVAi
         ZLxpprQG+L4J0XW3CpbxQBmvy0JzQu+5UVQsY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XWIubwUXF/jy2PvmQiEwr0O1TmH8h43aglO/vnVr6AA=;
        b=AETlOiTt1pugbyzK47MhiFwjnjqPNH4S+2TPByefJEaWgOw3dXXFHKeXyco4T8MBey
         iGYjwh7me92z6W7UYnh4q38dbgldN8D87w2wev1j85oTH+q9vZAMPz0v4JkttphDUTs7
         t0cMBPYt+oQyOZtcoay+EJbtMI3rWIC6qj+1+hBw7bikVP6ZtmTEGdSZbkqkpvLqQDtm
         +EIvGXvTThTaH3ksBvtBUB2RAVLPRlFXt+1xEUr6ouvAtww4+T+XrmtMXkXog7PS1MMo
         ByaP9URvlu7bKxXgK4nWppP3sQq2MQPVCuP2h0IYozMB2kwCedWhbmIFeZBnHF/hzdTC
         pmhQ==
X-Gm-Message-State: AOAM5302XSQfc0dROvdlsAC/QksiXUvNS3k9Lt4rar9Y9S513nLWW9q1
        LQ5n4bFnDSnwlsIyL4b/nHbqog==
X-Google-Smtp-Source: ABdhPJzFyDCgAh1qGbIJqN0WEXnPK8BEc46T3C435YzSQPjRhjaCNdlaq1J0tuFZyYWn9aiAyOqhsg==
X-Received: by 2002:a05:6e02:1584:: with SMTP id m4mr22312890ilu.108.1617667772483;
        Mon, 05 Apr 2021 17:09:32 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id k11sm13158445iok.1.2021.04.05.17.09.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Apr 2021 17:09:32 -0700 (PDT)
Subject: Re: [PATCH 5.11 000/152] 5.11.12-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210405085034.233917714@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <83bc807b-03d0-9884-651c-a82ca3d99e7c@linuxfoundation.org>
Date:   Mon, 5 Apr 2021 18:09:31 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210405085034.233917714@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/5/21 2:52 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.11.12 release.
> There are 152 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 07 Apr 2021 08:50:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
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
