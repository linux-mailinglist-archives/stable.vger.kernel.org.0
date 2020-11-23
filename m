Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A127C2C0E21
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 15:51:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728972AbgKWOuI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 09:50:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728654AbgKWOuH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Nov 2020 09:50:07 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3630AC0613CF
        for <stable@vger.kernel.org>; Mon, 23 Nov 2020 06:50:06 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id n137so5073296pfd.3
        for <stable@vger.kernel.org>; Mon, 23 Nov 2020 06:50:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=NzxYbnLhxXnKwcbY2JnglNS/lzwEh+nxVESd69zVfN0=;
        b=eOvS0Jyd7QDmYYiBVLxA3a4S+kBFFylyKBcexn3j4loM4Wf2N5okgiJrfhswcpF7cj
         dNnQSrkxw/EVKaS2veKl8V2hQcPir/bft+v4nAPIxhtB1CDxGwgWqqqs/Syn798sMKA/
         yCF5F4uC4/JVs46isc+a6biYEPDcMH5AQszeqF8qDxsFc0JK6Uk/vCE3txAdD0h0crNG
         i5oEbKHFCnrxZIFPRd5HHLdTl+ABhe8lCdIQErsPX3BWKgSgdHw276i9pVxoe2VoPgjE
         gd3OgNKrn0aRIi2HQbUcPPAa/YRP5ivsztD9NPt9MD3EuldbENjc7KRWzMl7CUMZm7Sv
         8UbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=NzxYbnLhxXnKwcbY2JnglNS/lzwEh+nxVESd69zVfN0=;
        b=kjxJXAPIdZuS/uvcymf748l1yhLhON+NLZ+2x2GKjXFy1XMaqNENwcRS7jRFPJzkUW
         luiHywMHxDKX3Y/keohJVZvsjE/rCcO3xsnCLLKKA2GmEEzlKOtZAVbzzriO+dGueihK
         mhzQaVYjFPBJkE7Hc0X3rPYvSCB7d3NvjUPZQMpWl+W05TGfHwQfSQtL+SBeR6mhbjhY
         SbVDiKqee6MMXjL44eqVfsAODNmukuMBv4nfouNaJPkUB0SiKGugrUVrsELArT8rSkU+
         NhUegWk3qdCqyP4yJQt/R8yndnRn/9MqrWlYhe5QqrwLSLNroKEhBCl9qgTLd7QbFIir
         mwzQ==
X-Gm-Message-State: AOAM532wTHJeQIE//3Z89SkoZKxcGee8zNUsDpvzTDVNl9llsXuY/pL0
        urD1yhY89AterjijludxW5EHd2tHaN+cSQ==
X-Google-Smtp-Source: ABdhPJzkMufB/6YoPCOPKu0GaRbLrIXUvKJe6dcM+aZUIKj72DOx0n1k92BFBzs4UOSVSBQAhDpUzg==
X-Received: by 2002:a63:f50f:: with SMTP id w15mr26696525pgh.403.1606143005424;
        Mon, 23 Nov 2020 06:50:05 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g4sm11403621pgu.81.2020.11.23.06.50.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 06:50:04 -0800 (PST)
Message-ID: <5fbbcc1c.1c69fb81.39dd8.8e3e@mx.google.com>
Date:   Mon, 23 Nov 2020 06:50:04 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.245-46-g900857924fc46
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 91 runs,
 5 regressions (v4.9.245-46-g900857924fc46)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 91 runs, 5 regressions (v4.9.245-46-g90085792=
4fc46)

Regressions Summary
-------------------

platform              | arch  | lab          | compiler | defconfig        =
   | regressions
----------------------+-------+--------------+----------+------------------=
---+------------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig  =
   | 1          =

qemu_arm-versatilepb  | arm   | lab-baylibre | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb  | arm   | lab-broonie  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb  | arm   | lab-cip      | gcc-8    | versatile_defconf=
ig | 1          =

r8a7795-salvator-x    | arm64 | lab-baylibre | gcc-8    | defconfig        =
   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.245-46-g900857924fc46/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.245-46-g900857924fc46
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      900857924fc46d147750d0020a52b55d89b527e4 =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig        =
   | regressions
----------------------+-------+--------------+----------+------------------=
---+------------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig  =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb94e7c94f26d8bed8d907

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.245-4=
6-g900857924fc46/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5=
d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.245-4=
6-g900857924fc46/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5=
d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbb94e7c94f26d8bed8d=
908
        failing since 25 days (last pass: v4.9.240-139-gd719c4ad8056, first=
 fail: v4.9.240-139-g65bd9a74252c) =

 =



platform              | arch  | lab          | compiler | defconfig        =
   | regressions
----------------------+-------+--------------+----------+------------------=
---+------------
qemu_arm-versatilepb  | arm   | lab-baylibre | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb94a4c10af0bcb4d8d906

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.245-4=
6-g900857924fc46/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.245-4=
6-g900857924fc46/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbb94a4c10af0bcb4d8d=
907
        failing since 9 days (last pass: v4.9.243-16-gd8d67e375b0a, first f=
ail: v4.9.243-25-ga01fe8e99a22) =

 =



platform              | arch  | lab          | compiler | defconfig        =
   | regressions
----------------------+-------+--------------+----------+------------------=
---+------------
qemu_arm-versatilepb  | arm   | lab-broonie  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb94a1c10af0bcb4d8d903

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.245-4=
6-g900857924fc46/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.245-4=
6-g900857924fc46/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbb94a1c10af0bcb4d8d=
904
        failing since 9 days (last pass: v4.9.243-16-gd8d67e375b0a, first f=
ail: v4.9.243-25-ga01fe8e99a22) =

 =



platform              | arch  | lab          | compiler | defconfig        =
   | regressions
----------------------+-------+--------------+----------+------------------=
---+------------
qemu_arm-versatilepb  | arm   | lab-cip      | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb94de899e8429c1d8d91b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.245-4=
6-g900857924fc46/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.245-4=
6-g900857924fc46/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbb94de899e8429c1d8d=
91c
        failing since 9 days (last pass: v4.9.243-16-gd8d67e375b0a, first f=
ail: v4.9.243-25-ga01fe8e99a22) =

 =



platform              | arch  | lab          | compiler | defconfig        =
   | regressions
----------------------+-------+--------------+----------+------------------=
---+------------
r8a7795-salvator-x    | arm64 | lab-baylibre | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbb9422acb00d439fd8d8fd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.245-4=
6-g900857924fc46/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvat=
or-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.245-4=
6-g900857924fc46/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvat=
or-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbb9422acb00d439fd8d=
8fe
        failing since 5 days (last pass: v4.9.243-24-ga8ede488cf7a, first f=
ail: v4.9.243-77-g36ec779d6aa89) =

 =20
