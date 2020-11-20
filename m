Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 979162BB937
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 23:40:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728980AbgKTWkY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 17:40:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728952AbgKTWkY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Nov 2020 17:40:24 -0500
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6844C0613CF
        for <stable@vger.kernel.org>; Fri, 20 Nov 2020 14:40:23 -0800 (PST)
Received: by mail-ot1-x342.google.com with SMTP id 92so7196148otd.5
        for <stable@vger.kernel.org>; Fri, 20 Nov 2020 14:40:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rXFrinMexMjSazmjE6qCKT+I04B1JNh+fsGJr4cdoxo=;
        b=WlRAd5nd3dasEmqG0E6/tjeWyEkUdlDlNqmpR4kDHEdcdV6gmaESPZxEaEgZJYFyvf
         JSGe0/A40ZygOySqCs6UnXo5ydw7Xajhx4+TvgH4LyhRytW/GNWWsuyoexbvsobmj+I0
         jHlGGeSpi/27uwktrc/990bPn+BW49b62MUKc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rXFrinMexMjSazmjE6qCKT+I04B1JNh+fsGJr4cdoxo=;
        b=Ycijc0e7oLnkvRWSaETnhc1WM0UXfAMqUP2/vhAQCdDN/NbBimG0O5IhYZiVxAejHO
         FGAeXUjqE/S86sY8izx+BWFWMsVVk4ZXDXPWCDQ/JaZYeLHU6lOL54hkvNLEw+M+gJNe
         aSO8hlF22Eso+BY0Q7cQjZBy/Nai6zGYsIZq3LXNLGjWSnfr7weM0ubxP+1yP/H7RR9j
         +3M0JqoTNRjnriTmzLRwfWQbQJQxLATwQUZqYWZIrF7hOfjMcslVRNo51pH9mZg6B+JH
         HVfBOowrt5SLuNWCGPXBoMwVRKFks4NSYU+Yq0dmlA54zss+WN3uT/J/dZmJux5qC9UI
         KtLQ==
X-Gm-Message-State: AOAM531mo+iCpuMlp3QwdBJ9QO9yl3gf8sW4zbD31tSOIkzxjDh1yzAJ
        hjj2/HJ4PQUpQR436PI1keTKkQ==
X-Google-Smtp-Source: ABdhPJxOlavL7r2SxArO1DE7DCIsUwMLrwpxy7NoqW5IV0xpXz+9lE8bNmZUN6txQbDJf7rIkhZnvw==
X-Received: by 2002:a9d:5d15:: with SMTP id b21mr1804721oti.244.1605912023308;
        Fri, 20 Nov 2020 14:40:23 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id h8sm1833100otm.72.2020.11.20.14.40.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Nov 2020 14:40:22 -0800 (PST)
Subject: Re: [PATCH 4.4 00/15] 4.4.245-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org, skhan@linuxfoundation.org
References: <20201120104539.534424264@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <a64d0e41-7b61-d567-5563-53142c100cf2@linuxfoundation.org>
Date:   Fri, 20 Nov 2020 15:40:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <20201120104539.534424264@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/20/20 4:02 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.245 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 22 Nov 2020 10:45:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.245-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
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
