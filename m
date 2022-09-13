Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00E6D5B6C5D
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 13:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231262AbiIML2B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 07:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231875AbiIML2A (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 07:28:00 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA1503ED57
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 04:27:59 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id y17so21692240ejo.6
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 04:27:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date;
        bh=2kfENomyR5iTkrEbOZeaa/KsrgAR3ZtUsqoaTKVUpIw=;
        b=xBmHEfe72hpOSV4RtAXiDGt9aW7ss/szGSJ710A+/TFXlHAmqL+9X812At8d5CP4aF
         xhKq4vvsAScIctXjgYDr0+j1OgUlWi68N9vm9UbFq34xz52VaX7xl5Z6LZ8j5zFpuZH8
         P05cVu8gQvh/EfZdAbmPqTq2RhawRpDypL5SplI4Q99Ax1HRyI75gtjERRcfRYAo6jJ5
         IAOxgclQmtbbaodtAv6l1qRUEZLDXfy9oh3prUTc/6jSXAjn4ULb5d/XW4A9/etHgvKj
         wQyH19lDKf6cNnnK8grZpsCEKqVbU32Am+MbnT3EldIY6j8C28k82UpQqijd2sp/hYzt
         Wqcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=2kfENomyR5iTkrEbOZeaa/KsrgAR3ZtUsqoaTKVUpIw=;
        b=fRQ67GjcH5pRMAlsO8TKgYaryHPph9Lx00EJmT1CUaHwysv/bECgRjRwVB+Zan5Cds
         5payxF5k+uGwH3s0O7as3NK/MjGU6JIusoZ3gpF0CxA2TS6iOwldYtkJC7LyS8TtpDLB
         DrU0fPnN115SDkgXZY3NIq3brDbTClxEeQiYG9JHiNWmuCR3pZrsNG7RYalSIiKjPQgJ
         MCEOOh7YLf1YlfgFdpKOrBDKI3g41rOPn1lAdBOPw1Y7z6RrHNNHbWywOwq9uhwzlE8k
         WVAcwRqzarqBaejlvXHDIZBClDtZMVJJZRPyLTqNjk76L5hs4Z7KXalUatLZhiaKrOpi
         2rGw==
X-Gm-Message-State: ACgBeo39vdNks1sOisLcbqcl8CfQYxEx2s7IMDWAWcOwXkKk6GU8IezG
        LYYPwbHO2FbXgOsa08FBOq9JG8nvd0sBV/F38VWan+Un0A/K/A==
X-Google-Smtp-Source: AA6agR6ZztF4hqFdSxvKsOV85i9wrs32fY5eRSd5YIPkscrruzzc8tE3PXkdEJzDKTjlUs1EcM9PuKUKrDiCkseg8ng=
X-Received: by 2002:a17:906:fd85:b0:77b:b538:6472 with SMTP id
 xa5-20020a170906fd8500b0077bb5386472mr9557930ejb.48.1663068477294; Tue, 13
 Sep 2022 04:27:57 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 13 Sep 2022 16:57:45 +0530
Message-ID: <CA+G9fYs-K=tN=By5-ZmYw-QT196TB_h+8qLNRRhL9beMpuAKiA@mail.gmail.com>
Subject: stable-rc: 5.15: arch/arm/mach-at91/pm.c:370:52: error:
 'DDR3PHY_ZQ0SR0' undeclared (first use in this function)
To:     linux-stable <stable@vger.kernel.org>, lkft-triage@lists.linaro.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Frederic Schumacher <frederic.schumacher@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On stable-rc 5.15 arm builds failed due to following errors / warnings.

arch/arm/mach-at91/pm.c: In function 'at91_suspend_finish':
arch/arm/mach-at91/pm.c:370:52: error: 'DDR3PHY_ZQ0SR0' undeclared
(first use in this function)
  370 |                 tmp = readl(soc_pm.data.ramc_phy + DDR3PHY_ZQ0SR0);
      |                                                    ^~~~~~~~~~~~~~
include/uapi/linux/byteorder/little_endian.h:35:51: note: in
definition of macro '__le32_to_cpu'
   35 | #define __le32_to_cpu(x) ((__force __u32)(__le32)(x))
      |                                                   ^
arch/arm/include/asm/io.h:303:46: note: in expansion of macro 'readl_relaxed'
  303 | #define readl(c)                ({ u32 __v = readl_relaxed(c);
__iormb(); __v; })
      |                                              ^~~~~~~~~~~~~
