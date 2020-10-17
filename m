Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 421B82912FF
	for <lists+stable@lfdr.de>; Sat, 17 Oct 2020 18:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438201AbgJQQLb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Oct 2020 12:11:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2411556AbgJQQLb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Oct 2020 12:11:31 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4030EC061755
        for <stable@vger.kernel.org>; Sat, 17 Oct 2020 09:11:31 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id l16so6003847ilj.9
        for <stable@vger.kernel.org>; Sat, 17 Oct 2020 09:11:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CJl8E+hI9mddMKfGLzS3CrF1csAMvdkU3W2yARhMj3Q=;
        b=KrDeSmxqY1VQjFtb4IaiwGrHOf930aEIqW7MG1nfmNqeks1DzdtkwLvORP7LVFLP4c
         sJX5a/QEZU1birVFqOVEwkY2vaZgf0eyxs7YnQfLXMIvWPm02cTgkGma9gVFCbrQa0fh
         OUfe9Hxg28bWQ0dTf8AVzzpAHDmGuZajNAM2U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CJl8E+hI9mddMKfGLzS3CrF1csAMvdkU3W2yARhMj3Q=;
        b=SJoU5H5t/MHNOk32mi7Xswi2UKNh4CJ2Z6K/ziHWKKFKGFnVqiAVqWNPWi+yvbX81w
         TG44dlaEe9fKWViNCp/Iana4/tiTWWm7pA7K2zBOZHxFtJGheymvMxAx8mQtcKD5jh9M
         mwnJlEjmQzdOD2Y2+DmH9uH79HCFZNpsuI31NPNj8j6ItZ6cCnTmVmHc42kUrywuvsqY
         7LY5jKcBYQq4ZDvUyT/UVtRiv8wRRToFVN14y9xBOjLHW9UbsWlOnqrQIQm3CPlK+EO3
         XtHwGzWjfb/RgXOyIyXJlDDYScqqJrsPEePmlA8xRDKcBwpKaWpk6IUBxbwgKY4lszOm
         O6Kg==
X-Gm-Message-State: AOAM530omfK4mjn7O7sgqVIMcl6Z1DnA6wMrSjFI8Ce6qs8LZgefkXa6
        ahGSQS+A3ofCZQL9Kwb9Bxqvdg==
X-Google-Smtp-Source: ABdhPJwSdCMBHiiRgEZk/hwIt7aNwJLp+0CkIjH1wRWMqRDO2HntJUkp2OjtkGde6m9uV8CXj8LS9g==
X-Received: by 2002:a92:4944:: with SMTP id w65mr6384629ila.288.1602951090679;
        Sat, 17 Oct 2020 09:11:30 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id b9sm5281558ilq.51.2020.10.17.09.11.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Oct 2020 09:11:30 -0700 (PDT)
Subject: Re: [PATCH 4.14 00/18] 4.14.202-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20201016090437.265805669@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <7a62e309-8b6b-6132-490c-ef1d7ecf7b8a@linuxfoundation.org>
Date:   Sat, 17 Oct 2020 10:11:29 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201016090437.265805669@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/16/20 3:07 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.202 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 18 Oct 2020 09:04:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.202-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
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
