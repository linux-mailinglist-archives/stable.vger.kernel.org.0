Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 141AA2C1A1D
	for <lists+stable@lfdr.de>; Tue, 24 Nov 2020 01:35:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728662AbgKXAci (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 19:32:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727724AbgKXAch (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Nov 2020 19:32:37 -0500
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55A07C0613CF
        for <stable@vger.kernel.org>; Mon, 23 Nov 2020 16:32:37 -0800 (PST)
Received: by mail-io1-xd43.google.com with SMTP id i18so20148185ioa.3
        for <stable@vger.kernel.org>; Mon, 23 Nov 2020 16:32:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cpiqXzx/LdrQtwsDnbGwM6Xu9hJ4qy3xVR96zQLt+tY=;
        b=Dr9saXZ5MaNxavs31lvgFRv8CKUXkIL3JKOXJaqqA4WjCwvXl2xvtXw2KsMZYJe7jX
         hoxrSN//OckPL9Hd0Z9sFl5/2r3pDes24wJ4fyLBIwRPj5m8AStW61vrfVAgvKn28mSN
         F3tL57weG8paqnSdBcNlVarDiRBHw3ewvi70o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cpiqXzx/LdrQtwsDnbGwM6Xu9hJ4qy3xVR96zQLt+tY=;
        b=gfWX0hfNYqHWB4AEwaGK5GHqhF//sLybZhsw4ZUddx1pMTSHkc3xyLwWiFidj75d1C
         JNqvUUlDwxPm4eEngEG04H8tGBth4BSeE2LKjTYsGcIKJ9GJjTXqbnn0z7Zg0BVjMMNG
         GvYv8CIJgCF/YqHtRFbZGVKyE0mtKl9gtnEmq80N0Z+9BOOWqrF/9zpOjBzSxkPfVwXc
         hCYYYq9kSung21+fFl10oDAxAnkZMMrU1bvu1fNKPkn7rQAKsYDkBSTBbEr+Sc4D9d9k
         H7r1MR3G48KfzKkM4lIdN3dZtNccmkkQAWDFrVobAJAlUw3sAAKhgwORE+oJ9DM8gw65
         NpPQ==
X-Gm-Message-State: AOAM530wbkvYIc4298y6Y69kVYo/nXnQCjowbZKRkC/J+2lOICo3AXue
        OPqE7x80gaSY5m4Jupxr326KZw==
X-Google-Smtp-Source: ABdhPJw6nFU1l5FxnceORg7bsFdu5ur3UZhQueKh5uQCr0X1AwWkgpDc0cGu+tMn5vAdi68KKdt2Gg==
X-Received: by 2002:a05:6602:59:: with SMTP id z25mr2033785ioz.2.1606177956794;
        Mon, 23 Nov 2020 16:32:36 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id t12sm7069856ios.12.2020.11.23.16.32.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Nov 2020 16:32:36 -0800 (PST)
Subject: Re: [PATCH 4.9 00/47] 4.9.246-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20201123121805.530891002@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <49308954-196f-e962-faa5-992d58c49f94@linuxfoundation.org>
Date:   Mon, 23 Nov 2020 17:32:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <20201123121805.530891002@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/23/20 5:21 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.246 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Nov 2020 12:17:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.246-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
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

