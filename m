Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF0924C8E0
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 01:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbgHTX5n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 19:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726868AbgHTX4L (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 19:56:11 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45355C06138B
        for <stable@vger.kernel.org>; Thu, 20 Aug 2020 16:47:49 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id e6so101470oii.4
        for <stable@vger.kernel.org>; Thu, 20 Aug 2020 16:47:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bIbtWEcH1THnymq0KZNRDlHBeYydc02vXBW8/wH0kWg=;
        b=ATfsMrtag0zq6+bSazuR6YxvkK0VIIJmLTRwNenQGZ7nWfsLndfXAb7DGJUPS+OOVD
         pCvKnatMOPLKOrM1wwkJuJDRd5Zk3bdCVk8TFFq1B7tiCp9lTSsoTh0PO/ccv83DmQQG
         8uX4CHL68BBeK6wpry52tL55Vmql5VhuIpU3Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bIbtWEcH1THnymq0KZNRDlHBeYydc02vXBW8/wH0kWg=;
        b=LLJ4Fg20JHJ1RdM3DRUuxFXrgy2y4Ypg1oi4MVTUlztwxK3Nkjaj3PhbVrp355DLkO
         DKoHPo2qMI5F+9KO/Z/li0NsvuY6Ll8pmYsxxOwAM+ouJQprLKaJNxHntLh+4UyNpl+Q
         RIkyANLgex3vcoyGWjOFMT2Bf0eaASHHjslL7o47ESoDmZNEO+chCFh/zyf/JVAjBP7A
         mFL0wYGyOp8W7WlyYmRlAuERy5v1HGRNNFcx/KXV8Inv+quRNTYTiYk1jbwPeBn6/yZ2
         syMxEGZMlZ61EPqFIhtoNF8V2z51PGHkRU138iUJQfnQRiNJgKFpfWkFx8bteyQW5CWm
         dD4g==
X-Gm-Message-State: AOAM530hflA6QwaHOjJykkA+eDaUF8BdC8QsyMQedTzpYNRpWyYZ/K1Q
        BmFk851IsAZkykirgpeKGYrlwQ==
X-Google-Smtp-Source: ABdhPJyARvgODqqfFMWZu23Qu8qq6RYTeefXOse0RFoa+7GY+pGejGf0R/6EHLsRapoPqcyJk4wCbQ==
X-Received: by 2002:aca:f504:: with SMTP id t4mr155326oih.137.1597967268547;
        Thu, 20 Aug 2020 16:47:48 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id w22sm42494ooq.37.2020.08.20.16.47.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Aug 2020 16:47:47 -0700 (PDT)
Subject: Re: [PATCH 5.8 000/232] 5.8.3-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <5de67ee5-20aa-a8f5-103c-f770d5711fba@linuxfoundation.org>
Date:   Thu, 20 Aug 2020 17:47:46 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/20/20 3:17 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.8.3 release.
> There are 232 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 Aug 2020 09:15:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.3-rc1.gz
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

