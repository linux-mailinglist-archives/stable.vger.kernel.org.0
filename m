Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0073C4006
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 01:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbhGKXrC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 19:47:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhGKXrC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 19:47:02 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B52D0C0613DD
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 16:44:12 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id p4-20020a17090a9304b029016f3020d867so9468904pjo.3
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 16:44:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=X7Jvic7VtXJLVBJDlFdqGqzRx2CPZSO0/tD9QZYIXhA=;
        b=UngsztQ58Hj6SoNMR89X2oJTvispqzMU3aQ2c1NPPIUZwLs5C9+q4lqJaW6nAf8Nhu
         OWA2UG8y/58/jQWAF2FuZ/MnqilgLikgaLP9hDqnFxQiNfl5Q7TYfLpeZfwpeCNOyJjU
         UKLM2fqDVyyw/fWkeUbSwOUkmowsvCosHBmHVxIZlbFUS7uLghc7ssqppzaHdfChDPyl
         8gDgtd6jKo9qveYysWDluQ2N4OLXOavVGWi782gAi9g3nQmY4z7nc9Lglb3rA/TN+Vy/
         lZtuDaFOovGt7QwP4MQVcvPrABOrZ68d5bpctfwn+63ikHWh3uWZ7KnZVFDul9QR2+lh
         MCgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=X7Jvic7VtXJLVBJDlFdqGqzRx2CPZSO0/tD9QZYIXhA=;
        b=C1sUVJ5f71WO2ifNOK0SNA2juLQse8CY5oAFwS/Rsx877d6Cm8XX/hzsOJUxcqUKWr
         pIcLSXejZ5uHDfLUf4FNki5wCkum/DxecJ2bcOnimdGNSH2xmzBLoftQwPBo8UIQS0XM
         yl1jJ1lGj5P7qka7vU1HvPDYgK9ZG10BnpPCIbSuWBG2dHxfRJNg3JL36Qc1nJsXeY9d
         zwOrSW4TAWAPNthQFLgu/1/BQrPWhUKnqOKWFpEefDXhOl0AmSEbGjP4LTvzAMQZQmiV
         gsbqQWPat0Czb03WXnCXQmIu9F80Q9swRpbAuQjoQfbGkialPVmLv++U97W86rrxkcQG
         jjyA==
X-Gm-Message-State: AOAM530X36wjj5P1P2G2mW/yuZ6k9lzMhKW0E4AoZZZ/Y/BWLrToTbxt
        MMYWKovpxGuV12AauSVM0rqcjXYDGBxkNuNY
X-Google-Smtp-Source: ABdhPJyNs6A1nba9yb9PItgMAmGxiYde3beYgx3AF71dXVJ65GGtTC5CQBv0HoEKE8GPUKzpQxvyew==
X-Received: by 2002:a17:90a:6c61:: with SMTP id x88mr11641767pjj.122.1626047051953;
        Sun, 11 Jul 2021 16:44:11 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i1sm5558991pfo.37.2021.07.11.16.44.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jul 2021 16:44:11 -0700 (PDT)
Message-ID: <60eb824b.1c69fb81.9bc6b.efec@mx.google.com>
Date:   Sun, 11 Jul 2021 16:44:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.49-594-gdb2c2c1f4b16e
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 184 runs,
 4 regressions (v5.10.49-594-gdb2c2c1f4b16e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 184 runs, 4 regressions (v5.10.49-594-gdb2=
c2c1f4b16e)

Regressions Summary
-------------------

platform   | arch   | lab           | compiler | defconfig                 =
   | regressions
-----------+--------+---------------+----------+---------------------------=
---+------------
d2500cc    | x86_64 | lab-clabbe    | gcc-8    | x86_64_defconfig          =
   | 1          =

d2500cc    | x86_64 | lab-clabbe    | gcc-8    | x86_64_defcon...6-chromebo=
ok | 1          =

hip07-d05  | arm64  | lab-collabora | gcc-8    | defconfig                 =
   | 1          =

imx8mp-evk | arm64  | lab-nxp       | gcc-8    | defconfig                 =
   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.49-594-gdb2c2c1f4b16e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.49-594-gdb2c2c1f4b16e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      db2c2c1f4b16ef2ad3a1ee515ea71f70579f4aee =



Test Regressions
---------------- =



platform   | arch   | lab           | compiler | defconfig                 =
   | regressions
-----------+--------+---------------+----------+---------------------------=
---+------------
d2500cc    | x86_64 | lab-clabbe    | gcc-8    | x86_64_defconfig          =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb4fc586abb46284117970

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
9-594-gdb2c2c1f4b16e/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d250=
0cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
9-594-gdb2c2c1f4b16e/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d250=
0cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb4fc586abb46284117=
971
        failing since 0 day (last pass: v5.10.49, first fail: v5.10.49-581-=
g85a3429452df0) =

 =



platform   | arch   | lab           | compiler | defconfig                 =
   | regressions
-----------+--------+---------------+----------+---------------------------=
---+------------
d2500cc    | x86_64 | lab-clabbe    | gcc-8    | x86_64_defcon...6-chromebo=
ok | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb51412cdbb1e87311796a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
9-594-gdb2c2c1f4b16e/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabb=
e/baseline-d2500cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
9-594-gdb2c2c1f4b16e/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabb=
e/baseline-d2500cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb51412cdbb1e873117=
96b
        failing since 0 day (last pass: v5.10.49, first fail: v5.10.49-581-=
g85a3429452df0) =

 =



platform   | arch   | lab           | compiler | defconfig                 =
   | regressions
-----------+--------+---------------+----------+---------------------------=
---+------------
hip07-d05  | arm64  | lab-collabora | gcc-8    | defconfig                 =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb636ec598c4b76c117970

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
9-594-gdb2c2c1f4b16e/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
9-594-gdb2c2c1f4b16e/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb636ec598c4b76c117=
971
        failing since 10 days (last pass: v5.10.46-101-ga41d5119dc1e, first=
 fail: v5.10.47) =

 =



platform   | arch   | lab           | compiler | defconfig                 =
   | regressions
-----------+--------+---------------+----------+---------------------------=
---+------------
imx8mp-evk | arm64  | lab-nxp       | gcc-8    | defconfig                 =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb527b605d3c5a71117989

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
9-594-gdb2c2c1f4b16e/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
9-594-gdb2c2c1f4b16e/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb527b605d3c5a71117=
98a
        failing since 0 day (last pass: v5.10.48-7-g5b40bcb16853d, first fa=
il: v5.10.49) =

 =20
