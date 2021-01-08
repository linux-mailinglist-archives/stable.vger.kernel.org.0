Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD35A2EEAC8
	for <lists+stable@lfdr.de>; Fri,  8 Jan 2021 02:12:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729832AbhAHBLj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 20:11:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729829AbhAHBLj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jan 2021 20:11:39 -0500
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07D0CC061285
        for <stable@vger.kernel.org>; Thu,  7 Jan 2021 17:10:58 -0800 (PST)
Received: by mail-ot1-x32c.google.com with SMTP id a109so8232498otc.1
        for <stable@vger.kernel.org>; Thu, 07 Jan 2021 17:10:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0FDXPA8gw2oNMsZaFQHMeqLocsKh/KaA8Xc2TDc9NL4=;
        b=cbrtW/rKxJq8kCIcDbxJoGA0uLiu1/udCm2O9FaYwp3GLJsICxDieWsl7qr+Tmd65b
         bBD8DJymkFNhyR52wjJUa9TLIZE5LTgobtZKiNFz+C8uy87O/7yItptGCmefgvHuhKjQ
         FLUQiJcXg7fbwiB+QEOcwDNQGQShx5whRdD40=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0FDXPA8gw2oNMsZaFQHMeqLocsKh/KaA8Xc2TDc9NL4=;
        b=SDD7BO5ptwyvr/SXs6d3cwPt4uTz9JmEW8WcMQrkS7DCdPwJLF1z1ibyd+m5ljUwt8
         sCd0K+87DIVAhrwvKbTHOwZLKaUA0S2RyvwQIW+sM/9QilELHvbnprXvdknDjUUbExBf
         US21GWwxmKVIgPCDixd5k93V+DXHC4LYL5NnPOe4SYJhAjSSR5yZwdCegNgEwMEXF4Qi
         EzyTUe5wgEmpsQAQK26mKsokpf9PjjvzgS7V5T5Uvu/T+27uhnqswKsxeNi0VJtqvSqp
         YPVF8k4ANycATjeUWhZdOIoedWPkqz6HA/3SvCu97KdKUlJohAJBfdPDvJTSeJutPpRb
         LTtg==
X-Gm-Message-State: AOAM533jJxxmeAxwVRMs+MlN9PKzeA+Bg6Jr2H7g7l9K8/ua3K9zxpFj
        lEhvp3IGJvIIjlavD/ZIvWZ16aNSFHSNgA==
X-Google-Smtp-Source: ABdhPJx0NhOOJ1/E9/MGT3irU+aY6rT/mGHD1rBe84HaKY850Z2eVLnlVNGqvpZRmcLgFW7851M3Pg==
X-Received: by 2002:a05:6830:1d66:: with SMTP id l6mr887357oti.23.1610068257451;
        Thu, 07 Jan 2021 17:10:57 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id q77sm1487577ooq.15.2021.01.07.17.10.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Jan 2021 17:10:56 -0800 (PST)
Subject: Re: [PATCH 4.19 0/8] 4.19.166-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20210107143047.586006010@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <1cde5107-b36c-e41c-3c8d-00eae3c45f5d@linuxfoundation.org>
Date:   Thu, 7 Jan 2021 18:10:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210107143047.586006010@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/7/21 7:32 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.166 release.
> There are 8 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 09 Jan 2021 14:30:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.166-rc1.gz
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
