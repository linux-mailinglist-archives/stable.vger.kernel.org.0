Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF47C2B87
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 03:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727720AbfJABLj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Sep 2019 21:11:39 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:34741 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726303AbfJABLj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Sep 2019 21:11:39 -0400
Received: by mail-io1-f67.google.com with SMTP id q1so43531625ion.1
        for <stable@vger.kernel.org>; Mon, 30 Sep 2019 18:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=yp8hB/Tts3x0Mfx+GqQZEiUscl3G6Z+j7ctgB40nM2k=;
        b=XiMGyl13tRNgxDVThBQyMeQQ7e24icor+33bSiJMOVwOWmot1TtU+hChLwh9mqjq/G
         rpgxgk1LtvI/fWXFsidbQtFmASDWWppOM9Eps3/1Hy9QLEyvCyCUkNCp/eoKH8+kJiwr
         T7jf1iElCWG2vW7wF05UZBq9mlVBiTDxfdhQ6gm37h+UEXGGUcf2pnpOLm7Gk6X7VbjR
         kNQocfdYprrzPZnNpDMgV193igJEvbKshDriYHyssBi2QXSGXMCq1AMHumCuuBEhMI0L
         HuvJPZMB4z+kV1frlvS4OCwsit3PEQ0t275kL2z0/aaCz4cNNLcAp6bp+yjkymO12Cn8
         W9VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=yp8hB/Tts3x0Mfx+GqQZEiUscl3G6Z+j7ctgB40nM2k=;
        b=gDuSBLzvDWBUCsntAjenWakt1ODCW+oeXK/kDJNFIBu0PBPxHk1b0vbrWgByj/q4fw
         /a0mdmvagm//0YK9PcVNDMxtQVpnMQWujiEIpvPTDcmnltikasHKha/6FlZ5Atgd2CCF
         TYk5fY3+mmVH28T/9JST68ZfYh83WYNw4/UZdPZ/F2KaUJaRA2g5xzO1AMKmt7baZ1l0
         Ip2j4KadAHlww4TcEC+Osvelk16pVg3g89hFXfU2RMLLoGYdCBGzL2QaEfXovEjZECW3
         WzhxqUZ1HvYWdpCuurvUwZQw0jPH/9PBDBAi+fdWRPCWC0xdi2cfGlDgOFFo6eSQ9w9M
         8t3A==
X-Gm-Message-State: APjAAAVQsdoRaxCdVKHY2t16HXgfxFTwDh+I9z1sdZ9R1SKBdGrYPXs+
        oNIJEXDucLX5+2vf+w/d/kx+wTQRLQo=
X-Google-Smtp-Source: APXvYqz2+i2UkcVxbC/XWvFPYV1dsy8grc1Uv2JRRkDvv4r2bcKpnJAT+A1WVvx8rOAjhszJnuuS6w==
X-Received: by 2002:a92:9fdb:: with SMTP id z88mr24888870ilk.38.1569892298658;
        Mon, 30 Sep 2019 18:11:38 -0700 (PDT)
Received: from localhost (c-75-72-120-115.hsd1.mn.comcast.net. [75.72.120.115])
        by smtp.gmail.com with ESMTPSA id l3sm6180657ioj.7.2019.09.30.18.11.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2019 18:11:38 -0700 (PDT)
Date:   Mon, 30 Sep 2019 20:11:37 -0500
From:   Dan Rue <dan.rue@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.3 00/25] 5.3.2-stable review
Message-ID: <20191001011137.ec2ascntddpgkr2n@xps.therub.org>
Mail-Followup-To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
References: <20190929135006.127269625@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190929135006.127269625@linuxfoundation.org>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Sep 29, 2019 at 03:56:03PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.3.2 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue 01 Oct 2019 01:47:47 PM UTC.
> Anything received after that time might be too late.

Results from Linaro’s test farm.
No regressions on arm64, arm, x86_64, and i386.

Summary
------------------------------------------------------------------------

kernel: 5.3.2-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
git branch: linux-5.3.y
git commit: 5910f7ae17298c45fce24a2f314573bcb7a86284
git describe: v5.3.1-26-g5910f7ae1729
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.3-oe/build/v5.3.1-26-g5910f7ae1729

No regressions (compared to build v5.3.1)

No fixes (compared to build v5.3.1)

Ran 23295 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15
- x86

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* kselftest
* libgpiod
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-timers-tests
* perf
* spectre-meltdown-checker-test
* v4l2-compliance
* ltp-open-posix-tests
* network-basic-tests
* kvm-unit-tests
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-none
* ssuite

-- 
Linaro LKFT
https://lkft.linaro.org
