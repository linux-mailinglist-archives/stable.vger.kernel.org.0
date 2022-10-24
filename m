Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21AAE60BB3C
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 22:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbiJXUxC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 16:53:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235124AbiJXUwc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 16:52:32 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F7A41DB8A6
        for <stable@vger.kernel.org>; Mon, 24 Oct 2022 11:59:12 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id b185so3542707pfb.9
        for <stable@vger.kernel.org>; Mon, 24 Oct 2022 11:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=2Pmwcdw9imQiwuflrO9cQozkTYb3cmcycLCcbB7sKmE=;
        b=XpLwHCa1XFZYecFq6Fm76BzLKHCGHvcUHPmJl3y9ERxbU7hMyJ7e+HTVackLn4BkPu
         lk5mRfYLKg0fRV0ltNDzvhBlR2u2K8DDZep0G6EO1IwzCU4PnzJ8K7L+vL3Bc4nhBEll
         BwGT8VUQn6FHoLdDLl81acASQgWNmssm65A4fWJrC8I+Thkk0hqdPwPvzTy2FDuz+q/i
         kIqmvPTsFDr0psDWQGaWwrKgk3v1vYTqm7RnOQMxsUNFhYei6c8WdBqPK1VZD9vVOYQg
         ITy/CwlqJBDFqfyZwZ3ianp/c/tJrsHcbMaI9PfQ2JyKllCr5z0W3yNdSSMz9SuYpYEO
         J21A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2Pmwcdw9imQiwuflrO9cQozkTYb3cmcycLCcbB7sKmE=;
        b=oGdIb8RkGKFXrBRGdpy4D3clRV0UqQ3Fwj6Br2DOmk6D+jfN0eaTHnX0oORf/p8g3I
         AczqG+wrH9MXm5j2LiNgN/ZKFNZRjUIILh3lnPRWAJqFXTkbG/3qWtyQrjmKbw5ttYp/
         IqGm/4jh8E8UOJBjuVyKmHFA8rLletYtBf+0nO0GdtUOrm7fuV7JgAZG89+ublcqZQ1g
         EniqJNKTT4BgfveM17mGfmcs/uttPL9olmujbx4vfpI/s3HPwGIyh9Xh6MxTvbhnBu1Z
         1VFXU/ompLPfP2cnWBZP0dC9N4P7O8HF5b3TAFqFPNJ2c2IEFB4pQrD2RRmjI3KTwGUO
         QR1w==
X-Gm-Message-State: ACrzQf3nx9952/6isqTRffWVFd+sJC9C15RLUa9oVHtOaFEy+EPVuGBD
        2CYgFqZxc7JyGQbejNQj1gcbZv0KJ42ZnTD4
X-Google-Smtp-Source: AMsMyM5JDDUK6n2AXPeEDmLXwJSLK+buSXpTbaHP7ptV0hK39nO9o5VGCWkvSxVCAMyzGAhFNxfkbA==
X-Received: by 2002:a05:6a00:b50:b0:566:917:e588 with SMTP id p16-20020a056a000b5000b005660917e588mr35385688pfo.2.1666637890669;
        Mon, 24 Oct 2022 11:58:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b129-20020a62cf87000000b0056bd59eaef0sm150853pfg.4.2022.10.24.11.58.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 11:58:09 -0700 (PDT)
Message-ID: <6356e041.620a0220.edd0c.04d1@mx.google.com>
Date:   Mon, 24 Oct 2022 11:58:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.149-391-gb4f4370de958b
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.10.y baseline: 140 runs,
 9 regressions (v5.10.149-391-gb4f4370de958b)
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

stable-rc/linux-5.10.y baseline: 140 runs, 9 regressions (v5.10.149-391-gb4=
f4370de958b)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig  =
        | regressions
---------------------------+-------+---------------+----------+------------=
--------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre  | gcc-10   | defconfig  =
        | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig  =
        | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig  =
        | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-baylibre  | gcc-10   | defconfig  =
        | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig  =
        | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig  =
        | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
        | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig  =
        | 1          =

r8a7743-iwg20d-q7          | arm   | lab-cip       | gcc-10   | shmobile_de=
fconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.149-391-gb4f4370de958b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.149-391-gb4f4370de958b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b4f4370de958b2655d6a93d4fc386eed8fe36cd6 =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig  =
        | regressions
