Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49BBF35A8B7
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 00:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235010AbhDIWcO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 18:32:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234951AbhDIWcN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Apr 2021 18:32:13 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A149C061763
        for <stable@vger.kernel.org>; Fri,  9 Apr 2021 15:32:00 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id d12so3355455iod.12
        for <stable@vger.kernel.org>; Fri, 09 Apr 2021 15:32:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LyVEXM4TmInjbu+KbY9qpw8hJXr4CrkW2ZOgUZ+M4BA=;
        b=Azopk5RVVPkbdafyzlAwLMi5Hz+KXXjoXzGkuUods75WbPdFNCYevyX8CaFi/WydCF
         31Oh+lyQq43ZWyQT2zHbVDHYqV3hsLxImw+yyO1FkQP5cLthJdySzo6XvuWwzKRm43QV
         XTCzTYNC863uVJ8OwaGcptzvB6yWgEkPkr9EQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LyVEXM4TmInjbu+KbY9qpw8hJXr4CrkW2ZOgUZ+M4BA=;
        b=mD+Qv89PkQemoWrOoX+DOMcF0powie6LQK8jIu1nWTkcxvLn6tm5KxSDJWGcJe3P7L
         Z5/1Am5dOe7Q2KCD0IFNJgE342/XGtvA06dLIbo7k6pJtA6SEM69wqOOuuo3cYxFn4W/
         0brPAiqi0uEFU6tOTFHopc5sXkz6bBcTCU+QINnBKl5HkdC4pd2dK76ANr0S+h4Ap6i9
         aP5h+Pg0hiMZUKj76n3makeJamWVnfJKQ/3RpLPlP+uafk390oCWAqqdbubEqazO/7yP
         swcAmXLjD6E2W+bJxZ97dwJ8k/AJR+6DyKiBpE06wBRhkhkmpEJ6YXYBytUPYzyie+uC
         +VEg==
X-Gm-Message-State: AOAM531s0zI0Cqo2hGhm3Npr2CRJ2+C5O+R+lEhZ5jfa/bypkudh2hh8
        mJYHIpK+2HixDEuEXSn0d+SkiA==
X-Google-Smtp-Source: ABdhPJxudhSnnUH+2iUvXsMMidUT4RADAD6TfRkDFtd4q/Dg9UvT4+AFbxt8KuaAmOHxq7bSCxsZhA==
X-Received: by 2002:a05:6638:2a3:: with SMTP id d3mr17326922jaq.42.1618007519929;
        Fri, 09 Apr 2021 15:31:59 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id o6sm1816670ioa.21.2021.04.09.15.31.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Apr 2021 15:31:59 -0700 (PDT)
Subject: Re: [PATCH 4.9 00/13] 4.9.266-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210409095259.624577828@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <d308015d-6a38-61e0-b2c1-4fdade360efb@linuxfoundation.org>
Date:   Fri, 9 Apr 2021 16:31:58 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210409095259.624577828@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/9/21 3:53 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.266 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 11 Apr 2021 09:52:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.266-rc1.gz
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

