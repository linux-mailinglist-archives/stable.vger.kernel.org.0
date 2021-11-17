Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4433C4546CB
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 14:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237352AbhKQNFB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 08:05:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237224AbhKQNFA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Nov 2021 08:05:00 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 781B6C061570
        for <stable@vger.kernel.org>; Wed, 17 Nov 2021 05:02:02 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id p18so2071119plf.13
        for <stable@vger.kernel.org>; Wed, 17 Nov 2021 05:02:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hFyULO5X2dcUowPhIaJB/8P9zcL+2+kFyXZK6pO4OVw=;
        b=6Nattf4dRpueZ3MxTrurnj1LfkoL7ahmbUc0jdrE4m0FREfLOkjdk7w6QI+TlwIFrd
         zOtSZbL8KkdERAvleksqRYI2VKQyN4JdDGpdweCb/h6aGG5hPBRM8oyKLk5BPQUnrmZR
         0E9645caXibdwRn9LlAH1i1sONjFrV3L7iQ42cya8AF16hNczxfQlfrtJ+duVmjmA2AY
         hS57+B5Ys6AsrXxGwzUF+arzEcktsX4t/mr8H+1jHxUiWpaFsc0cJq2NfwH7orSgeDOx
         Jz3VrKdhRUuqm5BU4GiDlOB4fmwl0Z6D9du118I3Zajxnq/3aWjl9hl1Bq2BsXTtiZdV
         CNPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hFyULO5X2dcUowPhIaJB/8P9zcL+2+kFyXZK6pO4OVw=;
        b=ZauFKiOVBXpyeoS5RKewfahYrF1uvmyaKvMIebq2lYjASCGWw+5wlT7FSAQuoIF42P
         78nEwtUgPG1mjM2qwp0Jk0Oz6w4GQJPStr4gD0plxLuEtq45LI6MOterQWEnBxJLxks5
         t554XRVho9+Gfohq1a6MfdVYz6Z9db1fwdmUdsAzAafuzEzPGkv0QivcEpX2ATl7KKwc
         jvkyWgpe7keAfzz98mqzaLpPJGwf4pm9BuTW2KsEnrbcHBTX6w2nbzT2KYcNluiVcDjq
         6RWKZ+qRZnSTkFqvwrfIs7SVP+uNWxpEUFHFaWiVV6ddpItzQagZTTiVytT8rkaPOuhJ
         wrBw==
X-Gm-Message-State: AOAM532crzge6l+AHEQNSCm6QP+0ILtdDeJiCxzl80aoR7vJUTsI8DaV
        ObOqUOPE8F/DumBKH+hDtM7Rv+BhbOuy0SyH
X-Google-Smtp-Source: ABdhPJwf4I4iZj95T3PKopBdlqxzaT+vvHQW1g2X38XGteP6Hstd/XggQ/zpNJ23IgSB0Rx1aD85rg==
X-Received: by 2002:a17:902:d50d:b0:141:ea03:5193 with SMTP id b13-20020a170902d50d00b00141ea035193mr55196718plg.89.1637154121740;
        Wed, 17 Nov 2021 05:02:01 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p43sm11704863pfw.4.2021.11.17.05.02.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 05:02:01 -0800 (PST)
Message-ID: <6194fd49.1c69fb81.64ae3.2c26@mx.google.com>
Date:   Wed, 17 Nov 2021 05:02:01 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.292-113-gf2c0456872466
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.4 baseline: 56 runs,
 1 regressions (v4.4.292-113-gf2c0456872466)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 56 runs, 1 regressions (v4.4.292-113-gf2c0456=
872466)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.292-113-gf2c0456872466/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.292-113-gf2c0456872466
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f2c045687246661e2d280c1809fbe3b09eceae59 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6194c246eb2325037133590c

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.292-1=
13-gf2c0456872466/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.292-1=
13-gf2c0456872466/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6194c246eb23250=
37133590f
        failing since 0 day (last pass: v4.4.292-113-ge9a92f80c735, first f=
ail: v4.4.292-113-g643cfcb15c40)
        2 lines

    2021-11-17T08:49:57.122591  [   19.440063] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-17T08:49:57.166674  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/120
    2021-11-17T08:49:57.176418  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
