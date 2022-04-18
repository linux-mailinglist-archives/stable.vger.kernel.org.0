Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A830504F08
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 12:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233331AbiDRKzk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 06:55:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiDRKzj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 06:55:39 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C563816596
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 03:53:00 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id j71so4712048pge.11
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 03:53:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=K5xdkBBawWSG/J89ITni3hcXelMdugFMw1WcQcARq1s=;
        b=p8qvRozE93Vu3y12Nb9jDrzVMcbIoohCg7hNCbriHJ5VA2E5QbLhvy3Km4VapU10yt
         8anrp5jAKR3VLnRLfAQfA91uEr1X7UmLPr44Ry0GeTGivfcL4ruEvB/FvEr5vzNc/Ckg
         m+ja9GtR6pF4cwvr75zhIF4xOTG50wuMxB4q495VGgUEaWZSEmGqwD3yUeIGRkuJFQb/
         3vWx60pOneeMSl51ruE9DwCtVvMZ3TrF5dX0L9pwycVtfarZ4lC3z35WPoUivqC398Ma
         7adzNjO+AqJhWeN1afAudkn7zjRxBB4fgimdMABP5ECqmnD/ktbEmWlU+SFHlDpjrm8w
         BQeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=K5xdkBBawWSG/J89ITni3hcXelMdugFMw1WcQcARq1s=;
        b=1yuKCCUiRx79KHWmUKkdYHQ4/1WA4LeGux+y8rsSYb0kA4R3gdoa3pKTM3FPA96UKK
         Lor2N8xjPSbFqgj7iPc3gJc7dYFjP9jTeokqP9f9Hcdr63vD5Fpc5pL1CC/rdQCp1BB2
         RjX9ehWPL1egb8jZ/1pwmxOWJHEnjzaDg98lJ0tMeqj3j+Z10l5XFuOeibqumwEQRbMi
         t4+DvOdcYEteT8xgK5KmcqDDHVnoJHFParxs0uDx9R5nV+VDaIsMtRFYnHAStSkI+60b
         rDOoohCCSAzpTYVf5kwobKXuwcyh/tqkTzbsf9QPiWIx0kQ2KKD+TYocNwmCoT6jNeTw
         /Rnw==
X-Gm-Message-State: AOAM533vMQ5BadiXdQS9z+S5khPndUKKpU4Gc/VxCA9YnWL0m8Nri5My
        GUXD/dArpaz1sbekp5KkNdjgfmpev7l1RcHz
X-Google-Smtp-Source: ABdhPJxPsxk8kCNfTyfqQT48/YJxySIzcokIx2RQtDh3Y3ixqUYymvvYEsI9Diu5+xotW8PUWOQxNQ==
X-Received: by 2002:a63:69c7:0:b0:380:afc8:33be with SMTP id e190-20020a6369c7000000b00380afc833bemr9454128pgc.304.1650279180107;
        Mon, 18 Apr 2022 03:53:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id bd17-20020a056a00279100b0050824e84050sm11794278pfb.147.2022.04.18.03.52.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 03:52:59 -0700 (PDT)
Message-ID: <625d430b.1c69fb81.f65df.c008@mx.google.com>
Date:   Mon, 18 Apr 2022 03:52:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Kernel: v5.15.34
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.15.y baseline: 88 runs, 3 regressions (v5.15.34)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.15.y baseline: 88 runs, 3 regressions (v5.15.34)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
beagle-xm            | arm   | lab-baylibre | gcc-10   | omap2plus_defconfi=
g | 1          =

meson-gxbb-p200      | arm64 | lab-baylibre | gcc-10   | defconfig         =
  | 1          =

meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-10   | defconfig         =
  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.34/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.34
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1b86fc15ba6d04e393d6e65753f2013963d407f3 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
beagle-xm            | arm   | lab-baylibre | gcc-10   | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/625757c90dedc3a79bae0698

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
4/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
4/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625757c90dedc3a79bae0=
699
        failing since 83 days (last pass: v5.15.14-70-g9cb47c4d3cbf, first =
fail: v5.15.16) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
meson-gxbb-p200      | arm64 | lab-baylibre | gcc-10   | defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/62575b7461779952afae06bd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
4/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
4/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62575b7461779952afae0=
6be
        new failure (last pass: v5.15.33-277-g059c7c9bf722c) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-10   | defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/62575c284063e66fa4ae06aa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
4/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s905d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
4/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s905d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62575c284063e66fa4ae0=
6ab
        new failure (last pass: v5.15.33) =

 =20
