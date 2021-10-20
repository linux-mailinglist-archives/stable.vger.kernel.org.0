Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 855FA435678
	for <lists+stable@lfdr.de>; Thu, 21 Oct 2021 01:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbhJTX0n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 19:26:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbhJTX0m (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Oct 2021 19:26:42 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7B18C06161C
        for <stable@vger.kernel.org>; Wed, 20 Oct 2021 16:24:27 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id c4so16840846pgv.11
        for <stable@vger.kernel.org>; Wed, 20 Oct 2021 16:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/vtS64mFl35nNdHBWzz1bAapoT/Rb4Wjf2BXZf5zcVc=;
        b=4qLUlr6jHkf0euo4R3THqRq0zr/dmUbXRdkGRmbKG5ooEiVPuKMzznZ7dpsgbVVS7E
         Fk6szHY7+xJxfmu9ld0M8QKsAB6XW5ko3RxsDp1RRxZO38taUiMxwD5s/fcs0M+Jf+kh
         0b5tkiGuFl8F+KcScdtyIFtGX8PQmQBGe27q5Yf37ViiYFsJZCFoKuFvZeXqTerhrm0N
         Ss+VdefiNq/ers1NW6Fb1NB513PAGmUjT+TrGe91YacciP8Se+MULSzTJN31fP5FQfiO
         XJBBsuzvZzKjMlzeGD6OT43M2fKDOv2XjNfz2TlNfhMbMBfcyJoMf97lMFXVS1MAJS2E
         Ohmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/vtS64mFl35nNdHBWzz1bAapoT/Rb4Wjf2BXZf5zcVc=;
        b=YJ0xZnAw+a3raxpMvK5ULYqwFooZ4WEM5zTiisaQjmqJhaMZoVPTyv1QpRGZkn7oWz
         cN7NvDP6eULRdwojxjrlg2k+v6U69WwU2/jA6KJle4akf8JlqryeO8b7y6SEs0ivhcZP
         UrY6vNZRorOfSgtnNocwZWcZF3dy3ei6UjYS5f90HKu73y6gV5Yhk7No/VeeTpaRwZSy
         09jjmO3fr05OAQD8NlJ+lLGBhtLSRXeNkWNgvW8umCSks7drLDrQ4UjLCPWXsYeM7Ojl
         jFRIPt0PCDGSS3CAe8Vm1TEVSUo7YhWDTitFN/C4I5jp/HLoW2ukFunoVi6U4+82t2Ct
         u8NA==
X-Gm-Message-State: AOAM532W0ybKOb11cGbeDf9E8vCoe30aolZNLRkhd2iwUKjMvSj5M3ms
        469/gZvwWuXw6QWvpjrFluFBx+ZKgFQOKWa2bXs=
X-Google-Smtp-Source: ABdhPJyGgawFRcJPZRZj1wFRRoshxab3kbIN1fk/+0f4Ra3mwI9EVM9lm2FwLsbDUYxVPxg4hVzIHw==
X-Received: by 2002:a62:6543:0:b0:44c:61a0:555a with SMTP id z64-20020a626543000000b0044c61a0555amr1709997pfb.14.1634772266834;
        Wed, 20 Oct 2021 16:24:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z11sm7045429pjl.45.2021.10.20.16.24.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 16:24:26 -0700 (PDT)
Message-ID: <6170a52a.1c69fb81.c4a4c.4e0a@mx.google.com>
Date:   Wed, 20 Oct 2021 16:24:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.289
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.4.y baseline: 110 runs, 2 regressions (v4.4.289)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 110 runs, 2 regressions (v4.4.289)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 2       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.289/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.289
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c67099a5bc53d1a24058ba5afe873f16cd290e16 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 2       =
   =


  Details:     https://kernelci.org/test/plan/id/6170723c6d945a84113358f1

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.289=
/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.289=
/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/6170723c6d945a84=
113358f4
        new failure (last pass: v4.4.288-42-g0c53da1daa10)
        1 lines

    2021-10-20T19:46:50.714754  / #
    2021-10-20T19:46:50.817931  #
    2021-10-20T19:46:50.818496   =

    2021-10-20T19:46:50.919739  / # #export SHELL=3D/bin/sh
    2021-10-20T19:46:50.920211  =

    2021-10-20T19:46:51.021479  / # export SHELL=3D/bin/sh. /lava-960859/en=
vironment
    2021-10-20T19:46:51.021866  =

    2021-10-20T19:46:51.122931  / # . /lava-960859/environment/lava-960859/=
bin/lava-test-runner /lava-960859/0
    2021-10-20T19:46:51.123815  =

    2021-10-20T19:46:51.124547  / # /lava-960859/bin/lava-test-runner /lava=
-960859/0 =

    ... (8 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6170723c6d945a8=
4113358f6
        new failure (last pass: v4.4.288-42-g0c53da1daa10)
        29 lines

    2021-10-20T19:46:51.554610  kern  :emerg : Internal error: Oops - BUG: =
0 [#1] SMP ARM
    2021-10-20T19:46:51.560604  kern  :emerg : Process udevd (pid: 108, sta=
ck limit =3D 0xcb940218)
    2021-10-20T19:46:51.564841  kern  :emerg : Stack: (0xcb941cf8 to 0xcb94=
2000)
    2021-10-20T19:46:51.573061  kern  :emerg : 1ce0:                       =
                                bf02bdc4 60000013
    2021-10-20T19:46:51.581128  kern  :emerg : 1d00: bf02bdc8 c06a35ac 0000=
0001 00000000 bf010250 00000002 60000093 00000002   =

 =20
