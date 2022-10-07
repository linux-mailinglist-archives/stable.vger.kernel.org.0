Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D2DF5F77E4
	for <lists+stable@lfdr.de>; Fri,  7 Oct 2022 14:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbiJGMTs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Oct 2022 08:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiJGMTr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Oct 2022 08:19:47 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C393CC63
        for <stable@vger.kernel.org>; Fri,  7 Oct 2022 05:19:38 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id h13so3309229pfr.7
        for <stable@vger.kernel.org>; Fri, 07 Oct 2022 05:19:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=NlefVuFiw2WGkhGndLaFFjgA+vwJQOo/8BxAnqGP1Yc=;
        b=4qrDNDuNoZWVqGFx7y9jHYA4PajbpxPiLNCxXdByQoiDUWfeeb2tSTxxle4Zz33ieI
         MHSm0aLwlDeG4Dh80xwnueIJyCshGoJlkivEsppZV6KwKwWqkpnVu+i0m44x//LknZ5d
         YBNOslFyNY25+U6dCiHv/fT1XXm5/DB9MTlJMkRdvILeHGVLd00Kl1rh4dv5UizWrYym
         iDJfZsvoOWlYSRkosCNGyvgeUGwgpOxx+pJm64T6o+GbRMKNbwVyJqOz+xO+s9AwnyzA
         0ZEO5o7YsL3QVk+fkv9KTKsk+E4WRwUsmRehH8XwC6wXb7UVDUYg/jWl20RFdR4eJ+SM
         GFJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NlefVuFiw2WGkhGndLaFFjgA+vwJQOo/8BxAnqGP1Yc=;
        b=jNa7xus4ip2O8NrMLq2azrB9YhMTK19kJ4nYdi1EcwT3F97cIgftWC086Ia2cnNiUP
         /oBRjRQxbwAp3OfjMzTTrYC5GIkQc5dwcL7jOz+QqzmSdlJm3U8P9O2IirWl/3pu7kzg
         gNwjUMndnXwtymxxVViaxJy/LPmBQrHVUYkvjs5mYFMGNMUHOE04/Ze3KIlsBoaQsuvE
         /6W3EgPCUvacHN07JQnTd2GHepRzCo4G96qrt7hFfYq54WhTmgz8FtxSBGrXPEXrBmov
         6IWvWa+ufWplt9UYLemoVgGNfWhHDxlEyB9q2N0qJc7siV5D6tvY6Ig8VG+QPr1O6M+X
         9ZUA==
X-Gm-Message-State: ACrzQf2JKGYNMK4l0/AFZEusfKr9TadLj1KKT4oUdA0WP9QGF4dNgfXl
        C1VwaruF2SsHk5zR6vslNXjw19S4/9sW8dyZ+Wg=
X-Google-Smtp-Source: AMsMyM6k/CC3pFk2ckOJgTapQETcfxqHfIaK67E0VEBcLaoIHNDiamjA0NLd6Fk5A6278c0Nyup/TQ==
X-Received: by 2002:a05:6a02:30e:b0:451:c1e1:375a with SMTP id bn14-20020a056a02030e00b00451c1e1375amr4520297pgb.474.1665145178042;
        Fri, 07 Oct 2022 05:19:38 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h17-20020a170902f55100b001788ccecbf5sm1434662plf.31.2022.10.07.05.19.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Oct 2022 05:19:37 -0700 (PDT)
Message-ID: <63401959.170a0220.ed4a8.2781@mx.google.com>
Date:   Fri, 07 Oct 2022 05:19:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.4.217
X-Kernelci-Report-Type: test
Subject: stable/linux-5.4.y baseline: 111 runs, 4 regressions (v5.4.217)
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

stable/linux-5.4.y baseline: 111 runs, 4 regressions (v5.4.217)

Regressions Summary
-------------------

platform                   | arch  | lab         | compiler | defconfig | r=
egressions
---------------------------+-------+-------------+----------+-----------+--=
----------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie | gcc-10   | defconfig | 1=
          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie | gcc-10   | defconfig | 1=
          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie | gcc-10   | defconfig | 1=
          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie | gcc-10   | defconfig | 1=
          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.217/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.217
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      6e150d605c9e21dbe939875c13e82da33fb59ed0 =



Test Regressions
---------------- =



platform                   | arch  | lab         | compiler | defconfig | r=
egressions
---------------------------+-------+-------------+----------+-----------+--=
----------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie | gcc-10   | defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/633feba125394f8fe2cab5ed

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.217/ar=
m64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.217/ar=
m64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633feba125394f8fe2cab=
5ee
        failing since 150 days (last pass: v5.4.190, first fail: v5.4.192) =

 =



platform                   | arch  | lab         | compiler | defconfig | r=
egressions
---------------------------+-------+-------------+----------+-----------+--=
----------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie | gcc-10   | defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/633feccd660fcf3a71cab5ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.217/ar=
m64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.217/ar=
m64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633feccd660fcf3a71cab=
5ed
        failing since 150 days (last pass: v5.4.190, first fail: v5.4.192) =

 =



platform                   | arch  | lab         | compiler | defconfig | r=
egressions
---------------------------+-------+-------------+----------+-----------+--=
----------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie | gcc-10   | defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/633feb651ab5c50939cab601

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.217/ar=
m64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.217/ar=
m64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633feb651ab5c50939cab=
602
        failing since 150 days (last pass: v5.4.190, first fail: v5.4.192) =

 =



platform                   | arch  | lab         | compiler | defconfig | r=
egressions
---------------------------+-------+-------------+----------+-----------+--=
----------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie | gcc-10   | defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/633fec55c4d46a7d16cab5f4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.217/ar=
m64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.217/ar=
m64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633fec55c4d46a7d16cab=
5f5
        failing since 150 days (last pass: v5.4.190, first fail: v5.4.192) =

 =20
