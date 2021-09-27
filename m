Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D7F541A373
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 00:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237797AbhI0W7z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 18:59:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237749AbhI0W7y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Sep 2021 18:59:54 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB94C061575
        for <stable@vger.kernel.org>; Mon, 27 Sep 2021 15:58:16 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id r75so24926618iod.7
        for <stable@vger.kernel.org>; Mon, 27 Sep 2021 15:58:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JvsvAi/jhPABlYynYFZG6hTxrqcvhKe59dyAuq5vYKc=;
        b=ZFimGlDzTM9pp2sZW9Z4ytVISi99HaPEYdDbPEbkDmP9fGYn9lYhjI8ReTbK5bq0HR
         62jd7e/NhEBjhA+B52F2YmIz5ZqFzuwficRrjXFoacFFPTWUh3Ae7lrfMr/7Pc1PVjP1
         Mq19kLn+051Q1IY56FwWMNSGCXfoJrJ+k5iRQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JvsvAi/jhPABlYynYFZG6hTxrqcvhKe59dyAuq5vYKc=;
        b=4H0jHPx7x30QZEYjvE0iPNKogukAJKTDVIHRf4g5HB3mXxKkDDjiIFIsvNrl+0ohAI
         GNzZ4I8yhIADo3bZ/59Ao+NpbYWa06qX3c1DlK4wNKIY+9ZYBoMy+mIDqxGp3uDuBFQR
         dv/hFD+IpFcY37NN4mh2WwT6+sNwCzVolRnrwLJ3WCMzWBtCX/PjrhJ+wyiEz35kguQt
         DMe0HNc/rj0swwl8USPFR5B/WxoEWE4nVQZ2QZagNGk7QAZJnaXFCNP8YO7hskSbFexX
         ng/ArBqJBAHe8O5aOdqBBHTVL3t+b4imJxLeM6DKWVAuWPDkEyfXez8npqgIfcmQzisp
         Qwaw==
X-Gm-Message-State: AOAM531pPBOw7txfCnup/QG+zLKqaIOgM+qhe3smqBsm8xTCCN4hiI7z
        4806SfxA13dhXCrO8Voqrvfoow==
X-Google-Smtp-Source: ABdhPJwDAshJAtoPM812J4z4qTQKT6ohczyCXgEyxo+erXGoB7G7dX64hGCHuUVHyXbOYSI+LLo0cQ==
X-Received: by 2002:a02:a38f:: with SMTP id y15mr1960097jak.26.1632783495699;
        Mon, 27 Sep 2021 15:58:15 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id d12sm626185ila.79.2021.09.27.15.58.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Sep 2021 15:58:15 -0700 (PDT)
Subject: Re: [PATCH 5.14 000/162] 5.14.9-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <0722f2b8-61ef-09c0-280b-572aa9267497@linuxfoundation.org>
Date:   Mon, 27 Sep 2021 16:58:14 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/27/21 11:00 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.9 release.
> There are 162 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Sep 2021 17:02:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
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
