Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90C16481512
	for <lists+stable@lfdr.de>; Wed, 29 Dec 2021 17:22:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237272AbhL2QWF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Dec 2021 11:22:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbhL2QWF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Dec 2021 11:22:05 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80471C061574
        for <stable@vger.kernel.org>; Wed, 29 Dec 2021 08:22:04 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id o63-20020a17090a0a4500b001b1c2db8145so25134226pjo.5
        for <stable@vger.kernel.org>; Wed, 29 Dec 2021 08:22:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=oGOi3yODmtts/ujGcwzsXiaPMuHMK5diiH9aVdQBZgQ=;
        b=aqbNJKLmFpmC7slHH3iMg6bBrdFvkIz1oVIVl3/GA/jh6gODY6sDKmVCVeB/Pyapro
         r2gcfwAHed0+lKRxX/CJ/brYksG9TbJChAHmth6MQnjUpBiRTHSNbLbAUY3fcP/OYpil
         iIV60Sb/f++knGOsTADeGK1h0GzdDsoSiMR0s9POD9V7Dh0m3Rv8hvVJQPLBdviPrUFj
         hq0TVH5+UKQzbEYwMKjlgVxhnk5PWLRZnUyQE3jRz10MBHljvojZUSmVGvVAOL6y3O3A
         fMbxFfY2dE9p9XBER7zo2EwVudNcHxy8wjm7kxr+7zu7cWxKyIuJ1vmvZHbdbeHmUspp
         wLjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=oGOi3yODmtts/ujGcwzsXiaPMuHMK5diiH9aVdQBZgQ=;
        b=1ZzLPd8tGY/8LQgGDF8E34lR0+dlRIBLkd90H0P5o/I2jMpGKBb/lMju2O/dCAw8O1
         dl7SsOcNrbf3gV0izXng2ebrG7UqwT7T8mBxSiahdu9BlVwonBaJgRWmDVvugoMF8JZj
         jyepxwNKWOOmTESK70Q67bZElJDoVfQjhrxE+lg8xg/7YaDMeICJkAol1wZ6Ake1PEGS
         4lv5Mt8hP+jnUYRC/tIox9OApxZYHF+9ssQ/6FcJB4DuWVbggMmzxwOpW3fyQ50hi72E
         L0U2C6jq1o6oMjFRkZN0DQ/j90dyCoiSbsstTNfPuWqSM5K5fX/dja5GC3YMWhGjLmV7
         lXbw==
X-Gm-Message-State: AOAM532xSG6vsonbb6rgqZhN4DzuQ3HTY8Jd+VHzeFsXo2CgoyEZYO2t
        jJaIuxIe1mkjRCpNhoHSOYFK3aY1jnpOOKZx
X-Google-Smtp-Source: ABdhPJwKSbVET8AIBUMomX6V0w4VNcSRwFKDirDu4R2rNhy+RI6ixU/G5qmyi9UYDiCePuHt8AXwBA==
X-Received: by 2002:a17:90b:19d4:: with SMTP id nm20mr33327103pjb.106.1640794923951;
        Wed, 29 Dec 2021 08:22:03 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v4sm22423664pjk.38.2021.12.29.08.22.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Dec 2021 08:22:03 -0800 (PST)
Message-ID: <61cc8b2b.1c69fb81.91e23.dd3a@mx.google.com>
Date:   Wed, 29 Dec 2021 08:22:03 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.19.223
X-Kernelci-Branch: linux-4.19.y
Subject: stable/linux-4.19.y baseline: 187 runs, 2 regressions (v4.19.223)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 187 runs, 2 regressions (v4.19.223)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig             | regre=
ssions
-----------+------+--------------+----------+-----------------------+------=
------
da850-lcdk | arm  | lab-baylibre | gcc-10   | davinci_all_defconfig | 2    =
      =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.223/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.223
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      7139b4fa767396e52716f3bc970d2c78195786f5 =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig             | regre=
ssions
-----------+------+--------------+----------+-----------------------+------=
------
da850-lcdk | arm  | lab-baylibre | gcc-10   | davinci_all_defconfig | 2    =
      =


  Details:     https://kernelci.org/test/plan/id/61cc50ce91be93e9b1ef6740

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: davinci_all_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.223/=
arm/davinci_all_defconfig/gcc-10/lab-baylibre/baseline-da850-lcdk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.223/=
arm/davinci_all_defconfig/gcc-10/lab-baylibre/baseline-da850-lcdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/61cc50ce91be93e=
9b1ef6744
        new failure (last pass: v4.19.222)
        6 lines

    2021-12-29T12:12:49.292498  kern  :alert : BUG: Bad page state in proce=
ss swapper  pfn:c3000
    2021-12-29T12:12:49.292737  kern  :alert : raw: 00000000 00000100 00000=
200 00000000 00000004 0000000a ffffff7f 00000000
    2021-12-29T12:12:49.292916  kern  :alert : page dumped because: nonzero=
 mapcount
    2021-12-29T12:12:49.293070  kern  :alert : BUG: Bad page state in proce=
ss swapper  pfn:c3400
    2021-12-29T12:12:49.293215  kern  :alert : raw: 00000000 00000100 00000=
200 00000000 00000004 0000000a ffffff7f 00000000
    2021-12-29T12:12:49.293359  kern  :alert : page dumped because: nonzero=
 mapcount
    2021-12-29T12:12:49.331237  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D6>   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61cc50ce91be93e=
9b1ef6745
        new failure (last pass: v4.19.222)
        4 lines

    2021-12-29T12:12:49.469223  kern  :emerg : page:c6f49000 count:0 mapcou=
nt:-128 mapping:00000000 index:0x4
    2021-12-29T12:12:49.469486  kern  :emerg : flags: 0x0()
    2021-12-29T12:12:49.469670  kern  :emerg : page:c6f51000 count:0 mapcou=
nt:-128 mapping:00000000 index:0x4
    2021-12-29T12:12:49.469823  kern  :emerg : flags: 0x0()
    2021-12-29T12:12:49.537919  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Deme=
rg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>
    2021-12-29T12:12:49.538139  + set +x
    2021-12-29T12:12:49.538311  <8><LAVA_SIGNAL_ENDRUN 0_dmesg 1328623_1.5.=
2.4.1>   =

 =20
