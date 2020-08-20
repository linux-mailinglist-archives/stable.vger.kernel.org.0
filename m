Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98E4424BFF1
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731353AbgHTN7M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:59:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730772AbgHTN5e (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 09:57:34 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79B15C061385
        for <stable@vger.kernel.org>; Thu, 20 Aug 2020 06:57:34 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id m71so1077750pfd.1
        for <stable@vger.kernel.org>; Thu, 20 Aug 2020 06:57:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JOgILcxJsVsVSUzdmSi7x+ORSfK5q2gmPxUAXB+ntAY=;
        b=Y/Yhqtgvj8N/9gYbx1p6rTeXtTdtGgBIASnHEHiFdRdwT4rthJr343an2L+NGaftYV
         9QMbP+uytJd0ADcEpkOuAAtKGJdY2vkKEfo9T5CtXRAKze2IH4eWtKvvC7dwowZHi65w
         wz6/+Ja4YBbEVgWBfnYj1wft8QWdVT+MZfuuqBtAisaVWL0WV2XIQYndFziyuevYLVVk
         HckL4reSFZPqjgoLF9oSEw4g8+bilJEjBsYpaaGkVL3WpHPGcLOixsLQjKwaQQg0Yfwx
         r3DPWe9UgvdChuXBedUYX4i80o/agiGzm+kn/RpzOVGMxesdztnho3h7ocsrqnGbJdde
         ScKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JOgILcxJsVsVSUzdmSi7x+ORSfK5q2gmPxUAXB+ntAY=;
        b=Xm0rriJTVWGMDFzMZcqpFHZ/uMELDziZg9rtuMg2S6VLfG9RHLDMJTY0YOSJiUZ6T6
         h9/WlvdtiwYNWDy8niY9YCjT2fesQgmqmk3HtitiYUYfNVItGnGkUMnsnNi8upKS+Otl
         frMWurylb72vGEq12XZbjrXpPIro3o7i/h7xlBvQJK1HLfid1ZGgBAirDIVKJsZgMxi0
         VAUAhpYcINj3sM5BjRxpkw4dy3bLoQ4omPH0N0H4iEMOMwostWp8Xdbctqjaw99Ja+H3
         1+uaAHKjtiwBM9yQwUXFVbv5yvnERbHtaSYFZ3/wuqEGDSN7oV4+culdqBFfaxKt7KgR
         D/xw==
X-Gm-Message-State: AOAM533V+/eIi+XUGct9VW/7x0mDImtEPPEWYx1NqYgSUGbAgTtexIQl
        l85F31GZiYCM0wUBcyS4Y8zXmWSUrPHV9g==
X-Google-Smtp-Source: ABdhPJwY5eyO9EtbXA/IWzamTBR/3jumaeCg2p3aduO8ShZXAi8VQ0sDisFYlBRE7qvJhd/hNJM3ug==
X-Received: by 2002:aa7:9357:: with SMTP id 23mr2347216pfn.278.1597931851040;
        Thu, 20 Aug 2020 06:57:31 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x23sm3006985pfi.60.2020.08.20.06.57.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2020 06:57:30 -0700 (PDT)
Message-ID: <5f3e814a.1c69fb81.cf197.78bf@mx.google.com>
Date:   Thu, 20 Aug 2020 06:57:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.59-153-g6793ee834d88
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 184 runs,
 2 regressions (v5.4.59-153-g6793ee834d88)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 184 runs, 2 regressions (v5.4.59-153-g6793e=
e834d88)

Regressions Summary
-------------------

platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =

bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 3/4    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.59-153-g6793ee834d88/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.59-153-g6793ee834d88
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6793ee834d88110102e15d8b341347c80c91a79b =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f3e4df1d1fc03c2b5d99a46

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.59-=
153-g6793ee834d88/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama=
5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.59-=
153-g6793ee834d88/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama=
5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f3e4df1d1fc03c2b5d99=
a47
      failing since 130 days (last pass: v5.4.30-54-g6f04e8ca5355, first fa=
il: v5.4.30-81-gf163418797b9)  =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f3e48acc6e7f8bea5d99a3d

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.59-=
153-g6793ee834d88/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.59-=
153-g6793ee834d88/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f3e48acc6e7f8be=
a5d99a3f
      new failure (last pass: v5.4.59-75-gbdc7345fed30)
      2 lines

    2020-08-20 09:55:40.118000  / # =

    2020-08-20 09:55:40.129000  =

    2020-08-20 09:55:40.232000  / # #
    2020-08-20 09:55:40.241000  #
    2020-08-20 09:55:41.500000  / # export SHELL=3D/bin/sh
    2020-08-20 09:55:41.511000  export SHELL=3D/bin/sh
    2020-08-20 09:55:43.011000  / # . /lava-9867/environment
    2020-08-20 09:55:43.021000  . [   27.706785] hwmon hwmon1: Undervoltage=
 detected!
    2020-08-20 09:55:43.022000  /lava-9867/environment
    2020-08-20 09:55:45.729000  / # /lava-9867/bin/lava-test-runner /lava-9=
867/0
    ... (10 line(s) more)
      =20