---------------------------+-------+---------------+----------+------------=
--------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre  | gcc-10   | defconfig  =
        | 1          =


  Details:     https://kernelci.org/test/plan/id/6356aec96456825ba65e5b40

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
49-391-gb4f4370de958b/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm=
64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
49-391-gb4f4370de958b/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm=
64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6356aec96456825ba65e5=
b41
        failing since 168 days (last pass: v5.10.113-130-g0412f4bd3360, fir=
st fail: v5.10.113-187-g3dca4fac0d16) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
        | regressions
---------------------------+-------+---------------+----------+------------=
--------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig  =
        | 1          =


  Details:     https://kernelci.org/test/plan/id/6356aedb134e1fd05a5e5b6f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
49-391-gb4f4370de958b/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm6=
4-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
49-391-gb4f4370de958b/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm6=
4-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6356aedb134e1fd05a5e5=
b70
        failing since 168 days (last pass: v5.10.113-130-g0412f4bd3360, fir=
st fail: v5.10.113-187-g3dca4fac0d16) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
        | regressions
---------------------------+-------+---------------+----------+------------=
--------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig  =
        | 1          =


  Details:     https://kernelci.org/test/plan/id/6356aecb6456825ba65e5b46

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
49-391-gb4f4370de958b/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm=
64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
49-391-gb4f4370de958b/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm=
64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6356aecb6456825ba65e5=
b47
        failing since 168 days (last pass: v5.10.113-130-g0412f4bd3360, fir=
st fail: v5.10.113-187-g3dca4fac0d16) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
        | regressions
---------------------------+-------+---------------+----------+------------=
--------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-baylibre  | gcc-10   | defconfig  =
        | 1          =


  Details:     https://kernelci.org/test/plan/id/6356aec741e8a8352b5e5bdb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
49-391-gb4f4370de958b/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm=
64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
49-391-gb4f4370de958b/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm=
64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6356aec741e8a8352b5e5=
bdc
        failing since 168 days (last pass: v5.10.113-130-g0412f4bd3360, fir=
st fail: v5.10.113-187-g3dca4fac0d16) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
        | regressions
---------------------------+-------+---------------+----------+------------=
--------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig  =
        | 1          =


  Details:     https://kernelci.org/test/plan/id/6356aec6134e1fd05a5e5b3a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
49-391-gb4f4370de958b/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm6=
4-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
49-391-gb4f4370de958b/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm6=
4-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6356aec6134e1fd05a5e5=
b3b
        failing since 168 days (last pass: v5.10.113-130-g0412f4bd3360, fir=
st fail: v5.10.113-187-g3dca4fac0d16) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
        | regressions
---------------------------+-------+---------------+----------+------------=
--------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig  =
        | 1          =


  Details:     https://kernelci.org/test/plan/id/6356aec86456825ba65e5b3a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
49-391-gb4f4370de958b/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm=
64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
49-391-gb4f4370de958b/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm=
64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6356aec86456825ba65e5=
b3b
        failing since 41 days (last pass: v5.10.101-87-g1f48487c6f05, first=
 fail: v5.10.142-80-gd4bb3d725075) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
        | regressions
---------------------------+-------+---------------+----------+------------=
--------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig  =
        | 1          =


  Details:     https://kernelci.org/test/plan/id/6356aec7134e1fd05a5e5b40

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
49-391-gb4f4370de958b/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm6=
4-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
49-391-gb4f4370de958b/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm6=
4-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6356aec7134e1fd05a5e5=
b41
        failing since 41 days (last pass: v5.10.101-87-g1f48487c6f05, first=
 fail: v5.10.142-80-gd4bb3d725075) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
        | regressions
---------------------------+-------+---------------+----------+------------=
--------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig  =
        | 1          =


  Details:     https://kernelci.org/test/plan/id/6356ae8cdd3510b52a5e5b48

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
49-391-gb4f4370de958b/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_ar=
m64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
49-391-gb4f4370de958b/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_ar=
m64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6356ae8cdd3510b52a5e5=
b49
        failing since 41 days (last pass: v5.10.101-87-g1f48487c6f05, first=
 fail: v5.10.142-80-gd4bb3d725075) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
        | regressions
---------------------------+-------+---------------+----------+------------=
--------+------------
r8a7743-iwg20d-q7          | arm   | lab-cip       | gcc-10   | shmobile_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6356ad10a97727a42d5e5b73

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
49-391-gb4f4370de958b/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a774=
3-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
49-391-gb4f4370de958b/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a774=
3-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6356ad10a97727a42d5e5=
b74
        failing since 14 days (last pass: v5.10.146-52-g014862eecf03f, firs=
t fail: v5.10.147-31-g1a3141006d41) =

 =20
