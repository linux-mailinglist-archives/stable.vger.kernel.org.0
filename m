Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39F75218A9D
	for <lists+stable@lfdr.de>; Wed,  8 Jul 2020 17:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729888AbgGHPAo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jul 2020 11:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729815AbgGHPAn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jul 2020 11:00:43 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6A78C061A0B
        for <stable@vger.kernel.org>; Wed,  8 Jul 2020 08:00:41 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id t198so25495977oie.7
        for <stable@vger.kernel.org>; Wed, 08 Jul 2020 08:00:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0GZgF/SyAhnMOXZCKoaQ1p6yjE2XQ72Ure/u4JzjEMg=;
        b=aWuWIcLFQ46VvdRzCVzqrfCzNUTmGcEQ8EsHJSBJ68MGVCHEvauLRtPXkri8BbADKj
         Z1UHksgZTXONRXDVSJzG48ExfRw7pMPjkGuaer+1aYJ6YQwTlRRgRvv8CIEQ7wTlGd9B
         srfARCjoO0QI52xSLXR/utQJ0ABCBjUgT8Abw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0GZgF/SyAhnMOXZCKoaQ1p6yjE2XQ72Ure/u4JzjEMg=;
        b=jhTHb2byaLYc2CmMDKghGvHT8QB3JR8QaE7nP4HhRvGHJC6cSPyOKDPYwYB5zI9XBA
         rPcWn+28RYtdR3i0ayfnbiviR7+LKEIaHxDkQa/UzSUihj4y2tz0kampQmz1hKFhxug6
         cIdS5Ti1WqirLWPT6UvwEaAKZ2Ls431SE8A8fKHEz8ka4p6rqhzLwuOq+4bTMF7vHPWu
         hHEYziA50MAGezpPopzTYR3/IvP8w23DXkQkoDgneZH7YyWDnA0KuLaf/AQRW15uXEZG
         1rZiHgeK8BvqtED7r8JWdrbIpgY8P56yyKkOSTeD1hBp8Mz91oAc3v6gk5dCEg8INGC5
         W4lg==
X-Gm-Message-State: AOAM532EShDLARch+JNkUA1skKIlMjtoAT+M3OArbwxQ+5wngWWIMDdf
        gHdqELeOl9GQiO1IUTGdNyvlfw==
X-Google-Smtp-Source: ABdhPJxXSRc4vYONf0j91kT5lMWUgUpWTXL5LI/rgNjA97TZzv3YXY47t5H6qFbT/QfSD1RD423Kxw==
X-Received: by 2002:aca:5c03:: with SMTP id q3mr7779580oib.132.1594220441078;
        Wed, 08 Jul 2020 08:00:41 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id c26sm6433809otr.26.2020.07.08.08.00.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 08:00:40 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/65] 5.4.51-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20200707145752.417212219@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <cf5d63dc-cf72-81b6-f76a-b27ebaff13fd@linuxfoundation.org>
Date:   Wed, 8 Jul 2020 09:00:39 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200707145752.417212219@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/7/20 9:16 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.51 release.
> There are 65 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Jul 2020 14:57:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.51-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah
