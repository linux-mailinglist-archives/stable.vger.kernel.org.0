Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74D3F323324
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 22:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233818AbhBWVSo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 16:18:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233159AbhBWVSi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Feb 2021 16:18:38 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37823C06174A
        for <stable@vger.kernel.org>; Tue, 23 Feb 2021 13:17:57 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id y202so18758294iof.1
        for <stable@vger.kernel.org>; Tue, 23 Feb 2021 13:17:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IDdOidXQKtdgzKXev6RJjW2Zdh/qSw86B89juMbHLSs=;
        b=HSi4n3KwB2lQi0fWKcs2+qFoxE6h/yEQ5cYtRDKC+zc7fPCUE+beOewuOxaOsj8WJF
         nJSAPQ5mILEq+ldR2q5u9SDZJ7w3v3+/iG1VD/snzq3UYvX1l/ZXCMborsBWYxTVBnPw
         Kyoqku9c4YdcDk/LeUnO3FdasncaJJRn+JCoQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IDdOidXQKtdgzKXev6RJjW2Zdh/qSw86B89juMbHLSs=;
        b=kVN3bl9cdiElSJnDryAUfsbLRSp6Vh4RFZTgLxmKSrmjSUMAKWPbxrFmk+v44d1O2i
         8Gy57H9H2RbPsHwuZtbsT3WzqYhA+MowKdI0TQgpTYUml5E0EXWeCQmkzMsykBixz4vD
         WJhyzkccXZMq1/aQBdpoFqWTTkmqJK4HIiL9I/68x12achOeB2lq2T+gcbRXjZDXgdpW
         +GSYIu22vbZKUm7OAAW/thnie2KWbyZV00XsHU+WykWxZDwoPfZk0WYe3NO2aXcq/eyP
         HQ8Ka3QTZsXOwlzAipx4KKhpW/jH0nIOIEz+qdqaSURKXSlOwUVr7OiFNT3QxWfEG7fc
         zcaw==
X-Gm-Message-State: AOAM530AryMK3kIdoHlFemDJ0xO2rV5vY1ZLCt0jGUlsrPOoqDFtojQl
        /Bq7Xl5/z0Xs8spZjzlLA/QZ8Q==
X-Google-Smtp-Source: ABdhPJwUN9ycbb/q+0usYAwWx5HJth1GuPLDhdYRoRtzMe2HNfuU1sLdcxqgB9EUSKccY32P/dm4aw==
X-Received: by 2002:a05:6602:26c6:: with SMTP id g6mr21114948ioo.150.1614115076679;
        Tue, 23 Feb 2021 13:17:56 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id b23sm24658ioz.6.2021.02.23.13.17.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Feb 2021 13:17:56 -0800 (PST)
Subject: Re: [PATCH 4.19 00/50] 4.19.177-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20210222121019.925481519@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <b945df39-81d9-d17c-8f19-07ea8138e9d9@linuxfoundation.org>
Date:   Tue, 23 Feb 2021 14:17:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210222121019.925481519@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/22/21 5:12 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.177 release.
> There are 50 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 Feb 2021 12:07:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.177-rc1.gz
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
