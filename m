Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C211259EF5
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 21:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729055AbgIATJY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 15:09:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726107AbgIATJX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Sep 2020 15:09:23 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7C40C061244;
        Tue,  1 Sep 2020 12:09:21 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id gf14so1036615pjb.5;
        Tue, 01 Sep 2020 12:09:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Omnb0d0gIRmcYRZt3fhQq4f2pv4EkvShvamaZBFx4EY=;
        b=CCT/eiAJnV891jqG/WV7Go1fkkjFdkAXr0RWWUrO80f9IQIdEW6roYmLQdeut3ro0y
         FGTObufOrXfdbr4AsgzhkbO4Fs578rxzp/o5KgGPG7Pjz6+/ABNhGnQZwnLdVeaU4h0C
         CJN8skPNCCLT6ZeraKBW61rVW7TqHSZE2mkYfgWVWPK6ufwdS0fplbuhEAze7AxNEz1Q
         RNmvTAGbycfV9ij5Xwv5nk3tA8pMF6TUcZmfF7UW4FAJpGZc807Y3A7+eQqtr6tc0ljt
         il1oeJH6R66cHvqLz4D56Mllv67HD0U0pRxq4gGEMafgiyixD5zS2mG40ztYvP8xiMAr
         U8GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Omnb0d0gIRmcYRZt3fhQq4f2pv4EkvShvamaZBFx4EY=;
        b=AIiYDw8baSPztDkzYtcFblMMLB69GJaFUq954Znq1OpwbuOnAAJHBIWPhesvjSEZao
         LY4PNp+MLOWLsLskrcMUjiNObQTxipLwzsE+eLJEzB1/bC6ViRQxQGozqT2WEj5aTlTI
         Pd4NpF+LQu/gCUhRdZ6/DCWUC10UGmTq10D4C5+ep6/TrO5pTI3sVlheSl7rVWGfIzpR
         XttU2MxyVB9RQLlltMtmF1bLaF41wGs6qD2M3FN7bx++TArPWLzGe+HXP2iXIimJEUMl
         pGk625nYJHaIJpCFtJ8rj1bsU+l+k3mzAUdOvsCjp5Gc8QJBIbjPYOCeFwwl4NRzAtWp
         kQGA==
X-Gm-Message-State: AOAM533PAZFsaoTcsPNykAwYUxCatC3osisMplz8nL/49UA1J39km6ai
        eH5R5jT/gDo+E/9EO7i4kB+XDexEY5A=
X-Google-Smtp-Source: ABdhPJyv+76L/nc+Y+zE3Gy0H3/Hmxl6EeTKpsQxreQcjh0o5syqup+/fL1u64ZwDsvNceVXY119jw==
X-Received: by 2002:a17:902:7048:: with SMTP id h8mr2634478plt.225.1598987361152;
        Tue, 01 Sep 2020 12:09:21 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n24sm2941230pgk.59.2020.09.01.12.09.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2020 12:09:20 -0700 (PDT)
Subject: Re: [PATCH 5.4 000/214] 5.4.62-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20200901150952.963606936@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
Message-ID: <694f63b6-c5a0-f434-5212-27f1cb7b5f2a@roeck-us.net>
Date:   Tue, 1 Sep 2020 12:09:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/1/20 8:08 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.62 release.
> There are 214 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 03 Sep 2020 15:09:01 +0000.
> Anything received after that time might be too late.
> 

Building x86_64:tools/perf ... failed
--------------
Error log:
Warning: Kernel ABI header at 'tools/include/uapi/linux/kvm.h' differs from latest version at 'include/uapi/linux/kvm.h'
Warning: Kernel ABI header at 'tools/include/uapi/linux/sched.h' differs from latest version at 'include/uapi/linux/sched.h'
Warning: Kernel ABI header at 'tools/arch/x86/include/asm/cpufeatures.h' differs from latest version at 'arch/x86/include/asm/cpufeatures.h'
Warning: Kernel ABI header at 'tools/arch/x86/include/uapi/asm/unistd.h' differs from latest version at 'arch/x86/include/uapi/asm/unistd.h'
Makefile.config:846: No libcap found, disables capability support, please install libcap-devel/libcap-dev
Makefile.config:958: No openjdk development package found, please install JDK package, e.g. openjdk-8-jdk, java-1.8.0-openjdk-devel
  PERF_VERSION = 5.4.61.gf5583dd12e6f
In file included from btf_dump.c:16:0:
btf_dump.c: In function ‘btf_align_of’:
tools/include/linux/kernel.h:53:17: error: comparison of distinct pointer types lacks a cast [-Werror]
  (void) (&_min1 == &_min2);  \
                 ^
btf_dump.c:770:10: note: in expansion of macro ‘min’
   return min(sizeof(void *), t->size);
          ^~~
cc1: all warnings being treated as errors
make[7]: *** [/tmp/buildbot-builddir/tools/perf/staticobjs/btf_dump.o] Error 1

Bisect log below. Reverting the following two patches fixes the problem.

497ef945f327 libbpf: Fix build on ppc64le architecture
401834f55ce7 libbpf: Handle GCC built-in types for Arm NEON

Guenter

---
$ git bisect log
# bad: [f5583dd12e6fc8a3c11ae732f38bce8334e150a2] Linux 5.4.62-rc1
# good: [6576d69aac94cd8409636dfa86e0df39facdf0d2] Linux 5.4.61
git bisect start 'HEAD' 'v5.4.61'
# good: [6c747bd0794c982b500bda7334ef55d9dabb6cc6] nvme-fc: Fix wrong return value in __nvme_fc_init_request()
git bisect good 6c747bd0794c982b500bda7334ef55d9dabb6cc6
# bad: [81b5698e6d9ecdc9569df8f4b93be70d587f5ddf] serial: samsung: Removes the IRQ not found warning
git bisect bad 81b5698e6d9ecdc9569df8f4b93be70d587f5ddf
# bad: [973679736caa8e1b39b68866535bdc7899a46f25] ASoC: wm8994: Avoid attempts to read unreadable registers
git bisect bad 973679736caa8e1b39b68866535bdc7899a46f25
# good: [1789df2a787c589dbe83bc3ed52af2abbc739d1b] ext4: correctly restore system zone info when remount fails
git bisect good 1789df2a787c589dbe83bc3ed52af2abbc739d1b
# good: [ba1fb0301a60cbded377e0f312c82847415a1820] drm/amd/powerplay: correct UVD/VCE PG state on custom pptable uploading
git bisect good ba1fb0301a60cbded377e0f312c82847415a1820
# bad: [1ef070d29e73a50e98a93d9a68f69cfef4247170] netfilter: avoid ipv6 -> nf_defrag_ipv6 module dependency
git bisect bad 1ef070d29e73a50e98a93d9a68f69cfef4247170
# bad: [401834f55ce7f86bf2c0f8fdd8fbf9e1baf19f1c] libbpf: Handle GCC built-in types for Arm NEON
git bisect bad 401834f55ce7f86bf2c0f8fdd8fbf9e1baf19f1c
# good: [ccb6e88cd42a9cb65bde705f7f8e7c9822dcb711] drm/amd/display: Switch to immediate mode for updating infopackets
git bisect good ccb6e88cd42a9cb65bde705f7f8e7c9822dcb711
# first bad commit: [401834f55ce7f86bf2c0f8fdd8fbf9e1baf19f1c] libbpf: Handle GCC built-in types for Arm NEON
