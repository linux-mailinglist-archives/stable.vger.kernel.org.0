Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 694DDA9904
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 05:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728072AbfIEDsL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 23:48:11 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:38218 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727544AbfIEDsL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Sep 2019 23:48:11 -0400
Received: by mail-pl1-f194.google.com with SMTP id w11so614457plp.5;
        Wed, 04 Sep 2019 20:48:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pYD81YFETvqhhEH9qUnNjLJMdHyZTdj4QK4cZ/lMPek=;
        b=cD9evuKSB0BVKnX+c/uRW7iufFoxlxduxxpDz+f9NBHVsiqDEJspt0hff3P45fewet
         Mvv4AvSJu8jTEl17jBBGAthlsQiI+iEUi1XabZXilivfmP0iBRs5iAuDC5VAI3SxZhlz
         SJ5NXFYQe8l3eOK/JHtvkkxE3f3dl9rf3HFzoJw8uxRAMV5hf0t8bwnnLSUVCpf2VAxy
         b10LCaE+fa9TyhMCgHGccPNC85HWevmIZyidPiEkRR6chPQaYsSsbTddyApkCcKE916S
         a9fBHSWiIG0BLAim13j65hlCKyeJq2n0NDpCoiBjGLgLMYmd2DeR56eXiJT8dZ3ENR/l
         sfSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pYD81YFETvqhhEH9qUnNjLJMdHyZTdj4QK4cZ/lMPek=;
        b=ob8RkVn4sybyjMd8NwbsvljrI0rqeZpiByuj/ZyRpFsVgUJ8YHi0rfiBFoR4W7k9Vk
         1jzZPPmjmzT4PnaI6kiTff7L37zHHYV9jalIh8fv0jh2Emo2LHxKsk9uk4lLru8OXQk4
         yogH2ub2KM/EuB0ZnnKU5ooU7QYIv9x6/TX9IsJ/QeQL/nFG8OoGl4sEdjCSm56x+qMi
         0rVHko3BFJBjqRVqdfCKb2gIPuEIxpCC3kB/OVEbLtTxGLicMBsL75W3NwaaHXRVcacI
         /ljX1YsTEoI02gkSk6sPM4OaGRO62xCUmBUde87U/XHQCdsgr+XX2z8JDiQ0uHPjfvd9
         /JCg==
X-Gm-Message-State: APjAAAW2BK6THR/krcOyPx84+xj5Z0FEEA+4WS6Ro4pbrTRh0+p9grGs
        Z3KJvR6RXI9YyG46fpvsr63uhor/
X-Google-Smtp-Source: APXvYqyMZZOXqSmlc1OTz0H0TSwBXgj90khqnhvRX5Qm0n1heW9gb0v8FZ6pCLzJK16qvpck85r6RQ==
X-Received: by 2002:a17:902:7892:: with SMTP id q18mr1127950pll.206.1567655290351;
        Wed, 04 Sep 2019 20:48:10 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z12sm442165pjp.11.2019.09.04.20.48.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Sep 2019 20:48:09 -0700 (PDT)
Subject: Re: [PATCH 4.14 00/57] 4.14.142-stable review
To:     Kevin Hilman <khilman@baylibre.com>,
        "kernelci.org bot" <bot@kernelci.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20190904175301.777414715@linuxfoundation.org>
 <5d705444.1c69fb81.c4927.1cd1@mx.google.com> <7hlfv3shk0.fsf@baylibre.com>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <6b9adb14-47ec-cd94-d2a2-c79d22d43d76@roeck-us.net>
Date:   Wed, 4 Sep 2019 20:48:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <7hlfv3shk0.fsf@baylibre.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/4/19 5:38 PM, Kevin Hilman wrote:
> "kernelci.org bot" <bot@kernelci.org> writes:
> 
>> stable-rc/linux-4.14.y boot: 144 boots: 5 failed, 131 passed with 8 offline (v4.14.141-58-g39a17ab1edd4)
>>
>> Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux-4.14.y/kernel/v4.14.141-58-g39a17ab1edd4/
>> Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.y/kernel/v4.14.141-58-g39a17ab1edd4/
>>
>> Tree: stable-rc
>> Branch: linux-4.14.y
>> Git Describe: v4.14.141-58-g39a17ab1edd4
>> Git Commit: 39a17ab1edd4adb3fb732726a36cb54a21cc570d
>> Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>> Tested: 68 unique boards, 23 SoC families, 14 builds out of 201
>>
>> Boot Failures Detected:
>>
>> arm:
>>      vexpress_defconfig:
>>          gcc-8:
>>              qemu_arm-virt-gicv3: 5 failed labs
> 
> All 5 failures are for this same QEMU target in multiple labs
> 
> It is also failing in linux-next and on several other stable versions.
> 

linux-next is in bad shape due to some usb issues, but I am not sure otherwise.
I ran a quick test on 4.14.y-queue, and all my (arm, arm64) qemu tests are fine.

Is it possible that this is a new or modified test ?

Guenter
