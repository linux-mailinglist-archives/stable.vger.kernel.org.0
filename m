Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8556648E1CB
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 01:55:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232064AbiANAzQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jan 2022 19:55:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbiANAzP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jan 2022 19:55:15 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99074C061574
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 16:55:15 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id l16so2575859pjl.4
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 16:55:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=z9y2GVOD8Y3CrSzVDTiWzubekA4HsEYaEOSiQWcSqX0=;
        b=LbGqEBiAlFqKspcAX6H03NsMRZNlUtMzUf7Dbf55isKPrMLMnTsJySmilSwIdmpGxb
         Sskl1m9JmhIutzM/coPBQTVoLbUuxbRrDCCnxWQH5WvcltXJWqFTkCst7zPvCHWz1lUg
         o8r30ffN0C7irg7K2hQS5WiRiDTVUVZNyth/x/+nlGF+znp67SAcqrhWSCv4iuftMWjE
         LRxZ76MVGDTuCdsLE8NWkj2YyNZYHYZo+3R2EbGBtLX92A1FYpVbj7LIP3HOQ4VZ288/
         NNkx7x6TofYJWYwBzUJxLVhBscjlHy8T3dsFXZ1l+rrck/9DyCDfLUvJX+ketg4ENcjN
         wFqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=z9y2GVOD8Y3CrSzVDTiWzubekA4HsEYaEOSiQWcSqX0=;
        b=73972Gl1J4zY1sn03Zz7Au0Ci+xdFzWzzQCyaaDgAfo0Fvl9Ha5t+rTZQ4GQnIZgmO
         4Zp2AafA/QMqNFBzlwiM5OVpIz1YOknG9DPg+7pDCvxuXvin4hdSiIJ8htrmxf+QrrUS
         mkNhhUfdT349F94dXvZ17Sg7Wi8MuORd8atinzT2xpp3RlBvim2EUwWR7WXXoHD1P8Ja
         d1zkfE7EhOywcmURXzwDMT2auFKGTpYmPFYEcUCLMlY9rRhkXstvUP51yueahNZQNARm
         AJLMparnC3V/5pwibMvf13QQYbJ+dLRv62FNOnYPdBzN8AO1T2+gFxqlWngzA7SwjCtT
         OZ1g==
X-Gm-Message-State: AOAM531ZAllq5Vby+KB0eEqSO0iAUZTTfQZTvsfREch9cdZyoaaXjTrr
        Dsg/8tfWNZA6I14BQP3CFd5G1u3fAkrVdDpzdJA=
X-Google-Smtp-Source: ABdhPJwkUopn8NTg7HqVJu+1V7dfYDLiEIiKozVBcZQao9LYcMhActY6giKFfY/mLkspLxqTTbE6Lw==
X-Received: by 2002:a17:90a:cc0c:: with SMTP id b12mr7724723pju.103.1642121714482;
        Thu, 13 Jan 2022 16:55:14 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id pc7sm1253992pjb.16.2022.01.13.16.55.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jan 2022 16:55:14 -0800 (PST)
Message-ID: <61e0c9f2.1c69fb81.1d607.42d6@mx.google.com>
Date:   Thu, 13 Jan 2022 16:55:14 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.171-15-g84235c8b1545
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 162 runs,
 4 regressions (v5.4.171-15-g84235c8b1545)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 162 runs, 4 regressions (v5.4.171-15-g84235c8=
b1545)

Regressions Summary
-------------------

platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.171-15-g84235c8b1545/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.171-15-g84235c8b1545
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      84235c8b1545b9437a45f11b8b0c05a096528d81 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e098e18e0ccf2e15ef675b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-1=
5-g84235c8b1545/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-1=
5-g84235c8b1545/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e098e18e0ccf2e15ef6=
75c
        failing since 28 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e098e37441f5f284ef6753

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-1=
5-g84235c8b1545/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-1=
5-g84235c8b1545/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e098e37441f5f284ef6=
754
        failing since 28 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e098f1b167b032b6ef6759

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-1=
5-g84235c8b1545/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-1=
5-g84235c8b1545/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e098f1b167b032b6ef6=
75a
        failing since 28 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e098e4acae919d83ef6748

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-1=
5-g84235c8b1545/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-1=
5-g84235c8b1545/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e098e4acae919d83ef6=
749
        failing since 28 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20
