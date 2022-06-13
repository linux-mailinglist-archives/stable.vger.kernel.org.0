Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E8FD548101
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 09:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237424AbiFMHwz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 03:52:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238655AbiFMHwq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 03:52:46 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5C9BBCAC
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 00:52:45 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id e66so4855767pgc.8
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 00:52:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ctssdKnqHv3iU86QUTZw+vddLXONS8vYyUu9Aqw8yPc=;
        b=aXoohuTpLvCUiO0zUP+l+ZYLi/8QCLDaIQIFz0jFPj+73OrNZDvkDndLeP1Nqt2/b9
         wjurJppdY8NZhV4p+zFnicmZcs2WjvVb1qJ5l50yet7vaqVBwUsjZ1OmB0uZrIbpB1Wb
         b583IPouXxEVRJzezpP0Uqt/lsINLQOyckdUy8fRlIVPx53p0HB9zScitnA/LXRrsWX/
         SyGL8hCohcGRBFjW43TNZocVludkfOWHQddYHTS0x7lJs5VjXfkOc0XfdB5EVC95rAr2
         mZZ50MG5UvqgShV9FlolHlgeN+UaEujvbRVTTuch9euY0AWbLj6gGZ62PbKPBqmztt3s
         eVjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ctssdKnqHv3iU86QUTZw+vddLXONS8vYyUu9Aqw8yPc=;
        b=5FP9n/DuzENNX24cGar3HVdLroBBmRF89gV1v2C4hExZWnoi4Dnqh0N0pKc0Ij36Zd
         F0TdRbGCAsVv0qswcJT9jwy77VbqHNyY934EosoIoHTY3gA0l4STEhnj62BLf6Qed4rG
         xqE+YmJZihmC7odSc8h/7ifOFFz1YBEKmo0nmH5UZfY5LLBY1TuOdY8397FO0ODkpN6A
         x5scAELAXxFQKrq3Jpv8PRc3x/CXFDXwpQemM5+sLDcuKE+8Oqh8rFTlf5SLmn5Khmlr
         m8dlM8/mPpnf+BtMky0HD2o+2DDjuTRmxKM/23v7hp1nsU2lAt7NkO3UDreFhHSqb07y
         VMGg==
X-Gm-Message-State: AOAM532cgNcwA3MGL71kne8ncXY0xp985eFrrcwJZaG5if6NNXCOVC7f
        surQAn6dbphaqZc9PlXhm2wUgbBLpkNJppXGz1M=
X-Google-Smtp-Source: ABdhPJwNZh9PwUGXYZGACn1D92gzAfLXiohR/fuq6+zcsTeV8BtMgkCRnsOTPC5dtEzDckNTG0vYFg==
X-Received: by 2002:a65:6044:0:b0:3fc:674:8f5a with SMTP id a4-20020a656044000000b003fc06748f5amr50649739pgp.436.1655106765218;
        Mon, 13 Jun 2022 00:52:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y23-20020a17090264d700b001640594376dsm4354096pli.183.2022.06.13.00.52.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 00:52:44 -0700 (PDT)
Message-ID: <62a6eccc.1c69fb81.629e.4ec7@mx.google.com>
Date:   Mon, 13 Jun 2022 00:52:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.45-880-g694575c32c9b2
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 177 runs,
 3 regressions (v5.15.45-880-g694575c32c9b2)
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

stable-rc/queue/5.15 baseline: 177 runs, 3 regressions (v5.15.45-880-g69457=
5c32c9b2)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
jetson-tk1       | arm   | lab-baylibre  | gcc-10   | multi_v7_defconfig   =
      | 1          =

jetson-tk1       | arm   | lab-baylibre  | gcc-10   | tegra_defconfig      =
      | 1          =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.45-880-g694575c32c9b2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.45-880-g694575c32c9b2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      694575c32c9b2ee35bbdd37cf190b5de778d9fb6 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
jetson-tk1       | arm   | lab-baylibre  | gcc-10   | multi_v7_defconfig   =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/62a6b710490d69361da39be1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.45-=
880-g694575c32c9b2/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jets=
on-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.45-=
880-g694575c32c9b2/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jets=
on-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a6b710490d69361da39=
be2
        failing since 2 days (last pass: v5.15.45-667-g99a55c4a9ecc0, first=
 fail: v5.15.45-798-g69fa874c62551) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
jetson-tk1       | arm   | lab-baylibre  | gcc-10   | tegra_defconfig      =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/62a6b79bff57922764a39bcf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.45-=
880-g694575c32c9b2/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-=
tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.45-=
880-g694575c32c9b2/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-=
tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a6b79bff57922764a39=
bd0
        new failure (last pass: v5.15.45-833-g04983d84c84ee) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62a6bb41931be554d9a39c36

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.45-=
880-g694575c32c9b2/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.45-=
880-g694575c32c9b2/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62a6bb42931be554d9a39c58
        failing since 97 days (last pass: v5.15.26-42-gc89c0807b943, first =
fail: v5.15.26-257-g2b9a22cd5eb8)

    2022-06-13T04:21:02.373358  <8>[   59.812513] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-06-13T04:21:03.397303  /lava-6602316/1/../bin/lava-test-case   =

 =20
