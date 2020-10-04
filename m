Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02D23282B9B
	for <lists+stable@lfdr.de>; Sun,  4 Oct 2020 18:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725827AbgJDQAA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Oct 2020 12:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbgJDP77 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Oct 2020 11:59:59 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDF95C0613CE
        for <stable@vger.kernel.org>; Sun,  4 Oct 2020 08:59:59 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id u24so4146642pgi.1
        for <stable@vger.kernel.org>; Sun, 04 Oct 2020 08:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=CHouNJPjLvulTXKyAVDNwg0Kq2hhtlNt9yHsRS2gMDs=;
        b=weS5iAf9BzLeXe7v8rWl1wveHhs757LNwixNJf6YY7C3eHP0XvIIr9uOuWR5tm1yxx
         otrKWLGwTx4NV7Jxe/VmyqogLevqNKrBMmswYNsHQEP9T9lt4SjUvLOqaQAwHqmQtr91
         siUN7synr7qBDD7H1F6O/awakbpmr5+ot4kTGOYZAUF5eHCZLJRmQA7S2j3yPd4PdMOE
         1dEdk6zahp01oQvQv9OpLt+xdJEErHY+X4mP2PGKI1oaB+V8jrE3F3vWkvPv1j5PCj2v
         hMJjfoWET8tsFF1eN3jKQFZyoHJ0n1U/33Ut+eyh7lUOnjN3LBb5WUHJb7pYrGfkOWMj
         eN2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=CHouNJPjLvulTXKyAVDNwg0Kq2hhtlNt9yHsRS2gMDs=;
        b=EANhg2F3kB/T9uhEy8+aVcN3Ly4zwfkhvQi3QCdjaVBs7xz61g2hgJ9KjJ/M6Pnlog
         jzC2jnjgNz5m4NC0ADfkImVC2XIPEnh47y/LSHxLLU2JP/uuBBpR9rSZBkLxtDi/3bV/
         UVDQ9wBbAbe6B8mBotCEyot/xCifTaqDXdQl2nbPAI+UjhuYXH52+fEeXJSzE9DolPKn
         0Gdx9T+s2Eb0OGXRaWo7wpWl1aYm47isGueqOaEpsdt+WBQl681pin5QzigtRcK7CUjN
         aZqcffl3LvylWj4anoSqaQWG/5sGe4LZHHOM2D9SHEkEVQF97D5nt//RQeq7Ols99ru8
         efVg==
X-Gm-Message-State: AOAM533fttCsS8kCyPgVjiNcvjK0bLjtR3pCKKzRAJAWBWji8AwGHknj
        09J4Br9x8X2t04f5Zct5uG0CFc181V+6Qg==
X-Google-Smtp-Source: ABdhPJwMEbK+XW7neBK02HPYT+on99yq4NULynsXXH1MjCGCogcaIUnGNmQHxSddFHFcYnB9q8QZmQ==
X-Received: by 2002:a62:2581:0:b029:13f:ba38:b113 with SMTP id l123-20020a6225810000b029013fba38b113mr12227949pfl.15.1601827198795;
        Sun, 04 Oct 2020 08:59:58 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g129sm9081947pfb.9.2020.10.04.08.59.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2020 08:59:58 -0700 (PDT)
Message-ID: <5f79f17e.1c69fb81.bf0a9.293c@mx.google.com>
Date:   Sun, 04 Oct 2020 08:59:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.69-16-gde6f85667998
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 82 runs,
 4 regressions (v5.4.69-16-gde6f85667998)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 82 runs, 4 regressions (v5.4.69-16-gde6f85667=
998)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig | results
-----------------+-------+---------------+----------+-----------+--------
bcm2837-rpi-3-b  | arm64 | lab-baylibre  | gcc-8    | defconfig | 3/4    =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-8    | defconfig | 85/90  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.69-16-gde6f85667998/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.69-16-gde6f85667998
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      de6f856679987eab744eda3856e1b5af07547480 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig | results
-----------------+-------+---------------+----------+-----------+--------
bcm2837-rpi-3-b  | arm64 | lab-baylibre  | gcc-8    | defconfig | 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f79b6789142499e284ff3f0

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.69-16=
-gde6f85667998/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.69-16=
-gde6f85667998/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f79b6789142499e=
284ff3f4
      new failure (last pass: v5.4.69-3-gf31ade88ddd8)
      1 lines

    2020-10-04 11:46:06.007000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-10-04 11:46:06.007000  (user:khilman) is already connected
    2020-10-04 11:46:21.290000  =00
    2020-10-04 11:46:21.291000  =

    2020-10-04 11:46:21.291000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-10-04 11:46:21.291000  =

    2020-10-04 11:46:21.291000  DRAM:  948 MiB
    2020-10-04 11:46:21.306000  RPI 3 Model B (0xa02082)
    2020-10-04 11:46:21.393000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-10-04 11:46:21.425000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (375 line(s) more)
      =



platform         | arch  | lab           | compiler | defconfig | results
-----------------+-------+---------------+----------+-----------+--------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-8    | defconfig | 85/90  =


  Details:     https://kernelci.org/test/plan/id/5f79b6c1d95535d9f34ff401

  Results:     85 PASS, 5 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.69-16=
-gde6f85667998/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kevi=
n.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.69-16=
-gde6f85667998/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kevi=
n.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.bootrr.cros-ec-sensors-accel0-probed: https://kernelci.org/tes=
t/case/id/5f79b6c1d95535d9f34ff415
      failing since 4 days (last pass: v5.4.68-384-g856fa448539c, first fai=
l: v5.4.68-388-gcf92ab7a7853)

    2020-10-04 11:49:12.561000  /lava-2688290/1/../bin/lava-test-case
     * baseline.bootrr.cros-ec-sensors-accel1-probed: https://kernelci.org/=
test/case/id/5f79b6c1d95535d9f34ff416
      failing since 4 days (last pass: v5.4.68-384-g856fa448539c, first fai=
l: v5.4.68-388-gcf92ab7a7853)

    2020-10-04 11:49:13.582000  /lava-2688290/1/../bin/lava-test-case
     * baseline.bootrr.cros-ec-sensors-gyro0-probed: https://kernelci.org/t=
est/case/id/5f79b6c1d95535d9f34ff417
      failing since 4 days (last pass: v5.4.68-384-g856fa448539c, first fai=
l: v5.4.68-388-gcf92ab7a7853)

    2020-10-04 11:49:14.604000  /lava-2688290/1/../bin/lava-test-case
    2020-10-04 11:49:14.613000  <8>[   24.943331] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-gyro0-probed RESULT=3Dfail>
      =20
