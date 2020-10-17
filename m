Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 342402912D9
	for <lists+stable@lfdr.de>; Sat, 17 Oct 2020 18:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438011AbgJQQHO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Oct 2020 12:07:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437997AbgJQQHN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Oct 2020 12:07:13 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90460C0613CE
        for <stable@vger.kernel.org>; Sat, 17 Oct 2020 09:07:13 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id k6so7815360ior.2
        for <stable@vger.kernel.org>; Sat, 17 Oct 2020 09:07:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Lv3NiRJud0HcFs+GeeI/bxT6/V0UjuI6PKHovZ48Sx0=;
        b=L6GhyG4cOsUvN2q5L+oIJISWEG+geBmULIzNEvpqmITAfqIkEvN6IU1w1+X+6QqAVb
         an1QvEW2jgWcmkykBLLrQLcUt+tTSyrfLBmmCnnvMqy0FBkKp0XmtbeeF46OhEwlvm3+
         GkYD3VhUriaNDJUMn9RoEXzSe0ugKhZFl5zqY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Lv3NiRJud0HcFs+GeeI/bxT6/V0UjuI6PKHovZ48Sx0=;
        b=YqiiQHdebDwr0vN+q1hvk6gvjq6YDyjjIViO/pG+EJyCR0fEsvuM1vVE+XIlac0vz6
         CEXAFsaXm/2wPGlOThPQTGes18sPlG4f/ENO4pIFgnQT+olwrm5/omhnQRjFi8xIE/b5
         gUF4tmylaYHB7ifqB5f7ztGtx4fYUW+zK27m7BsJpnmrzfVnRNZFnRpwKVZ8xpx7ltD6
         P8PU33X5DBJ6C3WmeqsrILB72cjzkaOuGJ+ujSMHRS41lmNv6s8brPR2z8lpHrgChwrT
         0P3hwCq24vCibrh9zxbuffXxfQu3b8S32Yiq18xI4UsuQfVL0QRuOv7Zt/ZM2MMf0NQe
         pjIA==
X-Gm-Message-State: AOAM533LIt6JHUUFCmrVHE3aGXR3mTQOax4pv72r+bX/uX9P6M1D0n7I
        t/GbAmT6/gEPgPi8YqrJdGVHpBil/aWmaQ==
X-Google-Smtp-Source: ABdhPJwKx13qOhmbiuvCbPoBXbqhMw1UckT62LqyJW7hI/0623/KJqEteqJ8d1cxGn6bemagND0XQw==
X-Received: by 2002:a05:6638:58e:: with SMTP id a14mr6316262jar.81.1602950832854;
        Sat, 17 Oct 2020 09:07:12 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id d21sm5492919ioi.39.2020.10.17.09.07.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Oct 2020 09:07:12 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/22] 5.4.72-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20201016090437.308349327@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <09aa51ab-58ce-da78-8149-56ecd495751c@linuxfoundation.org>
Date:   Sat, 17 Oct 2020 10:07:11 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201016090437.308349327@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/16/20 3:07 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.72 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 18 Oct 2020 09:04:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.72-rc1.gz
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

