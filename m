Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2764BE2F2
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:56:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356277AbiBUL02 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 06:26:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356653AbiBUL0P (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 06:26:15 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62163FD30
        for <stable@vger.kernel.org>; Mon, 21 Feb 2022 03:22:05 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id i10so12670789plr.2
        for <stable@vger.kernel.org>; Mon, 21 Feb 2022 03:22:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xyr1RrXpf9+hiRoXeul8L7ckJNrRhL4Hj6uizTnRHOw=;
        b=PLoUX7dnJRHMMjJZ2iscs180svQgZ7sTvRE4VKFriV+kvgEYQHNP3qQQXrlRPgjCrW
         2Et83B3u64vwdIRYW5f3IxdJJXu4Texi0mDjw+OI3dfkHaDkZsDaXKagZodHila8jAoB
         onQ6El26ddCeKRLy8Gv6D3zCcqFO8Smy4pYODtUtJhg6z34Ij6zoi4s0aACbEifXSSfW
         4cbjajXAWb2qa4RXEjxJaFGFp+OLNvLxOpajVHXZbgL7BzZIAMLP+1bMB9WY3X59VRvx
         vRFiMAH7K73Cwsl4MNEMQJmqKNmFzSA/9P1FKk6eXAm+CpNgIyTEg8Qxuouw/PMGJavL
         Ai/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xyr1RrXpf9+hiRoXeul8L7ckJNrRhL4Hj6uizTnRHOw=;
        b=y3Z2t1KL5Bk9aew9WnpomP0ZZHuojI/NvblEuAv74jhrHfJm0NTlB5a7769JCSDgq0
         yZsfBnjQeCKTQOH+Od07m0S+sXAr5S+/JoPO8nb+Z784G/ye+hx4Q1/ySETR9396fU9J
         QU1PVgpvjMiDKj3T5gWvsj7ufsM+e1y5oeqp4Dt10UqX1zhsX4R+yZESZ3WZI+fte8JC
         M+jzAQtGZygU93EToH4jptf+Qyh0v6aNB6pgpg6F9xsswpztOe+k2IqaB918+nPKkW62
         PD8LjTTgf3axd8UntMjvLuQpQRvJuAn1Q9wIuaU0JAbfWBjIZCZBSp1fxtL7Pp0q/73b
         siSA==
X-Gm-Message-State: AOAM533RpVL/s8LCKfR21sF+Nw7xxYrxxYtjNpA+rSdAfMevGEbhXC2B
        0r4IxlhB9IpkpfmbL7cscLyPeuHurW293Axa
X-Google-Smtp-Source: ABdhPJwBGrrVSngF6e7Hu6WjoA04i4I4qUjlapO4+rgZ8qIc3QnrWF/guoDOiyJSfJS8jEs8ONP0Ww==
X-Received: by 2002:a17:90a:77cb:b0:1b9:71e4:24a9 with SMTP id e11-20020a17090a77cb00b001b971e424a9mr20802552pjs.234.1645442524686;
        Mon, 21 Feb 2022 03:22:04 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q22-20020a17090a2e1600b001b9c387d0f5sm7457463pjd.28.2022.02.21.03.22.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 03:22:04 -0800 (PST)
Message-ID: <621375dc.1c69fb81.7bb19.4d1a@mx.google.com>
Date:   Mon, 21 Feb 2022 03:22:04 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.16
X-Kernelci-Kernel: v5.16.10-205-gb1b372a8b80e
Subject: stable-rc/queue/5.16 baseline: 124 runs,
 8 regressions (v5.16.10-205-gb1b372a8b80e)
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

stable-rc/queue/5.16 baseline: 124 runs, 8 regressions (v5.16.10-205-gb1b37=
2a8b80e)

Regressions Summary
-------------------

platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie  | gcc-10   | defconfig+ar=
m64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie  | gcc-10   | defconfig+ar=
m64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie  | gcc-10   | defconfig+ar=
m64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie  | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.16/ker=
nel/v5.16.10-205-gb1b372a8b80e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.16
  Describe: v5.16.10-205-gb1b372a8b80e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b1b372a8b80eb3770e51d7ff91c36e4e2ac3f665 =



Test Regressions
---------------- =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62133d4e2a460e8002c62982

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.10-=
205-gb1b372a8b80e/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.10-=
205-gb1b372a8b80e/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62133d4e2a460e8002c62=
983
        failing since 12 days (last pass: v5.16.7-127-g225efc2847e3, first =
fail: v5.16.7-127-g3b11c0b71857) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie  | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62133d2f352dc93c5ec62993

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.10-=
205-gb1b372a8b80e/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.10-=
205-gb1b372a8b80e/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62133d2f352dc93c5ec62=
994
        failing since 12 days (last pass: v5.16.7-127-g225efc2847e3, first =
fail: v5.16.7-127-g3b11c0b71857) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62133ceb17d98ea31dc6298a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.10-=
205-gb1b372a8b80e/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.10-=
205-gb1b372a8b80e/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62133ceb17d98ea31dc62=
98b
        failing since 12 days (last pass: v5.16.7-127-g225efc2847e3, first =
fail: v5.16.7-127-g3b11c0b71857) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie  | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62133cdf17d98ea31dc6297e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.10-=
205-gb1b372a8b80e/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.10-=
205-gb1b372a8b80e/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62133cdf17d98ea31dc62=
97f
        failing since 12 days (last pass: v5.16.7-127-g225efc2847e3, first =
fail: v5.16.7-127-g3b11c0b71857) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62133cea17d98ea31dc62987

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.10-=
205-gb1b372a8b80e/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.10-=
205-gb1b372a8b80e/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62133cea17d98ea31dc62=
988
        failing since 12 days (last pass: v5.16.7-127-g225efc2847e3, first =
fail: v5.16.7-127-g3b11c0b71857) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie  | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62133cde17d98ea31dc6297b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.10-=
205-gb1b372a8b80e/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.10-=
205-gb1b372a8b80e/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62133cde17d98ea31dc62=
97c
        failing since 12 days (last pass: v5.16.7-127-g225efc2847e3, first =
fail: v5.16.7-127-g3b11c0b71857) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62133ced17d98ea31dc6298d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.10-=
205-gb1b372a8b80e/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.10-=
205-gb1b372a8b80e/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/base=
line-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62133ced17d98ea31dc62=
98e
        failing since 12 days (last pass: v5.16.7-127-g225efc2847e3, first =
fail: v5.16.7-127-g3b11c0b71857) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
               | regressions
---------------------------+-------+--------------+----------+-------------=
---------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie  | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62133ce117d98ea31dc62981

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.10-=
205-gb1b372a8b80e/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.10-=
205-gb1b372a8b80e/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220211.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62133ce117d98ea31dc62=
982
        failing since 12 days (last pass: v5.16.7-127-g225efc2847e3, first =
fail: v5.16.7-127-g3b11c0b71857) =

 =20
