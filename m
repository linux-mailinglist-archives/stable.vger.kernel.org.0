Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6103A3E3B4F
	for <lists+stable@lfdr.de>; Sun,  8 Aug 2021 18:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbhHHQOB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Aug 2021 12:14:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230448AbhHHQOA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Aug 2021 12:14:00 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1725C061760
        for <stable@vger.kernel.org>; Sun,  8 Aug 2021 09:13:40 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id u5-20020a17090ae005b029017842fe8f82so16753530pjy.0
        for <stable@vger.kernel.org>; Sun, 08 Aug 2021 09:13:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GfBal4JwAVYUy2eQWSqbEASyZbiWgNMiEQgayyE4wQA=;
        b=DYcBZjK6ffLbYh6yuzOZR0+QlRj5KdmMwvwSICkiF8n9JgV4RQXBDkPTd8EGk51zsM
         WTBTb9hh0a3bxjmrltUz1mi/UjAAyG2zDe5p7NkIHG0fQZ51yYqsX8OT5/py+3evXJBj
         +z/RGBp/iZBkX8viZPFjFljWd8Bff9nWeYUoMfajLD+Rl6ZK6D1BAIAdoDq8MtPYPEVv
         MsfSIdBd2Gx22YrW+SvUDKWsA9iVJHpDbdC9eOkjuiGPyNS2SSH41KsqonmbDOlz+Fl5
         6+I8ribq7iRzmc8LY/jN+gncDJLDm0kmCxTGjxHJ43eUKleSVE/4aiaSGjkyfyOs7lpu
         vm6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GfBal4JwAVYUy2eQWSqbEASyZbiWgNMiEQgayyE4wQA=;
        b=IiZbgk03+va76v6A214lIGSSSi6jdoCkxF91XWE4oSRslTVoSzltWIGEz1q10G6dA6
         c0kl8gGWYgiHFB9Zoe9LZWZ/AUU5NwjIu6ZvVsaDSWhW+5cl9sH5WKqH8hQ6EsboGqCb
         iNGtANZhbkB444CQyF6BC3TY1fkeasep+TTra/zEp6eVIP6vEot004SqzCVGxTDU2kni
         O7uD5PCzhmib5W5p0xsLMztTCfoRvCJgWPNBH5vYK8ET60fk5J4SrMzOFN9ZAlgkDicf
         9rlisJs5HeFatL+FFoDH8lD7Nksjp3p8s36cnzlFu9oxXafoswD6Pv6tb2MPKlpIKflR
         BHYg==
X-Gm-Message-State: AOAM533SKE4v5YdqsDmhewy/n10J34RaTRJXqpXUXCME+Ru4/KDKC7m/
        yPdLYfu017BcPtK4V6mTrXJpjQ//fyyP+t1c
X-Google-Smtp-Source: ABdhPJyMQIg9A85yV0D+cbjkJ3SXO/KWxPGmRZPDUjfhwKXxzRh0NO1bDKo7x4Mcf/Q4gczGb2geww==
X-Received: by 2002:a63:6447:: with SMTP id y68mr288299pgb.154.1628439220022;
        Sun, 08 Aug 2021 09:13:40 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id hd21sm5164416pjb.7.2021.08.08.09.13.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Aug 2021 09:13:39 -0700 (PDT)
Message-ID: <611002b3.1c69fb81.22c1a.dd7c@mx.google.com>
Date:   Sun, 08 Aug 2021 09:13:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.279-11-g3882352fe192
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.4 baseline: 78 runs,
 6 regressions (v4.4.279-11-g3882352fe192)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 78 runs, 6 regressions (v4.4.279-11-g3882352f=
e192)

Regressions Summary
-------------------

platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv2 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv2 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv3 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv3 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv3 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.279-11-g3882352fe192/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.279-11-g3882352fe192
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3882352fe192c37317292d0dc49b7d0110424db4 =



Test Regressions
---------------- =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/610fcae62daa8c532cb13663

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.279-1=
1-g3882352fe192/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.279-1=
1-g3882352fe192/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610fcae62daa8c532cb13=
664
        failing since 267 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/610ff98822985275eeb13661

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.279-1=
1-g3882352fe192/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.279-1=
1-g3882352fe192/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610ff98822985275eeb13=
662
        failing since 267 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/610fec8ddd08a5833eb13681

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.279-1=
1-g3882352fe192/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.279-1=
1-g3882352fe192/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610fec8ddd08a5833eb13=
682
        failing since 267 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv3 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/610fca5a10ffad7f3fb13690

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.279-1=
1-g3882352fe192/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.279-1=
1-g3882352fe192/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610fca5a10ffad7f3fb13=
691
        failing since 267 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv3 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/610ff8ab0d206f97bbb13661

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.279-1=
1-g3882352fe192/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.279-1=
1-g3882352fe192/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610ff8ab0d206f97bbb13=
662
        failing since 267 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv3 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/610fec65ff8b4ff9aeb1368f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.279-1=
1-g3882352fe192/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.279-1=
1-g3882352fe192/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610fec65ff8b4ff9aeb13=
690
        failing since 267 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =20
