Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF4384165FB
	for <lists+stable@lfdr.de>; Thu, 23 Sep 2021 21:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242947AbhIWTfF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Sep 2021 15:35:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242976AbhIWTfD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Sep 2021 15:35:03 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39A8FC061764
        for <stable@vger.kernel.org>; Thu, 23 Sep 2021 12:33:25 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id bj3-20020a17090b088300b0019e6603fe89so4135626pjb.4
        for <stable@vger.kernel.org>; Thu, 23 Sep 2021 12:33:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=13b1YPYBnfNEOBhizfFkbElvmEayhhNrYpZKBC6oaM4=;
        b=6mLXCw+42PTc3dBv4ZKiWYOSuPfRYbgkaYMAP7ee0Y0pBA9O6RIIByKkFUtSyscS0v
         B3qy0wdQn7HmWG2ZoqOIu0L9H6wil1no8+W8Ek9FEU7cYqTIBQNruBE2bFYrsgut4o8k
         pAjbWVXIdHpkosJv/Q0ZMNGyd2cIiwaSz/bYp6I+LBsqjjNFKczy4hTYts04SNr1NMfi
         awVa45SIsqSRP6JT0tc3VncDnIeIW466wmpuyypia8uzq9b+4tP9xTba+2cC9NpzVeUd
         ku33AVtc3UpDHCVmnOqJMmuc+2lExdmfrU20rnI4xq70YuCP5NLY+QLRBaZFAqdH14XK
         sW6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=13b1YPYBnfNEOBhizfFkbElvmEayhhNrYpZKBC6oaM4=;
        b=nNeJm0gCTaFDnhZtipVAtJmBF+jFDTTI3qgOfN9XQQLG2y+8ZIRS7SmSH9v4dFDQsy
         2C36tsYqbCC9NDYaoZNZWACoT8+phzoU+XNUG62s0XrJExpUc4BElKSAQmMbA6qJB5Qn
         HPgiI0cbOWL/p7wK2v3a0lxdnK7QLzVhY1Qc6030kOwtd7LPUAGZe5W+zndhBpGYB3Fk
         lZ6NbT2C6mIfH998k+1iq0b/CEhjmRu/CyHo4CD1SM2kOSXfrW9JW33uf97DgKv6LLct
         ZjvgXRgeV6PzPzFzQ/soUG83KyUdqJpbV7viHqM0ROVNkBb2uAYmDaWHh3kikPx2+wwX
         /3UQ==
X-Gm-Message-State: AOAM533yuvnag6W2UsRsbwSk1UP/QrRWXyr/bk3RwhIlFumaie47H+KX
        MWyF27OBUfHdKaI8ktTKA7Qn2vWxLpsVnpjY
X-Google-Smtp-Source: ABdhPJxtKz9WBFeYd612sFU3vJCb8ovqGbVBbCXMt2t6+Gxf6UC1jWIq28EcwC7E4AfBpoBlePXwOw==
X-Received: by 2002:a17:902:7e85:b0:13c:957d:5620 with SMTP id z5-20020a1709027e8500b0013c957d5620mr5626909pla.48.1632425604326;
        Thu, 23 Sep 2021 12:33:24 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p9sm1673903pfn.7.2021.09.23.12.33.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 12:33:24 -0700 (PDT)
Message-ID: <614cd684.1c69fb81.dc55f.66bd@mx.google.com>
Date:   Thu, 23 Sep 2021 12:33:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.207-9-gae235b7e93e5
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 98 runs,
 3 regressions (v4.19.207-9-gae235b7e93e5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 98 runs, 3 regressions (v4.19.207-9-gae235b7=
e93e5)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.207-9-gae235b7e93e5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.207-9-gae235b7e93e5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ae235b7e93e586f45061383842390099f889c74e =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/614c9e17fac3c43dfa99a2e4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.207=
-9-gae235b7e93e5/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.207=
-9-gae235b7e93e5/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614c9e17fac3c43dfa99a=
2e5
        failing since 313 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/614cd158831440418099a2de

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.207=
-9-gae235b7e93e5/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.207=
-9-gae235b7e93e5/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614cd158831440418099a=
2df
        failing since 313 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/614c9e481f4c4411e299a2f1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.207=
-9-gae235b7e93e5/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.207=
-9-gae235b7e93e5/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614c9e481f4c4411e299a=
2f2
        failing since 313 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
