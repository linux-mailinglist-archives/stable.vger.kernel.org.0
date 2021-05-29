Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C793394AD2
	for <lists+stable@lfdr.de>; Sat, 29 May 2021 08:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbhE2Gow (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 May 2021 02:44:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbhE2Gov (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 May 2021 02:44:51 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19995C061574
        for <stable@vger.kernel.org>; Fri, 28 May 2021 23:43:08 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id v14so4199102pgi.6
        for <stable@vger.kernel.org>; Fri, 28 May 2021 23:43:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/QCQqZA1GhXhlaK5QLjhBTkGwkuX9jmwJ8HOJN4CaVQ=;
        b=YZrCDdKG4ny1w7OtIPoaWVkgxVGbfxtGpPPH4SYKivtGAw4Qs+iXiMY3V0QdwJCMJM
         TGvFGStwzPz2LVINIdl1lzNArmMeQDRjbYQTq9+sAyVt/fV1r3ThUj/kMVxncxnzR7Sv
         JptK8/RxDxD/fLnQUwalSh3XLUEFz7/C1hYERuEge2uYCidQ5JwbkZ0JLAsmQVlk3Yw7
         I4FPm6WpheZqwmo+jyC4jr7ToVV+wa3LYA5euIPrViQDiVyEgUq9LVDA0NwK/tALnJl1
         Y0fqNMYVd1myTlqMZJmiKyrb97TzJv1eas/tbKugC5NHj7wHd7sa+P8s3YFXSbMk02Pl
         el3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/QCQqZA1GhXhlaK5QLjhBTkGwkuX9jmwJ8HOJN4CaVQ=;
        b=BmvhibInqSPFEbtX20W8H35/w71AAbTGL+x3tJxmbBkWx8cf2k1KEyW5h36L4VvG8/
         4+R0ahtuwqL2jQU228A1ym2yaGCoJQoVXyVAAGGdt+5yweDRkI4Bz34bY10GKu4AVjQ+
         JTBKrZ2HPZEfrfOs0sk67+7czBFezW8wqON+5+5PT9ao+tl2GdXyU9utp0ySJevlhm5C
         izXL11y4pefsojPG7KHzpLXSoBwp4f8qWbxXuJgOa66SRwRy1cxV56k0zrEJORm2RmxH
         N6L+bpjAnbAZRLh70meSbunUiwHHEfStOSLAdlbko6rNsXVVAvctKMdu2bDcNnTmNriJ
         mc1w==
X-Gm-Message-State: AOAM533L8fEomB7NlqtGYqIZJzgSgsZGvEKBco0vff7V8utMscT/4jyo
        eTLGUlavztvoJ8VKgmdiEKjD8QpmXce9z/D7
X-Google-Smtp-Source: ABdhPJwUMvjmM7Mic4ggNsBfXBS3ib0rMN+CIbUWYgKLCPTqaiPYAHd8u96gc53UeI5lbKcaJ8SwaA==
X-Received: by 2002:a63:1b09:: with SMTP id b9mr12632848pgb.354.1622270587295;
        Fri, 28 May 2021 23:43:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h12sm6225110pgn.54.2021.05.28.23.43.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 23:43:07 -0700 (PDT)
Message-ID: <60b1e27b.1c69fb81.127e6.54c2@mx.google.com>
Date:   Fri, 28 May 2021 23:43:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.12.8
X-Kernelci-Branch: linux-5.12.y
X-Kernelci-Report-Type: test
Subject: stable/linux-5.12.y baseline: 196 runs, 2 regressions (v5.12.8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.12.y baseline: 196 runs, 2 regressions (v5.12.8)

Regressions Summary
-------------------

platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig | =
1          =

imx8mp-evk         | arm64 | lab-nxp      | gcc-8    | defconfig         | =
1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.12.y/kernel=
/v5.12.8/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.12.y
  Describe: v5.12.8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      cfb3ea79045ad3c7bcaa0036b5a66609ccdadffe =



Test Regressions
---------------- =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/60b1a727896b2c5d96b3af97

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.12.y/v5.12.8/ar=
m/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.12.y/v5.12.8/ar=
m/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b1a727896b2c5d96b3a=
f98
        new failure (last pass: v5.12.7) =

 =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
imx8mp-evk         | arm64 | lab-nxp      | gcc-8    | defconfig         | =
1          =


  Details:     https://kernelci.org/test/plan/id/60b1a9c34bb78f4943b3afc2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.12.y/v5.12.8/ar=
m64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.12.y/v5.12.8/ar=
m64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b1a9c34bb78f4943b3a=
fc3
        new failure (last pass: v5.12.7) =

 =20
