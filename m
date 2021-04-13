Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8C4435D4DD
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 03:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238147AbhDMBeo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 21:34:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237870AbhDMBen (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Apr 2021 21:34:43 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CA52C061574
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 18:34:25 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id e186so15447805iof.7
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 18:34:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ANTSeFlpFSVd9wNQakX4ES7nDZpCT79WuUjTq/e2V0k=;
        b=gjrPMoem41eiQAcN8CWU7UHNQW4FBDRe7v1NXejpf5l/QzYCkTfHTKopizhnTAiwMG
         1Ak2UjDvbxt6Rryx8zH8WXM4+VBzWmi8jOJLqgste6aBuCFJXO7T9Z1+2O/v2wrVi0rs
         KhgXHajWJq4YzIoC/NnUzOrLRW4bLKQ86LkLk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ANTSeFlpFSVd9wNQakX4ES7nDZpCT79WuUjTq/e2V0k=;
        b=i3ZM+/EloefRRVutzuljL7GOoTABzLDTOF6k5YuVifn38J4GJID1QeQMuUW5gn9D7m
         ewW2mT8B9LBtmANwmT0uIk0PApOS9lnx4Ckr0FB5J1EU2DSIvOid6AKUS0F5PnF3av3c
         wo1fPjQVBKqEkodN6g8RDxta3t01/v4y0D/33qDWLbir5hF79cIlTVttcwrmqXemymEV
         lyXGuEknHHylVlBUiyIE9pHccAP+PbN37QUSjse5pxYCRy/68ruzb1d/6ouhnvELSPGS
         9e0xFtQpMR/NEB+B9WGaUh4P7jdRxVTMZppBxvVYIFYbHvQxOJVzDwinaO7Uxq8KldQw
         Br3Q==
X-Gm-Message-State: AOAM532Fn6bTt2aFwF7TgR2C83PVNgpxmwKZc81U7pJDBBncGRcpiKFO
        ddks9mFIQg4H0SwhdG3msXdQ7Q==
X-Google-Smtp-Source: ABdhPJwM+S+XnUOQXVO+FQLuzQ6iQqBxzN/qaFWTKOdOsLOUoN8UDTa7tK3ON4Y/Ki7+mSQEPwzwHw==
X-Received: by 2002:a05:6602:1c9:: with SMTP id w9mr24743760iot.201.1618277664558;
        Mon, 12 Apr 2021 18:34:24 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id m5sm4719956ilg.79.2021.04.12.18.34.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Apr 2021 18:34:24 -0700 (PDT)
Subject: Re: [PATCH 5.10 000/188] 5.10.30-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <22f0e1dc-0ee1-e261-a271-1a2dd6a797ad@linuxfoundation.org>
Date:   Mon, 12 Apr 2021 19:34:23 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/12/21 2:38 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.30 release.
> There are 188 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Apr 2021 08:39:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.30-rc1.gz
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
