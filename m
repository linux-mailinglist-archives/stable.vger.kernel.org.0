Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 075213D9483
	for <lists+stable@lfdr.de>; Wed, 28 Jul 2021 19:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbhG1Rpf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 13:45:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbhG1Rpf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Jul 2021 13:45:35 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B5DCC061757
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 10:45:33 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id m2-20020a17090a71c2b0290175cf22899cso5281006pjs.2
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 10:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=q8TVHF5dJh/G/0bqPDVhF9ilJjOsRH9lEKyLzi0v1cg=;
        b=1JvlsbBxYYkqPMFVrTJBA2BjjHUDtA3iQ0mYCKjHL6Rb5eQw41/gdiOVwJsj4C9GOJ
         ZCft0ALrw2xeWTBR46UEx1sJl6TUEXeJMJia+ZWr+kzp2TM5Sobmb8MZ6BQx0v+RQGzB
         TQgiwUFR56klthNHRf/3zdsfAq8oHeA50HHmB3DplvQZ4k09+sXddeGe1YkKHoCfn/wK
         YtIt8GTcBmQU9ETlTO08NehfebfVHH5Vp9Dk86ro3xPXhQY2L3/PH5sNbI0VgjWtB8PI
         089GR+/UEEhQxGF+37+jTsRuFga9JsnnuJrqL67Rg5hc2v9zp2Pb34awHWV/MbVMJ9Zf
         hh4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=q8TVHF5dJh/G/0bqPDVhF9ilJjOsRH9lEKyLzi0v1cg=;
        b=UjalEY1AEYeHcCxn1iWuckxJsdkZEaBbfs6qaegmKxkmvGz9naqq7v+rTTprV/pO9S
         Jp/c1FIiBs1f5EPCr1zTZALH/dBzKf8pTF36ogev/O22JBMgjtK4IGScFk79fkt3axe7
         jK+dRcp/7y15mRKrd0RN8P9fthFJY3h8yNSVWRZGod+JCbB3OH++k2Lo2Mq9yOPYk+gs
         VmBokYAxL+COvS5pkCQZSmbrwZq+FS/vvcBenjiegPEWaqH2pkITHIcjLwPaEEYO3mpI
         fvzlb/8xiNmLUAiZRPAohfbKSrtccmXVrwVGxAykBvWg+oVRvZshtBHAHHU9bAENpiD3
         5ejg==
X-Gm-Message-State: AOAM533VO/lqDZbU7b6k9xd4o36W6UsK62Z1Kl4ofjgMLA1uoqE/z9V7
        KqegBc2dMc38QlBe/sTR+N8QOGGUtqjxtWdJ
X-Google-Smtp-Source: ABdhPJwTXYqR/Ai9QCD8H6wRRClQSFtoKfYPXkIXGIfmYQbgYDlAFacPiZIQrdYmmBAZPqrXa7ae2A==
X-Received: by 2002:a17:902:ab45:b029:12c:17e1:f817 with SMTP id ij5-20020a170902ab45b029012c17e1f817mr721682plb.60.1627494332735;
        Wed, 28 Jul 2021 10:45:32 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c14sm383405pgv.86.2021.07.28.10.45.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 10:45:32 -0700 (PDT)
Message-ID: <610197bc.1c69fb81.3fb5e.17b7@mx.google.com>
Date:   Wed, 28 Jul 2021 10:45:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.136-1-gd23f64074e2a
Subject: stable-rc/queue/5.4 baseline: 156 runs,
 4 regressions (v5.4.136-1-gd23f64074e2a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 156 runs, 4 regressions (v5.4.136-1-gd23f6407=
4e2a)

Regressions Summary
-------------------

platform           | arch   | lab          | compiler | defconfig          =
          | regressions
-------------------+--------+--------------+----------+--------------------=
----------+------------
bcm2837-rpi-3-b-32 | arm    | lab-baylibre | gcc-8    | bcm2835_defconfig  =
          | 2          =

d2500cc            | x86_64 | lab-clabbe   | gcc-8    | x86_64_defconfig   =
          | 1          =

d2500cc            | x86_64 | lab-clabbe   | gcc-8    | x86_64_defcon...6-c=
hromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.136-1-gd23f64074e2a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.136-1-gd23f64074e2a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d23f64074e2a81c040a4aafc571728678baa0311 =



Test Regressions
---------------- =



platform           | arch   | lab          | compiler | defconfig          =
          | regressions
-------------------+--------+--------------+----------+--------------------=
----------+------------
bcm2837-rpi-3-b-32 | arm    | lab-baylibre | gcc-8    | bcm2835_defconfig  =
          | 2          =


  Details:     https://kernelci.org/test/plan/id/61015d1aa4e7c7db67501917

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.136-1=
-gd23f64074e2a/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rp=
i-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.136-1=
-gd23f64074e2a/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rp=
i-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/61015d1aa4e7c7d=
b6750191e
        new failure (last pass: v5.4.135-108-g3bc4fefb0124)
        4 lines

    2021-07-28T13:34:57.681981  kern  :alert : 8<--- cut here ---
    2021-07-28T13:34:57.718647  kern  :alert : Unable to handle kernel NULL=
 pointer dereference at virtual address 00000000
    2021-07-28T13:34:57.720191  <8>[   13.744305] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>
    2021-07-28T13:34:57.721012  kern  :alert : pgd =3D c1eb881b   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61015d1aa4e7c7d=
b6750191f
        new failure (last pass: v5.4.135-108-g3bc4fefb0124)
        44 lines

    2021-07-28T13:34:57.724508  kern  :alert : [00000000] *pgd=3D2af19835, =
*pte=3D00000000, *ppte=3D00000000
    2021-07-28T13:34:57.764368  kern  :emerg : Internal error: Oops: 817 [#=
1] ARM
    2021-07-28T13:34:57.765960  kern  :emerg : Process udevadm (pid: 100, s=
tack limit =3D 0xc0c050d3)
    2021-07-28T13:34:57.766719  <8>[   13.787914] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D44>   =

 =



platform           | arch   | lab          | compiler | defconfig          =
          | regressions
-------------------+--------+--------------+----------+--------------------=
----------+------------
d2500cc            | x86_64 | lab-clabbe   | gcc-8    | x86_64_defconfig   =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/61015e05548bcc558a501901

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.136-1=
-gd23f64074e2a/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.136-1=
-gd23f64074e2a/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61015e05548bcc558a501=
902
        failing since 16 days (last pass: v5.4.130-4-g2151dbfa7bb2, first f=
ail: v5.4.131-344-g7da707277666) =

 =



platform           | arch   | lab          | compiler | defconfig          =
          | regressions
-------------------+--------+--------------+----------+--------------------=
----------+------------
d2500cc            | x86_64 | lab-clabbe   | gcc-8    | x86_64_defcon...6-c=
hromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/610161751e5ef7d0245018f1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.136-1=
-gd23f64074e2a/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/base=
line-d2500cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.136-1=
-gd23f64074e2a/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/base=
line-d2500cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610161751e5ef7d024501=
8f2
        failing since 16 days (last pass: v5.4.130-4-g2151dbfa7bb2, first f=
ail: v5.4.131-344-g7da707277666) =

 =20
