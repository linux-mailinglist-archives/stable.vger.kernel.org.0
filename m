Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D80613DAEB9
	for <lists+stable@lfdr.de>; Fri, 30 Jul 2021 00:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbhG2WOp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 18:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbhG2WOp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Jul 2021 18:14:45 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3CADC061765
        for <stable@vger.kernel.org>; Thu, 29 Jul 2021 15:14:41 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id j1so12265469pjv.3
        for <stable@vger.kernel.org>; Thu, 29 Jul 2021 15:14:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fipRcbQTiHWvCBeYmU3J5yoTAaUDZu8dZZcXhoa5KDM=;
        b=RgL7baOzLYz1Df5QpSMkyHiqkfj3wAW6CUk/gwGA/CwQJ8MdGDjn8kRMcQKm/W23EA
         ZJVThmmZit3AOlv1YrJ2OaKb91tHAtjtNmRc2r2kGZ39VEzm5NqlV2sAZNJTN9+A/hK1
         xWj2EGF74OcPK6dJUGYnuOVve1i1GMzuCe/j1YbNGR7+TGFQJFfqzFtZK3YlcfC2b2SJ
         UxpmoMn+sDrg8HGE0U+oyZ7k3/oIz7o4/8aHZ4VCABTV4/7aU8ts0y9ho9ws8JdxwvJv
         owDo+Z7sRBcXxdKXTI+wN78kRemHNREsInquc81rL6Z55Dl+C/k61W0iX/C5b+XcqCk8
         dtJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fipRcbQTiHWvCBeYmU3J5yoTAaUDZu8dZZcXhoa5KDM=;
        b=BILuwdhtPSGxqJCdy9fUvPtRbiBvWl8968yXu8EI387yIQufBZCg9sMUzNmUTduTh9
         hjm8jFj21aYwR6qOvgjdHQKidEDqZPIjaeoeYe/XKV9NQhitShERV5I1jdwe4Qasu4+1
         LXOYwcFWMz/GI5TbEuYKSMLLM+EZxBnSoP5h5iZGBYxnYssooSkmW98VDoy9b1hPP/9T
         eWIba44FyToK548v3cpPx6o/WiYCNaQPgQeXw9kVMxF8rx/TfU8EOMKbjzHtWpaVb6R8
         s01ccXhoeeHx5X31yMpbbe0oH7M8bZwXYUvjPdBLeysw7kUPrVosQwN2GVPNppAChfRq
         2+LA==
X-Gm-Message-State: AOAM533vYNcHct58WCKyQzHvwYYGq3PC0fX6n2bHIK/GdZm8EvY9ITB7
        4WBjURQ6CS2Q6XdmoubrOYjUK8hQdGb9OP/f
X-Google-Smtp-Source: ABdhPJxbXrNn+QkcPnQ1wa19zmR5rxJvYYcNXGOjsPltEvdsmV53wz+UroAse0Esr/jlHKKAsJBhhQ==
X-Received: by 2002:a17:90b:3ecb:: with SMTP id rm11mr17244844pjb.147.1627596881035;
        Thu, 29 Jul 2021 15:14:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w22sm4623752pfn.188.2021.07.29.15.14.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 15:14:40 -0700 (PDT)
Message-ID: <61032850.1c69fb81.b63e8.e9c6@mx.google.com>
Date:   Thu, 29 Jul 2021 15:14:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.13
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.13.6-22-g42e97d352a41
Subject: stable-rc/queue/5.13 baseline: 150 runs,
 4 regressions (v5.13.6-22-g42e97d352a41)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 150 runs, 4 regressions (v5.13.6-22-g42e97d3=
52a41)

Regressions Summary
-------------------

platform                | arch  | lab          | compiler | defconfig      =
    | regressions
------------------------+-------+--------------+----------+----------------=
----+------------
bcm2837-rpi-3-b-32      | arm   | lab-baylibre | gcc-8    | bcm2835_defconf=
ig  | 1          =

beagle-xm               | arm   | lab-baylibre | gcc-8    | multi_v7_defcon=
fig | 1          =

imx6qp-sabresd          | arm   | lab-nxp      | gcc-8    | multi_v7_defcon=
fig | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.6-22-g42e97d352a41/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.6-22-g42e97d352a41
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      42e97d352a41c8db6d13042fc12414c758d5f7f3 =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig      =
    | regressions
------------------------+-------+--------------+----------+----------------=
----+------------
bcm2837-rpi-3-b-32      | arm   | lab-baylibre | gcc-8    | bcm2835_defconf=
ig  | 1          =


  Details:     https://kernelci.org/test/plan/id/6102ee82a7c691db635018fd

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.6-2=
2-g42e97d352a41/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-r=
pi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.6-2=
2-g42e97d352a41/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-r=
pi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/6102ee82a7c691d=
b63501904
        new failure (last pass: v5.13.5-223-g3a7649e5ffb5)
        1 lines

    2021-07-29T18:07:39.683193  kern  :alert : BUG: Bad rss-counter state m=
m:bd07a697 type:MM_FILEPAGES val:4155
    2021-07-29T18:07:39.684651  <8>[   13.118230] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>   =

 =



platform                | arch  | lab          | compiler | defconfig      =
    | regressions
------------------------+-------+--------------+----------+----------------=
----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6102f0ff0bfa2b4f0a5018d3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.6-2=
2-g42e97d352a41/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.6-2=
2-g42e97d352a41/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6102f0ff0bfa2b4f0a501=
8d4
        new failure (last pass: v5.13.5-223-g3a7649e5ffb5) =

 =



platform                | arch  | lab          | compiler | defconfig      =
    | regressions
------------------------+-------+--------------+----------+----------------=
----+------------
imx6qp-sabresd          | arm   | lab-nxp      | gcc-8    | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6102f238d9ddf34a795018c5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.6-2=
2-g42e97d352a41/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6qp-sabres=
d.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.6-2=
2-g42e97d352a41/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6qp-sabres=
d.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6102f238d9ddf34a79501=
8c6
        new failure (last pass: v5.13.5-223-g3a7649e5ffb5) =

 =



platform                | arch  | lab          | compiler | defconfig      =
    | regressions
------------------------+-------+--------------+----------+----------------=
----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/6102f1997c008c8b3d5018c2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.6-2=
2-g42e97d352a41/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banana=
pi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.6-2=
2-g42e97d352a41/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banana=
pi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6102f1997c008c8b3d501=
8c3
        new failure (last pass: v5.13.5-223-g3a7649e5ffb5) =

 =20
