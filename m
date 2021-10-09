Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60F87427DFE
	for <lists+stable@lfdr.de>; Sun, 10 Oct 2021 00:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230503AbhJIWzk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Oct 2021 18:55:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230296AbhJIWzk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Oct 2021 18:55:40 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4F00C061570
        for <stable@vger.kernel.org>; Sat,  9 Oct 2021 15:53:42 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id k23-20020a17090a591700b001976d2db364so10522088pji.2
        for <stable@vger.kernel.org>; Sat, 09 Oct 2021 15:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=g3UkiaPSm1f4KeoDH7l6cyf2/qrISY7ru435KrTAkz8=;
        b=Ws+1zkS83sOqjCaLqBHikTt/dN4auQVHVkZ9ZVA3Z4902JD+0QNXgXKZqBy3loZGDh
         OyW4E5Pab1Mit2vira/FhZ2oDTQji0qmj71gJLdMtDBEZpfSA1tEFFBP/YYPGRD8PHrX
         J/ebDdwkDTVNZMB57swJmACuvqusGXUb+eOfc+znq2MaYiR17MvdwNgBNgu3I6oOKrAF
         8GpLe6uIPBDE4whzANpwJwIUkigLmVYaaKz3YTaELQRqKryjmquMdwAnSK6nL4PqN3mv
         khghShbalA2NG8Q5i7pWh1fVXBo3+USyTuIiaX19lx+vev87WNSH9prVZU9A5MD/YVA2
         8mjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=g3UkiaPSm1f4KeoDH7l6cyf2/qrISY7ru435KrTAkz8=;
        b=nFG68bHFACp09bBfUggRs4p0b5pbCDFaTpwXwwXHPP9uY6/wWVhDT8U2Y5TYujGkxY
         2Kmmvulw41uHzyOQCz9v6D3QNx+4x9Y0bHC9PXJWuvVCH92CEO35tn5RZMjBB89HupA7
         DDfG1+wEPCSpmSv+L/f6ag+znOItxlNr2XE8Kw6LGQ19c1Lnl0WdqtfqMdZAE7CPAVaL
         cuUJytklhnoYqIUicguOv56ZyNp2+YXFXv6z5M2vtSkU+jP65+zylLVDlpVNVL0HiXmq
         dvEUq2qAu6BEidSboKvMIM3KOMUkaQ2Ru7u3+T5gTBZpS6IoIZ0FFyvIyzcyvyXGZi8N
         Vzcg==
X-Gm-Message-State: AOAM533VytH5bNE95bW/pRXgaDMGwDKl1NjFEMe/P5LSbnrdegJFJ1pY
        AKsOLCFGyeRt/qr3eIjAXqio4MZH3k5eQtNj
X-Google-Smtp-Source: ABdhPJzTDTxx2YTnFCMRyoNyMUDBpQNzbdHKZHpLi+FZLLFVlBVvf2hoRrBouWdS1GxvIL8vaS5NCQ==
X-Received: by 2002:a17:90a:9317:: with SMTP id p23mr20766388pjo.151.1633820021969;
        Sat, 09 Oct 2021 15:53:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z9sm2891538pji.42.2021.10.09.15.53.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 15:53:41 -0700 (PDT)
Message-ID: <61621d75.1c69fb81.a993c.82f6@mx.google.com>
Date:   Sat, 09 Oct 2021 15:53:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.14.11-33-g7deec6e987b4
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.14
Subject: stable-rc/queue/5.14 baseline: 121 runs,
 3 regressions (v5.14.11-33-g7deec6e987b4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 121 runs, 3 regressions (v5.14.11-33-g7deec6=
e987b4)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig           |=
 regressions
------------------+------+---------------+----------+---------------------+=
------------
beagle-xm         | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig  |=
 1          =

beagle-xm         | arm  | lab-baylibre  | gcc-8    | omap2plus_defconfig |=
 1          =

rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig  |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.11-33-g7deec6e987b4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.11-33-g7deec6e987b4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7deec6e987b436512480965e9e015ead6aee5372 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig           |=
 regressions
------------------+------+---------------+----------+---------------------+=
------------
beagle-xm         | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig  |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6161e45e9fe73c718c99a2f7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.11-=
33-g7deec6e987b4/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.11-=
33-g7deec6e987b4/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6161e45e9fe73c718c99a=
2f8
        failing since 1 day (last pass: v5.14.10-44-gcee0088c496d, first fa=
il: v5.14.10-48-g292b9f8998a9) =

 =



platform          | arch | lab           | compiler | defconfig           |=
 regressions
------------------+------+---------------+----------+---------------------+=
------------
beagle-xm         | arm  | lab-baylibre  | gcc-8    | omap2plus_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6161e9d8065ef6949799a2f0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.11-=
33-g7deec6e987b4/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.11-=
33-g7deec6e987b4/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6161e9d8065ef6949799a=
2f1
        failing since 1 day (last pass: v5.14.10-44-gcee0088c496d, first fa=
il: v5.14.10-48-g292b9f8998a9) =

 =



platform          | arch | lab           | compiler | defconfig           |=
 regressions
------------------+------+---------------+----------+---------------------+=
------------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig  |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6161ffede9c2639e2a99a306

  Results:     69 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.11-=
33-g7deec6e987b4/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.11-=
33-g7deec6e987b4/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.cros-ec-keyb-probed: https://kernelci.org/test/case/id/=
6161ffeee9c2639e2a99a33b
        new failure (last pass: v5.14.10-48-g292b9f8998a9)

    2021-10-09T20:47:17.238652  /lava-4686210/1/../bin/lava-test-case
    2021-10-09T20:47:17.261378  <8>[   10.527433] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-keyb-probed RESULT=3Dfail>   =

 =20
