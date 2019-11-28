Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBA4910CC92
	for <lists+stable@lfdr.de>; Thu, 28 Nov 2019 17:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbfK1QPv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Nov 2019 11:15:51 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:42197 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726446AbfK1QPv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Nov 2019 11:15:51 -0500
Received: by mail-oi1-f195.google.com with SMTP id o12so23677039oic.9;
        Thu, 28 Nov 2019 08:15:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5Zh9VSEiy3yU9hrub2G8yPmA77KHe9sxQns9q6TzWY8=;
        b=onsMzDXejrAgu9ygoegCFEqVu8UPpO6xMvDuD175/ZckobetFQBMjzksU8W62zMnxh
         o/GHuO9e4uU65y03wuYnBVsiRrGY3bctmDqHhfR2yRZ4YVddpSdvyi1Cd6fMEvBXvvQz
         sFwX8xLUfuR6xp0DmQN3D14fVvSgdqT9/rpnku4upLpwKKF3etqTIkBbD3AcB4tkLxVg
         vOJpgRuMDc1jEzFLMBj5MG3BRb1x/X7Urovym2Hq8258+rGpYdAR1XRT64PpjQqHuHl5
         rlX5XfkLfXH2vncJKYxRMxp9VoXwuT3JMbdCnhnPMqI7Vp8gh45zbhWsb2RHZpYHUPiK
         JvqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5Zh9VSEiy3yU9hrub2G8yPmA77KHe9sxQns9q6TzWY8=;
        b=Q02fe76q5rxfy2C9CEAiiSDAkmH3DzmfuMteU2bPEsmRLBs0tSki+pFOAfTnIkAUt+
         BOx9DHCpMbn/M1va+GldjefY5YPac0geQMw+kwF070p5yKWeNrmgSaiM1lcuy/xaDWL1
         dIwySTfMw9drTy/00+vfH+LT0tmRh8GQMwcWSRPANYdG+6cMcA1ykJ62w0yI6IzrtQTJ
         p6L6d2WjdxXn+gWa0LfbU8YQtezhskA+WniQKOOM6Kk7a6VvjbphApDngKDFemZWka1T
         kZwluwNlGXCom88Rq0A5Mqtqf0Wv6n8cpItZ5vr9K5imwm1yNvUhjG3oDuQ7+XgIh6CH
         qJfQ==
X-Gm-Message-State: APjAAAX5qItDnP7GGQrFSooekmqxig2yxM8ODULYhZa+feJrcCsqhF45
        E+euGeidkpjAtY/n2jNuEgbUkrH2
X-Google-Smtp-Source: APXvYqwMCZe6pfpN5zTGL25ijLJM1pPyDJI8Hy3m+BdsHTkK5uRWVmXNMHXybtbx6cymmsxh94xgOQ==
X-Received: by 2002:a05:6808:14:: with SMTP id u20mr9023112oic.49.1574957750027;
        Thu, 28 Nov 2019 08:15:50 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q2sm385643otc.6.2019.11.28.08.15.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 28 Nov 2019 08:15:49 -0800 (PST)
Subject: Re: [PATCH 4.14 000/211] 4.14.157-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20191127203049.431810767@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <30c3292c-fd54-9e20-dc0d-4d4a457179fd@roeck-us.net>
Date:   Thu, 28 Nov 2019 08:15:47 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191127203049.431810767@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/27/19 12:28 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.157 release.
> There are 211 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 29 Nov 2019 20:18:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 172 pass: 167 fail: 5
Failed builds:
	i386:defconfig
	i386:allyesconfig
	i386:allmodconfig
	i386:allnoconfig
	i386:tinyconfig
Qemu test results:
	total: 372 pass: 347 fail: 25
Failed tests:
	<all i386>

As already reported.

Guenter