arch/arm/mach-at91/pm.c:370:23: note: in expansion of macro 'readl'
  370 |                 tmp = readl(soc_pm.data.ramc_phy + DDR3PHY_ZQ0SR0);
      |                       ^~~~~
arch/arm/mach-at91/pm.c:370:52: note: each undeclared identifier is
reported only once for each function it appears in
  370 |                 tmp = readl(soc_pm.data.ramc_phy + DDR3PHY_ZQ0SR0);
      |                                                    ^~~~~~~~~~~~~~
include/uapi/linux/byteorder/little_endian.h:35:51: note: in
definition of macro '__le32_to_cpu'
   35 | #define __le32_to_cpu(x) ((__force __u32)(__le32)(x))
      |                                                   ^
arch/arm/include/asm/io.h:303:46: note: in expansion of macro 'readl_relaxed'
  303 | #define readl(c)                ({ u32 __v = readl_relaxed(c);
__iormb(); __v; })
      |                                              ^~~~~~~~~~~~~
arch/arm/mach-at91/pm.c:370:23: note: in expansion of macro 'readl'
  370 |                 tmp = readl(soc_pm.data.ramc_phy + DDR3PHY_ZQ0SR0);
      |                       ^~~~~
arch/arm/mach-at91/pm.c:373:33: error: 'DDR3PHY_ZQ0SR0_PDO_OFF'
undeclared (first use in this function)
  373 |                 index = (tmp >> DDR3PHY_ZQ0SR0_PDO_OFF) & 0x1f;
      |                                 ^~~~~~~~~~~~~~~~~~~~~~
arch/arm/mach-at91/pm.c:377:33: error: 'DDR3PHY_ZQ0SR0_PUO_OFF'
undeclared (first use in this function)
  377 |                 index = (tmp >> DDR3PHY_ZQ0SR0_PUO_OFF) & 0x1f;
      |                                 ^~~~~~~~~~~~~~~~~~~~~~
arch/arm/mach-at91/pm.c:381:33: error: 'DDR3PHY_ZQ0SR0_PDODT_OFF'
undeclared (first use in this function)
  381 |                 index = (tmp >> DDR3PHY_ZQ0SR0_PDODT_OFF) & 0x1f;
      |                                 ^~~~~~~~~~~~~~~~~~~~~~~~
arch/arm/mach-at91/pm.c:385:33: error: 'DDR3PHY_ZQ0SRO_PUODT_OFF'
undeclared (first use in this function)
  385 |                 index = (tmp >> DDR3PHY_ZQ0SRO_PUODT_OFF) & 0x1f;
      |                                 ^~~~~~~~~~~~~~~~~~~~~~~~
make[2]: *** [scripts/Makefile.build:289: arch/arm/mach-at91/pm.o] Error 1

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Build link:
 - https://builds.tuxbuild.com/2EfrKWiY7k1znh1Nt7nFQmRuyRc/

# To install tuxmake on your system globally:
# sudo pip3 install -U tuxmake
#

tuxmake --runtime podman --target-arch arm --toolchain gcc-11
--kconfig at91_dt_defconfig

Following patch seems to be causing these build failures on stable-rc 5.15.
---
ARM: at91: pm: fix DDR recalibration when resuming from backup and self-refresh
[ Upstream commit 7a94b83a7dc551607b6c4400df29151e6a951f07 ]

On SAMA7G5, when resuming from backup and self-refresh, the bootloader
performs DDR PHY recalibration by restoring the value of ZQ0SR0 (stored
in RAM by Linux before going to backup and self-refresh). It has been
discovered that the current procedure doesn't work for all possible values
that might go to ZQ0SR0 due to hardware bug. The workaround to this is to
avoid storing some values in ZQ0SR0. Thus Linux will read the ZQ0SR0
register and cache its value in RAM after processing it (using
modified_gray_code array). The bootloader will restore the processed value.

Fixes: d2d4716d8384 ("ARM: at91: pm: save ddr phy calibration data to securam")
Suggested-by: Frederic Schumacher <frederic.schumacher@microchip.com>
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20220826083927.3107272-4-claudiu.beznea@microchip.com
Signed-off-by: Sasha Levin <sashal@kernel.org>



--
Linaro LKFT
https://lkft.linaro.org
