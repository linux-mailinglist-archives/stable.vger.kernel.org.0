Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8B5923B6A5
	for <lists+stable@lfdr.de>; Tue,  4 Aug 2020 10:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbgHDIQo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Aug 2020 04:16:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726788AbgHDIQn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Aug 2020 04:16:43 -0400
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 859E3C06174A
        for <stable@vger.kernel.org>; Tue,  4 Aug 2020 01:16:43 -0700 (PDT)
Received: by mail-vs1-xe43.google.com with SMTP id 1so15964335vsl.1
        for <stable@vger.kernel.org>; Tue, 04 Aug 2020 01:16:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wCMWqW/d7/QD6E2dtdDe0aa+C4q2EKOoc3JfQENrl90=;
        b=Ice+X1esOPzrUveiaMgNrCKLv+CdMsO76oudJlXVvfts/M1voomhXhqBnyYQf+18Q0
         T9cM+0Fu5x/+pyU6mBFB+xVva4ZLVIlU8UOpho54npzXbH4Idv+1T5tA9CSULC0wD+HA
         6aBRJYCnAd1RDI5esLAUfWCH1l4N1rmaqthy/a/X7zw9hOiZKRtBShOOMk2WK/VOvHao
         hDqiR8eIFxFW+xwGnMStxGIBnVEiQQLnQhFBHdAl/R1J6YC+0+HJrxdtqyqqE3yR9sIQ
         BPxQaHKcPS5akAoeNfcps6RFbkmmaw2U3w1gBqzj3bggZu3Jp33xTT5w/zr80rGySWMW
         bd6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wCMWqW/d7/QD6E2dtdDe0aa+C4q2EKOoc3JfQENrl90=;
        b=KulQ08JWGEDu3LBZox4KcacD2SSIbuRNdcLZ1QRFJAwvq8cVBPcSDXQX6caidDIJ+N
         8KA1EI+3L/XCDW5GWx5BHlPZFG/fThHiuN4L6yOyXz5sy2gwUYiva2lDkKwkwqE7cDhc
         qURpJ++k/4Tg2ZVoOAkRYGicavP0O6qIvB+Rnl4xZEQ/bfl84WW68jEgThKSfRtP0QjN
         tmB7r2qCfmViUlzT+L6G/SnRHuDhmDuvqBsRFAqNMs9xH4oIIQ2DbP1XKVtoyPUo9JOr
         WtGNRA7IJ8nbNg6Trcp/8imY8Rvr0u4KjvU5WBLZn687ZVo/j3Im+4ZFlISZ4+UhSL3A
         XPkA==
X-Gm-Message-State: AOAM532cKc4wP9lMx7hPzwYn23EyNZac8e3gVrqwWXo3+ltDLw5NYGZ6
        nnW5EepdMRiUIH/nFr9q3UiRFx4McIkQkcJHGUNbQw==
X-Google-Smtp-Source: ABdhPJzS6xK2mXcR9RdYPtTTDtS6u3uBiMOK7H6aliYB3S+V/7IPlPnwdrfQevljNk6PabUsnwwX8XkNEZxii+Bkbvs=
X-Received: by 2002:a67:e412:: with SMTP id d18mr14251253vsf.41.1596529002465;
 Tue, 04 Aug 2020 01:16:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200804072435.385370289@linuxfoundation.org>
In-Reply-To: <20200804072435.385370289@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 4 Aug 2020 13:46:31 +0530
Message-ID: <CA+G9fYs35Eiq1QFM0MOj6Y7gC=YKaiknCPgcJpJ5NMW4Y7qnYQ@mail.gmail.com>
Subject: Re: [PATCH 5.7 000/121] 5.7.13-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Will Deacon <will@kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 4 Aug 2020 at 13:03, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.7.13 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 06 Aug 2020 07:23:45 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.7.13-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.7.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

arm64 build broken.

make -sk KBUILD_BUILD_USER=3DTuxBuild -C/linux -j16 ARCH=3Darm64
CROSS_COMPILE=3Daarch64-linux-gnu- HOSTCC=3Dgcc CC=3D"sccache
aarch64-linux-gnu-gcc" O=3Dbuild Image
#
In file included from ../include/linux/smp.h:67,
                 from ../include/linux/percpu.h:7,
                 from ../include/linux/prandom.h:12,
                 from ../include/linux/random.h:118,
                 from ../arch/arm64/include/asm/pointer_auth.h:6,
                 from ../arch/arm64/include/asm/processor.h:39,
                 from ../include/linux/mutex.h:19,
                 from ../include/linux/kernfs.h:12,
                 from ../include/linux/sysfs.h:16,
                 from ../include/linux/kobject.h:20,
                 from ../include/linux/of.h:17,
                 from ../include/linux/irqdomain.h:35,
                 from ../include/linux/acpi.h:13,
                 from ../include/acpi/apei.h:9,
                 from ../include/acpi/ghes.h:5,
                 from ../include/linux/arm_sdei.h:8,
                 from ../arch/arm64/kernel/asm-offsets.c:10:
../arch/arm64/include/asm/smp.h:100:29: error: field =E2=80=98ptrauth_key=
=E2=80=99 has
incomplete type
  100 |  struct ptrauth_keys_kernel ptrauth_key;
      |                             ^~~~~~~~~~~
make[2]: *** [../scripts/Makefile.build:100:
arch/arm64/kernel/asm-offsets.s] Error 1

--=20
Linaro LKFT
https://lkft.linaro.org
