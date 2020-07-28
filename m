Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B47522FEFD
	for <lists+stable@lfdr.de>; Tue, 28 Jul 2020 03:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbgG1Bhr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 21:37:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726237AbgG1Bhq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jul 2020 21:37:46 -0400
Received: from mail-oo1-xc42.google.com (mail-oo1-xc42.google.com [IPv6:2607:f8b0:4864:20::c42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82C74C0619D2
        for <stable@vger.kernel.org>; Mon, 27 Jul 2020 18:37:46 -0700 (PDT)
Received: by mail-oo1-xc42.google.com with SMTP id n24so955055ooc.3
        for <stable@vger.kernel.org>; Mon, 27 Jul 2020 18:37:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7BD7VlCj+9fpGvYrpIdg86knouvhbQ4T8igQFat8A60=;
        b=SIA5rWqg9HgoCgllvk4zWkQEuUIGT34XDUKEcV14EfjJkyaQpfWOhZ4CmkEGmD8OoM
         qMnLkvRZHKOSedqhZ98xm6O9p+QtxY5/zJkjuGOM4VmbkokrMKSklWaDFX4Tz+rg7AnF
         8Y4qEM5EoBuvHOYh2vYp+Wchg3UV+BuLNIerY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7BD7VlCj+9fpGvYrpIdg86knouvhbQ4T8igQFat8A60=;
        b=eD+JZqDkd2/WLNQNzpADUlvUbZNRG8cp54AgIk7ztDt8Fs07cq22ujlCOx4/O2wj3L
         12+Sj833C2WB0bGLKD0B7gbjeZvs72vh1eEwYY61UFDTX3Ywhf8tKHAwaMqTKol0oTKo
         taLIbBTmTaT5xagmXvovyJp14Ep9gRYBp8hnQC0J+PLQTXYy4PQkg4M1D9CCvtBkFfhb
         II1Gwixtujcmw8cfeKnms5GMbhzBtxYupW3pxwBHjJ6aEW0aiExExmzZH71G/3lvPR91
         u/mR7iEwBVnboIDM1zooWm5E+9vMtDS7arHabKc5zwSewihP0wA81aIpXl1Vb7qf0xLo
         6d5g==
X-Gm-Message-State: AOAM5318br/6e6juQXM9IVgn2pwyuI75QAsfs/SoakIisQBSFkOSDmIW
        aCHzWmigV8SifaAxUWETcTIFvw==
X-Google-Smtp-Source: ABdhPJzl2D7vsp5ORNIRK95ufH+sTmHhiwE91vS4ngMTFMtLPuU9P/jNCxdupnrtOiwBm6zufOWXPw==
X-Received: by 2002:a4a:4150:: with SMTP id x77mr10571713ooa.21.1595900265818;
        Mon, 27 Jul 2020 18:37:45 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id r22sm2699990ooq.37.2020.07.27.18.37.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jul 2020 18:37:45 -0700 (PDT)
Subject: Re: [PATCH 4.19 00/86] 4.19.135-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, skhan@linuxfoundation.org
References: <20200727134914.312934924@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <139a2921-ed1a-cda6-8449-3b10f6d75940@linuxfoundation.org>
Date:   Mon, 27 Jul 2020 19:37:44 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200727134914.312934924@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/27/20 8:03 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.135 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Jul 2020 13:48:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.135-rc1.gz
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

