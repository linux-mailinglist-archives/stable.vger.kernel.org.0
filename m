Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB8E4A686C
	for <lists+stable@lfdr.de>; Wed,  2 Feb 2022 00:19:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242794AbiBAXTG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 18:19:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbiBAXTG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 18:19:06 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22C04C061714
        for <stable@vger.kernel.org>; Tue,  1 Feb 2022 15:19:06 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id z5so16657963plg.8
        for <stable@vger.kernel.org>; Tue, 01 Feb 2022 15:19:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jT3oVMntD0537r3fvFHSkJN58O4Nj824wf7q1UVz5Ck=;
        b=LtAOUTgnCGKgvebm3hE4MyNl4tQ0MTv3mqJLMenrrOLYzJyPiMkrUqgzgmYTfZxaNR
         Kb3jI8kcIdq01aQ2T14zti5ETImb/AJSnUToBXKuN+R8bTnfcOs6QzLHsJX184DlEdKN
         N03EZcGov5aBlML4sc66Ea0KWS/Lj8WdXvmHzBkN+JUSoqNTKbJxxv6gv0umR3+auRit
         f8zQ3eAyB1Fb7nN6NCepUEPwhZrOB+HPYCB6uv/5i7EZiqc0HOKor9t+H0weWQ08pof+
         0KbqXZ/cNk8KVLDrd+/1BMqmk597UF8s82H78NyI6pV/GUJ9lZxw03/APoMfS56rMW/d
         yWHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jT3oVMntD0537r3fvFHSkJN58O4Nj824wf7q1UVz5Ck=;
        b=tRDfyhlEj+xpleHN+qnxhpZe2NHI7VrM6uvU/F5HKowPzm8V21QpuqG0EEj/C4W3q0
         yyKXHQ6/18d8zwy+fT+W2MFe9PsDzA/oIo6abyCopxf+Q/MXZBleP4gDZ42HzmtZyUsj
         pzYTkibMcpLszlWJEywh+g7DHgs65THij9ZIvabnrAwgvK90EGk6YVgHimgsaD74I1JX
         +t2EyYhv9m4POiAvYxzefHbrejrnSBV66/VEAdHxe9Xi4fnxZWtaSCZbDvrnChiE7WSm
         BfpltV9c0gdNr65lJx5NWBkd7FL8pABO5U0vkDZSz0DJovuYm15i1NwCw5BaZbuzJNSP
         P3qQ==
X-Gm-Message-State: AOAM530vDaIYMZvZiYIO/7DVT/zdW80D8VTKt7ShfpL9eyWvVC3RcKaZ
        64CEFcWUAH4XGSvYD6Oq0D5BxsrM65SlQqys
X-Google-Smtp-Source: ABdhPJz+iD/WR5HOkj3S+bCL75x/gAYu2F0i/F2vZIO+bWHVqNr7FmWsdbkfGNb07QfgRvgdSo9lfA==
X-Received: by 2002:a17:90b:1bc9:: with SMTP id oa9mr4930138pjb.217.1643757545474;
        Tue, 01 Feb 2022 15:19:05 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n3sm22094728pfu.84.2022.02.01.15.19.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 15:19:05 -0800 (PST)
Message-ID: <61f9bfe9.1c69fb81.9c829.b25c@mx.google.com>
Date:   Tue, 01 Feb 2022 15:19:05 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.175-64-g177102635817
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 133 runs,
 4 regressions (v5.4.175-64-g177102635817)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 133 runs, 4 regressions (v5.4.175-64-g1771026=
35817)

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
el/v5.4.175-64-g177102635817/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.175-64-g177102635817
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      177102635817c82d3af4e16fd96a055441a0c629 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61f9870f8ca38e67c15d6f1d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.175-6=
4-g177102635817/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.175-6=
4-g177102635817/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f9870f8ca38e67c15d6=
f1e
        failing since 47 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61f987112d6a5042e95d6ee8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.175-6=
4-g177102635817/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.175-6=
4-g177102635817/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f987112d6a5042e95d6=
ee9
        failing since 47 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61f986e221072fa9765d6f0e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.175-6=
4-g177102635817/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.175-6=
4-g177102635817/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f986e221072fa9765d6=
f0f
        failing since 47 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61f987100021bd1fbf5d6eed

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.175-6=
4-g177102635817/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.175-6=
4-g177102635817/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f987100021bd1fbf5d6=
eee
        failing since 47 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20
