Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 579015F4D46
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 03:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbiJEBFS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Oct 2022 21:05:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiJEBFR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Oct 2022 21:05:17 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED74224BD0
        for <stable@vger.kernel.org>; Tue,  4 Oct 2022 18:05:15 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id c24so14130533plo.3
        for <stable@vger.kernel.org>; Tue, 04 Oct 2022 18:05:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=Gp6RAyQMYK48RD+tjwUHCtu6wdW3xTrSaLkvW0YCfhU=;
        b=SG5w7jOZXzT0/lA9IWzc1E0ZJ43++kVj3cIkJ6m9fWdRHsgzsduSl0TLsbdzz8WDBs
         45Aj/c/GAcPXb14WYqfvWmbH05BfaX1OzDkHb7UYaFcSgd2bzfbT7NQkoUFwHbLtfAk7
         8q6QLV6/GWrEcq+S/F5x4SthMbBnfRJ91YBkO6xMQXInsuLvAJlaoJmy+yJ90u8FkfOz
         GJHewUm2oxH5oezv1h+IHF5Ulkt83n/OPGvhpB1m4jQOngdkSSXqtcakE0cANt4/kG7j
         sQ0TAQeviu0ygy6PanpXnW1oaWBVkyajoHAqyYog6W7nMrPgIYVTv5O5rRD0usLcFQWb
         9Fkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=Gp6RAyQMYK48RD+tjwUHCtu6wdW3xTrSaLkvW0YCfhU=;
        b=H6/hmZQ0lthKN33DlTOr2sO/VS95GTD6gn8PtnP7btuRoVF9RbHRBnVE9bALn1a9hL
         wG5bK9yfvImqHWDt746T+vOHqO7iMFBpPtcZwpC4wjtCSSG66Zv+lumf5zStZRFyptPV
         UwUd7qY2dAgeVCb70WVB0L/DQxPgEYJoSTXwzjtgq2SSXadr1inrN2XCO+9NFW6jbWOp
         XIcfyTS42hzFWtwvWwPrYsyleQQAqR8m8AZdZORo5ZggdAvzKeYwHx5KJ41VQ4U/WQFx
         mIwVrOndK223KCbq0we4CnV6ibZ6O4i2ImFgdc43ueph0y1QQXEdKdEN3Y8ZH1qhty/a
         jw/w==
X-Gm-Message-State: ACrzQf35ynej4fRZG6hvpRMsE4wnlDCI+AdqGx9h337iD0npM+F2T2sl
        6ybyjJ5WMDLbBCTB5ts4k5AyfdXUenIC8CIqSq0=
X-Google-Smtp-Source: AMsMyM6tYquUTtCXbTKzOAAnd9n5Ejcu/vIQNJ140DU6sgNJPo/M934MZCJwSIkxF3VcTKAj7RlQJA==
X-Received: by 2002:a17:903:41c4:b0:17c:a586:916e with SMTP id u4-20020a17090341c400b0017ca586916emr22510523ple.18.1664931915208;
        Tue, 04 Oct 2022 18:05:15 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x184-20020a6231c1000000b0053e4baecc14sm9898458pfx.108.2022.10.04.18.05.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Oct 2022 18:05:14 -0700 (PDT)
Message-ID: <633cd84a.620a0220.be1d4.0b63@mx.google.com>
Date:   Tue, 04 Oct 2022 18:05:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.295-19-g625701973aed6
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 78 runs,
 4 regressions (v4.14.295-19-g625701973aed6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 78 runs, 4 regressions (v4.14.295-19-g625701=
973aed6)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
meson-gxl-s905x-khadas-vim   | arm64 | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =

meson-gxl-s905x-libretech-cc | arm64 | lab-broonie   | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-collabora | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.295-19-g625701973aed6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.295-19-g625701973aed6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      625701973aed6c6731bb0e9856d0daeb81a09eee =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
meson-gxl-s905x-khadas-vim   | arm64 | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/633ca722899b47b973cab609

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.295=
-19-g625701973aed6/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s=
905x-khadas-vim.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.295=
-19-g625701973aed6/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s=
905x-khadas-vim.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633ca722899b47b973cab=
60a
        failing since 91 days (last pass: v4.14.285-35-g61a723f50c9f, first=
 fail: v4.14.285-46-ga87318551bac) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-broonie   | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/633ca96441223423b5cab5f7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.295=
-19-g625701973aed6/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s9=
05x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.295=
-19-g625701973aed6/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s9=
05x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633ca96441223423b5cab=
5f8
        failing since 169 days (last pass: v4.14.275-277-gda5c0b6bebbb1, fi=
rst fail: v4.14.275-284-gdf8ec5b4383b9) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-collabora | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/633ca737d42b70f140cab5ee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.295=
-19-g625701973aed6/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.295=
-19-g625701973aed6/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633ca737d42b70f140cab=
5ef
        failing since 70 days (last pass: v4.14.267-41-g23609abc0d54, first=
 fail: v4.14.289-19-g8ed326806c84) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/633ca5e4acb677c3b3cab5ee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.295=
-19-g625701973aed6/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.295=
-19-g625701973aed6/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633ca5e4acb677c3b3cab=
5ef
        failing since 70 days (last pass: v4.14.267-41-g23609abc0d54, first=
 fail: v4.14.289-19-g8ed326806c84) =

 =20
