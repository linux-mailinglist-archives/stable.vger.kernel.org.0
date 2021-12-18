Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46756479B1C
	for <lists+stable@lfdr.de>; Sat, 18 Dec 2021 14:58:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233278AbhLRN64 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Dec 2021 08:58:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbhLRN6z (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Dec 2021 08:58:55 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A08F5C061574
        for <stable@vger.kernel.org>; Sat, 18 Dec 2021 05:58:55 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id a11-20020a17090a854b00b001b11aae38d6so5584358pjw.2
        for <stable@vger.kernel.org>; Sat, 18 Dec 2021 05:58:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LixzVCEQF1C6cgyPk4547aKQepk3kWIkpy/K9z2AnEs=;
        b=ATzOI6fIwtCYAr4edjwPuRwWZrcoxWENqA2jGbBGnBHs8KWhfYpEXmqOOn9znU87l5
         vGLQfO5kT8nN1QpIChFLFnhWFbTubKzgAbc+2LZomQYmbKsAEuBIc0lXHbeqtXFjLZWP
         MA0yzJ1GTiUFEqxsbALkgpP5i9rEQi/oEZ0K7pyK2RRl+UgUoYwJy9a6DkwaLIZSQ7j4
         O9xGCUOG/rfRHIHIuhg9/RjbURwNR43ePlSUCsiLDQTmp6MBPSrluMModVA0sKDvryXJ
         o5KPrNHl+31dgxaKK7IawMUHlpSo4pyGzOu+F3o0atbMVhIaSOGPypGt7jnb/iRgzk7D
         jyfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LixzVCEQF1C6cgyPk4547aKQepk3kWIkpy/K9z2AnEs=;
        b=ed0V0O7in5VAlEnSfR80G9GItV8yj/Hmphguqf8Wbq0xKAVV47RLKmzEenezxXfrFg
         XO36yevEzL6KjlKHhz/JHCkEnWZ34qHo+O4P8dX3ZT2n7/HcubaQJANAkpwy6zgg6P9B
         NSHjjMSWNvXSgfssyCO45BNlxHlWytfEfrMgXt7v/1dPTFMTLjxyo/NwBpVFcrDGoDQu
         larbKvpuebeJPGDmiVVKeKrQnlEXvoSeLghDXCIa7BUpyhrQcCsPw1va0e5MZWlB2ho4
         lJ8jb9I80CnlYoIDz72ooQCxZchf15YS/DIIXH4V41hYEs7XPMdM+PE3meqzM4Kk/Fxa
         45ZQ==
X-Gm-Message-State: AOAM532vVGW/UF86ZjiWdfLcRD8mMPfFwbOhBuF5TcuTwEL7kMr+r7gi
        W2B6XJr8/553kF7m6YBQNX7/ZPS/GBjvyzxk
X-Google-Smtp-Source: ABdhPJwJx7RzOt6OvUF9i/grGWvl6GTaT2QTbUZ1Ytkrc2sKvHXXKC/peC58JMqr8kA3EClTtyahgg==
X-Received: by 2002:a17:902:f544:b0:148:a2e8:2773 with SMTP id h4-20020a170902f54400b00148a2e82773mr7816738plf.122.1639835934551;
        Sat, 18 Dec 2021 05:58:54 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v13sm14090363pfu.38.2021.12.18.05.58.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Dec 2021 05:58:54 -0800 (PST)
Message-ID: <61bde91e.1c69fb81.2e345.53d2@mx.google.com>
Date:   Sat, 18 Dec 2021 05:58:54 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.293-11-g717774ccabbc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 132 runs,
 2 regressions (v4.9.293-11-g717774ccabbc)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 132 runs, 2 regressions (v4.9.293-11-g717774c=
cabbc)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig          | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.293-11-g717774ccabbc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.293-11-g717774ccabbc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      717774ccabbc5543e252f800e29d288e4c17711e =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61bdb6b675752c2a85397150

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.293-1=
1-g717774ccabbc/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-minnowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.293-1=
1-g717774ccabbc/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-minnowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61bdb6b675752c2a85397=
151
        new failure (last pass: v4.9.293-7-g5494b85558f4) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/61bdb8b34bd136d4e539713e

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.293-1=
1-g717774ccabbc/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.293-1=
1-g717774ccabbc/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61bdb8b34bd136d=
4e5397143
        failing since 1 day (last pass: v4.9.293-7-gd89b8545a1fa, first fai=
l: v4.9.293-7-g534f383585ec)
        2 lines

    2021-12-18T10:32:01.354433  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/124
    2021-12-18T10:32:01.363855  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
