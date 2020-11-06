Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC8362A992F
	for <lists+stable@lfdr.de>; Fri,  6 Nov 2020 17:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbgKFQMI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Nov 2020 11:12:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725875AbgKFQMI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Nov 2020 11:12:08 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21D55C0613CF
        for <stable@vger.kernel.org>; Fri,  6 Nov 2020 08:12:08 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id q10so1768032pfn.0
        for <stable@vger.kernel.org>; Fri, 06 Nov 2020 08:12:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FDuo9C4cjp5dPGMp1vg+wD3Gc9Npka7yP1Z+beryN+k=;
        b=XIbaHhLSWdX7rOhkxJY/hyeCvqQdZZKBn530uHwIb7F4JLr5HYHQWtYeh5eGLzpeUo
         9tF8nS6lZSA/GFkSaJVCg0kibKrV+dvSFrlYJ8mbRha/yG5y7xdLdMkQtVZ+JW2O2Dj9
         6xCUMludrqkNCHE9BO3OtROCJ5/VjPb6NkXlPpXVT63rNw/qDHycYrPbWfqeY5Ezq4cx
         LL2V3Bw1h0XWyGS5i25hfY8OsINtoCqTZiOfTwu8Rxz4F9L6ZU1SQJkUQcuHJfbAXriK
         6sy7N4t7VsgJdiG/elCPJzrp/jQXxEDputvLz0ER08fGPIK235tArrzRK7tLNcG6h1kr
         k9jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FDuo9C4cjp5dPGMp1vg+wD3Gc9Npka7yP1Z+beryN+k=;
        b=hy3N2IojBgHA4ajnVIKWVMr0Zc4rcU2XtkZTrYbLv7Mv3RE21d2c9poXNolR0wKbEh
         W7wWoKO5NVoaIHILx6QLkIyy/EvzFVYPDhtkdvZhxFhUBrRSYG95MjAmPX94ISYJawVL
         srk982/YCKKPPoLrTaECA2YW2M8Oufh5TpYpvqKSuFhyIatpCpIlHZGr0mAFDV9GKdj6
         YXippJ0+PEj5UkR1u+bkNp2a6a13VWQq5XpwGAhIp2ZoezZ3KSI66nynt6gJTp8BAgei
         lAJ0KGVxJOZ1r8ExjBmrNTanMGlnQqSTwvHT59VkAIfhymrjOtKD1d31WerOTtzgCTcC
         vt5w==
X-Gm-Message-State: AOAM533zbonHYxihLe8LM6dUQ1F7ESVpUXqFac/BQbLu+nuBGoC53H8L
        mnNhDn+oZyDUqZNlVWmv45tSr92P4ErdRA==
X-Google-Smtp-Source: ABdhPJxo8/EJ5n52MqK8harbrbtV+L25Cc2rMzmFFP4GKPD6+9JSBcdjZ70XVD51LiJ4Q2lS0yCvNw==
X-Received: by 2002:a17:90a:6b04:: with SMTP id v4mr276499pjj.101.1604679127417;
        Fri, 06 Nov 2020 08:12:07 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g14sm2682204pfk.90.2020.11.06.08.12.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2020 08:12:06 -0800 (PST)
Message-ID: <5fa575d6.1c69fb81.59ac2.4a1c@mx.google.com>
Date:   Fri, 06 Nov 2020 08:12:06 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.75-10-g67af28cd92c3
Subject: stable-rc/queue/5.4 baseline: 200 runs,
 2 regressions (v5.4.75-10-g67af28cd92c3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 200 runs, 2 regressions (v5.4.75-10-g67af28cd=
92c3)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig         =
 | regressions
----------------------+------+--------------+----------+-------------------=
-+------------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig   =
 | 1          =

stm32mp157c-dk2       | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.75-10-g67af28cd92c3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.75-10-g67af28cd92c3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      67af28cd92c335d52d54b9a5652b87df0f217dde =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig         =
 | regressions
----------------------+------+--------------+----------+-------------------=
-+------------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig   =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/5fa54278adb109f4a3db8866

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.75-10=
-g67af28cd92c3/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4=
_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.75-10=
-g67af28cd92c3/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4=
_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa54278adb109f4a3db8=
867
        failing since 8 days (last pass: v5.4.72-409-gbbe9df5e07cf, first f=
ail: v5.4.72-409-ga6e47f533653) =

 =



platform              | arch | lab          | compiler | defconfig         =
 | regressions
----------------------+------+--------------+----------+-------------------=
-+------------
stm32mp157c-dk2       | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/5fa545b43ba3117fa6db8871

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.75-10=
-g67af28cd92c3/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp15=
7c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.75-10=
-g67af28cd92c3/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp15=
7c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa545b43ba3117fa6db8=
872
        failing since 11 days (last pass: v5.4.72-54-gc97bc0eb3ef2, first f=
ail: v5.4.72-402-g22eb6f319bc6) =

 =20
