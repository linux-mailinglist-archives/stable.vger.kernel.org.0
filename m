Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2A531A280
	for <lists+stable@lfdr.de>; Fri, 12 Feb 2021 17:21:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbhBLQSj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Feb 2021 11:18:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbhBLQSg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Feb 2021 11:18:36 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B304CC06178A
        for <stable@vger.kernel.org>; Fri, 12 Feb 2021 08:17:51 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id z21so8474611iob.7
        for <stable@vger.kernel.org>; Fri, 12 Feb 2021 08:17:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=I5XGBMiYVQzPYsTEVpD7TBz8M4HLFi/2UW8Cw4sEt0Y=;
        b=cYKPviOydegN/kHFa2i6yCF1k8L0YPlYfj91gu7SBk6rNQRJoWtrRX/4MsH+pvKNWY
         NOaxK7kadAElp4ux9hkxi01kO+h/F3mvnZ5PNB3dNwFGKx7XjWroBbX51tODfpSbinzi
         0F3f3ycBJQkohQcK68VjwWxJA3i0q8sd6cqQw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=I5XGBMiYVQzPYsTEVpD7TBz8M4HLFi/2UW8Cw4sEt0Y=;
        b=DWqfxga6IhJmUeWy57rcfW0piV/NukmcaZWk0vgKh70k0Pal2E7S9mZZHsqXvzHOqR
         z55S68PROh5SQqVgvCl2MtbnQv2H+yISn3UXv3T4AsfMUNlbQGZaq17FbA5M/XFXIHcx
         ycr7Rf77TtnGq64JnFf/t9ptzPkFm6qMyW6TcDOLWK+7B4wOTbaTIpjTJFDVudKl1ZH2
         e5zXJ43o9Ks/BT6UjkEIrU3d35r9DNlrjME5B0sQ89zvYIL/lO2EImXAW4cCpi7doaXc
         sx/NXXQYA6XuCjzxSz1QbfFHdMzCJvM4HI01tytL6UWphrKKGuzJb0AkKHHxG2QxfxO6
         mzgA==
X-Gm-Message-State: AOAM533nd3e7QQfGAGObR8G3NAhKleIdgWj4IT6AG1SxcINdya1u9Egi
        xAZubSD1/3GOq2E0r373WJGS+w==
X-Google-Smtp-Source: ABdhPJxPN9dpp/xtJvCyo2ncekeZe2AsnQp52XshSoqNihLUbHnMJDfUdZX5h0jrXrfdyIzp2jAHRg==
X-Received: by 2002:a6b:3b53:: with SMTP id i80mr2635182ioa.203.1613146671191;
        Fri, 12 Feb 2021 08:17:51 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id s17sm4370146ioe.53.2021.02.12.08.17.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Feb 2021 08:17:50 -0800 (PST)
Subject: Re: [PATCH 5.4 00/24] 5.4.98-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20210211150148.516371325@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <31e8e4c2-cfce-3e24-0693-2246767aa8d1@linuxfoundation.org>
Date:   Fri, 12 Feb 2021 09:17:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210211150148.516371325@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/11/21 8:02 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.98 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 13 Feb 2021 15:01:39 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.98-rc1.gz
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
