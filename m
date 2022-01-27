Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 992FF49E89C
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 18:14:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbiA0ROz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 12:14:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbiA0ROy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 12:14:54 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4068EC061714
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 09:14:54 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id g20so2770067pgn.10
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 09:14:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Nvcs5ElgkNYm36/Et6vd5Y3TcuqIkJRzCCmGQty88mY=;
        b=xlxt8xLY8ht/MjvuJtnCV06jw2hbUecjRYGTt8fyF8Vh3hPbzzh+2p8aoFIWMAXpVv
         1dY5sGsstHOO1+qYhb0nMSMuuGZZC3BjvgvlEDJ4nHMAN+9X7Jlz3cotY06tWNMcjrGb
         oT2d7B8SuAlG5MpiRRowfYLU/nLeoSVwJmx+jIxM7UZiWN99UKR+If20EPaqOl2/Tq36
         koXI3ch2BbziQuegMfXVq48gpwrc1TkePZMkICr4yLpJr7ecHepuQjrm6WB46ahNJdn1
         FbjUpJaId1tCJkae8wkKbVTNZk0wVUVk0vBLCMcXoEIlK1Ap4JhwZUmf64MnMpHUKePr
         C4Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Nvcs5ElgkNYm36/Et6vd5Y3TcuqIkJRzCCmGQty88mY=;
        b=OmMIEGkbmL4fkHtCIfnjh6MurzAaMYnYrsxgCH9HltrMyqWs6kBRYvI22U6d7OSn72
         6iDuch5Had3jNL0Zyb2O8rxI36gDnZpczDwFy+Ur3ar+HOyCPBH4+z7jlMnBjmdYt5tb
         jFMFiYiV2dIt4vzQlFKquLGQXA49sgqvvjHdp+TymdrNK0tspHlEUT4bJRu/B1B/devh
         GMA8Ue4zvidUIxqUM0eWABIbBOORXqLmjfqmUm+McM+4+y2zTUUBC67dYGKXXKlWgXxS
         Nboh4B6mrhQVNMAGb5A2FfstYeu58lvCSB2+ZgSWC9XPDA7CbaZTGqn5jkRJv/Qc3+V6
         rgiQ==
X-Gm-Message-State: AOAM531krDzSbr63eYpRW0l9q6Yd5SWMBNdeTSYlgG3DljubamtV1bL5
        Iia6OYtQ7GCbIyZ8gnW1ba+uMSM8VuCQbd7dm/8=
X-Google-Smtp-Source: ABdhPJyT7gqLamkIBgGlulaWGqTs4VXMovYilnKfIJedtzas40Y1RlhbwxJ89UvHZn8H4ipl0tzQNw==
X-Received: by 2002:a63:6ac3:: with SMTP id f186mr3346761pgc.81.1643303693491;
        Thu, 27 Jan 2022 09:14:53 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e17sm5949617pfj.168.2022.01.27.09.14.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 09:14:53 -0800 (PST)
Message-ID: <61f2d30d.1c69fb81.20e89.08d0@mx.google.com>
Date:   Thu, 27 Jan 2022 09:14:53 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.173-315-gd1b9f8f899c1e
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 166 runs,
 4 regressions (v5.4.173-315-gd1b9f8f899c1e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 166 runs, 4 regressions (v5.4.173-315-gd1b9f8=
f899c1e)

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
el/v5.4.173-315-gd1b9f8f899c1e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.173-315-gd1b9f8f899c1e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d1b9f8f899c1e1b24273536bdb408c3c92494a83 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61f29a433481c32a44abbd6f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.173-3=
15-gd1b9f8f899c1e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.173-3=
15-gd1b9f8f899c1e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f29a433481c32a44abb=
d70
        failing since 42 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61f29a4df70b057e7cabbd2b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.173-3=
15-gd1b9f8f899c1e/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.173-3=
15-gd1b9f8f899c1e/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f29a4df70b057e7cabb=
d2c
        failing since 42 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61f29a58f70b057e7cabbd40

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.173-3=
15-gd1b9f8f899c1e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.173-3=
15-gd1b9f8f899c1e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f29a58f70b057e7cabb=
d41
        failing since 42 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61f29a779d40379bf4abbd4d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.173-3=
15-gd1b9f8f899c1e/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.173-3=
15-gd1b9f8f899c1e/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f29a779d40379bf4abb=
d4e
        failing since 42 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20
