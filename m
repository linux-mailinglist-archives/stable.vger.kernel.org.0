Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29AD232AEC9
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235794AbhCCAFm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:05:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344090AbhCBFQp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 00:16:45 -0500
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B6FDC061797
        for <stable@vger.kernel.org>; Mon,  1 Mar 2021 21:16:04 -0800 (PST)
Received: by mail-oi1-x231.google.com with SMTP id o3so20763412oic.8
        for <stable@vger.kernel.org>; Mon, 01 Mar 2021 21:16:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=Gzm0zEheMSszyinNhmGqqUS/Nr58XxyY0cqmg7USJpo=;
        b=irCO2CrrVT53hQWJvP+225Lla8q0JWBpQI6uuxdEz9lhoGryEpY7fe3Um9obf5K8nR
         /oyUd3w9esgNM1I0+doSq8k+6/B1fO1C8rlyAfyPmt+ixL1Qpr5TEr/VGUh7qYFQz+Gz
         JgNGF23J+5ZA3tFyzGXbnIi+EhGQdmJF8/GuI1ST1p5kCEb2DVJ03PBQyo/dTY3WAipZ
         j/gtfmuQWbzttALtEYvQbhanaGSq9Iu/6+u653kAdU3Sddvgzx6EZEtmJtjDlP7Bdyfw
         g038S3OCPbl6qYoEjww3+j9mSRfEtFebdiF7JyESK6+cqZnQIZs5JykwA+IebTC8lhzz
         ET1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=Gzm0zEheMSszyinNhmGqqUS/Nr58XxyY0cqmg7USJpo=;
        b=eYsCRaFlfVK37DQWpSuxf/EKDG/urAbYigyz0iJ3rf5xG7/pq3cNZgWGdotyHuH7WG
         ZAKC3n/aA/9jxxFoGKeFRbo9A2DCEfbcA4wq0iEljoim1l3+crR/JV5rDfvN63ErRGL6
         JV3NqsyMptMjBou9gwPIgM7fIaokJvXnZavJ2xiVfrpxR/bQ1loyyx6DHDZWeSs7+8Uk
         4h1B2wzyQT9etWmnJqeFwgxznKQicAFmliKwWpAGgwJCbydGL2UqOw9/Cml/YGc61K+G
         UcPtpJKG11TRWIUvhh3WHUAPBhIRE944Kafc+NsbJBwbKeOyaI6fi19YBpPvLqeK2fl+
         e3FA==
X-Gm-Message-State: AOAM532XfVTTpGyNVNkzdRIpMEbSss1Uxn+BGwmZ+1SJ55YfrXn2sN/+
        KyUcNxIOfCrtTGgSdwNYB/E9JiZKd/79QP9XKUdXmQ==
X-Google-Smtp-Source: ABdhPJx1orLxbk5AcwKD+Ifgjh9hj29WR7N9Qrf2vznZ2P1s/oJuAZdQvb9lT1a8rjg2qhGUUOVV4yBGUO6styG6+tE=
X-Received: by 2002:a05:6808:130d:: with SMTP id y13mr1990083oiv.167.1614662163626;
 Mon, 01 Mar 2021 21:16:03 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 2 Mar 2021 10:45:52 +0530
Message-ID: <CA+G9fYspCgCU3qggbXDUGm50_gK3S+LuNTO3BzvszGbhm3fcUA@mail.gmail.com>
Subject: icmpv6.h:70:2: error: implicit declaration of function
 '__icmpv6_send'; did you mean 'icmpv6_send'? [-Werror=implicit-function-declaration]
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     linux-stable <stable@vger.kernel.org>, SinYu <liuxyon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>, lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Stable rc builds failed on arm64, arm, arc, mips, parisc, ppc, riscv,
sh, s390 and x86_64.
Build failed branches list:
  - Stable-rc Linux 5.4.102-rc2
  - Stable-rc Linux 4.19.178-rc2
  - Stable-rc Linux 4.14.223-rc2
  - Stable-rc Linux 4.9.259-rc1

Failed build set list:
  - arm64 (allnoconfig) with gcc-8, gcc-9 and gcc-10
  - arm64 (tinyconfig) with gcc-8, gcc-9 and gcc-10
  <many>
  - x86_64 (allnoconfig) with gcc-8, gcc-9 and gcc-10
  - x86_64 (tinyconfig) with gcc-8, gcc-9 and gcc-10

# to reproduce this build locally:

tuxmake --target-arch=arm64 --kconfig=allnoconfig --toolchain=gcc-9
--wrapper=sccache --environment=SCCACHE_BUCKET=sccache.tuxbuild.com
--runtime=podman --image=public.ecr.aws/tuxmake/arm64_gcc-9 config
default kernel xipkernel modules dtbs dtbs-legacy debugkernel

make --silent --keep-going --jobs=8
O=/home/tuxbuild/.cache/tuxmake/builds/1/tmp ARCH=arm64
CROSS_COMPILE=aarch64-linux-gnu- 'CC=sccache aarch64-linux-gnu-gcc'
'HOSTCC=sccache gcc' allnoconfig
make --silent --keep-going --jobs=8
O=/home/tuxbuild/.cache/tuxmake/builds/1/tmp ARCH=arm64
CROSS_COMPILE=aarch64-linux-gnu- 'CC=sccache aarch64-linux-gnu-gcc'
'HOSTCC=sccache gcc'
In file included from include/net/ndisc.h:53,
                 from include/net/ipv6.h:18,
                 from include/linux/sunrpc/clnt.h:28,
                 from include/linux/nfs_fs.h:32,
                 from init/do_mounts.c:23:
include/linux/icmpv6.h: In function 'icmpv6_ndo_send':
include/linux/icmpv6.h:70:2: error: implicit declaration of function
'__icmpv6_send'; did you mean 'icmpv6_send'?
[-Werror=implicit-function-declaration]
   70 |  __icmpv6_send(skb_in, type, code, info, &parm);
      |  ^~~~~~~~~~~~~
      |  icmpv6_send
cc1: some warnings being treated as errors
make[2]: *** [scripts/Makefile.build:261: init/do_mounts.o] Error 1

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>

Build log link,
https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc/-/jobs/1064182703#L61
https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc/-/jobs/1064593353#L62

--
Linaro LKFT
https://lkft.linaro.org
