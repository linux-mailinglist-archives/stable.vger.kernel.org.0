Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 037C22EB050
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 17:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729543AbhAEQj0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 11:39:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727634AbhAEQjZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jan 2021 11:39:25 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F9DCC061574
        for <stable@vger.kernel.org>; Tue,  5 Jan 2021 08:38:44 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id y5so28770774iow.5
        for <stable@vger.kernel.org>; Tue, 05 Jan 2021 08:38:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fn+XDBGG98XHGcdw+sdCZGsRbR49Bp2d8ZeVVxDYpDI=;
        b=Dr8TA3Uz2+2gLjUVdIs7BdUKjvU+ADzGoJ3PbHpyoWk5o5bu//jox0jIBNgjZy2WGd
         Y3pWWxJ+7k4XC3NpMMcsUCQh+mUEYqQlNfAqcVteSG/TAjWVS7lWCN5fXypx6HwccgJy
         FcN7DIOzH74BIjSX702K7x7Xt0gzgxtCCN3Ho=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fn+XDBGG98XHGcdw+sdCZGsRbR49Bp2d8ZeVVxDYpDI=;
        b=XScOIQ4L8DwHhKa7X7reaVlPlsDiPJ5/rLoVkpJP8ReBq8LMMl9XUPdx2ajHAfOLXh
         ccDwESy1FzYkNh/eYerebfZRUwr3jNMWHZGixCeCqLyUCXW5wKvRqOOG7l0l+sB1K+zr
         t1+KmmtxxdSsFI8j3o2r2T/Pd0hjbMFuwk42Q9vRADkMQMXcEGKhilFBVcCN6oMdUTKR
         qmeIh1jfhAQUwNECQpijNQd/jE4Q2uKCcB1Tbn3balG7XKr01XngUPueqTu+cwi/YTLu
         GQ1k+eG7M1BUuI5iO9UokNz46OK1peSxIyoRlNswZ/e1nQEd0to7h1sUHW3yaLKEhs9k
         4l2Q==
X-Gm-Message-State: AOAM531S+xxcJqOSDE2O/pYn1wvRK19gAxjcHs3DptpTChbMsTKQXpKW
        WqkvDOIdQ7VILm4RP/BpGnDvWA==
X-Google-Smtp-Source: ABdhPJy2hdIT1E8/EJRHPCRWvK/OZHOoxEA9fDHfDyVBG1MluVsefDtBUzkPZ3Vd0c4rTdHpK/pMNQ==
X-Received: by 2002:a6b:c994:: with SMTP id z142mr28197iof.42.1609864723732;
        Tue, 05 Jan 2021 08:38:43 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id o11sm58191ilt.23.2021.01.05.08.38.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Jan 2021 08:38:43 -0800 (PST)
Subject: Re: [PATCH 5.10 00/63] 5.10.5-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20210104155708.800470590@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <c6849ef3-d400-3642-bb13-dbc426162872@linuxfoundation.org>
Date:   Tue, 5 Jan 2021 09:38:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210104155708.800470590@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/4/21 8:56 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.5 release.
> There are 63 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 06 Jan 2021 15:56:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.5-rc1.gz
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

