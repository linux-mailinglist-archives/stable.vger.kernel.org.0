Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3E2E72A3
	for <lists+stable@lfdr.de>; Mon, 28 Oct 2019 14:32:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729801AbfJ1NcS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Oct 2019 09:32:18 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:46708 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726833AbfJ1NcS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Oct 2019 09:32:18 -0400
Received: by mail-pl1-f194.google.com with SMTP id q21so5567463plr.13;
        Mon, 28 Oct 2019 06:32:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jzGVsB0UJfBwXjcHkSR9JlWipf5GTI/JmsMDtEyAZz8=;
        b=EH3S6FL2h21cxrOfgq+ECDzyloePyt03cKtKFT5gXdkun3Vj7fnDp3d+LLH2lq005p
         CQ8VxjJSwTqHH2M/ZdcEqheDXmCCkJHEbBHE8ScbblniO57be/Q4aYbootjSci3MN+ls
         wFnvjFppNIB3MD6CfEiPF0cwusnJC2SXT0fZjUr9ounl4t0WluhkXhl2zqDxuuYi6KWX
         4lw+EFbBOKxb7psLdaWnMltLursxdTwfHgK2s5ydDmfdiDtLAdEGNva0dUzcuCZZf9qu
         8IVk+WuL6/AefOqA4ST25sQv44iGXTptvsWbLiQHHTg1Oq85MjSIuxygtu7OLQxawUCO
         kOuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jzGVsB0UJfBwXjcHkSR9JlWipf5GTI/JmsMDtEyAZz8=;
        b=jgZgRrWuoJYw0pnCam9XFcBcc3aQgBoiB3Bw3ggG6A2Sf8zEh/tX6/ebh2zddLekEC
         Dzdhns9P2yp4NU+zpoifbDdsl7bB5meqrUTP/L582aEemlhoc6ds9TwGuJN7WzXriecc
         T9e0EtF4KMnHYKliZHzFtKPLj14inujB1q1IBoK4ZZ+u1g7yHXcCtaksq17eSO2yUNUJ
         0gA+0d0D+LQ3uz5gwOv7Xi/Fc7W9OMbtyZb6JOQDzxjFrcajiAWntjKv5pLOaQdVLTvS
         IQTWDvF61UlNQMW69kT0g7byXRi+ZlH57YlrEUG3ktFtuI8fDykG7/Cj9RNxgMFHC43B
         0Pbw==
X-Gm-Message-State: APjAAAXjXwNpFjfggVOpSEgjKnYX0q8y4Qly4L3BBZqBA+f/GgkMEH0E
        J0jo2Hy/sysP8XVk1XY1y2xUc2jr
X-Google-Smtp-Source: APXvYqzaGRWQNNrZP6cMIRblOQpSYCTDi7d7afqFwNXzYj1sT9dkVg1jN9eobSQmpNuX6N5noUSHLg==
X-Received: by 2002:a17:902:7b91:: with SMTP id w17mr17877578pll.275.1572269536856;
        Mon, 28 Oct 2019 06:32:16 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k32sm10384840pje.10.2019.10.28.06.32.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Oct 2019 06:32:16 -0700 (PDT)
Subject: Re: [PATCH 4.4 00/41] 4.4.198-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20191027203056.220821342@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <3961082b-17bc-cef7-f0e5-7bf029b2de2a@roeck-us.net>
Date:   Mon, 28 Oct 2019 06:32:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191027203056.220821342@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/27/19 2:00 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.198 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue 29 Oct 2019 08:27:02 PM UTC.
> Anything received after that time might be too late.
> 


Building mips:defconfig ... failed
--------------
Error log:
In file included from /opt/buildbot/slave/stable-queue-4.9/build/arch/mips/include/asm/bitops.h:21,
                  from /opt/buildbot/slave/stable-queue-4.9/build/include/linux/bitops.h:17,
                  from /opt/buildbot/slave/stable-queue-4.9/build/include/linux/kernel.h:10,
                  from /opt/buildbot/slave/stable-queue-4.9/build/arch/mips/kernel/cpu-probe.c:15:
/opt/buildbot/slave/stable-queue-4.9/build/arch/mips/kernel/cpu-probe.c: In function 'cpu_probe':
/opt/buildbot/slave/stable-queue-4.9/build/arch/mips/include/asm/cpu-features.h:349:31: error: implicit declaration of function '__ase' [-Werror=implicit-function-declaration]
   349 | #define cpu_has_loongson_mmi  __ase(MIPS_ASE_LOONGSON_MMI)
       |                               ^~~~~
/opt/buildbot/slave/stable-queue-4.9/build/arch/mips/kernel/cpu-probe.c:2079:6: note: in expansion of macro 'cpu_has_loongson_mmi'
  2079 |  if (cpu_has_loongson_mmi)
       |      ^~~~~~~~~~~~~~~~~~~~
/opt/buildbot/slave/stable-queue-4.9/build/arch/mips/kernel/cpu-probe.c:2083:16: error: 'HWCAP_LOONGSON_CAM' undeclared (first use in this function); did you mean 'HWCAP_LOONGSON_EXT'?
  2083 |   elf_hwcap |= HWCAP_LOONGSON_CAM;
       |                ^~~~~~~~~~~~~~~~~~
       |                HWCAP_LOONGSON_EXT
/opt/buildbot/slave/stable-queue-4.9/build/arch/mips/kernel/cpu-probe.c:2083:16: note: each undeclared identifier is reported only once for each function it appears in


Affects all mips builds in v{4.4, 4.9, 4.14}.

Guenter
