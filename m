Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6808842CFB4
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 02:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbhJNA4O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 20:56:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbhJNA4O (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Oct 2021 20:56:14 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 530E9C061570
        for <stable@vger.kernel.org>; Wed, 13 Oct 2021 17:54:10 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id oa4so3550543pjb.2
        for <stable@vger.kernel.org>; Wed, 13 Oct 2021 17:54:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2DogBDU4EWrZZcBkD56XIZ+FKJSqHBD9RsNIICPLCyQ=;
        b=m+peWWNcpc3vc78UPS0M6l71lb1jfN5wIZJv46R05cpmIolXtJWNE451d/eXmVJj5t
         nfKZhnm78XENSnW/byJMsDgq/ZaRorfZ4tQ/lNd9tpp6im21MnIKKMqpMT681aSoGubE
         F07IfPOKMjcInoWDIm8w5gEin5s/Nd6VEp0aqDZa/kuPKu1RwGRUorb5yd/+NQsV4d+2
         0DspeAD7iEx0plJ5am/Sz9Hz6klqMGn+Xs35O0zvwHBSv5sTwk8NuZ5Bo6bme0wTGcal
         dS22SpW40FJMcVgB7mfe3zEzBmTm8kGV0Le98usy+EvRfizeYuhwuLy1tknawX1uS6tK
         q6GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2DogBDU4EWrZZcBkD56XIZ+FKJSqHBD9RsNIICPLCyQ=;
        b=tIk+omsIrnx21U2sUwoYkGvx7/ZhJs0od9wed5M/0yoXLenM4qhQw056JR0/4FqtLR
         XJ96LQl1neT/kTz4wZIMoK2qOlWRKP2xhj5U4Xiy7ldOkpF68832Kg+x70xBl6rGOjHd
         AjkILtriB2f69AVf0EqZvT/HZoStNp8SVo/9DqXS54PaEmL+tAvzmrCBXAvdU/D7WziJ
         1bh3p/bqxPNYAULsBgAkqVGjgD6xkBNHf2iUEqxmSavlLCuc45jl7UI24UFdmduO78bv
         b87nkz11wLNDNzOLVvqXWiRh40eNIqMBP6KznhvWD3i7vAwWBQNX0nbaX38v90ewd/h1
         BGAA==
X-Gm-Message-State: AOAM532GK5ma4Cvx73tXVcgTNpR0qUUwr4IZKEhdMpafJCjL4acNHIWA
        fY4xPHolVNwAlGiaIFpB6RmBg3/F+lbfRZrK
X-Google-Smtp-Source: ABdhPJxLxJ2um7Q0rmi7prHLJIK9mZkL0l5V0ECw7LXm/71+pqy5yMC9DMf/0kTH1ovvnBw6fLBAAA==
X-Received: by 2002:a17:90a:a60e:: with SMTP id c14mr17176958pjq.70.1634172849617;
        Wed, 13 Oct 2021 17:54:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t9sm7024880pjq.20.2021.10.13.17.54.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 17:54:09 -0700 (PDT)
Message-ID: <61677fb1.1c69fb81.23fb3.512a@mx.google.com>
Date:   Wed, 13 Oct 2021 17:54:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.286-25-gf650ddaf7cb6
Subject: stable-rc/queue/4.9 baseline: 73 runs,
 3 regressions (v4.9.286-25-gf650ddaf7cb6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 73 runs, 3 regressions (v4.9.286-25-gf650ddaf=
7cb6)

Regressions Summary
-------------------

platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.286-25-gf650ddaf7cb6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.286-25-gf650ddaf7cb6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f650ddaf7cb6cee2d9b6b5f18e82d489d3e4f036 =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/616744da5b74bee60808fae3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.286-2=
5-gf650ddaf7cb6/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.286-2=
5-gf650ddaf7cb6/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616744da5b74bee60808f=
ae4
        failing since 333 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/616745069ac0dbf52b08fab8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.286-2=
5-gf650ddaf7cb6/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.286-2=
5-gf650ddaf7cb6/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616745069ac0dbf52b08f=
ab9
        failing since 333 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/616744f1b78dd9a14508fab9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.286-2=
5-gf650ddaf7cb6/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.286-2=
5-gf650ddaf7cb6/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616744f1b78dd9a14508f=
aba
        failing since 333 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
