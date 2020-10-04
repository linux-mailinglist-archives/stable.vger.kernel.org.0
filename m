Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63507282CDC
	for <lists+stable@lfdr.de>; Sun,  4 Oct 2020 21:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbgJDTEz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Oct 2020 15:04:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbgJDTEz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Oct 2020 15:04:55 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A05FC0613CE
        for <stable@vger.kernel.org>; Sun,  4 Oct 2020 12:04:53 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id b17so3946848pji.1
        for <stable@vger.kernel.org>; Sun, 04 Oct 2020 12:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=AHJqSvm7IBXMeQmuFyFS+3LAyczjwiaMaCNY4XCmoLQ=;
        b=sLL+UtDtwiZnhebICvl9QWTcEzYG/SKgLHjWoFKsiZUWKnVdmGq/oqpCDpUSKD/dwe
         lGxl2swVCEr6FgxFdFATkuXc58VDExv+L5TFzW8XAqOzQdje9IhvoHTWoJBma8XYTWjU
         24YhbCu7txnm/pdE4v1YjNjOuiRGUSmKQXaBPHxPYV4VN0a5X3hgnGHOiXhEnL0kmvi7
         5QTkxKUE4ywpG6ZWYytHHuRafb3tl6xwzL25jiyEjNenwkkINroRJgN64Qr4vi9MkdfB
         bbcYJVm89xWKhySEmMVeQXMcc3KqPKSYhg+/LuT29x6Cq2xqhEOw6nQ1O9fT6lHVtF+4
         BRDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=AHJqSvm7IBXMeQmuFyFS+3LAyczjwiaMaCNY4XCmoLQ=;
        b=IObnffPp1hyd6l1gTtz/WG+FRJg25cXwnBtRA1Ul+VJ/JregMzCpsFrAcvLDarKPRd
         hOtKk0q1DArj1hwTbL/nxHD/u8lD3fwmVy4G5wQSj9Dt4OkAdkoTvr7PQDEnsOoL3eaT
         L+WrrJBLK78wqQ3I2IkuePxH5kp9zoLYY/SxeYsH0XiIvdLeHXYAVy2MXf+9J/PwDGfD
         rxQiUoYE1JqaIzUSvvNiIso7uz/d9mP3jd2wIcSG1e7uhjyJjbwYVOJ2ZdIP0y5M55ze
         NaYDH390MI+9m6OFmJsV5qjbAzHR4hv/CyAoBl5ELmje8B55h7X9j4eqJF6c5+ttF0SX
         9hwQ==
X-Gm-Message-State: AOAM533IrbSeGgmFK8CC6uBN9mPN6YpR76ira31a4/mrTRETVyL/fNlH
        v1Jn7cDm8Q9h+lGRonS7R0uTjpF8VhfJig==
X-Google-Smtp-Source: ABdhPJwPagXc28IexPQs8Z0O5wKFpTDe4rXJlJjhyN/ynIDBgXAELz31cqlGtpVk8Tt9JPST7dU0+A==
X-Received: by 2002:a17:90a:ba0c:: with SMTP id s12mr13465618pjr.2.1601838292651;
        Sun, 04 Oct 2020 12:04:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i1sm2253227pjh.52.2020.10.04.12.04.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2020 12:04:51 -0700 (PDT)
Message-ID: <5f7a1cd3.1c69fb81.bee1a.43ea@mx.google.com>
Date:   Sun, 04 Oct 2020 12:04:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.200-8-ge3aa1fb702c6
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 92 runs,
 1 regressions (v4.14.200-8-ge3aa1fb702c6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 92 runs, 1 regressions (v4.14.200-8-ge3aa1fb=
702c6)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.200-8-ge3aa1fb702c6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.200-8-ge3aa1fb702c6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e3aa1fb702c6947e8e7dda62d34e68a934d42bf4 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 3/5    =


  Details:     https://kernelci.org/test/plan/id/5f79e70391d5982ca84ff3f3

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.200=
-8-ge3aa1fb702c6/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.200=
-8-ge3aa1fb702c6/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f79e70391d5982=
ca84ff3fa
      failing since 0 day (last pass: v4.14.200-4-g2338e5879b46, first fail=
: v4.14.200-8-gb1ab1c6f9ae9)
      2 lines

    2020-10-04 15:15:11.675000  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/99
    2020-10-04 15:15:11.684000  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
      =20
