Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F00AC13CF7
	for <lists+stable@lfdr.de>; Sun,  5 May 2019 05:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727253AbfEEDbk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 May 2019 23:31:40 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34505 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726524AbfEEDbk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 May 2019 23:31:40 -0400
Received: by mail-pg1-f194.google.com with SMTP id c13so4726278pgt.1;
        Sat, 04 May 2019 20:31:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zkpxz+bEVJim4pTUs/VL14wDtnfj/pMmqSrNj8K7mhg=;
        b=bNSaL0iUEkpv/cfyuXJBFxaS+pwPz5m6gm04nrZ4dKHfuNqANXIwiWIUAnqY/YOjyK
         DfwdwpinZJao09utvZS8sN+PLV7Bmpk9KXvg/z9spovwImGoJGhrEXT01nDl44Vr+5Ec
         zToqvcRsJ1DKMe/u4vJoG2v23hUUrWfmn10yTdoBzXos2zFQZHkDIDZ1MXv7FQzTspJW
         D+AfmZURVuOp7E3F3dprACtAG5StMi+XlC3FLoP0St1qAYQbY/P/4quq8jHRbLfZeS8T
         /nXvtcwA9XSM1Iud7xABryx1i5ASq88feG7eCV1nF9miKPhg4qXIXtG7fJJg+jM3GTTw
         WtUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zkpxz+bEVJim4pTUs/VL14wDtnfj/pMmqSrNj8K7mhg=;
        b=RH1iXs4yvcdM7t7Ix/p1YTuC/t7BC9qb2ZL2Yz1tQw6/OIVnOQNNcn2D2KqEwPJwSe
         u14fpqE/m0sgRCZ8pG0DdFrpbAaDGRhV+N+LkIPZDhA+0dFoquP7ZDxQsebkOoBhCYJz
         8QtOZ9fxlVLouioKI4KXsWPAmoq4ZV6wFM6sapx24X+K4we8y8/9xHF6zfgy/6TQNrJb
         7XaSm+ikyhH8q/zI/Mnjx3Qa2ekFeXCQ6vHVx6zVsI7gDyVdvnpJvNpQ1uuPRVBkBUBz
         pg91sDWrvhgmHqWFQwfROuAkijYCU9AHGVvENRsCos0zzCeRzSQGlHz9o0nM79mycp+4
         EFfw==
X-Gm-Message-State: APjAAAU2vYXCJ+tn2L92777xk+2awfD7fmPgNZqGiiPUxrloa4AHieKA
        kRg0brsRPP07g2NdcvGhFvDHeOX2
X-Google-Smtp-Source: APXvYqxXgktIUMCC3hbPZMaqaPBL/9R6BJGeXpDugLmJfMUqqyiJd5f/vi3BLd9J2nLIhsrkqLbEgw==
X-Received: by 2002:a63:750c:: with SMTP id q12mr22629407pgc.133.1557027099550;
        Sat, 04 May 2019 20:31:39 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j6sm8379049pfe.107.2019.05.04.20.31.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 20:31:38 -0700 (PDT)
Subject: Re: [PATCH 5.0 00/32] 5.0.13-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20190504102452.523724210@linuxfoundation.org>
 <20190505030515.txopqluki6mc2px2@xps.therub.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <4913833a-5b46-20d0-4dce-3e6d46a7a498@roeck-us.net>
Date:   Sat, 4 May 2019 20:31:36 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190505030515.txopqluki6mc2px2@xps.therub.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/4/19 8:05 PM, Dan Rue wrote:
> On Sat, May 04, 2019 at 12:24:45PM +0200, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 5.0.13 release.
>> There are 32 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Mon 06 May 2019 10:24:23 AM UTC.
>> Anything received after that time might be too late.
> 
> Results from Linaro’s test farm.
> Regressions detected.
> 

Confusing. What are the regressions ? Below it says that there are none.

Guenter

> Summary
> ------------------------------------------------------------------------
> 
> kernel: 5.0.13-rc1
> git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> git branch: linux-5.0.y
> git commit: c6bd3efdcefd68cc590853c50594a9fc971d93cd
> git describe: v5.0.12-33-gc6bd3efdcefd
> Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.0-oe/build/v5.0.12-33-gc6bd3efdcefd
> 
> No regressions (compared to build v5.0.11-102-g17f93022a8c9)
> 
> No fixes (compared to build v5.0.11-102-g17f93022a8c9)
> 
> Ran 25060 total tests in the following environments and test suites.
> 
> Environments
> --------------
> - dragonboard-410c
> - hi6220-hikey
> - i386
> - juno-r2
> - qemu_arm
> - qemu_arm64
> - qemu_i386
> - qemu_x86_64
> - x15
> - x86
> 
> Test Suites
> -----------
> * build
> * install-android-platform-tools-r2600
> * kselftest
> * libgpiod
> * libhugetlbfs
> * ltp-cap_bounds-tests
> * ltp-commands-tests
> * ltp-containers-tests
> * ltp-cpuhotplug-tests
> * ltp-cve-tests
> * ltp-dio-tests
> * ltp-fcntl-locktests-tests
> * ltp-filecaps-tests
> * ltp-fs_bind-tests
> * ltp-fs_perms_simple-tests
> * ltp-fsx-tests
> * ltp-hugetlb-tests
> * ltp-io-tests
> * ltp-ipc-tests
> * ltp-math-tests
> * ltp-mm-tests
> * ltp-nptl-tests
> * ltp-pty-tests
> * ltp-sched-tests
> * ltp-securebits-tests
> * ltp-syscalls-tests
> * ltp-timers-tests
> * perf
> * spectre-meltdown-checker-test
> * v4l2-compliance
> * kvm-unit-tests
> * ltp-fs-tests
> * ltp-open-posix-tests
> * kselftest-vsyscall-mode-native
> * kselftest-vsyscall-mode-none
> 

