Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE71F413641
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 17:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234065AbhIUPfH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 11:35:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233853AbhIUPfH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 11:35:07 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 142E6C061575
        for <stable@vger.kernel.org>; Tue, 21 Sep 2021 08:33:39 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id i13so23140608ilm.4
        for <stable@vger.kernel.org>; Tue, 21 Sep 2021 08:33:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0eLDsx/2EJ0VqfuLJsx8Q8VpSkY12tGf7fLHU46IIl8=;
        b=LCAZgmA6ucLnOgNr+PG9SUiiAk4rZKpHYi80CUyacnD9o4MpH/oQsiMBwebe3XV4Sm
         MLAEf8o1/0Kd5QQKlJU6Cpt93i4TmOqSJPfehjNwnYnvVw8Z70c+TGFCMuLr8PJDQeJ1
         Y+O1S6fRNWxOENrgRNCrknnMXY7rPsfjAwUFM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0eLDsx/2EJ0VqfuLJsx8Q8VpSkY12tGf7fLHU46IIl8=;
        b=dsgfRFR75FTEP++1LO8HLuEAsNqRaR8szPOfnOeZGauT/lZdtrEdP8niKB7VJqH9hT
         u5Lvc7fsJdrbHzw0ncugl8RDOr8zphDB+lwQbUXzSOLj7A6YxWAQZcibksRMz6c29Tuz
         26IcCw4FxAZtfKCkiHR9d6alrFUpA2C1LUkFAKBN7EfKsUz6eMB4H9xFfy44x5HSp320
         ZWKHekvv+VyVYJr4c1O8OWtAgD5BMoO3/OMIeaL6dvWDGKhsPK+vOjU6SjQ89cVlK3HY
         mNA3zyJfYEdaITwc/1gNxgHb2d3MHQnqsr1W0oe1KMXd/CtVVky0txFAuBW+CD5kXNuK
         qtrw==
X-Gm-Message-State: AOAM532KPoHb/crzdhHg2xQbb1jsfFhkCUaA7t8u7aMg0or0/PreEIe6
        KbJo0mFbUFJnAyGJ0n9bdjMUJA==
X-Google-Smtp-Source: ABdhPJzlSwOJhzRc9k4KQ3XpLE/uHYd9e913K/4rSk6hWC8zd9yyQNH3z39flpA8S5XExCXZGmz9MA==
X-Received: by 2002:a05:6e02:20ed:: with SMTP id q13mr7613678ilv.111.1632238418485;
        Tue, 21 Sep 2021 08:33:38 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id v6sm1643442iox.11.2021.09.21.08.33.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Sep 2021 08:33:38 -0700 (PDT)
Subject: Re: [PATCH 5.4 000/260] 5.4.148-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <30e198a5-dcd4-05e3-b0ef-8ebefc51842c@linuxfoundation.org>
Date:   Tue, 21 Sep 2021 09:33:37 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/20/21 10:40 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.148 release.
> There are 260 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Sep 2021 16:38:49 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.148-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
